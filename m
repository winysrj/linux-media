Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:52310 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbcISMrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 08:47:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] platform: pxa_camera: add VIDEO_V4L2 dependency
Date: Mon, 19 Sep 2016 14:46:30 +0200
Message-Id: <20160919124655.1466734-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moving the pxa_camera driver from soc_camera lots the implied
VIDEO_V4L2 Kconfig dependency, and building the driver without
V4L2 results in a kernel that cannot link:

drivers/media/platform/pxa_camera.o: In function `pxa_camera_remove':
pxa_camera.c:(.text.pxa_camera_remove+0x10): undefined reference to `v4l2_clk_unregister'
pxa_camera.c:(.text.pxa_camera_remove+0x18): undefined reference to `v4l2_device_unregister'
drivers/media/platform/pxa_camera.o: In function `pxa_camera_probe':
pxa_camera.c:(.text.pxa_camera_probe+0x458): undefined reference to `v4l2_of_parse_endpoint'
drivers/media/v4l2-core/videobuf2-core.o: In function `__enqueue_in_driver':
drivers/media/v4l2-core/videobuf2-core.o: In function `vb2_core_streamon':
videobuf2-core.c:(.text.vb2_core_streamon+0x1b4): undefined reference to `v4l_vb2q_enable_media_source'
drivers/media/v4l2-core/videobuf2-v4l2.o: In function `vb2_ioctl_reqbufs':
videobuf2-v4l2.c:(.text.vb2_ioctl_reqbufs+0xc): undefined reference to `video_devdata'

This adds back an explicit dependency.

Fixes: 3050b9985024 ("[media] media: platform: pxa_camera: move pxa_camera out of soc_camera")
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

