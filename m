Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56038 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbdHVX2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:48 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 20/25] rcar-vin: add chsel information to rvin_info
Date: Wed, 23 Aug 2017 01:26:35 +0200
Message-Id: <20170822232640.26147-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each Gen3 SoC has a limited set of predefined routing possibilities for
which CSI-2 device and virtual channel can be routed to which VIN
instance. Prepare to store this information in the struct rvin_info.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-vin.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 88683aaee3b6acd5..617f254b52fe106d 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -35,6 +35,9 @@
 /* Max number on VIN instances that can be in a system */
 #define RCAR_VIN_NUM 8
 
+/* Max number of CHSEL values for any Gen3 SoC */
+#define RCAR_CHSEL_MAX 6
+
 enum chip_id {
 	RCAR_H1,
 	RCAR_M1,
@@ -91,6 +94,19 @@ struct rvin_graph_entity {
 
 struct rvin_group;
 
+
+/** struct rvin_group_chsel - Map a CSI2 device and channel for a CHSEL value
+ * @csi:		VIN internal number for CSI2 device
+ * @chan:		CSI-2 channel number on remote. Note that channel
+ *			is not the same as VC. The CSI-2 hardware have 4
+ *			channels it can output on but which VC is outputted
+ *			on which channel is configurable inside the CSI-2.
+ */
+struct rvin_group_chsel {
+	enum rvin_csi_id csi;
+	unsigned int chan;
+};
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @chip:		type of VIN chip
@@ -98,6 +114,9 @@ struct rvin_group;
  *
  * max_width:		max input width the VIN supports
  * max_height:		max input height the VIN supports
+ *
+ * num_chsels:		number of possible chsel values for this VIN
+ * chsels:		routing table VIN <-> CSI-2 for the chsel values
  */
 struct rvin_info {
 	enum chip_id chip;
@@ -105,6 +124,9 @@ struct rvin_info {
 
 	unsigned int max_width;
 	unsigned int max_height;
+
+	unsigned int num_chsels;
+	struct rvin_group_chsel chsels[RCAR_VIN_NUM][RCAR_CHSEL_MAX];
 };
 
 /**
-- 
2.14.0
