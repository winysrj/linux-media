Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:32250 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754767AbeCGWF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:59 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v12 27/33] rcar-vin: add chsel information to rvin_info
Date: Wed,  7 Mar 2018 23:05:05 +0100
Message-Id: <20180307220511.9826-28-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each Gen3 SoC has a limited set of predefined routing possibilities for
which CSI-2 device and channel can be routed to which VIN instance.
Prepare to store this information in the struct rvin_info.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

* Changes since v11
- Fixed spelling.
- Reorderd filed order in struct rvin_group_route.
- Renamed chan to channel in struct rvin_group_route.
---
 drivers/media/platform/rcar-vin/rcar-vin.h | 42 ++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index d64cbb5716ab6f6a..9a68a5909fe07ec7 100644
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
@@ -81,12 +89,45 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+/**
+ * struct rvin_group_route - describes a route from a channel of a
+ *	CSI-2 receiver to a VIN
+ *
+ * @csi:	CSI-2 receiver ID.
+ * @channel:	Output channel of the CSI-2 receiver.
+ * @vin:	VIN ID.
+ * @mask:	Bitmask of the different CHSEL register values that
+ *		allow for a route from @csi + @chan to @vin.
+ *
+ * .. note::
+ *	Each R-Car CSI-2 receiver has four output channels facing the VIN
+ *	devices, each channel can carry one CSI-2 Virtual Channel (VC).
+ *	There is no correlation between channel number and CSI-2 VC. It's
+ *	up to the CSI-2 receiver driver to configure which VC is output
+ *	on which channel, the VIN devices only care about output channels.
+ *
+ *	There are in some cases multiple CHSEL register settings which would
+ *	allow for the same route from @csi + @channel to @vin. For example
+ *	on R-Car H3 both the CHSEL values 0 and 3 allow for a route from
+ *	CSI40/VC0 to VIN0. All possible CHSEL values for a route need to be
+ *	recorded as a bitmask in @mask, in this example bit 0 and 3 should
+ *	be set.
+ */
+struct rvin_group_route {
+	enum rvin_csi_id csi;
+	unsigned int channel;
+	unsigned int vin;
+	unsigned int mask;
+};
+
 /**
  * struct rvin_info - Information about the particular VIN implementation
  * @model:		VIN model
  * @use_mc:		use media controller instead of controlling subdevice
  * @max_width:		max input width the VIN supports
  * @max_height:		max input height the VIN supports
+ * @routes:		list of possible routes from the CSI-2 recivers to
+ *			all VINs. The list mush be NULL terminated.
  */
 struct rvin_info {
 	enum model_id model;
@@ -94,6 +135,7 @@ struct rvin_info {
 
 	unsigned int max_width;
 	unsigned int max_height;
+	const struct rvin_group_route *routes;
 };
 
 /**
-- 
2.16.2
