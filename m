Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51850 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KRHOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 02:14:38 -0500
Received: by mail-gh0-f174.google.com with SMTP id g15so85250ghb.19
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2012 23:14:37 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: g.liakhovetski@gmx.de
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	javier.martin@vista-silicon.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] soc_camera: mx2_camera: Constify v4l2_crop
Date: Sun, 18 Nov 2012 05:14:23 -0200
Message-Id: <1353222863-23959-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit 4f996594ce ([media] v4l2: make vidioc_s_crop const), set_crop 
should receive a 'const struct v4l2_crop *' argument type.

Adapt to this new format and get rid of the following build warning:

drivers/media/platform/soc_camera/mx2_camera.c:1529: warning: initialization from incompatible pointer type

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index e575ae8..5fc3319 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1131,15 +1131,15 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 }
 
 static int mx2_camera_set_crop(struct soc_camera_device *icd,
-				struct v4l2_crop *a)
+				const struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
-	soc_camera_limit_side(&rect->left, &rect->width, 0, 2, 4096);
-	soc_camera_limit_side(&rect->top, &rect->height, 0, 2, 4096);
+	soc_camera_limit_side(&rect.left, &rect.width, 0, 2, 4096);
+	soc_camera_limit_side(&rect.top, &rect.height, 0, 2, 4096);
 
 	ret = v4l2_subdev_call(sd, video, s_crop, a);
 	if (ret < 0)
-- 
1.7.9.5

