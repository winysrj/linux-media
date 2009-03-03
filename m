Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54170 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751945AbZCCPtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 10:49:42 -0500
Date: Tue, 3 Mar 2009 16:49:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
In-Reply-To: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0903030929160.5059@axis700.grange>
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moved to the new v4l list)

Nice! A couple of questions / remarks though.

On Mon, 2 Mar 2009, Robert Jarzmik wrote:

> The DMA transfers in pxa_camera showed some weaknesses in
> multiple queued buffers context :
>  - poll/select problem
>    The order between list pcdev->capture and DMA chain was
>    not the same. This creates a discrepancy between video
>    buffers marked as "done" by the IRQ handler, and the
>    really finished video buffer.

Could you please describe where and how the order could get wrong?

>  - multiple buffers DMA starting
>    When multiple buffers were queued, the DMA channels were

You mean multiple scatter-gather elements?

>    always started right away. This is not optimal, as a
>    special case appears when the first EOM was not yet
>    reached, and the DMA channels were prematurely started.

What is EOM? I see End of Line, End of Frame, End of Active Video, End of 
Transfer. I only see End of Message on the PXA MSL interface, which 
doesn't seem to be related. TBH, I do not quite understand what you mean 
here. What do we have to wait for before starting DMA channels?

Ok, after working through the whole patch, I think, you meant starting DMA 
in the middle of a frame and thus getting an incomplete frame, which you 
changed using the capture (not DMA) End of Frame interrupt, right?

>  - YUV planar formats hole
>    All planes were PAGE aligned (ie. 4096 bytes
>    aligned). This is not consistent with YUV422 format,
>    which requires Y, U and V planes glued together.
>    The new implementation forces the alignement on 8 bytes
>    (DMA requirement), which is almost always the case
>    (granted by width x height being a multiple of 8).

Then we shall adjust frame sizes to produce a multiple of 8.

>  - Maintainability
>    DMA code was a bit ofsuscated. Rationalize the code to be

s/ofsuscated/obfuscated/:-)

>    easily maintainable by anyone.

Nice. Well, you'd really do me a favour, if you could split it at least 
into two patches: maintainability improvements (split out functions, 
whatever else), and then fixes. Splitting off planar alignment fix should 
also be pretty straightforward, especially worth splitting off, when you 
add size rounding up. Mike suggested another split, you may decide which 
one you hold for more meaningful, or maybe both.

> This patch attemps to address these issues.
> 
> The test cases include tests in both YUV422 and RGB565 :
>  - a picture of size 111 x 111 (cross RAM pages example)
>  - a picture of size 1023 x 4 in (under 1 RAM page)
>  - a picture of size 1024 x 4 in (exactly 1 RAM page)
>  - a picture of size 1025 x 4 in (over 1 RAM page)
>  - a picture of size 1280 x 1024 (many RAM pages)

What exactly was the problem before your patch? How do I reproduce it? I 
guess, it should also be visible with monochrome or Bayer formats.

> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |  400 +++++++++++++++++++++++---------------
>  1 files changed, 243 insertions(+), 157 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index e3e6b29..ccedfaf 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -243,12 +243,12 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>  
>  	/* planar capture requires Y, U and V buffers to be page aligned */
>  	if (pcdev->channels == 3) {
> -		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
> +		*size = roundup(icd->width * icd->height, 8); /* Y pages */
> +		*size += roundup(icd->width * icd->height / 2, 8); /* U pages */
> +		*size += roundup(icd->width * icd->height / 2, 8); /* V pages */

Every time I see code like

	x = u;
	x += v;
	x += w;
	...

or

	x = u;
	x |= v;
	...

makes me wonder why not just write

	x = u +		/* need u */
	    v +		/* and v */
	    w;		/* and w */

This way you explicitly tell the compiler you don't need intermediate 
values and it can perform any optimisations it likes. I actually looked at 
assembly code - the compiler does save intermediate values each time in 
*size - as in case above, which involves a pointer dereference... I think, 
would be cleaner to chain additions as suggested above.

>  	} else {
> -		*size = icd->width * icd->height *
> -			((icd->current_fmt->depth + 7) >> 3);
> +		*size = roundup(icd->width * icd->height *
> +				((icd->current_fmt->depth + 7) >> 3), 8);
>  	}
>  
>  	if (0 == *count)
> @@ -289,19 +289,58 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>  }
>  
> +static int calculate_dma_sglen(struct scatterlist *sg, int sg_first,
> +			       int sg_first_ofs, int size)
> +{
> +	int sg_i, offset;
> +	int dma_len, xfer_len;
> +
> +	offset = sg_first_ofs;
> +	for (sg_i = sg_first; size > 0; sg_i++) {
> +		dma_len = sg_dma_len(&sg[sg_i]);

I think, you should not use direct access into an sg-list. Please, pass 
not an index into the array, but a pointer to an sg-element, and use 
sg_next() to walk to the next one. This way instead of passing beginning 
of the list and index, you just pass a pointer to the current element.

You should be fine with your size calculations, but I would still test 
against dma->sglen to make sure we don't access beyond the array.

> +
> +		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> +		xfer_len = roundup(min(dma_len - offset, size), 8);

I think it is too late to round up here. You should adjust window sizes in 
pxa_camera_set_fmt() so, that your Y, U, and V buffer sizes are a multiple 
of 8, at least for the V4L2_PIX_FMT_YUV422P case.

...and pxa_camera_set_crop() is just plain broken (when capture is 
running). You might want to fix that just as well. However, after all 
problems I had with S_CROP in mx3_camera, I'm asking myself if it makes 
any sense at all to crop during a running capture to a different window 
size?...

> +		size -= xfer_len;
> +		offset = 0;
> +	}
> +
> +	return sg_i - sg_first;
> +}
> +
> +/**
> + * pxa_init_dma_channel - init dma descriptors
> + * @pcdev: pxa camera device
> + * @buf: pxa buffer to find pxa dma channel
> + * @dma: dma video buffer
> + * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
> + * @cibr: camera read fifo
> + * @size: bytes to transfer
> + * @sg_first: index of first element of sg_list
> + * @sg_first_ofs: offset in first element of sg_list
> + *
> + * Prepares the pxa dma descriptors to transfer one camera channel.
> + * Beware sg_first and sg_first_ofs are both input and output parameters.
> + *
> + * Returns 0

... or error, e.g., -ENOMEM

> + */
>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  				struct pxa_buffer *buf,
>  				struct videobuf_dmabuf *dma, int channel,
> -				int sglen, int sg_start, int cibr,
> -				unsigned int size)
> +				int cibr, int size,
> +				int *sg_first, int *sg_first_ofs)
>  {
>  	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
> -	int i;
> +	struct scatterlist *sg = dma->sglist;
> +	int i, offset, sg_i, sglen;
> +	int dma_len = 0, xfer_len = 0;
>  
>  	if (pxa_dma->sg_cpu)
>  		dma_free_coherent(pcdev->dev, pxa_dma->sg_size,
>  				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
>  
> +	sglen = calculate_dma_sglen(sg, *sg_first, *sg_first_ofs, size);
> +
>  	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
>  	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
>  					     &pxa_dma->sg_dma, GFP_KERNEL);
> @@ -309,27 +348,51 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  		return -ENOMEM;
>  
>  	pxa_dma->sglen = sglen;
> +	offset = *sg_first_ofs;
> +
> +	dev_dbg(pcdev->dev, "DMA: sg_first=%d, sglen=%d, ofs=%d, dma.desc=%x\n",
> +		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
>  
> -	for (i = 0; i < sglen; i++) {
> -		int sg_i = sg_start + i;
> -		struct scatterlist *sg = dma->sglist;
> -		unsigned int dma_len = sg_dma_len(&sg[sg_i]), xfer_len;
> +	for (i = 0; size > 0; i++) {
> +		sg_i = *sg_first + i;
> +		dma_len = sg_dma_len(&sg[sg_i]);

Same here - please, fiix sg-list indexing. Yes, I see it was like this 
before, but I think it was wrong.

>  
>  		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
> -		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]);
> +		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]) + offset;

