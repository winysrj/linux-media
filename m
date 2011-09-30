Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:38620 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1I3VfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 17:35:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mchehab@redhat.com
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au,
	linux-next@vger.kernel.org, linux-media@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] drivers/media: fix dependencies in video mt9t001/mt9p031
Date: Fri, 30 Sep 2011 17:34:51 -0400
Message-Id: <1317418491-26513-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <4E83A02F.2020309@xenotime.net>
References: <4E83A02F.2020309@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both mt9t001.c and mt9p031.c have two identical issues, those
being that they will need module.h inclusion for the upcoming
cleanup going on there, and that their dependencies don't limit
selection of configs that will fail to compile as follows:

drivers/media/video/mt9p031.c:457: error: implicit declaration of function ‘v4l2_subdev_get_try_crop’
drivers/media/video/mt9t001.c:787: error: ‘struct v4l2_subdev’ has no member named ‘entity’

The related config options are CONFIG_MEDIA_CONTROLLER and
CONFIG_VIDEO_V4L2_SUBDEV_API.  Looking at the code, it appears
that the driver was never intended to work without these enabled,
so add a dependency on CONFIG_VIDEO_V4L2_SUBDEV_API, which in
turn already has a dependency on CONFIG_MEDIA_CONTROLLER.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 75e43c0..d285c8c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -469,14 +469,14 @@ config VIDEO_OV7670
 
 config VIDEO_MT9P031
 	tristate "Aptina MT9P031 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt9p031 5 Mpixel camera.
 
 config VIDEO_MT9T001
 	tristate "Aptina MT9T001 support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Aptina
 	  (Micron) mt0t001 3 Mpixel camera.
diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 8bcb1ce..fc9603f 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -14,6 +14,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
diff --git a/drivers/media/video/mt9t001.c b/drivers/media/video/mt9t001.c
index ae75d82..280d01d 100644
--- a/drivers/media/video/mt9t001.c
+++ b/drivers/media/video/mt9t001.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
-- 
1.7.6

