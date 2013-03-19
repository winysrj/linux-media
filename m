Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab3CSQuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 27/46] [media] siano: Convert it to report DVBv5 stats
Date: Tue, 19 Mar 2013 13:49:16 -0300
Message-Id: <1363711775-2120-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this frontend provides a nice set of statistics, the
way it is currently reported to userspace is poor. Worse than
that, instead of using quality indicators that range from 0 to 65535,
as expected by userspace, most indicators range from 0 to 100.

Improve it by using DVBv5 statistics API. The legacy indicators
are still reported using the very same old way, but they're now
using a proper range (0 to 65535 for quality indicadors; 0.1 dB
for SNR).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 826 ++++++++++++++++++++----------------
 1 file changed, 468 insertions(+), 358 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 04544f5..a5f5272 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -49,7 +49,10 @@ struct smsdvb_client_t {
 	struct completion       tune_done;
 	struct completion       stats_done;
 
-	struct SMSHOSTLIB_STATISTICS_DVB_EX_S sms_stat_dvb;
+	int last_per;
+
+	int legacy_ber, legacy_per;
+
 	int event_fe_state;
 	int event_unc_state;
 };
@@ -61,6 +64,82 @@ static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
+/*
+ * This struct is a mix of RECEPTION_STATISTICS_EX_S and SRVM_SIGNAL_STATUS_S.
+ * It was obtained by comparing the way it was filled by the original code
+ */
+struct RECEPTION_STATISTICS_PER_SLICES_S {
+	u32 result;
+	u32 snr;
+	s32 inBandPower;
+	u32 tsPackets;
+	u32 etsPackets;
+	u32 constellation;
+	u32 hpCode;
+	u32 tpsSrvIndLP;
+	u32 tpsSrvIndHP;
+	u32 cellId;
+	u32 reason;
+	u32 requestId;
+	u32 ModemState;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
+
+	u32 BER;		/* Post Viterbi BER [1E-5] */
+	s32 RSSI;		/* dBm */
+	s32 CarrierOffset;	/* Carrier Offset in bin/1024 */
+
+	u32 IsRfLocked;		/* 0 - not locked, 1 - locked */
+	u32 IsDemodLocked;	/* 0 - not locked, 1 - locked */
+
+	u32 BERBitCount;	/* Total number of SYNC bits. */
+	u32 BERErrorCount;	/* Number of erronous SYNC bits. */
+
+	s32 MRC_SNR;		/* dB */
+	s32 MRC_InBandPwr;	/* In band power in dBM */
+	s32 MRC_RSSI;		/* dBm */
+};
+
+u32 sms_to_bw_table[] = {
+	[BW_8_MHZ]		= 8000000,
+	[BW_7_MHZ]		= 7000000,
+	[BW_6_MHZ]		= 6000000,
+	[BW_5_MHZ]		= 5000000,
+	[BW_2_MHZ]		= 2000000,
+	[BW_1_5_MHZ]		= 1500000,
+	[BW_ISDBT_1SEG]		= 6000000,
+	[BW_ISDBT_3SEG]		= 6000000,
+	[BW_ISDBT_13SEG]	= 6000000,
+};
+
+u32 sms_to_guard_interval_table[] = {
+	[0] = GUARD_INTERVAL_1_32,
+	[1] = GUARD_INTERVAL_1_16,
+	[2] = GUARD_INTERVAL_1_8,
+	[3] = GUARD_INTERVAL_1_4,
+};
+
+u32 sms_to_code_rate_table[] = {
+	[0] = FEC_1_2,
+	[1] = FEC_2_3,
+	[2] = FEC_3_4,
+	[3] = FEC_5_6,
+	[4] = FEC_7_8,
+};
+
+
+u32 sms_to_hierarchy_table[] = {
+	[0] = HIERARCHY_NONE,
+	[1] = HIERARCHY_1,
+	[2] = HIERARCHY_2,
+	[3] = HIERARCHY_4,
+};
+
+u32 sms_to_modulation_table[] = {
+	[0] = QPSK,
+	[1] = QAM_16,
+	[2] = QAM_64,
+	[3] = DQPSK,
+};
+
 static void smsdvb_print_dvb_stats(struct SMSHOSTLIB_STATISTICS_ST *p)
 {
 	if (!(sms_dbg & 2))
@@ -244,93 +323,350 @@ static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 	}
 }
 
