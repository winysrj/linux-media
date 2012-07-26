Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:39139 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2GZL5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:57:13 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 1/2] [media] omap3isp: implement ENUM_FMT
Date: Thu, 26 Jul 2012 13:59:55 +0200
Message-Id: <1343303996-16025-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ENUM_FMT will not enumerate all formats that the ISP is capable of,
it will only return the format which has been previously configured
using the media controller, because this is the only format available
to a V4L2 application which is unaware of the media controller.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3isp/ispvideo.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index b37379d..d1d2c14 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -678,6 +678,28 @@ isp_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
 }
 
 static int
+isp_video_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *fmtdesc)
+{
+	struct isp_video_fh *vfh = to_isp_video_fh(fh);
+	struct isp_video *video = video_drvdata(file);
+
+	if (fmtdesc->index)
+		return -EINVAL;
+
+	if (fmtdesc->type != video->type)
+		return -EINVAL;
+
+	fmtdesc->flags = 0;
+	fmtdesc->description[0] = 0;
+
+	mutex_lock(&video->mutex);
+	fmtdesc->pixelformat = vfh->format.fmt.pix.pixelformat;
+	mutex_unlock(&video->mutex);
+
+	return 0;
+}
+
+static int
 isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 {
 	struct isp_video_fh *vfh = to_isp_video_fh(fh);
@@ -1191,6 +1213,7 @@ isp_video_s_input(struct file *file, void *fh, unsigned int input)
 
 static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 	.vidioc_querycap		= isp_video_querycap,
+	.vidioc_enum_fmt_vid_cap	= isp_video_enum_format,
 	.vidioc_g_fmt_vid_cap		= isp_video_get_format,
 	.vidioc_s_fmt_vid_cap		= isp_video_set_format,
 	.vidioc_try_fmt_vid_cap		= isp_video_try_format,
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
