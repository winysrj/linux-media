Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57985 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdB0KZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 05:25:19 -0500
Date: Mon, 27 Feb 2017 11:23:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2] soc-camera: fix rectangle adjustment in cropping
Message-ID: <Pine.LNX.4.64.1702271120060.21990@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

update_subrect() adjusts the sub-rectangle to be inside a base area.
It checks width and height to not exceed those of the area, then it
checks the low border (left or top) to lie within the area, then the
high border (right or bottom) to lie there too. This latter check has
a bug, which is fixed by this patch.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
[g.liakhovetski@gmx.de: dropped supposedly wrong hunks]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2: fix a silly typo, reported by Laurent, thanks! Also renamed the 
function, according to his suggestion.

 drivers/media/platform/soc_camera/soc_scale_crop.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index f77252d..0116097 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -62,7 +62,8 @@ int soc_camera_client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
 EXPORT_SYMBOL(soc_camera_client_g_rect);
 
 /* Client crop has changed, update our sub-rectangle to remain within the area */
-static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
+static void move_and_crop_subrect(struct v4l2_rect *rect,
+				  struct v4l2_rect *subrect)
 {
 	if (rect->width < subrect->width)
 		subrect->width = rect->width;
@@ -72,14 +73,14 @@ static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
 
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
@@ -216,7 +217,7 @@ int soc_camera_client_s_selection(struct v4l2_subdev *sd,
 
 	if (!ret) {
 		*target_rect = *cam_rect;
-		update_subrect(target_rect, subrect);
+		move_and_crop_subrect(target_rect, subrect);
 	}
 
 	return ret;
@@ -299,7 +300,7 @@ static int client_set_fmt(struct soc_camera_device *icd,
 	if (host_1to1)
 		*subrect = *rect;
 	else
-		update_subrect(rect, subrect);
+		move_and_crop_subrect(rect, subrect);
 
 	return 0;
 }
-- 
1.9.3
