Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:49990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab1CWKFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:05:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D4832189B85
	for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 11:05:08 +0100 (CET)
Date: Wed, 23 Mar 2011 11:05:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: don't dereference I2C client after it has
 been removed
Message-ID: <Pine.LNX.4.64.1103231104390.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

i2c_unregister_device() frees the I2C client, so, dereferencing it
afterwards is a bug, that leads to Oopses.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index e97be53..2f0fd2f 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -996,10 +996,11 @@ static void soc_camera_free_i2c(struct soc_camera_device *icd)
 {
 	struct i2c_client *client =
 		to_i2c_client(to_soc_camera_control(icd));
+	struct i2c_adapter *adap = client->adapter;
 	dev_set_drvdata(&icd->dev, NULL);
 	v4l2_device_unregister_subdev(i2c_get_clientdata(client));
 	i2c_unregister_device(client);
-	i2c_put_adapter(client->adapter);
+	i2c_put_adapter(adap);
 }
 #else
 #define soc_camera_init_i2c(icd, icl)	(-ENODEV)
-- 
1.7.2.5

