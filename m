Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753293AbZCPLW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:22:29 -0400
Date: Mon, 16 Mar 2009 12:22:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pxa_camera: Redesign DMA handling
In-Reply-To: <1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0903161153200.4409@axis700.grange>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009, Robert Jarzmik wrote:

> The DMA transfers in pxa_camera showed some weaknesses in
> multiple queued buffers context :
>  - poll/select problem
>    The bug shows up with capture_example tool from v4l2 hg
>    tree. The process just "stalls" on a "select timeout".
> 
>  - multiple buffers DMA starting
>    When multiple buffers were queued, the DMA channels were
>    always started right away. This is not optimal, as a
>    special case appears when the first EOF was not yet
>    reached, and the DMA channels were prematurely started.
> 
>  - Maintainability
>    DMA code was a bit obfuscated. Rationalize the code to be
>    easily maintainable by anyone.
> 
>  - DMA hot chaining
>    DMA is not stopped anymore to queue a buffer, the buffer
>    is queued with DMA running. As a tribute, a corner case
>    exists where chaining happens while DMA finishes the
>    chain, and the capture is restarted to deal with the
>    missed link buffer.
> 
> This patch attemps to address these issues / improvements.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  Documentation/video4linux/pxa_camera.txt |  125 ++++++++++++
>  drivers/media/video/pxa_camera.c         |  317 ++++++++++++++++++------------
>  2 files changed, 315 insertions(+), 127 deletions(-)
>  create mode 100644 Documentation/video4linux/pxa_camera.txt
> 
> diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/video4linux/pxa_camera.txt
> new file mode 100644
> index 0000000..2c68c1d
> --- /dev/null
> +++ b/Documentation/video4linux/pxa_camera.txt
> @@ -0,0 +1,125 @@
> +                              PXA-Camera Host Driver
> +                              ======================
> +
> +Constraints
> +-----------
> +  a) Image size for YUV422P format
> +     All YUV422P images are enforced to have width x height % 16 = 0.
> +     This is due to DMA constraints, which transfers only planes of 8 byte
> +     multiples.
> +
> +
> +Global video workflow
> +---------------------
> +  a) QIF stopped

What is QIF? Do you mean Quick Capture Interface - QCI? I also see CIF 
used in the datasheet, probably, for "Capture InterFace," but I don't see 
QIF anywhere. Also, please explain the first time you use the 
abbreviation. Also fix it in the commit message to patch 1/4.

> +     Initialy, the QIF interface is stopped.
> +     When a buffer is queued (pxa_videobuf_ops->buf_queue), the QIF starts.
> +
> +  b) QIF started
> +     More buffers can be queued while the QIF is started without halting the
> +     capture.  The new buffers are "appended" at the tail of the DMA chain, and
> +     smoothly captured one frame after the other.
> +
> +     Once a buffer is filled in the the QIF interface, it is marked as "DONE"

duplicate "the."

> +     and removed from the active buffers list. It can be then requeud or
> +     dequeued by userland application.
> +
> +     Once the last buffer is filled in, the QIF interface stops.
> +
> +
> +DMA usage
> +---------
> +  a) DMA flow
> +     - first buffer queued for capture
> +       Once a first buffer is queued for capture, the QIF is started, but data
> +       transfer is not started. On "End Of Frame" interrupt, the irq handler
> +       starts the DMA chain.
> +     - capture of one videobuffer
> +       The DMA chain starts transfering data into videobuffer RAM pages.
> +       When all pages are transfered, the DMA irq is raised on "ENDINTR" status
> +     - finishing one videobuffer
> +       The DMA irq handler marks the videobuffer as "done", and removes it from
> +       the active running queue
> +       Meanwhile, the next videobuffer (if there is one), is transfered by DMA
> +     - finishing the last videobuffer
> +       On the DMA irq of the last videobuffer, the QIF is stopped.
> +
> +  b) DMA prepared buffer will have this structure
> +
> +     +------------+-----+---------------+-----------------+
> +     | desc-sg[0] | ... | desc-sg[last] | finisher/linker |
> +     +------------+-----+---------------+-----------------+
> +
> +     This structure is pointed by dma->sg_cpu.
> +     The descriptors are used as follows :
> +      - desc-sg[i]: i-th descriptor, transfering the i-th sg
> +        element to the video buffer scatter gather
> +      - finisher: has ddadr=DADDR_STOP, dcmd=ENDIRQEN
> +      - linker: has ddadr= desc-sg[0] of next video buffer, dcmd=0
> +
> +     For the next schema, let's assume d0=desc-sg[0] .. dN=desc-sg[N],
> +     "f" stands for finisher and "l" for linker.
> +     A typical running chain is :
> +
> +         Videobuffer 1         Videobuffer 2
> +     +---------+----+---+  +----+----+----+---+
> +     | d0 | .. | dN | l |  | d0 | .. | dN | f |
> +     +---------+----+-|-+  ^----+----+----+---+
> +                      |    |
> +                      +----+
> +
> +     After the chaining is finished, the chain looks like :
> +
> +         Videobuffer 1         Videobuffer 2         Videobuffer 3
> +     +---------+----+---+  +----+----+----+---+  +----+----+----+---+
> +     | d0 | .. | dN | l |  | d0 | .. | dN | l |  | d0 | .. | dN | f |
> +     +---------+----+-|-+  ^----+----+----+-|-+  ^----+----+----+---+
> +                      |    |                |    |
> +                      +----+                +----+
> +                                           new_link
> +
> +  c) DMA hot chaining timeslice issue
> +
> +     As DMA chaining is done while DMA _is_ running, the linking may be done
> +     while the DMA jumps from one Videobuffer to another. On the schema, that
> +     would be a problem if the following sequence is encountered :
> +
> +      - DMA chain is Videobuffer1 + Videobuffer2
> +      - pxa_videobuf_queue() is called to queue Videobuffer3
> +      - DMA controller finishes Videobuffer2, and DMA stops
> +      =>
> +         Videobuffer 1         Videobuffer 2
> +     +---------+----+---+  +----+----+----+---+
> +     | d0 | .. | dN | l |  | d0 | .. | dN | f |
> +     +---------+----+-|-+  ^----+----+----+-^-+
> +                      |    |                |
> +                      +----+                +-- DMA DDADR loads DDADR_STOP
> +
> +      - pxa_dma_add_tail_buf() is called, the Videobuffer2 "finisher" is
> +        replaced by a "linker" to Videobuffer3 (creation of new_link)
> +      - pxa_videobuf_queue() finishes
> +      - the DMA irq handler is called, which terminates Videobuffer2
> +      - Videobuffer3 capture is not scheduled on DMA chain (as it stopped !!!)
> +
> +         Videobuffer 1         Videobuffer 2         Videobuffer 3
> +     +---------+----+---+  +----+----+----+---+  +----+----+----+---+
> +     | d0 | .. | dN | l |  | d0 | .. | dN | l |  | d0 | .. | dN | f |
> +     +---------+----+-|-+  ^----+----+----+-|-+  ^----+----+----+---+
> +                      |    |                |    |
> +                      +----+                +----+
> +                                           new_link
> +                                          DMA DDADR still is DDADR_STOP
> +
> +      - pxa_camera_check_link_miss() is called
> +        This checks if the DMA is finished and a buffer is still on the
> +        pcdev->capture list. If that's the case, the capture will be restarted,
> +        and Videobuffer3 is scheduled on DMA chain.
> +      - the DMA irq handler finishes
> +
> +     Note: if DMA stops just after pxa_camera_check_link_miss() reads DDADR()
> +     value, we have the guarantee that the DMA irq handler will be called back
> +     when the DMA will finish the buffer, and pxa_camer_check_link_miss() will

