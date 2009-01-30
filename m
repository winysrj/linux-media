Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45241 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbZA3Xpz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 18:45:55 -0500
From: Dominic Curran <dcurran@ti.com>
To: linux-media@vger.kernel.org,
	"linux-omap" <linux-omap@vger.kernel.org>
Subject: [OMAPZOOM][PATCH v2 1/6] CSI2: Add function to change number of data lanes used.
Date: Fri, 30 Jan 2009 17:45:49 -0600
Cc: greg.hofer@hp.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301745.49310.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 1/6] CSI2: Add function to change number of data 
lanes used.

Add new CSI2 function.
New function is isp_csi2_complexio_lanes_count().
Sets the number of CSI2 data lanes that should be used.

Signed-off-by: Dominic Curran <dcurran@ti.com>
Signed-off-by: Greg Hofer <greg.hofer@hp.com>
---
 drivers/media/video/isp/ispcsi2.c |   33 +++++++++++++++++++++++++++++++--
 drivers/media/video/isp/ispcsi2.h |    5 +++++
 2 files changed, 36 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 drivers/media/video/isp/ispcsi2.c
 mode change 100644 => 100755 drivers/media/video/isp/ispcsi2.h

Index: omapzoom04/drivers/media/video/isp/ispcsi2.c
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/ispcsi2.c
+++ omapzoom04/drivers/media/video/isp/ispcsi2.c
@@ -112,6 +112,11 @@ int isp_csi2_complexio_lanes_config(stru
 			currlanes_u->data[i] = true;
 			update_complexio_cfg1 = true;
 		}
+		/* If the lane position is non zero then we can assume that
+		 * the initial lane state is on.
+		 */
+		if (currlanes->data[i].pos)
+			currlanes->data[i].state = ISP_CSI2_LANE_ON;
 	}
 
 	if (currlanes->clk.pos != reqcfg->clk.pos) {
@@ -158,9 +163,10 @@ int isp_csi2_complexio_lanes_update(bool
 									1));
 			reg |= (currlanes->data[i].pol <<
 				ISPCSI2_COMPLEXIO_CFG1_DATA_POL_SHIFT(i + 1));
-			reg |= (currlanes->data[i].pos <<
+			if (currlanes->data[i].state == ISP_CSI2_LANE_ON)
+				reg |= (currlanes->data[i].pos <<
 				ISPCSI2_COMPLEXIO_CFG1_DATA_POSITION_SHIFT(i +
-									1));
+					 1));
 			currlanes_u->data[i] = false;
 		}
 	}
@@ -181,6 +187,29 @@ int isp_csi2_complexio_lanes_update(bool
 }
 
 /**
+ * isp_csi2_complexio_lanes_count - Turn data lanes on/off dynamically.
+ * @ cnt: Number of data lanes to enable.
+ *
+ * Always returns 0.
+ **/
+int isp_csi2_complexio_lanes_count(int cnt)
+{
+	struct isp_csi2_lanes_cfg *currlanes = &current_csi2_cfg.lanes;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		if (i < cnt)
+			currlanes->data[i].state = ISP_CSI2_LANE_ON;
+		else
+			currlanes->data[i].state = ISP_CSI2_LANE_OFF;
+	}
+
+	isp_csi2_complexio_lanes_update(true);
+	return 0;
+}
+EXPORT_SYMBOL(isp_csi2_complexio_lanes_count);
+
+/**
  * isp_csi2_complexio_lanes_get - Gets CSI2 ComplexIO lanes configuration.
  *
  * Gets settings from HW registers and fills in the internal driver memory
Index: omapzoom04/drivers/media/video/isp/ispcsi2.h
===================================================================
--- omapzoom04.orig/drivers/media/video/isp/ispcsi2.h
+++ omapzoom04/drivers/media/video/isp/ispcsi2.h
@@ -20,6 +20,9 @@
 #define OMAP_ISP_CSI2_API_H
 #include <linux/videodev2.h>
 
+#define ISP_CSI2_LANE_OFF 	0
+#define ISP_CSI2_LANE_ON 	1
+
 enum isp_csi2_irqevents {
 	OCP_ERR_IRQ = 0x4000,
 	SHORT_PACKET_IRQ = 0x2000,
@@ -63,6 +66,7 @@ enum isp_csi2_frame_mode {
 struct csi2_lanecfg {
 	u8 pos;
 	u8 pol;
+	u8 state; 	/*Current state - 1-Used  0-Unused */
 };
 
 struct isp_csi2_lanes_cfg {
@@ -175,6 +179,7 @@ struct isp_csi2_cfg_update {
 
 int isp_csi2_complexio_lanes_config(struct isp_csi2_lanes_cfg *reqcfg);
 int isp_csi2_complexio_lanes_update(bool force_update);
+int isp_csi2_complexio_lanes_count(int cnt);
 int isp_csi2_complexio_lanes_get(void);
 int isp_csi2_complexio_power_autoswitch(bool enable);
 int isp_csi2_complexio_power(enum isp_csi2_power_cmds power_cmd);
