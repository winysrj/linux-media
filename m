Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/10] [media] as102: Move ancillary routines to the beggining
Date: Tue, 12 Aug 2014 18:50:19 -0300
Message-Id: <1407880224-374-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid having function prototypes by moving some
ancillary routines to the beginning of the file.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_drv.c |  17 +-
 drivers/media/usb/as102/as102_drv.h |  15 +-
 drivers/media/usb/as102/as102_fe.c  | 542 +++++++++++++++++-------------------
 3 files changed, 274 insertions(+), 300 deletions(-)

diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
index d90a6651f03e..ff5bd2e5657a 100644
--- a/drivers/media/usb/as102/as102_drv.c
+++ b/drivers/media/usb/as102/as102_drv.c
@@ -216,7 +216,17 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 		goto edmxdinit;
 	}
 
-	ret = as102_dvb_register_fe(as102_dev, &as102_dev->dvb_fe);
+	/* Attach the frontend */
+	as102_dev->dvb_fe = dvb_attach(as102_attach, as102_dev->name,
+				       &as102_dev->bus_adap,
+				       as102_dev->elna_cfg);
+	if (!as102_dev->dvb_fe) {
+		dev_err(dev, "%s: as102_attach() failed: %d",
+		    __func__, ret);
+		goto efereg;
+	}
+
+	ret =  dvb_register_frontend(&as102_dev->dvb_adap, as102_dev->dvb_fe);
 	if (ret < 0) {
 		dev_err(dev, "%s: as102_dvb_register_frontend() failed: %d",
 		    __func__, ret);
@@ -252,7 +262,10 @@ edmxinit:
 void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 {
 	/* unregister as102 frontend */
-	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
+	dvb_unregister_frontend(as102_dev->dvb_fe);
+
+	/* detach frontend */
+	dvb_frontend_detach(as102_dev->dvb_fe);
 
 	/* unregister demux device */
 	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
index d6e08e23b366..1e2a76d3c517 100644
--- a/drivers/media/usb/as102/as102_drv.h
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -60,17 +60,10 @@ struct as102_dev_t {
 	uint8_t elna_cfg;
 
 	struct dvb_adapter dvb_adap;
-	struct dvb_frontend dvb_fe;
+	struct dvb_frontend *dvb_fe;
 	struct dvb_demux dvb_dmx;
 	struct dmxdev dvb_dmxdev;
 
-	/* demodulator stats */
-	struct as10x_demod_stats demod_stats;
-	/* signal strength */
-	uint16_t signal_strength;
-	/* bit error rate */
-	uint32_t ber;
-
 	/* timer handle to trig ts stream download */
 	struct timer_list timer_handle;
 
@@ -84,5 +77,7 @@ struct as102_dev_t {
 int as102_dvb_register(struct as102_dev_t *dev);
 void as102_dvb_unregister(struct as102_dev_t *dev);
 
-int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
-int as102_dvb_unregister_fe(struct dvb_frontend *dev);
+/* FIXME: move it to a separate header */
+struct dvb_frontend *as102_attach(const char *name,
+				  struct as10x_bus_adapter_t *bus_adap,
+				  uint8_t elna_cfg);
diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 041bb80aa4ba..7ec1c67ba119 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -17,298 +17,19 @@
 #include "as10x_types.h"
 #include "as10x_cmd.h"
 
-static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *dst,
-					 struct as10x_tps *src);
+struct as102_state {
+	struct dvb_frontend frontend;
+	struct as10x_demod_stats demod_stats;
+	struct as10x_bus_adapter_t *bus_adap;
 
-static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
-					  struct dtv_frontend_properties *src);
+	uint8_t elna_cfg;
 
-static int as102_fe_set_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tune_args tune_args = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	as102_fe_copy_tune_parameters(&tune_args, p);
-
-	/* send abilis command: SET_TUNE */
-	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
-	if (ret != 0)
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return (ret < 0) ? -EINVAL : 0;
-}
-
-static int as102_fe_get_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tps tps = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	/* send abilis command: GET_TPS */
-	ret = as10x_cmd_get_tps(&dev->bus_adap, &tps);
-
-	if (ret == 0)
-		as10x_fe_copy_tps_parameters(p, &tps);
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return (ret < 0) ? -EINVAL : 0;
-}
-
-static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
-			struct dvb_frontend_tune_settings *settings) {
-
-	settings->min_delay_ms = 1000;
-
-	return 0;
-}
-
-
-static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tune_status tstate = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	/* send abilis command: GET_TUNE_STATUS */
-	ret = as10x_cmd_get_tune_status(&dev->bus_adap, &tstate);
-	if (ret < 0) {
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"as10x_cmd_get_tune_status failed (err = %d)\n",
-			ret);
-		goto out;
-	}
-
-	dev->signal_strength  = tstate.signal_strength;
-	dev->ber  = tstate.BER;
-
-	switch (tstate.tune_state) {
-	case TUNE_STATUS_SIGNAL_DVB_OK:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		break;
-	case TUNE_STATUS_STREAM_DETECTED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
-		break;
-	case TUNE_STATUS_STREAM_TUNED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
-			FE_HAS_LOCK;
-		break;
-	default:
-		*status = TUNE_STATUS_NOT_TUNED;
-	}
-
-	dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
-			tstate.tune_state, tstate.signal_strength,
-			tstate.PER, tstate.BER);
-
-	if (*status & FE_HAS_LOCK) {
-		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
-			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
-			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
-		} else {
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"demod status: fc: 0x%08x, bad fc: 0x%08x, bytes corrected: 0x%08x , MER: 0x%04x\n",
-				dev->demod_stats.frame_count,
-				dev->demod_stats.bad_frame_count,
-				dev->demod_stats.bytes_fixed_by_rs,
-				dev->demod_stats.mer);
-		}
-	} else {
-		memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-	}
-
-out:
-	mutex_unlock(&dev->bus_adap.lock);
-	return ret;
-}
-
-/*
- * Note:
- * - in AS102 SNR=MER
- *   - the SNR will be returned in linear terms, i.e. not in dB
- *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
- *   - the accuracy is >2dB for SNR values outside this range
- */
-static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*snr = dev->demod_stats.mer;
-
-	return 0;
-}
-
-static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*ber = dev->ber;
-
-	return 0;
-}
-
-static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
-					 u16 *strength)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
-
-	return 0;
-}
-
-static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (dev->demod_stats.has_started)
-		*ucblocks = dev->demod_stats.bad_frame_count;
-	else
-		*ucblocks = 0;
-
-	return 0;
-}
-
-static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
-{
-	struct as102_dev_t *dev;
-	int ret;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	if (acquire) {
-		if (elna_enable)
-			as10x_cmd_set_context(&dev->bus_adap,
-					      CONTEXT_LNA, dev->elna_cfg);
-
-		ret = as10x_cmd_turn_on(&dev->bus_adap);
-	} else {
-		ret = as10x_cmd_turn_off(&dev->bus_adap);
-	}
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return ret;
-}
-
-static struct dvb_frontend_ops as102_fe_ops = {
-	.delsys = { SYS_DVBT },
-	.info = {
-		.name			= "Abilis AS102 DVB-T",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.caps = FE_CAN_INVERSION_AUTO
-			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
-			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
-			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
-			| FE_CAN_QAM_AUTO
-			| FE_CAN_TRANSMISSION_MODE_AUTO
-			| FE_CAN_GUARD_INTERVAL_AUTO
-			| FE_CAN_HIERARCHY_AUTO
-			| FE_CAN_RECOVER
-			| FE_CAN_MUTE_TS
-	},
-
-	.set_frontend		= as102_fe_set_frontend,
-	.get_frontend		= as102_fe_get_frontend,
-	.get_tune_settings	= as102_fe_get_tune_settings,
-
-	.read_status		= as102_fe_read_status,
-	.read_snr		= as102_fe_read_snr,
-	.read_ber		= as102_fe_read_ber,
-	.read_signal_strength	= as102_fe_read_signal_strength,
-	.read_ucblocks		= as102_fe_read_ucblocks,
-	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+	/* signal strength */
+	uint16_t signal_strength;
+	/* bit error rate */
+	uint32_t ber;
 };
 
