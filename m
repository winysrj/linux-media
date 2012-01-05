Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BLI029473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 31/47] [media] mt2063: Fix analog/digital set params logic
Date: Wed,  4 Jan 2012 23:00:42 -0200
Message-Id: <1325725258-27934-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver were using a hacky way of setting analog and digital
frequencies. Remove the hack and properly add the tuner logic for
each supported type of standard.

I was tempted to add more standards there, like SECAM and to fix
radio (as stepping seems broken), but I opted to keep it as-is,
as tests would be needed to add additional standards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  390 +++++++++++++++++-----------------
 drivers/media/common/tuners/mt2063.h |    1 -
 2 files changed, 190 insertions(+), 201 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 5154b9d..4f634ad 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/videodev2.h>
 
 #include "mt2063.h"
 
@@ -201,21 +202,6 @@ enum MT2063_Register_Offsets {
 	MT2063_REG_END_REGS
 };
 
-enum MTTune_atv_standard {
-	MTTUNEA_UNKNOWN = 0,
-	MTTUNEA_PAL_B,
-	MTTUNEA_PAL_G,
-	MTTUNEA_PAL_I,
-	MTTUNEA_PAL_L,
-	MTTUNEA_PAL_MN,
-	MTTUNEA_PAL_DK,
-	MTTUNEA_DIGITAL,
-	MTTUNEA_FMRADIO,
-	MTTUNEA_DVBC,
-	MTTUNEA_DVBT
-};
-
-
 struct mt2063_state {
 	struct i2c_adapter *i2c;
 
@@ -224,7 +210,6 @@ struct mt2063_state {
 	struct dvb_frontend *frontend;
 	struct tuner_state status;
 
-	enum MTTune_atv_standard tv_type;
 	u32 frequency;
 	u32 srate;
 	u32 bandwidth;
@@ -258,9 +243,11 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 	msg.buf[0] = reg;
 	memcpy(msg.buf + 1, data, len);
 
-	fe->ops.i2c_gate_ctrl(fe, 1);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 	ret = i2c_transfer(state->i2c, &msg, 1);
-	fe->ops.i2c_gate_ctrl(fe, 0);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	if (ret < 0)
 		printk(KERN_ERR "%s error ret=%d\n", __func__, ret);
@@ -297,7 +284,8 @@ static u32 mt2063_read(struct mt2063_state *state,
 	struct dvb_frontend *fe = state->frontend;
 	u32 i = 0;
 
-	fe->ops.i2c_gate_ctrl(fe, 1);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	for (i = 0; i < cnt; i++) {
 		int ret;
@@ -320,7 +308,9 @@ static u32 mt2063_read(struct mt2063_state *state,
 		if (ret < 0)
 			break;
 	}
-	fe->ops.i2c_gate_ctrl(fe, 0);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
 	return status;
 }
 
@@ -997,7 +987,7 @@ static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
  *
  * This function returns 0, if no lock, 1 if locked and a value < 1 if error
  */
-unsigned int mt2063_lockStatus(struct mt2063_state *state)
+static unsigned int mt2063_lockStatus(struct mt2063_state *state)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
@@ -1030,7 +1020,6 @@ unsigned int mt2063_lockStatus(struct mt2063_state *state)
 	 */
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mt2063_lockStatus);
 
 /*
  * mt2063_set_dnc_output_enable()
@@ -1922,132 +1911,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	return status;
 }
 
-int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
-		   enum MTTune_atv_standard tv_type)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-	u32 status = 0;
-	s32 pict_car = 0;
-	s32 pict2chanb_vsb = 0;
-	s32 pict2chanb_snd = 0;
-	s32 pict2snd1 = 0;
-	s32 pict2snd2 = 0;
-	s32 ch_bw = 0;
-	s32 if_mid = 0;
-	s32 rcvr_mode = 0;
-
-	switch (tv_type) {
-	case MTTUNEA_PAL_B:{
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 5500000;
-			pict2snd2 = 5742000;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_PAL_G:{
-			pict_car = 38900000;
-			ch_bw = 7000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 5500000;
-			pict2snd2 = 0;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_PAL_I:{
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6000000;
-			pict2snd2 = 0;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_PAL_L:{
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6500000;
-			pict2snd2 = 0;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_PAL_MN:{
-			pict_car = 38900000;
-			ch_bw = 6000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 4500000;
-			pict2snd2 = 0;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_PAL_DK:{
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6500000;
-			pict2snd2 = 0;
-			rcvr_mode = 1;
-			break;
-		}
-	case MTTUNEA_DIGITAL:{
-			pict_car = 36125000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -(ch_bw / 2);
-			pict2snd1 = 0;
-			pict2snd2 = 0;
-			rcvr_mode = 2;
-			break;
-		}
-	case MTTUNEA_FMRADIO:{
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -(ch_bw / 2);
-			pict2snd1 = 0;
-			pict2snd2 = 0;
-			rcvr_mode = 4;
-			break;
-		}
-	case MTTUNEA_DVBC:{
-			pict_car = 36125000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -(ch_bw / 2);
-			pict2snd1 = 0;
-			pict2snd2 = 0;
-			rcvr_mode = MT2063_CABLE_QAM;
-			break;
-		}
-	case MTTUNEA_DVBT:{
-			pict_car = 36125000;
-			ch_bw = bw_in;
-			pict2chanb_vsb = -(ch_bw / 2);
-			pict2snd1 = 0;
-			pict2snd2 = 0;
-			rcvr_mode = MT2063_OFFAIR_COFDM;
-			break;
-		}
-	case MTTUNEA_UNKNOWN:
-		break;
-	default:
-		break;
-	}
-
-	pict2chanb_snd = pict2chanb_vsb - ch_bw;
-	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
-
-	state->AS_Data.f_LO2_Step = 125000;
-	state->AS_Data.f_out = if_mid;
-	state->AS_Data.f_out_bw = ch_bw + 750000;
-	status = MT2063_SetReceiverMode(state, rcvr_mode);
-	if (status < 0)
-		return status;
-
-	status = MT2063_Tune(state, (f_in + (pict2chanb_vsb + (ch_bw / 2))));
-
-	return status;
-}
-
 static const u8 MT2063B0_defaults[] = {
 	/* Reg,  Value */
 	0x19, 0x05,
@@ -2300,83 +2163,208 @@ static int mt2063_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_get_status(struct dvb_frontend *fe, u32 * status)
+static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 {
-	int rc = 0;
+	struct mt2063_state *state = fe->tuner_priv;
+	int status;
 
-	/* FIXME: add get tuner lock status */
+	*tuner_status = 0;
+	status = mt2063_lockStatus(state);
+	if (status < 0)
+		return status;
+	if (status)
+	    *tuner_status = TUNER_STATUS_LOCKED;
 
-	return rc;
+	return 0;
 }
 
-static int mt2063_get_state(struct dvb_frontend *fe,
-			    enum tuner_param param, struct tuner_state *tunstate)
+static int mt2063_release(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		/* get frequency */
-		break;
-	case DVBFE_TUNER_TUNERSTEP:
-		break;
-	case DVBFE_TUNER_IFFREQ:
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		/* get bandwidth */
-		break;
-	case DVBFE_TUNER_REFCLOCK:
-		tunstate->refclock = mt2063_lockStatus(state);
+	fe->tuner_priv = NULL;
+	kfree(state);
+
+	return 0;
+}
+
+static int mt2063_set_analog_params(struct dvb_frontend *fe,
+				    struct analog_parameters *params)
+{
+	struct mt2063_state *state = fe->tuner_priv;
+	s32 pict_car = 0;
+	s32 pict2chanb_vsb = 0;
+	s32 pict2chanb_snd = 0;
+	s32 pict2snd1 = 0;
+	s32 pict2snd2 = 0;
+	s32 ch_bw = 0;
+	s32 if_mid = 0;
+	s32 rcvr_mode = 0;
+	int status;
+
+	switch (params->mode) {
+	case V4L2_TUNER_RADIO:
+		pict_car = 38900000;
+		ch_bw = 8000000;
+		pict2chanb_vsb = -(ch_bw / 2);
+		pict2snd1 = 0;
+		pict2snd2 = 0;
+		rcvr_mode = MT2063_OFFAIR_ANALOG;
 		break;
-	default:
+	case V4L2_TUNER_ANALOG_TV:
+		rcvr_mode = MT2063_CABLE_ANALOG;
+		if (params->std & ~V4L2_STD_MN) {
+			pict_car = 38900000;
+			ch_bw = 6000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 4500000;
+			pict2snd2 = 0;
+		} else if (params->std & V4L2_STD_PAL_I) {
+			pict_car = 38900000;
+			ch_bw = 8000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 6000000;
+			pict2snd2 = 0;
+		} else if (params->std & V4L2_STD_PAL_B) {
+			pict_car = 38900000;
+			ch_bw = 8000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 5500000;
+			pict2snd2 = 5742000;
+		} else if (params->std & V4L2_STD_PAL_G) {
+			pict_car = 38900000;
+			ch_bw = 7000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 5500000;
+			pict2snd2 = 0;
+		} else if (params->std & V4L2_STD_PAL_DK) {
+			pict_car = 38900000;
+			ch_bw = 8000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 6500000;
+			pict2snd2 = 0;
+		} else {	/* PAL-L */
+			pict_car = 38900000;
+			ch_bw = 8000000;
+			pict2chanb_vsb = -1250000;
+			pict2snd1 = 6500000;
+			pict2snd2 = 0;
+		}
 		break;
 	}
+	pict2chanb_snd = pict2chanb_vsb - ch_bw;
+	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
+
+	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
+	state->AS_Data.f_out = if_mid;
+	state->AS_Data.f_out_bw = ch_bw + 750000;
+	status = MT2063_SetReceiverMode(state, rcvr_mode);
+	if (status < 0)
+		return status;
+
+	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
+	if (status < 0)
+		return status;
 
-	return (int)tunstate->refclock;
+	state->frequency = params->frequency;
+	return 0;
 }
 
-static int mt2063_set_state(struct dvb_frontend *fe,
-			    enum tuner_param param, struct tuner_state *tunstate)
+/*
+ * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
+ * So, the amount of the needed bandwith is given by:
+ * 	Bw = Symbol_rate * (1 + 0.15)
+ * As such, the maximum symbol rate supported by 6 MHz is given by:
+ *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
+ */
+#define MAX_SYMBOL_RATE_6MHz	5217391
+
+static int mt2063_set_params(struct dvb_frontend *fe,
+			     struct dvb_frontend_parameters *params)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	u32 status = 0;
-
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		/* set frequency */
-
-		status =
-		    mt2063_setTune(fe,
-				tunstate->frequency, tunstate->bandwidth,
-				state->tv_type);
+	int status;
+	s32 pict_car = 0;
+	s32 pict2chanb_vsb = 0;
+	s32 pict2chanb_snd = 0;
+	s32 pict2snd1 = 0;
+	s32 pict2snd2 = 0;
+	s32 ch_bw = 0;
+	s32 if_mid = 0;
+	s32 rcvr_mode = 0;
 
-		state->frequency = tunstate->frequency;
-		break;
-	case DVBFE_TUNER_TUNERSTEP:
-		break;
-	case DVBFE_TUNER_IFFREQ:
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		/* set bandwidth */
-		state->bandwidth = tunstate->bandwidth;
+	switch (fe->ops.info.type) {
+	case FE_OFDM:
+		switch (params->u.ofdm.bandwidth) {
+		case BANDWIDTH_6_MHZ:
+			ch_bw = 6000000;
+			break;
+		case BANDWIDTH_7_MHZ:
+			ch_bw = 7000000;
+			break;
+		case BANDWIDTH_8_MHZ:
+			ch_bw = 8000000;
+			break;
+		default:
+			return -EINVAL;
+		}
+		rcvr_mode = MT2063_OFFAIR_COFDM;
+		pict_car = 36125000;
+		pict2chanb_vsb = -(ch_bw / 2);
+		pict2snd1 = 0;
+		pict2snd2 = 0;
 		break;
-	case DVBFE_TUNER_REFCLOCK:
-
+	case FE_QAM:
+		/*
+		 * Using a 8MHz bandwidth sometimes fail
+		 * with 6MHz-spaced channels, due to inter-carrier
+		 * interference. So, it is better to narrow-down the filter
+		 */
+		if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz)
+			ch_bw = 6000000;
+		else
+			ch_bw = 8000000;
+		rcvr_mode = MT2063_CABLE_QAM;
+		pict_car = 36125000;
+		pict2snd1 = 0;
+		pict2snd2 = 0;
+		pict2chanb_vsb = -(ch_bw / 2);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
+	pict2chanb_snd = pict2chanb_vsb - ch_bw;
+	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
+
+	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
+	state->AS_Data.f_out = if_mid;
+	state->AS_Data.f_out_bw = ch_bw + 750000;
+	status = MT2063_SetReceiverMode(state, rcvr_mode);
+	if (status < 0)
+		return status;
+
+	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
+
+	if (status < 0)
+	    return status;
 
-	return (int)status;
+	state->frequency = params->frequency;
+	return 0;
 }
 
-static int mt2063_release(struct dvb_frontend *fe)
+static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
-	fe->tuner_priv = NULL;
-	kfree(state);
+	*freq = state->frequency;
+	return 0;
+}
+
+static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
+{
+	struct mt2063_state *state = fe->tuner_priv;
 
+	*bw = state->AS_Data.f_out_bw - 750000;
 	return 0;
 }
 
@@ -2391,9 +2379,11 @@ static struct dvb_tuner_ops mt2063_ops = {
 	.init = mt2063_init,
 	.sleep = MT2063_Sleep,
 	.get_status = mt2063_get_status,
-	.get_state = mt2063_get_state,
-	.set_state = mt2063_set_state,
-	.release = mt2063_release
+	.set_analog_params = mt2063_set_analog_params,
+	.set_params    = mt2063_set_params,
+	.get_frequency = mt2063_get_frequency,
+	.get_bandwidth = mt2063_get_bandwidth,
+	.release = mt2063_release,
 };
 
 struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index b2e3abf..62d0e8e 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -28,7 +28,6 @@ int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 				   enum MTTune_atv_standard tv_type);
 
 /* FIXME: Should use the standard DVB attachment interfaces */
-unsigned int mt2063_lockStatus(struct dvb_frontend *fe);
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
 unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
 
-- 
1.7.7.5

