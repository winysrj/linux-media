Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF4AC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6FC20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMDtDhIs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfBZRFz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:55 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52379 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfBZRFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id m1so3181445wml.2
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sf5RC4nU+7DgbikC7U1NfRFqAPc77vKF0D4+Mp2tV5Q=;
        b=bMDtDhIshHM1VNkeUq2dSyNGFcBVgmUZSpcV2MyeEY+57cWCYb5sNDS0Qk/42e+w9E
         m1aidnhvh7XoFvwckTk5JGl9QUEYVunFbPtSWdRK4qTGjcQbgiT2X2Hiaxu+S4rSEvij
         PYNC723ay/Z3goZykj1zR9Pn/C4bSAHx2WYaPUE1Z9qatiQNy07AOSuPeafamnzYrMCO
         xBXIX7yfacVrGk19gY3ZK0crwsVssURMUWaUBIWjrdu4iftSmxVgFfVh7J1eYStyTvok
         Ht3uG1VR1uOHbxHQKYBR4TeQekSYkyTPPSAHsuASRsCN7uVDHKFjklsghfjyYu32Br2z
         MW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sf5RC4nU+7DgbikC7U1NfRFqAPc77vKF0D4+Mp2tV5Q=;
        b=e9pg3ky69y7xv+BEE5xQpLZ3W6bmZzmxhPcRJpXZhgJ6CNdRNu9BvQ+2uO48f8Vaq/
         GEULU26vtbdWaFB0x4bThm02Lf2fA/U2SZwc/ZTGuo2F/PIwS0vys9iua7zHoUxvyHE8
         QLqfL/cUtxx6+Iv0zbP1bbU+SY+n/At4O54+W8fPLEeSCk6LTW1w2EacJUgdQFq92YOf
         ttKrnvqjBt3s5VmjXoz0m3DLMT7r5d9xRH/lfEeU5EY6AjW+o5lpnt44UoT3omvZi9fU
         fdAmZ9lnYh0f+lbfZA9/ACqbPvyqn8WWzbob2Gl76spzy/2Etg46/9EvEFSgJY66/2vI
         FPUw==
X-Gm-Message-State: AHQUAubNtKMEbeiheM5NUxeLQw97+YQ7bPzxUG85lWPVhBjgfotoZ1pJ
        35B1zP+ShMbrSbgatTElbn/irj+sHuc=
X-Google-Smtp-Source: AHgI3IbHKikMkDPANVmuS0kQO+D7okYFE3zbOOZgv3gWrDISuuN4gZah3Y8FuWSjyTJxrkm0KnQP8g==
X-Received: by 2002:a1c:6505:: with SMTP id z5mr3511257wmb.7.1551200751894;
        Tue, 26 Feb 2019 09:05:51 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:51 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 15/21] media: vicodec: add struct for encoder/decoder instance
Date:   Tue, 26 Feb 2019 09:05:08 -0800
Message-Id: <20190226170514.86127-16-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add struct 'vicodec_dev_instance' for the fields in vicodec_dev
that have have both decoder and encoder versions.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 194 +++++++++---------
 1 file changed, 92 insertions(+), 102 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 15dfdd99be3a..5998b9e86cda 100644
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
+	struct vicodec_dev_instance stateful_enc;
+	struct vicodec_dev_instance stateful_dec;
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
@@ -368,9 +368,9 @@ static void device_run(void *priv)
 	spin_unlock(ctx->lock);
 
 	if (ctx->is_enc)
-		v4l2_m2m_job_finish(dev->enc_dev, ctx->fh.m2m_ctx);
+		v4l2_m2m_job_finish(dev->stateful_enc.m2m_dev, ctx->fh.m2m_ctx);
 	else
-		v4l2_m2m_job_finish(dev->dec_dev, ctx->fh.m2m_ctx);
+		v4l2_m2m_job_finish(dev->stateful_dec.m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
@@ -1490,9 +1490,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &vicodec_qops;
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
-	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_mutex :
-		&ctx->dev->dec_mutex;
-
+	src_vq->lock = ctx->is_enc ? &ctx->dev->stateful_enc.mutex :
+		&ctx->dev->stateful_dec.mutex;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -1580,7 +1579,7 @@ static int vicodec_open(struct file *file)
 		goto open_unlock;
 	}
 
-	if (vfd == &dev->enc_vfd)
+	if (vfd == &dev->stateful_enc.vfd)
 		ctx->is_enc = true;
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
@@ -1628,13 +1627,13 @@ static int vicodec_open(struct file *file)
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	if (ctx->is_enc) {
-		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_dev, ctx,
-						    &queue_init);
-		ctx->lock = &dev->enc_lock;
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_enc.m2m_dev,
+						    ctx, &queue_init);
+		ctx->lock = &dev->stateful_enc.lock;
 	} else {
-		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->dec_dev, ctx,
-						    &queue_init);
-		ctx->lock = &dev->dec_lock;
+		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_dec.m2m_dev,
+						    ctx, &queue_init);
+		ctx->lock = &dev->stateful_dec.lock;
 	}
 
 	if (IS_ERR(ctx->fh.m2m_ctx)) {
@@ -1693,19 +1692,57 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_ready	= job_ready,
 };
 
