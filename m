Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2EAEMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:47 -0400
Received: by mail-vx0-f174.google.com with SMTP id p1so2537594vcq.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:47 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 06/10] lg2160: update internal api interfaces and enable build
Date: Tue,  1 May 2012 00:12:21 -0400
Message-Id: <1335845545-20879-6-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/frontends/Kconfig  |    8 ++++++++
 drivers/media/dvb/frontends/lg2160.c |   25 +++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 2124670..09e21c9 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -531,6 +531,14 @@ config DVB_LGDT3305
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
+config DVB_LG2160
+	tristate "LG Electronics LG216x based"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  An ATSC/MH demodulator module. Say Y when you want
+	  to support this frontend.
+
 config DVB_S5H1409
 	tristate "Samsung S5H1409 based"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb/frontends/lg2160.c b/drivers/media/dvb/frontends/lg2160.c
index 269ab7b..daa8596 100644
--- a/drivers/media/dvb/frontends/lg2160.c
+++ b/drivers/media/dvb/frontends/lg2160.c
@@ -939,17 +939,15 @@ static int lg216x_read_rs_err_count(struct lg216x_state *state, u16 *err)
 
 /* ------------------------------------------------------------------------ */
 
-static int lg216x_get_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *param)
+static int lg216x_get_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
 	int ret;
 
 	lg_dbg("\n");
 
-	param->u.vsb.modulation = VSB_8; /* FIXME (MH) */
-	param->frequency = state->current_frequency;
-
+	fe->dtv_property_cache.modulation = VSB_8;
+	fe->dtv_property_cache.frequency = state->current_frequency;
 	fe->dtv_property_cache.delivery_system = SYS_ATSCMH;
 
 	ret = lg216x_get_fic_version(state,
@@ -1051,28 +1049,25 @@ fail:
 static int lg216x_get_property(struct dvb_frontend *fe,
 			       struct dtv_property *tvp)
 {
-	struct dvb_frontend_parameters param;
-
 	return (DTV_ATSCMH_FIC_VER == tvp->cmd) ?
-		lg216x_get_frontend(fe, &param) : 0;
+		lg216x_get_frontend(fe) : 0;
 }
 
 
-static int lg2160_set_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *param)
+static int lg2160_set_frontend(struct dvb_frontend *fe)
 {
 	struct lg216x_state *state = fe->demodulator_priv;
 	int ret;
 
-	lg_dbg("(%d, %d)\n", param->frequency, param->u.vsb.modulation);
+	lg_dbg("(%d)\n", fe->dtv_property_cache.frequency);
 
 	if (fe->ops.tuner_ops.set_params) {
-		ret = fe->ops.tuner_ops.set_params(fe, param);
+		ret = fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (lg_fail(ret))
 			goto fail;
-		state->current_frequency = param->frequency;
+		state->current_frequency = fe->dtv_property_cache.frequency;
 	}
 
 	ret = lg2160_agc_fix(state, 0, 0);
@@ -1129,7 +1124,7 @@ static int lg2160_set_frontend(struct dvb_frontend *fe,
 	ret = lg216x_enable_fic(state, 1);
 	lg_fail(ret);
 
-	lg216x_get_frontend(fe, param);
+	lg216x_get_frontend(fe);
 fail:
 	return ret;
 }
@@ -1359,7 +1354,6 @@ static struct dvb_frontend_ops lg2160_ops = {
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
-		.caps = FE_CAN_8VSB | FE_HAS_EXTENDED_CAPS /* FIXME (MH) */
 	},
 	.i2c_gate_ctrl        = lg216x_i2c_gate_ctrl,
 #if 0
@@ -1389,7 +1383,6 @@ static struct dvb_frontend_ops lg2161_ops = {
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
-		.caps = FE_CAN_8VSB | FE_HAS_EXTENDED_CAPS /* FIXME (MH) */
 	},
 	.i2c_gate_ctrl        = lg216x_i2c_gate_ctrl,
 #if 0
-- 
1.7.5.4