-static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
+static void smsdvb_stats_not_ready(struct dvb_frontend *fe)
+{
+	struct smsdvb_client_t *client =
+		container_of(fe, struct smsdvb_client_t, frontend);
+	struct smscore_device_t *coredev = client->coredev;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int i, n_layers;
+
+	switch (smscore_get_device_mode(coredev)) {
+	case DEVICE_MODE_ISDBT:
+	case DEVICE_MODE_ISDBT_BDA:
+		n_layers = 4;
+	default:
+		n_layers = 1;
+	}
+
+	/* Fill the length of each status counter */
+
+	/* Only global stats */
+	c->strength.len = 1;
+	c->cnr.len = 1;
+
+	/* Per-layer stats */
+	c->post_bit_error.len = n_layers;
+	c->post_bit_count.len = n_layers;
+	c->block_error.len = n_layers;
+	c->block_count.len = n_layers;
+
+	/* Signal is always available */
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = 0;
+
+	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
+	for (i = 0; i < n_layers; i++) {
+		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+}
+
+static inline int sms_to_mode(u32 mode)
+{
+	switch (mode) {
+	case 2:
+		return TRANSMISSION_MODE_2K;
+	case 4:
+		return TRANSMISSION_MODE_4K;
+	case 8:
+		return TRANSMISSION_MODE_8K;
+	}
+	return TRANSMISSION_MODE_AUTO;
+}
+
+static inline int sms_to_status(u32 is_demod_locked, u32 is_rf_locked)
+{
+	if (is_demod_locked)
+		return FE_HAS_SIGNAL  | FE_HAS_CARRIER | FE_HAS_VITERBI |
+		       FE_HAS_SYNC    | FE_HAS_LOCK;
+
+	if (is_rf_locked)
+		return FE_HAS_SIGNAL | FE_HAS_CARRIER;
+
+	return 0;
+}
+
+
+#define convert_from_table(value, table, defval) ({			\
+	u32 __ret;							\
+	if (value < ARRAY_SIZE(table))					\
+		__ret = table[value];					\
+	else								\
+		__ret = defval;						\
+	__ret;								\
+})
+
+#define sms_to_bw(value)						\
+	convert_from_table(value, sms_to_bw_table, 0);
+
+#define sms_to_guard_interval(value)					\
+	convert_from_table(value, sms_to_guard_interval_table,		\
+			   GUARD_INTERVAL_AUTO);
+
+#define sms_to_code_rate(value)						\
+	convert_from_table(value, sms_to_code_rate_table,		\
+			   FEC_NONE);
+
+#define sms_to_hierarchy(value)						\
+	convert_from_table(value, sms_to_hierarchy_table,		\
+			   FEC_NONE);
+
+#define sms_to_modulation(value)					\
+	convert_from_table(value, sms_to_modulation_table,		\
+			   FEC_NONE);
+
+static void smsdvb_update_tx_params(struct smsdvb_client_t *client,
+				    struct TRANSMISSION_STATISTICS_S *p)
+{
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	c->frequency = p->Frequency;
+	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
+	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
+	c->transmission_mode = sms_to_mode(p->TransmissionMode);
+	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
+	c->code_rate_HP = sms_to_code_rate(p->CodeRate);
+	c->code_rate_LP = sms_to_code_rate(p->LPCodeRate);
+	c->hierarchy = sms_to_hierarchy(p->Hierarchy);
+	c->modulation = sms_to_modulation(p->Constellation);
+}
+
+static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
+				     struct RECEPTION_STATISTICS_PER_SLICES_S *p)
+{
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+	c->modulation = sms_to_modulation(p->constellation);
+
+	/* TS PER */
+	client->last_per = c->block_error.stat[0].uvalue;
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_error.stat[0].uvalue += p->etsPackets;
+	c->block_count.stat[0].uvalue += p->etsPackets + p->tsPackets;
+
+	/* BER */
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_error.stat[0].uvalue += p->BERErrorCount;
+	c->post_bit_count.stat[0].uvalue += p->BERBitCount;
+
+	/* Legacy PER/BER */
+	client->legacy_per = (p->etsPackets * 65535) /
+			     (p->tsPackets + p->etsPackets);
+
+	/* Signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->RSSI * 1000;
+
+	/* Carrier to Noise ratio, in DB */
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].svalue = p->snr * 1000;
+}
+
+static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 				    struct SMSHOSTLIB_STATISTICS_ST *p)
 {
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
 	smsdvb_print_dvb_stats(p);
 
+	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+
+	/* Update DVB modulation parameters */
+	c->frequency = p->Frequency;
+	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
+	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
+	c->transmission_mode = sms_to_mode(p->TransmissionMode);
+	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
+	c->code_rate_HP = sms_to_code_rate(p->CodeRate);
+	c->code_rate_LP = sms_to_code_rate(p->LPCodeRate);
+	c->hierarchy = sms_to_hierarchy(p->Hierarchy);
+	c->modulation = sms_to_modulation(p->Constellation);
+
 	/* update reception data */
-	pReceptionData->IsRfLocked = p->IsRfLocked;
-	pReceptionData->IsDemodLocked = p->IsDemodLocked;
-	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
-	pReceptionData->ModemState = p->ModemState;
-	pReceptionData->SNR = p->SNR;
-	pReceptionData->BER = p->BER;
-	pReceptionData->BERErrorCount = p->BERErrorCount;
-	pReceptionData->BERBitCount = p->BERBitCount;
-	pReceptionData->RSSI = p->RSSI;
-	CORRECT_STAT_RSSI(*pReceptionData);
-	pReceptionData->InBandPwr = p->InBandPwr;
-	pReceptionData->CarrierOffset = p->CarrierOffset;
-	pReceptionData->ErrorTSPackets = p->ErrorTSPackets;
-	pReceptionData->TotalTSPackets = p->TotalTSPackets;
+	c->lna = p->IsExternalLNAOn ? 1 : 0;
+
+	/* Carrier to Noise ratio, in DB */
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].svalue = p->SNR * 1000;
+
+	/* Signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->RSSI * 1000;
+
+	/* TS PER */
+	client->last_per = c->block_error.stat[0].uvalue;
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_error.stat[0].uvalue += p->ErrorTSPackets;
+	c->block_count.stat[0].uvalue += p->TotalTSPackets;
+
+	/* BER */
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_error.stat[0].uvalue += p->BERErrorCount;
+	c->post_bit_count.stat[0].uvalue += p->BERBitCount;
+
+	/* Legacy PER/BER */
+	client->legacy_ber = p->BER;
 };
 