-int as102_dvb_unregister_fe(struct dvb_frontend *fe)
-{
-	/* unregister frontend */
-	dvb_unregister_frontend(fe);
-
-	/* detach frontend */
-	dvb_frontend_detach(fe);
-
-	return 0;
-}
-
-int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
-			  struct dvb_frontend *dvb_fe)
-{
-	int errno;
-	struct dvb_adapter *dvb_adap;
-
-	if (as102_dev == NULL)
-		return -EINVAL;
-
-	/* extract dvb_adapter */
-	dvb_adap = &as102_dev->dvb_adap;
-
-	/* init frontend callback ops */
-	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
-	strncpy(dvb_fe->ops.info.name, as102_dev->name,
-		sizeof(dvb_fe->ops.info.name));
-
-	/* register dvb frontend */
-	errno = dvb_register_frontend(dvb_adap, dvb_fe);
-	if (errno == 0)
-		dvb_fe->tuner_priv = as102_dev;
-
-	return errno;
-}
-
 static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
 					 struct as10x_tps *as10x_tps)
 {
@@ -559,3 +280,248 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			as102_fe_get_code_rate(params->code_rate_HP);
 	}
 }
+
+static int as102_fe_set_frontend(struct dvb_frontend *fe)
+{
+	struct as102_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as10x_tune_args tune_args = { 0 };
+
+	if (mutex_lock_interruptible(&state->bus_adap->lock))
+		return -EBUSY;
+
+	as102_fe_copy_tune_parameters(&tune_args, p);
+
+	/* send abilis command: SET_TUNE */
+	ret =  as10x_cmd_set_tune(state->bus_adap, &tune_args);
+	if (ret != 0)
+		dev_dbg(&state->bus_adap->usb_dev->dev,
+			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
+
+	mutex_unlock(&state->bus_adap->lock);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_frontend(struct dvb_frontend *fe)
+{
+	struct as102_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as10x_tps tps = { 0 };
+
+	if (mutex_lock_interruptible(&state->bus_adap->lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TPS */
+	ret = as10x_cmd_get_tps(state->bus_adap, &tps);
+
+	if (ret == 0)
+		as10x_fe_copy_tps_parameters(p, &tps);
+
+	mutex_unlock(&state->bus_adap->lock);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
+			struct dvb_frontend_tune_settings *settings) {
+
+	settings->min_delay_ms = 1000;
+
+	return 0;
+}
+
+
+static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	int ret = 0;
+	struct as102_state *state = fe->demodulator_priv;
+	struct as10x_tune_status tstate = { 0 };
+
+	if (mutex_lock_interruptible(&state->bus_adap->lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = as10x_cmd_get_tune_status(state->bus_adap, &tstate);
+	if (ret < 0) {
+		dev_dbg(&state->bus_adap->usb_dev->dev,
+			"as10x_cmd_get_tune_status failed (err = %d)\n",
+			ret);
+		goto out;
+	}
+
+	state->signal_strength  = tstate.signal_strength;
+	state->ber  = tstate.BER;
+
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
+	}
+
+	dev_dbg(&state->bus_adap->usb_dev->dev,
+			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+			tstate.tune_state, tstate.signal_strength,
+			tstate.PER, tstate.BER);
+
+	if (*status & FE_HAS_LOCK) {
+		if (as10x_cmd_get_demod_stats(state->bus_adap,
+			(struct as10x_demod_stats *) &state->demod_stats) < 0) {
+			memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+			dev_dbg(&state->bus_adap->usb_dev->dev,
+				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
+		} else {
+			dev_dbg(&state->bus_adap->usb_dev->dev,
+				"demod status: fc: 0x%08x, bad fc: 0x%08x, bytes corrected: 0x%08x , MER: 0x%04x\n",
+				state->demod_stats.frame_count,
+				state->demod_stats.bad_frame_count,
+				state->demod_stats.bytes_fixed_by_rs,
+				state->demod_stats.mer);
+		}
+	} else {
+		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+	}
+
+out:
+	mutex_unlock(&state->bus_adap->lock);
+	return ret;
+}
+
+/*
+ * Note:
+ * - in AS102 SNR=MER
+ *   - the SNR will be returned in linear terms, i.e. not in dB
+ *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
+ *   - the accuracy is >2dB for SNR values outside this range
+ */
+static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*snr = state->demod_stats.mer;
+
+	return 0;
+}
+
+static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*ber = state->ber;
+
+	return 0;
+}
+
+static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*strength = (((0xffff * 400) * state->signal_strength + 41000) * 2);
+
+	return 0;
+}
+
+static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	if (state->demod_stats.has_started)
+		*ucblocks = state->demod_stats.bad_frame_count;
+	else
+		*ucblocks = 0;
+
+	return 0;
+}
+
+static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
+	struct as102_state *state = fe->demodulator_priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&state->bus_adap->lock))
+		return -EBUSY;
+
+	if (acquire) {
+		if (elna_enable)
+			as10x_cmd_set_context(state->bus_adap,
+					      CONTEXT_LNA, state->elna_cfg);
+
+		ret = as10x_cmd_turn_on(state->bus_adap);
+	} else {
+		ret = as10x_cmd_turn_off(state->bus_adap);
+	}
+
+	mutex_unlock(&state->bus_adap->lock);
+
+	return ret;
+}
+
+static struct dvb_frontend_ops as102_fe_ops = {
+	.delsys = { SYS_DVBT },
+	.info = {
+		.name			= "Abilis AS102 DVB-T",
+		.frequency_min		= 174000000,
+		.frequency_max		= 862000000,
+		.frequency_stepsize	= 166667,
+		.caps = FE_CAN_INVERSION_AUTO
+			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
+			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
+			| FE_CAN_QAM_AUTO
+			| FE_CAN_TRANSMISSION_MODE_AUTO
+			| FE_CAN_GUARD_INTERVAL_AUTO
+			| FE_CAN_HIERARCHY_AUTO
+			| FE_CAN_RECOVER
+			| FE_CAN_MUTE_TS
+	},
+
+	.set_frontend		= as102_fe_set_frontend,
+	.get_frontend		= as102_fe_get_frontend,
+	.get_tune_settings	= as102_fe_get_tune_settings,
+
+	.read_status		= as102_fe_read_status,
+	.read_snr		= as102_fe_read_snr,
+	.read_ber		= as102_fe_read_ber,
+	.read_signal_strength	= as102_fe_read_signal_strength,
+	.read_ucblocks		= as102_fe_read_ucblocks,
+	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+};
+
+struct dvb_frontend *as102_attach(const char *name,
+				  struct as10x_bus_adapter_t *bus_adap,
+				  uint8_t elna_cfg)
+{
+	struct as102_state *state;
+	struct dvb_frontend *fe;
+
+	state = kzalloc(sizeof(struct as102_state), GFP_KERNEL);
+	if (state == NULL) {
+		dev_err(&bus_adap->usb_dev->dev,
+			"%s: unable to allocate memory for state\n", __func__);
+		return NULL;
+	}
+	fe = &state->frontend;
+	fe->demodulator_priv = state;
+	state->bus_adap = bus_adap;
+	state->elna_cfg = elna_cfg;
+
+	/* init frontend callback ops */
+	memcpy(&fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(fe->ops.info.name, name, sizeof(fe->ops.info.name));
+
+	return fe;
+
+}
+EXPORT_SYMBOL_GPL(as102_attach);
-- 
1.9.3

