Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62142 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFMMCc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 08:02:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [RFC] [media] omap3isp: try to fix dependencies
Date: Fri, 13 Jun 2014 14:02:01 +0200
Message-ID: <46586956.hxqoJOmDbk@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 2a0a5472af5c ("omap3isp: Use the ARM DMA IOMMU-aware operations")
brought the omap3isp driver closer to using standard APIs, but also
introduced two problems:

a) it selects a particular IOMMU driver for no good reason. This just
   causes hard to track dependency chains, in my case breaking an
   experimental patch set that tries to reenable !MMU support on ARM
   multiplatform kernels. Since the driver doesn't have a dependency
   on the actual IOMMU implementation (other than sitting on the same
   SoC), this changes the 'select OMAP_IOMMU' to a generic 'depends on
   IOMMU_API' that reflects the actual usage.

b) The driver incorrectly calls into low-level helpers designed to
   be used by the IOMMU implementation:
   arm_iommu_{create,attach,release}_mapping. I'm not fixing this
   here, but adding a FIXME and a dependency on ARM_DMA_USE_IOMMU.
   I believe the correct solution is to move the calls into the
   omap iommu driver that currently doesn't have them, and change
   the isp driver to call generic functions.

In addition, this also adds the missing 'select VIDEOBUF2_DMA_CONTIG'
that is needed since fbac1400bd1 ("[media] omap3isp: Move to videobuf2")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----

Hi Laurent,

Could you have a look at this? It's possible I'm missing something
important here, but this is what I currently need to get randconfig
builds to use the omap3isp driver.

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8108c69..15bf61b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -94,8 +94,9 @@ config VIDEO_M32R_AR_M64278
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
-	select ARM_DMA_USE_IOMMU
-	select OMAP_IOMMU
+	depends on ARM_DMA_USE_IOMMU # FIXME: use iommu API instead of low-level ARM calls
+	depends on IOMMU_API
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 3 camera controller.
 

