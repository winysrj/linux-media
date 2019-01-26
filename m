Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94197C282C7
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5004221872
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQYNPylX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfAZNs3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 26 Jan 2019 08:48:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39475 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfAZNs3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Jan 2019 08:48:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id y8so9119878wmi.4
        for <linux-media@vger.kernel.org>; Sat, 26 Jan 2019 05:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OaJa4iTVTg8EYVPSRiIwiyd8ZJHW+i7EHKwL5Ts8Tco=;
        b=LQYNPylX+AgzU5YbirMI33NV0LrmZk76X9kWk/YRI6zmtyOa2OeZdXEQ+jCkaAJ4r2
         h/wW4F9iWnGh5gyId5QlX93Mto5EMqGHMevJ5vLKB/vaI8F8hfTLQvPpAVPCd4kaC12Z
         PjxHu/FvZ7Z0EIgE+zet3xItLwGRJqAf2nRdWo6IE+J0CkSfdyeBiS5gnE9Wp5GfhVo1
         ps77qj8qmX79y3ZoKNf0Aq8oELwpG4BXdNk5dNtdDJ+caTbn5qA1cT58bG/PRDEURxAp
         GqOq24PhPlzBFavkoTPC7/vePNbTrXxC/J1KAxJB4yGQemEvkEhfw5xH+/AC1w2vesrg
         wXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OaJa4iTVTg8EYVPSRiIwiyd8ZJHW+i7EHKwL5Ts8Tco=;
        b=RddqaeRaC8kBQ70nZlSzoZyrd49S3nWgC+zHxzCKQwG5kHXjw/qedx3QCYhxeeCNtg
         5hxnf5MseOjcDSU0HZVmRvY3acsGuF14fvaNrYN9C2JEc+wU+SHRzvlhN4q4AeA+bh/i
         lxTGVULWLAEKUxUaeY/PiTscWUqS8TtvD54gHRzwKj+b4eaH0N9akMDJ6GxxI79OanBt
         +CyBUj8BvHAXjI2L2VeUhUrfvfoHuuAuPYiSbwiGs7x6UmcYBT+x1NSUG76F0xGA+tmW
         oKPgyZURPFdN1X+jroVwdLlKI2pPUqf7CuPEZawcstYEzBX93cB4/Qtb5mt5CCb1FSIM
         Hs2g==
X-Gm-Message-State: AJcUukfaU3uVzs2fRy+FkuP058z7WTPT65hTkBDxDRlv8YCB3J4xWYLQ
        91/Fggs4OqUP8SHVeO1etggy1jBJ5jY=
X-Google-Smtp-Source: ALg8bN5HODdX/AYCbNGKr2cpCitGFrFEW2IJe9BFLOQVorRYEn3qc5U8oq7rFyK27cj2htuGhSYr+A==
X-Received: by 2002:a1c:81ca:: with SMTP id c193mr11153189wmd.66.1548510506458;
        Sat, 26 Jan 2019 05:48:26 -0800 (PST)
Received: from ubuntu.home ([77.124.106.231])
        by smtp.gmail.com with ESMTPSA id v6sm101552298wrd.88.2019.01.26.05.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jan 2019 05:48:25 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 1/3] media: vicodec: add struct for encoder/decoder instance
Date:   Sat, 26 Jan 2019 05:47:57 -0800
Message-Id: <20190126134759.97680-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190126134759.97680-1-dafna3@gmail.com>
References: <20190126134759.97680-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add struct 'vicodec_dev_instance' for the fields in vicodec_dev
that have have both decoder and encoder versions.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 175 +++++++++---------
 1 file changed, 89 insertions(+), 86 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 953b9c4816a5..370517707324 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -89,21 +89,21 @@ enum {
 	V4L2_M2M_DST = 1,
 };
 
+struct vicodec_dev_instance {
+	struct video_device     vfd;
+	struct mutex            mutex;
+	spinlock_t              lock;
+	struct v4l2_m2m_dev     *m2m_dev;
+};
+
 struct vicodec_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	enc_vfd;
-	struct video_device	dec_vfd;
+	struct vicodec_dev_instance enc_instance;
+	struct vicodec_dev_instance dec_instance;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device	mdev;
 #endif
 
