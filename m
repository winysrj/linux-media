Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38347 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbETO67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:58:59 -0400
Received: by wichy4 with SMTP id hy4so63330216wic.1
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 07:58:58 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH] cx24120: Assume ucb registers is a counter
Date: Wed, 20 May 2015 15:57:49 +0100
Message-Id: <1432133869-28215-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ucblocks register is probably a counter and not a rate; assume
it is so and change the calculations as required.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/dvb-frontends/cx24120.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index a14d0f1..10a948e 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -154,7 +154,7 @@ struct cx24120_state {
 	u32 bitrate;
 	u32 berw_usecs;
 	u32 ber_prev;
-	u32 per_prev;
+	u32 ucb_offset;
 	unsigned long ber_jiffies_stats;
 	unsigned long per_jiffies_stats;
 };
@@ -698,8 +698,12 @@ static void cx24120_get_stats(struct cx24120_state *state)
 		ucb |= cx24120_readreg(state, CX24120_REG_UCB_L);
 		dev_dbg(&state->i2c->dev, "ucblocks = %d\n", ucb);
 
+		/* handle reset */
+		if (ucb < state->ucb_offset)
+			state->ucb_offset = c->block_error.stat[0].uvalue;
+
 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[0].uvalue += ucb;
+		c->block_error.stat[0].uvalue = ucb + state->ucb_offset;
 
 		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->block_count.stat[0].uvalue += state->bitrate / 8 / 208;
@@ -1541,8 +1545,7 @@ static int cx24120_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 		return 0;
 	}
 
-	*ucblocks = c->block_error.stat[0].uvalue - state->per_prev;
-	state->per_prev = c->block_error.stat[0].uvalue;
+	*ucblocks = c->block_error.stat[0].uvalue - state->ucb_offset;
 
 	return 0;
 }
-- 
2.1.0

