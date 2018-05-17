Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751644AbeEQUlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 16:41:50 -0400
Date: Thu, 17 May 2018 23:41:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 25/28] vim2m: support requests
Message-ID: <20180517204147.d2z6eqhgcveagzje@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-26-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503145318.128315-26-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, May 03, 2018 at 04:53:15PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for requests to vim2m.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vim2m.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index a1b0bb08668d..7c86c711a4cd 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -387,8 +387,26 @@ static void device_run(void *priv)
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>  
> +	/* Apply request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +	if (dst_buf->vb2_buf.req_obj.req &&
> +	    dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_setup(dst_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);

This seems wrong: you're making use of control values from two *different*,
*unrelated* requests.

I'd rather like that we didn't end up a request API for the mem2mem devices
and another for the rest... albeit the kernel implementation could be the
same or similar, it's still the uAPI that would have differing semantics
between the two.

> +
>  	device_process(ctx, src_buf, dst_buf);
>  
> +	/* Complete request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +	if (dst_buf->vb2_buf.req_obj.req &&
> +	    dst_buf->vb2_buf.req_obj.req != src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(dst_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	/* Run a timer, which simulates a hardware irq  */
>  	schedule_irq(dev, ctx->transtime);
>  }
> @@ -823,12 +841,21 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>  			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>  		if (vbuf == NULL)
>  			return;
> +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> +					   &ctx->hdl);
>  		spin_lock_irqsave(&ctx->dev->irqlock, flags);
>  		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
>  		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
>  	}
>  }
>  
> +static void vim2m_buf_request_complete(struct vb2_buffer *vb)
> +{
> +	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> +}
> +
>  static const struct vb2_ops vim2m_qops = {
>  	.queue_setup	 = vim2m_queue_setup,
>  	.buf_prepare	 = vim2m_buf_prepare,
> @@ -837,6 +864,7 @@ static const struct vb2_ops vim2m_qops = {
>  	.stop_streaming  = vim2m_stop_streaming,
>  	.wait_prepare	 = vb2_ops_wait_prepare,
>  	.wait_finish	 = vb2_ops_wait_finish,
> +	.buf_request_complete = vim2m_buf_request_complete,
>  };
>  
>  static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> @@ -1003,6 +1031,11 @@ static const struct v4l2_m2m_ops m2m_ops = {
>  	.job_abort	= job_abort,
>  };
>  
> +static const struct media_device_ops m2m_media_ops = {
> +	.req_validate = vb2_request_validate,
> +	.req_queue = vb2_m2m_request_queue,
> +};
> +
>  static int vim2m_probe(struct platform_device *pdev)
>  {
>  	struct vim2m_dev *dev;
> @@ -1027,6 +1060,7 @@ static int vim2m_probe(struct platform_device *pdev)
>  	dev->mdev.dev = &pdev->dev;
>  	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>  	media_device_init(&dev->mdev);
> +	dev->mdev.ops = &m2m_media_ops;
>  	dev->v4l2_dev.mdev = &dev->mdev;
>  	dev->pad[0].flags = MEDIA_PAD_FL_SINK;
>  	dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
