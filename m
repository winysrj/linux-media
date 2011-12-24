Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp59C009936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 12/47] [media] tda18218: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:17 -0200
Message-Id: <1324741852-26138-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-12-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda18218.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
index 1c86595..bbed0cf 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -113,6 +113,8 @@ static int tda18218_set_params(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
 	struct tda18218_priv *priv = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 bw = c->bandwidth_hz;
 	int ret;
 	u8 buf[3], i, BP_Filter, LP_Fc;
 	u32 LO_Frac;
@@ -138,23 +140,18 @@ static int tda18218_set_params(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
 	/* low-pass filter cut-off frequency */
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	if (bw <= 6000000) {
 		LP_Fc = 0;
 		priv->if_frequency = 4000000;
-		break;
-	case BANDWIDTH_7_MHZ:
+	} else if (bw <= 7000000) {
 		LP_Fc = 1;
 		priv->if_frequency = 3500000;
-		break;
-	case BANDWIDTH_8_MHZ:
-	default:
+	} else {
 		LP_Fc = 2;
 		priv->if_frequency = 4000000;
-		break;
 	}
 
-	LO_Frac = params->frequency + priv->if_frequency;
+	LO_Frac = c->frequency + priv->if_frequency;
 
 	/* band-pass filter */
 	if (LO_Frac < 188000000)
-- 
1.7.8.352.g876a6

