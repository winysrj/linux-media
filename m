Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65036 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752317AbeCCUvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/11] media: em28xx-camera: fix coding style issues
Date: Sat,  3 Mar 2018 17:51:06 -0300
Message-Id: <359607716b49f88206e5c71065ac66aacbeff1a4.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some coding style issues at em28xx-camera.

Fix them, by using checkpatch in strict mode to point for it.
Automatic fixes with --fix-inplace were complemented by manual
work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index f0c52da17372..3c2694a16ed1 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -45,7 +45,7 @@ static int em28xx_initialize_mt9m111(struct em28xx *dev)
 		{ 0x0d, 0x00, 0x01, },  /* reset and use defaults */
 		{ 0x0d, 0x00, 0x00, },
 		{ 0x0a, 0x00, 0x21, },
-		{ 0x21, 0x04, 0x00, },  /* full readout speed, no row/col skipping */
+		{ 0x21, 0x04, 0x00, },  /* full readout spd, no row/col skip */
 	};
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
@@ -153,7 +153,8 @@ static int em28xx_probe_sensor_micron(struct em28xx *dev)
 			break;
 		default:
 			dev_info(&dev->intf->dev,
-				 "unknown Micron sensor detected: 0x%04x\n", id);
+				 "unknown Micron sensor detected: 0x%04x\n",
+				 id);
 			return 0;
 		}
 
@@ -182,8 +183,10 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 	struct i2c_client *client = &dev->i2c_client[dev->def_i2c_bus];
 
 	dev->em28xx_sensor = EM28XX_NOSENSOR;
-	/* NOTE: these devices have the register auto incrementation disabled
-	 * by default, so we have to use single byte reads !              */
+	/*
+	 * NOTE: these devices have the register auto incrementation disabled
+	 * by default, so we have to use single byte reads !
+	 */
 	for (i = 0; omnivision_sensor_addrs[i] != I2C_CLIENT_END; i++) {
 		client->addr = omnivision_sensor_addrs[i];
 		/* Read manufacturer ID from registers 0x1c-0x1d (BE) */
@@ -393,7 +396,7 @@ int em28xx_init_camera(struct em28xx *dev)
 		subdev =
 		     v4l2_i2c_new_subdev_board(&v4l2->v4l2_dev, adap,
 					       &ov2640_info, NULL);
-		if (subdev == NULL)
+		if (!subdev)
 			return -ENODEV;
 
 		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
-- 
2.14.3
