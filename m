Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3LDA4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:38 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CBE3D35AB1
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 18/25] v4l: omap4iss: Make __iss_video_get_format() return a v4l2_mbus_framefmt
Date: Wed,  4 Dec 2013 01:56:18 +0100
Message-Id: <1386118585-12449-19-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function will be used by a caller that needs the media bus format
instead of the pixel format currently returned. Move the media bus
format to pixel format conversion to the existing caller.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index b4ffde8..5dbd774 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -232,7 +232,8 @@ iss_video_far_end(struct iss_video *video)
 }
 
 static int
-__iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
+__iss_video_get_format(struct iss_video *video,
+		       struct v4l2_mbus_framefmt *format)
 {
 	struct v4l2_subdev_format fmt;
 	struct v4l2_subdev *subdev;
@@ -243,6 +244,7 @@ __iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
 	if (subdev == NULL)
 		return -EINVAL;
 
+	memset(&fmt, 0, sizeof(fmt));
 	fmt.pad = pad;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 
@@ -253,26 +255,29 @@ __iss_video_get_format(struct iss_video *video, struct v4l2_format *format)
 	if (ret)
 		return ret;
 
-	format->type = video->type;
-	return iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
+	*format = fmt.format;
+	return 0;
 }
 
 static int
 iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
 {
-	struct v4l2_format format;
+	struct v4l2_mbus_framefmt format;
+	struct v4l2_pix_format pixfmt;
 	int ret;
 
-	memcpy(&format, &vfh->format, sizeof(format));
 	ret = __iss_video_get_format(video, &format);
 	if (ret < 0)
 		return ret;
 
-	if (vfh->format.fmt.pix.pixelformat != format.fmt.pix.pixelformat ||
-	    vfh->format.fmt.pix.height != format.fmt.pix.height ||
-	    vfh->format.fmt.pix.width != format.fmt.pix.width ||
-	    vfh->format.fmt.pix.bytesperline != format.fmt.pix.bytesperline ||
-	    vfh->format.fmt.pix.sizeimage != format.fmt.pix.sizeimage)
+	pixfmt.bytesperline = 0;
+	ret = iss_video_mbus_to_pix(video, &format, &pixfmt);
+
+	if (vfh->format.fmt.pix.pixelformat != pixfmt.pixelformat ||
+	    vfh->format.fmt.pix.height != pixfmt.height ||
+	    vfh->format.fmt.pix.width != pixfmt.width ||
+	    vfh->format.fmt.pix.bytesperline != pixfmt.bytesperline ||
+	    vfh->format.fmt.pix.sizeimage != pixfmt.sizeimage)
 		return -EINVAL;
 
 	return ret;
-- 
1.8.3.2

