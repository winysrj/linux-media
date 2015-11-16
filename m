Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44904 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/16] tda8261: don't use set_state/get_state callbacks
Date: Mon, 16 Nov 2015 08:21:09 -0200
Message-Id: <37d9687452f7aa89359d303bfe001117fe642441.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those callbacks are meant to be used only on some very specific
cases. There's absolutely no need to do that at tda8261, as
the only parameter that it allows to be set/get is the frequency.

So, use the standard get_params() and get_frequency() kABI
ops.

There's no need to touch at any bridge driver, as all interactions
are done via the macros at tda8261_cfg.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/tda8261.c     | 125 +++++++++++++-----------------
 drivers/media/dvb-frontends/tda8261_cfg.h |  37 +++------
 2 files changed, 63 insertions(+), 99 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 19c488814e5c..3285b1bc4642 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -83,88 +83,71 @@ static int tda8261_get_status(struct dvb_frontend *fe, u32 *status)
 static const u32 div_tab[] = { 2000, 1000,  500,  250,  125 }; /* kHz */
 static const u8  ref_div[] = { 0x00, 0x01, 0x02, 0x05, 0x07 };
 
-static int tda8261_get_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *tstate)
+static int tda8261_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda8261_state *state = fe->tuner_priv;
-	int err = 0;
 
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		tstate->frequency = state->frequency;
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		tstate->bandwidth = 40000000; /* FIXME! need to calculate Bandwidth */
-		break;
-	default:
-		pr_err("%s: Unknown parameter (param=%d)\n", __func__, param);
-		err = -EINVAL;
-		break;
-	}
+	*frequency = state->frequency;
 
-	return err;
+	return 0;
 }
 
-static int tda8261_set_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *tstate)
+static int tda8261_set_params(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda8261_state *state = fe->tuner_priv;
 	const struct tda8261_config *config = state->config;
 	u32 frequency, N, status = 0;
 	u8 buf[4];
 	int err = 0;
 
-	if (param & DVBFE_TUNER_FREQUENCY) {
-		/**
-		 * N = Max VCO Frequency / Channel Spacing
-		 * Max VCO Frequency = VCO frequency + (channel spacing - 1)
-		 * (to account for half channel spacing on either side)
-		 */
-		frequency = tstate->frequency;
-		if ((frequency < 950000) || (frequency > 2150000)) {
-			pr_warn("%s: Frequency beyond limits, frequency=%d\n", __func__, frequency);
-			return -EINVAL;
-		}
-		N = (frequency + (div_tab[config->step_size] - 1)) / div_tab[config->step_size];
-		pr_debug("%s: Step size=%d, Divider=%d, PG=0x%02x (%d)\n",
-			__func__, config->step_size, div_tab[config->step_size], N, N);
-
-		buf[0] = (N >> 8) & 0xff;
-		buf[1] = N & 0xff;
-		buf[2] = (0x01 << 7) | ((ref_div[config->step_size] & 0x07) << 1);
-
-		if (frequency < 1450000)
-			buf[3] = 0x00;
-		else if (frequency < 2000000)
-			buf[3] = 0x40;
-		else if (frequency < 2150000)
-			buf[3] = 0x80;
-
-		/* Set params */
-		if ((err = tda8261_write(state, buf)) < 0) {
-			pr_err("%s: I/O Error\n", __func__);
-			return err;
-		}
-		/* sleep for some time */
-		pr_debug("%s: Waiting to Phase LOCK\n", __func__);
-		msleep(20);
-		/* check status */
-		if ((err = tda8261_get_status(fe, &status)) < 0) {
-			pr_err("%s: I/O Error\n", __func__);
-			return err;
-		}
-		if (status == 1) {
-			pr_debug("%s: Tuner Phase locked: status=%d\n", __func__, status);
-			state->frequency = frequency; /* cache successful state */
-		} else {
-			pr_debug("%s: No Phase lock: status=%d\n", __func__, status);
-		}
-	} else {
-		pr_err("%s: Unknown parameter (param=%d)\n", __func__, param);
+	/*
+	 * N = Max VCO Frequency / Channel Spacing
+	 * Max VCO Frequency = VCO frequency + (channel spacing - 1)
+	 * (to account for half channel spacing on either side)
+	 */
+	frequency = c->frequency;
+	if ((frequency < 950000) || (frequency > 2150000)) {
+		pr_warn("%s: Frequency beyond limits, frequency=%d\n",
+			__func__, frequency);
 		return -EINVAL;
 	}
+	N = (frequency + (div_tab[config->step_size] - 1)) / div_tab[config->step_size];
+	pr_debug("%s: Step size=%d, Divider=%d, PG=0x%02x (%d)\n",
+		__func__, config->step_size, div_tab[config->step_size], N, N);
+
+	buf[0] = (N >> 8) & 0xff;
+	buf[1] = N & 0xff;
+	buf[2] = (0x01 << 7) | ((ref_div[config->step_size] & 0x07) << 1);
+
+	if (frequency < 1450000)
+		buf[3] = 0x00;
+	else if (frequency < 2000000)
+		buf[3] = 0x40;
+	else if (frequency < 2150000)
+		buf[3] = 0x80;
+
+	/* Set params */
+	err = tda8261_write(state, buf);
+	if (err < 0) {
+		pr_err("%s: I/O Error\n", __func__);
+		return err;
+	}
+	/* sleep for some time */
+	pr_debug("%s: Waiting to Phase LOCK\n", __func__);
+	msleep(20);
+	/* check status */
+	if ((err = tda8261_get_status(fe, &status)) < 0) {
+		pr_err("%s: I/O Error\n", __func__);
+		return err;
+	}
+	if (status == 1) {
+		pr_debug("%s: Tuner Phase locked: status=%d\n", __func__,
+			 status);
+		state->frequency = frequency; /* cache successful state */
+	} else {
+		pr_debug("%s: No Phase lock: status=%d\n", __func__, status);
+	}
 
 	return 0;
 }
@@ -182,14 +165,13 @@ static struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
 		.name		= "TDA8261",
-//		.tuner_name	= NULL,
 		.frequency_min	=  950000,
 		.frequency_max	= 2150000,
 		.frequency_step = 0
 	},
 
