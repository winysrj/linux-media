Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:49405 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbeJEDAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:00:16 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 3/3] rcar-vin: declare which VINs can use a Up Down Scaler (UDS)
Date: Thu,  4 Oct 2018 22:04:02 +0200
Message-Id: <20181004200402.15113-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add information about which VINs on which SoC have access to a UDS
scaler.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 01e418c2d4c6792e..337ae8bbe1e0b14c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -919,12 +919,21 @@ static const struct rvin_group_route rcar_info_r8a7795_routes[] = {
 	{ /* Sentinel */ }
 };
 
+static const struct rvin_group_scaler rcar_info_h3_m3w_m3n_scalers[] = {
+	{ .vin = 0, .companion = 1 },
+	{ .vin = 1, .companion = 0 },
+	{ .vin = 4, .companion = 5 },
+	{ .vin = 5, .companion = 4 },
+	{ /* Sentinel */ }
+};
+
 static const struct rvin_info rcar_info_r8a7795 = {
 	.model = RCAR_GEN3,
 	.use_mc = true,
 	.max_width = 4096,
 	.max_height = 4096,
 	.routes = rcar_info_r8a7795_routes,
+	.scalers = rcar_info_h3_m3w_m3n_scalers,
 };
 
 static const struct rvin_group_route rcar_info_r8a7795es1_routes[] = {
@@ -979,6 +988,7 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
 	.max_width = 4096,
 	.max_height = 4096,
 	.routes = rcar_info_r8a7795es1_routes,
+	.scalers = rcar_info_h3_m3w_m3n_scalers,
 };
 
 static const struct rvin_group_route rcar_info_r8a7796_routes[] = {
@@ -1019,6 +1029,7 @@ static const struct rvin_info rcar_info_r8a7796 = {
 	.max_width = 4096,
 	.max_height = 4096,
 	.routes = rcar_info_r8a7796_routes,
+	.scalers = rcar_info_h3_m3w_m3n_scalers,
 };
 
 static const struct rvin_group_route rcar_info_r8a77965_routes[] = {
@@ -1063,6 +1074,7 @@ static const struct rvin_info rcar_info_r8a77965 = {
 	.max_width = 4096,
 	.max_height = 4096,
 	.routes = rcar_info_r8a77965_routes,
+	.scalers = rcar_info_h3_m3w_m3n_scalers,
 };
 
 static const struct rvin_group_route rcar_info_r8a77970_routes[] = {
@@ -1088,12 +1100,18 @@ static const struct rvin_group_route rcar_info_r8a77995_routes[] = {
 	{ /* Sentinel */ }
 };
 
+static const struct rvin_group_scaler rcar_info_r8a77995_scalers[] = {
+	{ .vin = 4, .companion = -1 },
+	{ /* Sentinel */ }
+};
+
 static const struct rvin_info rcar_info_r8a77995 = {
 	.model = RCAR_GEN3,
 	.use_mc = true,
 	.max_width = 4096,
 	.max_height = 4096,
 	.routes = rcar_info_r8a77995_routes,
+	.scalers = rcar_info_r8a77995_scalers,
 };
 
 static const struct of_device_id rvin_of_id_table[] = {
-- 
2.19.0
