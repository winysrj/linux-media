Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:53955 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380Ab3BCWat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 17:30:49 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Michael Krufky <mkrufky@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATH 1/2] mxl5007 move reset to attach
Date: Sun, 03 Feb 2013 23:30:38 +0100
Message-ID: <2289340.7RydykYGjZ@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch move the soft reset to the attach function because with dual
tuners, when one tuner do reset, the other one is perturbed, and the 
stream has errors.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

diff -upr linux/drivers/media/tuners/mxl5007t.c linux.new/drivers/media/tuners/mxl5007t.c
--- linux/drivers/media/tuners/mxl5007t.c	2012-08-14 05:45:22.000000000 +0200
+++ linux.new/drivers/media/tuners/mxl5007t.c	2013-02-03 23:03:03.784525410 +0100
@@ -531,10 +531,6 @@ static int mxl5007t_tuner_init(struct mx
 	struct reg_pair_t *init_regs;
 	int ret;
 
-	ret = mxl5007t_soft_reset(state);
-	if (mxl_fail(ret))
-		goto fail;
-
 	/* calculate initialization reg array */
 	init_regs = mxl5007t_calc_init_regs(state, mode);
 
@@ -900,7 +896,20 @@ struct dvb_frontend *mxl5007t_attach(str
 		/* existing tuner instance */
 		break;
 	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = mxl5007t_soft_reset(state);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (mxl_fail(ret))
+		goto fail;
+
 	fe->tuner_priv = state;
+
 	mutex_unlock(&mxl5007t_list_mutex);
 
 	memcpy(&fe->ops.tuner_ops, &mxl5007t_tuner_ops,

