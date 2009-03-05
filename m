Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33661 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756117AbZCEU3L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 15:29:11 -0500
Date: Thu, 5 Mar 2009 21:29:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] pxa_camera: Remove YUV planar formats hole
In-Reply-To: <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0903052119590.4980@axis700.grange>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Robert Jarzmik wrote:

> All planes were PAGE aligned (ie. 4096 bytes aligned). This
> is not consistent with YUV422 format, which requires Y, U
> and V planes glued together.  The new implementation forces
> the alignement on 8 bytes (DMA requirement), which is almost
> always the case (granted by width x height being a multiple
> of 8).

This is not a review yet - just an explanation why I was suggesting to 
adjust height and width - you say yourself, that YUV422P (I think, this is 
wat you meant, not just YUV422) requires planes to immediately follow one 
another. But you have to align them on 8 byte boundary for DMA, so, you 
violate the standard, right? If so, I would rather suggest to adjust width 
and height for planar formats to comply to the standard. Or have I 
misunderstood you?

Thanks
Guennadi

> 
> The test cases include tests in both YUV422 and RGB565 :
>  - a picture of size 111 x 111 (cross RAM pages example)
>  - a picture of size 1023 x 4 in (under 1 RAM page)
>  - a picture of size 1024 x 4 in (exactly 1 RAM page)
>  - a picture of size 1025 x 4 in (over 1 RAM page)
>  - a picture of size 1280 x 1024 (many RAM pages)
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/video/pxa_camera.c |  165 ++++++++++++++++++++++++++------------
>  1 files changed, 114 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index e3e6b29..54df071 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -242,14 +242,13 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>  	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
>  
>  	/* planar capture requires Y, U and V buffers to be page aligned */
> -	if (pcdev->channels == 3) {
> -		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
> -		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
> -	} else {
> -		*size = icd->width * icd->height *
> -			((icd->current_fmt->depth + 7) >> 3);
> -	}
> +	if (pcdev->channels == 3)
> +		*size = roundup(icd->width * icd->height, 8) /* Y pages */
> +			+ roundup(icd->width * icd->height / 2, 8) /* U pages */
> +			+ roundup(icd->width * icd->height / 2, 8); /* V pages */
> +	else
> +		*size = roundup(icd->width * icd->height *
> +				((icd->current_fmt->depth + 7) >> 3), 8);
>  
>  	if (0 == *count)
>  		*count = 32;
> @@ -289,19 +288,63 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>  }
>  
> +static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
> +			       int sg_first_ofs, int size)
> +{
> +	int i, offset, dma_len, xfer_len;
> +	struct scatterlist *sg;
> +
> +	offset = sg_first_ofs;
> +	for_each_sg(sglist, sg, sglen, i) {
> +		dma_len = sg_dma_len(sg);
> +
> +		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> +		xfer_len = roundup(min(dma_len - offset, size), 8);
> +
> +		size = max(0, size - xfer_len);
> +		offset = 0;
> +		if (size == 0)
> +			break;
> +	}
> +
> +	BUG_ON(size != 0);
> +	return i + 1;
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
> + */
>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  				struct pxa_buffer *buf,
>  				struct videobuf_dmabuf *dma, int channel,
> -				int sglen, int sg_start, int cibr,
> -				unsigned int size)
> +				int cibr, int size,
> +				struct scatterlist **sg_first, int *sg_first_ofs)
>  {
>  	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
> -	int i;
> +	struct scatterlist *sg;
> +	int i, offset, sglen;
> +	int dma_len = 0, xfer_len = 0;
>  
>  	if (pxa_dma->sg_cpu)
>  		dma_free_coherent(pcdev->dev, pxa_dma->sg_size,
>  				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
>  
> +	sglen = calculate_dma_sglen(*sg_first, dma->sglen,
> +				    *sg_first_ofs, size);
> +
>  	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
>  	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
>  					     &pxa_dma->sg_dma, GFP_KERNEL);
> @@ -309,27 +352,51 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  		return -ENOMEM;
>  
>  	pxa_dma->sglen = sglen;
> +	offset = *sg_first_ofs;
>  
> -	for (i = 0; i < sglen; i++) {
> -		int sg_i = sg_start + i;
> -		struct scatterlist *sg = dma->sglist;
> -		unsigned int dma_len = sg_dma_len(&sg[sg_i]), xfer_len;
> +	dev_dbg(pcdev->dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
> +		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
>  
> -		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
> -		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(&sg[sg_i]);
> +
> +	for_each_sg(*sg_first, sg, sglen, i) {
> +		dma_len = sg_dma_len(sg);
>  
>  		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> -		xfer_len = (min(dma_len, size) + 7) & ~7;
> +		xfer_len = roundup(min(dma_len - offset, size), 8);
>  
> +		size = max(0, size - xfer_len);
> +
> +		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
> +		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
>  		pxa_dma->sg_cpu[i].dcmd =
>  			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
> -		size -= dma_len;
>  		pxa_dma->sg_cpu[i].ddadr =
>  			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
> +
> +		dev_vdbg(pcdev->dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
> +			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
> +			 sg_dma_address(sg) + offset, xfer_len);
> +		offset = 0;
> +
> +		if (size == 0)
> +			break;
>  	}
>  
> -	pxa_dma->sg_cpu[sglen - 1].ddadr = DDADR_STOP;
> -	pxa_dma->sg_cpu[sglen - 1].dcmd |= DCMD_ENDIRQEN;
> +	pxa_dma->sg_cpu[sglen].ddadr = DDADR_STOP;
> +	pxa_dma->sg_cpu[sglen].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
> +
> +	*sg_first_ofs = xfer_len;
> +	/*
> +	 * Handle 1 special case :
> +	 *  - if we finish the DMA transfer in the last 7 bytes of a RAM page
> +	 *    then we return the sg element pointing on the next page
> +	 */
> +	if (*sg_first_ofs >= dma_len) {
> +		*sg_first_ofs -= dma_len;
> +		*sg_first = sg_next(sg);
> +	} else {
> +		*sg_first = sg;
> +	}
>  
>  	return 0;
>  }
> @@ -342,9 +409,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
>  	int ret;
> -	int sglen_y,  sglen_yu = 0, sglen_u = 0, sglen_v = 0;
> -	int size_y, size_u = 0, size_v = 0;
> -
> +	int size_y = 0, size_u = 0, size_v = 0;
>  	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>  		vb, vb->baddr, vb->bsize);
>  
> @@ -381,53 +446,51 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	}
>  
>  	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> -		unsigned int size = vb->size;
> +		int size = vb->size;
> +		int next_ofs = 0;
>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> +		struct scatterlist *sg;
>  
>  		ret = videobuf_iolock(vq, vb, NULL);
>  		if (ret)
>  			goto fail;
>  
>  		if (pcdev->channels == 3) {
> -			/* FIXME the calculations should be more precise */
> -			sglen_y = dma->sglen / 2;
> -			sglen_u = sglen_v = dma->sglen / 4 + 1;
> -			sglen_yu = sglen_y + sglen_u;
>  			size_y = size / 2;
>  			size_u = size_v = size / 4;
>  		} else {
> -			sglen_y = dma->sglen;
>  			size_y = size;
>  		}
>  
> -		/* init DMA for Y channel */
> -		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, sglen_y,
> -					   0, 0x28, size_y);
> +		sg = dma->sglist;
>  
> +		/* init DMA for Y channel */
> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
> +					   &sg, &next_ofs);
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
> +		/* init DMA for U channel */
> +		if (size_u)
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
> +						   size_u, &sg, &next_ofs);
> +		if (ret) {
> +			dev_err(pcdev->dev,
> +				"DMA initialization for U failed\n");
> +			goto fail_u;
> +		}
>  
> -			/* init DMA for V channel */
> -			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, sglen_v,
> -						   sglen_yu, 0x38, size_v);
> -			if (ret) {
> -				dev_err(pcdev->dev,
> -					"DMA initialization for V failed\n");
> -				goto fail_v;
> -			}
> +		/* init DMA for V channel */
> +		if (size_v)
> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
> +						   size_u, &sg, &next_ofs);
> +		if (ret) {
> +			dev_err(pcdev->dev,
> +				"DMA initialization for V failed\n");
> +			goto fail_v;
>  		}
>  
>  		vb->state = VIDEOBUF_PREPARED;
> -- 
> 1.5.6.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
