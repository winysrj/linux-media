Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m349EcUG029907
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 05:14:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m349EQPi008536
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 05:14:27 -0400
Date: Fri, 4 Apr 2008 11:14:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <47F21593.7080507@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804031708470.18539@axis700.grange>
References: <47F21593.7080507@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Add support for YUV modes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Looks good overall!

First static analysis:

On Tue, 1 Apr 2008, Mike Rapoport wrote:

> @@ -67,9 +67,24 @@
> 
>  static DEFINE_MUTEX(camera_lock);
> 
> +#define BUFFER_TIMEOUT     msecs_to_jiffies(1000)  /* 0.5 seconds */

This doesn't look like 0.5 second to me:-) AFAIU, this timeout is supposed 
to trigger when an application failed to queue new buffers quickly enough. 
I see an init_timer, a mod_timer, but no del_timer(_sync). Don't you have 
to delete the timer at least on rmmod to avoid an Oops? Also on streamoff, 
which ATM wouldn't be possible with the current soc-camera API, because 
streamoff is not passed to the camera-host driver. A good place could be 
in the interrupt handler where you check

	if (list_empty(&pcdev->capture)) {
	}

I would prefer to first leave this timer aside and concentrate on the YUV 
functionality, could we do that? If I am right in that the YUV support 
doesn't require this timer, please, separate it into an additional patch.

> +static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
> +				struct pxa_buffer *buf,
> +				struct videobuf_dmabuf *dma, int channel,
> +				int sglen, int sg_start, int cibr, int size)
> +{
> +	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
> +	int i;
> +
> +	if (pxa_dma->sg_cpu)
> +		dma_free_coherent(pcdev->dev, pxa_dma->sg_size,
> +				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
> +
> +	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
> +	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
> +					     &pxa_dma->sg_dma, GFP_KERNEL);
> +	if (!pxa_dma->sg_cpu)
> +		return -ENOMEM;
> +
> +	pxa_dma->sglen = sglen;
> +
> +	/* DMA for Y buffers */

I presume, this comment doesn't hold?

> +	for (i = 0; i < sglen; i++) {
> +		int sg_i = sg_start + i;
> +		struct scatterlist *sg = dma->sglist;
> +		unsigned int dma_len = sg_dma_len(&sg[sg_i]), xfer_len;
> +
> +		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
> +		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]);
> +
> +		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> +		xfer_len = (min(dma_len, size) + 7) & ~7;
> +
> +		pxa_dma->sg_cpu[i].dcmd =
> +			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
> +		size -= dma_len;
> +		pxa_dma->sg_cpu[i].ddadr =
> +			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
> +	}
> +	/* end of Y pages */

This one too.

> +	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
> +	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
> +
> +	return 0;
>  }
> 
>  static int pxa_videobuf_prepare(struct videobuf_queue *vq,
> @@ -173,7 +249,8 @@ static int pxa_videobuf_prepare(struct v
>  		to_soc_camera_host(icd->dev.parent);
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
> -	int i, ret;
> +	int ret;
> +	int sglen_y, sglen_u, sglen_v, sglen_yu, size_y, size_uv;
> 
>  	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
>  		vb, vb->baddr, vb->bsize);
> @@ -218,49 +295,61 @@ static int pxa_videobuf_prepare(struct v
>  		if (ret)
>  			goto fail;
> 
> -		if (buf->sg_cpu)
> -			dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu,
> -					  buf->sg_dma);
> -
> -		buf->sg_size = (dma->sglen + 1) * sizeof(struct pxa_dma_desc);
> -		buf->sg_cpu = dma_alloc_coherent(pcdev->dev, buf->sg_size,
> -						 &buf->sg_dma, GFP_KERNEL);
> -		if (!buf->sg_cpu) {
> -			ret = -ENOMEM;
> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
> +			/* FIXME the calculations should be more precise */
> +			sglen_y = dma->sglen / 2;
> +			sglen_u = sglen_v = dma->sglen / 4 + 1;
> +			sglen_yu = sglen_y + dma->sglen / 4 + 1;

IMHO better readable would be

> +			sglen_yu = sglen_y + sglen_u;


> +			size_y = size / 2;
> +			size_uv = size / 4;

Following your above notation more consistent would be

> +			size_u = size_v = size / 4;

and then use them for the two pxa_init_dma_channel() calls respectively? 
It is confusing because sglen_yu above means (sglen_y + sglen_u).

> +		} else {
> +			sglen_y = dma->sglen;
> +			size_y = size;
> +		}
> +
> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, sglen_y,
> +					   0, 0x28, size_y);
> +
> +		if (ret) {
> +			dev_err(pcdev->dev,
> +				"DMA initialization for Y/RGB failed\n");
>  			goto fail;
>  		}
> 
> -		dev_dbg(&icd->dev, "nents=%d size: %d sg=0x%p\n",
> -			dma->sglen, size, dma->sglist);
> -		for (i = 0; i < dma->sglen; i++) {
> -			struct scatterlist *sg = dma->sglist;
> -			unsigned int dma_len = sg_dma_len(&sg[i]), xfer_len;
> -
> -			/* CIBR0 */
> -			buf->sg_cpu[i].dsadr = pcdev->res->start + 0x28;
> -			buf->sg_cpu[i].dtadr = sg_dma_address(&sg[i]);
> -			/* PXA270 Developer's Manual 27.4.4.1:
> -			 * round up to 8 bytes */
> -			xfer_len = (min(dma_len, size) + 7) & ~7;
> -			if (xfer_len & 7)
> -				dev_err(&icd->dev, "Unaligned buffer: "
> -					"dma_len %u, size %u\n", dma_len, size);
> -			buf->sg_cpu[i].dcmd = DCMD_FLOWSRC | DCMD_BURST8 |
> -				DCMD_INCTRGADDR | xfer_len;
> -			size -= dma_len;
> -			buf->sg_cpu[i].ddadr = buf->sg_dma + (i + 1) *
> -					sizeof(struct pxa_dma_desc);
> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_y,

This should be sglen_u							^^^^^

> +						   sglen_y, 0x30, size_uv);
> +			if (ret) {
> +				dev_err(pcdev->dev,
> +					"DMA initialization for U failed\n");
> +				goto fail_u;
> +			}
> +
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, sglen_y,

