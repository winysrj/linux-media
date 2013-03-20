Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab3CTOCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:22 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2KE2MmF001745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 10:02:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] [media] drxk: Add pre/post BER and PER/UCB stats
Date: Wed, 20 Mar 2013 11:02:13 -0300
Message-Id: <1363788136-14393-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
References: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original az6007 driver has the code to calculate such
stats. Add it to the driver, reporting them via DVBv5
stats API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 179 +++++++++++++++++++++++++++++---
 drivers/media/dvb-frontends/drxk_hard.h |   2 +
 drivers/media/dvb-frontends/drxk_map.h  |   3 +
 3 files changed, 172 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 0e40832..cd5084b 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -2655,11 +2655,6 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 		c = Log10Times100(SqrErrIQ);
 
 		iMER = a + b;
-		/* No negative MER, clip to zero */
-		if (iMER > c)
-			iMER -= c;
-		else
-			iMER = 0;
 	}
 	*pSignalToNoise = iMER;
 
@@ -6380,31 +6375,165 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	Start(state, 0, IF);
 
+	/* After set_frontend, stats aren't avaliable */
+	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
 
 	return 0;
 }
 
-static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
+static int drxk_get_stats(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct drxk_state *state = fe->demodulator_priv;
+	int status;
 	u32 stat;
-
-	dprintk(1, "\n");
+	u16 reg16;
+	u32 post_bit_count;
+	u32 post_bit_err_count;
+	u32 post_bit_error_scale;
+	u32 pre_bit_err_count;
+	u32 pre_bit_count;
+	u32 pkt_count;
+	u32 pkt_error_count;
+	s32 cnr, gain;
 
 	if (state->m_DrxkState == DRXK_NO_DEV)
 		return -ENODEV;
 	if (state->m_DrxkState == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
-	*status = 0;
+	/* get status */
+	state->fe_status = 0;
 	GetLockStatus(state, &stat, 0);
 	if (stat == MPEG_LOCK)
-		*status |= 0x1f;
+		state->fe_status |= 0x1f;
 	if (stat == FEC_LOCK)
-		*status |= 0x0f;
+		state->fe_status |= 0x0f;
 	if (stat == DEMOD_LOCK)
-		*status |= 0x07;
+		state->fe_status |= 0x07;
+
+	if (stat >= DEMOD_LOCK) {
+		GetSignalToNoise(state, &cnr);
+		c->cnr.stat[0].svalue = cnr * 10;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	if (stat < FEC_LOCK) {
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return 0;
+	}
+
+	/* Get post BER */
+
+	/* BER measurement is valid if at least FEC lock is achieved */
+
+	/* OFDM_EC_VD_REQ_SMB_CNT__A and/or OFDM_EC_VD_REQ_BIT_CNT can be written
+		to set nr of symbols or bits over which
+		to measure EC_VD_REG_ERR_BIT_CNT__A . See CtrlSetCfg(). */
+
+	/* Read registers for post/preViterbi BER calculation */
+	status = read16(state, OFDM_EC_VD_ERR_BIT_CNT__A, &reg16);
+	if (status < 0)
+		goto error;
+	pre_bit_err_count = reg16;
+
+	status = read16(state, OFDM_EC_VD_IN_BIT_CNT__A , &reg16);
+	if (status < 0)
+		goto error;
+	pre_bit_count = reg16;
+
+	/* Number of bit-errors */
+	status = read16(state, FEC_RS_NR_BIT_ERRORS__A, &reg16);
+	if (status < 0)
+		goto error;
+	post_bit_err_count = reg16;
+
+	status = read16(state, FEC_RS_MEASUREMENT_PRESCALE__A, &reg16);
+	if (status < 0)
+		goto error;
+	post_bit_error_scale = reg16;
+
+	status = read16(state, FEC_RS_MEASUREMENT_PERIOD__A, &reg16);
+	if (status < 0)
+		goto error;
+	pkt_count = reg16;
+
+	status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, &reg16);
+	if (status < 0)
+		goto error;
+	pkt_error_count = reg16;
+	write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
+
+	post_bit_err_count *= post_bit_error_scale;
+
+	post_bit_count = pkt_count * 204 * 8;
+
+	/* Store the results */
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_error.stat[0].uvalue += pkt_error_count;
+	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_count.stat[0].uvalue += pkt_count;
+
+	c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->pre_bit_error.stat[0].uvalue += pre_bit_err_count;
+	c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->pre_bit_count.stat[0].uvalue += pre_bit_count;
+
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_error.stat[0].uvalue += post_bit_err_count;
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].uvalue += post_bit_count;
+
+	/*
+	 * Read AGC gain
+	 *
+	 * IFgain = (IQM_AF_AGC_IF__A * 26.75) (nA)
+	 */
+	status = read16(state, IQM_AF_AGC_IF__A, &reg16);
+	if (status < 0) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return status;
+	}
+	gain = 2675 * (reg16 - DRXK_AGC_DAC_OFFSET) / 100;
+
+	/* FIXME: it makes sense to fix the scale here to dBm */
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = gain;
+
+error:
+	return status;
+}
+
+
+static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct drxk_state *state = fe->demodulator_priv;
+	int rc;
+
+	dprintk(1, "\n");
+
+	rc = drxk_get_stats(fe);
+	if (rc < 0)
+		return rc;
+
+	*status = state->fe_status;
+
 	return 0;
 }
 
