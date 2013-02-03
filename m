Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:20794 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753760Ab3BCWk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 17:40:28 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATH 2/2] mxl5007 move loop_thru to attach
Date: Sun, 03 Feb 2013 23:40:24 +0100
Message-ID: <3605279.72np2izzp3@jar7.dominio>
In-Reply-To: <2289340.7RydykYGjZ@jar7.dominio>
References: <2289340.7RydykYGjZ@jar7.dominio>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch move the loop_thru configuration to the attach function,
because with dual tuners until loop_tru configuration the other tuner
don't work.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

diff -upr linux/drivers/media/tuners/mxl5007t.c linux.new/drivers/media/tuners/mxl5007t.c
--- linux/drivers/media/tuners/mxl5007t.c	2013-02-03 23:16:08.031628907 +0100
+++ linux.new/drivers/media/tuners/mxl5007t.c	2013-02-03 23:14:12.196089297 +0100
@@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
 	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
 	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
 
-	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
 	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
 	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
 
@@ -908,6 +907,18 @@ struct dvb_frontend *mxl5007t_attach(str
 	if (mxl_fail(ret))
 		goto fail;
 
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = mxl5007t_write_reg(state, 0x04,
+		state->config->loop_thru_enable);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (mxl_fail(ret))
+		goto fail;
+
 	fe->tuner_priv = state;
 
 	mutex_unlock(&mxl5007t_list_mutex);

