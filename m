Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcF2Wnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 04/10] au8522: reorder functions to avoid a forward declaration
Date: Wed, 29 Jun 2016 19:43:20 -0300
Message-Id: <9d71a3692baff11d90092abab75b437aff3078b3.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move au8522_read_status() to be after au8522_get_stats(), in
order to avoid the need of a forward declaration.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 122 +++++++++++++++----------------
 1 file changed, 60 insertions(+), 62 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index 8a0764f605b0..aebee53903cc 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -650,68 +650,6 @@ static int au8522_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status);
-
-static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
-{
-	struct au8522_state *state = fe->demodulator_priv;
-	u8 reg;
-	u32 tuner_status = 0;
-
-	*status = 0;
-
-	if (state->current_modulation == VSB_8) {
-		dprintk("%s() Checking VSB_8\n", __func__);
-		reg = au8522_readreg(state, 0x4088);
-		if ((reg & 0x03) == 0x03)
-			*status |= FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI;
-	} else {
-		dprintk("%s() Checking QAM\n", __func__);
-		reg = au8522_readreg(state, 0x4541);
-		if (reg & 0x80)
-			*status |= FE_HAS_VITERBI;
-		if (reg & 0x20)
-			*status |= FE_HAS_LOCK | FE_HAS_SYNC;
-	}
-
-	switch (state->config.status_mode) {
-	case AU8522_DEMODLOCKING:
-		dprintk("%s() DEMODLOCKING\n", __func__);
-		if (*status & FE_HAS_VITERBI)
-			*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
-		break;
-	case AU8522_TUNERLOCKING:
-		/* Get the tuner status */
-		dprintk("%s() TUNERLOCKING\n", __func__);
-		if (fe->ops.tuner_ops.get_status) {
-			if (fe->ops.i2c_gate_ctrl)
-				fe->ops.i2c_gate_ctrl(fe, 1);
-
-			fe->ops.tuner_ops.get_status(fe, &tuner_status);
-
-			if (fe->ops.i2c_gate_ctrl)
-				fe->ops.i2c_gate_ctrl(fe, 0);
-		}
-		if (tuner_status)
-			*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
-		break;
-	}
-	state->fe_status = *status;
-
-	if (*status & FE_HAS_LOCK)
-		/* turn on LED, if it isn't on already */
-		au8522_led_ctrl(state, -1);
-	else
-		/* turn off LED */
-		au8522_led_ctrl(state, 0);
-
-	dprintk("%s() status 0x%08x\n", __func__, *status);
-
-	au8522_get_stats(fe, *status);
-
-	return 0;
-}
-
 static int au8522_led_status(struct au8522_state *state, const u16 *snr)
 {
 	struct au8522_led_config *led_config = state->config.led_cfg;
@@ -859,6 +797,66 @@ static int au8522_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+	u8 reg;
+	u32 tuner_status = 0;
+
+	*status = 0;
+
+	if (state->current_modulation == VSB_8) {
+		dprintk("%s() Checking VSB_8\n", __func__);
+		reg = au8522_readreg(state, 0x4088);
+		if ((reg & 0x03) == 0x03)
+			*status |= FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI;
+	} else {
+		dprintk("%s() Checking QAM\n", __func__);
+		reg = au8522_readreg(state, 0x4541);
+		if (reg & 0x80)
+			*status |= FE_HAS_VITERBI;
+		if (reg & 0x20)
+			*status |= FE_HAS_LOCK | FE_HAS_SYNC;
+	}
+
+	switch (state->config.status_mode) {
+	case AU8522_DEMODLOCKING:
+		dprintk("%s() DEMODLOCKING\n", __func__);
+		if (*status & FE_HAS_VITERBI)
+			*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
+		break;
+	case AU8522_TUNERLOCKING:
+		/* Get the tuner status */
+		dprintk("%s() TUNERLOCKING\n", __func__);
+		if (fe->ops.tuner_ops.get_status) {
+			if (fe->ops.i2c_gate_ctrl)
+				fe->ops.i2c_gate_ctrl(fe, 1);
+
+			fe->ops.tuner_ops.get_status(fe, &tuner_status);
+
+			if (fe->ops.i2c_gate_ctrl)
+				fe->ops.i2c_gate_ctrl(fe, 0);
+		}
+		if (tuner_status)
+			*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
+		break;
+	}
+	state->fe_status = *status;
+
+	if (*status & FE_HAS_LOCK)
+		/* turn on LED, if it isn't on already */
+		au8522_led_ctrl(state, -1);
+	else
+		/* turn off LED */
+		au8522_led_ctrl(state, 0);
+
+	dprintk("%s() status 0x%08x\n", __func__, *status);
+
+	au8522_get_stats(fe, *status);
+
+	return 0;
+}
+
 static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct au8522_state *state = fe->demodulator_priv;
-- 
2.7.4

