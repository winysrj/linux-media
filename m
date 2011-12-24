Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5HA009948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 36/47] [media] dvb-ttusb-budget: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:41 -0200
Message-Id: <1324741852-26138-37-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-36-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
 <1324741852-26138-32-git-send-email-mchehab@redhat.com>
 <1324741852-26138-33-git-send-email-mchehab@redhat.com>
 <1324741852-26138-34-git-send-email-mchehab@redhat.com>
 <1324741852-26138-35-git-send-email-mchehab@redhat.com>
 <1324741852-26138-36-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   50 ++++++++++++--------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 420bb42..2379f38 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1019,17 +1019,18 @@ static u32 functionality(struct i2c_adapter *adapter)
 
 static int alps_tdmb7_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
 	u8 data[4];
 	struct i2c_msg msg = {.addr=0x61, .flags=0, .buf=data, .len=sizeof(data) };
 	u32 div;
 
-	div = (params->frequency + 36166667) / 166667;
+	div = (p->frequency + 36166667) / 166667;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = ((div >> 10) & 0x60) | 0x85;
-	data[3] = params->frequency < 592000000 ? 0x40 : 0x80;
+	data[3] = p->frequency < 592000000 ? 0x40 : 0x80;
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -1073,6 +1074,7 @@ static int philips_tdm1316l_tuner_init(struct dvb_frontend* fe)
 
 static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
 	u8 tuner_buf[4];
 	struct i2c_msg tuner_msg = {.addr=0x60, .flags=0, .buf=tuner_buf, .len=sizeof(tuner_buf) };
@@ -1080,7 +1082,7 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe, struct dvb
 	u8 band, cp, filter;
 
 	// determine charge pump
-	tuner_frequency = params->frequency + 36130000;
+	tuner_frequency = p->frequency + 36130000;
 	if (tuner_frequency < 87000000) return -EINVAL;
 	else if (tuner_frequency < 130000000) cp = 3;
 	else if (tuner_frequency < 160000000) cp = 5;
@@ -1094,25 +1096,29 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe, struct dvb
 	else return -EINVAL;
 
 	// determine band
-	if (params->frequency < 49000000) return -EINVAL;
-	else if (params->frequency < 159000000) band = 1;
-	else if (params->frequency < 444000000) band = 2;
-	else if (params->frequency < 861000000) band = 4;
+	if (p->frequency < 49000000)
+		return -EINVAL;
+	else if (p->frequency < 159000000)
+		band = 1;
+	else if (p->frequency < 444000000)
+		band = 2;
+	else if (p->frequency < 861000000)
+		band = 4;
 	else return -EINVAL;
 
 	// setup PLL filter
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (p->bandwidth_hz) {
+	case 6000000:
 		tda1004x_writereg(fe, 0x0C, 0);
 		filter = 0;
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		tda1004x_writereg(fe, 0x0C, 0);
 		filter = 0;
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		tda1004x_writereg(fe, 0x0C, 0xFF);
 		filter = 1;
 		break;
@@ -1123,7 +1129,7 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe, struct dvb
 
 	// calculate divisor
 	// ((36130000+((1000000/6)/2)) + Finput)/(1000000/6)
-	tuner_frequency = (((params->frequency / 1000) * 6) + 217280) / 1000;
+	tuner_frequency = (((p->frequency / 1000) * 6) + 217280) / 1000;
 
 	// setup tuner buffer
 	tuner_buf[0] = tuner_frequency >> 8;
@@ -1275,21 +1281,22 @@ static int alps_stv0299_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32
 
 static int philips_tsa5059_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
 	u8 buf[4];
 	u32 div;
 	struct i2c_msg msg = {.addr = 0x61,.flags = 0,.buf = buf,.len = sizeof(buf) };
 
-	if ((params->frequency < 950000) || (params->frequency > 2150000))
+	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = (params->frequency + (125 - 1)) / 125;	// round correctly
+	div = (p->frequency + (125 - 1)) / 125;	/* round correctly */
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
 	buf[3] = 0xC4;
 
-	if (params->frequency > 1530000)
+	if (p->frequency > 1530000)
 		buf[3] = 0xC0;
 
 	/* BSBE1 wants XCE bit set */
@@ -1318,12 +1325,13 @@ static struct stv0299_config alps_stv0299_config = {
 
 static int ttusb_novas_grundig_29504_491_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
 	u8 buf[4];
 	u32 div;
 	struct i2c_msg msg = {.addr = 0x61,.flags = 0,.buf = buf,.len = sizeof(buf) };
 
-	div = params->frequency / 125;
+	div = p->frequency / 125;
 
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
@@ -1345,17 +1353,18 @@ static struct tda8083_config ttusb_novas_grundig_29504_491_config = {
 
 static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x62, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = (params->frequency + 35937500 + 31250) / 62500;
+	div = (p->frequency + 35937500 + 31250) / 62500;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x85 | ((div >> 10) & 0x60);
-	data[3] = (params->frequency < 174000000 ? 0x88 : params->frequency < 470000000 ? 0x84 : 0x81);
+	data[3] = (p->frequency < 174000000 ? 0x88 : p->frequency < 470000000 ? 0x84 : 0x81);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -1389,6 +1398,7 @@ static u8 read_pwm(struct ttusb* ttusb)
 
 static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb *ttusb = (struct ttusb *) fe->dvb->priv;
 	u8 tuner_buf[5];
 	struct i2c_msg tuner_msg = {.addr = 0x60,
@@ -1399,7 +1409,7 @@ static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struc
 	u8 band, cp, filter;
 
 	// determine charge pump
-	tuner_frequency = params->frequency;
+	tuner_frequency = p->frequency;
 	if      (tuner_frequency <  87000000) {return -EINVAL;}
 	else if (tuner_frequency < 130000000) {cp = 3; band = 1;}
 	else if (tuner_frequency < 160000000) {cp = 5; band = 1;}
@@ -1417,7 +1427,7 @@ static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struc
 
 	// calculate divisor
 	// (Finput + Fif)/Fref; Fif = 36125000 Hz, Fref = 62500 Hz
-	tuner_frequency = ((params->frequency + 36125000) / 62500);
+	tuner_frequency = ((p->frequency + 36125000) / 62500);
 
 	// setup tuner buffer
 	tuner_buf[0] = tuner_frequency >> 8;
-- 
1.7.8.352.g876a6

