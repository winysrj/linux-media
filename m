Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1330 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaBYKQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 01/13] v4l2-ioctl: add CREATE_BUFS sanity checks.
Date: Tue, 25 Feb 2014 11:15:51 +0100
Message-Id: <1393323363-30058-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Many drivers do not check anything. At least make sure that the various
buffer size related fields are not obviously wrong.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 52 ++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 707aef7..69a1948 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1444,9 +1444,57 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_create_buffers *create = arg;
-	int ret = check_fmt(file, create->format.type);
+	const struct v4l2_format *fmt = &create->format;
+	const struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	const struct v4l2_pix_format_mplane *mp = &fmt->fmt.pix_mp;
+	const struct v4l2_plane_pix_format *p;
+	int ret = check_fmt(file, fmt->type);
+	unsigned i;
+
+	if (ret)
+		return ret;
 
-	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
+	/* Sanity checks */
+	switch (fmt->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (pix->sizeimage == 0 || pix->width == 0 || pix->height == 0)
+			return -EINVAL;
+		/* Note: bytesperline is 0 for compressed formats */
+		if (pix->bytesperline &&
+		    pix->height * pix->bytesperline > pix->sizeimage)
+			return -EINVAL;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (mp->num_planes == 0 || mp->width == 0 || mp->height == 0)
+			return -EINVAL;
+		for (i = 0; i < mp->num_planes; i++) {
+			p = &mp->plane_fmt[i];
+
+			if (p->sizeimage == 0)
+				return -EINVAL;
+			/* Note: bytesperline is 0 for compressed formats */
+			if (p->bytesperline &&
+			    p->bytesperline * mp->height > p->sizeimage)
+				return -EINVAL;
+		}
+		break;
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		if (fmt->fmt.vbi.count[0] + fmt->fmt.vbi.count[1] == 0)
+			return -EINVAL;
+		break;
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		if (fmt->fmt.sliced.io_size == 0)
+			return -EINVAL;
+		break;
+	default:
+		/* Overlay formats are invalid */
+		return -EINVAL;
+	}
+	return ops->vidioc_create_bufs(file, fh, create);
 }
 
 static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
-- 
1.9.0

