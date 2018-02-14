Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46668 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967435AbeBNLog (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:44:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v4.14 01/13] media: v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
Date: Wed, 14 Feb 2018 12:44:22 +0100
Message-Id: <20180214114434.26842-2-hverkuil@xs4all.nl>
In-Reply-To: <20180214114434.26842-1-hverkuil@xs4all.nl>
References: <20180214114434.26842-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit b2469c814fbc8f1f19676dd4912717b798df511e upstream.

Don't duplicate the buffer type checks in enum/g/s/try_fmt.
The check_fmt function does that already.

It is hard to keep the checks in sync for all these functions and
in fact the check for VBI was wrong in the _fmt functions as it
allowed SDR types as well. This caused a v4l2-compliance failure
for /dev/swradio0 using vivid.

This simplifies the code and keeps the check in one place and
fixes the SDR/VBI bug.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 140 ++++++++++++++---------------------
 1 file changed, 54 insertions(+), 86 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b60a6b0841d1..42e376f46729 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1308,52 +1308,50 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_fmtdesc *p = arg;
-	struct video_device *vfd = video_devdata(file);
-	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
-	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
-	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
-	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
-	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
-	int ret = -EINVAL;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
+	ret = -EINVAL;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_enum_fmt_vid_cap))
+		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap_mplane))
+		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_overlay))
+		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out))
+		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_out(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_vid_out_mplane))
+		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
-		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_enum_fmt_sdr_cap))
+		if (unlikely(!ops->vidioc_enum_fmt_sdr_cap))
 			break;
 		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_enum_fmt_sdr_out))
+		if (unlikely(!ops->vidioc_enum_fmt_sdr_out))
 			break;
 		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_meta_cap))
+		if (unlikely(!ops->vidioc_enum_fmt_meta_cap))
 			break;
 		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
 		break;
@@ -1367,13 +1365,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
-	struct video_device *vfd = video_devdata(file);
-	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
-	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
-	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
-	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
-	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
-	int ret;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
 
 	/*
 	 * fmt can't be cleared for these overlay types due to the 'clips'
@@ -1401,7 +1396,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_g_fmt_vid_cap))
+		if (unlikely(!ops->vidioc_g_fmt_vid_cap))
 			break;
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
@@ -1409,23 +1404,15 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
-			break;
 		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_overlay))
-			break;
 		return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_vbi_cap))
-			break;
 		return ops->vidioc_g_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_cap))
-			break;
 		return ops->vidioc_g_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
+		if (unlikely(!ops->vidioc_g_fmt_vid_out))
 			break;
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
@@ -1433,32 +1420,18 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
-			break;
 		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_overlay))
-			break;
 		return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_vbi_out))
-			break;
 		return ops->vidioc_g_fmt_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
-			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
-		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_sdr_cap))
-			break;
 		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
-			break;
 		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
-			break;
 		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
 	}
 	return -EINVAL;
@@ -1484,12 +1457,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
-	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
-	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
-	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
-	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
-	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
-	int ret;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
 
 	ret = v4l_enable_media_source(vfd);
 	if (ret)
@@ -1498,37 +1469,37 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_s_fmt_vid_cap))
+		if (unlikely(!ops->vidioc_s_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_s_fmt_vid_cap(file, fh, arg);
 		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
-		if (is_tch)
+		if (vfd->vfl_type == VFL_TYPE_TOUCH)
 			v4l_pix_format_touch(&p->fmt.pix);
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
+		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
+		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_s_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_vbi_cap))
+		if (unlikely(!ops->vidioc_s_fmt_vbi_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_cap))
+		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out))
+		if (unlikely(!ops->vidioc_s_fmt_vid_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_s_fmt_vid_out(file, fh, arg);
@@ -1536,37 +1507,37 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
+		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
+		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_s_fmt_vid_out_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_vbi_out))
+		if (unlikely(!ops->vidioc_s_fmt_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_s_fmt_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_s_fmt_sliced_vbi_out))
+		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
-		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_sdr_cap))
+		if (unlikely(!ops->vidioc_s_fmt_sdr_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_s_fmt_sdr_out))
+		if (unlikely(!ops->vidioc_s_fmt_sdr_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
+		if (unlikely(!ops->vidioc_s_fmt_meta_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
@@ -1578,19 +1549,16 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_format *p = arg;
-	struct video_device *vfd = video_devdata(file);
-	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
-	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
-	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
-	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
-	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
-	int ret;
+	int ret = check_fmt(file, p->type);
+
+	if (ret)
+		return ret;
 
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_try_fmt_vid_cap))
+		if (unlikely(!ops->vidioc_try_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_try_fmt_vid_cap(file, fh, arg);
@@ -1598,27 +1566,27 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap_mplane))
+		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_overlay))
+		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_try_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_vbi_cap))
+		if (unlikely(!ops->vidioc_try_fmt_vbi_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-		if (unlikely(!is_rx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_cap))
+		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out))
+		if (unlikely(!ops->vidioc_try_fmt_vid_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_try_fmt_vid_out(file, fh, arg);
@@ -1626,37 +1594,37 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_mplane))
+		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_overlay))
+		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.win);
 		return ops->vidioc_try_fmt_vid_out_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_vbi_out))
+		if (unlikely(!ops->vidioc_try_fmt_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.vbi);
 		return ops->vidioc_try_fmt_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-		if (unlikely(!is_tx || is_vid || !ops->vidioc_try_fmt_sliced_vbi_out))
+		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
-		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_sdr_cap))
+		if (unlikely(!ops->vidioc_try_fmt_sdr_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_try_fmt_sdr_out))
+		if (unlikely(!ops->vidioc_try_fmt_sdr_out))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
 	case V4L2_BUF_TYPE_META_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
+		if (unlikely(!ops->vidioc_try_fmt_meta_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
-- 
2.15.1