-static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
+static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 				      struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
 {
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
+	int i, n_layers;
+
 	smsdvb_print_isdb_stats(p);
 
+	/* Update ISDB-T transmission parameters */
+	c->frequency = p->Frequency;
+	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
+	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
+	c->transmission_mode = sms_to_mode(p->TransmissionMode);
+	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
+	c->isdbt_partial_reception = p->PartialReception ? 1 : 0;
+	n_layers = p->NumOfLayers;
+	if (n_layers < 1)
+		n_layers = 1;
+	if (n_layers > 3)
+		n_layers = 3;
+	c->isdbt_layer_enabled = 0;
+
 	/* update reception data */
-	pReceptionData->IsRfLocked = p->IsRfLocked;
-	pReceptionData->IsDemodLocked = p->IsDemodLocked;
-	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
-	pReceptionData->ModemState = p->ModemState;
-	pReceptionData->SNR = p->SNR;
-	pReceptionData->BER = p->LayerInfo[0].BER;
-	pReceptionData->BERErrorCount = p->LayerInfo[0].BERErrorCount;
-	pReceptionData->BERBitCount = p->LayerInfo[0].BERBitCount;
-	pReceptionData->RSSI = p->RSSI;
-	CORRECT_STAT_RSSI(*pReceptionData);
-	pReceptionData->InBandPwr = p->InBandPwr;
-
-	pReceptionData->CarrierOffset = p->CarrierOffset;
-	pReceptionData->ErrorTSPackets = p->LayerInfo[0].ErrorTSPackets;
-	pReceptionData->TotalTSPackets = p->LayerInfo[0].TotalTSPackets;
-	pReceptionData->MFER = 0;
+	c->lna = p->IsExternalLNAOn ? 1 : 0;
 
-	/* TS PER */
-	if ((p->LayerInfo[0].TotalTSPackets +
-		 p->LayerInfo[0].ErrorTSPackets) > 0) {
-		pReceptionData->TS_PER = (p->LayerInfo[0].ErrorTSPackets
-				* 100) / (p->LayerInfo[0].TotalTSPackets
-				+ p->LayerInfo[0].ErrorTSPackets);
-	} else {
-		pReceptionData->TS_PER = 0;
+	/* Carrier to Noise ratio, in DB */
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].svalue = p->SNR * 1000;
+
+	/* Signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->RSSI * 1000;
+
+	client->last_per = c->block_error.stat[0].uvalue;
+
+	/* Clears global counters, as the code below will sum it again */
+	c->block_error.stat[0].uvalue = 0;
+	c->block_count.stat[0].uvalue = 0;
+	c->post_bit_error.stat[0].uvalue = 0;
+	c->post_bit_count.stat[0].uvalue = 0;
+
+	for (i = 0; i < n_layers; i++) {
+		lr = &p->LayerInfo[i];
+
+		/* Update per-layer transmission parameters */
+		if (lr->NumberOfSegments > 0 && lr->NumberOfSegments < 13) {
+			c->isdbt_layer_enabled |= 1 << i;
+			c->layer[i].segment_count = lr->NumberOfSegments;
+		} else {
+			continue;
+		}
+		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
+
+		/* TS PER */
+		c->block_error.stat[i].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[i].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[i].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[i].uvalue += lr->TotalTSPackets;
+
+		/* Update global PER counter */
+		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
+
+		/* BER */
+		c->post_bit_error.stat[i].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[i].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[i].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[i].uvalue += lr->BERBitCount;
+
+		/* Update global BER counter */
+		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[0].uvalue += lr->BERBitCount;
 	}
 }
 
