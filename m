Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:39747 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1JRT4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:56:39 -0400
Date: Tue, 18 Oct 2011 21:56:36 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 6/14] staging/media/as102: checkpatch fixes
Message-ID: <20111018215636.1575d4d8@darkstar>
In-Reply-To: <20111018111206.21439e30.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111206.21439e30.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318799 18000
# Node ID 5916edd6739e9b8e02ff8a1e93161c4d23b50b3e
# Parent  1ccb2e0adbf02a111decf8a4c78e93f4354e2bd2
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as102_fe.c.

Priority: normal

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
--- linux/drivers/staging/media/as102/as102_fe.c
+++ linuxb/drivers/staging/media/as102/as102_fe.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,12 +32,14 @@
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
 					  struct dvb_frontend_parameters *src);
 
-static void as102_fe_release(struct dvb_frontend *fe) {
+static void as102_fe_release(struct dvb_frontend *fe)
+{
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return;
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
@@ -64,13 +67,15 @@
 }
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
-static int as102_fe_init(struct dvb_frontend *fe) {
+static int as102_fe_init(struct dvb_frontend *fe)
+{
 	int ret = 0;
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -90,14 +95,16 @@
 #endif
 
 static int as102_fe_set_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *params) {
+				 struct dvb_frontend_parameters *params)
+{
 	int ret = 0;
 	struct as102_dev_t *dev;
 	struct as10x_tune_args tune_args = { 0 };
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -107,9 +114,8 @@
 
 	/* send abilis command: SET_TUNE */
 	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
-	if(ret != 0) {
+	if (ret != 0)
 		dprintk(debug, "as10x_cmd_set_tune failed. (err = %d)\n", ret);
-	}
 
 	mutex_unlock(&dev->bus_adap.lock);
 
@@ -117,7 +123,7 @@
 	return (ret < 0) ? -EINVAL : 0;
 }
 
-static int as102_fe_get_frontend(struct dvb_frontend* fe,
+static int as102_fe_get_frontend(struct dvb_frontend *fe,
 				 struct dvb_frontend_parameters *p) {
 	int ret = 0;
 	struct as102_dev_t *dev;
@@ -125,7 +131,8 @@
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -150,7 +157,8 @@
 #if 0
 	dprintk(debug, "step_size    = %d\n", settings->step_size);
 	dprintk(debug, "max_drift    = %d\n", settings->max_drift);
-	dprintk(debug, "min_delay_ms = %d -> %d\n", settings->min_delay_ms, 1000);
+	dprintk(debug, "min_delay_ms = %d -> %d\n", settings->min_delay_ms,
+		1000);
 #endif
 
 	settings->min_delay_ms = 1000;
@@ -160,14 +168,16 @@
 }
 
 
-static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status) {
+static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
 	int ret = 0;
 	struct as102_dev_t *dev;
 	struct as10x_tune_status tstate = { 0 };
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -176,48 +186,47 @@
 	/* send abilis command: GET_TUNE_STATUS */
 	ret = as10x_cmd_get_tune_status(&dev->bus_adap, &tstate);
 	if (ret < 0) {
-		dprintk(debug, "as10x_cmd_get_tune_status failed (err = %d)\n", ret);
+		dprintk(debug, "as10x_cmd_get_tune_status failed (err = %d)\n",
+			ret);
 		goto out;
 	}
 
 	dev->signal_strength  = tstate.signal_strength;
 	dev->ber  = tstate.BER;
 
-	switch(tstate.tune_state) {
-		case TUNE_STATUS_SIGNAL_DVB_OK:
-			*status = FE_HAS_SIGNAL |
-				  FE_HAS_CARRIER;
-			break;
-		case TUNE_STATUS_STREAM_DETECTED:
-			*status = FE_HAS_SIGNAL  |
-				  FE_HAS_CARRIER |
-				  FE_HAS_SYNC;
-			break;
-		case TUNE_STATUS_STREAM_TUNED:
-			*status = FE_HAS_SIGNAL  |
-				  FE_HAS_CARRIER |
-				  FE_HAS_SYNC	 |
-				  FE_HAS_LOCK;
-			break;
-		default:
-			*status = TUNE_STATUS_NOT_TUNED;
+	switch (tstate.tune_state) {
+	case TUNE_STATUS_SIGNAL_DVB_OK:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		break;
+	case TUNE_STATUS_STREAM_DETECTED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
+		break;
+	case TUNE_STATUS_STREAM_TUNED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
+			FE_HAS_LOCK;
+		break;
+	default:
+		*status = TUNE_STATUS_NOT_TUNED;
 	}
 
-	dprintk(debug, "tuner status: 0x%02x , strength %d , per: %d , ber: %d\n",
+	dprintk(debug, "tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
 			tstate.tune_state, tstate.signal_strength,
 			tstate.PER, tstate.BER);
 
 	if (*status & FE_HAS_LOCK) {
 		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
-				(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
+			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
 			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-			dprintk(debug, "as10x_cmd_get_demod_stats failed (probably not tuned)\n");
+			dprintk(debug, "as10x_cmd_get_demod_stats failed "
+				"(probably not tuned)\n");
 		} else {
-			dprintk(debug, "demod status: fc: 0x%08x , bad fc: 0x%08x , bytes corrected: 0x%08x , MER: 0x%04x\n",
-					dev->demod_stats.frame_count,
-					dev->demod_stats.bad_frame_count,
-					dev->demod_stats.bytes_fixed_by_rs,
-					dev->demod_stats.mer);
+			dprintk(debug,
+				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
+				"bytes corrected: 0x%08x , MER: 0x%04x\n",
+				dev->demod_stats.frame_count,
+				dev->demod_stats.bad_frame_count,
+				dev->demod_stats.bytes_fixed_by_rs,
+				dev->demod_stats.mer);
 		}
 	} else {
 		memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
@@ -236,12 +245,14 @@
  *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
  *   - the accuracy is >2dB for SNR values outside this range
  */
-static int as102_fe_read_snr(struct dvb_frontend* fe, u16* snr) {
+static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	*snr = dev->demod_stats.mer;
@@ -250,12 +261,14 @@
 	return 0;
 }
 
-static int as102_fe_read_ber(struct dvb_frontend* fe, u32* ber) {
+static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	*ber = dev->ber;
@@ -264,12 +277,15 @@
 	return 0;
 }
 
-static int as102_fe_read_signal_strength(struct dvb_frontend* fe, u16* strength) {
+static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
@@ -278,12 +294,14 @@
 	return 0;
 }
 
-static int as102_fe_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks) {
+static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
 	struct as102_dev_t *dev;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	if (dev->demod_stats.has_started)
@@ -296,13 +314,15 @@
 }
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19))
-static int as102_fe_ts_bus_ctrl(struct dvb_frontend* fe, int acquire) {
+static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
 	struct as102_dev_t *dev;
 	int ret;
 
 	ENTER();
 
-	if ((dev = (struct as102_dev_t *) fe->tuner_priv) == NULL)
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -362,8 +382,8 @@
 #endif
 };
 
-int as102_dvb_unregister_fe(struct dvb_frontend *fe) {
-
+int as102_dvb_unregister_fe(struct dvb_frontend *fe)
+{
 	/* unregister frontend */
 	dvb_unregister_frontend(fe);
 
@@ -374,11 +394,13 @@
 	return 0;
 }
 
-int as102_dvb_register_fe(struct as102_dev_t *as102_dev, struct dvb_frontend *dvb_fe) {
+int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
+			  struct dvb_frontend *dvb_fe)
+{
 	int errno;
 	struct dvb_adapter *dvb_adap;
 
-	if(as102_dev == NULL)
+	if (as102_dev == NULL)
 		return -EINVAL;
 
 	/* extract dvb_adapter */
@@ -389,140 +411,143 @@
 
 	/* register dbvb frontend */
 	errno = dvb_register_frontend(dvb_adap, dvb_fe);
-	if(errno == 0)
+	if (errno == 0)
 		dvb_fe->tuner_priv = as102_dev;
 
 	return errno;
 }
 
 static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
-					 struct as10x_tps *as10x_tps) {
+					 struct as10x_tps *as10x_tps)
+{
 
 	struct dvb_ofdm_parameters *fe_tps = &dst->u.ofdm;
 
 	/* extract consteallation */
-	switch(as10x_tps->constellation) {
-		case CONST_QPSK:
-			fe_tps->constellation = QPSK;
-			break;
-		case CONST_QAM16:
-			fe_tps->constellation = QAM_16;
-			break;
-		case CONST_QAM64:
-			fe_tps->constellation = QAM_64;
-			break;
+	switch (as10x_tps->constellation) {
+	case CONST_QPSK:
+		fe_tps->constellation = QPSK;
+		break;
+	case CONST_QAM16:
+		fe_tps->constellation = QAM_16;
+		break;
+	case CONST_QAM64:
+		fe_tps->constellation = QAM_64;
+		break;
 	}
 
 	/* extract hierarchy */
-	switch(as10x_tps->hierarchy) {
-		case HIER_NONE:
-			fe_tps->hierarchy_information = HIERARCHY_NONE;
-			break;
-		case HIER_ALPHA_1:
-			fe_tps->hierarchy_information = HIERARCHY_1;
-			break;
-		case HIER_ALPHA_2:
-			fe_tps->hierarchy_information = HIERARCHY_2;
-			break;
-		case HIER_ALPHA_4:
-			fe_tps->hierarchy_information = HIERARCHY_4;
-			break;
+	switch (as10x_tps->hierarchy) {
+	case HIER_NONE:
+		fe_tps->hierarchy_information = HIERARCHY_NONE;
+		break;
+	case HIER_ALPHA_1:
+		fe_tps->hierarchy_information = HIERARCHY_1;
+		break;
+	case HIER_ALPHA_2:
+		fe_tps->hierarchy_information = HIERARCHY_2;
+		break;
+	case HIER_ALPHA_4:
+		fe_tps->hierarchy_information = HIERARCHY_4;
+		break;
 	}
 
 	/* extract code rate HP */
-	switch(as10x_tps->code_rate_HP) {
-		case CODE_RATE_1_2:
-			fe_tps->code_rate_HP = FEC_1_2;
-			break;
-		case CODE_RATE_2_3:
-			fe_tps->code_rate_HP = FEC_2_3;
-			break;
-		case CODE_RATE_3_4:
-			fe_tps->code_rate_HP = FEC_3_4;
-			break;
-		case CODE_RATE_5_6:
-			fe_tps->code_rate_HP = FEC_5_6;
-			break;
-		case CODE_RATE_7_8:
-			fe_tps->code_rate_HP = FEC_7_8;
-			break;
+	switch (as10x_tps->code_rate_HP) {
+	case CODE_RATE_1_2:
+		fe_tps->code_rate_HP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		fe_tps->code_rate_HP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		fe_tps->code_rate_HP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		fe_tps->code_rate_HP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		fe_tps->code_rate_HP = FEC_7_8;
+		break;
 	}
 
 	/* extract code rate LP */
-	switch(as10x_tps->code_rate_LP) {
-		case CODE_RATE_1_2:
-			fe_tps->code_rate_LP = FEC_1_2;
-			break;
-		case CODE_RATE_2_3:
-			fe_tps->code_rate_LP = FEC_2_3;
-			break;
-		case CODE_RATE_3_4:
-			fe_tps->code_rate_LP = FEC_3_4;
-			break;
-		case CODE_RATE_5_6:
-			fe_tps->code_rate_LP = FEC_5_6;
-			break;
-		case CODE_RATE_7_8:
-			fe_tps->code_rate_LP = FEC_7_8;
-			break;
+	switch (as10x_tps->code_rate_LP) {
+	case CODE_RATE_1_2:
+		fe_tps->code_rate_LP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		fe_tps->code_rate_LP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		fe_tps->code_rate_LP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		fe_tps->code_rate_LP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		fe_tps->code_rate_LP = FEC_7_8;
+		break;
 	}
 
 	/* extract guard interval */
-	switch(as10x_tps->guard_interval) {
-		case GUARD_INT_1_32:
-			fe_tps->guard_interval = GUARD_INTERVAL_1_32;
-			break;
-		case GUARD_INT_1_16:
-			fe_tps->guard_interval = GUARD_INTERVAL_1_16;
-			break;
-		case GUARD_INT_1_8:
-			fe_tps->guard_interval = GUARD_INTERVAL_1_8;
-			break;
-		case GUARD_INT_1_4:
-			fe_tps->guard_interval = GUARD_INTERVAL_1_4;
-			break;
+	switch (as10x_tps->guard_interval) {
+	case GUARD_INT_1_32:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case GUARD_INT_1_16:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case GUARD_INT_1_8:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case GUARD_INT_1_4:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_4;
+		break;
 	}
 
 	/* extract transmission mode */
-	switch(as10x_tps->transmission_mode) {
-		case TRANS_MODE_2K:
-			fe_tps->transmission_mode = TRANSMISSION_MODE_2K;
-			break;
-		case TRANS_MODE_8K:
-			fe_tps->transmission_mode = TRANSMISSION_MODE_8K;
-			break;
+	switch (as10x_tps->transmission_mode) {
+	case TRANS_MODE_2K:
+		fe_tps->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case TRANS_MODE_8K:
+		fe_tps->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
 	}
 }
 
-static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg) {
+static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
+{
 	uint8_t c;
 
-	switch(arg) {
-		case FEC_1_2:
-			c = CODE_RATE_1_2;
-			break;
-		case FEC_2_3:
-			c = CODE_RATE_2_3;
-			break;
-		case FEC_3_4:
-			c = CODE_RATE_3_4;
-			break;
-		case FEC_5_6:
-			c = CODE_RATE_5_6;
-			break;
-		case FEC_7_8:
-			c = CODE_RATE_7_8;
-			break;
-		default:
-			c = CODE_RATE_UNKNOWN;
-			break;
+	switch (arg) {
+	case FEC_1_2:
+		c = CODE_RATE_1_2;
+		break;
+	case FEC_2_3:
+		c = CODE_RATE_2_3;
+		break;
+	case FEC_3_4:
+		c = CODE_RATE_3_4;
+		break;
+	case FEC_5_6:
+		c = CODE_RATE_5_6;
+		break;
+	case FEC_7_8:
+		c = CODE_RATE_7_8;
+		break;
+	default:
+		c = CODE_RATE_UNKNOWN;
+		break;
 	}
 
 	return c;
 }
 
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
-					  struct dvb_frontend_parameters *params) {
+			  struct dvb_frontend_parameters *params)
+{
 
 	/* set frequency */
 	tune_args->freq = params->frequency / 1000;
@@ -530,81 +555,81 @@
 	/* fix interleaving_mode */
 	tune_args->interleaving_mode = INTLV_NATIVE;
 
-	switch(params->u.ofdm.bandwidth) {
-		case BANDWIDTH_8_MHZ:
-			tune_args->bandwidth = BW_8_MHZ;
-			break;
-		case BANDWIDTH_7_MHZ:
-			tune_args->bandwidth = BW_7_MHZ;
-			break;
-		case BANDWIDTH_6_MHZ:
-			tune_args->bandwidth = BW_6_MHZ;
-			break;
-		default:
-			tune_args->bandwidth = BW_8_MHZ;
+	switch (params->u.ofdm.bandwidth) {
+	case BANDWIDTH_8_MHZ:
+		tune_args->bandwidth = BW_8_MHZ;
+		break;
+	case BANDWIDTH_7_MHZ:
+		tune_args->bandwidth = BW_7_MHZ;
+		break;
+	case BANDWIDTH_6_MHZ:
+		tune_args->bandwidth = BW_6_MHZ;
+		break;
+	default:
+		tune_args->bandwidth = BW_8_MHZ;
 	}
 
-	switch(params->u.ofdm.guard_interval) {
-		case GUARD_INTERVAL_1_32:
-			tune_args->guard_interval = GUARD_INT_1_32;
-			break;
-		case GUARD_INTERVAL_1_16:
-			tune_args->guard_interval = GUARD_INT_1_16;
-			break;
-		case GUARD_INTERVAL_1_8:
-			tune_args->guard_interval = GUARD_INT_1_8;
-			break;
-		case GUARD_INTERVAL_1_4:
-			tune_args->guard_interval = GUARD_INT_1_4;
-			break;
-		case GUARD_INTERVAL_AUTO:
-		default:
-			tune_args->guard_interval = GUARD_UNKNOWN;
-			break;
+	switch (params->u.ofdm.guard_interval) {
+	case GUARD_INTERVAL_1_32:
+		tune_args->guard_interval = GUARD_INT_1_32;
+		break;
+	case GUARD_INTERVAL_1_16:
+		tune_args->guard_interval = GUARD_INT_1_16;
+		break;
+	case GUARD_INTERVAL_1_8:
+		tune_args->guard_interval = GUARD_INT_1_8;
+		break;
+	case GUARD_INTERVAL_1_4:
+		tune_args->guard_interval = GUARD_INT_1_4;
+		break;
+	case GUARD_INTERVAL_AUTO:
+	default:
+		tune_args->guard_interval = GUARD_UNKNOWN;
+		break;
 	}
 
-	switch(params->u.ofdm.constellation) {
-		case QPSK:
-			tune_args->constellation = CONST_QPSK;
-			break;
-		case QAM_16:
-			tune_args->constellation = CONST_QAM16;
-			break;
-		case QAM_64:
-			tune_args->constellation = CONST_QAM64;
-			break;
-		default:
-			tune_args->constellation = CONST_UNKNOWN;
-			break;
+	switch (params->u.ofdm.constellation) {
+	case QPSK:
+		tune_args->constellation = CONST_QPSK;
+		break;
+	case QAM_16:
+		tune_args->constellation = CONST_QAM16;
+		break;
+	case QAM_64:
+		tune_args->constellation = CONST_QAM64;
+		break;
+	default:
+		tune_args->constellation = CONST_UNKNOWN;
+		break;
 	}
 
-	switch(params->u.ofdm.transmission_mode) {
-		case TRANSMISSION_MODE_2K:
-			tune_args->transmission_mode = TRANS_MODE_2K;
-			break;
-		case TRANSMISSION_MODE_8K:
-			tune_args->transmission_mode = TRANS_MODE_8K;
-			break;
-		default:
-			tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
+	switch (params->u.ofdm.transmission_mode) {
+	case TRANSMISSION_MODE_2K:
+		tune_args->transmission_mode = TRANS_MODE_2K;
+		break;
+	case TRANSMISSION_MODE_8K:
+		tune_args->transmission_mode = TRANS_MODE_8K;
+		break;
+	default:
+		tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
 	}
 
-	switch(params->u.ofdm.hierarchy_information) {
-		case HIERARCHY_NONE:
-			tune_args->hierarchy = HIER_NONE;
-			break;
-		case HIERARCHY_1:
-			tune_args->hierarchy = HIER_ALPHA_1;
-			break;
-		case HIERARCHY_2:
-			tune_args->hierarchy = HIER_ALPHA_2;
-			break;
-		case HIERARCHY_4:
-			tune_args->hierarchy = HIER_ALPHA_4;
-			break;
-		case HIERARCHY_AUTO:
-			tune_args->hierarchy = HIER_UNKNOWN;
-			break;
+	switch (params->u.ofdm.hierarchy_information) {
+	case HIERARCHY_NONE:
+		tune_args->hierarchy = HIER_NONE;
+		break;
+	case HIERARCHY_1:
+		tune_args->hierarchy = HIER_ALPHA_1;
+		break;
+	case HIERARCHY_2:
+		tune_args->hierarchy = HIER_ALPHA_2;
+		break;
+	case HIERARCHY_4:
+		tune_args->hierarchy = HIER_ALPHA_4;
+		break;
+	case HIERARCHY_AUTO:
+		tune_args->hierarchy = HIER_UNKNOWN;
+		break;
 	}
 
 	dprintk(debug, "tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
@@ -623,23 +648,26 @@
 		if (params->u.ofdm.code_rate_LP == FEC_NONE) {
 			tune_args->hier_select = HIER_HIGH_PRIORITY;
 			tune_args->code_rate =
-				as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+			   as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
 		}
 
 		if (params->u.ofdm.code_rate_HP == FEC_NONE) {
 			tune_args->hier_select = HIER_LOW_PRIORITY;
 			tune_args->code_rate =
-				as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
+			   as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
 		}
 
 		dprintk(debug, "\thierarchy: 0x%02x  "
 				"selected: %s  code_rate_%s: 0x%02x\n",
 			tune_args->hierarchy,
-			tune_args->hier_select == HIER_HIGH_PRIORITY ? "HP" : "LP",
-			tune_args->hier_select == HIER_HIGH_PRIORITY ? "HP" : "LP",
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
 			tune_args->code_rate);
 	} else {
-		tune_args->code_rate = as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+		tune_args->code_rate =
+			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
 	}
 }
 #endif
