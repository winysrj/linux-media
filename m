Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbeHMRpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:45:14 -0400
Date: Mon, 13 Aug 2018 12:02:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 29/34] v4l2-mem2mem: add vb2_m2m_request_queue
Message-ID: <20180813120149.1040f6f7@coco.lan>
In-Reply-To: <20180804124526.46206-30-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-30-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:21 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> For mem2mem devices we have to make sure that v4l2_m2m_try_schedule()
> is called whenever a request is queued.
> 
> We do that by creating a vb2_m2m_request_queue() helper that should
> be used instead of the 'normal' vb2_request_queue() helper. The m2m
> helper function will call v4l2_m2m_try_schedule() as needed.
> 
> In addition we also avoid calling v4l2_m2m_try_schedule() when preparing
> or queueing a buffer for a request since that is no longer needed.
> Instead this helper function will do that when the request is actually
> queued.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

But please notice below that there's another change on patch 1/34 due
to this patchset.

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 59 ++++++++++++++++++++++----
>  include/media/v4l2-mem2mem.h           |  4 ++
>  2 files changed, 55 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index b09494174eb4..56a16cfef6f8 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -369,7 +369,7 @@ static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
>  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
>  		if (m2m_dev->m2m_ops->job_abort)
>  			m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
> -		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
> +		dprintk("m2m_ctx %p running, will wait to complete\n", m2m_ctx);
>  		wait_event(m2m_ctx->finished,
>  				!(m2m_ctx->job_flags & TRANS_RUNNING));
>  	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
> @@ -460,8 +460,14 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  	int ret;
>  
>  	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> +	if (!V4L2_TYPE_IS_OUTPUT(vq->type) &&
> +	    (buf->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
> +		dprintk("%s: requests cannot be used with capture buffers\n",
> +			__func__);

I had to double-check the documentation at patch 01/34. While on one
part is says the same, saying that -EPERM is the error code, on
another part, it says:

	+Note that there is typically no need to use the Request API for CAPTURE buffers
	+since there are no per-frame settings to report there.

"typically" means that the normal usecase is to now allow, but gives
it open to implementations doing it.

Please fix that paragraph on patch 01/34 to reflect that no CAPTURE
buffers should be used with request API for m2m, in order to
reflect the code's implementation.

> +		return -EPERM;
> +	}
>  	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
> -	if (!ret)
> +	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
>  		v4l2_m2m_try_schedule(m2m_ctx);
>  
>  	return ret;
> @@ -483,14 +489,9 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	struct vb2_queue *vq;
> -	int ret;
>  
>  	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> -	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
> -	if (!ret)
> -		v4l2_m2m_try_schedule(m2m_ctx);
> -
> -	return ret;
> +	return vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
>  
> @@ -934,6 +935,48 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
>  
> +void vb2_m2m_request_queue(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +	struct v4l2_m2m_ctx *m2m_ctx = NULL;
> +
> +	/* Queue all non-buffer objects */
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> +		if (obj->ops->queue && !vb2_request_object_is_buffer(obj))
> +			obj->ops->queue(obj);
> +
> +	/* Queue all buffer objects */
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> +		struct v4l2_m2m_ctx *m2m_ctx_obj;
> +		struct vb2_buffer *vb;
> +
> +		if (!obj->ops->queue || !vb2_request_object_is_buffer(obj))
> +			continue;
> +
> +		/* Sanity checks */
> +		vb = container_of(obj, struct vb2_buffer, req_obj);
> +		WARN_ON(!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type));
> +		m2m_ctx_obj = container_of(vb->vb2_queue,
> +					   struct v4l2_m2m_ctx,
> +					   out_q_ctx.q);
> +		WARN_ON(m2m_ctx && m2m_ctx_obj != m2m_ctx);
> +		m2m_ctx = m2m_ctx_obj;
> +
> +		/*
> +		 * The buffer we queue here can in theory be immediately
> +		 * unbound, hence the use of list_for_each_entry_safe()
> +		 * above and why we call the queue op last.
> +		 */
> +		obj->ops->queue(obj);
> +	}
> +
> +	WARN_ON(!m2m_ctx);
> +
> +	if (m2m_ctx)
> +		v4l2_m2m_try_schedule(m2m_ctx);
> +}
> +EXPORT_SYMBOL_GPL(vb2_m2m_request_queue);
> +
>  /* Videobuf2 ioctl helpers */
>  
>  int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index d655720e16a1..58c1ecf3d648 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -622,6 +622,10 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
>  	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
>  }
>  
> +/* v4l2 request helper */
> +
> +void vb2_m2m_request_queue(struct media_request *req);
> +
>  /* v4l2 ioctl helpers */
>  
>  int v4l2_m2m_ioctl_reqbufs(struct file *file, void *priv,



Thanks,
Mauro
