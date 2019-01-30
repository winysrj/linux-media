Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C3CC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA172184D
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548854383;
	bh=iaUll6aG97PKTfmRI6suvZhftZi0MYKbInLC6mUsl/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=eDcJPg4jLH0l1j/6cyZHiHpsKriJPd7VNHPl/DpY+iXr5xPi9tUs+Mu2rfFmRe+ln
	 ZUCm77mLyPpafbFCwLqDjiSQ9VQ8fFP5qF4KrKtdCJIRd5QaQaQdZ20jMoADuYTAaf
	 +frpxsufwHfUpg+czek6uXDrF6Cd2zekeX3TCopE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbfA3NTm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:19:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3NTl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 08:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1FoN2GzDlLHxKe9YvlkgfJRwdy4T6LwhA6SiSQ9lL8g=; b=ne9ffId1hDZtBxJwpRwtWYrzU
        pDKFJDlkAeCyPqTEoKRP/rdTXIsphnFuYbY+qNhYEbKWgJ32Nlb/Td7B6LGSncHKSnL/Pa19aJdwr
        qt7ezP01d1rG/8XlkKm40TWKfIi+Bdl9RCEcAp7WqqiSrAGdxUvTukjrAD50zAOu15gD+1+0ggHp3
        /PAKY7TTqnXNV2H6yG0yLMIDuPobc8P8HqqaHvqpeIbPTJoq9mbu3SZN6h08FXagwjwtIsJCLU3TI
        a6FTrDkriex9KEY4BsDcTIC+hcnppjYIgBe73kjVYWw2KmjFemv3cZlMz8fZa4HMl7R9TaJfIURo3
        t3yu6KaFw==;
Received: from 177.43.31.175.dynamic.adsl.gvt.net.br ([177.43.31.175] helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gopmF-0004HX-Gu; Wed, 30 Jan 2019 13:19:40 +0000
Date:   Wed, 30 Jan 2019 11:19:33 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Anton Leontiev <scileont@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 2/3] media: vim2m: use per-file handler work queue
Message-ID: <20190130111933.313ed5a0@silica.lan>
In-Reply-To: <0f25ab2f936e3fcb8cd68b55682838027e46eec5.camel@collabora.com>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
        <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
        <0f25ab2f936e3fcb8cd68b55682838027e46eec5.camel@collabora.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 30 Jan 2019 09:41:44 -0300
Ezequiel Garcia <ezequiel@collabora.com> escreveu:

> On Tue, 2019-01-29 at 14:00 -0200, Mauro Carvalho Chehab wrote:
> > It doesn't make sense to have a per-device work queue, as the
> > scheduler should be called per file handler. Having a single
> > one causes failures if multiple streams are filtered by vim2m.
> >   
> 
> Having a per-device workqueue should emulate a real device more closely.

Yes.

> But more importantly, why would having a single workqeueue fail if multiple
> streams are run? The m2m should take care of the proper serialization
> between multiple contexts, unless I am missing something here.

Yes, the m2m core serializes the access to m2m src/dest buffer per device.

So, two instances can't access the buffer at the same time. That makes
sense for a real physical hardware, although specifically for the virtual
one, it doesn't (any may not make sense for some stateless codec, if
the codec would internally be able to handle multiple requests at the same
time).

Without this patch, when multiple instances are used, sometimes it ends 
into a dead lock preventing to stop all of them.

I didn't have time to debug where exactly it happens, but I suspect that
the issue is related to using the same mutex for both VB and open/release
instances.

Yet, I ended by opting to move all queue-specific mutex/semaphore to be
instance-based, as this makes a lot more sense, IMHO. Also, if some day
we end by allowing support for some hardware that would have support to
run multiple m2m instances in parallel, vim2m would already be ready.


