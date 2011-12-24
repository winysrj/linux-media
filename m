Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp50d018673
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 21/47] [media] budget-ci: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:26 -0200
Message-Id: <1324741852-26138-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-21-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttpci/budget-ci.c |   41 ++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index ab180f9..9807968 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -663,30 +663,31 @@ static int philips_su1278_tt_set_symbol_rate(struct dvb_frontend *fe, u32 srate,
 static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe,
 					   struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
 	u32 div;
 	u8 buf[4];
 	struct i2c_msg msg = {.addr = 0x60,.flags = 0,.buf = buf,.len = sizeof(buf) };
 
-	if ((params->frequency < 950000) || (params->frequency > 2150000))
+	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = (params->frequency + (500 - 1)) / 500;	// round correctly
+	div = (p->frequency + (500 - 1)) / 500;	// round correctly
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 2;
 	buf[3] = 0x20;
 
-	if (params->u.qpsk.symbol_rate < 4000000)
+	if (p->symbol_rate < 4000000)
 		buf[3] |= 1;
 
-	if (params->frequency < 1250000)
+	if (p->frequency < 1250000)
 		buf[3] |= 0;
-	else if (params->frequency < 1550000)
+	else if (p->frequency < 1550000)
 		buf[3] |= 0x40;
-	else if (params->frequency < 2050000)
+	else if (p->frequency < 2050000)
 		buf[3] |= 0x80;
-	else if (params->frequency < 2150000)
+	else if (p->frequency < 2150000)
 		buf[3] |= 0xC0;
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -743,6 +744,7 @@ static int philips_tdm1316l_tuner_init(struct dvb_frontend *fe)
 
 static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
 	u8 tuner_buf[4];
 	struct i2c_msg tuner_msg = {.addr = budget_ci->tuner_pll_address,.flags = 0,.buf = tuner_buf,.len = sizeof(tuner_buf) };
@@ -750,7 +752,7 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb
 	u8 band, cp, filter;
 
 	// determine charge pump
-	tuner_frequency = params->frequency + 36130000;
+	tuner_frequency = p->frequency + 36130000;
 	if (tuner_frequency < 87000000)
 		return -EINVAL;
 	else if (tuner_frequency < 130000000)
@@ -775,30 +777,30 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb
 		return -EINVAL;
 
 	// determine band
-	if (params->frequency < 49000000)
+	if (p->frequency < 49000000)
 		return -EINVAL;
-	else if (params->frequency < 159000000)
+	else if (p->frequency < 159000000)
 		band = 1;
-	else if (params->frequency < 444000000)
+	else if (p->frequency < 444000000)
 		band = 2;
-	else if (params->frequency < 861000000)
+	else if (p->frequency < 861000000)
 		band = 4;
 	else
 		return -EINVAL;
 
 	// setup PLL filter and TDA9889
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (p->bandwidth_hz) {
+	case 6000000:
 		tda1004x_writereg(fe, 0x0C, 0x14);
 		filter = 0;
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		tda1004x_writereg(fe, 0x0C, 0x80);
 		filter = 0;
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		tda1004x_writereg(fe, 0x0C, 0x14);
 		filter = 1;
 		break;
@@ -809,7 +811,7 @@ static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb
 
 	// calculate divisor
 	// ((36130000+((1000000/6)/2)) + Finput)/(1000000/6)
-	tuner_frequency = (((params->frequency / 1000) * 6) + 217280) / 1000;
+	tuner_frequency = (((p->frequency / 1000) * 6) + 217280) / 1000;
 
 	// setup tuner buffer
 	tuner_buf[0] = tuner_frequency >> 8;
@@ -858,6 +860,7 @@ static struct tda1004x_config philips_tdm1316l_config_invert = {
 
 static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_ci *budget_ci = (struct budget_ci *) fe->dvb->priv;
 	u8 tuner_buf[5];
 	struct i2c_msg tuner_msg = {.addr = budget_ci->tuner_pll_address,
@@ -868,7 +871,7 @@ static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struc
 	u8 band, cp, filter;
 
 	// determine charge pump
-	tuner_frequency = params->frequency + 36125000;
+	tuner_frequency = p->frequency + 36125000;
 	if (tuner_frequency < 87000000)
 		return -EINVAL;
 	else if (tuner_frequency < 130000000) {
@@ -905,7 +908,7 @@ static int dvbc_philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe, struc
 	filter = 1;
 
 	// calculate divisor
-	tuner_frequency = (params->frequency + 36125000 + (62500/2)) / 62500;
+	tuner_frequency = (p->frequency + 36125000 + (62500/2)) / 62500;
 
 	// setup tuner buffer
 	tuner_buf[0] = tuner_frequency >> 8;
-- 
1.7.8.352.g876a6

