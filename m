Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:47679 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2KRH1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 02:27:03 -0500
Received: by mail-yh0-f46.google.com with SMTP id m54so719788yhm.19
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2012 23:27:02 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: g.liakhovetski@gmx.de
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	javier.martin@vista-silicon.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] soc_camera: mx3_camera: Constify v4l2_crop
Date: Sun, 18 Nov 2012 05:26:51 -0200
Message-Id: <1353223611-18960-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 4f996594ce ([media] v4l2: make vidioc_s_crop const), set_crop 
should receive a 'const struct v4l2_crop *' argument type.

Adapt to this new format and get rid of the following build warning:

drivers/media/platform/soc_camera/mx3_camera.c:1134: warning: initialization from incompatible pointer type

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/soc_camera/mx3_camera.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 64d39b1..ae04395 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -799,17 +799,17 @@ static inline void stride_align(__u32 *width)
  * default g_crop and cropcap from soc_camera.c
  */
 static int mx3_camera_set_crop(struct soc_camera_device *icd,
-			       struct v4l2_crop *a)
+			       const struct v4l2_crop *a)
 {
-	struct v4l2_rect *rect = &a->c;
+	struct v4l2_rect rect = a->c;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
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