@@ -6439,6 +6568,10 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 		return -EAGAIN;
 
 	GetSignalToNoise(state, &snr2);
+
+	/* No negative SNR, clip to zero */
+	if (snr2 < 0)
+		snr2 = 0;
 	*snr = snr2 & 0xffff;
 	return 0;
 }
@@ -6522,6 +6655,7 @@ static struct dvb_frontend_ops drxk_ops = {
 struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 				 struct i2c_adapter *i2c)
 {
+	struct dtv_frontend_properties *p;
 	struct drxk_state *state = NULL;
 	u8 adr = config->adr;
 	int status;
@@ -6602,6 +6736,27 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	} else if (init_drxk(state) < 0)
 		goto error;
 
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
 	printk(KERN_INFO "drxk: frontend initialized.\n");
 	return &state->frontend;
 
diff --git a/drivers/media/dvb-frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
index d18a896..b8424f1 100644
--- a/drivers/media/dvb-frontends/drxk_hard.h
+++ b/drivers/media/dvb-frontends/drxk_hard.h
@@ -345,6 +345,8 @@ struct drxk_state {
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
 
+	fe_status_t fe_status;
+
 	/* Firmware */
 	const char *microcode_name;
 	struct completion fw_wait_load;
diff --git a/drivers/media/dvb-frontends/drxk_map.h b/drivers/media/dvb-frontends/drxk_map.h
index 23e16c1..761613f 100644
--- a/drivers/media/dvb-frontends/drxk_map.h
+++ b/drivers/media/dvb-frontends/drxk_map.h
@@ -10,6 +10,7 @@
 #define    FEC_RS_COMM_EXEC_STOP                                           0x0
 #define  FEC_RS_MEASUREMENT_PERIOD__A                                      0x1C30012
 #define  FEC_RS_MEASUREMENT_PRESCALE__A                                    0x1C30013
+#define FEC_RS_NR_BIT_ERRORS__A                                            0x1C30014
 #define  FEC_OC_MODE__A                                                    0x1C40011
 #define    FEC_OC_MODE_PARITY__M                                           0x1
 #define  FEC_OC_DTO_MODE__A                                                0x1C40014
@@ -129,6 +130,8 @@
 #define  OFDM_EC_SB_PRIOR__A                                               0x3410013
 #define    OFDM_EC_SB_PRIOR_HI                                             0x0
 #define    OFDM_EC_SB_PRIOR_LO                                             0x1
+#define OFDM_EC_VD_ERR_BIT_CNT__A                                          0x3420017
+#define OFDM_EC_VD_IN_BIT_CNT__A                                           0x3420018
 #define  OFDM_EQ_TOP_TD_TPS_CONST__A                                       0x3010054
 #define  OFDM_EQ_TOP_TD_TPS_CONST__M                                       0x3
 #define    OFDM_EQ_TOP_TD_TPS_CONST_64QAM                                  0x2
-- 
1.8.1.4

