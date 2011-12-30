Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1L3PJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCHv2 79/94] [media] firedtv: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:16 -0200
Message-Id: <1325257711-12274-80-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/firewire/firedtv-avc.c |   95 +++++++++++++++---------------
 drivers/media/dvb/firewire/firedtv-fe.c  |   17 ++++--
 drivers/media/dvb/firewire/firedtv.h     |    4 +-
 3 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index 9debf0f..d1a1a13 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -335,7 +335,7 @@ static int add_pid_filter(struct firedtv *fdtv, u8 *operand)
  * (not supported by the AVC standard)
  */
 static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
-			      struct dvb_frontend_parameters *params)
+			      struct dtv_frontend_properties *p)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
@@ -349,15 +349,15 @@ static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
 	else
 		c->operand[3] = SFE_VENDOR_OPCODE_TUNE_QPSK;
 
-	c->operand[4] = (params->frequency >> 24) & 0xff;
-	c->operand[5] = (params->frequency >> 16) & 0xff;
-	c->operand[6] = (params->frequency >> 8) & 0xff;
-	c->operand[7] = params->frequency & 0xff;
+	c->operand[4] = (p->frequency >> 24) & 0xff;
+	c->operand[5] = (p->frequency >> 16) & 0xff;
+	c->operand[6] = (p->frequency >> 8) & 0xff;
+	c->operand[7] = p->frequency & 0xff;
 
-	c->operand[8] = ((params->u.qpsk.symbol_rate / 1000) >> 8) & 0xff;
-	c->operand[9] = (params->u.qpsk.symbol_rate / 1000) & 0xff;
+	c->operand[8] = ((p->symbol_rate / 1000) >> 8) & 0xff;
+	c->operand[9] = (p->symbol_rate / 1000) & 0xff;
 
-	switch (params->u.qpsk.fec_inner) {
+	switch (p->fec_inner) {
 	case FEC_1_2:	c->operand[10] = 0x1; break;
 	case FEC_2_3:	c->operand[10] = 0x2; break;
 	case FEC_3_4:	c->operand[10] = 0x3; break;
@@ -416,7 +416,7 @@ static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
 }
 
 static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
-			       struct dvb_frontend_parameters *params)
+			       struct dtv_frontend_properties *p)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
@@ -435,8 +435,8 @@ static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
 			| 1 << 4 /* Frequency */
 			| 1 << 3 /* Symbol_Rate */
 			| 0 << 2 /* FEC_outer */
-			| (params->u.qam.fec_inner  != FEC_AUTO ? 1 << 1 : 0)
-			| (params->u.qam.modulation != QAM_AUTO ? 1 << 0 : 0);
+			| (p->fec_inner  != FEC_AUTO ? 1 << 1 : 0)
+			| (p->modulation != QAM_AUTO ? 1 << 0 : 0);
 
 	/* multiplex_valid_flags, low byte */
 	c->operand[6] =   0 << 7 /* NetworkID */
@@ -447,15 +447,15 @@ static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
 	c->operand[9]  = 0x00;
 	c->operand[10] = 0x00;
 
-	c->operand[11] = (((params->frequency / 4000) >> 16) & 0xff) | (2 << 6);
-	c->operand[12] = ((params->frequency / 4000) >> 8) & 0xff;
-	c->operand[13] = (params->frequency / 4000) & 0xff;
-	c->operand[14] = ((params->u.qpsk.symbol_rate / 1000) >> 12) & 0xff;
-	c->operand[15] = ((params->u.qpsk.symbol_rate / 1000) >> 4) & 0xff;
-	c->operand[16] = ((params->u.qpsk.symbol_rate / 1000) << 4) & 0xf0;
+	c->operand[11] = (((p->frequency / 4000) >> 16) & 0xff) | (2 << 6);
+	c->operand[12] = ((p->frequency / 4000) >> 8) & 0xff;
+	c->operand[13] = (p->frequency / 4000) & 0xff;
+	c->operand[14] = ((p->symbol_rate / 1000) >> 12) & 0xff;
+	c->operand[15] = ((p->symbol_rate / 1000) >> 4) & 0xff;
+	c->operand[16] = ((p->symbol_rate / 1000) << 4) & 0xf0;
 	c->operand[17] = 0x00;
 
