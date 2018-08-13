Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbeHMRvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:51:42 -0400
Date: Mon, 13 Aug 2018 12:08:59 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 31/34] vim2m: support requests
Message-ID: <20180813120859.6bab28b5@coco.lan>
In-Reply-To: <20180804124526.46206-32-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-32-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:23 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for requests to vim2m.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  drivers/media/platform/vim2m.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 6f87ef025ff1..3b8df2c9d24a 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -379,8 +379,18 @@ static void device_run(void *priv)
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
>  
> +	/* Apply request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_setup(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	device_process(ctx, src_buf, dst_buf);
>  
> +	/* Complete request controls if needed */
> +	if (src_buf->vb2_buf.req_obj.req)
> +		v4l2_ctrl_request_complete(src_buf->vb2_buf.req_obj.req,
> +					&ctx->hdl);
> +
>  	/* Run delayed work, which simulates a hardware irq  */
>  	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
>  }
> @@ -808,12 +818,21 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
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
> @@ -822,6 +841,7 @@ static const struct vb2_ops vim2m_qops = {
>  	.stop_streaming  = vim2m_stop_streaming,
>  	.wait_prepare	 = vb2_ops_wait_prepare,
>  	.wait_finish	 = vb2_ops_wait_finish,
> +	.buf_request_complete = vim2m_buf_request_complete,
>  };
>  
>  static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> @@ -988,6 +1008,11 @@ static const struct v4l2_m2m_ops m2m_ops = {
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
> @@ -1036,6 +1061,7 @@ static int vim2m_probe(struct platform_device *pdev)
>  	dev->mdev.dev = &pdev->dev;
>  	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
>  	media_device_init(&dev->mdev);
> +	dev->mdev.ops = &m2m_media_ops;
>  	dev->v4l2_dev.mdev = &dev->mdev;
>  
>  	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,



Thanks,
Mauro
