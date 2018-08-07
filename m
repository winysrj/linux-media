Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49364 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389181AbeHGR2g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 13:28:36 -0400
To: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] media/i2c: fix mt9v111.c build error
Message-ID: <61037652-d37e-387a-7f32-7730c03e1e45@infradead.org>
Date: Tue, 7 Aug 2018 08:13:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error in mt9v111.c when
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set

../drivers/media/i2c/mt9v111.c: In function ‘__mt9v111_get_pad_format’:
../drivers/media/i2c/mt9v111.c:801:3: error: implicit declaration of function ‘v4l2_subdev_get_try_format’ [-Werror=implicit-function-declaration]
   return v4l2_subdev_get_try_format(&mt9v111->sd, cfg, pad);

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jacopo Mondi <jacopo@jmondi.org>
---
 drivers/media/i2c/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180807.orig/drivers/media/i2c/Kconfig
+++ linux-next-20180807/drivers/media/i2c/Kconfig
@@ -875,7 +875,7 @@ config VIDEO_MT9V032
 
 config VIDEO_MT9V111
 	tristate "Aptina MT9V111 sensor support"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	help
 	  This is a Video4Linux2 sensor driver for the Aptina/Micron
