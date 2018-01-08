Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:52148 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755598AbeAHMxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 07:53:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wenyou Yang <wenyou.yang@microchip.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: ov7740: add media-controller dependency
Date: Mon,  8 Jan 2018 13:52:28 +0100
Message-Id: <20180108125322.3993808-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without CONFIG_MEDIA_CONTROLLER, the new driver fails to build:

drivers/perf/arm_dsu_pmu.c: In function 'dsu_pmu_probe_pmu':
drivers/perf/arm_dsu_pmu.c:661:2: error: implicit declaration of function 'bitmap_from_u32array'; did you mean 'bitmap_from_arr32'? [-Werror=implicit-function-declaration]

This adds a dependency similar to what we have for other drivers
like this.

Fixes: 39c5c4471b8d ("media: i2c: Add the ov7740 image sensor driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 9f18cd296841..03cf3a1a1e06 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -667,7 +667,7 @@ config VIDEO_OV7670
 
 config VIDEO_OV7740
 	tristate "OmniVision OV7740 sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
-- 
2.9.0
