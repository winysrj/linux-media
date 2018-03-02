Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:34477 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164179AbeCBB7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:31 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 31/32] rcar-vin: enable support for r8a7796
Date: Fri,  2 Mar 2018 02:57:50 +0100
Message-Id: <20180302015751.25596-32-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7796.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 44 +++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8017d386fc9bc545..f631a66e9cb69265 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -931,6 +931,46 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
 	.routes = rcar_info_r8a7795es1_routes,
 };
 
+static const struct rvin_group_route rcar_info_r8a7796_routes[] = {
+	{ .vin = 0, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(0) | BIT(3) },
+	{ .vin = 0, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(1) | BIT(4) },
+	{ .vin = 1, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(0) },
+	{ .vin = 1, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(2) },
+	{ .vin = 1, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(3) },
+	{ .vin = 1, .csi = RVIN_CSI20, .chan = 1, .mask = BIT(4) },
+	{ .vin = 2, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(1) },
+	{ .vin = 2, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(2) },
+	{ .vin = 2, .csi = RVIN_CSI40, .chan = 2, .mask = BIT(3) },
+	{ .vin = 2, .csi = RVIN_CSI20, .chan = 2, .mask = BIT(4) },
+	{ .vin = 3, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(0) },
+	{ .vin = 3, .csi = RVIN_CSI20, .chan = 1, .mask = BIT(1) },
+	{ .vin = 3, .csi = RVIN_CSI40, .chan = 3, .mask = BIT(3) },
+	{ .vin = 3, .csi = RVIN_CSI20, .chan = 3, .mask = BIT(4) },
+	{ .vin = 4, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(0) | BIT(3) },
+	{ .vin = 4, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(1) | BIT(4) },
+	{ .vin = 5, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(0) },
+	{ .vin = 5, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(2) },
+	{ .vin = 5, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(3) },
+	{ .vin = 5, .csi = RVIN_CSI20, .chan = 1, .mask = BIT(4) },
+	{ .vin = 6, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(1) },
+	{ .vin = 6, .csi = RVIN_CSI20, .chan = 0, .mask = BIT(2) },
+	{ .vin = 6, .csi = RVIN_CSI40, .chan = 2, .mask = BIT(3) },
+	{ .vin = 6, .csi = RVIN_CSI20, .chan = 2, .mask = BIT(4) },
+	{ .vin = 7, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(0) },
+	{ .vin = 7, .csi = RVIN_CSI20, .chan = 1, .mask = BIT(1) },
+	{ .vin = 7, .csi = RVIN_CSI40, .chan = 3, .mask = BIT(3) },
+	{ .vin = 7, .csi = RVIN_CSI20, .chan = 3, .mask = BIT(4) },
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
