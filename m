Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60986 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391344AbeKXEFU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 23:05:20 -0500
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] v4l2-ioctl: Zero v4l2_pix_format_mplane reserved fields
Date: Fri, 23 Nov 2018 14:19:58 -0300
Message-Id: <20181123171958.17614-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the core set the reserved fields to zero in
v4l2_pix_format_mplane and v4l2_plane_pix_format structs,
for _MPLANE queue types.

Moving this to the core avoids having to do so in each
and every driver.

Suggested-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 51 ++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 10b862dcbd86..3858fffc3e68 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1420,6 +1420,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_format *p = arg;
 	int ret = check_fmt(file, p->type);
+	int i;
 
 	if (ret)
 		return ret;
@@ -1458,7 +1459,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
+		ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
@@ -1474,7 +1481,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
+		ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
 	case V4L2_BUF_TYPE_VBI_OUTPUT:
@@ -1512,6 +1525,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	int ret = check_fmt(file, p->type);
+	int i;
 
 	if (ret)
 		return ret;
@@ -1536,7 +1550,13 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
+		ret = ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
 			break;
@@ -1564,7 +1584,13 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
+		ret = ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
 			break;
@@ -1604,6 +1630,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_format *p = arg;
 	int ret = check_fmt(file, p->type);
+	int i;
 
 	if (ret)
 		return ret;
@@ -1623,7 +1650,13 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
+		ret = ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
 			break;
@@ -1651,7 +1684,13 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
+		ret = ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
+		memset(p->fmt.pix_mp.reserved, 0,
+		       sizeof(p->fmt.pix_mp.reserved));
+		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
+			memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
+			       sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
 			break;
-- 
2.19.1