...and more

>  
>  		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> -		xfer_len = (min(dma_len, size) + 7) & ~7;
> +		xfer_len = roundup(min(dma_len - offset, size), 8);

Again, too late to align.

>  
>  		pxa_dma->sg_cpu[i].dcmd =
> -			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
> -		size -= dma_len;
> +			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len
> +			| ((i == 0) ? DCMD_STARTIRQEN : 0);

Why do you need the start interrupt? You don't seem to be doing anything 
useful in it. If you preserve it, can you please change this and other 
occurrences of

	x = y
		| z;

to

	x = y |
		z;

just to make consistent with the rest of the driver.

> +		size -= xfer_len;
>  		pxa_dma->sg_cpu[i].ddadr =
>  			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
> +
> +		dev_vdbg(pcdev->dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
> +			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
> +			 sg_dma_address(&sg[sg_i]) + offset, xfer_len);
> +		offset = 0;
>  	}
>  
> -	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
> -	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
> +	pxa_dma->sg_cpu[i].ddadr = DDADR_STOP;
> +	pxa_dma->sg_cpu[i].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
> +
> +	*sg_first_ofs = xfer_len;
> +	*sg_first = *sg_first + i;
> +
> +	/*
> +	 * Handle 2 special cases :
> +	 *  - if we finish the DMA transfer in the middle of a RAM page
> +	 *  - if we finish the DMA transfer in the last 7 bytes of a RAM page
> +	 */
> +	if (*sg_first_ofs != 0)
> +		*sg_first -= 1;
> +	if (*sg_first_ofs >= dma_len) {
> +		*sg_first_ofs -= dma_len;
> +		*sg_first += 1;
> +	}

This whole calculation looks suspicious. But I won't verify it now, 
because it anyway will change as you switch to sg-pointers instead of 
indices, but, please, keep in mind to double-check this.

>  
>  	return 0;
>  }
> @@ -342,8 +405,8 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>  	int ret;
> -	int sglen_y,  sglen_yu = 0, sglen_u = 0, sglen_v = 0;
> -	int size_y, size_u = 0, size_v = 0;
> +	int sg_next = 0, next_ofs = 0;
> +	int size_y = 0, size_u = 0, size_v = 0;
>  
>  	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>  		vb, vb->baddr, vb->bsize);
> @@ -381,53 +444,50 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	}
>  
>  	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> -		unsigned int size = vb->size;
> +		int size = vb->size;

Why this change? I don't see any need for it.

>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
>  
>  		ret = videobuf_iolock(vq, vb, NULL);
>  		if (ret)
>  			goto fail;
>  
> -		if (pcdev->channels == 3) {
> -			/* FIXME the calculations should be more precise */
> -			sglen_y = dma->sglen / 2;
> -			sglen_u = sglen_v = dma->sglen / 4 + 1;
> -			sglen_yu = sglen_y + sglen_u;
> +		switch (pcdev->channels) {
> +		case 1:
> +			size_y = size;
> +			break;
> +		case 3:
>  			size_y = size / 2;
>  			size_u = size_v = size / 4;
> -		} else {
> -			sglen_y = dma->sglen;
> -			size_y = size;
> +			break;
>  		}

Here you changed an "if" to a "switch," later on you do an "if (channels 
== 3)" again. Please, choose one. I think, since we only have two 
possibilities, and since it has already been implemented that way, we can 
leave it with "if"s.

>  
>  		/* init DMA for Y channel */
> -		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, sglen_y,
> -					   0, 0x28, size_y);
> -
> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
> +					   &sg_next, &next_ofs);

These calls will change parameters

