Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab0EEU5q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 16:57:46 -0400
Message-ID: <4BE1DBC2.3000300@redhat.com>
Date: Wed, 05 May 2010 17:57:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH v1 1/1] V4L: Add sync before a hardware operation to videobuf.
References: <1263914929-28211-1-git-send-email-p.osciak@samsung.com> <1263914929-28211-2-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1263914929-28211-2-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
> Architectures with non-coherent CPU cache (e.g. ARM) may require a cache
> flush or invalidation before starting a hardware operation if the data in
> a video buffer being queued has been touched by the CPU.
> 
> This patch adds calls to sync before a hardware operation that are expected
> to be interpreted and handled by each memory type-specific module.
> 
> Whether it is a sync before or after the operation can be determined from
> the current buffer state: VIDEOBUF_DONE and VIDEOBUF_ERROR indicate a sync
> called after an operation.

Hi Pawel,

After analyzing this patch, maybe the better is to add a check for dma 
coherency. So, instead of directly calling sync,the better is to check 
if !dma_is_consistent(), to avoid adding a penalty on architectures
where the cache is coherent.

> 
> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index bb0a1c8..e56c67a 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -561,6 +561,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  		goto done;
>  	}
>  
> +	CALL(q, sync, q, buf);
> +
>  	list_add_tail(&buf->stream, &q->stream);
>  	if (q->streaming) {
>  		spin_lock_irqsave(q->irqlock, flags);
> @@ -761,6 +763,8 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
>  	if (0 != retval)
>  		goto done;
>  
> +	CALL(q, sync, q, q->read_buf);
> +
>  	/* start capture & wait */
>  	spin_lock_irqsave(q->irqlock, flags);
>  	q->ops->buf_queue(q, q->read_buf);
> @@ -826,6 +830,8 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
>  			goto done;
>  		}
>  
> +		CALL(q, sync, q, q->read_buf);
> +
>  		spin_lock_irqsave(q->irqlock, flags);
>  		q->ops->buf_queue(q, q->read_buf);
>  		spin_unlock_irqrestore(q->irqlock, flags);
> @@ -893,6 +899,9 @@ static int __videobuf_read_start(struct videobuf_queue *q)
>  		err = q->ops->buf_prepare(q, q->bufs[i], field);
>  		if (err)
>  			return err;
> +
> +		CALL(q, sync, q, q->read_buf);
> +
>  		list_add_tail(&q->bufs[i]->stream, &q->stream);
>  	}
>  	spin_lock_irqsave(q->irqlock, flags);
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index fa78555..2b153f8 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -50,6 +50,9 @@ MODULE_LICENSE("GPL");
>  #define dprintk(level, fmt, arg...)	if (debug >= level) \
>  	printk(KERN_DEBUG "vbuf-sg: " fmt , ## arg)
>  
> +#define is_sync_after(vb) \
> +	(vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
> +
>  /* --------------------------------------------------------------------- */
>  
>  struct scatterlist*
> @@ -516,6 +519,9 @@ static int __videobuf_sync(struct videobuf_queue *q,
>  	BUG_ON(!mem);
>  	MAGIC_CHECK(mem->magic,MAGIC_SG_MEM);
>  
> +	if (!is_sync_after(buf))
> +		return 0;
> +
>  	return	videobuf_dma_sync(q,&mem->dma);
>  }
>  


-- 

Cheers,
Mauro
