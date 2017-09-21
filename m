Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53759 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751787AbdIUPcN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:32:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] tc358743: set entity function to video interface bridge
Date: Thu, 21 Sep 2017 17:32:11 +0200
Message-Id: <20170921153211.16836-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TC358743 is an HDMI to MIPI CSI2-2 bridge.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index b7285e45b908a..82927ef0cd913 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1947,6 +1947,7 @@ static int tc358743_probe(struct i2c_client *client,
 	}
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err < 0)
 		goto err_hdl;
-- 
2.11.0
