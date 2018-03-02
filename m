Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:9098 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164185AbeCBB7d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:33 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 32/32] rcar-vin: enable support for r8a77970
Date: Fri,  2 Mar 2018 02:57:51 +0100
Message-Id: <20180302015751.25596-33-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a77970.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f631a66e9cb69265..29b1ad793deefabc 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -971,6 +971,25 @@ static const struct rvin_info rcar_info_r8a7796 = {
 	.routes = rcar_info_r8a7796_routes,
 };
 
+static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
+	{ .vin = 0, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(0) | BIT(3) },
+	{ .vin = 1, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(2) },
+	{ .vin = 1, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(3) },
+	{ .vin = 2, .csi = RVIN_CSI40, .chan = 0, .mask = BIT(1) },
+	{ .vin = 2, .csi = RVIN_CSI40, .chan = 2, .mask = BIT(3) },
+	{ .vin = 3, .csi = RVIN_CSI40, .chan = 1, .mask = BIT(0) },
+	{ .vin = 3, .csi = RVIN_CSI40, .chan = 3, .mask = BIT(3) },
+	{ /* Sentinel */ }
+};
+
+static const struct rvin_info rcar_info_r8a77970 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = _rcar_info_r8a77970_routes,
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -1008,6 +1027,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,vin-r8a7796",
 		.data = &rcar_info_r8a7796,
 	},
+	{
+		.compatible = "renesas,vin-r8a77970",
+		.data = &rcar_info_r8a77970,
+	},
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.16.2
