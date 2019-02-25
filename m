Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA03C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47225213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUZ8V6eN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfBYWWt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41714 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfBYWWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so11705019wrw.8
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=en8ChlNmv1wmkd04/fq3Y7+zdqGQ00qd8lQMY0iOp00=;
        b=mUZ8V6eNAlmAaGPtBSq4WdLBqxDtx29pqrnaV/Gv80D/DSonW+3+N/JzpWoY7vG5jk
         lwnnxoh30UWBLCjAmfAbeGaSRrK0HJlOXbFnahV2rtPKtdFIe8mNGewHPbiwoMW943Z4
         9ugiS9nYEW/yxAxHyQc9tifta6E/yuwSczNedFrgrffkU6P53HU/XYJkxcCd8DOGdgLL
         CXw3EVRRctVi5/eXkz0ewlS108FayMqqrFQlHOu+W4IN1bQFzEjS1FROXYz7PDEHs6pL
         nJM/MjEXmCPeCNtcJla+MqblkYdYrHV0Hnxh4TRyGNUy7KYsysHPTOyMku+qPDaeQ97r
         2r8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=en8ChlNmv1wmkd04/fq3Y7+zdqGQ00qd8lQMY0iOp00=;
        b=a0ZKKHZPc4kKjeBQKbAZAksiVqKgp8GzLrIAjYjCZegaEbNmxwiqd7f/mdoMv03+QK
         m4boHtJVCVNjr0ajRUzV9IoNu4wCm5Irzx38aMKMXDoWG1pVUOL2smFrmkKNIW4f9g01
         WXKOyx7IurzQEcRAiHnAAJfrdigYP+0ibjOIDnV8wTAO0z8ADVjMqUdxNoMHK82Co6Nb
         PUyVelWpg7oI9HiuG+y0hCx54KmCONBSkFjDo3ggtolEex3Cfj1WrFhC62GZ/rrP/mbk
         OrmkNY5Bwblr6U8OnLp8a4Ux/b+ApsJeUAurlN5HyHdE9+sW9KVTk+dtfiLSF4bYvrgA
         VA8w==
X-Gm-Message-State: AHQUAuYYglqYXcQFDQnjdzkp6TM81g11xm9Rx+TdWC9eWjsOycYoIbfU
        SuP7RInRjuTkmLrxhaBPYk7BgKJVTNE=
X-Google-Smtp-Source: AHgI3IZU61hgYE1jTCcLGu+ASHMEqM0kOMT7cMRCvdKoPKS38g2vaQg9bjobW0dLbgGFa0zL2MkvoQ==
X-Received: by 2002:a5d:4d12:: with SMTP id z18mr14446120wrt.115.1551133367080;
        Mon, 25 Feb 2019 14:22:47 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id p16sm24061977wro.25.2019.02.25.14.22.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:46 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 20/21] media: vicodec: Register another node for stateless decoder
