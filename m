Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.domdv.de ([193.102.202.1]:2945 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbaCZUjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 16:39:25 -0400
Message-ID: <1395865972.23074.61.camel@host028-server-9.lan.domdv.de>
Subject: [PATCH 2/3] TBS USB drivers (DVB-S/S2) - add lock led hooks to
 frontends
From: Andreas Steinmetz <ast@domdv.de>
To: linux-media@vger.kernel.org
Date: Wed, 26 Mar 2014 21:32:52 +0100
Content-Type: multipart/mixed; boundary="=-5//w74PPt19lFct1NON6"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-5//w74PPt19lFct1NON6
Content-Type: text/plain; charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit

[Please CC me on replies, I'm not subscribed]

Based on GPLv2 code taken from:

https://bitbucket.org/CrazyCat/linux-tbs-drivers/

The patch adds lock led hooks to the stv090x, stv0288, cx24116 and
tda10071 frontends. Similar code already exists in the stv0900 frontend.
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de

--=-5//w74PPt19lFct1NON6
Content-Disposition: attachment; filename="add-led-hook-to-frontends.patch"
Content-Type: text/x-patch; name="add-led-hook-to-frontends.patch";
	charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/cx24116.c v4l-dvb/drivers/media/dvb-frontends/cx24116.c
--- v4l-dvb.orig/drivers/media/dvb-frontends/cx24116.c	2014-03-26 14:00:26.009338722 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/cx24116.c	2014-03-26 19:30:42.561267100 +0100
@@ -703,6 +703,9 @@ static int cx24116_read_status(struct dv
 	if (lock & CX24116_HAS_SYNCLOCK)
 		*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, *status & FE_HAS_LOCK);
+
 	return 0;
 }
 
@@ -1111,6 +1114,8 @@ static void cx24116_release(struct dvb_f
 {
 	struct cx24116_state *state = fe->demodulator_priv;
 	dprintk("%s\n", __func__);
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
 	kfree(state);
 }
 
@@ -1196,6 +1201,9 @@ static int cx24116_sleep(struct dvb_fron
 
 	dprintk("%s()\n", __func__);
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
 	/* Firmware CMD 36: Power config */
 	cmd.args[0x00] = CMD_TUNERSLEEP;
 	cmd.args[0x01] = 1;
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/cx24116.h v4l-dvb/drivers/media/dvb-frontends/cx24116.h
--- v4l-dvb.orig/drivers/media/dvb-frontends/cx24116.h	2014-03-26 14:00:26.009338722 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/cx24116.h	2014-03-26 19:30:42.562267103 +0100
@@ -34,6 +34,9 @@ struct cx24116_config {
 	/* Need to reset device during firmware loading */
 	int (*reset_device)(struct dvb_frontend *fe);
 
+	/* Hook for Lock LED */
+	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
+
 	/* Need to set MPEG parameters */
 	u8 mpg_clk_pos_pol:0x02;
 
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/stv0288.c v4l-dvb/drivers/media/dvb-frontends/stv0288.c
--- v4l-dvb.orig/drivers/media/dvb-frontends/stv0288.c	2014-03-26 14:00:26.026338778 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/stv0288.c	2014-03-26 19:30:52.361300077 +0100
@@ -381,6 +381,9 @@ static int stv0288_read_status(struct dv
 		dprintk("stv0288 has locked\n");
 	}
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, *status & FE_HAS_LOCK);
+
 	return 0;
 }
 
@@ -415,6 +418,9 @@ static int stv0288_sleep(struct dvb_fron
 {
 	struct stv0288_state *state = fe->demodulator_priv;
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
 	stv0288_writeregI(state, 0x41, 0x84);
 	state->initialised = 0;
 
@@ -532,6 +538,8 @@ static int stv0288_i2c_gate_ctrl(struct
 static void stv0288_release(struct dvb_frontend *fe)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
 	kfree(state);
 }
 
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/stv0288.h v4l-dvb/drivers/media/dvb-frontends/stv0288.h
--- v4l-dvb.orig/drivers/media/dvb-frontends/stv0288.h	2014-03-26 14:00:26.026338778 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/stv0288.h	2014-03-26 19:30:52.361300077 +0100
@@ -41,6 +41,9 @@ struct stv0288_config {
 	int min_delay_ms;
 
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
+
+	/* Hook for Lock LED */
+	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
 #if IS_ENABLED(CONFIG_DVB_STV0288)
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/stv090x.c v4l-dvb/drivers/media/dvb-frontends/stv090x.c
--- v4l-dvb.orig/drivers/media/dvb-frontends/stv090x.c	2014-03-26 14:00:26.029338788 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/stv090x.c	2014-03-26 19:31:00.210326489 +0100
@@ -3546,6 +3546,9 @@ static int stv090x_read_status(struct dv
 		break;
 	}
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, *status & FE_HAS_LOCK);
+
 	return 0;
 }
 
@@ -3893,6 +3896,9 @@ static int stv090x_sleep(struct dvb_fron
 	u32 reg;
 	u8 full_standby = 0;
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
 	if (stv090x_i2c_gate_ctrl(state, 1) < 0)
 		goto err;
 
@@ -4124,6 +4130,9 @@ static void stv090x_release(struct dvb_f
 {
 	struct stv090x_state *state = fe->demodulator_priv;
 
+	if (state->config->set_lock_led)
+		state->config->set_lock_led(fe, 0);
+
 	state->internal->num_used--;
 	if (state->internal->num_used <= 0) {
 
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/stv090x.h v4l-dvb/drivers/media/dvb-frontends/stv090x.h
--- v4l-dvb.orig/drivers/media/dvb-frontends/stv090x.h	2014-03-26 14:00:26.029338788 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/stv090x.h	2014-03-26 19:31:00.212326496 +0100
@@ -101,6 +101,9 @@ struct stv090x_config {
 	int (*tuner_set_refclk)  (struct dvb_frontend *fe, u32 refclk);
 	int (*tuner_get_status) (struct dvb_frontend *fe, u32 *status);
 	void (*tuner_i2c_lock) (struct dvb_frontend *fe, int lock);
+
+	/* Hook for Lock LED */
+	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
 #if IS_ENABLED(CONFIG_DVB_STV090x)
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/tda10071.c v4l-dvb/drivers/media/dvb-frontends/tda10071.c
--- v4l-dvb.orig/drivers/media/dvb-frontends/tda10071.c	2014-03-26 15:03:13.427501381 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/tda10071.c	2014-03-26 19:31:07.609351389 +0100
@@ -501,6 +501,9 @@ static int tda10071_read_status(struct d
 	if (tmp & 0x08) /* RS or BCH */
 		*status |= FE_HAS_SYNC | FE_HAS_LOCK;
 
+	if (priv->cfg.set_lock_led)
+		priv->cfg.set_lock_led(fe, *status & FE_HAS_LOCK);
+
 	priv->fe_status = *status;
 
 	return ret;
@@ -1165,6 +1168,9 @@ static int tda10071_sleep(struct dvb_fro
 		goto error;
 	}
 
+	if (priv->cfg.set_lock_led)
+		priv->cfg.set_lock_led(fe, 0);
+
 	cmd.args[0] = CMD_SET_SLEEP_MODE;
 	cmd.args[1] = 0;
 	cmd.args[2] = 1;
@@ -1199,6 +1205,8 @@ static int tda10071_get_tune_settings(st
 static void tda10071_release(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	if (priv->cfg.set_lock_led)
+		priv->cfg.set_lock_led(fe, 0);
 	kfree(priv);
 }
 
diff -rNup v4l-dvb.orig/drivers/media/dvb-frontends/tda10071.h v4l-dvb/drivers/media/dvb-frontends/tda10071.h
--- v4l-dvb.orig/drivers/media/dvb-frontends/tda10071.h	2014-03-26 15:03:13.428501384 +0100
+++ v4l-dvb/drivers/media/dvb-frontends/tda10071.h	2014-03-26 19:31:07.610351392 +0100
@@ -69,6 +69,9 @@ struct tda10071_config {
 	 * Values:
 	 */
 	u8 pll_multiplier;
+
+	/* Hook for Lock LED */
+	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
 

--=-5//w74PPt19lFct1NON6--

