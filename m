Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab2AEPiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 10:38:00 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05Fc0oL003004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 10:38:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] [media] drxk: create only one frontend for both DVB-C and DVB-T
Date: Thu,  5 Jan 2012 13:37:49 -0200
Message-Id: <1325777872-14696-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of creating two DVB frontend entries for the same device,
create just one entry, and fill the delivery_system according with
the supported standards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    2 +-
 drivers/media/dvb/frontends/drxk.h         |    6 +-
 drivers/media/dvb/frontends/drxk_hard.c    |  192 ++++++++++++----------------
 drivers/media/dvb/frontends/drxk_hard.h    |    3 +-
 drivers/media/dvb/ngene/ngene-cards.c      |    2 +-
 drivers/media/video/em28xx/em28xx-dvb.c    |   28 +----
 6 files changed, 88 insertions(+), 145 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index ba9a643..2f31648 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -580,7 +580,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 	memset(&config, 0, sizeof(config));
 	config.adr = 0x29 + (input->nr & 1);
 
-	fe = input->fe = dvb_attach(drxk_attach, &config, i2c, &input->fe2);
+	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!input->fe) {
 		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 870432f..0209818 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -37,12 +37,10 @@ struct drxk_config {
 #if defined(CONFIG_DVB_DRXK) || (defined(CONFIG_DVB_DRXK_MODULE) \
         && defined(MODULE))
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
-					struct i2c_adapter *i2c,
-					struct dvb_frontend **fe_t);
+					struct i2c_adapter *i2c);
 #else
 static inline struct dvb_frontend *drxk_attach(const struct drxk_config *config,
-					struct i2c_adapter *i2c,
-					struct dvb_frontend **fe_t)
+					struct i2c_adapter *i2c)
 {
         printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
         return NULL;
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 77e78f4..a95fb44 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6174,7 +6174,7 @@ error:
 	return status;
 }
 