>  		if (ret) {
>  			dev_err(pcdev->dev,
>  				"DMA initialization for Y/RGB failed\n");
>  			goto fail;
>  		}
>  
> -		if (pcdev->channels == 3) {
> -			/* init DMA for U channel */
> -			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_u,
> -						   sglen_y, 0x30, size_u);
> -			if (ret) {
> -				dev_err(pcdev->dev,
> -					"DMA initialization for U failed\n");
> -				goto fail_u;
> -			}
> -
> -			/* init DMA for V channel */
> -			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, sglen_v,
> -						   sglen_yu, 0x38, size_v);
> -			if (ret) {
> -				dev_err(pcdev->dev,
> -					"DMA initialization for V failed\n");
> -				goto fail_v;
> -			}
> +		/* init DMA for U channel */
> +		if (size_u)
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
> +						   size_u, &sg_next, &next_ofs);
> +		if (ret) {
> +			dev_err(pcdev->dev,
> +				"DMA initialization for U failed\n");
> +			goto fail_u;
> +		}
> +
> +		/* init DMA for V channel */
> +		if (size_v)
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
> +						   size_u, &sg_next, &next_ofs);
> +		if (ret) {
> +			dev_err(pcdev->dev,
> +				"DMA initialization for V failed\n");
> +			goto fail_v;
>  		}
>  
>  		vb->state = VIDEOBUF_PREPARED;
> @@ -453,6 +513,97 @@ out:
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
> +	for (i = 0; i < pcdev->channels; i++) {
> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
> +		pcdev->sg_tail[i]->ddadr = DDADR_STOP;
> +	}
> +}
> +
> +static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
> +				 struct pxa_buffer *buf)
> +{
> +	int i;
> +
> +	for (i = 0; i < pcdev->channels; i++) {
> +		if (!pcdev->sg_tail[i])
> +			continue;
> +		pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
> +	}
> +
> +	pxa_dma_update_sg_tail(pcdev, buf);
> +}
> +
> +/**
> + * pxa_camera_start_capture - start video capturing
> + * @pcdev: camera device
> + *
> + * Launch capturing. DMA channels should not be active yet. They should get
> + * activated at the end of frame interrupt, to capture only whole frames, and
> + * never begin the capture of a partial frame.

I like this!

> + */
> +static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
> +{
> +	unsigned long cicr0, cifr;
> +
> +	dev_dbg(pcdev->dev, "%s\n", __func__);
> +	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> +	__raw_writel(cifr, pcdev->base + CIFR);
> +
> +	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB | CISR_IFO_0
> +		| CISR_IFO_1 | CISR_IFO_2;
> +	cicr0 &= ~CICR0_EOFM;
> +	__raw_writel(cicr0, pcdev->base + CICR0);
> +}
> +
> +static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
> +{
> +	unsigned long cicr0;
> +
> +	pxa_dma_stop_channels(pcdev);
> +
> +	cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
> +	__raw_writel(cicr0, pcdev->base + CICR0);
> +
> +	dev_dbg(pcdev->dev, "%s\n", __func__);
> +}
> +
>  static void pxa_videobuf_queue(struct videobuf_queue *vq,
>  			       struct videobuf_buffer *vb)
>  {
> @@ -462,10 +613,9 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>  	struct pxa_buffer *active;
>  	unsigned long flags;
> -	int i;
>  
> -	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d active=%p\n", __func__,
> +		vb, vb->baddr, vb->bsize, pcdev->active);
>  	spin_lock_irqsave(&pcdev->lock, flags);
>  
>  	list_add_tail(&vb->queue, &pcdev->capture);
> @@ -473,68 +623,14 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
>  	vb->state = VIDEOBUF_ACTIVE;
>  	active = pcdev->active;
>  
> -	if (!active) {
> -		unsigned long cifr, cicr0;
> +	pxa_dma_stop_channels(pcdev);
>  
> -		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> -		__raw_writel(cifr, pcdev->base + CIFR);
> +	pxa_dma_add_tail_buf(pcdev, buf);

Do you really have to call pxa_dma_stop_channels() if (!active)? Looks 
like after your modifications DMA is not running yet anyway.

>  
> -		for (i = 0; i < pcdev->channels; i++) {
> -			DDADR(pcdev->dma_chans[i]) = buf->dmas[i].sg_dma;
> -			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> -			pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen - 1;
> -		}
> -
> -		pcdev->active = buf;
> -
> -		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
> -		__raw_writel(cicr0, pcdev->base + CICR0);
> -	} else {
> -		struct pxa_cam_dma *buf_dma;
> -		struct pxa_cam_dma *act_dma;
> -		int nents;
> -
> -		for (i = 0; i < pcdev->channels; i++) {
> -			buf_dma = &buf->dmas[i];
> -			act_dma = &active->dmas[i];
> -			nents = buf_dma->sglen;
> -
> -			/* Stop DMA engine */
> -			DCSR(pcdev->dma_chans[i]) = 0;
> -
> -			/* Add the descriptors we just initialized to
> -			   the currently running chain */
> -			pcdev->sg_tail[i]->ddadr = buf_dma->sg_dma;
> -			pcdev->sg_tail[i] = buf_dma->sg_cpu + buf_dma->sglen - 1;
> -
> -			/* Setup a dummy descriptor with the DMA engines current
> -			 * state
> -			 */
> -			buf_dma->sg_cpu[nents].dsadr =
> -				pcdev->res->start + 0x28 + i*8; /* CIBRx */
> -			buf_dma->sg_cpu[nents].dtadr =
> -				DTADR(pcdev->dma_chans[i]);
> -			buf_dma->sg_cpu[nents].dcmd =
> -				DCMD(pcdev->dma_chans[i]);
> -
> -			if (DDADR(pcdev->dma_chans[i]) == DDADR_STOP) {
> -				/* The DMA engine is on the last
> -				   descriptor, set the next descriptors
> -				   address to the descriptors we just
> -				   initialized */
> -				buf_dma->sg_cpu[nents].ddadr = buf_dma->sg_dma;
> -			} else {
> -				buf_dma->sg_cpu[nents].ddadr =
> -					DDADR(pcdev->dma_chans[i]);
> -			}
> -
> -			/* The next descriptor is the dummy descriptor */
> -			DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
> -				sizeof(struct pxa_dma_desc);
> -
> -			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> -		}
> -	}
> +	if (!active)

