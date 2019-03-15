Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092E7C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7439218D0
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfCOQpY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:24 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49020 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729750AbfCOQpW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:22 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 76E1C260215
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 07/16] media: vimc: cap: Add handler for singleplanar fmt ioctls
Date:   Fri, 15 Mar 2019 13:43:50 -0300
Message-Id: <20190315164359.626-8-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190315164359.626-1-andrealmeid@collabora.com>
References: <20190315164359.626-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since multiplanar is a superset of single planar formats, instead of
having different implementations for them, treat all formats as
multiplanar. If we need to work with single planar formats, convert them to
multiplanar (with num_planes = 1), re-use the multiplanar code, and
transform them back to single planar. This is implemented with
v4l2_fmt_sp2mp_func().

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 63 +++++++++++++++++-----
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index a93241d53953..47acf50f1ad2 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -127,7 +127,7 @@ static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
-	struct v4l2_pix_format *format = &f->fmt.pix;
+	struct v4l2_pix_format_mplane *format = &f->fmt.pix_mp;
 
 	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
 				VIMC_FRAME_MAX_WIDTH) & ~1;
@@ -145,20 +145,58 @@ static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
 	if (!v4l2_format_info(format->pixelformat))
 		format->pixelformat = fmt_default.fmt.pix.pixelformat;
 
-	return v4l2_fill_pixfmt(format, format->pixelformat,
+	return v4l2_fill_pixfmt_mp(format, format->pixelformat,
 				format->width, format->height);
 }
 
-static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
+static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	if (f->index >= ARRAY_SIZE(vimc_cap_supported_pixfmt))
+		return -EINVAL;
+
+	f->pixelformat = vimc_cap_supported_pixfmt[f->index];
+	strncpy(f->description, v4l2_get_fourcc_name(f->pixelformat), 4);
+	f->description[4] = '\0';
+
+	return 0;
+}
+
+/*
+ * VIDIOC FMT handlers for single-planar
+ */
+
+static int vimc_cap_g_fmt_vid_cap_sp(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	if (multiplanar)
+		return -EINVAL;
+
+	return vimc_cap_g_fmt_vid_cap(file, priv, f);
+}
+
+static int vimc_cap_try_fmt_vid_cap_sp(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	if (multiplanar)
+		return -EINVAL;
+
+	return v4l2_fmt_sp2mp_func(file, priv, f, vimc_cap_try_fmt_vid_cap);
+}
+
+static int vimc_cap_s_fmt_vid_cap_sp(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
 
+	if (multiplanar)
+		return -EINVAL;
+
 	/* Do not change the format while stream is on */
 	if (vb2_is_busy(&vcap->queue))
 		return -EBUSY;
 
-	vimc_cap_try_fmt_vid_cap(file, priv, f);
+	v4l2_fmt_sp2mp_func(file, priv, f, vimc_cap_try_fmt_vid_cap);
 
 	dev_dbg(vcap->dev, "%s: format update: "
 		"old:%dx%d (0x%x, %d, %d, %d, %d) "
@@ -181,15 +219,13 @@ static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
+static int vimc_cap_enum_fmt_vid_cap_sp(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
-	if (f->index >= ARRAY_SIZE(vimc_cap_supported_pixfmt))
+	if (multiplanar)
 		return -EINVAL;
 
-	f->pixelformat = vimc_cap_supported_pixfmt[f->index];
-
-	return 0;
+	return vimc_cap_enum_fmt_vid_cap(file, priv, f);
 }
 
 static bool vimc_cap_is_pixfmt_supported(u32 pixelformat)
@@ -235,10 +271,11 @@ static const struct v4l2_file_operations vimc_cap_fops = {
 static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
 	.vidioc_querycap = vimc_cap_querycap,
 
-	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap = vimc_cap_try_fmt_vid_cap,
-	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap_sp,
+	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap_sp,
+	.vidioc_try_fmt_vid_cap = vimc_cap_try_fmt_vid_cap_sp,
+	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap_sp,
+
 	.vidioc_enum_framesizes = vimc_cap_enum_framesizes,
 
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
-- 
2.21.0

