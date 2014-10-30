Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934301AbaJ3KNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:13:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] dib7000p: get rid of an unused argument
Date: Thu, 30 Oct 2014 08:13:43 -0200
Message-Id: <1414664023-7024-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dib7000p is for DVB, and not ISDB. So, there's no layer.

That removes this compilation warning:
	drivers/media/dvb-frontends/dib7000p.c:1972: warning: 'i' is used uninitialized in this function

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/dib7000p.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 589134e95175..c505d696f92d 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -1780,7 +1780,7 @@ static u32 interpolate_value(u32 value, struct linear_segments *segments,
 }
 
 /* FIXME: may require changes - this one was borrowed from dib8000 */
-static u32 dib7000p_get_time_us(struct dvb_frontend *demod, int layer)
+static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
 {
 	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
 	u64 time_us, tmp64;
@@ -1881,7 +1881,6 @@ static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
 {
 	struct dib7000p_state *state = demod->demodulator_priv;
 	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
-	int i;
 	int show_per_stats = 0;
 	u32 time_us = 0, val, snr;
 	u64 blocks, ucb;
@@ -1935,7 +1934,7 @@ static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
 
 		/* Estimate the number of packets based on bitrate */
 		if (!time_us)
-			time_us = dib7000p_get_time_us(demod, -1);
+			time_us = dib7000p_get_time_us(demod);
 
 		if (time_us) {
 			blocks = 1250000ULL * 1000000ULL;
@@ -1949,7 +1948,7 @@ static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
 
 	/* Get post-BER measures */
 	if (time_after(jiffies, state->ber_jiffies_stats)) {
-		time_us = dib7000p_get_time_us(demod, -1);
+		time_us = dib7000p_get_time_us(demod);
 		state->ber_jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
 
 		dprintk("Next all layers stats available in %u us.", time_us);
@@ -1969,7 +1968,7 @@ static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 		c->block_error.stat[0].uvalue += val;
 
-		time_us = dib7000p_get_time_us(demod, i);
+		time_us = dib7000p_get_time_us(demod);
 		if (time_us) {
 			blocks = 1250000ULL * 1000000ULL;
 			do_div(blocks, time_us * 8 * 204);
-- 
1.9.3

