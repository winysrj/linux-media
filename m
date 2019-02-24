Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAEAC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA9320652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MskXl470"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfBXJDP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:15 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38682 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfBXJDO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so6678610wrw.5
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wsnQSbYEGI327AP0lbAMolPj+IvLZTErRDhXZhS1d9A=;
        b=MskXl470IQesGLcE/5LtcAGQ08CODS5ZlYngSZFKzzMhtr9qaSlhVzwCF/R4fhwtqx
         l1sCkY3Up8GPrYijHsuD1ZEsEguwtoHjLmv8o5QzpAZaZV/CuOcCb6ipI2/DkDR8emLI
         Jww1tEZqzBMdpLIYOwSd+/Hbk+gkoD+84WZXo0rBbm54tVWmrTH7rMGTNTFxEZUqaLDy
         uaQkXSGWX/JvozuCMPko589YCnFRUHQvdkKimoEy+++j3lmAE4GgQnfsxMVP38+GFgau
         YynbXKmHM52PsWV/wx6JF0N/YbsOo67U63oWHR3baNIzQdgzlGBt5Jf9dCRaZI5gX48t
         Jseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wsnQSbYEGI327AP0lbAMolPj+IvLZTErRDhXZhS1d9A=;
        b=orHeNgHRU/uaO4hyCv1uJSSOI3/7m354FMTVnNDod8l2oBlBFHQ50tkEGybe3PTNaN
         FoLS7HUpAC+5v7ph+La20P/53WT6nAKmxhiCPO7zxFgVOkR0k2p4X7FITtS6FmbFXUzu
         +U04+vZ3pdstso4vdFynyn56dAGMUQF+rHqfgFpj0gjxxBBFrFcmjK9N4KpXnqj6S3Or
         r+raj6r3kPpuNijc0QajBdCqjEmfti01uH5bqmO33b6h0SpS5to2zzbAWc9FBIlhW2W1
         DcfaIzAq+hm0yZy7UyTdzWkhWY3kxvGDFRQCqfzADW9qM0zfEyzJtz4ks7r41OWkfUlv
         54sA==
X-Gm-Message-State: AHQUAubWNPsleXkzWIuRVUhzJAO1JcZBDfxURpWoyhTTBd84Chii1ynh
        10Pz9MbWn5yLwBd/0xRm/kmiB365Hlc=
X-Google-Smtp-Source: AHgI3IbyvxgpO8g0gsgqgaQceojKDOWJnfHY4HJNHOShKlL+QZ9kUmQDCjn284J9ryMiEMjJ7XDrdg==
X-Received: by 2002:adf:c543:: with SMTP id s3mr6582296wrf.192.1550998992246;
        Sun, 24 Feb 2019 01:03:12 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.03.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:03:11 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 16/18] media: vicodec: Register another node for stateless decoder
Date:   Sun, 24 Feb 2019 01:02:33 -0800
Message-Id: <20190224090234.19723-17-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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
index 869fe33f6f26..725c73ac7272 100644
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