This should be sglen_v							^^^^^

> @@ -292,59 +379,90 @@ static void pxa_videobuf_queue(struct vi
> 
>  	if (!active) {
>  		CIFR |= CIFR_RESET_F;
> -		DDADR(pcdev->dma_chan_y) = buf->sg_dma;
> -		DCSR(pcdev->dma_chan_y) = DCSR_RUN;
> +		DDADR(pcdev->dma_chans[0]) = buf->dmas[0].sg_dma;
> +		DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
> +
> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
> +			DDADR(pcdev->dma_chans[1]) = buf->dmas[1].sg_dma;
> +			DCSR(pcdev->dma_chans[1]) = DCSR_RUN;
> +
> +			DDADR(pcdev->dma_chans[2]) = buf->dmas[2].sg_dma;
> +			DCSR(pcdev->dma_chans[2]) = DCSR_RUN;
> +		}
> +
>  		pcdev->active = buf;
>  		CICR0 |= CICR0_ENB;
> +		mod_timer(&pcdev->timeout, jiffies + BUFFER_TIMEOUT);
>  	} else {
> -		struct videobuf_dmabuf *active_dma =
> -			videobuf_to_dma(&active->vb);
> -		/* Stop DMA engine */
> -		DCSR(pcdev->dma_chan_y) = 0;
> -
> -		/* Add the descriptors we just initialized to the currently
> -		 * running chain
> -		 */
> -		active->sg_cpu[active_dma->sglen - 1].ddadr = buf->sg_dma;
> -
> -		/* Setup a dummy descriptor with the DMA engines current
> -		 * state
> -		 */
> -		/* CIBR0 */
> -		buf->sg_cpu[nents].dsadr = pcdev->res->start + 0x28;
> -		buf->sg_cpu[nents].dtadr = DTADR(pcdev->dma_chan_y);
> -		buf->sg_cpu[nents].dcmd = DCMD(pcdev->dma_chan_y);
> -
> -		if (DDADR(pcdev->dma_chan_y) == DDADR_STOP) {
> -			/* The DMA engine is on the last descriptor, set the
> -			 * next descriptors address to the descriptors
> -			 * we just initialized
> +		struct pxa_cam_dma *buf_dma;
> +		struct pxa_cam_dma *act_dma;
> +		int channels = 1;
> +		int nents;
> +		int i;
> +
> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
> +			channels = 3;
> +
> +		for (i = 0; i < channels; i++) {
> +			buf_dma = &buf->dmas[i];
> +			act_dma = &active->dmas[0];
> +			nents = buf_dma->sglen;
> +
> +			/* Stop DMA engine */
> +			DCSR(pcdev->dma_chans[i]) = 0;
> +
> +			/* Add the descriptors we just initialized to
> +			   the currently running chain */
> +			act_dma->sg_cpu[act_dma->sglen - 1].ddadr =
> +				buf_dma->sg_dma;
> +
> +			/* Setup a dummy descriptor with the DMA engines current
> +			 * state
>  			 */
> -			buf->sg_cpu[nents].ddadr = buf->sg_dma;
> -		} else {
> -			buf->sg_cpu[nents].ddadr = DDADR(pcdev->dma_chan_y);
> +			buf_dma->sg_cpu[nents].dsadr =
> +				pcdev->res->start + 0x28 + i*8; /* CIBRx */
> +			buf_dma->sg_cpu[nents].dtadr =
> +				DTADR(pcdev->dma_chans[i]);
> +			buf_dma->sg_cpu[nents].dcmd =
> +				DCMD(pcdev->dma_chans[i]);
> +
> +			if (DDADR(pcdev->dma_chans[i]) == DDADR_STOP) {
> +				/* The DMA engine is on the last
> +				   descriptor, set the next descriptors
> +				   address to the descriptors we just
> +				   initialized */
> +				buf_dma->sg_cpu[nents].ddadr = buf_dma->sg_dma;
> +			} else {
> +				buf_dma->sg_cpu[nents].ddadr =
> +					DDADR(pcdev->dma_chans[i]);
> +			}
> +
> +			/* The next descriptor is the dummy descriptor */
> +			DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
> +				sizeof(struct pxa_dma_desc);
> +
> +			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> +#ifdef DEBUG
> +			if (CISR & CISR_IFO_0) {
> +				dev_warn(pcdev->dev, "FIFO overrun\n");
> +				for (i = 0; i < channels; i++)
> +					DDADR(pcdev->dma_chans[i]) =
> +						pcdev->active->dmas[i].sg_dma;
> +
> +				CICR0 &= ~CICR0_ENB;
> +				CIFR |= CIFR_RESET_F;
> +				for (i = 0; i < channels; i++)
> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
> +				CICR0 |= CICR0_ENB;
> +			} else {
> +				for (i = 0; i < channels; i++)
> +					DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
> +			}

These three loops don't look right. At least because they use the same 
index i. And you're iterating over channels inside a loop over channels, 
and you have dma_chans[0] instead of [i]. Please fix.

> +static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
> +			       enum pxa_camera_active_dma act_dma)
> +{
> +	struct pxa_buffer *buf;
> +	unsigned long flags;
> +	unsigned int status;
> +	struct videobuf_buffer *vb;
> +
> +	spin_lock_irqsave(&pcdev->lock, flags);
> +
> +	status = DCSR(channel);
> +	DCSR(channel) |= DCSR_ENDINTR;

better

> +	DCSR(channel) = status | DCSR_ENDINTR;

to avoid clearing new interrupts.

> @@ -572,7 +750,7 @@ static void pxa_camera_remove_device(str
>  	/* disable capture, disable interrupts */
>  	CICR0 = 0x3ff;
>  	/* Stop DMA engine */
> -	DCSR(pcdev->dma_chan_y) = 0;
> +	DCSR(pcdev->dma_chans[0]) = 0;

Disable the other two channels too?

Ok, now compile-time, applied on the top of v4l-dvb/develop:

drivers/media/video/pxa_camera.c: In function 'pxa_init_dma_channel':
drivers/media/video/pxa_camera.c:229: warning: comparison of distinct pointer types lacks a cast
drivers/media/video/pxa_camera.c: In function 'pxa_camera_set_bus_param':
drivers/media/video/pxa_camera.c:890: error: implicit declaration of function 'CICR1_COLOR_SP_VAL'
drivers/media/video/pxa_camera.c:893: error: implicit declaration of function 'CICR1_RGB_BPP_VAL'
drivers/media/video/pxa_camera.c:893: error: implicit declaration of function 'CICR1_RGBT_CONV_VAL'

I converted parameters of pxa_init_dma_channel() to unsigned int and added 
the missing defines. Please, do the same in your next version. Then I 
still got

drivers/media/video/pxa_camera.c: In function 'pxa_videobuf_prepare':
drivers/media/video/pxa_camera.c:257: warning: 'size_uv' may be used uninitialized in this function
drivers/media/video/pxa_camera.c:257: warning: 'sglen_yu' may be used uninitialized in this function

which also have to be fixed.

Run-time: positive. My 8 bit raw modes still worked. Stopping mplayer and 
immediately rmmod-ing pxa-camera locked up the system, as expected.

So, please fix these issues and we'll try to get it in!

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
