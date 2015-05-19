Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59362 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbbESMjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 08:39:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Benoit Parrot <bparrot@ti.com>,
	Prabhakar <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] [media] ov2659: add v4l2_subdev dependency
Date: Tue, 19 May 2015 14:39:12 +0200
Message-ID: <6092911.yr0lA5IaG4@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added ov2659 driver uses the v4l2 subdev API, but
can be enabled even when that API is not part of the kernel,
resulting in this build error:

media/i2c/ov2659.c: In function 'ov2659_get_fmt':
media/i2c/ov2659.c:1054:8: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
media/i2c/ov2659.c:1054:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
media/i2c/ov2659.c: In function 'ov2659_set_fmt':
media/i2c/ov2659.c:1129:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
media/i2c/ov2659.c: In function 'ov2659_open':
media/i2c/ov2659.c:1264:38: error: 'struct v4l2_subdev_fh' has no member named 'pad'

This adds an explicit dependency, like all the other drivers have.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: c4c0283ab3c ("[media] media: i2c: add support for omnivision's ov2659 sensor")

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6f30ea76151a..db01ed84918f 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -469,7 +469,7 @@ config VIDEO_SMIAPP_PLL
 config VIDEO_OV2659
 	tristate "OmniVision OV2659 sensor support"
 	depends on VIDEO_V4L2 && I2C
-	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV2659 camera.
