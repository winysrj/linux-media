Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50902 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3ACSe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:34:29 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/3] sh_vou: Don't modify const variable in sh_vou_s_crop()
Date: Thu,  3 Jan 2013 19:35:55 +0100
Message-Id: <1357238157-18115-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The crop rectangle is const, make a local copy instead of modifying it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/sh_vou.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 85fd312..43278de 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -937,7 +937,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
-	struct v4l2_rect *rect = &a->c;
+	const struct v4l2_rect *rect = &a->c;
 	struct v4l2_crop sd_crop = {.type = V4L2_BUF_TYPE_VIDEO_OUTPUT};
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	struct sh_vou_geometry geo;
@@ -961,16 +961,16 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	else
 		img_height_max = 576;
 
-	v4l_bound_align_image(&rect->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
-			      &rect->height, 0, img_height_max, 1, 0);
+	geo.output = *rect;
+	v4l_bound_align_image(&geo.output.width, 0, VOU_MAX_IMAGE_WIDTH, 1,
+			      &geo.output.height, 0, img_height_max, 1, 0);
 
-	if (rect->width + rect->left > VOU_MAX_IMAGE_WIDTH)
-		rect->left = VOU_MAX_IMAGE_WIDTH - rect->width;
+	if (geo.output.width + geo.output.left > VOU_MAX_IMAGE_WIDTH)
+		geo.output.left = VOU_MAX_IMAGE_WIDTH - geo.output.width;
 
-	if (rect->height + rect->top > img_height_max)
-		rect->top = img_height_max - rect->height;
+	if (geo.output.height + geo.output.top > img_height_max)
+		geo.output.top = img_height_max - geo.output.height;
 
-	geo.output = *rect;
 	geo.in_width = pix->width;
 	geo.in_height = pix->height;
 
-- 
1.7.8.6

