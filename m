Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59196 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbaICKKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] m88ts2022: change parameter type of m88ts2022_cmd
Date: Wed,  3 Sep 2014 13:10:36 +0300
Message-Id: <1409739036-5091-4-git-send-email-crope@iki.fi>
In-Reply-To: <1409739036-5091-1-git-send-email-crope@iki.fi>
References: <1409739036-5091-1-git-send-email-crope@iki.fi>
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
index 9f7ebcf..caa5423 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -18,10 +18,9 @@
 
 #include "m88ts2022_priv.h"
 
-static int m88ts2022_cmd(struct dvb_frontend *fe,
-		int op, int sleep, u8 reg, u8 mask, u8 val, u8 *reg_val)
+static int m88ts2022_cmd(struct m88ts2022_dev *dev, int op, int sleep, u8 reg,
+		u8 mask, u8 val, u8 *reg_val)
 {
-	struct m88ts2022_dev *dev = fe->tuner_priv;
 	int ret, i;
 	unsigned int utmp;
 	struct m88ts2022_reg_val reg_vals[] = {
@@ -124,7 +123,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			dev->frequency_khz, dev->frequency_khz - c->frequency,
 			f_vco_khz, pll_n, div_ref, div_out);
 
-	ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
+	ret = m88ts2022_cmd(dev, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 	if (ret)
 		goto err;
 
@@ -142,7 +141,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
+		ret = m88ts2022_cmd(dev, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 		if (ret)
 			goto err;
 	}
@@ -158,7 +157,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	ret = m88ts2022_cmd(fe, 0x08, 5, 0x3c, 0xff, 0x00, NULL);
+	ret = m88ts2022_cmd(dev, 0x08, 5, 0x3c, 0xff, 0x00, NULL);
 	if (ret)
 		goto err;
 
@@ -185,7 +184,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(dev, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -195,7 +194,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(dev, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -227,7 +226,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(dev, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -237,7 +236,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
+	ret = m88ts2022_cmd(dev, 0x04, 2, 0x26, 0xff, 0x00, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -257,7 +256,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	ret = m88ts2022_cmd(fe, 0x01, 20, 0x21, 0xff, 0x00, NULL);
+	ret = m88ts2022_cmd(dev, 0x01, 20, 0x21, 0xff, 0x00, NULL);
 	if (ret)
 		goto err;
 err:
diff --git a/drivers/media/tuners/m88ts2022_priv.h b/drivers/media/tuners/m88ts2022_priv.h
index 56c1071..feeb5ad 100644
--- a/drivers/media/tuners/m88ts2022_priv.h
+++ b/drivers/media/tuners/m88ts2022_priv.h
@@ -24,7 +24,6 @@ struct m88ts2022_dev {
 	struct m88ts2022_config cfg;
 	struct i2c_client *client;
 	struct regmap *regmap;
-	struct dvb_frontend *fe;
 	u32 frequency_khz;
 };
 
-- 
http://palosaari.fi/

