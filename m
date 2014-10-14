Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40476 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaJNGZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 02:25:41 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH] media: soc_camera: Fix VIDIOC_S_CROP ioctl miscalculation
Date: Tue, 14 Oct 2014 15:25:24 +0900
Message-Id: <1413267924-8273-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

This patch corrects the miscalculation of the capture buffer
size and clipping data update in VIDIOC_S_CROP sequence.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is against master branch of linuxtv.org/media_tree.git.

 drivers/media/platform/soc_camera/rcar_vin.c       | 5 -----
 drivers/media/platform/soc_camera/soc_scale_crop.c | 6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 61c36b0..5196c81 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1119,9 +1119,6 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	cam->width = mf.width;
 	cam->height = mf.height;
 
-	icd->user_width  = cam->width;
-	icd->user_height = cam->height;
-
 	cam->vin_left = rect->left & ~1;
 	cam->vin_top = rect->top & ~1;
 
@@ -1130,8 +1127,6 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	cam->subrect = *rect;
-
 	dev_dbg(dev, "VIN cropped to %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height,
 		cam->vin_left, cam->vin_top);
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 8e74fb7..7a1951a 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -74,14 +74,14 @@ static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
 
 	if (rect->left > subrect->left)
 		subrect->left = rect->left;
-	else if (rect->left + rect->width >
+	else if (rect->left + rect->width <
 		 subrect->left + subrect->width)
 		subrect->left = rect->left + rect->width -
 			subrect->width;
 
 	if (rect->top > subrect->top)
 		subrect->top = rect->top;
-	else if (rect->top + rect->height >
+	else if (rect->top + rect->height <
 		 subrect->top + subrect->height)
 		subrect->top = rect->top + rect->height -
 			subrect->height;
@@ -117,6 +117,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
 			rect->width, rect->height, rect->left, rect->top);
 		*target_rect = *cam_rect;
+		*subrect = *rect;
 		return 0;
 	}
 
@@ -204,6 +205,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 
 	if (!ret) {
 		*target_rect = *cam_rect;
+		*subrect = *rect;
 		update_subrect(target_rect, subrect);
 	}
 
-- 
1.9.1

