Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AQG002495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 35/47] [media] mt2063: Convert it to the DVBv5 way for set_params()
Date: Wed,  4 Jan 2012 23:00:46 -0200
Message-Id: <1325725258-27934-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   46 ++++++++++++---------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index b2678a4..75cb1d2 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2051,9 +2051,9 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
  */
 #define MAX_SYMBOL_RATE_6MHz	5217391
 
-static int mt2063_set_params(struct dvb_frontend *fe,
-			     struct dvb_frontend_parameters *params)
+static int mt2063_set_params(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2063_state *state = fe->tuner_priv;
 	int status;
 	s32 pict_car = 0;
@@ -2065,37 +2065,25 @@ static int mt2063_set_params(struct dvb_frontend *fe,
 	s32 if_mid = 0;
 	s32 rcvr_mode = 0;
 
-	switch (fe->ops.info.type) {
-	case FE_OFDM:
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
-			ch_bw = 6000000;
-			break;
-		case BANDWIDTH_7_MHZ:
-			ch_bw = 7000000;
-			break;
-		case BANDWIDTH_8_MHZ:
-			ch_bw = 8000000;
-			break;
-		default:
-			return -EINVAL;
-		}
+	if (c->bandwidth_hz == 0)
+		return -EINVAL;
+	if (c->bandwidth_hz <= 6000000)
+		ch_bw = 6000000;
+	else if (c->bandwidth_hz <= 7000000)
+		ch_bw = 7000000;
+	else
+		ch_bw = 8000000;
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
 		rcvr_mode = MT2063_OFFAIR_COFDM;
 		pict_car = 36125000;
 		pict2chanb_vsb = -(ch_bw / 2);
 		pict2snd1 = 0;
 		pict2snd2 = 0;
 		break;
-	case FE_QAM:
-		/*
-		 * Using a 8MHz bandwidth sometimes fail
-		 * with 6MHz-spaced channels, due to inter-carrier
-		 * interference. So, it is better to narrow-down the filter
-		 */
-		if (params->u.qam.symbol_rate <= MAX_SYMBOL_RATE_6MHz)
-			ch_bw = 6000000;
-		else
-			ch_bw = 8000000;
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
 		rcvr_mode = MT2063_CABLE_QAM;
 		pict_car = 36125000;
 		pict2snd1 = 0;
@@ -2115,12 +2103,12 @@ static int mt2063_set_params(struct dvb_frontend *fe,
 	if (status < 0)
 		return status;
 
-	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
+	status = MT2063_Tune(state, (c->frequency + (pict2chanb_vsb + (ch_bw / 2))));
 
 	if (status < 0)
 		return status;
 
-	state->frequency = params->frequency;
+	state->frequency = c->frequency;
 	return 0;
 }
 
-- 
1.7.7.5

