Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:56711 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbeKEUiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:38:51 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/6] media: rcar-vin: Add support for R-Car R8A77990
Date: Mon,  5 Nov 2018 12:19:07 +0100
Message-Id: <1541416751-19810-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1541416751-19810-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1541416751-19810-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add R-Car E3 R8A77990 SoC to the rcar-vin supported ones.
Based on the experimental patch from Magnus Damm.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f476b2f..cae2166 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1088,6 +1088,22 @@ static const struct rvin_info rcar_info_r8a77970 = {
 	.routes = rcar_info_r8a77970_routes,
 };
 
+static const struct rvin_group_route rcar_info_r8a77990_routes[] = {
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 5, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 4, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 5, .mask = BIT(1) | BIT(3) },
+	{ /* Sentinel */ }
+};
+
+static const struct rvin_info rcar_info_r8a77990 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = rcar_info_r8a77990_routes,
+};
+
 static const struct rvin_group_route rcar_info_r8a77995_routes[] = {
 	{ /* Sentinel */ }
 };
@@ -1146,6 +1162,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.data = &rcar_info_r8a77970,
 	},
 	{
+		.compatible = "renesas,vin-r8a77990",
+		.data = &rcar_info_r8a77990,
+	},
+	{
 		.compatible = "renesas,vin-r8a77995",
 		.data = &rcar_info_r8a77995,
 	},
-- 
2.7.4
