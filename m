Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50753 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3IMNIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:25 -0400
Message-ID: <1379077699.4396.16.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH RFC 2/7] mem2mem_testdev: Use mem-to-mem ioctl and vb2
 helpers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Date: Fri, 13 Sep 2013 15:08:19 +0200
In-Reply-To: <1379076986-10446-3-git-send-email-s.nawrocki@samsung.com>
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com>
	 <1379076986-10446-3-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Am Freitag, den 13.09.2013, 14:56 +0200 schrieb Sylwester Nawrocki:
> Simplify the driver by using the m2m ioctl and vb2 helpers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/mem2mem_testdev.c |   94 ++++--------------------------
>  1 file changed, 11 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 6a17676..73df44f 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -359,21 +359,6 @@ static void job_abort(void *priv)
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
>   * This simulates all the immediate preparations required before starting
> @@ -648,52 +633,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
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
> -static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct m2mtest_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
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
>  static int m2mtest_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct m2mtest_ctx *ctx =
> @@ -748,14 +687,14 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
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
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
> @@ -821,24 +760,12 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
>  	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
>  }
>  
> -static void m2mtest_wait_prepare(struct vb2_queue *q)
> -{
> -	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> -	m2mtest_unlock(ctx);
> -}
> -
> -static void m2mtest_wait_finish(struct vb2_queue *q)
> -{
> -	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> -	m2mtest_lock(ctx);
> -}
> -
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
>  static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> @@ -853,6 +780,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	src_vq->ops = &m2mtest_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
>  	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -865,6 +793,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	dst_vq->ops = &m2mtest_qops;
>  	dst_vq->mem_ops = &vb2_vmalloc_memops;
>  	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -945,6 +874,7 @@ static int m2mtest_open(struct file *file)
>  		kfree(ctx);
>  		goto open_unlock;
>  	}
> +	ctx->fh.m2m_ctx = ctx->m2m_ctx;

Since you added m2m_ctx to v4l2_fh, why not drop ctx->m2m_ctx altogether
and always use ctx->fh.m2m_ctx instead?

>  	v4l2_fh_add(&ctx->fh);
>  	atomic_inc(&dev->num_inst);
> @@ -1019,8 +949,6 @@ static struct v4l2_m2m_ops m2m_ops = {
>  	.device_run	= device_run,
>  	.job_ready	= job_ready,
>  	.job_abort	= job_abort,
> -	.lock		= m2mtest_lock,
> -	.unlock		= m2mtest_unlock,
>  };
>  
>  static int m2mtest_probe(struct platform_device *pdev)

regards
Philipp

