Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/15] drx-j: properly handle bit counts on stats
Date: Mon, 10 Mar 2014 08:59:05 -0300
Message-Id: <1394452747-5426-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of just assuming that the min resolution is 1E-6,
pass both bit error and bit counts for userspace to calculate
BER. The same applies for PER, for 8VSB. It is not clear how
to get the packet count for QAM. So, for now, don't expose PER
for QAM.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 89 ++++++++++++++++-------------
 1 file changed, 50 insertions(+), 39 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 6005e344f66c..9958277dd943 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -6199,7 +6199,8 @@ rw_error:
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
 */
-static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_errs)
+static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr,
+				   u16 *pck_errs, u16 *pck_count)
 {
 	int rc;
 	u16 data = 0;
@@ -6224,9 +6225,8 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_er
 		pr_err("error: period and/or prescale is zero!\n");
 		return -EIO;
 	}
-	*pck_errs =
-	    (u16) frac_times1e6(packet_errors_mant * (1 << packet_errors_exp),
-				 (period * prescale * 77));
+	*pck_errs = packet_errors_mant * (1 << packet_errors_exp);
+	*pck_count = period * prescale * 77;
 
 	return 0;
 rw_error:
@@ -6238,7 +6238,8 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
+static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr,
+				    u32 *ber, u32 *cnt)
 {
 	int rc;
 	u16 data = 0;
@@ -6259,19 +6260,17 @@ static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 	bit_errors_exp = (data & FEC_RS_NR_BIT_ERRORS_EXP__M)
 	    >> FEC_RS_NR_BIT_ERRORS_EXP__B;
 
+	*cnt = period * prescale * 207 * ((bit_errors_exp > 2) ? 1 : 8);
+
 	if (((bit_errors_mant << bit_errors_exp) >> 3) > 68700)
-		*ber = 26570;
+		*ber = (*cnt) * 26570;
 	else {
 		if (period * prescale == 0) {
 			pr_err("error: period and/or prescale is zero!\n");
 			return -EIO;
 		}
-		*ber =
-		    frac_times1e6(bit_errors_mant <<
-				 ((bit_errors_exp >
-				   2) ? (bit_errors_exp - 3) : bit_errors_exp),
-				 period * prescale * 207 *
-				 ((bit_errors_exp > 2) ? 1 : 8));
+		*ber = bit_errors_mant << ((bit_errors_exp > 2) ?
+			(bit_errors_exp - 3) : bit_errors_exp);
 	}
 
 	return 0;
@@ -6284,7 +6283,8 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static int get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
+static int get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr,
+				   u32 *ber, u32 *cnt)
 {
 	u16 data = 0;
 	int rc;
@@ -6292,15 +6292,12 @@ static int get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 	rc = drxj_dap_read_reg16(dev_addr, VSB_TOP_NR_SYM_ERRS__A, &data, 0);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
-		goto rw_error;
+		return -EIO;
 	}
-	*ber =
-	    frac_times1e6(data,
-			 VSB_TOP_MEASUREMENT_PERIOD * SYMBOLS_PER_SEGMENT);
+	*ber = data;
+	*cnt = VSB_TOP_MEASUREMENT_PERIOD * SYMBOLS_PER_SEGMENT;
 
 	return 0;
-rw_error:
-	return -EIO;
 }
 
 /**
@@ -9289,7 +9286,8 @@ rw_error:
 *
 */
 static int
