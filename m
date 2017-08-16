Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49006 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751893AbdHPMvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 2/5] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode
Date: Wed, 16 Aug 2017 15:51:47 +0300
Message-Id: <20170816125150.27199-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
References: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

ISP CSI1 module needs all the bits correctly set to work.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> # on Beagleboard-xM + MPT9P031
---
 drivers/media/platform/omap3isp/ispccp2.c | 7 +++++--
 drivers/media/platform/omap3isp/ispreg.h  | 4 ++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 8b6f7d2e79a0..47210b102bcb 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -213,14 +213,17 @@ static int ccp2_phyif_config(struct isp_ccp2_device *ccp2,
 	struct isp_device *isp = to_isp_device(ccp2);
 	u32 val;
 
-	/* CCP2B mode */
 	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL) |
-			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
+			    ISPCCP2_CTRL_MODE;
 	/* Data/strobe physical layer */
 	BIT_SET(val, ISPCCP2_CTRL_PHY_SEL_SHIFT, ISPCCP2_CTRL_PHY_SEL_MASK,
 		buscfg->phy_layer);
+	BIT_SET(val, ISPCCP2_CTRL_IO_OUT_SEL_SHIFT,
+		ISPCCP2_CTRL_IO_OUT_SEL_MASK, buscfg->ccp2_mode);
 	BIT_SET(val, ISPCCP2_CTRL_INV_SHIFT, ISPCCP2_CTRL_INV_MASK,
 		buscfg->strobe_clk_pol);
+	BIT_SET(val, ISPCCP2_CTRL_VP_CLK_POL_SHIFT,
+		ISPCCP2_CTRL_VP_CLK_POL_MASK, buscfg->vp_clk_pol);
 	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
 
 	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index b5ea8da0b904..d08483919a77 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -87,6 +87,8 @@
 #define ISPCCP2_CTRL_PHY_SEL_MASK	0x1
 #define ISPCCP2_CTRL_PHY_SEL_SHIFT	1
 #define ISPCCP2_CTRL_IO_OUT_SEL		(1 << 2)
+#define ISPCCP2_CTRL_IO_OUT_SEL_MASK	0x1
+#define ISPCCP2_CTRL_IO_OUT_SEL_SHIFT	2
 #define ISPCCP2_CTRL_MODE		(1 << 4)
 #define ISPCCP2_CTRL_VP_CLK_FORCE_ON	(1 << 9)
 #define ISPCCP2_CTRL_INV		(1 << 10)
@@ -94,6 +96,8 @@
 #define ISPCCP2_CTRL_INV_SHIFT		10
 #define ISPCCP2_CTRL_VP_ONLY_EN		(1 << 11)
 #define ISPCCP2_CTRL_VP_CLK_POL		(1 << 12)
+#define ISPCCP2_CTRL_VP_CLK_POL_MASK	0x1
+#define ISPCCP2_CTRL_VP_CLK_POL_SHIFT	12
 #define ISPCCP2_CTRL_VPCLK_DIV_SHIFT	15
 #define ISPCCP2_CTRL_VPCLK_DIV_MASK	0x1ffff /* [31:15] */
 #define ISPCCP2_CTRL_VP_OUT_CTRL_SHIFT	8 /* 3430 bits */
-- 
2.11.0
