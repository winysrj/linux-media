Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31727 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3JPLbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 07:31:19 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
 <1381581120-26883-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1381581120-26883-3-git-send-email-s.nawrocki@samsung.com>
Subject: RE: [PATCH RFC v2 02/10] mem2mem_testdev: Use mem-to-mem ioctl and vb2
 helpers
Date: Wed, 16 Oct 2013 13:31:15 +0200
Message-id: <064501ceca63$3ab16380$b0142a80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Saturday, October 12, 2013 2:32 PM
> Subject: [PATCH RFC v2 02/10] mem2mem_testdev: Use mem-to-mem ioctl and
> vb2 helpers
> 
> Simplify the driver by using the m2m ioctl and vb2 helpers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
> Changes since v1:
>  - dropped now redundant struct m2mtest_ctx::m2m_ctx field.
> ---
>  drivers/media/platform/mem2mem_testdev.c |  152 ++++++----------------
> --------
>  1 files changed, 28 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c
> b/drivers/media/platform/mem2mem_testdev.c
> index 6a17676..a348c07 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -177,8 +177,6 @@ struct m2mtest_ctx {
> 
>  	enum v4l2_colorspace	colorspace;
> 
> -	struct v4l2_m2m_ctx	*m2m_ctx;
> -
>  	/* Source and destination queue data */
>  	struct m2mtest_q_data   q_data[2];
>  };
> @@ -342,8 +340,8 @@ static int job_ready(void *priv)  {
>  	struct m2mtest_ctx *ctx = priv;
> 
> -	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < ctx->translen
> -	    || v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) < ctx->translen)
> {
> +	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < ctx->translen
> +	    || v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < ctx-
> >translen) {
>  		dprintk(ctx->dev, "Not enough buffers available\n");
>  		return 0;
>  	}
> @@ -359,21 +357,6 @@ static void job_abort(void *priv)
>  	ctx->aborting = 1;
>  }
> 
> -static void m2mtest_lock(void *priv)
> -{
> -	struct m2mtest_ctx *ctx = priv;
> -	struct m2mtest_dev *dev = ctx->dev;
> -	mutex_lock(&dev->dev_mutex);
> -}
> -
> -static void m2mtest_unlock(void *priv)
> -{
> -	struct m2mtest_ctx *ctx = priv;
> -	struct m2mtest_dev *dev = ctx->dev;
> -	mutex_unlock(&dev->dev_mutex);
> -}
> -
> -
>  /* device_run() - prepares and starts the device
>   *
>   * This simulates all the immediate preparations required before
> starting @@ -386,8 +369,8 @@ static void device_run(void *priv)
>  	struct m2mtest_dev *dev = ctx->dev;
>  	struct vb2_buffer *src_buf, *dst_buf;
> 
> -	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> -	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> 
>  	device_process(ctx, src_buf, dst_buf);
> 
> @@ -409,8 +392,8 @@ static void device_isr(unsigned long priv)
>  		return;
>  	}
> 
> -	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
> -	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> +	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->fh.m2m_ctx);
> +	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->fh.m2m_ctx);
> 
>  	curr_ctx->num_processed++;
> 
> @@ -423,7 +406,7 @@ static void device_isr(unsigned long priv)
>  	    || curr_ctx->aborting) {
>  		dprintk(curr_ctx->dev, "Finishing transaction\n");
>  		curr_ctx->num_processed = 0;
> -		v4l2_m2m_job_finish(m2mtest_dev->m2m_dev, curr_ctx-
> >m2m_ctx);
> +		v4l2_m2m_job_finish(m2mtest_dev->m2m_dev, curr_ctx-
> >fh.m2m_ctx);
>  	} else {
>  		device_run(curr_ctx);
>  	}
> @@ -491,7 +474,7 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx,
> struct v4l2_format *f)
>  	struct vb2_queue *vq;
>  	struct m2mtest_q_data *q_data;
> 
> -	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>  	if (!vq)
>  		return -EINVAL;
> 
> @@ -594,7 +577,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx,
> struct v4l2_format *f)
>  	struct m2mtest_q_data *q_data;
>  	struct vb2_queue *vq;
> 
> -	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>  	if (!vq)
>  		return -EINVAL;
> 
> @@ -648,52 +631,6 @@ static int vidioc_s_fmt_vid_out(struct file *file,
> void *priv,
>  	return ret;
>  }
> 
> -static int vidioc_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *reqbufs)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> -}
> -
> -static int vidioc_querybuf(struct file *file, void *priv,
> -			   struct v4l2_buffer *buf)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_qbuf(struct file *file, void *priv, struct
> v4l2_buffer *buf) -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *priv, struct
> v4l2_buffer *buf) -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_streamon(struct file *file, void *priv,
> -			   enum v4l2_buf_type type)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *priv,
> -			    enum v4l2_buf_type type)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> -}
> -
>  static int m2mtest_s_ctrl(struct v4l2_ctrl *ctrl)  {
>  	struct m2mtest_ctx *ctx =
> @@ -748,14 +685,14 @@ static const struct v4l2_ioctl_ops
> m2mtest_ioctl_ops = {
>  	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
>  	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
> 
> -	.vidioc_reqbufs		= vidioc_reqbufs,
> -	.vidioc_querybuf	= vidioc_querybuf,
> +	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
> 
> -	.vidioc_qbuf		= vidioc_qbuf,
> -	.vidioc_dqbuf		= vidioc_dqbuf,
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
> 
> -	.vidioc_streamon	= vidioc_streamon,
> -	.vidioc_streamoff	= vidioc_streamoff,
>  	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,  }; @@ -
> 818,27 +755,15 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
> static void m2mtest_buf_queue(struct vb2_buffer *vb)  {
>  	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> -	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> -}
> -
> -static void m2mtest_wait_prepare(struct vb2_queue *q) -{
> -	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> -	m2mtest_unlock(ctx);
> -}
> -
> -static void m2mtest_wait_finish(struct vb2_queue *q) -{
> -	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> -	m2mtest_lock(ctx);
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
>  }
> 
>  static struct vb2_ops m2mtest_qops = {
>  	.queue_setup	 = m2mtest_queue_setup,
>  	.buf_prepare	 = m2mtest_buf_prepare,
>  	.buf_queue	 = m2mtest_buf_queue,
> -	.wait_prepare	 = m2mtest_wait_prepare,
> -	.wait_finish	 = m2mtest_wait_finish,
> +	.wait_prepare	 = vb2_ops_wait_prepare,
> +	.wait_finish	 = vb2_ops_wait_finish,
>  };
> 
>  static int queue_init(void *priv, struct vb2_queue *src_vq, struct
> vb2_queue *dst_vq) @@ -853,6 +778,7 @@ static int queue_init(void *priv,
> struct vb2_queue *src_vq, struct vb2_queue *ds
>  	src_vq->ops = &m2mtest_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
>  	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
> 
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -865,6 +791,7 @@ static int queue_init(void *priv, struct vb2_queue
> *src_vq, struct vb2_queue *ds
>  	dst_vq->ops = &m2mtest_qops;
>  	dst_vq->mem_ops = &vb2_vmalloc_memops;
>  	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
> 
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -936,10 +863,10 @@ static int m2mtest_open(struct file *file)
>  	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
>  	ctx->colorspace = V4L2_COLORSPACE_REC709;
> 
> -	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> &queue_init);
> 
> -	if (IS_ERR(ctx->m2m_ctx)) {
> -		rc = PTR_ERR(ctx->m2m_ctx);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		rc = PTR_ERR(ctx->fh.m2m_ctx);
> 
>  		v4l2_ctrl_handler_free(hdl);
>  		kfree(ctx);
> @@ -949,7 +876,8 @@ static int m2mtest_open(struct file *file)
>  	v4l2_fh_add(&ctx->fh);
>  	atomic_inc(&dev->num_inst);
> 
> -	dprintk(dev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx-
> >m2m_ctx);
> +	dprintk(dev, "Created instance: %p, m2m_ctx: %p\n",
> +		ctx, ctx->fh.m2m_ctx);
> 
>  open_unlock:
>  	mutex_unlock(&dev->dev_mutex);
> @@ -967,7 +895,7 @@ static int m2mtest_release(struct file *file)
>  	v4l2_fh_exit(&ctx->fh);
>  	v4l2_ctrl_handler_free(&ctx->hdl);
>  	mutex_lock(&dev->dev_mutex);
> -	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>  	mutex_unlock(&dev->dev_mutex);
>  	kfree(ctx);
> 
> @@ -976,34 +904,13 @@ static int m2mtest_release(struct file *file)
>  	return 0;
>  }
> 
> -static unsigned int m2mtest_poll(struct file *file,
> -				 struct poll_table_struct *wait)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> -}
> -
> -static int m2mtest_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct m2mtest_dev *dev = video_drvdata(file);
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -	int res;
> -
> -	if (mutex_lock_interruptible(&dev->dev_mutex))
> -		return -ERESTARTSYS;
> -	res = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> -	mutex_unlock(&dev->dev_mutex);
> -	return res;
> -}
> -
>  static const struct v4l2_file_operations m2mtest_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= m2mtest_open,
>  	.release	= m2mtest_release,
> -	.poll		= m2mtest_poll,
> +	.poll		= v4l2_m2m_fop_poll,
>  	.unlocked_ioctl	= video_ioctl2,
> -	.mmap		= m2mtest_mmap,
> +	.mmap		= v4l2_m2m_fop_mmap,
>  };
> 
>  static struct video_device m2mtest_videodev = { @@ -1019,8 +926,6 @@
> static struct v4l2_m2m_ops m2m_ops = {
>  	.device_run	= device_run,
>  	.job_ready	= job_ready,
>  	.job_abort	= job_abort,
> -	.lock		= m2mtest_lock,
> -	.unlock		= m2mtest_unlock,
>  };
> 
>  static int m2mtest_probe(struct platform_device *pdev) @@ -1134,4
> +1039,3 @@ static int __init m2mtest_init(void)
> 
>  module_init(m2mtest_init);
>  module_exit(m2mtest_exit);
> -
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

