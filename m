Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbaGBPxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:53:50 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 9/9] dib8000: use jifies instead of current_kernel_time()
Date: Wed,  2 Jul 2014 12:52:23 -0300
Message-Id: <1404316343-23856-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of doing the tuning delays and timeouts using
current_kernel_time(), use jiffies. That consumes less
CPU cycles, and it is monotonic.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 57 ++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index d160a1ed92bb..07aa6707f733 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -115,7 +115,7 @@ struct dib8000_state {
 	u16 found_guard;
 	u8 subchannel;
 	u8 symbol_duration;
-	u32 timeout;
+	unsigned long timeout;
 	u8 longest_intlv_layer;
 	u16 output_mode;
 
@@ -1237,7 +1237,7 @@ static int dib8000_agc_soft_split(struct dib8000_state *state)
 	u16 agc, split_offset;
 
 	if (!state->current_agc || !state->current_agc->perform_agc_softsplit || state->current_agc->split.max == 0)
-		return FE_CALLBACK_TIME_NEVER;
+		return 0;
 
 	// n_agc_global
 	agc = dib8000_read_word(state, 390);
@@ -2847,12 +2847,12 @@ static void dib8000_set_sync_wait(struct dib8000_state *state)
 	dib8000_write_word(state, 273, (dib8000_read_word(state, 273) & 0x000f) | (sync_wait << 4));
 }
 
-static u32 dib8000_get_timeout(struct dib8000_state *state, u32 delay, enum timeout_mode mode)
+static unsigned long dib8000_get_timeout(struct dib8000_state *state, u32 delay, enum timeout_mode mode)
 {
 	if (mode == SYMBOL_DEPENDENT_ON)
-		return systime() + (delay * state->symbol_duration);
-	else
-		return systime() + delay;
+		delay *= state->symbol_duration;
+
+	return jiffies + usecs_to_jiffies(delay * 100);
 }
 
 static s32 dib8000_get_status(struct dvb_frontend *fe)
@@ -3004,8 +3004,8 @@ static int dib8000_tune(struct dvb_frontend *fe)
 	u16 locks, deeper_interleaver = 0, i;
 	int ret = 1; /* 1 symbol duration (in 100us unit) delay most of the time */
 
-	u32 *timeout = &state->timeout;
-	u32 now = systime();
+	unsigned long *timeout = &state->timeout;
+	unsigned long now = jiffies;
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1, agc2;
 #endif
@@ -3015,7 +3015,8 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 #if 0
 	if (*tune_state < CT_DEMOD_STOP)
-		dprintk("IN: context status = %d, TUNE_STATE %d autosearch step = %u systime = %u", state->channel_parameters_set, *tune_state, state->autosearch_state, now);
+		dprintk("IN: context status = %d, TUNE_STATE %d autosearch step = %u jiffies = %lu",
+			state->channel_parameters_set, *tune_state, state->autosearch_state, now);
 #endif
 
 	switch (*tune_state) {
@@ -3184,7 +3185,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			} else {
 				*tune_state = CT_DEMOD_STEP_8;
 			}
-		} else if (now > *timeout) {
+		} else if (time_after(now, *timeout)) {
 			*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
 		}
 		break;
@@ -3213,7 +3214,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		if (locks & (1<<10)) { /* lmod4_lock */
 			ret = 14; /* wait for 14 symbols */
 			*tune_state = CT_DEMOD_STEP_8;
-		} else if (now > *timeout)
+		} else if (time_after(now, *timeout))
 			*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
 		break;
 
@@ -3256,8 +3257,9 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			if (state->diversity_onoff != 0) /* because of diversity sync */
 				locks *= 2;
 
-			*timeout = now + (2000 * locks); /* give the mpeg lock 800ms if sram is present */
-			dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %d", deeper_interleaver, state->longest_intlv_layer, locks, *timeout);
+			*timeout = now + msecs_to_jiffies(200 * locks); /* give the mpeg lock 800ms if sram is present */
+			dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %ld",
+				deeper_interleaver, state->longest_intlv_layer, locks, *timeout);
 
 			*tune_state = CT_DEMOD_STEP_10;
 		} else
@@ -3276,7 +3278,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			else
 				state->status = FE_STATUS_DATA_LOCKED;
 			*tune_state = CT_DEMOD_STOP;
-		} else if (now > *timeout) {
+		} else if (time_after(now, *timeout)) {
 			if (c->isdbt_sb_mode
 			    && c->isdbt_sb_subchannel < 14
 			    && !state->differential_constellation) { /* continue to try init prbs autosearch */
@@ -3322,7 +3324,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			state->agc2_min = 0;
 		}
 #endif
-		ret = FE_CALLBACK_TIME_NEVER;
+		ret = 0;
 		break;
 	default:
 		break;
@@ -3542,9 +3544,9 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
-	int l, i, active, time, time_slave = FE_CALLBACK_TIME_NEVER;
+	int l, i, active, time, time_slave = 0;
 	u8 exit_condition, index_frontend;
-	u32 delay, callback_time;
+	unsigned long delay, callback_time;
 
 	if (c->frequency == 0) {
 		dprintk("dib8000: must at least specify frequency ");
@@ -3596,12 +3598,12 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 		time = dib8000_agc_startup(state->fe[0]);
 		for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 			time_slave = dib8000_agc_startup(state->fe[index_frontend]);
-			if (time == FE_CALLBACK_TIME_NEVER)
+			if (time == 0)
 				time = time_slave;
-			else if ((time_slave != FE_CALLBACK_TIME_NEVER) && (time_slave > time))
+			else if ((time_slave != 0) && (time_slave > time))
 				time = time_slave;
 		}
-		if (time == FE_CALLBACK_TIME_NEVER)
+		if (time == 0)
 			break;
 
 		usleep_range(time * 100, (time + 10) * 100);
@@ -3619,11 +3621,14 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 
 	active = 1;
 	do {
-		callback_time = FE_CALLBACK_TIME_NEVER;
+		callback_time = 0;
 		for (index_frontend = 0; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 			delay = dib8000_tune(state->fe[index_frontend]);
-			if (delay != FE_CALLBACK_TIME_NEVER)
-				delay += systime();
+			if (delay != 0) {
+				delay = jiffies + usecs_to_jiffies(100 * delay);
+				if (!callback_time || delay < callback_time)
+					callback_time = delay;
+			}
 
 			/* we are in autosearch */
 			if (state->channel_parameters_set == 0) { /* searching */
@@ -3652,8 +3657,6 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 					}
 				}
 			}
-			if (delay < callback_time)
-				callback_time = delay;
 		}
 		/* tuning is done when the master frontend is done (failed or success) */
 		if (dib8000_get_status(state->fe[0]) == FE_STATUS_TUNE_FAILED ||
@@ -3669,12 +3672,12 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 				dprintk("tuning done with status %d", dib8000_get_status(state->fe[0]));
 		}
 
-		if ((active == 1) && (callback_time == FE_CALLBACK_TIME_NEVER)) {
+		if ((active == 1) && (callback_time == 0)) {
 			dprintk("strange callback time something went wrong");
 			active = 0;
 		}
 
-		while ((active == 1) && (systime() < callback_time))
+		while ((active == 1) && (time_before(jiffies, callback_time)))
 			msleep(100);
 	} while (active);
 
-- 
1.9.3

