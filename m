Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44910 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752407AbdLHBJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:04 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 22/28] rcar-vin: add chsel information to rvin_info
Date: Fri,  8 Dec 2017 02:08:36 +0100
Message-Id: <20171208010842.20047-23-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each Gen3 SoC has a limited set of predefined routing possibilities for
which CSI-2 device and virtual channel can be routed to which VIN
instance. Prepare to store this information in the struct rvin_info.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-vin.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 5f736a3500b6e10f..41bf24aa8a1a0aed 100644
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
@@ -91,6 +94,22 @@ struct rvin_graph_entity {
 
 struct rvin_group;
 
+/** struct rvin_group_chsel - Map a CSI-2 receiver and channel to a CHSEL value
+ * @csi:		VIN internal number for CSI-2 device
+ * @chan:		Output channel of the CSI-2 receiver. Each R-Car CSI-2
+ *			receiver has four output channels facing the VIN
+ *			devices, each channel can carry one CSI-2 Virtual
+ *			Channel (VC) and there are no correlation between
+ *			output channel number and CSI-2 VC. It's up to the
+ *			CSI-2 receiver driver to configure which VC is
+ *			outputted on which channel, the VIN devices only
+ *			cares about output channels.
+ */
+struct rvin_group_chsel {
+	enum rvin_csi_id csi;
+	unsigned int chan;
+};
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @chip:		type of VIN chip
@@ -98,6 +117,9 @@ struct rvin_group;
  *
  * max_width:		max input width the VIN supports
  * max_height:		max input height the VIN supports
+ *
+ * num_chsels:		number of possible chsel values for this VIN
+ * chsels:		routing table VIN <-> CSI-2 for the chsel values
  */
 struct rvin_info {
 	enum chip_id chip;
@@ -105,6 +127,9 @@ struct rvin_info {
 
 	unsigned int max_width;
 	unsigned int max_height;
+
+	unsigned int num_chsels;
+	struct rvin_group_chsel chsels[RCAR_VIN_NUM][RCAR_CHSEL_MAX];
 };
 
 /**
-- 
2.15.0
