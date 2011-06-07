Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:57785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1FGKLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 06:11:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C399E189B77
	for <linux-media@vger.kernel.org>; Tue,  7 Jun 2011 12:11:41 +0200 (CEST)
Date: Tue, 7 Jun 2011 12:11:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2] V4L: soc-camera: remove several now unused soc-camera
 client operations
Message-ID: <Pine.LNX.4.64.1106071210420.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch removes .enum_input(), .suspend() and .resume() soc-camera
client operations.

Functionality, provided by .enum_input(), if needed, can be implemented
using the v4l2-subdev API.

As for .suspend() and .resume(), the only client driver, implementing
these methods has been mt9m111, and the only host driver, using them
has been pxa-camera. Now that both those drivers have been converted
to the standard subdev .s_power() operation, .suspend() and .resume()
can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2: also remove .suspend() and .resume()

 drivers/media/video/soc_camera.c |   17 +++++------------
 include/media/soc_camera.h       |    3 ---
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4e4d412..136326e 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -199,22 +199,15 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 static int soc_camera_enum_input(struct file *file, void *priv,
 				 struct v4l2_input *inp)
 {
-	struct soc_camera_device *icd = file->private_data;
-	int ret = 0;
-
 	if (inp->index != 0)
 		return -EINVAL;
 
-	if (icd->ops->enum_input)
-		ret = icd->ops->enum_input(icd, inp);
-	else {
-		/* default is camera */
-		inp->type = V4L2_INPUT_TYPE_CAMERA;
-		inp->std  = V4L2_STD_UNKNOWN;
-		strcpy(inp->name, "Camera");
-	}
+	/* default is camera */
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std  = V4L2_STD_UNKNOWN;
+	strcpy(inp->name, "Camera");
 
-	return ret;
+	return 0;
 }
 
 static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 790f422..7791c0e 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -202,11 +202,8 @@ struct soc_camera_format_xlate {
 };
 
 struct soc_camera_ops {
-	int (*suspend)(struct soc_camera_device *, pm_message_t state);
-	int (*resume)(struct soc_camera_device *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
-	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
 };
-- 
1.7.2.5

