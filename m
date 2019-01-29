Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9D7C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2CBC2175B
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548777630;
	bh=lQhJKDaQpp6JwUI3UIGMBaEgdtObmW1LV6mQ3Kegrps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q4QRO579yiLPlK2T4FvlguYP5k602PN2BaLOWDMWWYYZFAOT2lMoHtMDKHES+qlTH
	 c8d6KFOwD9Sf+I11zKBX62Kw6cCLKf1X2n98M2N6LKJ4JVFzvi5ofPEFwo0S8zyLmK
	 aMjc2btgP5GWCEl0axiQuJu9unQN/ZQzzuXtr9wg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfA2QA1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfA2QA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sPpTiMWIgOhi3yU6eyNIva14qn4dMy6XfRuC8vP5GH4=; b=aIe7QwPPbBWRz4UMWsuNlOvWsw
        CAIWx2F9tgTQnC+mpG3H5YPSB5MtcmkXZnlH/Pp0sjPxy77vrTZQwreH/fhuowCg0x/wk7e0WoymF
        l8auKL0aAqZF9Zqr3bhPa3VWTmUyzpbSyCj9xCbwlotIw1zJQMCaBNvwMru0FpwCp1NfgiuZHj4aD
        X+oslEskYkvmhvDuOXpKyCtM2FnOITuBa/b1S3hXUoOawL1/k+CppTSK+O3aDGMWpvLhNdJni+jWa
        Y5RitHBMfvG8B9MDOZiSIUkcbQyL4Z9Ayji8lCSciDWC+PwL8Jzsegk3nSa58OWix6dcurnctRz8P
        iLC30+Zg==;
Received: from 177.43.31.175.dynamic.adsl.gvt.net.br ([177.43.31.175] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1goVoI-0006o3-K8; Tue, 29 Jan 2019 16:00:26 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1goVoD-0006UR-Av; Tue, 29 Jan 2019 14:00:21 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Anton Leontiev <scileont@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/3] media: vim2m: use per-file handler work queue
Date:   Tue, 29 Jan 2019 14:00:16 -0200
Message-Id: <7ff2d5c791473c746ae07c012d1890c6bdd08f6d.1548776693.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548776693.git.mchehab+samsung@kernel.org>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It doesn't make sense to have a per-device work queue, as the
scheduler should be called per file handler. Having a single
one causes failures if multiple streams are filtered by vim2m.

So, move it to be inside the context structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 38 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index ccd0576c766e..a9e43070567e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -146,9 +146,6 @@ struct vim2m_dev {
 
 	atomic_t		num_inst;
 	struct mutex		dev_mutex;
-	spinlock_t		irqlock;
-
-	struct delayed_work	work_run;
 
 	struct v4l2_m2m_dev	*m2m_dev;
 };
@@ -167,6 +164,10 @@ struct vim2m_ctx {
 	/* Transaction time (i.e. simulated processing time) in milliseconds */
 	u32			transtime;
 
+	struct mutex		vb_mutex;
+	struct delayed_work	work_run;
+	spinlock_t		irqlock;
+
 	/* Abort requested by m2m */
 	int			aborting;
 
@@ -490,7 +491,6 @@ static void job_abort(void *priv)
 static void device_run(void *priv)
 {
 	struct vim2m_ctx *ctx = priv;
-	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
@@ -507,18 +507,18 @@ static void device_run(void *priv)
 				   &ctx->hdl);
 
 	/* Run delayed work, which simulates a hardware irq  */
-	schedule_delayed_work(&dev->work_run, msecs_to_jiffies(ctx->transtime));
+	schedule_delayed_work(&ctx->work_run, msecs_to_jiffies(ctx->transtime));
 }
 
 static void device_work(struct work_struct *w)
 {
-	struct vim2m_dev *vim2m_dev =
-		container_of(w, struct vim2m_dev, work_run.work);
 	struct vim2m_ctx *curr_ctx;
+	struct vim2m_dev *vim2m_dev;
 	struct vb2_v4l2_buffer *src_vb, *dst_vb;
 	unsigned long flags;
 
-	curr_ctx = v4l2_m2m_get_curr_priv(vim2m_dev->m2m_dev);
+	curr_ctx = container_of(w, struct vim2m_ctx, work_run.work);
+	vim2m_dev = curr_ctx->dev;
 
 	if (NULL == curr_ctx) {
 		pr_err("Instance released before the end of transaction\n");
@@ -530,10 +530,10 @@ static void device_work(struct work_struct *w)
 
 	curr_ctx->num_processed++;
 
-	spin_lock_irqsave(&vim2m_dev->irqlock, flags);
+	spin_lock_irqsave(&curr_ctx->irqlock, flags);
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
-	spin_unlock_irqrestore(&vim2m_dev->irqlock, flags);
+	spin_unlock_irqrestore(&curr_ctx->irqlock, flags);
 
 	if (curr_ctx->num_processed == curr_ctx->translen
 	    || curr_ctx->aborting) {
@@ -893,11 +893,10 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
-	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;
 
-	cancel_delayed_work_sync(&dev->work_run);
+	cancel_delayed_work_sync(&ctx->work_run);
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
@@ -907,9 +906,9 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 			return;
 		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
 					   &ctx->hdl);
-		spin_lock_irqsave(&ctx->dev->irqlock, flags);
+		spin_lock_irqsave(&ctx->irqlock, flags);
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
-		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+		spin_unlock_irqrestore(&ctx->irqlock, flags);
 	}
 }
 
@@ -943,7 +942,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->ops = &vim2m_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->lock = &ctx->vb_mutex;
 	src_vq->supports_requests = true;
 
 	ret = vb2_queue_init(src_vq);
@@ -957,7 +956,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	dst_vq->ops = &vim2m_qops;
 	dst_vq->mem_ops = &vb2_vmalloc_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	dst_vq->lock = &ctx->dev->dev_mutex;
+	dst_vq->lock = &ctx->vb_mutex;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1032,6 +1031,10 @@ static int vim2m_open(struct file *file)
 
 	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 
+	mutex_init(&ctx->vb_mutex);
+	spin_lock_init(&ctx->irqlock);
+	INIT_DELAYED_WORK(&ctx->work_run, device_work);
+
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
 		rc = PTR_ERR(ctx->fh.m2m_ctx);
 
@@ -1112,8 +1115,6 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
-	spin_lock_init(&dev->irqlock);
-
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
@@ -1125,7 +1126,6 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
-	INIT_DELAYED_WORK(&dev->work_run, device_work);
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
-- 
2.20.1