-get_qamrs_err_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_errors)
+get_qamrs_err_count(struct i2c_device_addr *dev_addr,
+		    struct drxjrs_errors *rs_errors)
 {
 	int rc;
 	u16 nr_bit_errors = 0,
@@ -9474,6 +9472,8 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 	u16 qam_vd_period = 0;	/* Viterbi Measurement period */
 	u32 vd_bit_cnt = 0;	/* ViterbiDecoder Bit Count */
 
+	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	/* read the physical registers */
 	/*   Get the RS error data */
 	rc = get_qamrs_err_count(dev_addr, &measuredrs_errors);
@@ -9554,9 +9554,9 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 	    QAM_VD_NR_SYMBOL_ERRORS_FIXED_MANT__B;
 
 	if ((m << e) >> 3 > 549752)
-		qam_vd_ser = 500000;
+		qam_vd_ser = 500000 * vd_bit_cnt * ((e > 2) ? 1 : 8) / 8;
 	else
-		qam_vd_ser = frac_times1e6(m << ((e > 2) ? (e - 3) : e), vd_bit_cnt * ((e > 2) ? 1 : 8) / 8);
+		qam_vd_ser = m << ((e > 2) ? (e - 3) : e);
 
 	/* --------------------------------------- */
 	/* pre and post RedSolomon BER Calculation */
@@ -9578,9 +9578,9 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 
 	/*qam_pre_rs_ber = frac_times1e6( ber_cnt, rs_bit_cnt ); */
 	if (m > (rs_bit_cnt >> (e + 1)) || (rs_bit_cnt >> e) == 0)
-		qam_pre_rs_ber = 500000;
+		qam_pre_rs_ber = 500000 * rs_bit_cnt >> e;
 	else
-		qam_pre_rs_ber = frac_times1e6(m, rs_bit_cnt >> e);
+		qam_pre_rs_ber = m;
 
 	/* post RS BER = 1000000* (11.17 * FEC_OC_SNC_FAIL_COUNT__A) /  */
 	/*               (1504.0 * FEC_OC_SNC_FAIL_PERIOD__A)  */
@@ -9609,16 +9609,16 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 
 	p->cnr.stat[0].svalue = ((u16) qam_sl_mer) * 100;
-	if (ext_attr->standard == DRX_STANDARD_ITU_B)
+	if (ext_attr->standard == DRX_STANDARD_ITU_B) {
 		p->pre_bit_error.stat[0].uvalue += qam_vd_ser;
-	else
+		p->pre_bit_count.stat[0].uvalue += vd_bit_cnt * ((e > 2) ? 1 : 8) / 8;
+	} else {
 		p->pre_bit_error.stat[0].uvalue += qam_pre_rs_ber;
+		p->pre_bit_count.stat[0].uvalue += rs_bit_cnt >> e;
+	}
 
 	p->post_bit_error.stat[0].uvalue = qam_post_rs_ber;
 
-	p->pre_bit_count.stat[0].uvalue += 1000000;
-	p->post_bit_count.stat[0].uvalue += 1000000;
-
 	p->block_error.stat[0].uvalue += pkt_errs;
 
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
@@ -10661,8 +10661,8 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 	struct dtv_frontend_properties *p = &state->frontend.dtv_property_cache;
 	enum drx_standard standard = ext_attr->standard;
 	int rc;
-	u32 ber;
-	u16 pkt, mer, strength;
+	u32 ber, cnt;
+	u16 err, pkt, mer, strength;
 
 	rc = get_sig_strength(demod, &strength);
 	if (rc < 0) {
@@ -10684,23 +10684,26 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 #endif
 		if (lock_status != DRXJ_DEMOD_LOCK && lock_status != DRX_LOCKED) {
 			p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-			p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 			p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 			p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+			p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 			p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 			p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		} else {
-			rc = get_vsb_post_rs_pck_err(dev_addr, &pkt);
+			rc = get_vsb_post_rs_pck_err(dev_addr, &err, &pkt);
 			if (rc != 0) {
 				pr_err("error %d getting UCB\n", rc);
 				p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 			} else {
 				p->block_error.stat[0].scale = FE_SCALE_COUNTER;
-				p->block_error.stat[0].uvalue += pkt;
+				p->block_error.stat[0].uvalue += err;
+				p->block_count.stat[0].scale = FE_SCALE_COUNTER;
+				p->block_count.stat[0].uvalue += pkt;
 			}
 
 			/* PostViterbi is compute in steps of 10^(-6) */
-			rc = get_vs_bpre_viterbi_ber(dev_addr, &ber);
+			rc = get_vs_bpre_viterbi_ber(dev_addr, &ber, &cnt);
 			if (rc != 0) {
 				pr_err("error %d getting pre-ber\n", rc);
 				p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
@@ -10708,10 +10711,10 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 				p->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 				p->pre_bit_error.stat[0].uvalue += ber;
 				p->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-				p->pre_bit_count.stat[0].uvalue += 1000000;
+				p->pre_bit_count.stat[0].uvalue += cnt;
 			}
 
-			rc = get_vs_bpost_viterbi_ber(dev_addr, &ber);
+			rc = get_vs_bpost_viterbi_ber(dev_addr, &ber, &cnt);
 			if (rc != 0) {
 				pr_err("error %d getting post-ber\n", rc);
 				p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
@@ -10719,7 +10722,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 				p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 				p->post_bit_error.stat[0].uvalue += ber;
 				p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-				p->post_bit_count.stat[0].uvalue += 1000000;
+				p->post_bit_count.stat[0].uvalue += cnt;
 			}
 			rc = get_vsbmer(dev_addr, &mer);
 			if (rc != 0) {
@@ -11966,7 +11969,15 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 		return 0;
 	}
 
-	*ber = p->pre_bit_error.stat[0].uvalue;
+	if (!p->pre_bit_count.stat[0].uvalue) {
+		if (!p->pre_bit_error.stat[0].uvalue)
+			*ber = 0;
+		else
+			*ber = 1000000;
+	} else {
+		*ber = frac_times1e6(p->pre_bit_error.stat[0].uvalue,
+				     p->pre_bit_count.stat[0].uvalue);
+	}
 	return 0;
 }
 
-- 
1.8.5.3

