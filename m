Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BFSda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 13:33:30 -0500
Date: Mon, 6 Feb 2012 19:33:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v3 3/4] media i.MX27 camera: improve discard buffer
 handling.
In-Reply-To: <1327925653-13310-3-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1202061907020.10363@axis700.grange>
References: <1327925653-13310-1-git-send-email-javier.martin@vista-silicon.com>
 <1327925653-13310-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

Thanks for the update! Let's see, whether this one can be improved a bit 
more.

On Mon, 30 Jan 2012, Javier Martin wrote:

> The way discard buffer was previously handled lead
> to possible races that made a buffer that was not
> yet ready to be overwritten by new video data. This
> is easily detected at 25fps just adding "#define DEBUG"
> to enable the "memset" check and seeing how the image
> is corrupted.
> 
> A new "discard" queue and two discard buffers have
> been added to make them flow trough the pipeline
> of queues and thus provide suitable event ordering.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Changes since v2:
>  - Remove BUG_ON when active list is empty.
>  - Replace empty list checks with warnings.

I think, the best would be to warn and bail out, instead of implicitly 
crashing.

> 
> ---
>  drivers/media/video/mx2_camera.c |  280 +++++++++++++++++++++-----------------
>  1 files changed, 153 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 35ab971..e7ccd97 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c

[snip]

> @@ -706,8 +806,9 @@ static int mx2_stop_streaming(struct vb2_queue *q)
>  	unsigned long flags;
>  	u32 cntl;
>  
> -	spin_lock_irqsave(&pcdev->lock, flags);
>  	if (mx27_camera_emma(pcdev)) {
> +		spin_lock_irqsave(&pcdev->lock, flags);
> +
>  		cntl = readl(pcdev->base_emma + PRP_CNTL);
>  		if (prp->cfg.channel == 1) {
>  			writel(cntl & ~PRP_CNTL_CH1EN,
> @@ -716,8 +817,18 @@ static int mx2_stop_streaming(struct vb2_queue *q)
>  			writel(cntl & ~PRP_CNTL_CH2EN,
>  			       pcdev->base_emma + PRP_CNTL);
>  		}
> +		INIT_LIST_HEAD(&pcdev->capture);
> +		INIT_LIST_HEAD(&pcdev->active_bufs);
> +		INIT_LIST_HEAD(&pcdev->discard);
> +
> +		spin_unlock_irqrestore(&pcdev->lock, flags);
> +
> +		dma_free_coherent(ici->v4l2_dev.dev,
> +			pcdev->discard_size, pcdev->discard_buffer,
> +			pcdev->discard_buffer_dma);
> +		pcdev->discard_buffer = NULL;

AFAICS, the IRQ handler runs without taking any locks, so, there's a 
theoretical SMP race here with using the discard buffers from the ISR. So, 
I think, you'd have to add some locking to the ISR and here do something 
like

+		x = pcdev->discard_buffer;
+		pcdev->discard_buffer = NULL;
+
+		spin_unlock_irqrestore(&pcdev->lock, flags);
+
+		dma_free_coherent(ici->v4l2_dev.dev,
+			pcdev->discard_size, x,
+			pcdev->discard_buffer_dma);


>  	}
> -	spin_unlock_irqrestore(&pcdev->lock, flags);
> +

You're adding an empty line here.

>  
>  	return 0;
>  }

[snip]

