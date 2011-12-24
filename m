Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab1LXPvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:09 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp9mO017082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 20/47] [media] av7110: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:25 -0200
Message-Id: <1324741852-26138-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-20-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttpci/av7110.c |   55 +++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index abf6b55..37eb4ac 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1570,17 +1570,18 @@ static int get_firmware(struct av7110* av7110)
 
 static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u8 pwr = 0;
 	u8 buf[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
-	u32 div = (params->frequency + 479500) / 125;
+	u32 div = (p->frequency + 479500) / 125;
 
-	if (params->frequency > 2000000) pwr = 3;
-	else if (params->frequency > 1800000) pwr = 2;
-	else if (params->frequency > 1600000) pwr = 1;
-	else if (params->frequency > 1200000) pwr = 0;
-	else if (params->frequency >= 1100000) pwr = 1;
+	if (p->frequency > 2000000) pwr = 3;
+	else if (p->frequency > 1800000) pwr = 2;
+	else if (p->frequency > 1600000) pwr = 1;
+	else if (p->frequency > 1200000) pwr = 0;
+	else if (p->frequency >= 1100000) pwr = 1;
 	else pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
@@ -1606,17 +1607,18 @@ static struct ves1x93_config alps_bsrv2_config = {
 
 static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
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
@@ -1637,12 +1639,13 @@ static struct ves1820_config alps_tdbe2_config = {
 
 static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = params->frequency / 125;
+	div = p->frequency / 125;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x8e;
@@ -1663,9 +1666,10 @@ static struct tda8083_config grundig_29504_451_config = {
 
 static int philips_cd1516_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u32 div;
-	u32 f = params->frequency;
+	u32 f = p->frequency;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
@@ -1694,14 +1698,15 @@ static struct ves1820_config philips_cd1516_config = {
 
 static int alps_tdlb7_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u32 div, pwr;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x60, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = (params->frequency + 36200000) / 166666;
+	div = (p->frequency + 36200000) / 166666;
 
-	if (params->frequency <= 782000000)
+	if (p->frequency <= 782000000)
 		pwr = 1;
 	else
 		pwr = 2;
@@ -1831,6 +1836,7 @@ static u8 nexusca_stv0297_inittab[] = {
 
 static int nexusca_stv0297_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u32 div;
 	u8 data[4];
@@ -1838,19 +1844,19 @@ static int nexusca_stv0297_tuner_set_params(struct dvb_frontend* fe, struct dvb_
 	struct i2c_msg readmsg = { .addr = 0x63, .flags = I2C_M_RD, .buf = data, .len = 1 };
 	int i;
 
-	div = (params->frequency + 36150000 + 31250) / 62500;
+	div = (p->frequency + 36150000 + 31250) / 62500;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0xce;
 
-	if (params->frequency < 45000000)
+	if (p->frequency < 45000000)
 		return -EINVAL;
-	else if (params->frequency < 137000000)
+	else if (p->frequency < 137000000)
 		data[3] = 0x01;
-	else if (params->frequency < 403000000)
+	else if (p->frequency < 403000000)
 		data[3] = 0x02;
-	else if (params->frequency < 860000000)
+	else if (p->frequency < 860000000)
 		data[3] = 0x04;
 	else
 		return -EINVAL;
@@ -1886,24 +1892,25 @@ static struct stv0297_config nexusca_stv0297_config = {
 
 static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
 	u32 div;
 	u8 cfg, cpump, band_select;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = (36125000 + params->frequency) / 166666;
+	div = (36125000 + p->frequency) / 166666;
 
 	cfg = 0x88;
 
-	if (params->frequency < 175000000) cpump = 2;
-	else if (params->frequency < 390000000) cpump = 1;
-	else if (params->frequency < 470000000) cpump = 2;
-	else if (params->frequency < 750000000) cpump = 1;
+	if (p->frequency < 175000000) cpump = 2;
+	else if (p->frequency < 390000000) cpump = 1;
+	else if (p->frequency < 470000000) cpump = 2;
+	else if (p->frequency < 750000000) cpump = 1;
 	else cpump = 3;
 
-	if (params->frequency < 175000000) band_select = 0x0e;
-	else if (params->frequency < 470000000) band_select = 0x05;
+	if (p->frequency < 175000000) band_select = 0x0e;
+	else if (p->frequency < 470000000) band_select = 0x05;
 	else band_select = 0x03;
 
 	data[0] = (div >> 8) & 0x7f;
-- 
1.7.8.352.g876a6