-	struct mutex		enc_mutex;
-	struct mutex		dec_mutex;
-	spinlock_t		enc_lock;
-	spinlock_t		dec_lock;
-
-	struct v4l2_m2m_dev	*enc_dev;
-	struct v4l2_m2m_dev	*dec_dev;
 };
 
 struct vicodec_ctx {
@@ -309,9 +309,9 @@ static void device_run(void *priv)
 	spin_unlock(ctx->lock);
 
 	if (ctx->is_enc)
-		v4l2_m2m_job_finish(dev->enc_dev, ctx->fh.m2m_ctx);
+		v4l2_m2m_job_finish(dev->enc_instance.m2m_dev, ctx->fh.m2m_ctx);
 	else
-		v4l2_m2m_job_finish(dev->dec_dev, ctx->fh.m2m_ctx);
+		v4l2_m2m_job_finish(dev->dec_instance.m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
@@ -1440,9 +1440,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &vicodec_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_mutex :
-		&ctx->dev->dec_mutex;
-
+	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_instance.mutex :
+		&ctx->dev->dec_instance.mutex;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1530,7 +1529,7 @@ static int vicodec_open(struct file *file)
 		goto open_unlock;
 	}
 
-	if (vfd == &dev->enc_vfd)
+	if (vfd == &dev->enc_instance.vfd)
 		ctx->is_enc = true;
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
@@ -1578,13 +1577,13 @@ static int vicodec_open(struct file *file)
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	if (ctx->is_enc) {
-		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_dev, ctx,
-						    &queue_init);
-		ctx->lock = &dev->enc_lock;
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_instance.m2m_dev,
+						    ctx, &queue_init);
+		ctx->lock = &dev->enc_instance.lock;
 	} else {
-		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->dec_dev, ctx,
-						    &queue_init);
-		ctx->lock = &dev->dec_lock;
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->dec_instance.m2m_dev,
+						    ctx, &queue_init);
+		ctx->lock = &dev->dec_instance.lock;
 	}
 
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
@@ -1642,18 +1641,50 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_ready	= job_ready,
 };
 
+static int register_instance(struct vicodec_dev *dev,
+			     struct vicodec_dev_instance *dev_instance,
+			     const char *name, bool is_enc)
+{
+	struct video_device *vfd;
+	int ret;
+
+	dev_instance->vfd = vicodec_videodev;
+	vfd = &dev_instance->vfd;
+	vfd->lock = &dev_instance->mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	strscpy(vfd->name, name, sizeof(vfd->name));
+	vfd->device_caps = V4L2_CAP_STREAMING |
+		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
+	if (is_enc) {
+		v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
+	} else {
+		v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
+	}
+	video_set_drvdata(vfd, dev);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device '%s'\n", name);
+		return ret;
+	}
+	v4l2_info(&dev->v4l2_dev, "Device '%s' registered as /dev/video%d\n",
+		  name, vfd->num);
+	return ret;
+}
+
 static int vicodec_probe(struct platform_device *pdev)
 {
 	struct vicodec_dev *dev;
-	struct video_device *vfd;
 	int ret;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
-	spin_lock_init(&dev->enc_lock);
-	spin_lock_init(&dev->dec_lock);
+	spin_lock_init(&dev->enc_instance.lock);
+	spin_lock_init(&dev->dec_instance.lock);
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
@@ -1666,75 +1697,47 @@ static int vicodec_probe(struct platform_device *pdev)
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
 
-	mutex_init(&dev->enc_mutex);
-	mutex_init(&dev->dec_mutex);
+	mutex_init(&dev->enc_instance.mutex);
+	mutex_init(&dev->dec_instance.mutex);
 
 	platform_set_drvdata(pdev, dev);
 
-	dev->enc_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(dev->enc_dev)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec device\n");
-		ret = PTR_ERR(dev->enc_dev);
+	dev->enc_instance.m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->enc_instance.m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec enc device\n");
+		ret = PTR_ERR(dev->enc_instance.m2m_dev);
 		goto unreg_dev;
 	}
 
-	dev->dec_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(dev->dec_dev)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec device\n");
-		ret = PTR_ERR(dev->dec_dev);
+	dev->dec_instance.m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev->dec_instance.m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec dec device\n");
+		ret = PTR_ERR(dev->dec_instance.m2m_dev);
 		goto err_enc_m2m;
 	}
 
