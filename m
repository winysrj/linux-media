Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbC3LLQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 07:11:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC 05/12] [media] tc358743: fix lane number calculation to include blanking
Date: Mon, 30 Mar 2015 13:10:49 +0200
Message-Id: <1427713856-10240-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of only using the visible width and height, also add the
horizontal and vertical blanking to calculate the bit rate.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index dd2ea16..74e83c5 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -713,9 +713,11 @@ static unsigned tc358743_num_csi_lanes_needed(struct v4l2_subdev *sd)
 {
 	struct tc358743_state *state = to_state(sd);
 	struct v4l2_bt_timings *bt = &state->timings.bt;
+	u32 htotal = bt->width + bt->hfrontporch + bt->hsync + bt->hbackporch;
+	u32 vtotal = bt->height + bt->vfrontporch + bt->vsync + bt->vbackporch;
 	u32 bits_pr_pixel =
 		(state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16) ?  16 : 24;
-	u32 bps = bt->width * bt->height * fps(bt) * bits_pr_pixel;
+	u32 bps = htotal * vtotal * fps(bt) * bits_pr_pixel;
 
 	return DIV_ROUND_UP(bps, state->pdata.bps_pr_lane);
 }
-- 
2.1.4

