Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33641 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966113AbcKLNNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:55 -0500
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
Subject: [PATCHv2 31/32] media: rcar-vin: enable support for r8a7795
Date: Sat, 12 Nov 2016 14:12:15 +0100
Message-Id: <20161112131216.22635-32-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7795.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/Kconfig     |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 71 +++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index 111d2a1..e0e981c 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_RCAR_VIN
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Support for Renesas R-Car Video Input (VIN) driver.
-	  Supports R-Car Gen2 SoCs.
+	  Supports R-Car Gen2 and Gen3 SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rcar-vin.
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 1efbb0a..1a86c72 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1134,6 +1134,73 @@ static const struct rvin_info rcar_info_m1 = {
 	.max_height = 2048,
 };
 
+static const struct rvin_info rcar_info_r8a7795 = {
+	.chip = RCAR_GEN3,
+	.max_width = 4096,
+	.max_height = 4096,
+
+	.num_chsels = 6,
+	.chsels = {
+		{
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+			{ .csi = RVIN_CSI21, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+			{ .csi = RVIN_CSI21, .chan = 3 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+			{ .csi = RVIN_CSI21, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+			{ .csi = RVIN_CSI21, .chan = 3 },
+		},
+	},
+};
+
 static const struct rvin_info rcar_info_gen2 = {
 	.chip = RCAR_GEN2,
 	.max_width = 2048,
@@ -1142,6 +1209,10 @@ static const struct rvin_info rcar_info_gen2 = {
 
 static const struct of_device_id rvin_of_id_table[] = {
 	{
+		.compatible = "renesas,vin-r8a7795",
+		.data = &rcar_info_r8a7795,
+	},
+	{
 		.compatible = "renesas,vin-r8a7794",
 		.data = &rcar_info_gen2,
 	},
-- 
2.10.2

