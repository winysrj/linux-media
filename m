Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:18804 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab2ANUjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 15:39:06 -0500
Message-ID: <4F11E7D4.4050906@iki.fi>
Date: Sat, 14 Jan 2012 22:38:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@ti.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, patches@linaro.org, jesse.barker@linaro.org,
	daniel@ffwll.ch,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hiroshi Doyu <hiroshi.doyu@gmail.com>
Subject: Re: [Linaro-mm-sig] [RFCv1 2/4] v4l:vb2: add support for shared buffer
 (dma_buf)
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <1325760118-27997-3-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1325760118-27997-3-git-send-email-sumit.semwal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,

Thanks for the patch!

Sumit Semwal wrote:
...
> @@ -962,6 +1030,109 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  }
>  
>  /**
> + * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
> + */
> +static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +	struct v4l2_plane planes[VIDEO_MAX_PLANES];
> +	struct vb2_queue *q = vb->vb2_queue;
> +	void *mem_priv;
> +	unsigned int plane;
> +	int ret;
> +	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +
> +	/* Verify and copy relevant information provided by the userspace */
> +	ret = __fill_vb2_buffer(vb, b, planes);
> +	if (ret)
> +		return ret;
> +
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
> +
> +		if (IS_ERR_OR_NULL(dbuf)) {
> +			dprintk(1, "qbuf: invalid dmabuf fd for "
> +				"plane %d\n", plane);
> +			ret = PTR_ERR(dbuf);
> +			goto err;
> +		}
> +
> +		/* this doesn't get filled in until __fill_vb2_buffer(),
> +		 * since it isn't known until after dma_buf_get()..
> +		 */
> +		planes[plane].length = dbuf->size;
> +
> +		/* Skip the plane if already verified */
> +		if (dbuf == vb->planes[plane].dbuf) {
> +			dma_buf_put(dbuf);
> +			continue;
> +		}
> +
> +		dprintk(3, "qbuf: buffer description for plane %d changed, "
> +			"reattaching dma buf\n", plane);
> +
> +		/* Release previously acquired memory if present */
> +		if (vb->planes[plane].mem_priv) {
> +			call_memop(q, plane, detach_dmabuf,
> +				vb->planes[plane].mem_priv);
> +			dma_buf_put(vb->planes[plane].dbuf);
> +		}
> +
> +		vb->planes[plane].mem_priv = NULL;
> +
> +		/* Acquire each plane's memory */
> +		mem_priv = q->mem_ops->attach_dmabuf(
> +				q->alloc_ctx[plane], dbuf);
> +		if (IS_ERR(mem_priv)) {
> +			dprintk(1, "qbuf: failed acquiring dmabuf "
> +				"memory for plane %d\n", plane);
> +			ret = PTR_ERR(mem_priv);
> +			goto err;
> +		}
> +
> +		vb->planes[plane].dbuf = dbuf;
> +		vb->planes[plane].mem_priv = mem_priv;
> +	}
> +
> +	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
> +	 * really we want to do this just before the DMA, not while queueing
> +	 * the buffer(s)..
> +	 */
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		ret = q->mem_ops->map_dmabuf(
> +				vb->planes[plane].mem_priv, write);
> +		if (ret) {
> +			dprintk(1, "qbuf: failed mapping dmabuf "
> +				"memory for plane %d\n", plane);
> +			goto err;
> +		}
> +	}

Shouldn't the buffer mapping only be done at the first call to
__qbuf_dmabuf()? On latter calls, the cache would need to be handled
according to presence of V4L2_BUF_FLAG_NO_CACHE_CLEAN /
V4L2_BUF_FLAG_NO_CACHE_INVALIDATE in v4l2_buffer.

> +	/*
> +	 * Call driver-specific initialization on the newly acquired buffer,
> +	 * if provided.
> +	 */
> +	ret = call_qop(q, buf_init, vb);
> +	if (ret) {
> +		dprintk(1, "qbuf: buffer initialization failed\n");
> +		goto err;
> +	}
> +
> +	/*
> +	 * Now that everything is in order, copy relevant information
> +	 * provided by userspace.
> +	 */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		vb->v4l2_planes[plane] = planes[plane];
> +
> +	return 0;
> +err:
> +	/* In case of errors, release planes that were already acquired */
> +	__vb2_buf_dmabuf_put(vb);
> +
> +	return ret;
> +}
> +
> +/**
>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>   */
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
> @@ -985,6 +1156,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  	case V4L2_MEMORY_USERPTR:
>  		ret = __qbuf_userptr(vb, b);
>  		break;
> +	case V4L2_MEMORY_DMABUF:
> +		ret = __qbuf_dmabuf(vb, b);
> +		break;
>  	default:
>  		WARN(1, "Invalid queue type\n");
>  		ret = -EINVAL;
> @@ -1284,6 +1458,7 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>  {
>  	struct vb2_buffer *vb = NULL;
>  	int ret;
> +	unsigned int plane;
>  
>  	if (q->fileio) {
>  		dprintk(1, "dqbuf: file io in progress\n");
> @@ -1307,6 +1482,15 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>  		return ret;
>  	}
>  
> +	/* TODO: this unpins the buffer(dma_buf_unmap_attachment()).. but
> +	 * really we want tot do this just after DMA, not when the
> +	 * buffer is dequeued..
> +	 */
> +	if (q->memory == V4L2_MEMORY_DMABUF)
> +		for (plane = 0; plane < vb->num_planes; ++plane)
> +			call_memop(q, plane, unmap_dmabuf,
> +				vb->planes[plane].mem_priv);
> +

Same here, except reverse: this only should be done when the buffer is
destroyed --- either when the user explicitly calls reqbufs(0) or when
the file handle owning this buffer is being closed.

Mapping buffers at every prepare_buf and unmapping them in dqbuf is
prohibitively expensive. Same goes for many other APIs than V4L2, I think.

I wonder if the means to do this exists already.

I have to admit I haven't followed the dma_buf discussion closely so I
might be missing something relevant here.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
