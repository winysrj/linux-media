Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E814C4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F358B20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xp/2Nw2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfBZRGC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:06:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37897 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfBZRGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:06:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id g12so2717717wrm.5
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HherVcHU+jrhSoQOHql2YvBenIfobA4ob398Xl/p6Fw=;
        b=Xp/2Nw2osDCeI2cX1w8sufSlxGlVID2wFlBtC+dG0LbjpdhlxOk3ZHY72jZdHjsfmY
         /zKNaP4YC3jvL6rfGM0Q5wlXeijt8l3s33pyD8ZpDgmev6gxIk3ff5zvYHCwwjC4oDE2
         wnxSIW6oQskp+QsIhLIuptrHk98NuBNbYvMKyZLB4spGkmDxhlpkgqft+G1T5BiEmDjD
         2hhrnfErreBxRhzdntF1dmX+4+5j/a8ZbOlKuTLRV+Wa4VDfvX+ociMLqVW6xlMTRHqU
         W3K6nUX6pEviZ1Oeov61EeqevODQ97bRjDBDNh+QYxIQC5qa1qs0P6Ytt82ekLWiEV2K
         0z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HherVcHU+jrhSoQOHql2YvBenIfobA4ob398Xl/p6Fw=;
        b=Ui99Nrtrh9P+UXSSE4MBMEm3Ra2El8BfDMUd/4h72bilXuPXml2B4OaIrnZk0CJrSl
         HJDUwd9MNOe9f3Hnn1AQhLL+Mjq6Xn9MpvLwQeLlp2v4YZuM9lYQvWWnGdsBWtm+mMGF
         lzlh3GU2Q6t0t3SxqNPxyhrDbpxyeZC06l6YsvjIJJwNDd4wTdUvjc93ZXJDiYphJXmC
         jhGJLcOYTvxgvD3NUK4ws4REDnlaFwRwHiPaS8vmNvXGHl7On7Wt7XEJgZ8GkS+1cz6u
         WXX3KAJHXIV4w+ylXe3cCnDkv6eUaAm1lNovR8mPfs3pSnChnZnNArn0iiHpUYfAeyHg
         9rzw==
X-Gm-Message-State: AHQUAuYBXb978EoPSWN4qEWIBsamGs23muJYbWpNYAYlBStCPrnDuqHJ
        bvFhGp/OypZNcj4cEYYwAmBsyhdol5k=
X-Google-Smtp-Source: AHgI3IYgCKUKj2rPoodneZEr3wwMPZW93w/mIug2OffktBUfHnnQyj5ZLZhxrLvjk5th3a2S7k4N6Q==
X-Received: by 2002:adf:deca:: with SMTP id i10mr16343955wrn.312.1551200759624;
        Tue, 26 Feb 2019 09:05:59 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:58 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 20/21] media: vicodec: Register another node for stateless decoder
Date:   Tue, 26 Feb 2019 09:05:13 -0800
Message-Id: <20190226170514.86127-21-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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
index 6c9a41838d31..7733b22247b6 100644
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
@@ -1564,6 +1575,8 @@ static int vicodec_open(struct file *file)
 
 	if (vfd == &dev->stateful_enc.vfd)
 		ctx->is_enc = true;
+	else if (vfd == &dev->stateless_dec.vfd)
+		ctx->is_stateless = true;
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
@@ -1576,6 +1589,8 @@ static int vicodec_open(struct file *file)
 			  1, 31, 1, 20);
 	v4l2_ctrl_new_std(hdl, &vicodec_ctrl_ops, V4L2_CID_FWHT_P_FRAME_QP,
 			  1, 31, 1, 20);
+	if (ctx->is_stateless)
+		v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1615,6 +1630,10 @@ static int vicodec_open(struct file *file)
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
@@ -1751,6 +1770,10 @@ static int vicodec_probe(struct platform_device *pdev)
 			      "stateful-decoder", false))
 		goto unreg_sf_enc;
 
+	if (register_instance(dev, &dev->stateless_dec,
+			      "videdev-stateless-dec", false))
+		goto unreg_sf_dec;
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
 						 &dev->stateful_enc.vfd,
@@ -1768,23 +1791,36 @@ static int vicodec_probe(struct platform_device *pdev)
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
@@ -1804,6 +1840,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	media_device_unregister(&dev->mdev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
+	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
@@ -1811,6 +1848,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
 	video_unregister_device(&dev->stateful_enc.vfd);
 	video_unregister_device(&dev->stateful_dec.vfd);
+	video_unregister_device(&dev->stateless_dec.vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.17.1

