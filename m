Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44225 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbDLM1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2015 08:27:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH] v4l: omap4iss: Replace outdated OMAP4 control pad API with syscon
Date: Sun, 12 Apr 2015 15:28:13 +0300
Message-Id: <1428841693-15109-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <3292592.cickJMVhRq@wuerfel>
References: <3292592.cickJMVhRq@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap4_ctrl_pad_readl and omap4_ctrl_pad_writel functions have been
removed by commit efde234674d9 ("ARM: OMAP4+: control: remove support
for legacy pad read/write") but are still used by the OMAP4 ISS driver,
resulting in a compilation breakage:

drivers/staging/media/omap4iss/iss_csiphy.c: In function 'omap4iss_csiphy_config':
drivers/staging/media/omap4iss/iss_csiphy.c:167:2: error: implicit declaration of function 'omap4_ctrl_pad_writel' [-Werror=implicit-function-declaration]
  omap4_ctrl_pad_writel(cam_rx_ctrl,

Fix the problem by using the syscon API to reaplace the control pad API.
Lookup the syscon instance by compatible name for now as the OMAP4 ISS
driver doesn't support DT yet.

Fixes: efde234674d9 ("ARM: OMAP4+: control: remove support for legacy pad read/write")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/Kconfig      |  1 +
 drivers/staging/media/omap4iss/iss.c        | 11 +++++++++++
 drivers/staging/media/omap4iss/iss.h        |  4 ++++
 drivers/staging/media/omap4iss/iss_csiphy.c | 12 +++++++-----
 4 files changed, 23 insertions(+), 5 deletions(-)

Hi Arnd,

This patch doesn't depend nor conflict with the OMAP4 ISS patches scheduled to
be merged in v4.1. If Mauro is fine with that, and if it makes your life
easier, it could get merged through the arm-soc tree. Please let me know what
you prefer.

diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index b78643f..072dac0 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_OMAP4
 	bool "OMAP 4 Camera support"
 	depends on VIDEO_V4L2=y && VIDEO_V4L2_SUBDEV_API && I2C=y && ARCH_OMAP4
 	depends on HAS_DMA
+	select MFD_SYSCON
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 4 ISS controller.
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 44b81a2..cf22dd2 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
@@ -1386,6 +1387,16 @@ static int iss_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, iss);
 
+	/*
+	 * TODO: When implementing DT support switch to syscon regmap lookup by
+	 * phandle.
+	 */
+	iss->syscon = syscon_regmap_lookup_by_compatible("syscon");
+	if (IS_ERR(iss->syscon)) {
+		ret = PTR_ERR(iss->syscon);
+		goto error;
+	}
+
 	/* Clocks */
 	ret = iss_map_mem_resource(pdev, iss, OMAP4_ISS_MEM_TOP);
 	if (ret < 0)
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 734cfee..35df8b4 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -29,6 +29,8 @@
 #include "iss_ipipe.h"
 #include "iss_resizer.h"
 
+struct regmap;
+
 #define to_iss_device(ptr_module)				\
 	container_of(ptr_module, struct iss_device, ptr_module)
 #define to_device(ptr_module)						\
@@ -79,6 +81,7 @@ struct iss_reg {
 
 /*
  * struct iss_device - ISS device structure.
+ * @syscon: Regmap for the syscon register space
  * @crashed: Bitmask of crashed entities (indexed by entity ID)
  */
 struct iss_device {
@@ -93,6 +96,7 @@ struct iss_device {
 
 	struct resource *res[OMAP4_ISS_MEM_LAST];
 	void __iomem *regs[OMAP4_ISS_MEM_LAST];
+	struct regmap *syscon;
 
 	u64 raw_dmamask;
 
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 7c3d55d..748607f 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -13,6 +13,7 @@
 
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/regmap.h>
 
 #include "../../../../arch/arm/mach-omap2/control.h"
 
@@ -140,9 +141,11 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 	 * - bit [18] : CSIPHY1 CTRLCLK enable
 	 * - bit [17:16] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
 	 */
-	cam_rx_ctrl = omap4_ctrl_pad_readl(
-			OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
-
+	/*
+	 * TODO: When implementing DT support specify the CONTROL_CAMERA_RX
+	 * register offset in the syscon property instead of hardcoding it.
+	 */
+	regmap_read(iss->syscon, 0x68, &cam_rx_ctrl);
 
 	if (subdevs->interface == ISS_INTERFACE_CSI2A_PHY1) {
 		cam_rx_ctrl &= ~(OMAP4_CAMERARX_CSI21_LANEENABLE_MASK |
@@ -166,8 +169,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 		cam_rx_ctrl |= OMAP4_CAMERARX_CSI22_CTRLCLKEN_MASK;
 	}
 
-	omap4_ctrl_pad_writel(cam_rx_ctrl,
-		 OMAP4_CTRL_MODULE_PAD_CORE_CONTROL_CAMERA_RX);
+	regmap_write(iss->syscon, 0x68, cam_rx_ctrl);
 
 	/* Reset used lane count */
 	csi2->phy->used_data_lanes = 0;
-- 
Regards,

Laurent Pinchart

