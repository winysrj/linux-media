Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7Qc017072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 45/47] [media] budget: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:50 -0200
Message-Id: <1324741852-26138-46-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-45-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-45-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttpci/budget.c |   39 +++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index d238fb9..719b965 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -202,17 +202,18 @@ static int budget_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t m
 
 static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
 	u8 pwr = 0;
 	u8 buf[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
-	u32 div = (params->frequency + 479500) / 125;
+	u32 div = (c->frequency + 479500) / 125;
 
-	if (params->frequency > 2000000) pwr = 3;
-	else if (params->frequency > 1800000) pwr = 2;
-	else if (params->frequency > 1600000) pwr = 1;
-	else if (params->frequency > 1200000) pwr = 0;
-	else if (params->frequency >= 1100000) pwr = 1;
+	if (c->frequency > 2000000) pwr = 3;
+	else if (c->frequency > 1800000) pwr = 2;
+	else if (c->frequency > 1600000) pwr = 1;
+	else if (c->frequency > 1200000) pwr = 0;
+	else if (c->frequency >= 1100000) pwr = 1;
 	else pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
@@ -238,17 +239,18 @@ static struct ves1x93_config alps_bsrv2_config =
 
 static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x62, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = (params->frequency + 35937500 + 31250) / 62500;
+	div = (c->frequency + 35937500 + 31250) / 62500;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x85 | ((div >> 10) & 0x60);
-	data[3] = (params->frequency < 174000000 ? 0x88 : params->frequency < 470000000 ? 0x84 : 0x81);
+	data[3] = (c->frequency < 174000000 ? 0x88 : c->frequency < 470000000 ? 0x84 : 0x81);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
@@ -265,6 +267,7 @@ static struct ves1820_config alps_tdbe2_config = {
 
 static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = fe->dvb->priv;
 	u8 *tuner_addr = fe->tuner_priv;
 	u32 div;
@@ -277,18 +280,18 @@ static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dv
 	else
 		msg.addr = 0x61;
 
-	div = (36125000 + params->frequency) / 166666;
+	div = (36125000 + c->frequency) / 166666;
 
 	cfg = 0x88;
 
-	if (params->frequency < 175000000) cpump = 2;
-	else if (params->frequency < 390000000) cpump = 1;
-	else if (params->frequency < 470000000) cpump = 2;
-	else if (params->frequency < 750000000) cpump = 1;
+	if (c->frequency < 175000000) cpump = 2;
+	else if (c->frequency < 390000000) cpump = 1;
+	else if (c->frequency < 470000000) cpump = 2;
+	else if (c->frequency < 750000000) cpump = 1;
 	else cpump = 3;
 
-	if (params->frequency < 175000000) band_select = 0x0e;
-	else if (params->frequency < 470000000) band_select = 0x05;
+	if (c->frequency < 175000000) band_select = 0x0e;
+	else if (c->frequency < 470000000) band_select = 0x05;
 	else band_select = 0x03;
 
 	data[0] = (div >> 8) & 0x7f;
@@ -314,12 +317,13 @@ static u8 tuner_address_grundig_29504_401_activy = 0x60;
 
 static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = params->frequency / 125;
+	div = c->frequency / 125;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x8e;
@@ -337,12 +341,13 @@ static struct tda8083_config grundig_29504_451_config = {
 
 static int s5h1420_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = params->frequency / 1000;
+	div = c->frequency / 1000;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0xc2;
-- 
1.7.8.352.g876a6