-	switch (params->u.qpsk.fec_inner) {
+	switch (p->fec_inner) {
 	case FEC_1_2:	c->operand[18] = 0x1; break;
 	case FEC_2_3:	c->operand[18] = 0x2; break;
 	case FEC_3_4:	c->operand[18] = 0x3; break;
@@ -467,7 +467,7 @@ static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
 	default:	c->operand[18] = 0x0;
 	}
 
-	switch (params->u.qam.modulation) {
+	switch (p->modulation) {
 	case QAM_16:	c->operand[19] = 0x08; break;
 	case QAM_32:	c->operand[19] = 0x10; break;
 	case QAM_64:	c->operand[19] = 0x18; break;
@@ -484,9 +484,8 @@ static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
 }
 
 static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
-			       struct dvb_frontend_parameters *params)
+			       struct dtv_frontend_properties *p)
 {
-	struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
 	c->opcode = AVC_OPCODE_DSD;
@@ -501,42 +500,42 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 	c->operand[5] =
 	      0 << 7 /* reserved */
 	    | 1 << 6 /* CenterFrequency */
-	    | (ofdm->bandwidth      != BANDWIDTH_AUTO        ? 1 << 5 : 0)
-	    | (ofdm->constellation  != QAM_AUTO              ? 1 << 4 : 0)
-	    | (ofdm->hierarchy_information != HIERARCHY_AUTO ? 1 << 3 : 0)
-	    | (ofdm->code_rate_HP   != FEC_AUTO              ? 1 << 2 : 0)
-	    | (ofdm->code_rate_LP   != FEC_AUTO              ? 1 << 1 : 0)
-	    | (ofdm->guard_interval != GUARD_INTERVAL_AUTO   ? 1 << 0 : 0);
+	    | (p->bandwidth_hz != 0        ? 1 << 5 : 0)
+	    | (p->modulation  != QAM_AUTO              ? 1 << 4 : 0)
+	    | (p->hierarchy != HIERARCHY_AUTO ? 1 << 3 : 0)
+	    | (p->code_rate_HP   != FEC_AUTO              ? 1 << 2 : 0)
+	    | (p->code_rate_LP   != FEC_AUTO              ? 1 << 1 : 0)
+	    | (p->guard_interval != GUARD_INTERVAL_AUTO   ? 1 << 0 : 0);
 
 	/* multiplex_valid_flags, low byte */
 	c->operand[6] =
 	      0 << 7 /* NetworkID */
-	    | (ofdm->transmission_mode != TRANSMISSION_MODE_AUTO ? 1 << 6 : 0)
+	    | (p->transmission_mode != TRANSMISSION_MODE_AUTO ? 1 << 6 : 0)
 	    | 0 << 5 /* OtherFrequencyFlag */
 	    | 0 << 0 /* reserved */ ;
 
 	c->operand[7]  = 0x0;
-	c->operand[8]  = (params->frequency / 10) >> 24;
-	c->operand[9]  = ((params->frequency / 10) >> 16) & 0xff;
-	c->operand[10] = ((params->frequency / 10) >>  8) & 0xff;
-	c->operand[11] = (params->frequency / 10) & 0xff;
-
-	switch (ofdm->bandwidth) {
-	case BANDWIDTH_7_MHZ:	c->operand[12] = 0x20; break;
-	case BANDWIDTH_8_MHZ:
-	case BANDWIDTH_6_MHZ:	/* not defined by AVC spec */
-	case BANDWIDTH_AUTO:
+	c->operand[8]  = (p->frequency / 10) >> 24;
+	c->operand[9]  = ((p->frequency / 10) >> 16) & 0xff;
+	c->operand[10] = ((p->frequency / 10) >>  8) & 0xff;
+	c->operand[11] = (p->frequency / 10) & 0xff;
+
+	switch (p->bandwidth_hz) {
+	case 7000000:	c->operand[12] = 0x20; break;
+	case 8000000:
+	case 6000000:	/* not defined by AVC spec */
+	case 0:
 	default:		c->operand[12] = 0x00;
 	}
 
-	switch (ofdm->constellation) {
+	switch (p->modulation) {
 	case QAM_16:	c->operand[13] = 1 << 6; break;
 	case QAM_64:	c->operand[13] = 2 << 6; break;
 	case QPSK:
 	default:	c->operand[13] = 0x00;
 	}
 
-	switch (ofdm->hierarchy_information) {
+	switch (p->hierarchy) {
 	case HIERARCHY_1:	c->operand[13] |= 1 << 3; break;
 	case HIERARCHY_2:	c->operand[13] |= 2 << 3; break;
 	case HIERARCHY_4:	c->operand[13] |= 3 << 3; break;
@@ -545,7 +544,7 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 	default:		break;
 	}
 
-	switch (ofdm->code_rate_HP) {
+	switch (p->code_rate_HP) {
 	case FEC_2_3:	c->operand[13] |= 1; break;
 	case FEC_3_4:	c->operand[13] |= 2; break;
 	case FEC_5_6:	c->operand[13] |= 3; break;
@@ -554,7 +553,7 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 	default:	break;
 	}
 
-	switch (ofdm->code_rate_LP) {
+	switch (p->code_rate_LP) {
 	case FEC_2_3:	c->operand[14] = 1 << 5; break;
 	case FEC_3_4:	c->operand[14] = 2 << 5; break;
 	case FEC_5_6:	c->operand[14] = 3 << 5; break;
@@ -563,7 +562,7 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 	default:	c->operand[14] = 0x00; break;
 	}
 
-	switch (ofdm->guard_interval) {
+	switch (p->guard_interval) {
 	case GUARD_INTERVAL_1_16:	c->operand[14] |= 1 << 3; break;
 	case GUARD_INTERVAL_1_8:	c->operand[14] |= 2 << 3; break;
 	case GUARD_INTERVAL_1_4:	c->operand[14] |= 3 << 3; break;
@@ -572,7 +571,7 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 	default:			break;
 	}
 
-	switch (ofdm->transmission_mode) {
+	switch (p->transmission_mode) {
 	case TRANSMISSION_MODE_8K:	c->operand[14] |= 1 << 1; break;
 	case TRANSMISSION_MODE_2K:
 	case TRANSMISSION_MODE_AUTO:
@@ -586,7 +585,7 @@ static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
 }
 
 int avc_tuner_dsd(struct firedtv *fdtv,
-		  struct dvb_frontend_parameters *params)
+		  struct dtv_frontend_properties *p)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int pos, ret;
@@ -598,9 +597,9 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
-	case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fdtv, params); break;
-	case FIREDTV_DVB_C: pos = avc_tuner_dsd_dvb_c(fdtv, params); break;
-	case FIREDTV_DVB_T: pos = avc_tuner_dsd_dvb_t(fdtv, params); break;
+	case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fdtv, p); break;
+	case FIREDTV_DVB_C: pos = avc_tuner_dsd_dvb_c(fdtv, p); break;
+	case FIREDTV_DVB_T: pos = avc_tuner_dsd_dvb_t(fdtv, p); break;
 	default:
 		BUG();
 	}
diff --git a/drivers/media/dvb/firewire/firedtv-fe.c b/drivers/media/dvb/firewire/firedtv-fe.c
index 1eb5ad3..e1705a9 100644
--- a/drivers/media/dvb/firewire/firedtv-fe.c
+++ b/drivers/media/dvb/firewire/firedtv-fe.c
@@ -141,16 +141,16 @@ static int fdtv_read_uncorrected_blocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return -EOPNOTSUPP;
 }
 
-static int fdtv_set_frontend(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+static int fdtv_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct firedtv *fdtv = fe->sec_priv;
 
-	return avc_tuner_dsd(fdtv, params);
+	return avc_tuner_dsd(fdtv, p);
 }
 
 static int fdtv_get_frontend(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+			     struct dtv_frontend_properties *params)
 {
 	return -EOPNOTSUPP;
 }
@@ -173,8 +173,8 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 	ops->init			= fdtv_dvb_init;
 	ops->sleep			= fdtv_sleep;
 
-	ops->set_frontend_legacy	= fdtv_set_frontend;
-	ops->get_frontend_legacy = fdtv_get_frontend;
+	ops->set_frontend		= fdtv_set_frontend;
+	ops->get_frontend		= fdtv_get_frontend;
 
 	ops->get_property		= fdtv_get_property;
 	ops->set_property		= fdtv_set_property;
@@ -192,6 +192,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
+		ops->delsys[0]		= SYS_DVBS;
 		fi->type		= FE_QPSK;
 
 		fi->frequency_min	= 950000;
@@ -211,6 +212,8 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 		break;
 
 	case FIREDTV_DVB_S2:
+		ops->delsys[0]		= SYS_DVBS;
+		ops->delsys[1]		= SYS_DVBS;
 		fi->type		= FE_QPSK;
 
 		fi->frequency_min	= 950000;
@@ -231,6 +234,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 		break;
 
 	case FIREDTV_DVB_C:
+		ops->delsys[0]		= SYS_DVBC_ANNEX_A;
 		fi->type		= FE_QAM;
 
 		fi->frequency_min	= 47000000;
@@ -249,6 +253,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 		break;
 
 	case FIREDTV_DVB_T:
+		ops->delsys[0]		= SYS_DVBT;
 		fi->type		= FE_OFDM;
 
 		fi->frequency_min	= 49000000;
diff --git a/drivers/media/dvb/firewire/firedtv.h b/drivers/media/dvb/firewire/firedtv.h
index bd00b04..4fdcd8c 100644
--- a/drivers/media/dvb/firewire/firedtv.h
+++ b/drivers/media/dvb/firewire/firedtv.h
@@ -112,8 +112,8 @@ struct firedtv {
 /* firedtv-avc.c */
 int avc_recv(struct firedtv *fdtv, void *data, size_t length);
 int avc_tuner_status(struct firedtv *fdtv, struct firedtv_tuner_status *stat);
-struct dvb_frontend_parameters;
-int avc_tuner_dsd(struct firedtv *fdtv, struct dvb_frontend_parameters *params);
+struct dtv_frontend_properties;
+int avc_tuner_dsd(struct firedtv *fdtv, struct dtv_frontend_properties *params);
 int avc_tuner_set_pids(struct firedtv *fdtv, unsigned char pidc, u16 pid[]);
 int avc_tuner_get_ts(struct firedtv *fdtv);
 int avc_identify_subunit(struct firedtv *fdtv);
-- 
1.7.8.352.g876a6

