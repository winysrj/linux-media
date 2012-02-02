Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:18910 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 21/31] omap3isp: Add lane configuration to platform data
Date: Fri,  3 Feb 2012 01:54:41 +0200
Message-Id: <1328226891-8968-21-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add lane configuration (order of clock and data lane) to platform data on
both CCP2 and CSI-2.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispcsiphy.h |   15 ++-------------
 include/media/omap3isp.h                 |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 13 deletions(-)

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
index 3f4928d..4d94be5 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -91,6 +91,29 @@ enum {
 };
 
 /**
+ * struct isp_csiphy_lane: CCP2/CSI2 lane position and polarity
+ * @pos: position of the lane
+ * @pol: polarity of the lane
+ */
+struct isp_csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+#define ISP_CSIPHY1_NUM_DATA_LANES	1
+#define ISP_CSIPHY2_NUM_DATA_LANES	2
+
+/**
+ * struct isp_csiphy_lanes_cfg - CCP2/CSI2 lane configuration
+ * @data: Configuration of one or two data lanes
+ * @clk: Clock lane configuration
+ */
+struct isp_csiphy_lanes_cfg {
+	struct isp_csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
+	struct isp_csiphy_lane clk;
+};
+
+/**
  * struct isp_ccp2_platform_data - CCP2 interface platform data
  * @strobe_clk_pol: Strobe/clock polarity
  *		0 - Non Inverted, 1 - Inverted
@@ -109,6 +132,7 @@ struct isp_ccp2_platform_data {
 	unsigned int ccp2_mode:1;
 	unsigned int phy_layer:1;
 	unsigned int vpclk_div:2;
+	struct isp_csiphy_lanes_cfg lanecfg;
 };
 
 /**
@@ -119,6 +143,7 @@ struct isp_ccp2_platform_data {
 struct isp_csi2_platform_data {
 	unsigned crc:1;
 	unsigned vpclk_div:2;
+	struct isp_csiphy_lanes_cfg lanecfg;
 };
 
 struct isp_subdev_i2c_board_info {
-- 
1.7.2.5

