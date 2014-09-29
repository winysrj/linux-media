Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 6/6] [media] drxk: move device init code to .init callback
Date: Sun, 28 Sep 2014 23:23:23 -0300
Message-Id: <5e536ab9105a8713ef30ff932cfd44ab32ad2faf.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of initializing the board during frontend attach, do it
latter, when DVB core calls the .init() callback.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index f140b835c414..18c499acb4c8 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -541,7 +541,7 @@ error:
 }
 
 
-static int init_state(struct drxk_state *state)
+static void init_state(struct drxk_state *state)
 {
 	/*
 	 * FIXME: most (all?) of the values bellow should be moved into
@@ -773,7 +773,6 @@ static int init_state(struct drxk_state *state)
 
 	state->m_rfmirror = (ul_rf_mirror == 0);
 	state->m_if_agc_pol = false;
-	return 0;
 }
 
 static int drxx_open(struct drxk_state *state)
@@ -6053,11 +6052,33 @@ error:
 
 static int init_drxk(struct drxk_state *state)
 {
+	struct dtv_frontend_properties *p;
 	int status = 0, n = 0;
 	enum drx_power_mode power_mode = DRXK_POWER_DOWN_OFDM;
 	u16 driver_version;
 
 	dprintk(1, "\n");
+
+	/* Initialize stats */
+	p = &state->frontend.dtv_property_cache;
+	p->strength.len = 1;
+	p->cnr.len = 1;
+	p->block_error.len = 1;
+	p->block_count.len = 1;
+	p->pre_bit_error.len = 1;
+	p->pre_bit_count.len = 1;
+	p->post_bit_error.len = 1;
+	p->post_bit_count.len = 1;
+
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	if ((state->m_drxk_state == DRXK_UNINITIALIZED)) {
 		drxk_i2c_lock(state);
 		status = power_up_device(state);
@@ -6276,33 +6297,32 @@ error:
 	return status;
 }
 
-static void load_firmware_cb(const struct firmware *fw,
-			     void *context)
+static void load_firmware_cb(struct drxk_state *state)
 {
-	struct drxk_state *state = context;
+	const struct firmware *fw = NULL;
+	int status;
 
-	dprintk(1, ": %s\n", fw ? "firmware loaded" : "firmware not loaded");
+	status = request_firmware(&fw, state->microcode_name,
+				  state->i2c->dev.parent);
+	if (status < 0)
+		fw = NULL;
+
+	dprintk(1, ": firmware %s %s\n", state->microcode_name,
+		fw ? "loaded" : "not loaded");
 	if (!fw) {
 		pr_err("Could not load firmware file %s.\n",
 			state->microcode_name);
 		pr_info("Copy %s to your hotplug directory!\n",
 			state->microcode_name);
-		state->microcode_name = NULL;
+		pr_info("Trying to use the internal firmware, but this may not work well. Be warned.\n");
 
 		/*
-		 * As firmware is now load asynchronous, it is not possible
-		 * anymore to fail at frontend attach. We might silently
-		 * return here, and hope that the driver won't crash.
-		 * We might also change all DVB callbacks to return -ENODEV
-		 * if the device is not initialized.
 		 * As the DRX-K devices have their own internal firmware,
 		 * let's just hope that it will match a firmware revision
 		 * compatible with this driver and proceed.
 		 */
 	}
 	state->fw = fw;
-
-	init_drxk(state);
 }
 
 static void drxk_release(struct dvb_frontend *fe)
@@ -6737,6 +6757,23 @@ static int drxk_get_tune_settings(struct dvb_frontend *fe,
 	}
 }
 
+static int drxk_init(struct dvb_frontend *fe)
+{
+	struct drxk_state *state = fe->demodulator_priv;
+
+	/*
+	 * FIXME: If we let init to run during resume, the frontend
+	 * won't work anymore, on a suspend2ram. Letting it to be
+	 * initialized also doesn't help for suspend2disk. So, let's
+	 * just return for now. Probably, we need to do something else
+	 * during suspend in order to allow to reload the firmware here.
+	 */
+	if (fe->exit == DVB_FE_DEVICE_RESUME)
+		return 0;
+
+	return init_drxk(state);
+}
+
 static struct dvb_frontend_ops drxk_ops = {
 	/* .delsys will be filled dynamically */
 	.info = {
@@ -6760,6 +6797,7 @@ static struct dvb_frontend_ops drxk_ops = {
 	.release = drxk_release,
 	.sleep = drxk_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
+	.init = drxk_init,
 
 	.set_frontend = drxk_set_parameters,
 	.get_tune_settings = drxk_get_tune_settings,
@@ -6773,10 +6811,8 @@ static struct dvb_frontend_ops drxk_ops = {
 struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 				 struct i2c_adapter *i2c)
 {
-	struct dtv_frontend_properties *p;
 	struct drxk_state *state = NULL;
 	u8 adr = config->adr;
-	int status;
 
 	dprintk(1, "\n");
 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
@@ -6802,7 +6838,6 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 		state->m_dvbc_static_clk = true;
 	}
 
-
 	if (config->mpeg_out_clk_strength)
 		state->m_ts_clockk_strength = config->mpeg_out_clk_strength & 0x07;
 	else
@@ -6827,48 +6862,14 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	memcpy(&state->frontend.ops, &drxk_ops, sizeof(drxk_ops));
 	state->frontend.demodulator_priv = state;
 
-	init_state(state);
-
 	/* Load firmware and initialize DRX-K */
-	if (state->microcode_name) {
-		const struct firmware *fw = NULL;
+	if (state->microcode_name)
+		load_firmware_cb(state);
 
-		status = request_firmware(&fw, state->microcode_name,
-					  state->i2c->dev.parent);
-		if (status < 0)
-			fw = NULL;
-		load_firmware_cb(fw, state);
-	} else if (init_drxk(state) < 0)
-		goto error;
+	init_state(state);
 
-
-	/* Initialize stats */
-	p = &state->frontend.dtv_property_cache;
-	p->strength.len = 1;
-	p->cnr.len = 1;
-	p->block_error.len = 1;
-	p->block_count.len = 1;
-	p->pre_bit_error.len = 1;
-	p->pre_bit_count.len = 1;
-	p->post_bit_error.len = 1;
-	p->post_bit_count.len = 1;
-
-	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-
-	pr_info("frontend initialized.\n");
+	pr_info("frontend attached.\n");
 	return &state->frontend;
-
-error:
-	pr_err("not found\n");
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL(drxk_attach);
 
-- 
1.9.3