-static void smsdvb_update_isdbt_stats_ex(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
-				    struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
+					 struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
 {
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
+	int i, n_layers;
+
 	smsdvb_print_isdb_stats_ex(p);
 
+	/* Update ISDB-T transmission parameters */
+	c->frequency = p->Frequency;
+	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
+	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
+	c->transmission_mode = sms_to_mode(p->TransmissionMode);
+	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
+	c->isdbt_partial_reception = p->PartialReception ? 1 : 0;
+	n_layers = p->NumOfLayers;
+	if (n_layers < 1)
+		n_layers = 1;
+	if (n_layers > 3)
+		n_layers = 3;
+	c->isdbt_layer_enabled = 0;
+
 	/* update reception data */
-	pReceptionData->IsRfLocked = p->IsRfLocked;
-	pReceptionData->IsDemodLocked = p->IsDemodLocked;
-	pReceptionData->IsExternalLNAOn = p->IsExternalLNAOn;
-	pReceptionData->ModemState = p->ModemState;
-	pReceptionData->SNR = p->SNR;
-	pReceptionData->BER = p->LayerInfo[0].BER;
-	pReceptionData->BERErrorCount = p->LayerInfo[0].BERErrorCount;
-	pReceptionData->BERBitCount = p->LayerInfo[0].BERBitCount;
-	pReceptionData->RSSI = p->RSSI;
-	CORRECT_STAT_RSSI(*pReceptionData);
-	pReceptionData->InBandPwr = p->InBandPwr;
-
-	pReceptionData->CarrierOffset = p->CarrierOffset;
-	pReceptionData->ErrorTSPackets = p->LayerInfo[0].ErrorTSPackets;
-	pReceptionData->TotalTSPackets = p->LayerInfo[0].TotalTSPackets;
-	pReceptionData->MFER = 0;
+	c->lna = p->IsExternalLNAOn ? 1 : 0;
 
-	/* TS PER */
-	if ((p->LayerInfo[0].TotalTSPackets +
-		 p->LayerInfo[0].ErrorTSPackets) > 0) {
-		pReceptionData->TS_PER = (p->LayerInfo[0].ErrorTSPackets
-				* 100) / (p->LayerInfo[0].TotalTSPackets
-				+ p->LayerInfo[0].ErrorTSPackets);
-	} else {
-		pReceptionData->TS_PER = 0;
+	/* Carrier to Noise ratio, in DB */
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].svalue = p->SNR * 1000;
+
+	/* Signal Strength, in DBm */
+	c->strength.stat[0].uvalue = p->RSSI * 1000;
+
+	client->last_per = c->block_error.stat[0].uvalue;
+
+	/* Clears global counters, as the code below will sum it again */
+	c->block_error.stat[0].uvalue = 0;
+	c->block_count.stat[0].uvalue = 0;
+	c->post_bit_error.stat[0].uvalue = 0;
+	c->post_bit_count.stat[0].uvalue = 0;
+
+	for (i = 0; i < n_layers; i++) {
+		lr = &p->LayerInfo[i];
+
+		/* Update per-layer transmission parameters */
+		if (lr->NumberOfSegments > 0 && lr->NumberOfSegments < 13) {
+			c->isdbt_layer_enabled |= 1 << i;
+			c->layer[i].segment_count = lr->NumberOfSegments;
+		} else {
+			continue;
+		}
+		c->layer[i].modulation = sms_to_modulation(lr->Constellation);
+
+		/* TS PER */
+		c->block_error.stat[i].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[i].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[i].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[i].uvalue += lr->TotalTSPackets;
+
+		/* Update global PER counter */
+		c->block_error.stat[0].uvalue += lr->ErrorTSPackets;
+		c->block_count.stat[0].uvalue += lr->TotalTSPackets;
+
+		/* BER */
+		c->post_bit_error.stat[i].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[i].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[i].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[i].uvalue += lr->BERBitCount;
+
+		/* Update global BER counter */
+		c->post_bit_error.stat[0].uvalue += lr->BERErrorCount;
+		c->post_bit_count.stat[0].uvalue += lr->BERBitCount;
 	}
 }
 
@@ -339,13 +675,14 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 	struct smsdvb_client_t *client = (struct smsdvb_client_t *) context;
 	struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
 			+ cb->offset);
