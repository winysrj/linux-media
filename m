Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9E4C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87DA52082F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfC0PTR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:17 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48518 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfC0PTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id C51DB281FF2
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 06/15] media: vimc: cap: Add handler for multiplanar fmt ioctls
Date:   Wed, 27 Mar 2019 12:17:34 -0300
Message-Id: <20190327151743.18528-7-andrealmeid@collabora.com>
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

Add functions to handle multiplanar format ioctls, calling
the generic format ioctls functions when possible.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2:
- Fix alignment

 drivers/media/platform/vimc/vimc-capture.c | 85 ++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 24d70c2c9db7..5e13c6580aff 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -118,6 +118,10 @@ static void vimc_cap_get_format(struct vimc_ent_device *ved,
 	*fmt = vcap->format.fmt.pix;
 }
 
+/*
+ * Functions to handle both single- and multi-planar VIDIOC FMT
+ */
+
 static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
@@ -245,6 +249,77 @@ static bool vimc_cap_is_pixfmt_supported(u32 pixelformat)
 			return true;
 	return false;
 }
+/*
+ * VIDIOC handlers for multi-planar formats
+ */
+
+static int vimc_cap_g_fmt_vid_cap_mp(struct file *file, void *priv,
+				     struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	if (!IS_MULTIPLANAR(vcap))
+		return -EINVAL;
+
+	return vimc_cap_g_fmt_vid_cap(file, priv, f);
+}
+
+static int vimc_cap_try_fmt_vid_cap_mp(struct file *file, void *priv,
+				       struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	if (!IS_MULTIPLANAR(vcap))
+		return -EINVAL;
+
+	return _vimc_cap_try_fmt_vid_cap_mp(file, priv, f);
+}
+
+static int vimc_cap_s_fmt_vid_cap_mp(struct file *file, void *priv,
+				     struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	if (!IS_MULTIPLANAR(vcap))
+		return -EINVAL;
+
+	/* Do not change the format while stream is on */
+	if (vb2_is_busy(&vcap->queue))
+		return -EBUSY;
+
+	_vimc_cap_try_fmt_vid_cap_mp(file, priv, f);
+
+	dev_dbg(vcap->dev, "%s: format update: "
+		"old:%dx%d (0x%x, %d, %d, %d, %d) "
+		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
+		/* old */
+		vcap->format.fmt.pix_mp.width, vcap->format.fmt.pix_mp.height,
+		vcap->format.fmt.pix_mp.pixelformat,
+		vcap->format.fmt.pix_mp.colorspace,
+		vcap->format.fmt.pix_mp.quantization,
+		vcap->format.fmt.pix_mp.xfer_func,
+		vcap->format.fmt.pix_mp.ycbcr_enc,
+		/* new */
+		f->fmt.pix_mp.width, f->fmt.pix_mp.height,
+		f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.colorspace,
+		f->fmt.pix_mp.quantization, f->fmt.pix_mp.xfer_func,
+		f->fmt.pix_mp.ycbcr_enc);
+
+	vcap->format = *f;
+
+	return 0;
+}
+
+static int vimc_cap_enum_fmt_vid_cap_mp(struct file *file, void *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	if (!IS_MULTIPLANAR(vcap))
+		return -EINVAL;
+
+	return vimc_cap_enum_fmt_vid_cap(file, priv, f);
+}
 
 static int vimc_cap_enum_framesizes(struct file *file, void *fh,
 				    struct v4l2_frmsizeenum *fsize)
@@ -276,14 +351,24 @@ static const struct v4l2_file_operations vimc_cap_fops = {
 	.mmap           = vb2_fop_mmap,
 };
 
+
 static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
 	.vidioc_querycap = vimc_cap_querycap,
 
+	/**
+	 * The vidioc_*_vid_cap* functions acts as a front end to
+	 * vimc_*_vid_cap, dealing with the single- and multi-planar
+	 */
 	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap_sp,
 	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap_sp,
 	.vidioc_try_fmt_vid_cap = vimc_cap_try_fmt_vid_cap_sp,
 	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap_sp,
 
+	.vidioc_g_fmt_vid_cap_mplane = vimc_cap_g_fmt_vid_cap_mp,
+	.vidioc_s_fmt_vid_cap_mplane = vimc_cap_s_fmt_vid_cap_mp,
+	.vidioc_try_fmt_vid_cap_mplane = vimc_cap_try_fmt_vid_cap_mp,
+	.vidioc_enum_fmt_vid_cap_mplane = vimc_cap_enum_fmt_vid_cap_mp,
+
 	.vidioc_enum_framesizes = vimc_cap_enum_framesizes,
 
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
-- 
2.21.0

