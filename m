Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VXT026592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 71/94] [media] af9005-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:08 -0200
Message-Id: <1325257711-12274-72-git-send-email-mchehab@redhat.com>
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

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/af9005-fe.c |  101 +++++++++++++++++----------------
 1 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index e9addd8..6c1ef61 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -303,7 +303,7 @@ static int af9005_get_pre_vit_err_bit_count(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	/* read constellation mode */
+	/* read modulation mode */
 	ret =
 	    af9005_read_register_bits(state->d, xd_g_reg_tpsd_const,
 				      reg_tpsd_const_pos, reg_tpsd_const_len,
@@ -321,7 +321,7 @@ static int af9005_get_pre_vit_err_bit_count(struct dvb_frontend *fe,
 		bits = 6;
 		break;
 	default:
-		err("invalid constellation mode");
+		err("invalid modulation mode");
 		return -EINVAL;
 	}
 	*pre_bit_count = super_frame_count * 68 * 4 * x * bits;
@@ -533,13 +533,13 @@ static int af9005_fe_read_signal_strength(struct dvb_frontend *fe,
 
 static int af9005_fe_read_snr(struct dvb_frontend *fe, u16 * snr)
 {
-	/* the snr can be derived from the ber and the constellation
+	/* the snr can be derived from the ber and the modulation
 	   but I don't think this kind of complex calculations belong
 	   in the driver. I may be wrong.... */
 	return -ENOSYS;
 }
 
-static int af9005_fe_program_cfoe(struct dvb_usb_device *d, fe_bandwidth_t bw)
+static int af9005_fe_program_cfoe(struct dvb_usb_device *d, u32 bw)
 {
 	u8 temp0, temp1, temp2, temp3, buf[4];
 	int ret;
@@ -551,7 +551,7 @@ static int af9005_fe_program_cfoe(struct dvb_usb_device *d, fe_bandwidth_t bw)
 	u32 NS_coeff2_8k;
 
 	switch (bw) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		NS_coeff1_2048Nu = 0x2ADB6DC;
 		NS_coeff1_8191Nu = 0xAB7313;
 		NS_coeff1_8192Nu = 0xAB6DB7;
@@ -560,7 +560,7 @@ static int af9005_fe_program_cfoe(struct dvb_usb_device *d, fe_bandwidth_t bw)
 		NS_coeff2_8k = 0x55B6DC;
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		NS_coeff1_2048Nu = 0x3200001;
 		NS_coeff1_8191Nu = 0xC80640;
 		NS_coeff1_8192Nu = 0xC80000;
@@ -569,7 +569,7 @@ static int af9005_fe_program_cfoe(struct dvb_usb_device *d, fe_bandwidth_t bw)
 		NS_coeff2_8k = 0x640000;
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		NS_coeff1_2048Nu = 0x3924926;
 		NS_coeff1_8191Nu = 0xE4996E;
 		NS_coeff1_8192Nu = 0xE49249;
@@ -773,17 +773,17 @@ static int af9005_fe_program_cfoe(struct dvb_usb_device *d, fe_bandwidth_t bw)
 
 }
 
-static int af9005_fe_select_bw(struct dvb_usb_device *d, fe_bandwidth_t bw)
+static int af9005_fe_select_bw(struct dvb_usb_device *d, u32 bw)
 {
 	u8 temp;
 	switch (bw) {
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		temp = 0;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		temp = 1;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		temp = 2;
 		break;
 	default:
@@ -930,10 +930,10 @@ static int af9005_fe_init(struct dvb_frontend *fe)
 
 	/* init other parameters: program cfoe and select bandwidth */
 	deb_info("program cfoe\n");
-	if ((ret = af9005_fe_program_cfoe(state->d, BANDWIDTH_6_MHZ)))
+	if ((ret = af9005_fe_program_cfoe(state->d, 6000000)))
 		return ret;
-	/* set read-update bit for constellation */
-	deb_info("set read-update bit for constellation\n");
+	/* set read-update bit for modulation */
+	deb_info("set read-update bit for modulation\n");
 	if ((ret =
 	     af9005_write_register_bits(state->d, xd_p_reg_feq_read_update,
 					reg_feq_read_update_pos,
@@ -943,8 +943,8 @@ static int af9005_fe_init(struct dvb_frontend *fe)
 	/* sample code has a set MPEG TS code here
 	   but sniffing reveals that it doesn't do it */
 
-	/* set read-update bit to 1 for DCA constellation */
-	deb_info("set read-update bit 1 for DCA constellation\n");
+	/* set read-update bit to 1 for DCA modulation */
+	deb_info("set read-update bit 1 for DCA modulation\n");
 	if ((ret =
 	     af9005_write_register_bits(state->d, xd_p_reg_dca_read_update,
 					reg_dca_read_update_pos,
@@ -1099,15 +1099,15 @@ static int af9005_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 	return 0;
 }
 
-static int af9005_fe_set_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *fep)
+static int af9005_fe_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct af9005_fe_state *state = fe->demodulator_priv;
 	int ret;
 	u8 temp, temp0, temp1, temp2;
 
 	deb_info("af9005_fe_set_frontend freq %d bw %d\n", fep->frequency,
-		 fep->u.ofdm.bandwidth);
+		 fep->bandwidth_hz);
 	if (fe->ops.tuner_ops.release == NULL) {
 		err("Tuner not attached");
 		return -ENODEV;
@@ -1167,10 +1167,10 @@ static int af9005_fe_set_frontend(struct dvb_frontend *fe,
 
 	/* select bandwidth */
 	deb_info("select bandwidth");
-	ret = af9005_fe_select_bw(state->d, fep->u.ofdm.bandwidth);
+	ret = af9005_fe_select_bw(state->d, fep->bandwidth_hz);
 	if (ret)
 		return ret;
-	ret = af9005_fe_program_cfoe(state->d, fep->u.ofdm.bandwidth);
+	ret = af9005_fe_program_cfoe(state->d, fep->bandwidth_hz);
 	if (ret)
 		return ret;
 
@@ -1226,7 +1226,7 @@ static int af9005_fe_set_frontend(struct dvb_frontend *fe,
 }
 
 static int af9005_fe_get_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *fep)
 {
 	struct af9005_fe_state *state = fe->demodulator_priv;
 	int ret;
@@ -1243,15 +1243,15 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("CONSTELLATION ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.constellation = QPSK;
+		fep->modulation = QPSK;
 		deb_info("QPSK\n");
 		break;
 	case 1:
-		fep->u.ofdm.constellation = QAM_16;
+		fep->modulation = QAM_16;
 		deb_info("QAM_16\n");
 		break;
 	case 2:
-		fep->u.ofdm.constellation = QAM_64;
+		fep->modulation = QAM_64;
 		deb_info("QAM_64\n");
 		break;
 	}
@@ -1266,19 +1266,19 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("HIERARCHY ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+		fep->hierarchy = HIERARCHY_NONE;
 		deb_info("NONE\n");
 		break;
 	case 1:
-		fep->u.ofdm.hierarchy_information = HIERARCHY_1;
+		fep->hierarchy = HIERARCHY_1;
 		deb_info("1\n");
 		break;
 	case 2:
-		fep->u.ofdm.hierarchy_information = HIERARCHY_2;
+		fep->hierarchy = HIERARCHY_2;
 		deb_info("2\n");
 		break;
 	case 3:
-		fep->u.ofdm.hierarchy_information = HIERARCHY_4;
+		fep->hierarchy = HIERARCHY_4;
 		deb_info("4\n");
 		break;
 	}
@@ -1302,23 +1302,23 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("CODERATE HP ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.code_rate_HP = FEC_1_2;
+		fep->code_rate_HP = FEC_1_2;
 		deb_info("FEC_1_2\n");
 		break;
 	case 1:
-		fep->u.ofdm.code_rate_HP = FEC_2_3;
+		fep->code_rate_HP = FEC_2_3;
 		deb_info("FEC_2_3\n");
 		break;
 	case 2:
-		fep->u.ofdm.code_rate_HP = FEC_3_4;
+		fep->code_rate_HP = FEC_3_4;
 		deb_info("FEC_3_4\n");
 		break;
 	case 3:
-		fep->u.ofdm.code_rate_HP = FEC_5_6;
+		fep->code_rate_HP = FEC_5_6;
 		deb_info("FEC_5_6\n");
 		break;
 	case 4:
-		fep->u.ofdm.code_rate_HP = FEC_7_8;
+		fep->code_rate_HP = FEC_7_8;
 		deb_info("FEC_7_8\n");
 		break;
 	}
@@ -1333,23 +1333,23 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("CODERATE LP ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.code_rate_LP = FEC_1_2;
+		fep->code_rate_LP = FEC_1_2;
 		deb_info("FEC_1_2\n");
 		break;
 	case 1:
-		fep->u.ofdm.code_rate_LP = FEC_2_3;
+		fep->code_rate_LP = FEC_2_3;
 		deb_info("FEC_2_3\n");
 		break;
 	case 2:
-		fep->u.ofdm.code_rate_LP = FEC_3_4;
+		fep->code_rate_LP = FEC_3_4;
 		deb_info("FEC_3_4\n");
 		break;
 	case 3:
-		fep->u.ofdm.code_rate_LP = FEC_5_6;
+		fep->code_rate_LP = FEC_5_6;
 		deb_info("FEC_5_6\n");
 		break;
 	case 4:
-		fep->u.ofdm.code_rate_LP = FEC_7_8;
+		fep->code_rate_LP = FEC_7_8;
 		deb_info("FEC_7_8\n");
 		break;
 	}
@@ -1363,19 +1363,19 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("GUARD INTERVAL ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
+		fep->guard_interval = GUARD_INTERVAL_1_32;
 		deb_info("1_32\n");
 		break;
 	case 1:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_16;
+		fep->guard_interval = GUARD_INTERVAL_1_16;
 		deb_info("1_16\n");
 		break;
 	case 2:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_8;
+		fep->guard_interval = GUARD_INTERVAL_1_8;
 		deb_info("1_8\n");
 		break;
 	case 3:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_4;
+		fep->guard_interval = GUARD_INTERVAL_1_4;
 		deb_info("1_4\n");
 		break;
 	}
@@ -1390,11 +1390,11 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("TRANSMISSION MODE ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K;
+		fep->transmission_mode = TRANSMISSION_MODE_2K;
 		deb_info("2K\n");
 		break;
 	case 1:
-		fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
+		fep->transmission_mode = TRANSMISSION_MODE_8K;
 		deb_info("8K\n");
 		break;
 	}
@@ -1406,15 +1406,15 @@ static int af9005_fe_get_frontend(struct dvb_frontend *fe,
 	deb_info("BANDWIDTH ");
 	switch (temp) {
 	case 0:
-		fep->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+		fep->bandwidth_hz = 6000000;
 		deb_info("6\n");
 		break;
 	case 1:
-		fep->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+		fep->bandwidth_hz = 7000000;
 		deb_info("7\n");
 		break;
 	case 2:
-		fep->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+		fep->bandwidth_hz = 8000000;
 		deb_info("8\n");
 		break;
 	}
@@ -1454,6 +1454,7 @@ struct dvb_frontend *af9005_fe_attach(struct dvb_usb_device *d)
 }
 
 static struct dvb_frontend_ops af9005_fe_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "AF9005 USB DVB-T",
 		 .type = FE_OFDM,
@@ -1475,8 +1476,8 @@ static struct dvb_frontend_ops af9005_fe_ops = {
 	.sleep = af9005_fe_sleep,
 	.ts_bus_ctrl = af9005_ts_bus_ctrl,
 
-	.set_frontend_legacy = af9005_fe_set_frontend,
-	.get_frontend_legacy = af9005_fe_get_frontend,
+	.set_frontend = af9005_fe_set_frontend,
+	.get_frontend = af9005_fe_get_frontend,
 
 	.read_status = af9005_fe_read_status,
 	.read_ber = af9005_fe_read_ber,
-- 
1.7.8.352.g876a6

