Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1195CC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E084A2082F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfC0PTX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:23 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48532 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730539AbfC0PTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 5E1DC281FF4
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 08/15] media: vimc: cap: Add multiplanar default format
Date:   Wed, 27 Mar 2019 12:17:36 -0300
Message-Id: <20190327151743.18528-9-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327151743.18528-1-andrealmeid@collabora.com>
References: <20190327151743.18528-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

vimc already have a default single planar default format.
Add a multiplanar default pixel format to perform those
same actions. Change where the default pixelformat is set to make sure
that the vcap is with the right capabilities.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2:
- Move here the default format is set to verify if the device have a
multiplanar capability before assign the default format

 drivers/media/platform/vimc/vimc-capture.c | 38 +++++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index a65611be63bb..c344d04ed8ea 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -104,6 +104,15 @@ static const struct v4l2_format fmt_default = {
 	.fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT,
 };
 
+static const struct v4l2_format fmt_default_mp = {
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	.fmt.pix_mp.width = 640,
+	.fmt.pix_mp.height = 480,
+	.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_YVU420M,
+	.fmt.pix_mp.field = V4L2_FIELD_NONE,
+	.fmt.pix_mp.colorspace = V4L2_COLORSPACE_DEFAULT,
+};
+
 struct vimc_cap_buffer {
 	/*
 	 * struct vb2_v4l2_buffer must be the first element
@@ -153,6 +162,7 @@ static int _vimc_cap_try_fmt_vid_cap_mp(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *format = &f->fmt.pix_mp;
+	struct vimc_cap_device *vcap = video_drvdata(file);
 
 	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
 				VIMC_FRAME_MAX_WIDTH) & ~1;
@@ -168,7 +178,9 @@ static int _vimc_cap_try_fmt_vid_cap_mp(struct file *file, void *priv,
 
 	/* Don't accept a pixelformat that is not on the table */
 	if (!v4l2_format_info(format->pixelformat))
-		format->pixelformat = fmt_default.fmt.pix.pixelformat;
+		format->pixelformat = IS_MULTIPLANAR(vcap) ?
+				fmt_default_mp.fmt.pix_mp.pixelformat :
+				fmt_default.fmt.pix.pixelformat;
 
 	return v4l2_fill_pixfmt_mp(format, format->pixelformat,
 				   format->width, format->height);
@@ -651,13 +663,6 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	INIT_LIST_HEAD(&vcap->buf_list);
 	spin_lock_init(&vcap->qlock);
 
-	/* Set default frame format */
-	vcap->format = fmt_default;
-	v4l2_fill_pixfmt(&vcap->format.fmt.pix,
-			 vcap->format.fmt.pix.pixelformat,
-			 vcap->format.fmt.pix.width,
-			 vcap->format.fmt.pix.height);
-
 	/* Fill the vimc_ent_device struct */
 	vcap->ved.ent = &vcap->vdev.entity;
 	vcap->ved.process_frame = vimc_cap_process_frame;
@@ -679,6 +684,23 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	strscpy(vdev->name, pdata->entity_name, sizeof(vdev->name));
 	video_set_drvdata(vdev, &vcap->ved);
 
+	dev_dbg(vcap->dev, "vimc-capture is in %s mode", IS_MULTIPLANAR(vcap) ?
+		"multiplanar" : "singleplanar");
+
+	if (IS_MULTIPLANAR(vcap)) {
+		vcap->format = fmt_default_mp;
+		v4l2_fill_pixfmt_mp(&vcap->format.fmt.pix_mp,
+				vcap->format.fmt.pix_mp.pixelformat,
+				vcap->format.fmt.pix_mp.width,
+				vcap->format.fmt.pix_mp.height);
+	} else {
+		vcap->format = fmt_default;
+		v4l2_fill_pixfmt(&vcap->format.fmt.pix,
+				vcap->format.fmt.pix.pixelformat,
+				vcap->format.fmt.pix.width,
+				vcap->format.fmt.pix.height);
+	}
+
 	/* Register the video_device with the v4l2 and the media framework */
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-- 
2.21.0