-	u32 *pMsgData = (u32 *) phdr + 1;
-	/*u32 MsgDataLen = phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
+	void *p = phdr + 1;
+	struct dvb_frontend *fe = &client->frontend;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	bool is_status_update = false;
 
 	switch (phdr->msgType) {
 	case MSG_SMS_DVBT_BDA_DATA:
-		dvb_dmx_swfilter(&client->demux, (u8 *)(phdr + 1),
+		dvb_dmx_swfilter(&client->demux, p,
 				 cb->size - sizeof(struct SmsMsgHdr_ST));
 		break;
 
@@ -355,166 +692,64 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		break;
 
 	case MSG_SMS_SIGNAL_DETECTED_IND:
-		client->sms_stat_dvb.TransmissionData.IsDemodLocked = true;
+		client->fe_status = FE_HAS_SIGNAL  | FE_HAS_CARRIER |
+				    FE_HAS_VITERBI | FE_HAS_SYNC    |
+				    FE_HAS_LOCK;
+
 		is_status_update = true;
 		break;
 
 	case MSG_SMS_NO_SIGNAL_IND:
-		client->sms_stat_dvb.TransmissionData.IsDemodLocked = false;
+		client->fe_status = 0;
+
 		is_status_update = true;
 		break;
 
-	case MSG_SMS_TRANSMISSION_IND: {
-
-		pMsgData++;
-		memcpy(&client->sms_stat_dvb.TransmissionData, pMsgData,
-				sizeof(struct TRANSMISSION_STATISTICS_S));
+	case MSG_SMS_TRANSMISSION_IND:
+		smsdvb_update_tx_params(client, p);
 
-#if 1
-		/*
-		 * FIXME: newer driver doesn't have those fixes
-		 * Are those firmware-specific stuff?
-		 */
-
-		/* Mo need to correct guard interval
-		 * (as opposed to old statistics message).
-		 */
-		CORRECT_STAT_BANDWIDTH(client->sms_stat_dvb.TransmissionData);
-		CORRECT_STAT_TRANSMISSON_MODE(
-				client->sms_stat_dvb.TransmissionData);
-#endif
 		is_status_update = true;
 		break;
