Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:62996 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932816AbcKPOkc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:40:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pxa_camera: add V4L2 dependency
Date: Wed, 16 Nov 2016 15:39:54 +0100
Message-Id: <20161116144016.2487252-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moving this driver out of soc_camera has resulted in a new randconfig failure:

drivers/media/built-in.o: In function `pxa_camera_remove':
pxa_camera.c:(.text+0x1854d): undefined reference to `v4l2_clk_unregister'
pxa_camera.c:(.text+0x18555): undefined reference to `v4l2_device_unregister'
drivers/media/built-in.o: In function `pxa_camera_sensor_unbind':
pxa_camera.c:(.text+0x185dd): undefined reference to `video_unregister_device'

As the driver now can be built for COMPILE_TEST as well, this means we
can see the problem even on non-PXA platforms.
Adding a dependency on VIDEO_V4L2 ensures this cannot happen and matches
what the other drivers do.

Fixes: 4bb738f228b3 ("[media] media: platform: pxa_camera: move pxa_camera out of soc_camera")
Fixes: 5809ecdd6c3c ("[media] pxa_camera: allow building it if COMPILE_TEST is set")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ce4a96fccc43..5ff803efdc03 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -93,7 +93,7 @@ config VIDEO_OMAP3_DEBUG
 
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && HAS_DMA
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	depends on PXA27x || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
 	select SG_SPLIT
-- 
2.9.0

