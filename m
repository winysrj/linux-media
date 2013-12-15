Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3LOWiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 17:38:25 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] dib8000: improves the auto search mode check logic
Date: Sun, 15 Dec 2013 17:35:20 -0200
Message-Id: <1387136120-11754-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that detects if auto search mode should be used is too
complex.

Also, it doesn't cover all cases, as the dib8000_tune logic
requires either auto mode or a fully specified manual mode.

So, move it to a separate function and add some extra debug
data to help identifying when it falled back to auto mode,
because the manual settings are invalid.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 118 ++++++++++++++++++++++++++--------
 1 file changed, 90 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 063232afecd6..f11c9f8f35b3 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2873,6 +2873,91 @@ static int dib8090p_init_sdram(struct dib8000_state *state)
 	return 0;
 }
 
+/**
+ * is_manual_mode - Check if TMCC should be used for parameters settings
+ * @c:	struct dvb_frontend_properties
+ *
+ * By default, TMCC table should be used for parameter settings on most
+ * usercases. However, sometimes it is desirable to lock the demod to
+ * use the manual parameters.
+ *
+ * On manual mode, the current dib8000_tune state machine is very restrict:
+ * It requires that both per-layer and per-transponder parameters to be
+ * properly specified, otherwise the device won't lock.
+ *
+ * Check if all those conditions are properly satisfied before allowing
+ * the device to use the manual frequency lock mode.
+ */
+static int is_manual_mode(struct dtv_frontend_properties *c)
+{
+	int i, n_segs = 0;
+
+	/* Use auto mode on DVB-T compat mode */
+	if (c->delivery_system != SYS_ISDBT)
+		return 0;
+
+	/*
+	 * Transmission mode is only detected on auto mode, currently
+	 */
+	if (c->transmission_mode == TRANSMISSION_MODE_AUTO) {
+		dprintk("transmission mode auto");
+		return 0;
+	}
+
+	/*
+	 * Guard interval is only detected on auto mode, currently
+	 */
+	if (c->guard_interval == GUARD_INTERVAL_AUTO) {
+		dprintk("guard interval auto");
+		return 0;
+	}
+
+	/*
+	 * If no layer is enabled, assume auto mode, as at least one
+	 * layer should be enabled
+	 */
+	if (!c->isdbt_layer_enabled) {
+		dprintk("no layer modulation specified");
+		return 0;
+	}
+
+	/*
+	 * Check if the per-layer parameters aren't auto and
+	 * disable a layer if segment count is 0 or invalid.
+	 */
+	for (i = 0; i < 3; i++) {
+		if (!(c->isdbt_layer_enabled & 1 << i))
+			continue;
+
+		if ((c->layer[i].segment_count > 13) ||
+		    (c->layer[i].segment_count == 0)) {
+			c->isdbt_layer_enabled &= ~(1 << i);
+			continue;
+		}
+
+		n_segs += c->layer[i].segment_count;
+
+		if ((c->layer[i].modulation == QAM_AUTO) ||
+		    (c->layer[i].fec == FEC_AUTO)) {
+			dprintk("layer %c has either modulation or FEC auto",
+				'A' + i);
+			return 0;
+		}
+	}
+
+	/*
+	 * Userspace specified a wrong number of segments.
+	 *	fallback to auto mode.
+	 */
+	if (n_segs == 0 || n_segs > 13) {
+		dprintk("number of segments is invalid");
+		return 0;
+	}
+
+	/* Everything looks ok for manual mode */
+	return 1;
+}
+
 static int dib8000_tune(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
@@ -2901,37 +2986,14 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			if (state->revision == 0x8090)
 				dib8090p_init_sdram(state);
 			state->status = FE_STATUS_TUNE_PENDING;
-			if ((c->delivery_system != SYS_ISDBT) ||
-					(c->inversion == INVERSION_AUTO) ||
-					(c->transmission_mode == TRANSMISSION_MODE_AUTO) ||
-					(c->guard_interval == GUARD_INTERVAL_AUTO) ||
-					(((c->isdbt_layer_enabled & (1 << 0)) != 0) &&
-					 (c->layer[0].segment_count != 0xff) &&
-					 (c->layer[0].segment_count != 0) &&
-					 ((c->layer[0].modulation == QAM_AUTO) ||
-					  (c->layer[0].fec == FEC_AUTO))) ||
-					(((c->isdbt_layer_enabled & (1 << 1)) != 0) &&
-					 (c->layer[1].segment_count != 0xff) &&
-					 (c->layer[1].segment_count != 0) &&
-					 ((c->layer[1].modulation == QAM_AUTO) ||
-					  (c->layer[1].fec == FEC_AUTO))) ||
-					(((c->isdbt_layer_enabled & (1 << 2)) != 0) &&
-					 (c->layer[2].segment_count != 0xff) &&
-					 (c->layer[2].segment_count != 0) &&
-					 ((c->layer[2].modulation == QAM_AUTO) ||
-					  (c->layer[2].fec == FEC_AUTO))) ||
-					(((c->layer[0].segment_count == 0) ||
-					  ((c->isdbt_layer_enabled & (1 << 0)) == 0)) &&
-					 ((c->layer[1].segment_count == 0) ||
-					  ((c->isdbt_layer_enabled & (2 << 0)) == 0)) &&
-					 ((c->layer[2].segment_count == 0) || ((c->isdbt_layer_enabled & (3 << 0)) == 0))))
-				state->channel_parameters_set = 0; /* auto search */
-			else
-				state->channel_parameters_set = 1; /* channel parameters are known */
+			state->channel_parameters_set = is_manual_mode(c);
+
+			dprintk("Tuning channel on %s search mode",
+				state->channel_parameters_set ? "manual" : "auto");
 
 			dib8000_viterbi_state(state, 0); /* force chan dec in restart */
 
-			/* Layer monit */
+			/* Layer monitor */
 			dib8000_write_word(state, 285, dib8000_read_word(state, 285) & 0x60);
 
 			dib8000_set_frequency_offset(state);
-- 
1.8.3.1