-static void drxk_c_release(struct dvb_frontend *fe)
+static void drxk_release(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
@@ -6182,21 +6182,7 @@ static void drxk_c_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static int drxk_c_init(struct dvb_frontend *fe)
-{
-	struct drxk_state *state = fe->demodulator_priv;
-
-	dprintk(1, "\n");
-	if (mutex_trylock(&state->ctlock) == 0)
-		return -EBUSY;
-	if (state->m_itut_annex_c)
-		SetOperationMode(state, OM_QAM_ITU_C);
-	else
-		SetOperationMode(state, OM_QAM_ITU_A);
-	return 0;
-}
-
-static int drxk_c_sleep(struct dvb_frontend *fe)
+static int drxk_sleep(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
@@ -6229,24 +6215,36 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (fe->ops.tuner_ops.set_params)
+		fe->ops.tuner_ops.set_params(fe);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	state->props = *p;
+
 	switch (delsys) {
 	case SYS_DVBC_ANNEX_A:
-		state->m_itut_annex_c = false;
-		break;
 	case SYS_DVBC_ANNEX_C:
+		if (!state->m_hasDVBC)
+			return -EINVAL;
+		state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ? true : false;
+		if (state->m_itut_annex_c)
+			SetOperationMode(state, OM_QAM_ITU_C);
+		else
+			SetOperationMode(state, OM_QAM_ITU_A);
+			break;
 		state->m_itut_annex_c = true;
 		break;
+	case SYS_DVBT:
+		if (!state->m_hasDVBT)
+			return -EINVAL;
+		SetOperationMode(state, OM_DVBT);
+		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-	state->props = *p;
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	Start(state, 0, IF);
 
@@ -6314,91 +6312,54 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int drxk_c_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings
+static int drxk_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings
 				    *sets)
 {
-	dprintk(1, "\n");
-	sets->min_delay_ms = 3000;
-	sets->max_drift = 0;
-	sets->step_size = 0;
-	return 0;
-}
-
-static void drxk_t_release(struct dvb_frontend *fe)
-{
-	/*
-	 * There's nothing to release here, as the state struct
-	 * is already freed by drxk_c_release.
-	 */
-}
-
-static int drxk_t_init(struct dvb_frontend *fe)
-{
-	struct drxk_state *state = fe->demodulator_priv;
-
-	dprintk(1, "\n");
-	if (mutex_trylock(&state->ctlock) == 0)
-		return -EBUSY;
-	SetOperationMode(state, OM_DVBT);
-	return 0;
-}
-
-static int drxk_t_sleep(struct dvb_frontend *fe)
-{
-	struct drxk_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	dprintk(1, "\n");
-	mutex_unlock(&state->ctlock);
-	return 0;
+	switch (p->delivery_system) {
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		sets->min_delay_ms = 3000;
+		sets->max_drift = 0;
+		sets->step_size = 0;
+		return 0;
+	default:
+		/*
+		 * For DVB-T, let it use the default DVB core way, that is:
+		 *	fepriv->step_size = fe->ops.info.frequency_stepsize * 2
+		 */
+		return -EINVAL;
+	}
 }
 
-static struct dvb_frontend_ops drxk_c_ops = {
-	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
-	.info = {
-		 .name = "DRXK DVB-C",
-		 .frequency_min = 47000000,
-		 .frequency_max = 862000000,
-		 .symbol_rate_min = 870000,
-		 .symbol_rate_max = 11700000,
-		 .caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
-		 FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_FEC_AUTO},
-	.release = drxk_c_release,
-	.init = drxk_c_init,
-	.sleep = drxk_c_sleep,
-	.i2c_gate_ctrl = drxk_gate_ctrl,
-
-	.set_frontend = drxk_set_parameters,
-	.get_tune_settings = drxk_c_get_tune_settings,
-
-	.read_status = drxk_read_status,
-	.read_ber = drxk_read_ber,
-	.read_signal_strength = drxk_read_signal_strength,
-	.read_snr = drxk_read_snr,
-	.read_ucblocks = drxk_read_ucblocks,
-};
-
-static struct dvb_frontend_ops drxk_t_ops = {
-	.delsys = { SYS_DVBT },
+static struct dvb_frontend_ops drxk_ops = {
+	/* .delsys will be filled dynamically */
 	.info = {
-		 .name = "DRXK DVB-T",
-		 .frequency_min = 47125000,
-		 .frequency_max = 865000000,
-		 .frequency_stepsize = 166667,
-		 .frequency_tolerance = 0,
-		 .caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
-		 FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		 FE_CAN_FEC_AUTO |
-		 FE_CAN_QAM_16 | FE_CAN_QAM_64 |
-		 FE_CAN_QAM_AUTO |
-		 FE_CAN_TRANSMISSION_MODE_AUTO |
-		 FE_CAN_GUARD_INTERVAL_AUTO |
-		 FE_CAN_HIERARCHY_AUTO | FE_CAN_RECOVER | FE_CAN_MUTE_TS},
-	.release = drxk_t_release,
-	.init = drxk_t_init,
-	.sleep = drxk_t_sleep,
+		.name = "DRXK",
+		.frequency_min = 47000000,
+		.frequency_max = 865000000,
+		 /* For DVB-C */
+		.symbol_rate_min = 870000,
+		.symbol_rate_max = 11700000,
+		/* For DVB-T */
+		.frequency_stepsize = 166667,
+
+		.caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_FEC_AUTO |
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_MUTE_TS |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_RECOVER |
+			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO
+	},
+
+	.release = drxk_release,
+	.sleep = drxk_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
 	.set_frontend = drxk_set_parameters,
+	.get_tune_settings = drxk_get_tune_settings,
 
 	.read_status = drxk_read_status,
 	.read_ber = drxk_read_ber,
@@ -6408,9 +6369,10 @@ static struct dvb_frontend_ops drxk_t_ops = {
 };
 
 struct dvb_frontend *drxk_attach(const struct drxk_config *config,
-				 struct i2c_adapter *i2c,
-				 struct dvb_frontend **fe_t)
+				 struct i2c_adapter *i2c)
 {
+	int n;
+
 	struct drxk_state *state = NULL;
 	u8 adr = config->adr;
 
@@ -6445,21 +6407,29 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
 
-	memcpy(&state->c_frontend.ops, &drxk_c_ops,
-	       sizeof(struct dvb_frontend_ops));
-	memcpy(&state->t_frontend.ops, &drxk_t_ops,
-	       sizeof(struct dvb_frontend_ops));
-	state->c_frontend.demodulator_priv = state;
-	state->t_frontend.demodulator_priv = state;
+	memcpy(&state->frontend.ops, &drxk_ops, sizeof(drxk_ops));
+	state->frontend.demodulator_priv = state;
 
 	init_state(state);
 	if (init_drxk(state) < 0)
 		goto error;
-	*fe_t = &state->t_frontend;
 
-	printk(KERN_INFO "drxk: frontend initialized.\n");
+	/* Initialize the supported delivery systems */
+	n = 0;
+	if (state->m_hasDVBC) {
+		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
+		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
+		strlcat(state->frontend.ops.info.name, " DVB-C",
+			sizeof(state->frontend.ops.info.name));
+	}
+	if (state->m_hasDVBT) {
+		state->frontend.ops.delsys[n++] = SYS_DVBT;
+		strlcat(state->frontend.ops.info.name, " DVB-T",
+			sizeof(state->frontend.ops.info.name));
+	}
 
-	return &state->c_frontend;
+	printk(KERN_INFO "drxk: frontend initialized.\n");
+	return &state->frontend;
 
 error:
 	printk(KERN_ERR "drxk: not found\n");
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 60bcd61..7e3e4cf 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -195,8 +195,7 @@ struct DRXKOfdmScCmd_t {
 };
 
 struct drxk_state {
-	struct dvb_frontend c_frontend;
-	struct dvb_frontend t_frontend;
+	struct dvb_frontend frontend;
 	struct dtv_frontend_properties props;
 	struct device *dev;
 
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 0564192..8418c02 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -218,7 +218,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 	memset(&config, 0, sizeof(config));
 	config.adr = 0x29 + (chan->number ^ 2);
 
-	chan->fe = dvb_attach(drxk_attach, &config, i2c, &chan->fe2);
+	chan->fe = dvb_attach(drxk_attach, &config, i2c);
 	if (!chan->fe) {
 		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 1194631..ac55de9 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -874,11 +874,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		struct xc5000_config cfg;
 		hauppauge_hvr930c_init(dev);
 
-		dvb->dont_attach_fe1 = 1;
-
 		dvb->fe[0] = dvb_attach(drxk_attach,
-					&hauppauge_930c_drxk, &dev->i2c_adap,
-					&dvb->fe[1]);
+					&hauppauge_930c_drxk, &dev->i2c_adap);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -888,7 +885,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		sema_init(&dvb->pll_mutex, 1);
 		dvb->gate_ctrl = dvb->fe[0]->ops.i2c_gate_ctrl;
 		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-		dvb->fe[1]->id = 1;
 
 		/* Attach xc5000 */
 		memset(&cfg, 0, sizeof(cfg));
@@ -902,27 +898,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			result = -EINVAL;
 			goto out_free;
 		}
-
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
 
-		/* Hack - needed by drxk/tda18271c2dd */
-		dvb->fe[1]->tuner_priv = dvb->fe[0]->tuner_priv;
-		memcpy(&dvb->fe[1]->ops.tuner_ops,
-		       &dvb->fe[0]->ops.tuner_ops,
-		       sizeof(dvb->fe[0]->ops.tuner_ops));
-
-		mfe_shared = 1;
-
 		break;
 	}
 	case EM2884_BOARD_TERRATEC_H5:
 	case EM2884_BOARD_CINERGY_HTC_STICK:
 		terratec_h5_init(dev);
 
-		dvb->dont_attach_fe1 = 1;
-
-		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap, &dvb->fe[1]);
+		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -932,7 +917,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		sema_init(&dvb->pll_mutex, 1);
 		dvb->gate_ctrl = dvb->fe[0]->ops.i2c_gate_ctrl;
 		dvb->fe[0]->ops.i2c_gate_ctrl = drxk_gate_ctrl;
-		dvb->fe[1]->id = 1;
 
 		/* Attach tda18271 to DVB-C frontend */
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
@@ -944,14 +928,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 0);
 
-		/* Hack - needed by drxk/tda18271c2dd */
-		dvb->fe[1]->tuner_priv = dvb->fe[0]->tuner_priv;
-		memcpy(&dvb->fe[1]->ops.tuner_ops,
-		       &dvb->fe[0]->ops.tuner_ops,
-		       sizeof(dvb->fe[0]->ops.tuner_ops));
-
-		mfe_shared = 1;
-
 		break;
 	case EM28174_BOARD_PCTV_460E:
 		/* attach demod */
-- 
1.7.7.5