-	}
-	case MSG_SMS_HO_PER_SLICES_IND: {
-		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
-				&client->sms_stat_dvb.ReceptionData;
-		struct SRVM_SIGNAL_STATUS_S SignalStatusData;
-
-		pMsgData++;
-		SignalStatusData.result = pMsgData[0];
-		SignalStatusData.snr = pMsgData[1];
-		SignalStatusData.inBandPower = (s32) pMsgData[2];
-		SignalStatusData.tsPackets = pMsgData[3];
-		SignalStatusData.etsPackets = pMsgData[4];
-		SignalStatusData.constellation = pMsgData[5];
-		SignalStatusData.hpCode = pMsgData[6];
-		SignalStatusData.tpsSrvIndLP = pMsgData[7] & 0x03;
-		SignalStatusData.tpsSrvIndHP = pMsgData[8] & 0x03;
-		SignalStatusData.cellId = pMsgData[9] & 0xFFFF;
-		SignalStatusData.reason = pMsgData[10];
-		SignalStatusData.requestId = pMsgData[11];
-		pReceptionData->IsRfLocked = pMsgData[16];
-		pReceptionData->IsDemodLocked = pMsgData[17];
-		pReceptionData->ModemState = pMsgData[12];
-		pReceptionData->SNR = pMsgData[1];
-		pReceptionData->BER = pMsgData[13];
-		pReceptionData->RSSI = pMsgData[14];
-		CORRECT_STAT_RSSI(client->sms_stat_dvb.ReceptionData);
-
-		pReceptionData->InBandPwr = (s32) pMsgData[2];
-		pReceptionData->CarrierOffset = (s32) pMsgData[15];
-		pReceptionData->TotalTSPackets = pMsgData[3];
-		pReceptionData->ErrorTSPackets = pMsgData[4];
 
-		/* TS PER */
-		if ((SignalStatusData.tsPackets + SignalStatusData.etsPackets)
-				> 0) {
-			pReceptionData->TS_PER = (SignalStatusData.etsPackets
-					* 100) / (SignalStatusData.tsPackets
-					+ SignalStatusData.etsPackets);
-		} else {
-			pReceptionData->TS_PER = 0;
-		}
-
-		pReceptionData->BERBitCount = pMsgData[18];
-		pReceptionData->BERErrorCount = pMsgData[19];
-
-		pReceptionData->MRC_SNR = pMsgData[20];
-		pReceptionData->MRC_InBandPwr = pMsgData[21];
-		pReceptionData->MRC_RSSI = pMsgData[22];
+	case MSG_SMS_HO_PER_SLICES_IND:
+		smsdvb_update_per_slices(client, p);
 
 		is_status_update = true;
 		break;
-	}
-	case MSG_SMS_GET_STATISTICS_RES: {
-		union {
-			struct SMSHOSTLIB_STATISTICS_ISDBT_ST  isdbt;
-			struct SmsMsgStatisticsInfo_ST         dvb;
-		} *p = (void *) (phdr + 1);
-		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
-				&client->sms_stat_dvb.ReceptionData;
-
-		is_status_update = true;
 
+	case MSG_SMS_GET_STATISTICS_RES:
 		switch (smscore_get_device_mode(client->coredev)) {
 		case DEVICE_MODE_ISDBT:
 		case DEVICE_MODE_ISDBT_BDA:
-			smsdvb_update_isdbt_stats(pReceptionData, &p->isdbt);
+			smsdvb_update_isdbt_stats(client, p);
 			break;
 		default:
-			smsdvb_update_dvb_stats(pReceptionData, &p->dvb.Stat);
-		}
-		if (!pReceptionData->IsDemodLocked) {
-			pReceptionData->SNR = 0;
-			pReceptionData->BER = 0;
-			pReceptionData->BERErrorCount = 0;
-			pReceptionData->InBandPwr = 0;
-			pReceptionData->ErrorTSPackets = 0;
+			smsdvb_update_dvb_stats(client, p);
 		}
 
+		is_status_update = true;
 		break;
-	}
-	case MSG_SMS_GET_STATISTICS_EX_RES: {
-		union {
-			struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST isdbt;
-			struct SMSHOSTLIB_STATISTICS_ST          dvb;
-		} *p = (void *) (phdr + 1);
-		struct RECEPTION_STATISTICS_EX_S *pReceptionData =
-				&client->sms_stat_dvb.ReceptionData;
 
+	/* Only for ISDB-T */
+	case MSG_SMS_GET_STATISTICS_EX_RES:
+		smsdvb_update_isdbt_stats_ex(client, p);
 		is_status_update = true;
-
-		switch (smscore_get_device_mode(client->coredev)) {
-		case DEVICE_MODE_ISDBT:
-		case DEVICE_MODE_ISDBT_BDA:
-			smsdvb_update_isdbt_stats_ex(pReceptionData, &p->isdbt);
-			break;
-		default:
-			smsdvb_update_dvb_stats(pReceptionData, &p->dvb);
-		}
-		if (!pReceptionData->IsDemodLocked) {
-			pReceptionData->SNR = 0;
-			pReceptionData->BER = 0;
-			pReceptionData->BERErrorCount = 0;
-			pReceptionData->InBandPwr = 0;
-			pReceptionData->ErrorTSPackets = 0;
-		}
-
 		break;
-	}
 	default:
 		sms_info("message not handled");
 	}
 	smscore_putbuffer(client->coredev, cb);
 
 	if (is_status_update) {
-		if (client->sms_stat_dvb.ReceptionData.IsDemodLocked) {
-			client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER
-				| FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+		if (client->fe_status == FE_HAS_LOCK) {
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_LOCK);
-			if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets
-					== 0)
+			if (client->last_per == c->block_error.stat[0].uvalue)
 				sms_board_dvb3_event(client, DVB3_EVENT_UNC_OK);
 			else
-				sms_board_dvb3_event(client,
-						DVB3_EVENT_UNC_ERR);
-
+				sms_board_dvb3_event(client, DVB3_EVENT_UNC_ERR);
 		} else {
-			if (client->sms_stat_dvb.ReceptionData.IsRfLocked)
-				client->fe_status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-			else
-				client->fe_status = 0;
+			smsdvb_stats_not_ready(fe);
+
 			sms_board_dvb3_event(client, DVB3_EVENT_FE_UNLOCK);
 		}
 		complete(&client->stats_done);
