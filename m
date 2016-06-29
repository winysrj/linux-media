Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbcF2Wnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 09/10] au8522/xc5000: use the new get_rf_attenuation() ops
Date: Wed, 29 Jun 2016 19:43:25 -0300
Message-Id: <be523787ff2a90fbe71ad00f1b953a4eb907dc61.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to the new get_rf_attenuation(), in order to remove
some hacks at au8522.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 26 +++++++++++---------
 drivers/media/tuners/xc5000.c            | 42 ++++++++++++++------------------
 2 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index 518040228064..46887cc2225b 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -734,27 +734,29 @@ static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status)
 	}
 
 	/* Get (or estimate) RF strength */
-	if (fe->ops.tuner_ops.get_rf_strength) {
+	if (fe->ops.tuner_ops.get_rf_attenuation) {
+		s32 strength;
+
 		/* If the tuner has RF strength, use it */
-
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		ret = fe->ops.tuner_ops.get_rf_strength(fe, &state->strength);
+		strength = fe->ops.tuner_ops.get_rf_attenuation(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
-		if (ret < 0)
-			state->strength = 0;
 
-		/*
-		 * FIXME: As this frontend is used only with au0828, and,
-		 * currently, the tuner is eiter xc5000 or tda18271, and
-		 * only the first implements get_rf_strength(), we'll assume
-		 * that the strength will be returned in dB.
-		 */
-		c->strength.stat[0].svalue = 35000 - 1000 * (65535 - state->strength) / 256;
 		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = 35000 - strength;
+
+		dprintk("Signal strength = %d.%02d dBm\n",
+	                strength / 1000, (strength % 1000) / 10);
+
+
+		/* For DVBv3 legacy support, adjust scale */
+		strength = 65535 - strength;
+		state->strength = (strength < 0) ? 0 : strength;
 	} else {
 		u32 tmp;
+
 		/*
 		 * If it doen't, estimate from SNR
 		 * (borrowed from lgdt330x.c)
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 91ad392eb60c..1eb57150b1f6 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -569,24 +569,18 @@ static int xc_get_totalgain(struct xc5000_priv *priv, u16 *totalgain)
 	return xc5000_readreg(priv, XREG_TOTALGAIN, totalgain);
 }
 
-static int xc5000_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
+static s32 xc5000_get_rf_attenuation(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
-	u16 gain = 0;
-
-	*strength = 0;
+	u16 gain = 65535;
 
 	ret = xc_get_totalgain(priv, &gain);
 	if (ret < 0)
-		return ret;
+		return 256000;
 
-	*strength = 65535 - gain;
-
-	dprintk(1, "Signal strength = 0x%04x (gain = 0x%04x)\n",
-		*strength, gain);
-
-	return 0;
+	/* In theory, it will range from 256 dB to 0 dB */
+	return (1000 * gain) / 256;
 }
 
 static u16 wait_for_lock(struct xc5000_priv *priv)
@@ -1399,20 +1393,20 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 		.frequency_step =      50000,
 	},
 
-	.release	   = xc5000_release,
-	.init		   = xc5000_init,
-	.sleep		   = xc5000_sleep,
-	.suspend	   = xc5000_suspend,
-	.resume		   = xc5000_resume,
+	.release	    = xc5000_release,
+	.init		    = xc5000_init,
+	.sleep		    = xc5000_sleep,
+	.suspend	    = xc5000_suspend,
+	.resume		    = xc5000_resume,
 
-	.set_config	   = xc5000_set_config,
-	.set_params	   = xc5000_set_digital_params,
-	.set_analog_params = xc5000_set_analog_params,
-	.get_frequency	   = xc5000_get_frequency,
-	.get_if_frequency  = xc5000_get_if_frequency,
-	.get_bandwidth	   = xc5000_get_bandwidth,
-	.get_status	   = xc5000_get_status,
-	.get_rf_strength   = xc5000_get_rf_strength
+	.set_config	    = xc5000_set_config,
+	.set_params	    = xc5000_set_digital_params,
+	.set_analog_params  = xc5000_set_analog_params,
+	.get_frequency	    = xc5000_get_frequency,
+	.get_if_frequency   = xc5000_get_if_frequency,
+	.get_bandwidth	    = xc5000_get_bandwidth,
+	.get_status	    = xc5000_get_status,
+	.get_rf_attenuation = xc5000_get_rf_attenuation,
 };
 
 struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
-- 
2.7.4

