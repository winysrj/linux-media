Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp4LQ018657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:04 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 03/47] [media] qt1010: remove fake implementaion of get_bandwidth()
Date: Sat, 24 Dec 2011 13:50:08 -0200
Message-Id: <1324741852-26138-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-3-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver implements a fake get_bandwidth() callback. In
reallity, the tuner driver won't adjust its low-pass
filter based on a bandwidth, and were just providing a fake
method for demods to read whatever was "set".

This code is useless, as none of the drivers that use
this tuner seems to require a get_bandwidth() callback.

While here, convert set_params to use the DVBv5 way to pass
parameters to tuners.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/qt1010.c      |   16 ++++------------
 drivers/media/common/tuners/qt1010_priv.h |    1 -
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
index cd461c2..bd433ad 100644
--- a/drivers/media/common/tuners/qt1010.c
+++ b/drivers/media/common/tuners/qt1010.c
@@ -85,6 +85,7 @@ static void qt1010_dump_regs(struct qt1010_priv *priv)
 static int qt1010_set_params(struct dvb_frontend *fe,
 			     struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct qt1010_priv *priv;
 	int err;
 	u32 freq, div, mod1, mod2;
@@ -144,13 +145,11 @@ static int qt1010_set_params(struct dvb_frontend *fe,
 #define FREQ2  4000000 /* 4 MHz Quartz oscillator in the stick? */
 
 	priv = fe->tuner_priv;
-	freq = params->frequency;
+	freq = c->frequency;
 	div = (freq + QT1010_OFFSET) / QT1010_STEP;
 	freq = (div * QT1010_STEP) - QT1010_OFFSET;
 	mod1 = (freq + QT1010_OFFSET) % FREQ1;
 	mod2 = (freq + QT1010_OFFSET) % FREQ2;
-	priv->bandwidth =
-		(fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
 	priv->frequency = freq;
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -321,6 +320,7 @@ static int qt1010_init(struct dvb_frontend *fe)
 {
 	struct qt1010_priv *priv = fe->tuner_priv;
 	struct dvb_frontend_parameters params;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 	u8 i, tmpval, *valptr = NULL;
 
@@ -397,7 +397,7 @@ static int qt1010_init(struct dvb_frontend *fe)
 		if ((err = qt1010_init_meas2(priv, i, &tmpval)))
 			return err;
 
-	params.frequency = 545000000; /* Sigmatek DVB-110 545000000 */
+	c->frequency = 545000000; /* Sigmatek DVB-110 545000000 */
 				      /* MSI Megasky 580 GL861 533000000 */
 	return qt1010_set_params(fe, &params);
 }
@@ -416,13 +416,6 @@ static int qt1010_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int qt1010_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
-{
-	struct qt1010_priv *priv = fe->tuner_priv;
-	*bandwidth = priv->bandwidth;
-	return 0;
-}
-
 static int qt1010_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	*frequency = 36125000;
@@ -443,7 +436,6 @@ static const struct dvb_tuner_ops qt1010_tuner_ops = {
 
 	.set_params    = qt1010_set_params,
 	.get_frequency = qt1010_get_frequency,
-	.get_bandwidth = qt1010_get_bandwidth,
 	.get_if_frequency = qt1010_get_if_frequency,
 };
 
diff --git a/drivers/media/common/tuners/qt1010_priv.h b/drivers/media/common/tuners/qt1010_priv.h
index 090cf47..2c42d3f 100644
--- a/drivers/media/common/tuners/qt1010_priv.h
+++ b/drivers/media/common/tuners/qt1010_priv.h
@@ -99,7 +99,6 @@ struct qt1010_priv {
 	u8 reg25_init_val;
 
 	u32 frequency;
-	u32 bandwidth;
 };
 
 #endif
-- 
1.7.8.352.g876a6

