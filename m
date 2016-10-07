Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57545 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936586AbcJGQBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 22/22] [media] tc358743: set entity function to video interface bridge
Date: Fri,  7 Oct 2016 18:01:07 +0200
Message-Id: <20161007160107.5074-23-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TC358743 is an HDMI to MIPI CSI2-2 bridge.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index dfa45d2..c7a8f55 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1891,6 +1891,7 @@ static int tc358743_probe(struct i2c_client *client,
 	}
 
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err < 0)
 		goto err_hdl;
-- 
2.9.3

