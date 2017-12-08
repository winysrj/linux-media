Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45174 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdLHBJI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:08 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 28/28] rcar-vin: enable support for r8a77970
Date: Fri,  8 Dec 2017 02:08:42 +0100
Message-Id: <20171208010842.20047-29-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a77970.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/rcar_vin.txt         |  1 +
 drivers/media/platform/rcar-vin/rcar-core.c        | 40 ++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 314743532bbb4523..6b98f8a3398fa493 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -21,6 +21,7 @@ on Gen3 to a CSI-2 receiver.
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7796" for the R8A7796 device
+   - "renesas,vin-r8a77970" for the R8A77970 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
      device.
    - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ed7fbb58ad6846c1..136179ffeebf6862 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1145,6 +1145,42 @@ static const struct rvin_info rcar_info_r8a7796 = {
 	},
 };
 
+static const struct rvin_info rcar_info_r8a77970 = {
+	.chip = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+
+	.num_chsels = 5,
+	.chsels = {
+		{
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+		}, {
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_NC, .chan = 0 },
+		}, {
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_NC, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_NC, .chan = 0 },
+		},
+	},
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -1182,6 +1218,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,vin-r8a7796",
 		.data = &rcar_info_r8a7796,
 	},
+	{
+		.compatible = "renesas,vin-r8a77970",
+		.data = &rcar_info_r8a77970,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.15.0
