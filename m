Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36966 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2KMNqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:46:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/2] omap_vout: Drop overlay format enumeration
Date: Tue, 13 Nov 2012 14:47:38 +0100
Message-Id: <1352814459-8215-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enumerating formats for output overlays doesn't make sense, as the pixel
format is defined by the display API, not the V4L2 API. Drop the
vidioc_enum_fmt_vid_overlay ioctl operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap/omap_vout.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 21d55f0..dea33b5 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1232,21 +1232,6 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *fh,
 	return ret;
 }
 
-static int vidioc_enum_fmt_vid_overlay(struct file *file, void *fh,
-			struct v4l2_fmtdesc *fmt)
-{
-	int index = fmt->index;
-
-	if (index >= NUM_OUTPUT_FORMATS)
-		return -EINVAL;
-
-	fmt->flags = omap_formats[index].flags;
-	strlcpy(fmt->description, omap_formats[index].description,
-			sizeof(fmt->description));
-	fmt->pixelformat = omap_formats[index].pixelformat;
-	return 0;
-}
-
 static int vidioc_g_fmt_vid_overlay(struct file *file, void *fh,
 			struct v4l2_format *f)
 {
@@ -1862,7 +1847,6 @@ static const struct v4l2_ioctl_ops vout_ioctl_ops = {
 	.vidioc_s_ctrl       			= vidioc_s_ctrl,
 	.vidioc_try_fmt_vid_overlay 		= vidioc_try_fmt_vid_overlay,
 	.vidioc_s_fmt_vid_overlay		= vidioc_s_fmt_vid_overlay,
-	.vidioc_enum_fmt_vid_overlay		= vidioc_enum_fmt_vid_overlay,
 	.vidioc_g_fmt_vid_overlay		= vidioc_g_fmt_vid_overlay,
 	.vidioc_cropcap				= vidioc_cropcap,
 	.vidioc_g_crop				= vidioc_g_crop,
-- 
1.7.8.6

