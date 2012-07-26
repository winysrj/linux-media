Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:39145 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2GZL5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:57:16 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: [PATCH 2/2] [media] omap3isp: support G_FMT
Date: Thu, 26 Jul 2012 13:59:56 +0200
Message-Id: <1343303996-16025-3-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows a V4L2 application which has no knowledge of the media
controller to open a video device node of the already-configured ISP
and query what it will deliver. Previously, G_FMT only worked after a
S_FMT had already been done.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3isp/ispvideo.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d1d2c14..955211b 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -1244,6 +1244,7 @@ static int isp_video_open(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
 	struct isp_video_fh *handle;
+	struct media_pad *src_pad;
 	int ret = 0;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
@@ -1273,6 +1274,32 @@ static int isp_video_open(struct file *file)
 	handle->format.type = video->type;
 	handle->timeperframe.denominator = 1;
 
+	src_pad = media_entity_remote_source(&video->pad);
+
+	if (src_pad) { /* it's on an active link */
+		struct v4l2_subdev_format srcfmt = {
+			.pad = src_pad->index,
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
+		struct v4l2_subdev *src_subdev =
+			isp_video_remote_subdev(video, NULL);
+		pr_debug("%s src_subdev=\"%s\"\n", __func__, src_subdev->name);
+
+		ret = v4l2_subdev_call(src_subdev, pad, get_fmt, NULL, &srcfmt);
+		if (ret)
+			goto done;
+		pr_debug("%s MBUS format %dx%d code:%x\n", __func__,
+				srcfmt.format.width, srcfmt.format.height,
+				srcfmt.format.code);
+
+		isp_video_mbus_to_pix(video, &srcfmt.format,
+			&handle->format.fmt.pix);
+		pr_debug("%s V4L format %dx%d 4CC:%x\n", __func__,
+				handle->format.fmt.pix.width,
+				handle->format.fmt.pix.height,
+				handle->format.fmt.pix.pixelformat);
+	}
+
 	handle->video = video;
 	file->private_data = &handle->vfh;
 
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
