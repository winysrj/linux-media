Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:57535 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbdHGKtr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 06:49:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging/imx: always select VIDEOBUF2_DMA_CONTIG
Date: Mon,  7 Aug 2017 12:49:18 +0200
Message-Id: <20170807104929.3651892-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I ran into a rare build error during randconfig testing:

drivers/staging/media/imx/imx-media-capture.o: In function `capture_stop_streaming':
imx-media-capture.c:(.text+0x224): undefined reference to `vb2_buffer_done'
drivers/staging/media/imx/imx-media-capture.o: In function `imx_media_capture_device_register':
imx-media-capture.c:(.text+0xe60): undefined reference to `vb2_queue_init'
imx-media-capture.c:(.text+0xfa0): undefined reference to `vb2_dma_contig_memops'

While VIDEOBUF2_DMA_CONTIG was already selected by the camera driver,
it wasn't necessarily there with just the base driver enabled.
This moves the 'select' statement to the top-level option to make
sure it's always available.

Fixes: 64b5a49df486 ("[media] media: imx: Add Capture Device Interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 719508fcb0e9..2be921cd0d55 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_IMX_MEDIA
 	tristate "i.MX5/6 V4L2 media core driver"
 	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
 	depends on VIDEO_V4L2_SUBDEV_API
+	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_FWNODE
 	---help---
 	  Say yes here to enable support for video4linux media controller
@@ -13,7 +14,6 @@ menu "i.MX5/6 Media Sub devices"
 config VIDEO_IMX_CSI
 	tristate "i.MX5/6 Camera Sensor Interface driver"
 	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
-	select VIDEOBUF2_DMA_CONTIG
 	default y
 	---help---
 	  A video4linux camera sensor interface driver for i.MX5/6.
-- 
2.9.0