Date:   Mon, 25 Feb 2019 14:22:38 -0800
Message-Id: <20190225222239.121770-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add stateless decoder instance field to the dev struct and
register another node for the statelsess decoder.
The stateless API for the node will be implemented in further patches.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 46 +++++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 5d6f0cdc2064..9e67c1fd81a4 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -104,6 +104,7 @@ struct vicodec_dev {
 	struct v4l2_device	v4l2_dev;
 	struct vicodec_dev_instance stateful_enc;
 	struct vicodec_dev_instance stateful_dec;
+	struct vicodec_dev_instance stateless_dec;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device	mdev;
 #endif
@@ -114,6 +115,7 @@ struct vicodec_ctx {
 	struct v4l2_fh		fh;
 	struct vicodec_dev	*dev;
 	bool			is_enc;
+	bool			is_stateless;
 	spinlock_t		*lock;
 
 	struct v4l2_ctrl_handler hdl;
@@ -373,6 +375,9 @@ static void device_run(void *priv)
 
 	if (ctx->is_enc)
 		v4l2_m2m_job_finish(dev->stateful_enc.m2m_dev, ctx->fh.m2m_ctx);
+	else if (ctx->is_stateless)
+		v4l2_m2m_job_finish(dev->stateless_dec.m2m_dev,
+				    ctx->fh.m2m_ctx);
 	else
 		v4l2_m2m_job_finish(dev->stateful_dec.m2m_dev, ctx->fh.m2m_ctx);
 }
@@ -1494,8 +1499,14 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &vicodec_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	src_vq->lock = ctx->is_enc ? &ctx->dev->stateful_enc.mutex :
-		&ctx->dev->stateful_dec.mutex;
+	if (ctx->is_enc)
+		src_vq->lock = &ctx->dev->stateful_enc.mutex;
+	else if (ctx->is_stateless)
+		src_vq->lock = &ctx->dev->stateless_dec.mutex;
+	else
+		src_vq->lock = &ctx->dev->stateful_dec.mutex;
+	src_vq->supports_requests = ctx->is_stateless;
+	src_vq->requires_requests = ctx->is_stateless;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1588,6 +1599,8 @@ static int vicodec_open(struct file *file)
 
 	if (vfd == &dev->stateful_enc.vfd)
 		ctx->is_enc = true;
+	else if (vfd == &dev->stateless_dec.vfd)
+		ctx->is_stateless = true;
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
@@ -1598,6 +1611,8 @@ static int vicodec_open(struct file *file)
 			  1, 16, 1, 10);
 	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame, NULL);
 	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame, NULL);
+	if (ctx->is_stateless)
+		v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1637,6 +1652,10 @@ static int vicodec_open(struct file *file)
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_enc.m2m_dev,
 						    ctx, &queue_init);
 		ctx->lock = &dev->stateful_enc.lock;
+	} else if (ctx->is_stateless) {
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateless_dec.m2m_dev,
+						    ctx, &queue_init);
+		ctx->lock = &dev->stateless_dec.lock;
 	} else {
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_dec.m2m_dev,
 						    ctx, &queue_init);
@@ -1773,6 +1792,10 @@ static int vicodec_probe(struct platform_device *pdev)
 			      "stateful-decoder", false))
 		goto unreg_sf_enc;
 
+	if (register_instance(dev, &dev->stateless_dec,
+			      "videdev-stateless-dec", false))
+		goto unreg_sf_dec;
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
 						 &dev->stateful_enc.vfd,
@@ -1790,23 +1813,36 @@ static int vicodec_probe(struct platform_device *pdev)
 		goto unreg_m2m_sf_enc_mc;
 	}
 
+	ret = v4l2_m2m_register_media_controller(dev->stateless_dec.m2m_dev,
+						 &dev->stateless_dec.vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for stateless dec\n");
+		goto unreg_m2m_sf_dec_mc;
+	}
+
 	ret = media_device_register(&dev->mdev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
-		goto unreg_m2m_sf_dec_mc;
+		goto unreg_m2m_sl_dec_mc;
 	}
 #endif
 	return 0;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
+unreg_m2m_sl_dec_mc:
+	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
 unreg_m2m_sf_dec_mc:
 	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
 unreg_m2m_sf_enc_mc:
 	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 unreg_m2m:
+	video_unregister_device(&dev->stateless_dec.vfd);
+	v4l2_m2m_release(dev->stateless_dec.m2m_dev);
+#endif
+unreg_sf_dec:
 	video_unregister_device(&dev->stateful_dec.vfd);
 	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
-#endif
 unreg_sf_enc:
 	video_unregister_device(&dev->stateful_enc.vfd);
 	v4l2_m2m_release(dev->stateful_enc.m2m_dev);
@@ -1826,6 +1862,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	media_device_unregister(&dev->mdev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
+	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
@@ -1833,6 +1870,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
 	video_unregister_device(&dev->stateful_enc.vfd);
 	video_unregister_device(&dev->stateful_dec.vfd);
+	video_unregister_device(&dev->stateless_dec.vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.17.1

