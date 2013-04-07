Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934561Ab3DGXxz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Apr 2013 19:53:55 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37Nrt05027910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 7 Apr 2013 19:53:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH 4/5] r820t: proper lock and set the I2C gate
Date: Sun,  7 Apr 2013 20:53:29 -0300
Message-Id: <1365378810-1637-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365378810-1637-1-git-send-email-mchehab@redhat.com>
References: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
 <1365378810-1637-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this tuner can be used by analog and digital parts of the
driver, be sure that all ops that access the hardware will
be be properly locked.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 50 +++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 50401a4..198a37b 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1193,8 +1193,6 @@ static int generic_set_freq(struct dvb_frontend *fe,
 	tuner_dbg("should set frequency to %d kHz, bw %d MHz\n",
 		  freq / 1000, bw);
 
-	mutex_lock(&priv->lock);
-
 	if ((type == V4L2_TUNER_ANALOG_TV) && (std == V4L2_STD_SECAM_LC))
 		lo_freq = freq - priv->int_freq;
 	 else
@@ -1218,7 +1216,6 @@ static int generic_set_freq(struct dvb_frontend *fe,
 
 	rc = r820t_sysfreq_sel(priv, freq, type, std, delsys);
 err:
-	mutex_unlock(&priv->lock);
 
 	if (rc < 0)
 		tuner_dbg("%s: failed=%d\n", __func__, rc);
@@ -1335,6 +1332,8 @@ static int r820t_xtal_check(struct r820t_priv *priv)
 
 /*
  *  r820t frontend operations and tuner attach code
+ *
+ * All driver locks and i2c control are only in this part of the code
  */
 
 static int r820t_init(struct dvb_frontend *fe)
@@ -1345,11 +1344,10 @@ static int r820t_init(struct dvb_frontend *fe)
 
 	tuner_dbg("%s:\n", __func__);
 
+	mutex_lock(&priv->lock);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	mutex_lock(&priv->lock);
-
 	if ((priv->cfg->rafael_chip == CHIP_R820T) ||
 	    (priv->cfg->rafael_chip == CHIP_R828S) ||
 	    (priv->cfg->rafael_chip == CHIP_R820C)) {
@@ -1369,17 +1367,13 @@ static int r820t_init(struct dvb_frontend *fe)
 	rc = r820t_write(priv, 0x05,
 			 r820t_init_array, sizeof(r820t_init_array));
 
-	mutex_unlock(&priv->lock);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	return rc;
 err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
+	mutex_unlock(&priv->lock);
 
-	tuner_dbg("%s: failed=%d\n", __func__, rc);
+	if (rc < 0)
+		tuner_dbg("%s: failed=%d\n", __func__, rc);
 	return rc;
 }
 
@@ -1390,15 +1384,15 @@ static int r820t_sleep(struct dvb_frontend *fe)
 
 	tuner_dbg("%s:\n", __func__);
 
+	mutex_lock(&priv->lock);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	mutex_lock(&priv->lock);
 	rc = r820t_standby(priv);
-	mutex_unlock(&priv->lock);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
+	mutex_unlock(&priv->lock);
 
 	tuner_dbg("%s: failed=%d\n", __func__, rc);
 	return rc;
@@ -1409,6 +1403,7 @@ static int r820t_set_analog_freq(struct dvb_frontend *fe,
 {
 	struct r820t_priv *priv = fe->tuner_priv;
 	unsigned bw;
+	int rc;
 
 	tuner_dbg("%s called\n", __func__);
 
@@ -1421,8 +1416,18 @@ static int r820t_set_analog_freq(struct dvb_frontend *fe,
 	else
 		bw = 8;
 
-	return generic_set_freq(fe, 62500l * p->frequency, bw,
-				V4L2_TUNER_ANALOG_TV, p->std, SYS_UNDEFINED);
+	mutex_lock(&priv->lock);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	rc = generic_set_freq(fe, 62500l * p->frequency, bw,
+			      V4L2_TUNER_ANALOG_TV, p->std, SYS_UNDEFINED);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	mutex_unlock(&priv->lock);
+
+	return rc;
 }
 
 static int r820t_set_params(struct dvb_frontend *fe)
@@ -1435,6 +1440,7 @@ static int r820t_set_params(struct dvb_frontend *fe)
 	tuner_dbg("%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
 		__func__, c->delivery_system, c->frequency, c->bandwidth_hz);
 
+	mutex_lock(&priv->lock);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -1447,6 +1453,7 @@ static int r820t_set_params(struct dvb_frontend *fe)
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
+	mutex_unlock(&priv->lock);
 
 	if (rc)
 		tuner_dbg("%s: failed=%d\n", __func__, rc);
@@ -1458,10 +1465,14 @@ static int r820t_signal(struct dvb_frontend *fe, u16 *strength)
 	struct r820t_priv *priv = fe->tuner_priv;
 	int rc = 0;
 
+	mutex_lock(&priv->lock);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
 	if (priv->has_lock) {
 		rc = r820t_read_gain(priv);
 		if (rc < 0)
-			return rc;
+			goto err;
 
 		/* A higher gain at LNA means a lower signal strength */
 		*strength = (45 - rc) << 4 | 0xff;
@@ -1469,6 +1480,11 @@ static int r820t_signal(struct dvb_frontend *fe, u16 *strength)
 		*strength = 0;
 	}
 
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	mutex_unlock(&priv->lock);
+
 	tuner_dbg("%s: %s, gain=%d strength=%d\n",
 		  __func__,
 		  priv->has_lock ? "PLL locked" : "no signal",
-- 
1.8.1.4