@@ -612,13 +847,20 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 	Msg.msgFlags = 0;
 	Msg.msgLength = sizeof(Msg);
 
-	/*
-	 * Check for firmware version, to avoid breaking for old cards
-	 */
-	if (client->coredev->fw_version >= 0x800)
-		Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
-	else
+	switch (smscore_get_device_mode(client->coredev)) {
+	case DEVICE_MODE_ISDBT:
+	case DEVICE_MODE_ISDBT_BDA:
+		/*
+		* Check for firmware version, to avoid breaking for old cards
+		*/
+		if (client->coredev->fw_version >= 0x800)
+			Msg.msgType = MSG_SMS_GET_STATISTICS_EX_REQ;
+		else
+			Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+		break;
+	default:
 		Msg.msgType = MSG_SMS_GET_STATISTICS_REQ;
+	}
 
 	rc = smsdvb_sendrequest_and_wait(client, &Msg, sizeof(Msg),
 					 &client->stats_done);
@@ -628,12 +870,12 @@ static int smsdvb_send_statistics_request(struct smsdvb_client_t *client)
 
 static inline int led_feedback(struct smsdvb_client_t *client)
 {
-	if (client->fe_status & FE_HAS_LOCK)
-		return sms_board_led_feedback(client->coredev,
-			(client->sms_stat_dvb.ReceptionData.BER
-			== 0) ? SMS_LED_HI : SMS_LED_LO);
-	else
+	if (!(client->fe_status & FE_HAS_LOCK))
 		return sms_board_led_feedback(client->coredev, SMS_LED_OFF);
+
+	return sms_board_led_feedback(client->coredev,
+				     (client->legacy_ber == 0) ?
+				     SMS_LED_HI : SMS_LED_LO);
 }
 
 static int smsdvb_read_status(struct dvb_frontend *fe, fe_status_t *stat)
@@ -655,11 +897,12 @@ static int smsdvb_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	int rc;
 	struct smsdvb_client_t *client;
+
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
 	rc = smsdvb_send_statistics_request(client);
 
-	*ber = client->sms_stat_dvb.ReceptionData.BER;
+	*ber = client->legacy_ber;
 
 	led_feedback(client);
 
@@ -668,21 +911,21 @@ static int smsdvb_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 static int smsdvb_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc;
-
+	s32 power = (s32) c->strength.stat[0].uvalue;
 	struct smsdvb_client_t *client;
+
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
 	rc = smsdvb_send_statistics_request(client);
 
-	if (client->sms_stat_dvb.ReceptionData.InBandPwr < -95)
+	if (power < -95)
 		*strength = 0;
-		else if (client->sms_stat_dvb.ReceptionData.InBandPwr > -29)
-			*strength = 100;
+		else if (power > -29)
+			*strength = 65535;
 		else
-			*strength =
-				(client->sms_stat_dvb.ReceptionData.InBandPwr
-				+ 95) * 3 / 2;
+			*strength = (power + 95) * 65535 / 66;
 
 	led_feedback(client);
 
@@ -691,13 +934,16 @@ static int smsdvb_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 static int smsdvb_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc;
 	struct smsdvb_client_t *client;
+
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
 	rc = smsdvb_send_statistics_request(client);
 
-	*snr = client->sms_stat_dvb.ReceptionData.SNR;
+	/* Preferred scale for SNR with legacy API: 0.1 dB */
+	*snr = c->cnr.stat[0].svalue / 100;
 
 	led_feedback(client);
 
@@ -707,12 +953,14 @@ static int smsdvb_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int smsdvb_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	int rc;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client;
+
 	client = container_of(fe, struct smsdvb_client_t, frontend);
 
 	rc = smsdvb_send_statistics_request(client);
 
-	*ucblocks = client->sms_stat_dvb.ReceptionData.ErrorTSPackets;
+	*ucblocks = c->block_error.stat[0].uvalue;
 
 	led_feedback(client);
 
@@ -743,7 +991,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 
 	int ret;
 
-	client->fe_status = FE_HAS_SIGNAL;
+	client->fe_status = 0;
 	client->event_fe_state = -1;
 	client->event_unc_state = -1;
 	fe->dtv_property_cache.delivery_system = SYS_DVBT;
@@ -871,6 +1119,8 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe)
 		container_of(fe, struct smsdvb_client_t, frontend);
 	struct smscore_device_t *coredev = client->coredev;
 