-	.set_state	= tda8261_set_state,
-	.get_state	= tda8261_get_state,
+	.set_params	= tda8261_set_params,
+	.get_frequency	= tda8261_get_frequency,
 	.get_status	= tda8261_get_status,
 	.release	= tda8261_release
 };
@@ -210,10 +192,7 @@ struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 	fe->ops.tuner_ops	= tda8261_ops;
 
 	fe->ops.tuner_ops.info.frequency_step = div_tab[config->step_size];
-//	fe->ops.tuner_ops.tuner_name	 = &config->buf;
 
-//	printk("%s: Attaching %s TDA8261 8PSK/QPSK tuner\n",
-//		__func__, fe->ops.tuner_ops.tuner_name);
 	pr_info("%s: Attaching TDA8261 8PSK/QPSK tuner\n", __func__);
 
 	return fe;
diff --git a/drivers/media/dvb-frontends/tda8261_cfg.h b/drivers/media/dvb-frontends/tda8261_cfg.h
index 04a19e14ee5a..fe527ff84df4 100644
--- a/drivers/media/dvb-frontends/tda8261_cfg.h
+++ b/drivers/media/dvb-frontends/tda8261_cfg.h
@@ -21,17 +21,15 @@ static int tda8261_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
 	int err = 0;
 
-	if (tuner_ops->get_state) {
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+	if (tuner_ops->get_frequency) {
+		err = tuner_ops->get_frequency(fe, frequency);
 		if (err < 0) {
-			printk("%s: Invalid parameter\n", __func__);
+			pr_err("%s: Invalid parameter\n", __func__);
 			return err;
 		}
-		*frequency = t_state.frequency;
-		printk("%s: Frequency=%d\n", __func__, t_state.frequency);
+		pr_debug("%s: Frequency=%d\n", __func__, *frequency);
 	}
 	return 0;
 }
@@ -40,37 +38,24 @@ static int tda8261_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
-	t_state.frequency = frequency;
-
-	if (tuner_ops->set_state) {
-		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+	if (tuner_ops->set_params) {
+		err = tuner_ops->set_params(fe);
 		if (err < 0) {
-			printk("%s: Invalid parameter\n", __func__);
+			pr_err("%s: Invalid parameter\n", __func__);
 			return err;
 		}
 	}
-	printk("%s: Frequency=%d\n", __func__, t_state.frequency);
+	pr_debug("%s: Frequency=%d\n", __func__, c->frequency);
 	return 0;
 }
 
 static int tda8261_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
-	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
-	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
-	int err = 0;
+	/* FIXME! need to calculate Bandwidth */
+	*bandwidth = 40000000;
 
-	if (tuner_ops->get_state) {
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
-		if (err < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-		*bandwidth = t_state.bandwidth;
-		printk("%s: Bandwidth=%d\n", __func__, t_state.bandwidth);
-	}
 	return 0;
 }
-- 
2.5.0