-	dev->enc_vfd = vicodec_videodev;
-	vfd = &dev->enc_vfd;
-	vfd->lock = &dev->enc_mutex;
-	vfd->v4l2_dev = &dev->v4l2_dev;
-	strscpy(vfd->name, "vicodec-enc", sizeof(vfd->name));
-	vfd->device_caps = V4L2_CAP_STREAMING |
-		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
-	v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
-	v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
-	video_set_drvdata(vfd, dev);
-
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+	if (register_instance(dev, &dev->enc_instance,
+			      "videdev-enc", true))
 		goto err_dec_m2m;
-	}
-	v4l2_info(&dev->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
 
-	dev->dec_vfd = vicodec_videodev;
-	vfd = &dev->dec_vfd;
-	vfd->lock = &dev->dec_mutex;
-	vfd->v4l2_dev = &dev->v4l2_dev;
-	vfd->device_caps = V4L2_CAP_STREAMING |
-		(multiplanar ? V4L2_CAP_VIDEO_M2M_MPLANE : V4L2_CAP_VIDEO_M2M);
-	strscpy(vfd->name, "vicodec-dec", sizeof(vfd->name));
-	v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
-	v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
-	video_set_drvdata(vfd, dev);
-
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+	if (register_instance(dev, &dev->dec_instance,
+			      "videdev-statefull-dec", false))
 		goto unreg_enc;
-	}
-	v4l2_info(&dev->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	ret = v4l2_m2m_register_media_controller(dev->enc_dev,
-			&dev->enc_vfd, MEDIA_ENT_F_PROC_VIDEO_ENCODER);
+	ret = v4l2_m2m_register_media_controller(dev->enc_instance.m2m_dev,
+						 &dev->enc_instance.vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_ENCODER);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for enc\n");
 		goto unreg_m2m;
 	}
 
-	ret = v4l2_m2m_register_media_controller(dev->dec_dev,
-			&dev->dec_vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);
+	ret = v4l2_m2m_register_media_controller(dev->dec_instance.m2m_dev,
+						 &dev->dec_instance.vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for dec\n");
 		goto unreg_m2m_enc_mc;
 	}
 
@@ -1748,18 +1751,18 @@ static int vicodec_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 unreg_m2m_dec_mc:
-	v4l2_m2m_unregister_media_controller(dev->dec_dev);
+	v4l2_m2m_unregister_media_controller(dev->dec_instance.m2m_dev);
 unreg_m2m_enc_mc:
-	v4l2_m2m_unregister_media_controller(dev->enc_dev);
+	v4l2_m2m_unregister_media_controller(dev->enc_instance.m2m_dev);
 unreg_m2m:
-	video_unregister_device(&dev->dec_vfd);
+	video_unregister_device(&dev->dec_instance.vfd);
 #endif
 unreg_enc:
-	video_unregister_device(&dev->enc_vfd);
+	video_unregister_device(&dev->enc_instance.vfd);
 err_dec_m2m:
-	v4l2_m2m_release(dev->dec_dev);
+	v4l2_m2m_release(dev->dec_instance.m2m_dev);
 err_enc_m2m:
-	v4l2_m2m_release(dev->enc_dev);
+	v4l2_m2m_release(dev->enc_instance.m2m_dev);
 unreg_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
@@ -1774,15 +1777,15 @@ static int vicodec_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	media_device_unregister(&dev->mdev);
-	v4l2_m2m_unregister_media_controller(dev->enc_dev);
-	v4l2_m2m_unregister_media_controller(dev->dec_dev);
+	v4l2_m2m_unregister_media_controller(dev->enc_instance.m2m_dev);
+	v4l2_m2m_unregister_media_controller(dev->dec_instance.m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
-	v4l2_m2m_release(dev->enc_dev);
-	v4l2_m2m_release(dev->dec_dev);
-	video_unregister_device(&dev->enc_vfd);
-	video_unregister_device(&dev->dec_vfd);
+	v4l2_m2m_release(dev->enc_instance.m2m_dev);
+	v4l2_m2m_release(dev->dec_instance.m2m_dev);
+	video_unregister_device(&dev->enc_instance.vfd);
+	video_unregister_device(&dev->dec_instance.vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.17.1

