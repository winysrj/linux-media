Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:61096 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753588AbdGJIte (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:49:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] platform: video-mux: fix Kconfig dependency
Date: Mon, 10 Jul 2017 10:48:43 +0200
Message-Id: <20170710084906.1937968-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_V4L2 is built as a loadable module, the new video mux driver
fails to link as built-in code:

drivers/media/platform/video-mux.o: In function `video_mux_remove':
video-mux.c:(.text+0x24): undefined reference to `v4l2_async_unregister_subdev'
drivers/media/platform/video-mux.o: In function `video_mux_probe':
video-mux.c:(.text+0x800): undefined reference to `v4l2_subdev_init'
video-mux.c:(.text+0xa10): undefined reference to `v4l2_async_register_subdev'

This makes it use the same Kconfig dependency as all the other users of
the VIDEO_V4L2_SUBDEV_API symbol.

Fixes: 68803ad4522f ("[media] platform: add video-multiplexer subdevice driver")
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fb1fa0b82077..20179eb8f31e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -76,7 +76,7 @@ config VIDEO_M32R_AR_M64278
 
 config VIDEO_MUX
 	tristate "Video Multiplexer"
-	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2 && OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	select REGMAP
 	help
 	  This driver provides support for N:1 video bus multiplexers.
-- 
2.9.0
