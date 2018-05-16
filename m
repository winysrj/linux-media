Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:45455 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbeEPQct (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:49 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/6] media: rcar-vin: Handle data-active property
Date: Wed, 16 May 2018 18:32:29 +0200
Message-Id: <1526488352-898-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data-active property has to be specified when running with embedded
synchronization. The VIN peripheral can use HSYNC in place of CLOCKENB
when the CLOCKENB pin is not connected, this requires explicit
synchronization to be in use.

Now that the driver supports 'data-active' property, it makes not sense
to zero the mbus configuration flags when running with implicit synch
(V4L2_MBUS_BT656).

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index d3072e1..075d08f 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -531,15 +531,21 @@ static int rvin_digital_parse_v4l2(struct device *dev,
 		return -ENOTCONN;
 
 	vin->mbus_cfg.type = vep->bus_type;
+	vin->mbus_cfg.flags = vep->bus.parallel.flags;
 
 	switch (vin->mbus_cfg.type) {
 	case V4L2_MBUS_PARALLEL:
 		vin_dbg(vin, "Found PARALLEL media bus\n");
-		vin->mbus_cfg.flags = vep->bus.parallel.flags;
 		break;
 	case V4L2_MBUS_BT656:
 		vin_dbg(vin, "Found BT656 media bus\n");
-		vin->mbus_cfg.flags = 0;
+
+		if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
+		    !(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
+			vin_err(vin,
+				"Missing data enable signal polarity property\n");
+			return -EINVAL;
+		}
 		break;
 	default:
 		vin_err(vin, "Unknown media bus type\n");
-- 
2.7.4
