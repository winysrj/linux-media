Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51607 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbeEPMRK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 08:17:10 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 4/4] media: rcar-vin: Add support for R-Car R8A77995 SoC
Date: Wed, 16 May 2018 14:16:56 +0200
Message-Id: <1526473016-30559-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add R-Car R8A77995 SoC to the rcar-vin supported ones.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ea74c55..fba8610 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1104,6 +1104,10 @@ static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
 	{ /* Sentinel */ }
 };
 
+static const struct rvin_group_route _rcar_info_r8a77995_routes[] = {
+	{ /* Sentinel */ }
+};
+
 static const struct rvin_info rcar_info_r8a77970 = {
 	.model = RCAR_GEN3,
 	.use_mc = true,
@@ -1112,6 +1116,14 @@ static const struct rvin_info rcar_info_r8a77970 = {
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
@@ -1153,6 +1165,10 @@ static const struct of_device_id rvin_of_id_table[] = {
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
