Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFF5C282D8
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 12:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D997E218A3
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 12:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfA3Ml4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:41:56 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3Ml4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 07:41:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id CD2D727DE8E
Message-ID: <0f25ab2f936e3fcb8cd68b55682838027e46eec5.camel@collabora.com>
Subject: Re: [PATCH 2/3] media: vim2m: use per-file handler work queue
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Anton Leontiev <scileont@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Wed, 30 Jan 2019 09:41:44 -0300
In-Reply-To: <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
         <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-01-29 at 14:00 -0200, Mauro Carvalho Chehab wrote:
> It doesn't make sense to have a per-device work queue, as the
> scheduler should be called per file handler. Having a single
> one causes failures if multiple streams are filtered by vim2m.
> 

Having a per-device workqueue should emulate a real device more closely.

But more importantly, why would having a single workqeueue fail if multiple
streams are run? The m2m should take care of the proper serialization
between multiple contexts, unless I am missing something here.

Thanks,
Eze

> So, move it to be inside the context structure.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/vim2m.c | 38 +++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index ccd0576c766e..a9e43070567e 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -146,9 +146,6 @@ struct vim2m_dev {
>  
>  	atomic_t		num_inst;
>  	struct mutex		dev_mutex;
> -	spinlock_t		irqlock;
> -
> -	struct delayed_work	work_run;
>  
>  	struct v4l2_m2m_dev	*m2m_dev;
>  };
> @@ -167,6 +164,10 @@ struct vim2m_ctx {
>  	/* Transaction time (i.e. simulated processing time) in milliseconds */
>  	u32			transtime;
>  
> +	struct mutex		vb_mutex;
> +	struct delayed_work	work_run;
> +	spinlock_t		irqlock;
> +
>  	/* Abort requested by m2m */
>  	int			aborting;
>  
> @@ -490,7 +491,6 @@ static void job_abort(void *priv)
>  static void device_run(void *priv)
>  {
>  	struct vim2m_ctx *ctx = priv;
> -	struct vim2m_dev *dev = ctx->dev;
>  	struct vb2_v4l2_buffer *src_buf, *dst_buf;
>  
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> @@ -507,18 +507,18 @@ static void device_run(void *priv)
>  				   &ctx->hdl);
>  
>  	/* Run delayed work, which simulates a hardware irq  */
> -	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
> +	schedule_delayed_work(&ctx->work_run, msecs_to_jiffies(ctx->transtime));
>  }
>  
>  static void device_work(struct work_struct *w)
>  {
> -	struct vim2m_dev *vim2m_dev =
> -		container_of(w, struct vim2m_dev, work_run.work);
>  	struct vim2m_ctx *curr_ctx;
> +	struct vim2m_dev *vim2m_dev;
>  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
>  	unsigned long flags;
>  
> -	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
> +	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
> +	vim2m_dev = curr_ctx->dev;
>  
>  	if (NULL == curr_ctx) {
>  		pr_err("Instance released before the end of transaction\n");
> @@ -530,10 +530,10 @@ static void device_work(struct work_struct *w)
>  
>  	curr_ctx->num_processed++;
>  
> -	spin_lock_irqsave(&vim2m_dev->irqlock, flags);
> +	spin_lock_irqsave(&curr_ctx->irqlock, flags);
>  	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> -	spin_unlock_irqrestore(&vim2m_dev->irqlock, flags);
> +	spin_unlock_irqrestore(&curr_ctx->irqlock, flags);
>  
>  	if (curr_ctx->num_processed == curr_ctx->translen
>  	    || curr_ctx->aborting) {
> @@ -893,11 +893,10 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
>  static void vim2m_stop_streaming(struct vb2_queue *q)
>  {
>  	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
> -	struct vim2m_dev *dev = ctx->dev;
>  	struct vb2_v4l2_buffer *vbuf;
>  	unsigned long flags;
>  
> -	cancel_delayed_work_sync(&dev->work_run);
> +	cancel_delayed_work_sync(&ctx->work_run);
>  	for (;;) {
>  		if (V4L2_TYPE_IS_OUTPUT(q->type))
>  			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> @@ -907,9 +906,9 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
>  			return;
>  		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
>  					   &ctx->hdl);
> -		spin_lock_irqsave(&ctx->dev->irqlock, flags);
> +		spin_lock_irqsave(&ctx->irqlock, flags);
>  		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> -		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
> +		spin_unlock_irqrestore(&ctx->irqlock, flags);
>  	}
>  }
>  
> @@ -943,7 +942,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	src_vq->ops = &vim2m_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	src_vq->lock = &ctx->dev->dev_mutex;
> +	src_vq->lock = &ctx->vb_mutex;
>  	src_vq->supports_requests = true;
>  
>  	ret = vb2_queue_init(src_vq);
> @@ -957,7 +956,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
>  	dst_vq->ops = &vim2m_qops;
>  	dst_vq->mem_ops = &vb2_vmalloc_memops;
>  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	dst_vq->lock = &ctx->dev->dev_mutex;
> +	dst_vq->lock = &ctx->vb_mutex;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -1032,6 +1031,10 @@ static int vim2m_open(struct file *file)
>  
>  	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
>  
> +	mutex_init(&ctx->vb_mutex);
> +	spin_lock_init(&ctx->irqlock);
> +	INIT_DELAYED_WORK(&ctx->work_run, device_work);
> +
>  	if (IS_ERR(ctx->fh.m2m_ctx)) {
>  		rc = PTR_ERR(ctx->fh.m2m_ctx);
>  
> @@ -1112,8 +1115,6 @@ static int vim2m_probe(struct platform_device *pdev)
>  	if (!dev)
>  		return -ENOMEM;
>  
> -	spin_lock_init(&dev->irqlock);
> -
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
>  		return ret;
> @@ -1125,7 +1126,6 @@ static int vim2m_probe(struct platform_device *pdev)
>  	vfd = &dev->vfd;
>  	vfd->lock = &dev->dev_mutex;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
> -	INIT_DELAYED_WORK(&dev->work_run, device_work);
>  
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {


