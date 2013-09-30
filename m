Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2054 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3I3Jp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 05:45:59 -0400
Message-ID: <52494846.2000702@xs4all.nl>
Date: Mon, 30 Sep 2013 11:45:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	pawel@osciak.com, javier.martin@vista-silicon.com,
	m.szyprowski@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 4/7] s5p-jpeg: Use mem-to-mem ioctl helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com> <1379076986-10446-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1379076986-10446-5-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2013 02:56 PM, Sylwester Nawrocki wrote:
> Simplify the driver by using the m2m ioctl and vb2 helpers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |  111 ++++-----------------------
>  1 file changed, 13 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 88c5beb..66f7519 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -322,6 +322,7 @@ static int s5p_jpeg_open(struct file *file)
>  		ret = PTR_ERR(ctx->m2m_ctx);
>  		goto error;
>  	}
> +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
>  
>  	ctx->out_q.fmt = out_fmt;
>  	ctx->cap_q.fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_YUYV);
> @@ -353,39 +354,13 @@ static int s5p_jpeg_release(struct file *file)
>  	return 0;
>  }
>  
> -static unsigned int s5p_jpeg_poll(struct file *file,
> -				 struct poll_table_struct *wait)
> -{
> -	struct s5p_jpeg *jpeg = video_drvdata(file);
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
> -	unsigned int res;
> -
> -	mutex_lock(&jpeg->lock);
> -	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> -	mutex_unlock(&jpeg->lock);
> -	return res;
> -}
> -
> -static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct s5p_jpeg *jpeg = video_drvdata(file);
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
> -	int ret;
> -
> -	if (mutex_lock_interruptible(&jpeg->lock))
> -		return -ERESTARTSYS;
> -	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> -	mutex_unlock(&jpeg->lock);
> -	return ret;
> -}
> -
>  static const struct v4l2_file_operations s5p_jpeg_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= s5p_jpeg_open,
>  	.release	= s5p_jpeg_release,
> -	.poll		= s5p_jpeg_poll,
> +	.poll		= v4l2_m2m_fop_poll,
>  	.unlocked_ioctl	= video_ioctl2,
> -	.mmap		= s5p_jpeg_mmap,
> +	.mmap		= v4l2_m2m_fop_mmap,
>  };
>  
>  /*
> @@ -793,53 +768,6 @@ static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
>  	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
>  }
>  
> -static int s5p_jpeg_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *reqbufs)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> -}
> -
> -static int s5p_jpeg_querybuf(struct file *file, void *priv,
> -			   struct v4l2_buffer *buf)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int s5p_jpeg_dqbuf(struct file *file, void *priv,
> -			  struct v4l2_buffer *buf)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int s5p_jpeg_streamon(struct file *file, void *priv,
> -			   enum v4l2_buf_type type)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> -}
> -
> -static int s5p_jpeg_streamoff(struct file *file, void *priv,
> -			    enum v4l2_buf_type type)
> -{
> -	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
> -
> -	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> -}
> -
>  static int s5p_jpeg_g_selection(struct file *file, void *priv,
>  			 struct v4l2_selection *s)
>  {
> @@ -973,14 +901,13 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
>  	.vidioc_s_fmt_vid_cap		= s5p_jpeg_s_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_out		= s5p_jpeg_s_fmt_vid_out,
>  
> -	.vidioc_reqbufs			= s5p_jpeg_reqbufs,
> -	.vidioc_querybuf		= s5p_jpeg_querybuf,
> -
> -	.vidioc_qbuf			= s5p_jpeg_qbuf,
> -	.vidioc_dqbuf			= s5p_jpeg_dqbuf,
> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
>  
> -	.vidioc_streamon		= s5p_jpeg_streamon,
> -	.vidioc_streamoff		= s5p_jpeg_streamoff,
> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
>  
>  	.vidioc_g_selection		= s5p_jpeg_g_selection,
>  };
> @@ -1175,20 +1102,6 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
>  }
>  
> -static void s5p_jpeg_wait_prepare(struct vb2_queue *vq)
> -{
> -	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
> -
> -	mutex_unlock(&ctx->jpeg->lock);
> -}
> -
> -static void s5p_jpeg_wait_finish(struct vb2_queue *vq)
> -{
> -	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
> -
> -	mutex_lock(&ctx->jpeg->lock);
> -}
> -
>  static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
>  	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
> @@ -1212,8 +1125,8 @@ static struct vb2_ops s5p_jpeg_qops = {
>  	.queue_setup		= s5p_jpeg_queue_setup,
>  	.buf_prepare		= s5p_jpeg_buf_prepare,
>  	.buf_queue		= s5p_jpeg_buf_queue,
> -	.wait_prepare		= s5p_jpeg_wait_prepare,
> -	.wait_finish		= s5p_jpeg_wait_finish,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
>  	.start_streaming	= s5p_jpeg_start_streaming,
>  	.stop_streaming		= s5p_jpeg_stop_streaming,
>  };
> @@ -1231,6 +1144,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &s5p_jpeg_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->jpeg->lock;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -1243,6 +1157,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &s5p_jpeg_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->jpeg->lock;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> 

