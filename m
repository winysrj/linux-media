Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab1LXPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:08 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7ds030862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 23/47] [media] saa7134: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:28 -0200
Message-Id: <1324741852-26138-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-23-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/saa7134/saa7134-dvb.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 1e4ef16..5fdb845 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -186,6 +186,7 @@ static int mt352_avermedia_xc3028_init(struct dvb_frontend *fe)
 static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
 					   struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 off[] = { 0x00, 0xf1};
 	u8 on[]  = { 0x00, 0x71};
 	struct i2c_msg msg = {.addr=0x43, .flags=0, .buf=off, .len = sizeof(off)};
@@ -196,7 +197,7 @@ static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe,
 	/* set frequency (mt2050) */
 	f.tuner     = 0;
 	f.type      = V4L2_TUNER_DIGITAL_TV;
-	f.frequency = params->frequency / 1000 * 16 / 1000;
+	f.frequency = c->frequency / 1000 * 16 / 1000;
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	i2c_transfer(&dev->i2c_adap, &msg, 1);
@@ -289,6 +290,7 @@ static int philips_tda1004x_request_firmware(struct dvb_frontend *fe,
 
 static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct saa7134_dev *dev = fe->dvb->priv;
 	struct tda1004x_state *state = fe->demodulator_priv;
 	u8 addr = state->config->tuner_address;
@@ -299,7 +301,7 @@ static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_
 	u8 band, cp, filter;
 
 	/* determine charge pump */
-	tuner_frequency = params->frequency + 36166000;
+	tuner_frequency = c->frequency + 36166000;
 	if (tuner_frequency < 87000000)
 		return -EINVAL;
 	else if (tuner_frequency < 130000000)
@@ -324,28 +326,28 @@ static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_
 		return -EINVAL;
 
 	/* determine band */
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
 
 	/* setup PLL filter */
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
 
@@ -356,7 +358,7 @@ static int philips_tda6651_pll_set(struct dvb_frontend *fe, struct dvb_frontend_
 	/* calculate divisor
 	 * ((36166000+((1000000/6)/2)) + Finput)/(1000000/6)
 	 */
-	tuner_frequency = (((params->frequency / 1000) * 6) + 217496) / 1000;
+	tuner_frequency = (((c->frequency / 1000) * 6) + 217496) / 1000;
 
 	/* setup tuner buffer */
 	tuner_buf[0] = (tuner_frequency >> 8) & 0x7f;
-- 
1.7.8.352.g876a6