+static int register_instance(struct vicodec_dev *dev,
+			     struct vicodec_dev_instance *dev_instance,
+			     const char *name, bool is_enc)
+{
+	struct video_device *vfd;
+	int ret;
+
+	spin_lock_init(&dev_instance->lock);
+	mutex_init(&dev_instance->mutex);
+	dev_instance->m2m_dev = v4l2_m2m_init(&m2m_ops);
+	if (IS_ERR(dev_instance->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec enc device\n");
+		return PTR_ERR(dev_instance->m2m_dev);
+	}
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
+		v4l2_m2m_release(dev_instance->m2m_dev);
+		return ret;
+	}
+	v4l2_info(&dev->v4l2_dev, "Device '%s' registered as /dev/video%d\n",
+		  name, vfd->num);
+	return 0;
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
-
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
@@ -1719,100 +1756,53 @@ static int vicodec_probe(struct platform_device *pdev)
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
 
-	mutex_init(&dev->enc_mutex);
-	mutex_init(&dev->dec_mutex);
-
 	platform_set_drvdata(pdev, dev);
 
-	dev->enc_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(dev->enc_dev)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec device\n");
-		ret = PTR_ERR(dev->enc_dev);
+	if (register_instance(dev, &dev->stateful_enc,
+			      "stateful-encoder", true))
 		goto unreg_dev;
-	}
-
-	dev->dec_dev = v4l2_m2m_init(&m2m_ops);
-	if (IS_ERR(dev->dec_dev)) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec device\n");
-		ret = PTR_ERR(dev->dec_dev);
-		goto err_enc_m2m;
-	}
 
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
-		goto err_dec_m2m;
-	}
-	v4l2_info(&dev->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
-
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
-		goto unreg_enc;
-	}
-	v4l2_info(&dev->v4l2_dev,
-			"Device registered as /dev/video%d\n", vfd->num);
+	if (register_instance(dev, &dev->stateful_dec,
+			      "stateful-decoder", false))
+		goto unreg_sf_enc;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-	ret = v4l2_m2m_register_media_controller(dev->enc_dev,
-			&dev->enc_vfd, MEDIA_ENT_F_PROC_VIDEO_ENCODER);
+	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
+						 &dev->stateful_enc.vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_ENCODER);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for enc\n");
 		goto unreg_m2m;
 	}
 
-	ret = v4l2_m2m_register_media_controller(dev->dec_dev,
-			&dev->dec_vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);
+	ret = v4l2_m2m_register_media_controller(dev->stateful_dec.m2m_dev,
+						 &dev->stateful_dec.vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
 	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto unreg_m2m_enc_mc;
+		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for dec\n");
+		goto unreg_m2m_sf_enc_mc;
 	}
 
 	ret = media_device_register(&dev->mdev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
-		goto unreg_m2m_dec_mc;
+		goto unreg_m2m_sf_dec_mc;
 	}
 #endif
 	return 0;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-unreg_m2m_dec_mc:
-	v4l2_m2m_unregister_media_controller(dev->dec_dev);
-unreg_m2m_enc_mc:
-	v4l2_m2m_unregister_media_controller(dev->enc_dev);
+unreg_m2m_sf_dec_mc:
+	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
+unreg_m2m_sf_enc_mc:
+	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
 unreg_m2m:
-	video_unregister_device(&dev->dec_vfd);
+	video_unregister_device(&dev->stateful_dec.vfd);
+	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
 #endif
-unreg_enc:
-	video_unregister_device(&dev->enc_vfd);
-err_dec_m2m:
-	v4l2_m2m_release(dev->dec_dev);
-err_enc_m2m:
-	v4l2_m2m_release(dev->enc_dev);
+unreg_sf_enc:
+	video_unregister_device(&dev->stateful_enc.vfd);
+	v4l2_m2m_release(dev->stateful_enc.m2m_dev);
 unreg_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
@@ -1827,15 +1817,15 @@ static int vicodec_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	media_device_unregister(&dev->mdev);
-	v4l2_m2m_unregister_media_controller(dev->enc_dev);
-	v4l2_m2m_unregister_media_controller(dev->dec_dev);
+	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
+	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
 
-	v4l2_m2m_release(dev->enc_dev);
-	v4l2_m2m_release(dev->dec_dev);
-	video_unregister_device(&dev->enc_vfd);
-	video_unregister_device(&dev->dec_vfd);
+	v4l2_m2m_release(dev->stateful_enc.m2m_dev);
+	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
+	video_unregister_device(&dev->stateful_enc.vfd);
+	video_unregister_device(&dev->stateful_dec.vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
-- 
2.17.1

