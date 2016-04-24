Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36660 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbcDXVKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id w143so16620920wmw.3
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:35 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 22/24] [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode
Date: Mon, 25 Apr 2016 00:08:22 +0300
Message-Id: <1461532104-24032-23-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ISP CSI1 module needs all the bits correctly set to work.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/media/platform/omap3isp/isp.c      | 2 ++
 drivers/media/platform/omap3isp/ispccp2.c  | 7 +++++--
 drivers/media/platform/omap3isp/ispreg.h   | 4 ++++
 drivers/media/platform/omap3isp/omap3isp.h | 1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index e51a1f9..6361fde 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2056,6 +2056,8 @@ static void isp_of_parse_node_csi1(struct device *dev,
 	 * sensor. Frame descriptors, perhaps?
 	 */
 	buscfg->bus.ccp2.crc = 1;
+
+	buscfg->bus.ccp2.vp_clk_pol = 1;
 }
 
 static void isp_of_parse_node_csi2(struct device *dev,
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ca09523..7bb7feb 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -213,14 +213,17 @@ static int ccp2_phyif_config(struct isp_ccp2_device *ccp2,
 	struct isp_device *isp = to_isp_device(ccp2);
 	u32 val;
 
-	/* CCP2B mode */
 	val = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL) |
-			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
+	      ISPCCP2_CTRL_MODE;
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
index b5ea8da..d084839 100644
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
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
index 443e8f7..f6d1d0d 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -108,6 +108,7 @@ struct isp_ccp2_cfg {
 	unsigned int ccp2_mode:1;
 	unsigned int phy_layer:1;
 	unsigned int vpclk_div:2;
+	unsigned int vp_clk_pol:1;
 	struct isp_csiphy_lanes_cfg lanecfg;
 };
 
-- 
1.9.1

