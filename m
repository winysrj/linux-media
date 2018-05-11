Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:49769 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbeEKJ7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 05:59:50 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/5] media: rcar-vin: Add support for R-Car R8A77995 SoC
Date: Fri, 11 May 2018 11:59:37 +0200
Message-Id: <1526032781-14319-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add R-Car R8A77995 SoC to the rcar-vin supported ones.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d3072e1..e547ef7 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -985,6 +985,10 @@ static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
 	{ /* Sentinel */ }
 };
 
+static const struct rvin_group_route _rcar_info_r8a77995_routes[] = {
+	{ /* Sentinel */ }
+};
+
 static const struct rvin_info rcar_info_r8a77970 = {
 	.model = RCAR_GEN3,
 	.use_mc = true,
@@ -993,6 +997,14 @@ static const struct rvin_info rcar_info_r8a77970 = {
 	.routes = _rcar_info_r8a77970_routes,
 };
 
+static const struct rvin_info rcar_info_r8a77995 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = _rcar_info_r8a77995_routes,
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -1034,6 +1046,10 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,vin-r8a77970",
 		.data = &rcar_info_r8a77970,
 	},
+	{
+		.compatible = "renesas,vin-r8a77995",
+		.data = &rcar_info_r8a77995,
+	},
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-- 
2.7.4
