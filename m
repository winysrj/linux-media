Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14B3dcs006783
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 06:03:40 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m14B39SA014843
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 06:03:09 -0500
Date: Mon, 4 Feb 2008 12:03:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0801311708390.8478@axis700.grange>
Message-ID: <Pine.LNX.4.64.0802041159180.4256@axis700.grange>
References: <Pine.LNX.4.64.0801311658420.8478@axis700.grange>
	<Pine.LNX.4.64.0801311708390.8478@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

On Thu, 31 Jan 2008, Guennadi Liakhovetski wrote:

> +static int
> +pxa_videobuf_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
> +						enum v4l2_field field)
> +{
> +	struct soc_camera_device *icd = vq->priv_data;
> +	struct soc_camera_host *ici =
> +		to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
> +	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
> +//	unsigned long flags;
> +	int i, ret;
> +
> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
> +		vb, vb->baddr, vb->bsize);
> +
> +	/* Added list head initialization on alloc */
> +	WARN_ON(!list_empty(&vb->queue));
> +
> +#ifdef DEBUG
> +	/* This can be useful if you want to see if we actually fill
> +	 * the buffer with something */
> +	memset((void *)vb->baddr, 0xaa, vb->bsize);
> +#endif
> +
> +	BUG_ON(NULL == icd->current_fmt);
> +
> +	/* I think, in buf_prepare you only have to protect global data,
> +	 * the actual buffer is yours */

Could someone, please, confirm, that my assumption here is correct and I 
don't need this additional locking here?

> +//	spin_lock_irqsave(&pcdev->lock, flags);
> +	buf->inwork = 1;
> +
> +	if (buf->fmt	!= icd->current_fmt ||
> +	    vb->width	!= icd->width ||
> +	    vb->height	!= icd->height ||
> +	    vb->field	!= field) {
> +		buf->fmt	= icd->current_fmt;
> +		vb->width	= icd->width;
> +		vb->height	= icd->height;
> +		vb->field	= field;
> +		vb->state	= VIDEOBUF_NEEDS_INIT;
> +	}
> +
> +	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
> +	if (0 != vb->baddr && vb->bsize < vb->size) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> +		unsigned int size = vb->size;
> +		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> +
> +		if (0 != (ret = videobuf_iolock(vq, vb, NULL)))
> +			goto fail;
> +
> +		if (buf->sg_cpu)
> +			dma_free_coherent(pcdev->dev, buf->sg_size, buf->sg_cpu, buf->sg_dma);
> +
> +		buf->sg_size = (dma->sglen + 1) * sizeof(struct pxa_dma_desc);
> +		buf->sg_cpu = dma_alloc_coherent(pcdev->dev, buf->sg_size,
> +						 &buf->sg_dma, GFP_KERNEL);
> +		if (!buf->sg_cpu) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		dev_dbg(&icd->dev, "%s nents=%d size: %d sg=0x%p\n", __FUNCTION__,
> +			dma->sglen, size, dma->sglist);
> +		for (i = 0; i < dma->sglen; i++ ) {
> +			struct scatterlist *sg = dma->sglist;
> +			unsigned int dma_len = sg_dma_len(&sg[i]), xfer_len;
> +
> +			buf->sg_cpu[i].dsadr = pcdev->res->start + 0x28; /* CIBR0 */
> +			buf->sg_cpu[i].dtadr = sg_dma_address(&sg[i]);
> +			/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> +			xfer_len = (min(dma_len, size) + 7) & ~7;
> +//			xfer_len = min(dma_len, size);
> +			if (xfer_len & 7)
> +				dev_err(&icd->dev, "Unaligned buffer: dma_len %u, size %u\n",
> +					dma_len, size);
> +			buf->sg_cpu[i].dcmd = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR |
> +				xfer_len;
> +			size -= dma_len;
> +			buf->sg_cpu[i].ddadr = buf->sg_dma + (i + 1) *
> +					sizeof(struct pxa_dma_desc);
> +		}
> +		buf->sg_cpu[dma->sglen - 1].ddadr = DDADR_STOP;
> +		buf->sg_cpu[dma->sglen - 1].dcmd |= DCMD_ENDIRQEN;
> +
> +		vb->state = VIDEOBUF_PREPARED;
> +	}
> +
> +	buf->inwork = 0;
> +//	spin_unlock_irqrestore(&pcdev->lock, flags);
> +
> +	return 0;
> +
> +fail:
> +	free_buffer(vq, buf);
> +out:
> +	buf->inwork = 0;
> +//	spin_unlock_irqrestore(&pcdev->lock, flags);
> +	return ret;
> +}

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