You don't need "active" now at all, just use pcdev->active directly.

> +		pxa_camera_start_capture(pcdev);
> +	else
> +		pxa_dma_start_channels(pcdev);
>  
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
>  }
> @@ -572,7 +668,7 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>  			      struct videobuf_buffer *vb,
>  			      struct pxa_buffer *buf)
>  {
> -	unsigned long cicr0;
> +	int i;
>  
>  	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
>  	list_del_init(&vb->queue);
> @@ -580,15 +676,13 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>  	do_gettimeofday(&vb->ts);
>  	vb->field_count++;
>  	wake_up(&vb->done);
> +	dev_dbg(pcdev->dev, "%s dequeud buffer (vb=0x%p)\n", __func__, vb);
>  
>  	if (list_empty(&pcdev->capture)) {
> +		pxa_camera_stop_capture(pcdev);

Yre you actually using power-management? Could you test it?

>  		pcdev->active = NULL;
> -		DCSR(pcdev->dma_chans[0]) = 0;
> -		DCSR(pcdev->dma_chans[1]) = 0;
> -		DCSR(pcdev->dma_chans[2]) = 0;
> -
> -		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
> -		__raw_writel(cicr0, pcdev->base + CICR0);
> +		for (i = 0; i < pcdev->channels; i++)
> +			pcdev->sg_tail[i] = NULL;
>  		return;
>  	}
>  
> @@ -603,19 +697,23 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  	unsigned long flags;
>  	u32 status, camera_status, overrun;
>  	struct videobuf_buffer *vb;
> -	unsigned long cifr, cicr0;
>  
>  	spin_lock_irqsave(&pcdev->lock, flags);
>  
>  	status = DCSR(channel);
> -	DCSR(channel) = status | DCSR_ENDINTR;
> +	DCSR(channel) = status | DCSR_STARTINTR | DCSR_ENDINTR;

Again - I don't think you need the STARTINTR.

> +
> +	camera_status = __raw_readl(pcdev->base + CISR);
> +	overrun = CISR_IFO_0;
> +	if (pcdev->channels == 3)
> +		overrun |= CISR_IFO_1 | CISR_IFO_2;
>  
>  	if (status & DCSR_BUSERR) {
>  		dev_err(pcdev->dev, "DMA Bus Error IRQ!\n");
>  		goto out;
>  	}
>  
> -	if (!(status & DCSR_ENDINTR)) {
> +	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
>  		dev_err(pcdev->dev, "Unknown DMA IRQ source, "
>  			"status: 0x%08x\n", status);
>  		goto out;
> @@ -626,38 +724,27 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  		goto out;
>  	}
>  
> -	camera_status = __raw_readl(pcdev->base + CISR);
> -	overrun = CISR_IFO_0;
> -	if (pcdev->channels == 3)
> -		overrun |= CISR_IFO_1 | CISR_IFO_2;
> -	if (camera_status & overrun) {
> -		dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n", camera_status);
> -		/* Stop the Capture Interface */
> -		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
> -		__raw_writel(cicr0, pcdev->base + CICR0);
> -
> -		/* Stop DMA */
> -		DCSR(channel) = 0;
> -		/* Reset the FIFOs */
> -		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> -		__raw_writel(cifr, pcdev->base + CIFR);
> -		/* Enable End-Of-Frame Interrupt */
> -		cicr0 &= ~CICR0_EOFM;
> -		__raw_writel(cicr0, pcdev->base + CICR0);
> -		/* Restart the Capture Interface */
> -		__raw_writel(cicr0 | CICR0_ENB, pcdev->base + CICR0);
> -		goto out;
> -	}
> -
>  	vb = &pcdev->active->vb;
>  	buf = container_of(vb, struct pxa_buffer, vb);
>  	WARN_ON(buf->inwork || list_empty(&vb->queue));
> -	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
>  
> -	buf->active_dma &= ~act_dma;
> -	if (!buf->active_dma)
> -		pxa_camera_wakeup(pcdev, vb, buf);
> +	dev_dbg(pcdev->dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
> +		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
> +		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
> +
> +	if (status & DCSR_ENDINTR) {
> +		if (camera_status & overrun) {
> +			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
> +				camera_status);
> +			pxa_camera_stop_capture(pcdev);
> +			pxa_camera_start_capture(pcdev);
> +			goto out;
> +		}
> +
> +		buf->active_dma &= ~act_dma;
> +		if (!buf->active_dma)
> +			pxa_camera_wakeup(pcdev, vb, buf);
> +	}
>  
>  out:
>  	spin_unlock_irqrestore(&pcdev->lock, flags);
> @@ -796,12 +883,11 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
>  	__raw_writel(status, pcdev->base + CISR);
>  
>  	if (status & CISR_EOF) {
> -		int i;
> -		for (i = 0; i < pcdev->channels; i++) {
> -			DDADR(pcdev->dma_chans[i]) =
> -				pcdev->active->dmas[i].sg_dma;
> -			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> -		}
> +		pcdev->active = list_first_entry(&pcdev->capture,
> +					   struct pxa_buffer, vb.queue);
> +
> +		pxa_dma_start_channels(pcdev);
> +
>  		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
>  		__raw_writel(cicr0, pcdev->base + CICR0);
>  	}
> -- 
> 1.5.6.5

Overall - very nice! Now, I think, it also would be easier for you, if you 
split it into several patches. We can then review small patches again, 
then probably some of them won't need a third revision (counting this as 
the first,) if any will need one, it shoule be easier for you to update a 
couple of small patches rather then the whole big one. And easier for 
everyone to compare what has changed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
