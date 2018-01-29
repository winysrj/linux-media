Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:57602 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751738AbeA2Qft (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:49 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 24/30] rcar-vin: add chsel information to rvin_info
Date: Mon, 29 Jan 2018 17:34:29 +0100
Message-Id: <20180129163435.24936-25-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-vin.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 903d8fb8426a7860..ca2c2a23cef8506c 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -43,6 +43,14 @@ enum model_id {
 	RCAR_GEN3,
 };
 
+enum rvin_csi_id {
+	RVIN_CSI20,
+	RVIN_CSI21,
+	RVIN_CSI40,
+	RVIN_CSI41,
+	RVIN_CSI_MAX,
+};
+
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
@@ -81,12 +89,33 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+/** struct rvin_group_route - Map a CSI-2 receiver and channel to a CHSEL
+ * @vin:		Which VIN the CSI-2 and VC describes
+ * @csi:		VIN internal number for CSI-2 device
+ * @chan:		Output channel of the CSI-2 receiver. Each R-Car CSI-2
+ *			receiver has four output channels facing the VIN
+ *			devices, each channel can carry one CSI-2 Virtual
+ *			Channel (VC) and there are no correlation between
+ *			output channel number and CSI-2 VC. It's up to the
+ *			CSI-2 receiver driver to configure which VC is
+ *			outputted on which channel, the VIN devices only
+ *			cares about output channels.
+ * @mask:		Bitmask of chsel values which accommodates route
+ */
+struct rvin_group_route {
+	unsigned int vin;
+	enum rvin_csi_id csi;
+	unsigned char chan;
+	unsigned int mask;
+};
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @model:		VIN model
  * @use_mc:		use media controller instead of controlling subdevice
  * @max_width:		max input width the VIN supports
  * @max_height:		max input height the VIN supports
+ * @routes:		routing table VIN <-> CSI-2 for the chsel values
  */
 struct rvin_info {
 	enum model_id model;
@@ -94,6 +123,7 @@ struct rvin_info {
 
 	unsigned int max_width;
 	unsigned int max_height;
+	const struct rvin_group_route *routes;
 };
 
 /**
-- 
2.16.1
