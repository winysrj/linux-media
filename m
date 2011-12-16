Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1LPIA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 03:00:57 -0500
Received: by wgbdr13 with SMTP id dr13so5726309wgb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 00:00:56 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, saaguirre@ti.com, mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] V4L: soc-camera: provide support for S_INPUT.
Date: Fri, 16 Dec 2011 09:00:43 +0100
Message-Id: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some v4l-subdevs such as tvp5150 have multiple
inputs. This patch allows the user of a soc-camera
device to select between them.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/soc_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b72580c..1cea1a9 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -235,10 +235,10 @@ static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
 
 static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
 {
-	if (i > 0)
-		return -EINVAL;
+	struct soc_camera_device *icd = file->private_data;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
-	return 0;
+	return v4l2_subdev_call(sd, video, s_routing, i, 0, 0);
 }
 
 static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
-- 
1.7.0.4

