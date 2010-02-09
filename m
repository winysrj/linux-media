Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f189.google.com ([209.85.211.189]:59253 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0BIIrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 03:47:20 -0500
Received: by ywh27 with SMTP id 27so6298337ywh.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 00:47:19 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, g.liakhovetski@gmx.de
Date: Tue, 09 Feb 2010 17:40:40 +0900
Message-Id: <20100209084040.29907.35986.sendpatchset@rxone.opensource.se>
Subject: [PATCH] soc-camera: return -ENODEV is sensor is missing
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@opensource.se>

Update the soc-camera i2c code to return -ENODEV if
a camera sensor is missing instead of -ENOMEM.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/media/video/soc_camera.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- 0001/drivers/media/video/soc_camera.c
+++ work/drivers/media/video/soc_camera.c	2010-02-09 17:32:58.000000000 +0900
@@ -846,10 +846,8 @@ static int soc_camera_init_i2c(struct so
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
 	struct v4l2_subdev *subdev;
-	int ret;
 
 	if (!adap) {
-		ret = -ENODEV;
 		dev_err(&icd->dev, "Cannot get I2C adapter #%d. No driver?\n",
 			icl->i2c_adapter_id);
 		goto ei2cga;
@@ -859,10 +857,8 @@ static int soc_camera_init_i2c(struct so
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
 				icl->module_name, icl->board_info, NULL);
-	if (!subdev) {
-		ret = -ENOMEM;
+	if (!subdev)
 		goto ei2cnd;
-	}
 
 	client = subdev->priv;
 
@@ -873,7 +869,7 @@ static int soc_camera_init_i2c(struct so
 ei2cnd:
 	i2c_put_adapter(adap);
 ei2cga:
-	return ret;
+	return -ENODEV;
 }
 
 static void soc_camera_free_i2c(struct soc_camera_device *icd)
