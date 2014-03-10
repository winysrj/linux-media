Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaCJL7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/15] drx-j: Prepare to use DVBv5 stats
Date: Mon, 10 Mar 2014 08:59:04 -0300
Message-Id: <1394452747-5426-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the stats internally to use DVBv5. For now, it will keep
showing everything via DVBv3 API only, as the .len value were
not initialized.

That allows testing if the new stats code didn't break anything.

A latter patch will add the final bits for the DVBv5 stats to
fully work.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |  24 --
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 321 +++++++++-------------
 2 files changed, 125 insertions(+), 220 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index e54eb35b52d9..9076bf21cc8a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1033,30 +1033,6 @@ struct drx_channel {
 
 /*========================================*/
 
-/**
-* \struct struct drx_sig_quality * Signal quality metrics.
-*
-* Used by DRX_CTRL_SIG_QUALITY.
-*/
-struct drx_sig_quality {
-	u16 MER;     /**< in steps of 0.1 dB                        */
-	u32 pre_viterbi_ber;
-		       /**< in steps of 1/scale_factor_ber              */
-	u32 post_viterbi_ber;
-		       /**< in steps of 1/scale_factor_ber              */
-	u32 scale_factor_ber;
-		       /**< scale factor for BER                      */
-	u16 packet_error;
-		       /**< number of packet errors                   */
-	u32 post_reed_solomon_ber;
-		       /**< in steps of 1/scale_factor_ber              */
-	u32 pre_ldpc_ber;
-		       /**< in steps of 1/scale_factor_ber              */
-	u32 aver_iter;/**< in steps of 0.01                          */
-	u16 indicator;
-		       /**< indicative signal quality low=0..100=high */
-};
-
 enum drx_cfg_sqi_speed {
 	DRX_SQI_SPEED_FAST = 0,
 	DRX_SQI_SPEED_MEDIUM,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index ca807b1fc67c..6005e344f66c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -8656,10 +8656,12 @@ rw_error:
 }
 
 /*============================================================================*/
-static int
-ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality);
+static int ctrl_get_qam_sig_quality(struct drx_demod_instance *demod);
+
 static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
 	int rc;
 	u32 iqm_fs_rate_ofs = 0;
 	u32 iqm_fs_rate_lo = 0;
@@ -8669,11 +8671,6 @@ static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *c
 	u16 fsm_state = 0;
 	int i = 0;
 	int ofsofs = 0;
-	struct i2c_device_addr *dev_addr = NULL;
-	struct drxj_data *ext_attr = NULL;
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Silence the controlling of lc, equ, and the acquisition state machine */
 	rc = drxj_dap_read_reg16(dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena, 0);
