Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:56454 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750932AbeDNMDT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:03:19 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 32/33] rcar-vin: enable support for r8a7796
Date: Sat, 14 Apr 2018 13:57:25 +0200
Message-Id: <20180414115726.5075-33-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7796.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 44 +++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 81119ae4402d0990..81c82793b1312aae 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -931,6 +931,46 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
 	.routes = rcar_info_r8a7795es1_routes,
 };
 
+static const struct rvin_group_route rcar_info_r8a7796_routes[] = {
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 0, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 1, .mask = BIT(0) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 1, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 2, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 2, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 3, .mask = BIT(1) },
+	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 3, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 4, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 5, .mask = BIT(0) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 5, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 5, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 5, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 6, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 6, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 2, .vin = 6, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 6, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 7, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 7, .mask = BIT(1) },
+	{ .csi = RVIN_CSI40, .channel = 3, .vin = 7, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 7, .mask = BIT(4) },
+	{ /* Sentinel */ }
+};
+
+static const struct rvin_info rcar_info_r8a7796 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = rcar_info_r8a7796_routes,
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -964,6 +1004,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,vin-r8a7795",
 		.data = &rcar_info_r8a7795,
 	},
+	{
+		.compatible = "renesas,vin-r8a7796",
+		.data = &rcar_info_r8a7796,
+	},
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.16.2
