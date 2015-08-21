Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55055 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbHUSJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 14:09:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] v4l: omap3isp: Enable driver compilation with COMPILE_TEST
Date: Fri, 21 Aug 2015 21:09:17 +0300
Message-Id: <1440180557-28180-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver can't be compiled on non-ARM platforms but has no
compile-time dependency on OMAP. Drop the OMAP dependency when
COMPILE_TEST is set.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 484038185ae3..95f0f6e6bbc8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -85,7 +85,9 @@ config VIDEO_M32R_AR_M64278
 
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on ARCH_OMAP3 || COMPILE_TEST
+	depends on ARM
 	depends on HAS_DMA && OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
-- 
2.4.6

