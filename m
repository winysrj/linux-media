Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:39383 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164156AbeCBB7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:24 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 26/32] rcar-vin: add chsel information to rvin_info
Date: Fri,  2 Mar 2018 02:57:45 +0100
Message-Id: <20180302015751.25596-27-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-vin.h | 42 ++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 07cde9e1ab01ca51..6150a883e17f8479 100644
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
+ * @vin:	VIN ID.
+ * @csi:	CSI-2 receiver ID.
+ * @chan:	Output channel of the CSI-2 receiver.
+ * @mask:	Bitmask of the different CHSEL register values that
+ *		allows for a route from @csi + @chan to @vin.
+ *
+ * .. note::
+ *	Each R-Car CSI-2 receiver has four output channels facing the VIN
+ *	devices, each channel can carry one CSI-2 Virtual Channel (VC).
+ *	There are no correlation between channel number and CSI-2 VC. It's
+ *	up to the CSI-2 receiver driver to configure which VC is output
+ *	on which channel, the VIN devices only care about output channels.
+ *
+ *	There are in some cases multiple CHSEL register settings which would
+ *	allow for the same route from @csi + @chan to @vin. For example
+ *	on R-Car H3 both the CHSEL values 0 and 3 allows for a route from
+ *	CSI40/VC0 to VIN0. All possible CHSEL values for a route need to be
+ *	recorded as a bitmask in @mask, in this example bit 0 and 3 should
+ *	be set.
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
