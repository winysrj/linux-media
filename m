Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51688 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2LKNKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 08:10:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: csiphy: Fix an uninitialized variable compiler warning
Date: Tue, 11 Dec 2012 14:11:52 +0100
Message-Id: <1355231512-5158-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/omap3isp/ispcsiphy.c: In function
‘csiphy_routing_cfg’:
drivers/media/platform/omap3isp/ispcsiphy.c:71:57: warning: ‘shift’
may be used uninitialized in this function [-Wuninitialized]
drivers/media/platform/omap3isp/ispcsiphy.c:40:6: note: ‘shift’ was
declared here

The warning is a false positive but the compiler is right in
complaining. Fix it by using the correct enum data type for the iface
argument and adding a default case in the switch statement.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispcsiphy.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 3d56b33..c09de32 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -32,7 +32,8 @@
 #include "ispreg.h"
 #include "ispcsiphy.h"
 
-static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
+static void csiphy_routing_cfg_3630(struct isp_csiphy *phy,
+				    enum isp_interface_type iface,
 				    bool ccp2_strobe)
 {
 	u32 reg = isp_reg_readl(
@@ -40,6 +41,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
 	u32 shift, mode;
 
 	switch (iface) {
+	default:
+	/* Should not happen in practice, but let's keep the compiler happy. */
 	case ISP_INTERFACE_CCP2B_PHY1:
 		reg &= ~OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
 		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
@@ -59,9 +62,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
 	}
 
 	/* Select data/clock or data/strobe mode for CCP2 */
-	switch (iface) {
-	case ISP_INTERFACE_CCP2B_PHY1:
-	case ISP_INTERFACE_CCP2B_PHY2:
+	if (iface == ISP_INTERFACE_CCP2B_PHY1 ||
+	    iface == ISP_INTERFACE_CCP2B_PHY2) {
 		if (ccp2_strobe)
 			mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_CCP2_DATA_STROBE;
 		else
@@ -110,7 +112,8 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
  * and 3630, so they will not hold their contents in off-mode. This isn't an
  * issue since the MPU power domain is forced on whilst the ISP is in use.
  */
-static void csiphy_routing_cfg(struct isp_csiphy *phy, u32 iface, bool on,
+static void csiphy_routing_cfg(struct isp_csiphy *phy,
+			       enum isp_interface_type iface, bool on,
 			       bool ccp2_strobe)
 {
 	if (phy->isp->mmio_base[OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL]
-- 
Regards,

Laurent Pinchart

