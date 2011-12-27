Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab1L0BJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:45 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19iJt032685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 34/91] [media] lgdt3305: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:22 -0200
Message-Id: <1324948159-23709-35-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-34-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/lgdt3305.c |   97 ++++++++++++++++----------------
 1 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index e1a9c92..58eb7bc 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -266,7 +266,7 @@ fail:
 }
 
 static int lgdt3305_set_modulation(struct lgdt3305_state *state,
-				   struct dvb_frontend_parameters *param)
+				   struct dtv_frontend_properties *p)
 {
 	u8 opermode;
 	int ret;
@@ -279,7 +279,7 @@ static int lgdt3305_set_modulation(struct lgdt3305_state *state,
 
 	opermode &= ~0x03;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		opermode |= 0x03;
 		break;
@@ -298,11 +298,11 @@ fail:
 }
 
 static int lgdt3305_set_filter_extension(struct lgdt3305_state *state,
-					 struct dvb_frontend_parameters *param)
+					 struct dtv_frontend_properties *p)
 {
 	int val;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		val = 0;
 		break;
@@ -321,11 +321,11 @@ static int lgdt3305_set_filter_extension(struct lgdt3305_state *state,
 /* ------------------------------------------------------------------------ */
 
 static int lgdt3305_passband_digital_agc(struct lgdt3305_state *state,
-					 struct dvb_frontend_parameters *param)
+					 struct dtv_frontend_properties *p)
 {
 	u16 agc_ref;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		agc_ref = 0x32c4;
 		break;
@@ -348,11 +348,11 @@ static int lgdt3305_passband_digital_agc(struct lgdt3305_state *state,
 }
 
 static int lgdt3305_rfagc_loop(struct lgdt3305_state *state,
-			       struct dvb_frontend_parameters *param)
+			       struct dtv_frontend_properties *p)
 {
 	u16 ifbw, rfbw, agcdelay;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		agcdelay = 0x04c0;
 		rfbw     = 0x8000;
@@ -398,11 +398,11 @@ static int lgdt3305_rfagc_loop(struct lgdt3305_state *state,
 }
 
 static int lgdt3305_agc_setup(struct lgdt3305_state *state,
-			      struct dvb_frontend_parameters *param)
+			      struct dtv_frontend_properties *p)
 {
 	int lockdten, acqen;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		lockdten = 0;
 		acqen = 0;
@@ -432,15 +432,15 @@ static int lgdt3305_agc_setup(struct lgdt3305_state *state,
 		return -EINVAL;
 	}
 
-	return lgdt3305_rfagc_loop(state, param);
+	return lgdt3305_rfagc_loop(state, p);
 }
 
 static int lgdt3305_set_agc_power_ref(struct lgdt3305_state *state,
-				      struct dvb_frontend_parameters *param)
+				      struct dtv_frontend_properties *p)
 {
 	u16 usref = 0;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		if (state->cfg->usref_8vsb)
 			usref = state->cfg->usref_8vsb;
@@ -473,14 +473,14 @@ static int lgdt3305_set_agc_power_ref(struct lgdt3305_state *state,
 /* ------------------------------------------------------------------------ */
 
 static int lgdt3305_spectral_inversion(struct lgdt3305_state *state,
-				       struct dvb_frontend_parameters *param,
+				       struct dtv_frontend_properties *p,
 				       int inversion)
 {
 	int ret;
 
 	lg_dbg("(%d)\n", inversion);
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		ret = lgdt3305_write_reg(state, LGDT3305_CR_CTRL_7,
 					 inversion ? 0xf9 : 0x79);
@@ -497,13 +497,13 @@ static int lgdt3305_spectral_inversion(struct lgdt3305_state *state,
 }
 
 static int lgdt3305_set_if(struct lgdt3305_state *state,
-			   struct dvb_frontend_parameters *param)
+			   struct dtv_frontend_properties *p)
 {
 	u16 if_freq_khz;
 	u8 nco1, nco2, nco3, nco4;
 	u64 nco;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		if_freq_khz = state->cfg->vsb_if_khz;
 		break;
@@ -517,7 +517,7 @@ static int lgdt3305_set_if(struct lgdt3305_state *state,
 
 	nco = if_freq_khz / 10;
 
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		nco <<= 24;
 		do_div(nco, 625);
@@ -677,13 +677,13 @@ fail:
 	return ret;
 }
 
-static int lgdt3304_set_parameters(struct dvb_frontend *fe,
-				   struct dvb_frontend_parameters *param)
+static int lgdt3304_set_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgdt3305_state *state = fe->demodulator_priv;
 	int ret;
 
-	lg_dbg("(%d, %d)\n", param->frequency, param->u.vsb.modulation);
+	lg_dbg("(%d, %d)\n", p->frequency, p->modulation);
 
 	if (fe->ops.tuner_ops.set_params) {
 		ret = fe->ops.tuner_ops.set_params(fe);
@@ -691,23 +691,23 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (lg_fail(ret))
 			goto fail;
-		state->current_frequency = param->frequency;
+		state->current_frequency = p->frequency;
 	}
 
-	ret = lgdt3305_set_modulation(state, param);
+	ret = lgdt3305_set_modulation(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
-	ret = lgdt3305_passband_digital_agc(state, param);
+	ret = lgdt3305_passband_digital_agc(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
-	ret = lgdt3305_agc_setup(state, param);
+	ret = lgdt3305_agc_setup(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
 	/* reg 0x030d is 3304-only... seen in vsb and qam usbsnoops... */
-	switch (param->u.vsb.modulation) {
+	switch (p->modulation) {
 	case VSB_8:
 		lgdt3305_write_reg(state, 0x030d, 0x00);
 		lgdt3305_write_reg(state, LGDT3305_CR_CTR_FREQ_1, 0x4f);
@@ -718,7 +718,7 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe,
 	case QAM_64:
 	case QAM_256:
 		lgdt3305_write_reg(state, 0x030d, 0x14);
-		ret = lgdt3305_set_if(state, param);
+		ret = lgdt3305_set_if(state, p);
 		if (lg_fail(ret))
 			goto fail;
 		break;
@@ -727,13 +727,13 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe,
 	}
 
 
-	ret = lgdt3305_spectral_inversion(state, param,
+	ret = lgdt3305_spectral_inversion(state, p,
 					  state->cfg->spectral_inversion
 					  ? 1 : 0);
 	if (lg_fail(ret))
 		goto fail;
 
-	state->current_modulation = param->u.vsb.modulation;
+	state->current_modulation = p->modulation;
 
 	ret = lgdt3305_mpeg_mode(state, state->cfg->mpeg_mode);
 	if (lg_fail(ret))
@@ -747,13 +747,13 @@ fail:
 	return ret;
 }
 
-static int lgdt3305_set_parameters(struct dvb_frontend *fe,
-				   struct dvb_frontend_parameters *param)
+static int lgdt3305_set_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgdt3305_state *state = fe->demodulator_priv;
 	int ret;
 
-	lg_dbg("(%d, %d)\n", param->frequency, param->u.vsb.modulation);
+	lg_dbg("(%d, %d)\n", p->frequency, p->modulation);
 
 	if (fe->ops.tuner_ops.set_params) {
 		ret = fe->ops.tuner_ops.set_params(fe);
@@ -761,20 +761,20 @@ static int lgdt3305_set_parameters(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (lg_fail(ret))
 			goto fail;
-		state->current_frequency = param->frequency;
+		state->current_frequency = p->frequency;
 	}
 
-	ret = lgdt3305_set_modulation(state, param);
+	ret = lgdt3305_set_modulation(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
-	ret = lgdt3305_passband_digital_agc(state, param);
+	ret = lgdt3305_passband_digital_agc(state, p);
 	if (lg_fail(ret))
 		goto fail;
-	ret = lgdt3305_set_agc_power_ref(state, param);
+	ret = lgdt3305_set_agc_power_ref(state, p);
 	if (lg_fail(ret))
 		goto fail;
-	ret = lgdt3305_agc_setup(state, param);
+	ret = lgdt3305_agc_setup(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
@@ -786,20 +786,20 @@ static int lgdt3305_set_parameters(struct dvb_frontend *fe,
 	if (lg_fail(ret))
 		goto fail;
 
-	ret = lgdt3305_set_if(state, param);
+	ret = lgdt3305_set_if(state, p);
 	if (lg_fail(ret))
 		goto fail;
-	ret = lgdt3305_spectral_inversion(state, param,
+	ret = lgdt3305_spectral_inversion(state, p,
 					  state->cfg->spectral_inversion
 					  ? 1 : 0);
 	if (lg_fail(ret))
 		goto fail;
 
-	ret = lgdt3305_set_filter_extension(state, param);
+	ret = lgdt3305_set_filter_extension(state, p);
 	if (lg_fail(ret))
 		goto fail;
 
-	state->current_modulation = param->u.vsb.modulation;
+	state->current_modulation = p->modulation;
 
 	ret = lgdt3305_mpeg_mode(state, state->cfg->mpeg_mode);
 	if (lg_fail(ret))
@@ -814,14 +814,14 @@ fail:
 }
 
 static int lgdt3305_get_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *param)
+				 struct dtv_frontend_properties *p)
 {
 	struct lgdt3305_state *state = fe->demodulator_priv;
 
 	lg_dbg("\n");
 
-	param->u.vsb.modulation = state->current_modulation;
-	param->frequency = state->current_frequency;
+	p->modulation = state->current_modulation;
+	p->frequency = state->current_frequency;
 	return 0;
 }
 
@@ -1176,8 +1176,8 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 	},
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
-	.set_frontend_legacy         = lgdt3304_set_parameters,
-	.get_frontend_legacy = lgdt3305_get_frontend,
+	.set_frontend         = lgdt3304_set_parameters,
+	.get_frontend         = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
 	.read_ber             = lgdt3305_read_ber,
@@ -1188,6 +1188,7 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 };
 
 static struct dvb_frontend_ops lgdt3305_ops = {
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3305 VSB/QAM Frontend",
 		.type               = FE_ATSC,
@@ -1199,8 +1200,8 @@ static struct dvb_frontend_ops lgdt3305_ops = {
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
 	.sleep                = lgdt3305_sleep,
-	.set_frontend_legacy         = lgdt3305_set_parameters,
-	.get_frontend_legacy = lgdt3305_get_frontend,
+	.set_frontend         = lgdt3305_set_parameters,
+	.get_frontend         = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
 	.read_status          = lgdt3305_read_status,
 	.read_ber             = lgdt3305_read_ber,
-- 
1.7.8.352.g876a6

