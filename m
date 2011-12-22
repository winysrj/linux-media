Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab1LVLUZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:25 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKPk9004877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:25 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 20/28] [media] tda18218: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:08 -0200
Message-Id: <1324552816-25704-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-20-git-send-email-mchehab@redhat.com>
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