> 
> Thanks,
> Eze
> 
> > So, move it to be inside the context structure.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/platform/vim2m.c | 38 +++++++++++++++++-----------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> > index ccd0576c766e..a9e43070567e 100644
> > --- a/drivers/media/platform/vim2m.c
> > +++ b/drivers/media/platform/vim2m.c
> > @@ -146,9 +146,6 @@ struct vim2m_dev {
> >  
> >  	atomic_t		num_inst;
> >  	struct mutex		dev_mutex;
> > -	spinlock_t		irqlock;
> > -
> > -	struct delayed_work	work_run;
> >  
> >  	struct v4l2_m2m_dev	*m2m_dev;
> >  };
> > @@ -167,6 +164,10 @@ struct vim2m_ctx {
> >  	/* Transaction time (i.e. simulated processing time) in milliseconds */
> >  	u32			transtime;
> >  
> > +	struct mutex		vb_mutex;
> > +	struct delayed_work	work_run;
> > +	spinlock_t		irqlock;
> > +
> >  	/* Abort requested by m2m */
> >  	int			aborting;
> >  
> > @@ -490,7 +491,6 @@ static void job_abort(void *priv)
> >  static void device_run(void *priv)
> >  {
> >  	struct vim2m_ctx *ctx = priv;
> > -	struct vim2m_dev *dev = ctx->dev;
> >  	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> >  
> >  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > @@ -507,18 +507,18 @@ static void device_run(void *priv)
> >  				   &ctx->hdl);
> >  
> >  	/* Run delayed work, which simulates a hardware irq  */
> > -	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
> > +	schedule_delayed_work(&ctx->work_run, msecs_to_jiffies(ctx->transtime));
> >  }
> >  
> >  static void device_work(struct work_struct *w)
> >  {
> > -	struct vim2m_dev *vim2m_dev =
> > -		container_of(w, struct vim2m_dev, work_run.work);
> >  	struct vim2m_ctx *curr_ctx;
> > +	struct vim2m_dev *vim2m_dev;
> >  	struct vb2_v4l2_buffer *src_vb, *dst_vb;
> >  	unsigned long flags;
> >  
> > -	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
> > +	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
> > +	vim2m_dev = curr_ctx->dev;
> >  
> >  	if (NULL == curr_ctx) {
> >  		pr_err("Instance released before the end of transaction\n");
> > @@ -530,10 +530,10 @@ static void device_work(struct work_struct *w)
> >  
> >  	curr_ctx->num_processed++;
> >  
> > -	spin_lock_irqsave(&vim2m_dev->irqlock, flags);
> > +	spin_lock_irqsave(&curr_ctx->irqlock, flags);
> >  	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> >  	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> > -	spin_unlock_irqrestore(&vim2m_dev->irqlock, flags);
> > +	spin_unlock_irqrestore(&curr_ctx->irqlock, flags);
> >  
> >  	if (curr_ctx->num_processed == curr_ctx->translen
> >  	    || curr_ctx->aborting) {
> > @@ -893,11 +893,10 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
> >  static void vim2m_stop_streaming(struct vb2_queue *q)
> >  {
> >  	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
> > -	struct vim2m_dev *dev = ctx->dev;
> >  	struct vb2_v4l2_buffer *vbuf;
> >  	unsigned long flags;
> >  
> > -	cancel_delayed_work_sync(&dev->work_run);
> > +	cancel_delayed_work_sync(&ctx->work_run);
> >  	for (;;) {
> >  		if (V4L2_TYPE_IS_OUTPUT(q->type))
> >  			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > @@ -907,9 +906,9 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
> >  			return;
> >  		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> >  					   &ctx->hdl);
> > -		spin_lock_irqsave(&ctx->dev->irqlock, flags);
> > +		spin_lock_irqsave(&ctx->irqlock, flags);
> >  		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > -		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
> > +		spin_unlock_irqrestore(&ctx->irqlock, flags);
> >  	}
> >  }
> >  
> > @@ -943,7 +942,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
> >  	src_vq->ops = &vim2m_qops;
> >  	src_vq->mem_ops = &vb2_vmalloc_memops;
> >  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > -	src_vq->lock = &ctx->dev->dev_mutex;
> > +	src_vq->lock = &ctx->vb_mutex;
> >  	src_vq->supports_requests = true;
> >  
> >  	ret = vb2_queue_init(src_vq);
> > @@ -957,7 +956,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
> >  	dst_vq->ops = &vim2m_qops;
> >  	dst_vq->mem_ops = &vb2_vmalloc_memops;
> >  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > -	dst_vq->lock = &ctx->dev->dev_mutex;
> > +	dst_vq->lock = &ctx->vb_mutex;
> >  
> >  	return vb2_queue_init(dst_vq);
> >  }
> > @@ -1032,6 +1031,10 @@ static int vim2m_open(struct file *file)
> >  
> >  	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> >  
> > +	mutex_init(&ctx->vb_mutex);
> > +	spin_lock_init(&ctx->irqlock);
> > +	INIT_DELAYED_WORK(&ctx->work_run, device_work);
> > +
> >  	if (IS_ERR(ctx->fh.m2m_ctx)) {
> >  		rc = PTR_ERR(ctx->fh.m2m_ctx);
> >  
> > @@ -1112,8 +1115,6 @@ static int vim2m_probe(struct platform_device *pdev)
> >  	if (!dev)
> >  		return -ENOMEM;
> >  
> > -	spin_lock_init(&dev->irqlock);
> > -
> >  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> >  	if (ret)
> >  		return ret;
> > @@ -1125,7 +1126,6 @@ static int vim2m_probe(struct platform_device *pdev)
> >  	vfd = &dev->vfd;
> >  	vfd->lock = &dev->dev_mutex;
> >  	vfd->v4l2_dev = &dev->v4l2_dev;
> > -	INIT_DELAYED_WORK(&dev->work_run, device_work);
> >  
> >  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> >  	if (ret) {  
> 
> 




Cheers,
Mauro
