Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44384 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753355AbeEURCB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:01 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 08/16] v4l: mark unordered formats
Date: Mon, 21 May 2018 13:59:38 -0300
Message-Id: <20180521165946.11778-9-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Now that we've introduced the V4L2_FMT_FLAG_UNORDERED flag,
mark the appropriate formats.

v2: Set unordered flag before calling the driver callback.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 74 +++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f48c505550e0..2135ac235a96 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1102,6 +1102,27 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_enum_output(file, fh, p);
 }
 
+static void v4l_fill_unordered_fmtdesc(struct v4l2_fmtdesc *fmt)
+{
+	switch (fmt->pixelformat) {
+	case V4L2_PIX_FMT_MPEG:
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_H264_NO_SC:
+	case V4L2_PIX_FMT_H264_MVC:
+	case V4L2_PIX_FMT_H263:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_XVID:
+	case V4L2_PIX_FMT_VC1_ANNEX_G:
+	case V4L2_PIX_FMT_VC1_ANNEX_L:
+	case V4L2_PIX_FMT_VP8:
+	case V4L2_PIX_FMT_VP9:
+	case V4L2_PIX_FMT_HEVC:
+		fmt->flags |= V4L2_FMT_FLAG_UNORDERED;
+	}
+}
+
 static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 {
 	const unsigned sz = sizeof(fmt->description);
@@ -1310,61 +1331,80 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 
 	if (descr)
 		WARN_ON(strlcpy(fmt->description, descr, sz) >= sz);
-	fmt->flags = flags;
+	fmt->flags |= flags;
 }
 
-static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
-{
-	struct v4l2_fmtdesc *p = arg;
-	int ret = check_fmt(file, p->type);
 
-	if (ret)
-		return ret;
-	ret = -EINVAL;
+static int __vidioc_enum_fmt(const struct v4l2_ioctl_ops *ops,
+			     struct v4l2_fmtdesc *p,
+			     struct file *file, void *fh)
+{
+	int ret = 0;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
 			break;
-		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
 			break;
-		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
 			break;
-		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
 			break;
-		ret = ops->vidioc_enum_fmt_vid_out(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_out(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
-		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 		if (unlikely(!ops->vidioc_enum_fmt_sdr_cap))
 			break;
-		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		if (unlikely(!ops->vidioc_enum_fmt_sdr_out))
 			break;
-		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, p);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		if (unlikely(!ops->vidioc_enum_fmt_meta_cap))
 			break;
-		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
+		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, p);
 		break;
 	}
+	return ret;
+}
+
+static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_fmtdesc *p = arg;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
+	ret = -EINVAL;
+
+	ret = __vidioc_enum_fmt(ops, p, file, fh);
+	if (ret)
+		return ret;
+	/*
+	 * Set the unordered flag and call the driver
+	 * again so it has the chance to clear the flag.
+	 */
+	v4l_fill_unordered_fmtdesc(p);
+	ret = __vidioc_enum_fmt(ops, p, file, fh);
 	if (ret == 0)
 		v4l_fill_fmtdesc(p);
 	return ret;
-- 
2.16.3