@@ -8858,8 +8855,10 @@ qam64auto(struct drx_demod_instance *demod,
 	  struct drx_channel *channel,
 	  s32 tuner_freq_offset, enum drx_lock_status *lock_status)
 {
-	struct drx_sig_quality sig_quality;
-	struct drxj_data *ext_attr = NULL;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	struct drx39xxj_state *state = dev_addr->user_data;
+	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
 	int rc;
 	u32 lck_state = NO_LOCK;
 	u32 start_time = 0;
@@ -8868,7 +8867,6 @@ qam64auto(struct drx_demod_instance *demod,
 	u16 data = 0;
 
 	/* external attributes for storing aquired channel constellation */
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
 	lck_state = NO_LOCK;
@@ -8882,12 +8880,12 @@ qam64auto(struct drx_demod_instance *demod,
 		switch (lck_state) {
 		case NO_LOCK:
 			if (*lock_status == DRXJ_DEMOD_LOCK) {
-				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
+				rc = ctrl_get_qam_sig_quality(demod);
 				if (rc != 0) {
 					pr_err("error %d\n", rc);
 					goto rw_error;
 				}
-				if (sig_quality.MER > 208) {
+				if (p->cnr.stat[0].svalue > 20800) {
 					lck_state = DEMOD_LOCKED;
 					/* some delay to see if fec_lock possible TODO find the right value */
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, waiting longer */
@@ -8951,12 +8949,12 @@ qam64auto(struct drx_demod_instance *demod,
 			if ((*lock_status == DRXJ_DEMOD_LOCK) &&	/* still demod_lock in 150ms */
 			    ((jiffies_to_msecs(jiffies) - d_locked_time) >
 			     DRXJ_QAM_FEC_LOCK_WAITTIME)) {
-				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
+				rc = ctrl_get_qam_sig_quality(demod);
 				if (rc != 0) {
 					pr_err("error %d\n", rc);
 					goto rw_error;
 				}
-				if (sig_quality.MER > 208) {
+				if (p->cnr.stat[0].svalue > 20800) {
 					rc = drxj_dap_read_reg16(demod->my_i2c_dev_addr, QAM_SY_TIMEOUT__A, &data, 0);
 					if (rc != 0) {
 						pr_err("error %d\n", rc);
@@ -9005,8 +9003,10 @@ qam256auto(struct drx_demod_instance *demod,
 	   struct drx_channel *channel,
 	   s32 tuner_freq_offset, enum drx_lock_status *lock_status)
 {
-	struct drx_sig_quality sig_quality;
-	struct drxj_data *ext_attr = NULL;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	struct drx39xxj_state *state = dev_addr->user_data;
+	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
 	int rc;
 	u32 lck_state = NO_LOCK;
 	u32 start_time = 0;
@@ -9014,7 +9014,6 @@ qam256auto(struct drx_demod_instance *demod,
 	u32 timeout_ofs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
 
 	/* external attributes for storing aquired channel constellation */
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
 	lck_state = NO_LOCK;
@@ -9027,12 +9026,12 @@ qam256auto(struct drx_demod_instance *demod,
 		switch (lck_state) {
 		case NO_LOCK:
 			if (*lock_status == DRXJ_DEMOD_LOCK) {
-				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
+				rc = ctrl_get_qam_sig_quality(demod);
 				if (rc != 0) {
 					pr_err("error %d\n", rc);
 					goto rw_error;
 				}
-				if (sig_quality.MER > 268) {
+				if (p->cnr.stat[0].svalue > 26800) {
 					lck_state = DEMOD_LOCKED;
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, wait longer */
 					d_locked_time = jiffies_to_msecs(jiffies);
@@ -9441,13 +9440,15 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 *  Pre-condition: Device must be started and in lock.
 */
 static int
-ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
+ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 {
-	struct i2c_device_addr *dev_addr = NULL;
-	struct drxj_data *ext_attr = NULL;
-	int rc;
-	enum drx_modulation constellation = DRX_CONSTELLATION_UNKNOWN;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
+	struct drx39xxj_state *state = dev_addr->user_data;
+	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
 	struct drxjrs_errors measuredrs_errors = { 0, 0, 0, 0, 0 };
+	enum drx_modulation constellation = ext_attr->constellation;
+	int rc;
 
 	u32 pre_bit_err_rs = 0;	/* pre RedSolomon Bit Error Rate */
 	u32 post_bit_err_rs = 0;	/* post RedSolomon Bit Error Rate */
@@ -9473,11 +9474,6 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 	u16 qam_vd_period = 0;	/* Viterbi Measurement period */
 	u32 vd_bit_cnt = 0;	/* ViterbiDecoder Bit Count */
 
-	/* get device basic information */
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
-	constellation = ext_attr->constellation;
-
 	/* read the physical registers */
 	/*   Get the RS error data */
 	rc = get_qamrs_err_count(dev_addr, &measuredrs_errors);
@@ -9605,26 +9601,43 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 		qam_post_rs_ber = e / m;
 
 	/* fill signal quality data structure */
-	sig_quality->MER = ((u16) qam_sl_mer);
+	p->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+
+	p->cnr.stat[0].svalue = ((u16) qam_sl_mer) * 100;
 	if (ext_attr->standard == DRX_STANDARD_ITU_B)
-		sig_quality->pre_viterbi_ber = qam_vd_ser;
+		p->pre_bit_error.stat[0].uvalue += qam_vd_ser;
 	else
-		sig_quality->pre_viterbi_ber = qam_pre_rs_ber;
-	sig_quality->post_viterbi_ber = qam_pre_rs_ber;
-	sig_quality->post_reed_solomon_ber = qam_post_rs_ber;
-	sig_quality->scale_factor_ber = ((u32) 1000000);
+		p->pre_bit_error.stat[0].uvalue += qam_pre_rs_ber;
+
+	p->post_bit_error.stat[0].uvalue = qam_post_rs_ber;
+
+	p->pre_bit_count.stat[0].uvalue += 1000000;
+	p->post_bit_count.stat[0].uvalue += 1000000;
+
+	p->block_error.stat[0].uvalue += pkt_errs;
+
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 	rc = get_acc_pkt_err(demod, &sig_quality->packet_error);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-#else
-	sig_quality->packet_error = ((u16) pkt_errs);
 #endif
 
 	return 0;
 rw_error:
+	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return -EIO;
 }
 
@@ -10627,28 +10640,6 @@ rw_error:
   ===== SigQuality() ==========================================================
   ===========================================================================*/
 
-static u16
-mer2indicator(u16 mer, u16 min_mer, u16 threshold_mer, u16 max_mer)
-{
-	u16 indicator = 0;
-
-	if (mer < min_mer) {
-		indicator = 0;
-	} else if (mer < threshold_mer) {
-		if ((threshold_mer - min_mer) != 0)
-			indicator = 25 * (mer - min_mer) / (threshold_mer - min_mer);
-	} else if (mer < max_mer) {
-		if ((max_mer - threshold_mer) != 0)
-			indicator = 25 + 75 * (mer - threshold_mer) / (max_mer - threshold_mer);
-		else
-			indicator = 25;
-	} else {
-		indicator = 100;
-	}
-
-	return indicator;
-}
-
 /**
 * \fn int ctrl_sig_quality()
 * \brief Retreive signal quality form device.
@@ -10661,130 +10652,94 @@ mer2indicator(u16 mer, u16 min_mer, u16 threshold_mer, u16 max_mer)
 
 */
 static int
-ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
+ctrl_sig_quality(struct drx_demod_instance *demod,
+		 enum drx_lock_status lock_status)
 {
-	struct i2c_device_addr *dev_addr = NULL;
-	struct drxj_data *ext_attr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
+	struct drx39xxj_state *state = dev_addr->user_data;
+	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
+	enum drx_standard standard = ext_attr->standard;
 	int rc;
-	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
-	u16 min_mer = 0;
-	u16 max_mer = 0;
-	u16 threshold_mer = 0;
-
-	/* Check arguments */
-	if ((sig_quality == NULL) || (demod == NULL))
-		return -EINVAL;
+	u32 ber;
+	u16 pkt, mer, strength;
 
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
-	standard = ext_attr->standard;
-
-	/* get basic information */
-	dev_addr = demod->my_i2c_dev_addr;
-	rc = ctrl_lock_status(demod, &lock_status);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+	rc = get_sig_strength(demod, &strength);
+	if (rc < 0) {
+		pr_err("error getting signal strength %d\n", rc);
+		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	} else {
+		p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		p->strength.stat[0].uvalue = 65535UL *  strength/ 100;
 	}
+
 	switch (standard) {
 	case DRX_STANDARD_8VSB:
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
-		rc = get_acc_pkt_err(demod, &sig_quality->packet_error);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-#else
-		rc = get_vsb_post_rs_pck_err(dev_addr, &sig_quality->packet_error);
+		rc = get_acc_pkt_err(demod, &pkt);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
 #endif
 		if (lock_status != DRXJ_DEMOD_LOCK && lock_status != DRX_LOCKED) {
-			sig_quality->post_viterbi_ber = 500000;
-			sig_quality->MER = 20;
-			sig_quality->pre_viterbi_ber = 0;
+			p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		} else {
+			rc = get_vsb_post_rs_pck_err(dev_addr, &pkt);
+			if (rc != 0) {
+				pr_err("error %d getting UCB\n", rc);
+				p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			} else {
+				p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+				p->block_error.stat[0].uvalue += pkt;
+			}
+
 			/* PostViterbi is compute in steps of 10^(-6) */
-			rc = get_vs_bpre_viterbi_ber(dev_addr, &sig_quality->pre_viterbi_ber);
+			rc = get_vs_bpre_viterbi_ber(dev_addr, &ber);
 			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
+				pr_err("error %d getting pre-ber\n", rc);
+				p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			} else {
+				p->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+				p->pre_bit_error.stat[0].uvalue += ber;
+				p->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+				p->pre_bit_count.stat[0].uvalue += 1000000;
 			}
-			rc = get_vs_bpost_viterbi_ber(dev_addr, &sig_quality->post_viterbi_ber);
+
+			rc = get_vs_bpost_viterbi_ber(dev_addr, &ber);
 			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
+				pr_err("error %d getting post-ber\n", rc);
+				p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			} else {
+				p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+				p->post_bit_error.stat[0].uvalue += ber;
+				p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+				p->post_bit_count.stat[0].uvalue += 1000000;
 			}
-			rc = get_vsbmer(dev_addr, &sig_quality->MER);
+			rc = get_vsbmer(dev_addr, &mer);
 			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
+				pr_err("error %d getting MER\n", rc);
+				p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			} else {
+				p->cnr.stat[0].svalue = mer * 100;
+				p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 			}
 		}
-		min_mer = 20;
-		max_mer = 360;
-		threshold_mer = 145;
-		sig_quality->post_reed_solomon_ber = 0;
-		sig_quality->scale_factor_ber = 1000000;
-		sig_quality->indicator =
-		    mer2indicator(sig_quality->MER, min_mer, threshold_mer,
-				  max_mer);
 		break;
 #ifndef DRXJ_VSB_ONLY
 	case DRX_STANDARD_ITU_A:
 	case DRX_STANDARD_ITU_B:
 	case DRX_STANDARD_ITU_C:
-		rc = ctrl_get_qam_sig_quality(demod, sig_quality);
+		rc = ctrl_get_qam_sig_quality(demod);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (lock_status != DRXJ_DEMOD_LOCK && lock_status != DRX_LOCKED) {
-			switch (ext_attr->constellation) {
-			case DRX_CONSTELLATION_QAM256:
-				sig_quality->MER = 210;
-				break;
-			case DRX_CONSTELLATION_QAM128:
-				sig_quality->MER = 180;
-				break;
-			case DRX_CONSTELLATION_QAM64:
-				sig_quality->MER = 150;
-				break;
-			case DRX_CONSTELLATION_QAM32:
-				sig_quality->MER = 120;
-				break;
-			case DRX_CONSTELLATION_QAM16:
-				sig_quality->MER = 90;
-				break;
-			default:
-				sig_quality->MER = 0;
-				return -EIO;
-			}
-		}
-
-		switch (ext_attr->constellation) {
-		case DRX_CONSTELLATION_QAM256:
-			min_mer = 210;
-			threshold_mer = 270;
-			max_mer = 380;
-			break;
-		case DRX_CONSTELLATION_QAM64:
-			min_mer = 150;
-			threshold_mer = 210;
-			max_mer = 380;
-			break;
-		case DRX_CONSTELLATION_QAM128:
-		case DRX_CONSTELLATION_QAM32:
-		case DRX_CONSTELLATION_QAM16:
-			break;
-		default:
-			return -EIO;
-		}
-		sig_quality->indicator =
-		    mer2indicator(sig_quality->MER, min_mer, threshold_mer,
-				  max_mer);
 		break;
 #endif
 	default:
@@ -11997,81 +11952,61 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	default:
 		pr_err("Lock state unknown %d\n", lock_status);
 	}
+	ctrl_sig_quality(demod, lock_status);
 
 	return 0;
 }
 
 static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	result = ctrl_sig_quality(demod, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get ber!\n");
+	if (p->pre_bit_error.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
 		*ber = 0;
 		return 0;
 	}
 
-	*ber = sig_quality.post_reed_solomon_ber;
+	*ber = p->pre_bit_error.stat[0].uvalue;
 	return 0;
 }
 
 static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 					 u16 *strength)
 {
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	result = ctrl_sig_quality(demod, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get signal strength!\n");
+	if (p->strength.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
 		*strength = 0;
 		return 0;
 	}
 
-	/* 1-100% scaled to 0-65535 */
-	*strength = (sig_quality.indicator * 65535 / 100);
+	*strength = p->strength.stat[0].uvalue;
 	return 0;
 }
 
 static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	result = ctrl_sig_quality(demod, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not read snr!\n");
+	if (p->cnr.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
 		*snr = 0;
 		return 0;
 	}
 
-	*snr = sig_quality.MER;
+	*snr = p->cnr.stat[0].svalue / 10;
 	return 0;
 }
 
-static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucb)
 {
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	result = ctrl_sig_quality(demod, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get uc blocks!\n");
-		*ucblocks = 0;
+	if (p->block_error.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
+		*ucb = 0;
 		return 0;
 	}
 
-	*ucblocks = sig_quality.packet_error;
+	*ucb = p->block_error.stat[0].uvalue;
 	return 0;
 }
 
@@ -12178,15 +12113,9 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 		pr_err("Failed to disable LNA!\n");
 		return 0;
 	}
-#ifdef DJH_DEBUG
-	for (i = 0; i < 2000; i++) {
-		fe_status_t status;
-		drx39xxj_read_status(fe, &status);
-		pr_debug("i=%d status=%d\n", i, status);
-		msleep(100);
-		i += 100;
-	}
-#endif
+
+	/* After set_frontend, except for strength, stats aren't available */
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
 
 	return 0;
 }
-- 
1.8.5.3