+	smsdvb_stats_not_ready(fe);
+
 	switch (smscore_get_device_mode(coredev)) {
 	case DEVICE_MODE_DVBT:
 	case DEVICE_MODE_DVBT_BDA:
@@ -883,150 +1133,10 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe)
 	}
 }
 
-static int smsdvb_get_frontend_dvb(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	struct TRANSMISSION_STATISTICS_S *td =
-		&client->sms_stat_dvb.TransmissionData;
-
-	fep->frequency = td->Frequency;
-
-	switch (td->Bandwidth) {
-	case 6:
-		fep->bandwidth_hz = 6000000;
-		break;
-	case 7:
-		fep->bandwidth_hz = 7000000;
-		break;
-	case 8:
-		fep->bandwidth_hz = 8000000;
-		break;
-	}
-
-	switch (td->TransmissionMode) {
-	case 2:
-		fep->transmission_mode = TRANSMISSION_MODE_2K;
-		break;
-	case 8:
-		fep->transmission_mode = TRANSMISSION_MODE_8K;
-	}
-
-	switch (td->GuardInterval) {
-	case 0:
-		fep->guard_interval = GUARD_INTERVAL_1_32;
-		break;
-	case 1:
-		fep->guard_interval = GUARD_INTERVAL_1_16;
-		break;
-	case 2:
-		fep->guard_interval = GUARD_INTERVAL_1_8;
-		break;
-	case 3:
-		fep->guard_interval = GUARD_INTERVAL_1_4;
-		break;
-	}
-
-	switch (td->CodeRate) {
-	case 0:
-		fep->code_rate_HP = FEC_1_2;
-		break;
-	case 1:
-		fep->code_rate_HP = FEC_2_3;
-		break;
-	case 2:
-		fep->code_rate_HP = FEC_3_4;
-		break;
-	case 3:
-		fep->code_rate_HP = FEC_5_6;
-		break;
-	case 4:
-		fep->code_rate_HP = FEC_7_8;
-		break;
-	}
-
-	switch (td->LPCodeRate) {
-	case 0:
-		fep->code_rate_LP = FEC_1_2;
-		break;
-	case 1:
-		fep->code_rate_LP = FEC_2_3;
-		break;
-	case 2:
-		fep->code_rate_LP = FEC_3_4;
-		break;
-	case 3:
-		fep->code_rate_LP = FEC_5_6;
-		break;
-	case 4:
-		fep->code_rate_LP = FEC_7_8;
-		break;
-	}
-
-	switch (td->Constellation) {
-	case 0:
-		fep->modulation = QPSK;
-		break;
-	case 1:
-		fep->modulation = QAM_16;
-		break;
-	case 2:
-		fep->modulation = QAM_64;
-		break;
-	}
-
-	switch (td->Hierarchy) {
-	case 0:
-		fep->hierarchy = HIERARCHY_NONE;
-		break;
-	case 1:
-		fep->hierarchy = HIERARCHY_1;
-		break;
-	case 2:
-		fep->hierarchy = HIERARCHY_2;
-		break;
-	case 3:
-		fep->hierarchy = HIERARCHY_4;
-		break;
-	}
-
-	fep->inversion = INVERSION_AUTO;
-
-	return 0;
-}
-
-static int smsdvb_get_frontend_isdb(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	struct TRANSMISSION_STATISTICS_S *td =
-		&client->sms_stat_dvb.TransmissionData;
-
-	fep->frequency = td->Frequency;
-	fep->bandwidth_hz = 6000000;
-	/* todo: retrive the other parameters */
-
-	return 0;
-}
-
+/* Nothing to do here, as stats are automatically updated */
 static int smsdvb_get_frontend(struct dvb_frontend *fe)
 {
-	struct smsdvb_client_t *client =
-		container_of(fe, struct smsdvb_client_t, frontend);
-	struct smscore_device_t *coredev = client->coredev;
-
-	switch (smscore_get_device_mode(coredev)) {
-	case DEVICE_MODE_DVBT:
-	case DEVICE_MODE_DVBT_BDA:
-		return smsdvb_get_frontend_dvb(fe);
-	case DEVICE_MODE_ISDBT:
-	case DEVICE_MODE_ISDBT_BDA:
-		return smsdvb_get_frontend_isdb(fe);
-	default:
-		return -EINVAL;
-	}
+	return 0;
 }
 
 static int smsdvb_init(struct dvb_frontend *fe)
-- 
1.8.1.4

