Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:51619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab1FFRWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:22:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C0352189B77
	for <linux-media@vger.kernel.org>; Mon,  6 Jun 2011 19:22:04 +0200 (CEST)
Date: Mon, 6 Jun 2011 19:22:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: remove now unused soc-camera .enum_input()
 operation
Message-ID: <Pine.LNX.4.64.1106061921260.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Also this functionality should be implemented, if needed, using the
v4l2-subdev API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   13 ++++---------
 include/media/soc_camera.h       |    1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 3988643..faf1e6c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -199,20 +199,15 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 static int soc_camera_enum_input(struct file *file, void *priv,
 				 struct v4l2_input *inp)
 {
-	struct soc_camera_device *icd = file->private_data;
 	int ret = 0;
 
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
 
 	return ret;
 }
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 790f422..5a26d4e 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -206,7 +206,6 @@ struct soc_camera_ops {
 	int (*resume)(struct soc_camera_device *);
 	unsigned long (*query_bus_param)(struct soc_camera_device *);
 	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
-	int (*enum_input)(struct soc_camera_device *, struct v4l2_input *);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
 };
-- 
1.7.2.5

