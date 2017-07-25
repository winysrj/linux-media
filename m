Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61531 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdGYPhz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 11:37:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: add KConfig dependencies
Date: Tue, 25 Jul 2017 17:36:45 +0200
Message-Id: <20170725153735.239734-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new ov5670 driver fails to build when VIDEO_V4L2_SUBDEV_API
or MEDIA_CONTROLLER are disabled:

drivers/media/i2c/ov5670.c: In function 'ov5670_open':
drivers/media/i2c/ov5670.c:1917:5: error: implicit declaration of function 'v4l2_subdev_get_try_format'; did you mean 'v4l2_subdev_notify_event'? [-Werror=implicit-function-declaration]
     v4l2_subdev_get_try_format(sd, fh->pad, 0);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     v4l2_subdev_notify_event
drivers/media/i2c/ov5670.c:1917:38: error: 'struct v4l2_subdev_fh' has no member named 'pad'
     v4l2_subdev_get_try_format(sd, fh->pad, 0);
                                      ^~
drivers/media/i2c/ov5670.c: In function 'ov5670_do_get_pad_format':
drivers/media/i2c/ov5670.c:2198:17: error: invalid type argument of unary '*' (have 'int')
   fmt->format = *v4l2_subdev_get_try_format(&ov5670->sd, cfg,
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          fmt->pad);
          ~~~~~~~~~
drivers/media/i2c/ov5670.c: At top level:
drivers/media/i2c/ov5670.c:2444:19: error: 'v4l2_subdev_link_validate' undeclared here (not in a function); did you mean 'v4l2_subdev_init'?
  .link_validate = v4l2_subdev_link_validate,
                   ^~~~~~~~~~~~~~~~~~~~~~~~~
                   v4l2_subdev_init
drivers/media/i2c/ov5670.c: In function 'ov5670_probe':
drivers/media/i2c/ov5670.c:2492:12: error: 'struct v4l2_subdev' has no member named 'entity'

This adds both to the Kconfig entry.

Fixes: 5de35c9b8dcd ("media: i2c: Add Omnivision OV5670 5M sensor support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index a05e40ecba7c..94153895fcd4 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -618,8 +618,9 @@ config VIDEO_OV6650
 
 config VIDEO_OV5670
 	tristate "OmniVision OV5670 sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
-- 
2.9.0
