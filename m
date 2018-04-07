Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45349 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeDGLkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 07:40:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: omap3isp: Enable driver compilation on ARM with COMPILE_TEST
Date: Sat,  7 Apr 2018 14:40:08 +0300
Message-Id: <20180407114008.6707-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver can't be compiled on non-ARM platforms but has no
compile-time dependency on OMAP. It however requires common clock
framework support, which isn't provided by all ARM platforms.

Drop the OMAP dependency when COMPILE_TEST is set and add ARM and
COMMON_CLK dependencies.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Hi Mauro,

While we continue the discussions on whether the ARM IOMMU functions should be
stubbed in the omap3isp driver itself or not, I propose already merging this
patch that will extend build coverage for the omap3isp driver. Extending
compilation to non-ARM platforms can then be added on top, depending on the
result of the discussion.

You might have noticed the 0-day build bot report reporting that the driver
depends on the common clock framework (build failure on openrisc). The issue
affects ARM as well as not all ARM platforms use the common clock framework.
I've thus also added a dependency on COMMON_CLK. Note that this dependency can
prevent compilation on x86 platforms. If you want to fix that, the
definition of struct clk_hw in include/linux/clk-provider.h will need to be
exposed even when CONFIG_COMMON_CLK isn't selected. I'll let you propose a fix
for that issue to the clock maintainers if you think it should be addressed.

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7a1cf8a1b01..58aa233d3cf9 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -62,7 +62,10 @@ config VIDEO_MUX
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on ARCH_OMAP3 || COMPILE_TEST
+	depends on ARM
+	depends on COMMON_CLK
 	depends on HAS_DMA && OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
-- 
Regards,

Laurent Pinchart
