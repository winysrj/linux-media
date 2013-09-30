Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1680 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3I3JsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 05:48:20 -0400
Message-ID: <524948CB.8010807@xs4all.nl>
Date: Mon, 30 Sep 2013 11:47:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	pawel@osciak.com, javier.martin@vista-silicon.com,
	m.szyprowski@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 5/7] mx2-emmaprp: Use mem-to-mem ioctl helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com> <1379076986-10446-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1379076986-10446-6-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2013 02:56 PM, Sylwester Nawrocki wrote:
> Simplify the driver by using the m2m ioctl and vb2 helpers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/mx2_emmaprp.c |  108 ++++------------------------------
>  1 file changed, 11 insertions(+), 97 deletions(-)
> 
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index c690435..a531862 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -253,20 +253,6 @@ static void emmaprp_job_abort(void *priv)
>  	v4l2_m2m_job_finish(pcdev->m2m_dev, ctx->m2m_ctx);
>  }
>  
> -static void emmaprp_lock(void *priv)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -	struct emmaprp_dev *pcdev = ctx->dev;
> -	mutex_lock(&pcdev->dev_mutex);
> -}
> -
> -static void emmaprp_unlock(void *priv)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -	struct emmaprp_dev *pcdev = ctx->dev;
> -	mutex_unlock(&pcdev->dev_mutex);
> -}
> -
>  static inline void emmaprp_dump_regs(struct emmaprp_dev *pcdev)
>  {
>  	dprintk(pcdev,
> @@ -617,52 +603,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
>  	return vidioc_s_fmt(priv, f);
>  }
>  
> -static int vidioc_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *reqbufs)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> -}
> -
> -static int vidioc_querybuf(struct file *file, void *priv,
> -			   struct v4l2_buffer *buf)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vidioc_streamon(struct file *file, void *priv,
> -			   enum v4l2_buf_type type)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *priv,
> -			    enum v4l2_buf_type type)
> -{
> -	struct emmaprp_ctx *ctx = priv;
> -
> -	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> -}
> -
>  static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
>  	.vidioc_querycap	= vidioc_querycap,
>  
> @@ -676,14 +616,13 @@ static const struct v4l2_ioctl_ops emmaprp_ioctl_ops = {
>  	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
>  	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
>  
> -	.vidioc_reqbufs		= vidioc_reqbufs,
> -	.vidioc_querybuf	= vidioc_querybuf,
> -
> -	.vidioc_qbuf		= vidioc_qbuf,
> -	.vidioc_dqbuf		= vidioc_dqbuf,
> +	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
>  
> -	.vidioc_streamon	= vidioc_streamon,
> -	.vidioc_streamoff	= vidioc_streamoff,
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
>  };
>  
>  
> @@ -767,6 +706,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &emmaprp_qops;
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->dev->dev_mutex;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -779,6 +719,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->ops = &emmaprp_qops;
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->dev->dev_mutex;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -812,6 +753,7 @@ static int emmaprp_open(struct file *file)
>  		kfree(ctx);
>  		return ret;
>  	}
> +	/* TODO: Assign fh->m2m_ctx, needs conversion to struct v4l2_fh first */

What's the point of adding this patch if it won't work yet?

Regards,

	Hans

>  
>  	clk_prepare_enable(pcdev->clk_emma_ipg);
>  	clk_prepare_enable(pcdev->clk_emma_ahb);
> @@ -841,39 +783,13 @@ static int emmaprp_release(struct file *file)
>  	return 0;
>  }
>  
> -static unsigned int emmaprp_poll(struct file *file,
> -				 struct poll_table_struct *wait)
> -{
> -	struct emmaprp_dev *pcdev = video_drvdata(file);
> -	struct emmaprp_ctx *ctx = file->private_data;
> -	unsigned int res;
> -
> -	mutex_lock(&pcdev->dev_mutex);
> -	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> -	mutex_unlock(&pcdev->dev_mutex);
> -	return res;
> -}
> -
> -static int emmaprp_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct emmaprp_dev *pcdev = video_drvdata(file);
> -	struct emmaprp_ctx *ctx = file->private_data;
> -	int ret;
> -
> -	if (mutex_lock_interruptible(&pcdev->dev_mutex))
> -		return -ERESTARTSYS;
> -	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> -	mutex_unlock(&pcdev->dev_mutex);
> -	return ret;
> -}
> -
>  static const struct v4l2_file_operations emmaprp_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= emmaprp_open,
>  	.release	= emmaprp_release,
> -	.poll		= emmaprp_poll,
> +	.poll		= v4l2_m2m_fop_poll,
>  	.unlocked_ioctl	= video_ioctl2,
> -	.mmap		= emmaprp_mmap,
> +	.mmap		= v4l2_m2m_fop_mmap,
>  };
>  
>  static struct video_device emmaprp_videodev = {
> @@ -888,8 +804,6 @@ static struct video_device emmaprp_videodev = {
>  static struct v4l2_m2m_ops m2m_ops = {
>  	.device_run	= emmaprp_device_run,
>  	.job_abort	= emmaprp_job_abort,
> -	.lock		= emmaprp_lock,
> -	.unlock		= emmaprp_unlock,
>  };
>  
>  static int emmaprp_probe(struct platform_device *pdev)
> 

