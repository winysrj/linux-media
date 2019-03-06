Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD7BC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E379620661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUnpIJHi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfCFVOm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55189 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id f3so7345683wmj.4
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HherVcHU+jrhSoQOHql2YvBenIfobA4ob398Xl/p6Fw=;
        b=bUnpIJHi8DHh1gTxwUf3up0p2HmUoY+0VFB3tv97EX3wDlregvJkV71Hz1Ynxt1O54
         8QdxAQ9qpM1119Rpmbsq6p6RGEAnP9YtDdH03c0kktx3B07UGfEMsqxD2lMN9QUgrkX/
         jAE5jW7GP+c0a6BAoZlgoh7ASPx2LhRTadAu1CgNQaFJ9+5sPUKKOEtQ+UpHSQcKSGzk
         jqkTBXiyqqKGi1XLJa6RZd3SH6XqwidfSwdUdptEDLngbpV7Rp53Kw60F4iYbbijDgEF
         m3x6X+NaCPY+MFeDJg/Fz1AEy2L/NeUPwpzFDo7ZKWdUvhKztwZ5Zy2qgEpb4OopjLnB
         IBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HherVcHU+jrhSoQOHql2YvBenIfobA4ob398Xl/p6Fw=;
        b=bS968ddQEps+1eNgLfU9RzMg7j7qAz7hx17A32aNdLGZyIL2NlCdcqEqx8pGF2//WM
         tkibCOzeCMqNmEKoxWyA+VtldAcD8yT+qHwDcz9E99bJdKcVvCl3UFn7c3225SZ9osAd
         w/vy1beUfp08VLbrz/GwxBM1QNgHWcCanDyqsGubudc8IwTqrbHQx4vARCxQ08jmX5aU
         4AHN304DAFz36PrZ3z/gh3PLQigBPf+AujRbWPuFDay0ra5j9y/2rhOEpfchYe3zfRjg
         sjZB9b2T2qYgoxCJrpvLhE/bkXer4SPRvaTEakrtkB3Dv9jwSjjQtgNY9W9ex78TFNHO
         i6eQ==
X-Gm-Message-State: APjAAAXIse27pwyOi3k42J/KE6bkC+mH6GHJsJUwb8S758KvlmEQkOqw
        LA6XTzzXzhFZnZz2VG+iarPKlMZTXFk=
X-Google-Smtp-Source: APXvYqxFJF22uvtYNHSa2dndviJ8HrGz1Dn08uYkYVOOGhOa9S3Exu0pW4zxwRYNCWjCYdl/BcnlHg==
X-Received: by 2002:a1c:2dd2:: with SMTP id t201mr3576613wmt.44.1551906879153;
        Wed, 06 Mar 2019 13:14:39 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:38 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 21/23] media: vicodec: Register another node for stateless decoder
Date:   Wed,  6 Mar 2019 13:13:41 -0800
Message-Id: <20190306211343.15302-22-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

