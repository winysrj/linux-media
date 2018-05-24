Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:35941 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966725AbeEXWCf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 18:02:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 2/9] media: rcar-vin: Remove two empty lines
Date: Fri, 25 May 2018 00:02:12 +0200
Message-Id: <1527199339-7724-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527199339-7724-1-git-send-email-jacopo+renesas@jmondi.org>
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
