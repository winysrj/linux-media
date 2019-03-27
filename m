Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB7EC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E5C20449
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfC0PTY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48542 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfC0PTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 603A8281FF3
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 07/15] media: vimc: cap: Add multiplanar formats
Date:   Wed, 27 Mar 2019 12:17:35 -0300
Message-Id: <20190327151743.18528-8-andrealmeid@collabora.com>
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

Add multiplanar formats to be exposed to the userspace as
supported formats. Since we don't want to support multiplanar
formats when the driver is in singleplanar mode, we only access
the multiplanar formats array if the multiplanar mode is enabled.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Changes in v2:
- Change line break style
- Add TODO comment

 drivers/media/platform/vimc/vimc-capture.c | 34 ++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 5e13c6580aff..a65611be63bb 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -32,6 +32,10 @@
 #define IS_MULTIPLANAR(vcap) \
 	(vcap->vdev.device_caps & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
 
+/**
+ * TODO: capture device should only enum formats that all subdevices on
+ * topology accepts
+ */
 static const u32 vimc_cap_supported_pixfmt[] = {
 	V4L2_PIX_FMT_BGR24,
 	V4L2_PIX_FMT_RGB24,
@@ -58,6 +62,19 @@ static const u32 vimc_cap_supported_pixfmt[] = {
 	V4L2_PIX_FMT_SRGGB12,
 };
 
+static const u32 vimc_cap_supported_pixfmt_mp[] = {
+	V4L2_PIX_FMT_YUV420M,
+	V4L2_PIX_FMT_YVU420M,
+	V4L2_PIX_FMT_YUV422M,
+	V4L2_PIX_FMT_YVU422M,
+	V4L2_PIX_FMT_YUV444M,
+	V4L2_PIX_FMT_YVU444M,
+	V4L2_PIX_FMT_NV12M,
+	V4L2_PIX_FMT_NV21M,
+	V4L2_PIX_FMT_NV16M,
+	V4L2_PIX_FMT_NV61M,
+};
+
 struct vimc_cap_device {
 	struct vimc_ent_device ved;
 	struct video_device vdev;
@@ -157,13 +174,26 @@ static int _vimc_cap_try_fmt_vid_cap_mp(struct file *file, void *priv,
 				   format->width, format->height);
 }
 
+/**
+ * When multiplanar is true, consider that the vimc_cap_enum_fmt_vid_cap_mp
+ * is concantenate in the vimc_cap_enum_fmt_vid_cap array. Otherwise, just
+ * consider the single-planar array
+ */
 static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
-	if (f->index >= ARRAY_SIZE(vimc_cap_supported_pixfmt))
+	struct vimc_cap_device *vcap = video_drvdata(file);
+	const unsigned int sp_size = ARRAY_SIZE(vimc_cap_supported_pixfmt);
+	const unsigned int mp_size = ARRAY_SIZE(vimc_cap_supported_pixfmt_mp);
+
+	if (f->index >= sp_size + (IS_MULTIPLANAR(vcap) ? mp_size : 0))
 		return -EINVAL;
 
-	f->pixelformat = vimc_cap_supported_pixfmt[f->index];
+	if (f->index >= sp_size)
+		f->pixelformat =
+			vimc_cap_supported_pixfmt_mp[f->index - sp_size];
+	else
+		f->pixelformat = vimc_cap_supported_pixfmt[f->index];
 
 	return 0;
 }
-- 
2.21.0

