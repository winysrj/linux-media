Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54251 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752472AbcLLPza (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/15] em28xx: drop last soc_camera link
Date: Mon, 12 Dec 2016 16:55:18 +0100
Message-Id: <20161212155520.41375-14-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The em28xx driver still used the soc_camera.h header for the ov2640
driver. Since this driver no longer uses soc_camera, that include can
be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 2e24b65..640a639 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -23,7 +23,6 @@
 
 #include <linux/i2c.h>
 #include <linux/usb.h>
-#include <media/soc_camera.h>
 #include <media/i2c/mt9v011.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
@@ -43,13 +42,6 @@ static unsigned short omnivision_sensor_addrs[] = {
 	I2C_CLIENT_END
 };
 
-static struct soc_camera_link camlink = {
-	.bus_id = 0,
-	.flags = 0,
-	.module_name = "em28xx",
-	.unbalanced_power = true,
-};
-
 /* FIXME: Should be replaced by a proper mt9m111 driver */
 static int em28xx_initialize_mt9m111(struct em28xx *dev)
 {
@@ -421,7 +413,6 @@ int em28xx_init_camera(struct em28xx *dev)
 			.type = "ov2640",
 			.flags = I2C_CLIENT_SCCB,
 			.addr = client->addr,
-			.platform_data = &camlink,
 		};
 		struct v4l2_subdev_format format = {
 			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-- 
2.10.2

