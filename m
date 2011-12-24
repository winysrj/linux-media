Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5tX017033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 05/47] [media] mt2031: remove fake implementaion of get_bandwidth()
Date: Sat, 24 Dec 2011 13:50:10 -0200
Message-Id: <1324741852-26138-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-5-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
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
 drivers/media/common/tuners/mt2131.c      |   17 ++---------------
 drivers/media/common/tuners/mt2131_priv.h |    1 -
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/media/common/tuners/mt2131.c b/drivers/media/common/tuners/mt2131.c
index a4f830b..d9cab1f 100644
--- a/drivers/media/common/tuners/mt2131.c
+++ b/drivers/media/common/tuners/mt2131.c
@@ -95,6 +95,7 @@ static int mt2131_writeregs(struct mt2131_priv *priv,u8 *buf, u8 len)
 static int mt2131_set_params(struct dvb_frontend *fe,
 			     struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2131_priv *priv;
 	int ret=0, i;
 	u32 freq;
@@ -105,12 +106,8 @@ static int mt2131_set_params(struct dvb_frontend *fe,
 	u8 lockval = 0;
 
 	priv = fe->tuner_priv;
-	if (fe->ops.info.type == FE_OFDM)
-		priv->bandwidth = params->u.ofdm.bandwidth;
-	else
-		priv->bandwidth = 0;
 
-	freq = params->frequency / 1000;  // Hz -> kHz
+	freq = c->frequency / 1000;  /* Hz -> kHz */
 	dprintk(1, "%s() freq=%d\n", __func__, freq);
 
 	f_lo1 = freq + MT2131_IF1 * 1000;
@@ -193,14 +190,6 @@ static int mt2131_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int mt2131_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
-{
-	struct mt2131_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __func__);
-	*bandwidth = priv->bandwidth;
-	return 0;
-}
-
 static int mt2131_get_status(struct dvb_frontend *fe, u32 *status)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
@@ -263,7 +252,6 @@ static const struct dvb_tuner_ops mt2131_tuner_ops = {
 
 	.set_params    = mt2131_set_params,
 	.get_frequency = mt2131_get_frequency,
-	.get_bandwidth = mt2131_get_bandwidth,
 	.get_status    = mt2131_get_status
 };
 
@@ -281,7 +269,6 @@ struct dvb_frontend * mt2131_attach(struct dvb_frontend *fe,
 		return NULL;
 
 	priv->cfg = cfg;
-	priv->bandwidth = 6000000; /* 6MHz */
 	priv->i2c = i2c;
 
 	if (mt2131_readreg(priv, 0, &id) != 0) {
diff --git a/drivers/media/common/tuners/mt2131_priv.h b/drivers/media/common/tuners/mt2131_priv.h
index 4e05a67..62aeedf 100644
--- a/drivers/media/common/tuners/mt2131_priv.h
+++ b/drivers/media/common/tuners/mt2131_priv.h
@@ -38,7 +38,6 @@ struct mt2131_priv {
 	struct i2c_adapter   *i2c;
 
 	u32 frequency;
-	u32 bandwidth;
 };
 
 #endif /* __MT2131_PRIV_H__ */
-- 
1.7.8.352.g876a6

