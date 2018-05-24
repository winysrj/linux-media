Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:54833 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161587AbeEXWCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 18:02:42 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 8/9] media: rcar-vin: Rename _rcar_info to rcar_info
Date: Fri, 25 May 2018 00:02:18 +0200
Message-Id: <1527199339-7724-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove leading underscore to align all rcar_group_route structure
declarations.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8edf896..30f6ea7 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -1019,7 +1019,7 @@ static const struct rvin_info rcar_info_r8a7796 = {
 	.routes = rcar_info_r8a7796_routes,
 };
 
-static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
+static const struct rvin_group_route rcar_info_r8a77970_routes[] = {
 	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
 	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
 	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
@@ -1035,7 +1035,7 @@ static const struct rvin_info rcar_info_r8a77970 = {
 	.use_mc = true,
 	.max_width = 4096,
 	.max_height = 4096,
-	.routes = _rcar_info_r8a77970_routes,
+	.routes = rcar_info_r8a77970_routes,
 };
 
 static const struct of_device_id rvin_of_id_table[] = {
-- 
2.7.4
