Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9SN8015896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 43/94] [media] sp887x: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:40 -0200
Message-Id: <1325257711-12274-44-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/sp887x.c |   49 +++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 33ec08a..4b28d6a 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -209,13 +209,13 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	return 0;
 };
 
-static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
+static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
 {
 	int known_parameters = 1;
 
 	*reg0xc05 = 0x000;
 
-	switch (p->u.ofdm.constellation) {
+	switch (p->modulation) {
 	case QPSK:
 		break;
 	case QAM_16:
@@ -231,7 +231,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		return -EINVAL;
 	};
 
-	switch (p->u.ofdm.hierarchy_information) {
+	switch (p->hierarchy) {
 	case HIERARCHY_NONE:
 		break;
 	case HIERARCHY_1:
@@ -250,7 +250,7 @@ static int configure_reg0xc05 (struct dvb_frontend_parameters *p, u16 *reg0xc05)
 		return -EINVAL;
 	};
 
-	switch (p->u.ofdm.code_rate_HP) {
+	switch (p->code_rate_HP) {
 	case FEC_1_2:
 		break;
 	case FEC_2_3:
@@ -303,17 +303,30 @@ static void divide (int n, int d, int *quotient_i, int *quotient_f)
 }
 
 static void sp887x_correct_offsets (struct sp887x_state* state,
-				    struct dvb_frontend_parameters *p,
+				    struct dtv_frontend_properties *p,
 				    int actual_freq)
 {
 	static const u32 srate_correction [] = { 1879617, 4544878, 8098561 };
-	int bw_index = p->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+	int bw_index;
 	int freq_offset = actual_freq - p->frequency;
 	int sysclock = 61003; //[kHz]
 	int ifreq = 36000000;
 	int freq;
 	int frequency_shift;
 
+	switch (p->bandwidth_hz) {
+	default:
+	case 8000000:
+		bw_index = 0;
+		break;
+	case 7000000:
+		bw_index = 1;
+		break;
+	case 6000000:
+		bw_index = 2;
+		break;
+	}
+
 	if (p->inversion == INVERSION_ON)
 		freq = ifreq - freq_offset;
 	else
@@ -333,17 +346,17 @@ static void sp887x_correct_offsets (struct sp887x_state* state,
 	sp887x_writereg(state, 0x30a, frequency_shift & 0xfff);
 }
 
-static int sp887x_setup_frontend_parameters (struct dvb_frontend* fe,
-					     struct dvb_frontend_parameters *p)
+static int sp887x_setup_frontend_parameters (struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct sp887x_state* state = fe->demodulator_priv;
 	unsigned actual_freq;
 	int err;
 	u16 val, reg0xc05;
 
-	if (p->u.ofdm.bandwidth != BANDWIDTH_8_MHZ &&
-	    p->u.ofdm.bandwidth != BANDWIDTH_7_MHZ &&
-	    p->u.ofdm.bandwidth != BANDWIDTH_6_MHZ)
+	if (p->bandwidth_hz != 8000000 &&
+	    p->bandwidth_hz != 7000000 &&
+	    p->bandwidth_hz != 6000000)
 		return -EINVAL;
 
 	if ((err = configure_reg0xc05(p, &reg0xc05)))
@@ -369,9 +382,9 @@ static int sp887x_setup_frontend_parameters (struct dvb_frontend* fe,
 	sp887x_correct_offsets(state, p, actual_freq);
 
 	/* filter for 6/7/8 Mhz channel */
-	if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
+	if (p->bandwidth_hz == 6000000)
 		val = 2;
-	else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
+	else if (p->bandwidth_hz == 7000000)
 		val = 1;
 	else
 		val = 0;
@@ -379,16 +392,16 @@ static int sp887x_setup_frontend_parameters (struct dvb_frontend* fe,
 	sp887x_writereg(state, 0x311, val);
 
 	/* scan order: 2k first = 0, 8k first = 1 */
-	if (p->u.ofdm.transmission_mode == TRANSMISSION_MODE_2K)
+	if (p->transmission_mode == TRANSMISSION_MODE_2K)
 		sp887x_writereg(state, 0x338, 0x000);
 	else
 		sp887x_writereg(state, 0x338, 0x001);
 
 	sp887x_writereg(state, 0xc05, reg0xc05);
 
-	if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
+	if (p->bandwidth_hz == 6000000)
 		val = 2 << 3;
-	else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
+	else if (p->bandwidth_hz == 7000000)
 		val = 3 << 3;
 	else
 		val = 0 << 3;
@@ -579,7 +592,7 @@ error:
 }
 
 static struct dvb_frontend_ops sp887x_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "Spase SP887x DVB-T",
 		.type = FE_OFDM,
@@ -598,7 +611,7 @@ static struct dvb_frontend_ops sp887x_ops = {
 	.sleep = sp887x_sleep,
 	.i2c_gate_ctrl = sp887x_i2c_gate_ctrl,
 
-	.set_frontend_legacy = sp887x_setup_frontend_parameters,
+	.set_frontend = sp887x_setup_frontend_parameters,
 	.get_tune_settings = sp887x_get_tune_settings,
 
 	.read_status = sp887x_read_status,
-- 
1.7.8.352.g876a6

