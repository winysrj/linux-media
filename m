Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54361 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755307AbeE2IsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:48:21 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 02/10] media: rcar-vin: Remove two empty lines
Date: Tue, 29 May 2018 10:48:00 +0200
Message-Id: <1527583688-314-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove un-necessary empty lines.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 16d3e01..bcf02de 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -707,11 +707,9 @@ static int rvin_mc_parse_of_endpoint(struct device *dev,
 		return -EINVAL;
 
 	if (!of_device_is_available(to_of_node(asd->match.fwnode))) {
-
 		vin_dbg(vin, "OF device %pOF disabled, ignoring\n",
 			to_of_node(asd->match.fwnode));
 		return -ENOTCONN;
-
 	}
 
 	if (vin->group->csi[vep->base.id].fwnode) {
-- 
2.7.4
