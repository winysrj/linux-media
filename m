Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:45283 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660Ab1LOJuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:50:39 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC 2/4] omap3isp: Add lane configuration to platform data
Date: Thu, 15 Dec 2011 11:50:33 +0200
Message-Id: <1323942635-13058-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111215095015.GC3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane configuration (order of clock and data lane) to platform data on
both CCP2 and CSI-2.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispcsiphy.h |   15 ++-------------
 include/media/omap3isp.h                 |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/video/omap3isp/ispcsiphy.h
index 9596dc6..e93a661 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -27,22 +27,11 @@
 #ifndef OMAP3_ISP_CSI_PHY_H
 #define OMAP3_ISP_CSI_PHY_H
 
+#include <media/omap3isp.h>
+
 struct isp_csi2_device;
 struct regulator;
 
-struct csiphy_lane {
-	u8 pos;
-	u8 pol;
-};
-
-#define ISP_CSIPHY2_NUM_DATA_LANES	2
-#define ISP_CSIPHY1_NUM_DATA_LANES	1
-
-struct isp_csiphy_lanes_cfg {
-	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
-	struct csiphy_lane clk;
-};
-
 struct isp_csiphy_dphy_cfg {
 	u8 ths_term;
 	u8 ths_settle;
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index e917b1d..8fe0bdf 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -86,6 +86,19 @@ enum {
 	ISP_CCP2_MODE_CCP2 = 1,
 };
 
+struct csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+#define ISP_CSIPHY2_NUM_DATA_LANES	2
+#define ISP_CSIPHY1_NUM_DATA_LANES	1
+
+struct isp_csiphy_lanes_cfg {
+	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
+	struct csiphy_lane clk;
+};
+
 /**
  * struct isp_ccp2_platform_data - CCP2 interface platform data
  * @strobe_clk_pol: Strobe/clock polarity
@@ -105,6 +118,7 @@ struct isp_ccp2_platform_data {
 	unsigned int ccp2_mode:1;
 	unsigned int phy_layer:1;
 	unsigned int vpclk_div:2;
+	struct isp_csiphy_lanes_cfg *lanecfg;
 };
 
 /**
@@ -115,6 +129,7 @@ struct isp_ccp2_platform_data {
 struct isp_csi2_platform_data {
 	unsigned crc:1;
 	unsigned vpclk_div:2;
+	struct isp_csiphy_lanes_cfg *lanecfg;
 };
 
 struct isp_subdev_i2c_board_info {
-- 
1.7.2.5

