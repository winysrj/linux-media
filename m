Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40415 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101AbaHVK6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:37 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 19/21] m88ts2022: change parameter type of m88ts2022_cmd
Date: Fri, 22 Aug 2014 13:58:11 +0300
Message-Id: <1408705093-5167-20-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is driver internal function and does not need anything from
frontend structure. Due to that change parameter type to driver
state which is better for driver internal functions.

Also remove one unused variable from state itself.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c      | 21 ++++++++++-----------
 drivers/media/tuners/m88ts2022_priv.h |  1 -
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 04d3979..90e1a35 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -18,10 +18,9 @@
 
 #include "m88ts2022_priv.h"
 
-static int m88ts2022_cmd(struct dvb_frontend *fe,
-		int op, int sleep, u8 reg, u8 mask, u8 val, u8 *reg_val)
+static int m88ts2022_cmd(struct m88ts2022 *s, int op, int sleep, u8 reg,
+		u8 mask, u8 val, u8 *reg_val)
 {
-	struct m88ts2022 *s = fe->tuner_priv;
 	int ret, i;
 	unsigned int utmp;
 	struct m88ts2022_reg_val reg_vals[] = {
@@ -124,7 +123,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			s->frequency_khz, s->frequency_khz - c->frequency,
 			f_vco_khz, pll_n, div_ref, div_out);
 
-	ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
+	ret = m88ts2022_cmd(s, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 	if (ret)
 		goto err;
 
@@ -142,7 +141,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
+		ret = m88ts2022_cmd(s, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 		if (ret)
 			goto err;
 	}
@@ -158,7 +157,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	ret = m88ts2022_cmd(fe, 0x08, 5, 0x3c, 0xff, 0x00, NULL);
+	ret = m88ts2022_cmd(s, 0x08, 5, 0x3c, 0xff, 0x00, NULL);
 	if (ret)
 		goto err;
 
@@ -185,7 +184,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(s, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -195,7 +194,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(s, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -227,7 +226,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(s, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -237,7 +236,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(s, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -257,7 +256,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x01, 20, 0x21, 0xff, 0x00, NULL);
+	ret = m88ts2022_cmd(s, 0x01, 20, 0x21, 0xff, 0x00, NULL);
 	if (ret)
 		goto err;
 err:
diff --git a/drivers/media/tuners/m88ts2022_priv.h b/drivers/media/tuners/m88ts2022_priv.h
index a67afe3..a0e22fa 100644
--- a/drivers/media/tuners/m88ts2022_priv.h
+++ b/drivers/media/tuners/m88ts2022_priv.h
@@ -24,7 +24,6 @@ struct m88ts2022 {
 	struct m88ts2022_config cfg;
 	struct i2c_client *client;
 	struct regmap *regmap;
-	struct dvb_frontend *fe;
 	u32 frequency_khz;
 };
 
-- 
http://palosaari.fi/

