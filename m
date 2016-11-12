Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33546 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965978AbcKLNNv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:51 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 22/32] media: rcar-vin: add chsel information to rvin_info
Date: Sat, 12 Nov 2016 14:12:06 +0100
Message-Id: <20161112131216.22635-23-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Each Gen3 SoC have a limited set of predefined routing possibilities for
which CSI2 device and virtual channel can be routed to which VIN
instance.  Prepare to store this information in the struct rvin_info.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-vin.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 90c28a7..cd7d959 100644
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
@@ -111,6 +114,16 @@ struct rvin_graph_entity {
 
 struct rvin_group;
 
+
+/** struct rvin_group_chsel - Map a CSI2 device and channel for a CHSEL value
+ * @csi:		VIN internal number for CSI2 device
+ * @chan:		CSI2 VC number on remote
+ */
+struct rvin_group_chsel {
+	enum rvin_csi_id csi;
+	int chan;
+};
+
 /**
  * struct rvin_info- Information about the particular VIN implementation
  * @chip:		type of VIN chip
@@ -123,6 +136,9 @@ struct rvin_info {
 
 	unsigned int max_width;
 	unsigned int max_height;
+
+	unsigned int num_chsels;
+	struct rvin_group_chsel chsels[RCAR_VIN_NUM][RCAR_CHSEL_MAX];
 };
 
 /**
-- 
2.10.2

