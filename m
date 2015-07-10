Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36835 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbbGJNLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:11:48 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/5] [media] tc358743: enable v4l2 subdevice devnode
Date: Fri, 10 Jul 2015 15:11:34 +0200
Message-Id: <1436533897-3060-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 48d1575..0be6d9f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1668,7 +1668,7 @@ static int tc358743_probe(struct i2c_client *client,
 	state->i2c_client = client;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
-	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/* i2c access */
 	if ((i2c_rd16(sd, CHIPID) & MASK_CHIPID) != 0) {
-- 
2.1.4

