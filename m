Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47710 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754911AbdKKAjK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:10 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 25/25] rcar-vin: enable support for r8a7796
Date: Sat, 11 Nov 2017 01:38:35 +0100
Message-Id: <20171111003835.4909-26-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7796.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/rcar_vin.txt         |  1 +
 drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index df1abd0fb20386f8..ddf249c2276600d2 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -10,6 +10,7 @@ Depending on the instance the VIN input is connected to external SoC pins, or
 on Gen3 to a CSI-2 receiver.
 
  - compatible: Must be one or more of the following
+   - "renesas,vin-r8a7796" for the R8A7796 device
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index b22f6596700d2479..e329de4ce0172e8d 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1084,6 +1084,66 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
 	},
 };
 
+static const struct rvin_info rcar_info_r8a7796 = {
+	.chip = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+
+	.num_chsels = 5,
+	.chsels = {
+		{
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+		}, {
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_NC, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+		}, {
+			{ .csi = RVIN_NC, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_NC, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+		},
+	},
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -1117,6 +1177,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,vin-r8a7795",
 		.data = &rcar_info_r8a7795,
 	},
+	{
+		.compatible = "renesas,vin-r8a7796",
+		.data = &rcar_info_r8a7796,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.15.0
