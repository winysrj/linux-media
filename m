Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C94C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B99A21928
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epbNKFwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfBINys (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:48 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36504 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfBINys (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so8275977wmc.1
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pl25v6K8gZUfCyA1ycTJM9FoIrmc+0fxtygITWSEw0g=;
        b=epbNKFwWltnxQDpupLF9cEFwH2luagKagDZZJ8C0ryXGhyEWL4U+vz8tkFSUPMdWX3
         fgoHMMgmOfO2GvfRuWOSmCeGwUTLKWGE30b54cF2KUf0VO8bs1NmYl2LeKNKQp4o6k20
         dvA4YJ30aFuY5YTtKCYeQmWfbD9xggt5XrHNsVcDHzUktMC1oGjjOUNHfMkPLh1kxlmw
         +DyYNJ1R8QIHEemc2dvCeVVMTsbipVycj5mTdDN9+rTii+Bji9J1Zc4HM5AuiWMQ61yC
         Vkufs/QhVnPbpEkYgvDQs13I2wOwFTNfQP8ay/3uVwvMFguSecKQZADGDFKI+IAWaemp
         grAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Pl25v6K8gZUfCyA1ycTJM9FoIrmc+0fxtygITWSEw0g=;
        b=Zdk5gr+yZUJyqobapbRTmvo2a/m1A8sWdYAFOtrAeyLt86nOxXz9P3QYSSLoJW0nIk
         FzEENFtHzzpLZiqHE+2mWF92zaJU0HgrQQZCAZqTKfpL3l+EZsfr04Urz416vB3XdNmm
         ifUymfnIJcSECCcUSRuS5fJKZK09w6ZE7tGtjrPsnVOTG07ijBvoFKEy6KSbnQDvEssY
         lYGzICTI5l/0kg27GJ5BvabaIpFeBYMnaOfH04CfDWJynGxo5cIhpylp4cg+jkdUNp2P
         mxyGwPP9lcpOqyTQ7GvXzfc8QQ76PSRz3DE4libsJhq7EPcRDTiUV125NoMWBIf2UiP9
         MJ0g==
X-Gm-Message-State: AHQUAuYTQ5s9PPUoO6n4iVOxou11Bv8wOgP+dpQAKqOPUHSACoO6cmvE
        C51LAKn2rJaHVCKVbkHLnKIv7rTyNOg=
X-Google-Smtp-Source: AHgI3Ib/y0TihuRIh7fSUR3D5vf+SeppEsGP49H+Mz3FOTFvjyVmyGlEp1aipfxK7cM0yQ0MSbM7Bg==
X-Received: by 2002:a5d:4e82:: with SMTP id e2mr20301220wru.291.1549720486224;
        Sat, 09 Feb 2019 05:54:46 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:45 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 6/9] media: vicodec: Register another node for stateless decoder
Date:   Sat,  9 Feb 2019 05:54:24 -0800
Message-Id: <20190209135427.20630-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add stateless decoder instance field to the dev struct and
register another node for the statelsess decoder.
The stateless API for the node will be implemented in further patches.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 45 +++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 95276c09cb9a..324ce566478e 100644
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
@@ -317,6 +319,9 @@ static void device_run(void *priv)
 
 	if (ctx->is_enc)
 		v4l2_m2m_job_finish(dev->stateful_enc.m2m_dev, ctx->fh.m2m_ctx);
+	else if (ctx->is_stateless)
+		v4l2_m2m_job_finish(dev->stateless_dec.m2m_dev,
+				    ctx->fh.m2m_ctx);
 	else
 		v4l2_m2m_job_finish(dev->stateful_dec.m2m_dev, ctx->fh.m2m_ctx);
 }
@@ -1461,8 +1466,13 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
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
+	src_vq->supports_requests = ctx->is_stateless ? true : false;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1560,6 +1570,8 @@ static int vicodec_open(struct file *file)
 
 	if (vfd == &dev->stateful_enc.vfd)
 		ctx->is_enc = true;
+	else if (vfd == &dev->stateless_dec.vfd)
+		ctx->is_stateless = true;
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
@@ -1570,6 +1582,8 @@ static int vicodec_open(struct file *file)
 			  1, 16, 1, 10);
 	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame, NULL);
 	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame, NULL);
+	if (ctx->is_stateless)
+		v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
@@ -1609,6 +1623,10 @@ static int vicodec_open(struct file *file)
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
@@ -1744,6 +1762,10 @@ static int vicodec_probe(struct platform_device *pdev)
 			      "videdev-statefull-dec", false))
 		goto unreg_sf_enc;
 
+	if (register_instance(dev, &dev->stateless_dec,
+			      "videdev-stateless-dec", false))
+		goto unreg_sf_dec;
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
 						 &dev->stateful_enc.vfd,
@@ -1761,23 +1783,36 @@ static int vicodec_probe(struct platform_device *pdev)
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
@@ -1797,6 +1832,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	media_device_unregister(&dev->mdev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
+	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
@@ -1804,6 +1840,7 @@ static int vicodec_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
 	video_unregister_device(&dev->stateful_enc.vfd);
 	video_unregister_device(&dev->stateful_dec.vfd);
+	video_unregister_device(&dev->stateless_dec.vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.17.1

