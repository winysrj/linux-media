Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53208 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757176Ab2JJUBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 16:01:46 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, tony@atomide.com,
	khilman@deeprootsystems.com
Subject: [PATCH v4 2/3] omap3isp: Add PHY routing configuration
Date: Wed, 10 Oct 2012 23:01:41 +0300
Message-Id: <1349899302-9041-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121010200115.GO14107@valkosipuli.retiisi.org.uk>
References: <20121010200115.GO14107@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PHY routing configuration for both 3430 and 3630. Also add register bit
definitions of CSIRXFE and CAMERA_PHY_CTRL registers on OMAP 3430 and 3630,
respectively.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/ispcsiphy.c |   92 +++++++++++++++++++++++++++
 drivers/media/platform/omap3isp/ispreg.h    |   22 +++++++
 2 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 348f67e..12ae394 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -32,6 +32,98 @@
 #include "ispreg.h"
 #include "ispcsiphy.h"
 
+static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
+				    bool ccp2_strobe)
+{
+	u32 reg = isp_reg_readl(
+		phy->isp, OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
+	u32 shift, mode;
+
+	switch (iface) {
+	case ISP_INTERFACE_CCP2B_PHY1:
+		reg &= ~OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
+		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
+		break;
+	case ISP_INTERFACE_CSI2C_PHY1:
+		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
+		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
+		break;
+	case ISP_INTERFACE_CCP2B_PHY2:
+		reg |= OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
+		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
+		break;
+	case ISP_INTERFACE_CSI2A_PHY2:
+		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
+		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
+		break;
+	}
+
+	/* Select data/clock or data/strobe mode for CCP2 */
+	switch (iface) {
+	case ISP_INTERFACE_CCP2B_PHY1:
+	case ISP_INTERFACE_CCP2B_PHY2:
+		if (ccp2_strobe)
+			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE;
+		else
+			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_CLOCK;
+	}
+
+	reg &= ~(OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK << shift);
+	reg |= mode << shift;
+
+	isp_reg_writel(phy->isp, reg,
+		       OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
+}
+
+static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
+				    bool ccp2_strobe)
+{
+	uint32_t csirxfe = OMAP343X_CONTROL_CSIRXFE_PWRDNZ
+		| OMAP343X_CONTROL_CSIRXFE_RESET;
+
+	/* Nothing to configure here. */
+	if (iface == ISP_INTERFACE_CSI2A_PHY2)
+		return;
+
+	if (iface != ISP_INTERFACE_CCP2B_PHY1)
+		return;
+
+	if (!on) {
+		isp_reg_writel(phy->isp, 0,
+			       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
+		return;
+	}
+
+	if (ccp2_strobe)
+		csirxfe |= OMAP343X_CONTROL_CSIRXFE_SELFORM;
+
+	isp_reg_writel(phy->isp, csirxfe,
+		       OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE, 0);
+}
+
+/**
+ * Configure OMAP 3 CSI PHY routing.
+ *
+ * Note that the underlying routing configuration registers are part
+ * of the control (SCM) register space and part of the CORE power
+ * domain on both 3430 and 3630, so they will not hold their contents
+ * in off-mode.
+ *
+ * @phy: relevant phy device
+ * @iface: ISP_INTERFACE_*
+ * @on: power on or off
+ * @ccp2_strobe: false: data/clock, true: data/strobe
+ */
+static void csiphy_routing_cfg(struct isp_csiphy *phy, u32 iface, bool on,
+			       bool ccp2_strobe)
+{
+	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL]
+	    && on)
+		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
+	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_343X_CONTROL_CSIRXFE])
+		return csiphy_routing_cfg_3430(phy, iface, on, ccp2_strobe);
+}
+
 /*
  * csiphy_lanes_config - Configuration of CSIPHY lanes.
  *
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index e2c57f3..148108b 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -1583,4 +1583,26 @@
 #define ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_MASK		\
 	(0x7fffff << ISPCSIPHY_REG2_CCP2_SYNC_PATTERN_SHIFT)
 
+/* -----------------------------------------------------------------------------
+ * CONTROL registers for CSI-2 phy routing
+ */
+
+/* OMAP343X_CONTROL_CSIRXFE */
+#define OMAP343X_CONTROL_CSIRXFE_CSIB_INV	(1 << 7)
+#define OMAP343X_CONTROL_CSIRXFE_RESENABLE	(1 << 8)
+#define OMAP343X_CONTROL_CSIRXFE_SELFORM	(1 << 10)
+#define OMAP343X_CONTROL_CSIRXFE_PWRDNZ		(1 << 12)
+#define OMAP343X_CONTROL_CSIRXFE_RESET		(1 << 13)
+
+/* OMAP3630_CONTROL_CAMERA_PHY_CTRL */
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT	2
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT	0
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY		0x0
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE 0x1
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_CLOCK 0x2
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_GPI		0x3
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_MASK		0x3
+/* CCP2B: set to receive data from PHY2 instead of PHY1 */
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2	(1 << 4)
+
 #endif	/* OMAP3_ISP_REG_H */
-- 
1.7.2.5