> @@ -1179,18 +1212,23 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
>  static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		int bufnum)
>  {

This function is called from the ISR, so, I presume, you'll have to 
spin_lock() somewhere here.

> -	u32 imgsize = pcdev->icd->user_height * pcdev->icd->user_width;
>  	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>  	struct mx2_buffer *buf;
>  	struct vb2_buffer *vb;
>  	unsigned long phys;
>  
> -	if (!list_empty(&pcdev->active_bufs)) {
> -		buf = list_entry(pcdev->active_bufs.next,
> -			struct mx2_buffer, queue);
> +	buf = list_entry(pcdev->active_bufs.next,
> +			 struct mx2_buffer, queue);
>  
> -		BUG_ON(buf->bufnum != bufnum);
> +	BUG_ON(buf->bufnum != bufnum);
>  
> +	if (buf->discard) {
> +		/*
> +		 * Discard buffer must not be returned to user space.
> +		 * Just return it to the discard queue.
> +		 */
> +		list_move_tail(pcdev->active_bufs.next, &pcdev->discard);
> +	} else {
>  		vb = &buf->vb;
>  #ifdef DEBUG
>  		phys = vb2_dma_contig_plane_dma_addr(vb, 0);
> @@ -1212,6 +1250,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  			}
>  		}
>  #endif
> +
>  		dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%p %lu\n", __func__, vb,
>  				vb2_plane_vaddr(vb, 0),
>  				vb2_get_plane_payload(vb, 0));
> @@ -1225,29 +1264,23 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  	pcdev->frame_count++;
>  
>  	if (list_empty(&pcdev->capture)) {
> -		if (prp->cfg.channel == 1) {
> -			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
> -					PRP_DEST_RGB1_PTR + 4 * bufnum);
> -		} else {
> -			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
> -						PRP_DEST_Y_PTR -
> -						0x14 * bufnum);
> -			if (prp->out_fmt == V4L2_PIX_FMT_YUV420) {
> -				writel(pcdev->discard_buffer_dma + imgsize,
> -				       pcdev->base_emma + PRP_DEST_CB_PTR -
> -				       0x14 * bufnum);
> -				writel(pcdev->discard_buffer_dma +
> -				       ((5 * imgsize) / 4), pcdev->base_emma +
> -				       PRP_DEST_CR_PTR - 0x14 * bufnum);
> -			}
> -		}
> +		if (list_empty(&pcdev->discard))
> +			dev_warn(pcdev->dev, "%s: trying to access empty discard list\n",
> +				 __func__);

It is good, that you check for this error, but

> +
> +		buf = list_entry(pcdev->discard.next,
> +			struct mx2_buffer, queue);
> +		buf->bufnum = bufnum;
> +
> +		list_move_tail(pcdev->discard.next, &pcdev->active_bufs);
> +		mx27_update_emma_buf(pcdev, pcdev->discard_buffer_dma, bufnum);

here even in the above error case you continue to access the invalid list 
entry... 

>  		return;
>  	}
>  
>  	buf = list_entry(pcdev->capture.next,
>  			struct mx2_buffer, queue);
>  
> -	buf->bufnum = !bufnum;
> +	buf->bufnum = bufnum;
>  
>  	list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
>  
> @@ -1255,18 +1288,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  	buf->state = MX2_STATE_ACTIVE;
>  
>  	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
> -	if (prp->cfg.channel == 1) {
> -		writel(phys, pcdev->base_emma + PRP_DEST_RGB1_PTR + 4 * bufnum);
> -	} else {
> -		writel(phys, pcdev->base_emma +
> -				PRP_DEST_Y_PTR - 0x14 * bufnum);
> -		if (prp->cfg.out_fmt == PRP_CNTL_CH2_OUT_YUV420) {
> -			writel(phys + imgsize, pcdev->base_emma +
> -					PRP_DEST_CB_PTR - 0x14 * bufnum);
> -			writel(phys + ((5 * imgsize) / 4), pcdev->base_emma +
> -					PRP_DEST_CR_PTR - 0x14 * bufnum);
> -		}
> -	}
> +	mx27_update_emma_buf(pcdev, phys, bufnum);
>  }
>  
>  static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
> @@ -1275,6 +1297,10 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>  	unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
>  	struct mx2_buffer *buf;
>  
> +	if (list_empty(&pcdev->active_bufs))
> +		dev_warn(pcdev->dev, "%s: called while active list is empty\n",
> +			__func__);
> +

Similarly here: if this is a possible condition, shouldn't you nicely bail 
out here? Of course, interrupts have to be acked still.

>  	if (status & (1 << 7)) { /* overflow */
>  		u32 cntl;
>  		/*

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