pxa_camerA_check_link_miss - an "a" is missing

> +     be called again, to reschedule Videobuffer3.
> +
> +--
> +Author: Robert Jarzmik <robert.jarzmik@free.fr>
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index aca5374..a0ca982 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -324,7 +324,7 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>   * Prepares the pxa dma descriptors to transfer one camera channel.
>   * Beware sg_first and sg_first_ofs are both input and output parameters.
>   *
> - * Returns 0
> + * Returns 0 or -ENOMEM if no coherent memory is available

As mentioned before, put in the previous patch.

>   */
>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  				struct pxa_buffer *buf,
> @@ -369,6 +369,10 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
>  		pxa_dma->sg_cpu[i].dcmd =
>  			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
> +#ifdef DEBUG
> +		if (!i)
> +			pxa_dma->sg_cpu[i].dcmd |= DCMD_STARTIRQEN;
> +#endif
>  		pxa_dma->sg_cpu[i].ddadr =
>  			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
>  
> @@ -402,6 +406,20 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  	return 0;
>  }
>  
> +static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
> +				    struct pxa_buffer *buf)
> +{
> +	buf->active_dma = DMA_Y;
> +	if (pcdev->channels == 3)
> +		buf->active_dma |= DMA_U | DMA_V;
> +}
> +
> +/*
> + * Please check the DMA prepared buffer structure in :
> + *   Documentation/video4linux/pxa_camera.txt
> + * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
> + * modification while DMA chain is running will work anyway.
> + */
>  static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  		struct videobuf_buffer *vb, enum v4l2_field field)
>  {
> @@ -498,9 +516,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	}
>  
>  	buf->inwork = 0;
> -	buf->active_dma = DMA_Y;
> -	if (pcdev->channels == 3)
> -		buf->active_dma |= DMA_U | DMA_V;
> +	pxa_videobuf_set_actdma(pcdev, buf);
>  
>  	return 0;
>  
> @@ -517,6 +533,99 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * pxa_dma_start_channels - start DMA channel for active buffer
> + * @pcdev: pxa camera device
> + *
> + * Initialize DMA channels to the beginning of the active video buffer, and
> + * start these channels.
> + */
> +static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
> +{
> +	int i;
> +	struct pxa_buffer *active;
> +
> +	active = pcdev->active;
> +
> +	for (i = 0; i < pcdev->channels; i++) {
> +		dev_dbg(pcdev->dev, "%s (channel=%d) ddadr=%08x\n", __func__,
> +			i, active->dmas[i].sg_dma);
> +		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
> +		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> +	}
> +}
> +
> +static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
> +{
> +	int i;
> +
> +	for (i = 0; i < pcdev->channels; i++) {
> +		dev_dbg(pcdev->dev, "%s (channel=%d)\n", __func__, i);
> +		DCSR(pcdev->dma_chans[i]) = 0;
> +	}
> +}
> +
> +static void pxa_dma_update_sg_tail(struct pxa_camera_dev *pcdev,
> +				   struct pxa_buffer *buf)
> +{
> +	int i;
> +
> +	for (i = 0; i < pcdev->channels; i++)
> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
> +}
> +
> +static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
> +				 struct pxa_buffer *buf)
> +{
> +	int i;
> +	struct pxa_dma_desc *buf_last_desc;
> +
> +	for (i = 0; i < pcdev->channels; i++) {
> +		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
> +		buf_last_desc->ddadr = DDADR_STOP;
> +
> +		if (!pcdev->sg_tail[i])
> +			continue;
> +		pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
> +	}
> +
> +	pxa_dma_update_sg_tail(pcdev, buf);

pxa_dma_update_sg_tail is called only here, why not inline it and also put 
inside one loop?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
