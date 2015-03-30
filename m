Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbbC3LLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 10/12] [media] tc358743: detect chip by ChipID instead of IntMask
Date: Mon, 30 Mar 2015 13:10:54 +0200
Message-Id: <1427713856-10240-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When resetting the CPU instead of power cycling, IntMask is still set
from last boot. Instead of depending on it to be set to its reset
defaults, check the ChipID register and rewrite IntMask if needed.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 2cf97d9..02b131b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1847,13 +1847,19 @@ static int tc358743_probe(struct i2c_client *client,
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/* i2c access */
+	if (i2c_rd16(sd, CHIPID) != 0x0000) {
+		v4l2_info(sd, "not a TC358743 on address 0x%x\n",
+			  client->addr << 1);
+		return -ENODEV;
+	}
 	/* read the interrupt mask register, it should carry the
 	 * default values, as it hasn't been touched at this point.
 	 */
 	if (i2c_rd16(sd, INTMASK) != 0x0400) {
-		v4l2_info(sd, "not a TC358743 on address 0x%x\n",
-			  client->addr << 1);
-		return -ENODEV;
+		v4l2_warn(sd, "initial interrupt mask: 0x%04x\n",
+			  i2c_rd16(sd, INTMASK));
+		i2c_wr16(sd, INTMASK, 0x0400);
+	}
 
 	tc358743_clear_interrupt_status(sd);
 
-- 
2.1.4

