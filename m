Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNsR032747
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 23/28] [media] tda827x: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:11 -0200
Message-Id: <1324552816-25704-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-23-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
 <1324552816-25704-9-git-send-email-mchehab@redhat.com>
 <1324552816-25704-10-git-send-email-mchehab@redhat.com>
 <1324552816-25704-11-git-send-email-mchehab@redhat.com>
 <1324552816-25704-12-git-send-email-mchehab@redhat.com>
 <1324552816-25704-13-git-send-email-mchehab@redhat.com>
 <1324552816-25704-14-git-send-email-mchehab@redhat.com>
 <1324552816-25704-15-git-send-email-mchehab@redhat.com>
 <1324552816-25704-16-git-send-email-mchehab@redhat.com>
 <1324552816-25704-17-git-send-email-mchehab@redhat.com>
 <1324552816-25704-18-git-send-email-mchehab@redhat.com>
 <1324552816-25704-19-git-send-email-mchehab@redhat.com>
 <1324552816-25704-20-git-send-email-mchehab@redhat.com>
 <1324552816-25704-21-git-send-email-mchehab@redhat.com>
 <1324552816-25704-22-git-send-email-mchehab@redhat.com>
 <1324552816-25704-23-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda827x.c |   49 +++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/common/tuners/tda827x.c
index e0d5b43..7316308 100644
--- a/drivers/media/common/tuners/tda827x.c
+++ b/drivers/media/common/tuners/tda827x.c
@@ -155,9 +155,11 @@ static int tuner_transfer(struct dvb_frontend *fe,
 static int tda827xo_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda827x_priv *priv = fe->tuner_priv;
 	u8 buf[14];
 	int rc;
+	u32 band;
 
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
@@ -165,18 +167,20 @@ static int tda827xo_set_params(struct dvb_frontend *fe,
 	u32 N;
 
 	dprintk("%s:\n", __func__);
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	if (c->bandwidth_hz == 0) {
+		if_freq = 5000000;
+		band = BANDWIDTH_8_MHZ;
+	} else if (c->bandwidth_hz <= 6000000) {
 		if_freq = 4000000;
-		break;
-	case BANDWIDTH_7_MHZ:
+		band = BANDWIDTH_6_MHZ;
+	} else if (c->bandwidth_hz <= 7000000) {
 		if_freq = 4500000;
-		break;
-	default:		   /* 8 MHz or Auto */
+		band = BANDWIDTH_7_MHZ;
+	} else {	/* 8 MHz */
 		if_freq = 5000000;
-		break;
+		band = BANDWIDTH_8_MHZ;
 	}
-	tuner_freq = params->frequency;
+	tuner_freq = c->frequency;
 
 	i = 0;
 	while (tda827x_table[i].lomax < tuner_freq) {
@@ -220,8 +224,8 @@ static int tda827xo_set_params(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
-	priv->frequency = params->frequency;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
+	priv->frequency = c->frequency;
+	priv->bandwidth = band;
 
 	return 0;
 
@@ -516,9 +520,11 @@ static void tda827xa_lna_gain(struct dvb_frontend *fe, int high,
 static int tda827xa_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tda827x_priv *priv = fe->tuner_priv;
 	struct tda827xa_data *frequency_map = tda827xa_dvbt;
 	u8 buf[11];
+	u32 band;
 
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
@@ -531,18 +537,20 @@ static int tda827xa_set_params(struct dvb_frontend *fe,
 	tda827xa_lna_gain(fe, 1, NULL);
 	msleep(20);
 
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	if (c->bandwidth_hz == 0) {
+		if_freq = 5000000;
+		band = BANDWIDTH_8_MHZ;
+	} else if (c->bandwidth_hz <= 6000000) {
 		if_freq = 4000000;
-		break;
-	case BANDWIDTH_7_MHZ:
+		band = BANDWIDTH_6_MHZ;
+	} else if (c->bandwidth_hz <= 7000000) {
 		if_freq = 4500000;
-		break;
-	default:		   /* 8 MHz or Auto */
+		band = BANDWIDTH_7_MHZ;
+	} else {	/* 8 MHz */
 		if_freq = 5000000;
-		break;
+		band = BANDWIDTH_8_MHZ;
 	}
-	tuner_freq = params->frequency;
+	tuner_freq = c->frequency;
 
 	if (fe->ops.info.type == FE_QAM) {
 		dprintk("%s select tda827xa_dvbc\n", __func__);
@@ -645,9 +653,8 @@ static int tda827xa_set_params(struct dvb_frontend *fe,
 	if (rc < 0)
 		goto err;
 
-	priv->frequency = params->frequency;
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
-
+	priv->frequency = c->frequency;
+	priv->bandwidth = band;
 
 	return 0;
 
-- 
1.7.8.352.g876a6

