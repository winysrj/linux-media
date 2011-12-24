Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab1LXPvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:11 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFpBO4030870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 44/47] [media] budget-av: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:49 -0200
Message-Id: <1324741852-26138-45-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-44-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-37-git-send-email-mchehab@redhat.com>
 <1324741852-26138-38-git-send-email-mchehab@redhat.com>
 <1324741852-26138-39-git-send-email-mchehab@redhat.com>
 <1324741852-26138-40-git-send-email-mchehab@redhat.com>
 <1324741852-26138-41-git-send-email-mchehab@redhat.com>
 <1324741852-26138-42-git-send-email-mchehab@redhat.com>
 <1324741852-26138-43-git-send-email-mchehab@redhat.com>
 <1324741852-26138-44-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttpci/budget-av.c |   43 ++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 78d32f7..ef03777 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -505,30 +505,31 @@ static int philips_su1278_ty_ci_set_symbol_rate(struct dvb_frontend *fe, u32 sra
 static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe,
 						 struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
 	u8 buf[4];
 	struct budget *budget = (struct budget *) fe->dvb->priv;
 	struct i2c_msg msg = {.addr = 0x61,.flags = 0,.buf = buf,.len = sizeof(buf) };
 
-	if ((params->frequency < 950000) || (params->frequency > 2150000))
+	if ((c->frequency < 950000) || (c->frequency > 2150000))
 		return -EINVAL;
 
-	div = (params->frequency + (125 - 1)) / 125;	// round correctly
+	div = (c->frequency + (125 - 1)) / 125;	// round correctly
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
 	buf[3] = 0x20;
 
-	if (params->u.qpsk.symbol_rate < 4000000)
+	if (c->symbol_rate < 4000000)
 		buf[3] |= 1;
 
-	if (params->frequency < 1250000)
+	if (c->frequency < 1250000)
 		buf[3] |= 0;
-	else if (params->frequency < 1550000)
+	else if (c->frequency < 1550000)
 		buf[3] |= 0x40;
-	else if (params->frequency < 2050000)
+	else if (c->frequency < 2050000)
 		buf[3] |= 0x80;
-	else if (params->frequency < 2150000)
+	else if (c->frequency < 2150000)
 		buf[3] |= 0xC0;
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -619,6 +620,7 @@ static struct stv0299_config cinergy_1200s_1894_0010_config = {
 
 static int philips_cu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = (struct budget *) fe->dvb->priv;
 	u8 buf[6];
 	struct i2c_msg msg = {.addr = 0x60,.flags = 0,.buf = buf,.len = sizeof(buf) };
@@ -627,13 +629,13 @@ static int philips_cu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 #define CU1216_IF 36125000
 #define TUNER_MUL 62500
 
-	u32 div = (params->frequency + CU1216_IF + TUNER_MUL / 2) / TUNER_MUL;
+	u32 div = (c->frequency + CU1216_IF + TUNER_MUL / 2) / TUNER_MUL;
 
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0xce;
-	buf[3] = (params->frequency < 150000000 ? 0x01 :
-		  params->frequency < 445000000 ? 0x02 : 0x04);
+	buf[3] = (c->frequency < 150000000 ? 0x01 :
+		  c->frequency < 445000000 ? 0x02 : 0x04);
 	buf[4] = 0xde;
 	buf[5] = 0x20;
 
@@ -699,6 +701,7 @@ static int philips_tu1216_tuner_init(struct dvb_frontend *fe)
 
 static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = (struct budget *) fe->dvb->priv;
 	u8 tuner_buf[4];
 	struct i2c_msg tuner_msg = {.addr = 0x60,.flags = 0,.buf = tuner_buf,.len =
@@ -707,7 +710,7 @@ static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 	u8 band, cp, filter;
 
 	// determine charge pump
-	tuner_frequency = params->frequency + 36166000;
+	tuner_frequency = c->frequency + 36166000;
 	if (tuner_frequency < 87000000)
 		return -EINVAL;
 	else if (tuner_frequency < 130000000)
@@ -732,28 +735,28 @@ static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 		return -EINVAL;
 
 	// determine band
-	if (params->frequency < 49000000)
+	if (c->frequency < 49000000)
 		return -EINVAL;
-	else if (params->frequency < 161000000)
+	else if (c->frequency < 161000000)
 		band = 1;
-	else if (params->frequency < 444000000)
+	else if (c->frequency < 444000000)
 		band = 2;
-	else if (params->frequency < 861000000)
+	else if (c->frequency < 861000000)
 		band = 4;
 	else
 		return -EINVAL;
 
 	// setup PLL filter
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (c->bandwidth_hz) {
+	case 6000000:
 		filter = 0;
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		filter = 0;
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		filter = 1;
 		break;
 
@@ -763,7 +766,7 @@ static int philips_tu1216_tuner_set_params(struct dvb_frontend *fe, struct dvb_f
 
 	// calculate divisor
 	// ((36166000+((1000000/6)/2)) + Finput)/(1000000/6)
-	tuner_frequency = (((params->frequency / 1000) * 6) + 217496) / 1000;
+	tuner_frequency = (((c->frequency / 1000) * 6) + 217496) / 1000;
 
 	// setup tuner buffer
 	tuner_buf[0] = (tuner_frequency >> 8) & 0x7f;
-- 
1.7.8.352.g876a6

