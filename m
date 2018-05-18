Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:35059 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbeEROlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:41:20 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 2/9] media: rcar-vin: Remove two empty lines
Date: Fri, 18 May 2018 16:40:38 +0200
Message-Id: <1526654445-10702-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526654445-10702-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove un-necessary empty lines.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6b80f98..1aadd90 100644
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
