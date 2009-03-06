Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:43432 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752702AbZCFJoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 04:44:39 -0500
From: Philippe =?utf-8?q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: Guennadi Liakhovetski <lg@denx.de>
Subject: [PATCH] mt9t031 bugfix
Date: Fri, 6 Mar 2009 10:37:51 +0100
Cc: linux-media@vger.kernel.org,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200903061037.51684.philippe.retornaz@epfl.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- The video device is not allocated when mt9t031_init() is called, don't use 
it in debug printk.

- The clock polarity is inverted in mt9t031_set_bus_param(), use the correct 
one.


Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>

---

diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index acc1fa9..d846110 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -144,8 +144,6 @@ static int mt9t031_init(struct soc_camera_device *icd)
 	int ret;
 
 	/* Disable chip output, synchronous option update */
-	dev_dbg(icd->vdev->parent, "%s\n", __func__);
-
 	ret = reg_write(icd, MT9T031_RESET, 1);
 	if (ret >= 0)
 		ret = reg_write(icd, MT9T031_RESET, 0);
@@ -186,9 +184,9 @@ static int mt9t031_set_bus_param(struct soc_camera_device *icd,
 		return -EINVAL;
 
 	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
-		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
-	else
 		reg_clear(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
+	else
+		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
 
 	return 0;
 }
