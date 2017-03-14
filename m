Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37583 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdCNTGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:52 -0400
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
Subject: [PATCH v3 27/27] rcar-vin: enable support for r8a7796
Date: Tue, 14 Mar 2017 20:03:08 +0100
Message-Id: <20170314190308.25790-28-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7796.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 .../devicetree/bindings/media/rcar_vin.txt         |  1 +
 drivers/media/platform/rcar-vin/rcar-core.c        | 64 ++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index ffdfa97ac37753f9..7e36ebe5c89b7dfd 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -10,6 +10,7 @@ always slaves and support multiple input channels which can be either RGB,
 YUVU, BT656 or CSI-2.
 
  - compatible: Must be one or more of the following
+   - "renesas,vin-r8a7796" for the R8A7796 device
    - "renesas,vin-r8a7795" for the R8A7795 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7793" for the R8A7793 device
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c30040c42ce588a9..8930189638473f37 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1119,6 +1119,66 @@ static const struct rvin_info rcar_info_r8a7795 = {
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
 static const struct rvin_info rcar_info_gen2 = {
 	.chip = RCAR_GEN2,
 	.use_mc = false,
@@ -1132,6 +1192,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.data = &rcar_info_r8a7795,
 	},
 	{
+		.compatible = "renesas,vin-r8a7796",
+		.data = &rcar_info_r8a7796,
+	},
+	{
 		.compatible = "renesas,vin-r8a7794",
 		.data = &rcar_info_gen2,
 	},
-- 
2.12.0
