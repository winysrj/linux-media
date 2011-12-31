Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1LaMdj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:33:39 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVCXdne007398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 07:33:39 -0500
Received: from [10.3.230.236] (vpn-230-236.phx2.redhat.com [10.3.230.236])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id pBVCXZFb032295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 07:33:37 -0500
Message-ID: <4EFF011E.6050406@redhat.com>
Date: Sat, 31 Dec 2011 10:33:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] cxd2820/af9013/af9015 conversion to DVBv5 parameters
References: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325326980-27464-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31-12-2011 08:22, Mauro Carvalho Chehab wrote:
> Due to the recent changes on those 3 drivers, applied upstream, I've
> discarded the previous patches I had, and made 3 other ones:
> 
>   [media] cxd2820: convert get|set_fontend to use DVBv5 parameters
>   [media] af9013: convert get|set_fontend to use DVBv5 parameters
>   [media] af9015: convert set_fontend to use DVBv5 parameters
> 
> They're trivial ones: just remove the DVBv3 parameters from the calls.
> A few other patches at my series also suffered minor merge conflicts,
> with an obvious solution. The entire series is at my sixth rebase of
> the DVBv5 patches, at:
> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/DVBv5-v6
> 
> And has 142 patches. I'll merge it today, as it is not fun to rebase
> a tree like that. If bugs are discovered on them, they'll be fixed on
> separate patches anyway, so there's no point on holding it forever.
> 
> I may eventually modify a them a little bit, when applying upstream,
> in order to make checkpatch happy with the patches.

Ok, fixed several coding style issues (still, I was too lazy to fix
everything).

As reference, I'm enclosing the diff between upstream and my
experimental tree. Everything here should be just coding style
fixes ;)


diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 352b27f..b79629f 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -148,7 +148,7 @@ static int thomson_dtt7579_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int thomson_dtt7579_tuner_calc_regs(struct dvb_frontend* fe, u8* pllbuf, int buf_len)
+static int thomson_dtt7579_tuner_calc_regs(struct dvb_frontend *fe, u8* pllbuf, int buf_len)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
@@ -192,7 +192,7 @@ static struct zl10353_config thomson_dtt7579_zl10353_config = {
 	.demod_address = 0x0f,
 };
 
-static int cx24108_tuner_set_params(struct dvb_frontend* fe)
+static int cx24108_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 freq = c->frequency;
@@ -267,7 +267,7 @@ static struct cx24110_config pctvsat_config = {
 	.demod_address = 0x55,
 };
 
-static int microtune_mt7202dtf_tuner_set_params(struct dvb_frontend* fe)
+static int microtune_mt7202dtf_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
@@ -343,7 +343,7 @@ static int advbt771_samsung_tdtc9251dh0_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int advbt771_samsung_tdtc9251dh0_tuner_calc_regs(struct dvb_frontend* fe, u8* pllbuf, int buf_len)
+static int advbt771_samsung_tdtc9251dh0_tuner_calc_regs(struct dvb_frontend *fe, u8 *pllbuf, int buf_len)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 div;
@@ -463,7 +463,7 @@ static struct or51211_config or51211_config = {
 	.sleep = or51211_sleep,
 };
 
-static int vp3021_alps_tded4_tuner_set_params(struct dvb_frontend* fe)
+static int vp3021_alps_tded4_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
@@ -516,7 +516,7 @@ static int digitv_alps_tded4_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int digitv_alps_tded4_tuner_calc_regs(struct dvb_frontend* fe,  u8* pllbuf, int buf_len)
+static int digitv_alps_tded4_tuner_calc_regs(struct dvb_frontend *fe,  u8 *pllbuf, int buf_len)
 {
 	u32 div;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 1ee2e7f..0a080c3 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -281,7 +281,7 @@ struct dvb_frontend_ops {
 	enum dvbfe_algo (*get_frontend_algo)(struct dvb_frontend *fe);
 
 	/* these two are only used for the swzigzag code */
-	int (*set_frontend)(struct dvb_frontend* fe);
+	int (*set_frontend)(struct dvb_frontend *fe);
 	int (*get_tune_settings)(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* settings);
 
 	int (*get_frontend)(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/dvb/dvb-usb/af9005-fe.c
index 27ad0a3..0e1b04f 100644
--- a/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ b/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -930,7 +930,8 @@ static int af9005_fe_init(struct dvb_frontend *fe)
 
 	/* init other parameters: program cfoe and select bandwidth */
 	deb_info("program cfoe\n");
-	if ((ret = af9005_fe_program_cfoe(state->d, 6000000)))
+	ret = af9005_fe_program_cfoe(state->d, 6000000);
+	if (ret)
 		return ret;
 	/* set read-update bit for modulation */
 	deb_info("set read-update bit for modulation\n");
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 0b85564..0315db8 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -276,15 +276,15 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
 	param.flags = 0;
 
 	switch (fep->bandwidth_hz) {
-		case 8000000:
-			param.bandwidth = 0;
-			break;
-		case 7000000:
-			param.bandwidth = 1;
-			break;
-		case 6000000:
-			param.bandwidth = 2;
-			break;
+	case 8000000:
+		param.bandwidth = 0;
+		break;
+	case 7000000:
+		param.bandwidth = 1;
+		break;
+	case 6000000:
+		param.bandwidth = 2;
+		break;
 	}
 
 	err = dvb_usb_generic_rw(state->d,
diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
index 270747d..c94da3c 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
@@ -100,7 +100,7 @@ static int dtt200u_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_fron
 	return 0;
 }
 
-static int dtt200u_fe_set_frontend(struct dvb_frontend* fe)
+static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
@@ -110,11 +110,17 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend* fe)
 	u8 bwbuf[2] = { SET_BANDWIDTH, 0 },freqbuf[3] = { SET_RF_FREQ, 0, 0 };
 
 	switch (fep->bandwidth_hz) {
-		case 8000000: bwbuf[1] = 8; break;
-		case 7000000: bwbuf[1] = 7; break;
-		case 6000000: bwbuf[1] = 6; break;
-		default:
-			return -EINVAL;
+	case 8000000:
+		bwbuf[1] = 8;
+		break;
+	case 7000000:
+		bwbuf[1] = 7;
+		break;
+	case 6000000:
+		bwbuf[1] = 6;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	dvb_usb_generic_write(state->d,bwbuf,2);
@@ -137,7 +143,7 @@ static int dtt200u_fe_get_frontend(struct dvb_frontend* fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	memcpy(fep,&state->fep,sizeof(struct dtv_frontend_properties));
+	memcpy(fep, &state->fep, sizeof(struct dtv_frontend_properties));
 	return 0;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index c40168f..79db9d6 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -113,7 +113,7 @@ static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int gp8psk_fe_set_frontend(struct dvb_frontend* fe)
+static int gp8psk_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct gp8psk_fe_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 178e938..8d8c6ad 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -135,7 +135,7 @@ static int vp702x_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int vp702x_fe_set_frontend(struct dvb_frontend* fe)
+static int vp702x_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct vp702x_fe_state *st = fe->demodulator_priv;
@@ -162,7 +162,7 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe)
 	cmd[5] = (sr << 4)  & 0xf0;
 
 	deb_fe("setting frontend to: %u -> %u (%x) LNB-based GHz, symbolrate: %d -> %lu (%lx)\n",
-			fep->frequency,freq,freq, fep->symbol_rate,
+			fep->frequency, freq, freq, fep->symbol_rate,
 			(unsigned long) sr, (unsigned long) sr);
 
 /*	if (fep->inversion == INVERSION_ON)
diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/dvb/dvb-usb/vp7045-fe.c
index 53d658a0..ecbd623 100644
--- a/drivers/media/dvb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp7045-fe.c
@@ -103,7 +103,7 @@ static int vp7045_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int vp7045_fe_set_frontend(struct dvb_frontend* fe)
+static int vp7045_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct vp7045_fe_state *state = fe->demodulator_priv;
@@ -116,11 +116,17 @@ static int vp7045_fe_set_frontend(struct dvb_frontend* fe)
 	buf[3] = 0;
 
 	switch (fep->bandwidth_hz) {
-		case 8000000: buf[4] = 8; break;
-		case 7000000: buf[4] = 7; break;
-		case 6000000: buf[4] = 6; break;
-		default:
-			return -EINVAL;
+	case 8000000:
+		buf[4] = 8;
+		break;
+	case 7000000:
+		buf[4] = 7;
+		break;
+	case 6000000:
+		buf[4] = 6;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	vp7045_usb_op(state->d,LOCK_TUNER_COMMAND,buf,5,NULL,0,200);
diff --git a/drivers/media/dvb/frontends/bsbe1.h b/drivers/media/dvb/frontends/bsbe1.h
index f482b10..53e4d0d 100644
--- a/drivers/media/dvb/frontends/bsbe1.h
+++ b/drivers/media/dvb/frontends/bsbe1.h
@@ -69,7 +69,7 @@ static int alps_bsbe1_set_symbol_rate(struct dvb_frontend* fe, u32 srate, u32 ra
 	return 0;
 }
 
-static int alps_bsbe1_tuner_set_params(struct dvb_frontend* fe)
+static int alps_bsbe1_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret;
diff --git a/drivers/media/dvb/frontends/bsru6.h b/drivers/media/dvb/frontends/bsru6.h
index 686df0c..c2a578e 100644
--- a/drivers/media/dvb/frontends/bsru6.h
+++ b/drivers/media/dvb/frontends/bsru6.h
@@ -112,7 +112,7 @@ static int alps_bsru6_tuner_set_params(struct dvb_frontend *fe)
 	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = (p->frequency + (125 - 1)) / 125;	// round correctly
+	div = (p->frequency + (125 - 1)) / 125;	/* round correctly */
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index d5d61a5..a5b1521 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -320,7 +320,7 @@ static int cx22700_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int cx22700_set_frontend(struct dvb_frontend* fe)
+static int cx22700_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx22700_state* state = fe->demodulator_priv;
@@ -341,7 +341,7 @@ static int cx22700_set_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int cx22700_get_frontend(struct dvb_frontend* fe)
+static int cx22700_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx22700_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index 587c3ec..a0dcbd6 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -622,7 +622,7 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.init = cx22702_init,
 	.i2c_gate_ctrl = cx22702_i2c_gate_ctrl,
 
-	.set_frontend= cx22702_set_tps,
+	.set_frontend = cx22702_set_tps,
 	.get_frontend = cx22702_get_frontend,
 	.get_tune_settings = cx22702_get_tune_settings,
 
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 98014fc..2f07c49 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -531,7 +531,7 @@ static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int cx24110_set_frontend(struct dvb_frontend* fe)
+static int cx24110_set_frontend(struct dvb_frontend *fe)
 {
 	struct cx24110_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -549,7 +549,7 @@ static int cx24110_set_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int cx24110_get_frontend(struct dvb_frontend* fe)
+static int cx24110_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx24110_state *state = fe->demodulator_priv;
@@ -572,7 +572,7 @@ static int cx24110_get_frontend(struct dvb_frontend* fe)
 	p->frequency += afc;
 	p->inversion = (cx24110_readreg (state, 0x22) & 0x10) ?
 				INVERSION_ON : INVERSION_OFF;
-	p->fec_inner = cx24110_get_fec (state);
+	p->fec_inner = cx24110_get_fec(state);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index 01a1e30..a1c5bdb 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -114,7 +114,7 @@ static u16 dib3000_seq[2][2][2] =     /* fft,gua,   inv   */
 
 static int dib3000mb_get_frontend(struct dvb_frontend* fe);
 
-static int dib3000mb_set_frontend(struct dvb_frontend* fe, int tuner)
+static int dib3000mb_set_frontend(struct dvb_frontend *fe, int tuner)
 {
 	struct dib3000_state* state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -697,7 +697,7 @@ static int dib3000mb_fe_init_nonmobile(struct dvb_frontend* fe)
 	return dib3000mb_fe_init(fe, 0);
 }
 
-static int dib3000mb_set_frontend_and_tuner(struct dvb_frontend* fe)
+static int dib3000mb_set_frontend_and_tuner(struct dvb_frontend *fe)
 {
 	return dib3000mb_set_frontend(fe, 1);
 }
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index f2ad9ae..e500b89 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -687,7 +687,7 @@ static int dib3000mc_get_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int dib3000mc_set_frontend(struct dvb_frontend* fe)
+static int dib3000mc_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dib3000mc_state *state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index aa6a798..2a2d646 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -1212,7 +1212,7 @@ static int dib7000m_get_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int dib7000m_set_frontend(struct dvb_frontend* fe)
+static int dib7000m_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dib7000m_state *state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 95cb042..1ab3483 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -622,7 +622,8 @@ static int dvb_pll_set_params(struct dvb_frontend *fe)
 	if (priv->i2c == NULL)
 		return -EINVAL;
 
-	if ((result = dvb_pll_configure(fe, buf, c->frequency)) < 0)
+	result = dvb_pll_configure(fe, buf, c->frequency);
+	if (result < 0)
 		return result;
 	else
 		frequency = result;
@@ -650,7 +651,8 @@ static int dvb_pll_calc_regs(struct dvb_frontend *fe,
 	if (buf_len < 5)
 		return -EINVAL;
 
-	if ((result = dvb_pll_configure(fe, buf+1, c->frequency)) < 0)
+	result = dvb_pll_configure(fe, buf + 1, c->frequency);
+	if (result < 0)
 		return result;
 	else
 		frequency = result;
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb/frontends/dvb_dummy_fe.c
index 0f0796b..ac4c8d2 100644
--- a/drivers/media/dvb/frontends/dvb_dummy_fe.c
+++ b/drivers/media/dvb/frontends/dvb_dummy_fe.c
@@ -76,7 +76,7 @@ static int dvb_dummy_fe_get_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int dvb_dummy_fe_set_frontend(struct dvb_frontend* fe)
+static int dvb_dummy_fe_set_frontend(struct dvb_frontend *fe)
 {
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 187d9ea..754d0f5 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -286,7 +286,7 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 		return -EINVAL;
 	set_tuner[0].reg[0] = lna_band;
 
-	switch(bandwidth) {
+	switch (bandwidth) {
 	case 5000000:
 		bw = 0;
 		break;
@@ -392,7 +392,7 @@ static int it913x_fe_select_bw(struct it913x_fe_state *state,
 
 	deb_info("Bandwidth %d Adc %d", bandwidth, adcFrequency);
 
-	switch(bandwidth) {
+	switch (bandwidth) {
 	case 5000000:
 		bw = 3;
 		break;
@@ -582,7 +582,7 @@ static int it913x_fe_get_frontend(struct dvb_frontend *fe)
 	ret = it913x_read_reg(state, REG_TPSD_TX_MODE, reg, sizeof(reg));
 
 	if (reg[3] < 3)
-		p->modulation= fe_con[reg[3]];
+		p->modulation = fe_con[reg[3]];
 
 	if (reg[0] < 3)
 		p->transmission_mode = fe_mode[reg[0]];
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index 4fc6dda..dc3e42c 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -117,7 +117,7 @@ static int reset_and_configure (struct l64781_state* state)
 	return (i2c_transfer(state->i2c, &msg, 1) == 1) ? 0 : -ENODEV;
 }
 
-static int apply_frontend_param (struct dvb_frontend* fe)
+static int apply_frontend_param(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct l64781_state* state = fe->demodulator_priv;
@@ -243,7 +243,7 @@ static int apply_frontend_param (struct dvb_frontend* fe)
 	return 0;
 }
 
-static int get_frontend(struct dvb_frontend* fe)
+static int get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct l64781_state* state = fe->demodulator_priv;
@@ -273,7 +273,7 @@ static int get_frontend(struct dvb_frontend* fe)
 		p->transmission_mode = TRANSMISSION_MODE_8K;
 		break;
 	default:
-		printk("Unexpected value for transmission_mode\n");
+		printk(KERN_WARNING "Unexpected value for transmission_mode\n");
 	}
 
 	tmp = l64781_readreg(state, 0x05);
@@ -328,7 +328,7 @@ static int get_frontend(struct dvb_frontend* fe)
 		p->modulation = QAM_64;
 		break;
 	default:
-		printk("Unexpected value for modulation\n");
+		printk(KERN_WARNING "Unexpected value for modulation\n");
 	}
 	switch((tmp >> 2) & 7) {
 	case 0:
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 61e99f5..0e6f41b 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -311,7 +311,7 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int lgdt330x_set_parameters(struct dvb_frontend* fe)
+static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	/*
@@ -350,7 +350,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe)
 	int err = 0;
 	/* Change only if we are actually changing the modulation */
 	if (state->current_modulation != p->modulation) {
-		switch(p->modulation) {
+		switch (p->modulation) {
 		case VSB_8:
 			dprintk("%s: VSB_8 MODE\n", __func__);
 
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 84129ae..0321eec 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -166,7 +166,7 @@ static void mt352_calc_input_freq(struct mt352_state* state,
 	buf[1] = lsb(value);
 }
 
-static int mt352_set_parameters(struct dvb_frontend* fe)
+static int mt352_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *op = &fe->dtv_property_cache;
 	struct mt352_state* state = fe->demodulator_priv;
@@ -399,7 +399,7 @@ static int mt352_get_parameters(struct dvb_frontend* fe)
 			break;
 	}
 
-	op->frequency = ( 500 * (div - IF_FREQUENCYx6) ) / 3 * 1000;
+	op->frequency = (500 * (div - IF_FREQUENCYx6)) / 3 * 1000;
 
 	if (trl == 0x72)
 		op->bandwidth_hz = 8000000;
diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index 389f490..89021bd 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -81,7 +81,7 @@ static void nxt6000_reset(struct nxt6000_state* state)
 	nxt6000_writereg(state, OFDM_COR_CTL, val | COREACT);
 }
 
-static int nxt6000_set_bandwidth(struct nxt6000_state* state, u32 bandwidth)
+static int nxt6000_set_bandwidth(struct nxt6000_state *state, u32 bandwidth)
 {
 	u16 nominal_rate;
 	int result;
@@ -456,7 +456,7 @@ static int nxt6000_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int nxt6000_set_frontend(struct dvb_frontend* fe)
+static int nxt6000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct nxt6000_state* state = fe->demodulator_priv;
@@ -467,13 +467,20 @@ static int nxt6000_set_frontend(struct dvb_frontend* fe)
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	if ((result = nxt6000_set_bandwidth(state, p->bandwidth_hz)) < 0)
+	result = nxt6000_set_bandwidth(state, p->bandwidth_hz);
+	if (result < 0)
 		return result;
-	if ((result = nxt6000_set_guard_interval(state, p->guard_interval)) < 0)
+
+	result = nxt6000_set_guard_interval(state, p->guard_interval);
+	if (result < 0)
 		return result;
-	if ((result = nxt6000_set_transmission_mode(state, p->transmission_mode)) < 0)
+
+	result = nxt6000_set_transmission_mode(state, p->transmission_mode);
+	if (result < 0)
 		return result;
-	if ((result = nxt6000_set_inversion(state, p->inversion)) < 0)
+
+	result = nxt6000_set_inversion(state, p->inversion);
+	if (result < 0)
 		return result;
 
 	msleep(500);
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 5bb6f3e..82ee2959 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -306,7 +306,7 @@ static int modulation_fw_class(fe_modulation_t modulation)
 	}
 }
 
-static int or51132_set_parameters(struct dvb_frontend* fe)
+static int or51132_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret;
@@ -318,7 +318,7 @@ static int or51132_set_parameters(struct dvb_frontend* fe)
 	/* Upload new firmware only if we need a different one */
 	if (modulation_fw_class(state->current_modulation) !=
 	    modulation_fw_class(p->modulation)) {
-		switch(modulation_fw_class(p->modulation)) {
+		switch (modulation_fw_class(p->modulation)) {
 		case MOD_FWCLASS_VSB:
 			dprintk("set_parameters VSB MODE\n");
 			fwname = OR51132_VSB_FIRMWARE;
@@ -389,14 +389,21 @@ start:
 		return -EREMOTEIO;
 	}
 	switch(status&0xff) {
-		case 0x06: p->modulation = VSB_8; break;
-		case 0x43: p->modulation = QAM_64; break;
-		case 0x45: p->modulation = QAM_256; break;
-		default:
-			if (retry--) goto start;
-			printk(KERN_WARNING "or51132: unknown status 0x%02x\n",
-			       status&0xff);
-			return -EREMOTEIO;
+	case 0x06:
+		p->modulation = VSB_8;
+		break;
+	case 0x43:
+		p->modulation = QAM_64;
+		break;
+	case 0x45:
+		p->modulation = QAM_256;
+		break;
+	default:
+		if (retry--)
+			goto start;
+		printk(KERN_WARNING "or51132: unknown status 0x%02x\n",
+		       status&0xff);
+		return -EREMOTEIO;
 	}
 
 	/* FIXME: Read frequency from frontend, take AFC into account */
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 58ddf55..d2b52e5 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -218,7 +218,7 @@ static int or51211_setmode(struct dvb_frontend* fe, int mode)
 	return 0;
 }
 
-static int or51211_set_parameters(struct dvb_frontend* fe)
+static int or51211_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct or51211_state* state = fe->demodulator_priv;
@@ -544,7 +544,7 @@ struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 }
 
 static struct dvb_frontend_ops or51211_ops = {
-        .delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name               = "Oren OR51211 VSB Frontend",
 		.type               = FE_ATSC,
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 3d0334a..d83d20a 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -559,7 +559,7 @@ static void s5h1420_setfec_inversion(struct s5h1420_state* state,
 		vit08 = 0x3f;
 		vit09 = 0;
 	} else {
-		switch(p->fec_inner) {
+		switch (p->fec_inner) {
 		case FEC_1_2:
 			vit08 = 0x01; vit09 = 0x10;
 			break;
@@ -628,7 +628,7 @@ static fe_spectral_inversion_t s5h1420_getinversion(struct s5h1420_state* state)
 	return INVERSION_OFF;
 }
 
-static int s5h1420_set_frontend(struct dvb_frontend* fe)
+static int s5h1420_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1420_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index bad1832..58e4792 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -480,7 +480,8 @@ static int sp8870_set_frontend(struct dvb_frontend *fe)
 
 	for (trials = 1; trials <= MAXTRIALS; trials++) {
 
-		if ((err = sp8870_set_frontend_parameters(fe)))
+		err = sp8870_set_frontend_parameters(fe);
+		if (err)
 			return err;
 
 		for (check_count = 0; check_count < MAXCHECKS; check_count++) {
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 4b28d6a..6fd8513 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -209,7 +209,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	return 0;
 };
 
-static int configure_reg0xc05 (struct dtv_frontend_properties *p, u16 *reg0xc05)
+static int configure_reg0xc05(struct dtv_frontend_properties *p, u16 *reg0xc05)
 {
 	int known_parameters = 1;
 
@@ -346,7 +346,7 @@ static void sp887x_correct_offsets (struct sp887x_state* state,
 	sp887x_writereg(state, 0x30a, frequency_shift & 0xfff);
 }
 
-static int sp887x_setup_frontend_parameters (struct dvb_frontend *fe)
+static int sp887x_setup_frontend_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct sp887x_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 114d112..a7abc82 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -559,7 +559,7 @@ static int stv0299_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int stv0299_set_frontend(struct dvb_frontend* fe)
+static int stv0299_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0299_state* state = fe->demodulator_priv;
@@ -584,8 +584,8 @@ static int stv0299_set_frontend(struct dvb_frontend* fe)
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	stv0299_set_FEC (state, p->fec_inner);
-	stv0299_set_symbolrate (fe, p->symbol_rate);
+	stv0299_set_FEC(state, p->fec_inner);
+	stv0299_set_symbolrate(fe, p->symbol_rate);
 	stv0299_writeregI(state, 0x22, 0x00);
 	stv0299_writeregI(state, 0x23, 0x00);
 
@@ -596,7 +596,7 @@ static int stv0299_set_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int stv0299_get_frontend(struct dvb_frontend* fe)
+static int stv0299_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0299_state* state = fe->demodulator_priv;
@@ -616,8 +616,8 @@ static int stv0299_get_frontend(struct dvb_frontend* fe)
 	if (state->config->invert) invval = (~invval) & 1;
 	p->inversion = invval ? INVERSION_ON : INVERSION_OFF;
 
-	p->fec_inner = stv0299_get_fec (state);
-	p->symbol_rate = stv0299_get_symbolrate (state);
+	p->fec_inner = stv0299_get_fec(state);
+	p->symbol_rate = stv0299_get_symbolrate(state);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 035e0e2..a330831 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -228,7 +228,7 @@ struct qam_params {
 	u8 conf, agcref, lthr, mseth, aref;
 };
 
-static int tda10021_set_parameters (struct dvb_frontend *fe)
+static int tda10021_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys  = c->delivery_system;
@@ -279,7 +279,7 @@ static int tda10021_set_parameters (struct dvb_frontend *fe)
 	if (c->inversion != INVERSION_ON && c->inversion != INVERSION_OFF)
 		return -EINVAL;
 
-	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->symbol_rate);
+	/*printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->symbol_rate);*/
 
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
@@ -386,7 +386,7 @@ static int tda10021_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10021_get_frontend(struct dvb_frontend* fe)
+static int tda10021_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10021_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index 55d7563..d0b8e86 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -302,7 +302,7 @@ struct qam_params {
 	u8 qam, lockthr, mseth, aref, agcrefnyq, eragnyq_thd;
 };
 
-static int tda10023_set_parameters (struct dvb_frontend *fe)
+static int tda10023_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys  = c->delivery_system;
@@ -456,7 +456,7 @@ static int tda10023_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10023_get_frontend(struct dvb_frontend* fe)
+static int tda10023_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda10023_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index e180103..bbab4a1 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -473,7 +473,7 @@ static void tda10046_init_plls(struct dvb_frontend* fe)
 		tda1004x_write_byteI(state, TDA10046H_FREQ_PHY2_LSB, 0x3f);
 		break;
 	}
-	tda10046h_set_bandwidth(state, 8000000); // default bandwidth 8 MHz
+	tda10046h_set_bandwidth(state, 8000000); /* default bandwidth 8 MHz */
 	/* let the PLLs settle */
 	msleep(120);
 }
@@ -697,7 +697,7 @@ static int tda10046_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int tda1004x_set_fe(struct dvb_frontend* fe)
+static int tda1004x_set_fe(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda1004x_state* state = fe->demodulator_priv;
@@ -737,7 +737,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe)
 		(fe_params->modulation == QAM_AUTO) ||
 		(fe_params->hierarchy == HIERARCHY_AUTO)) {
 		tda1004x_write_mask(state, TDA1004X_AUTO, 1, 1);	// enable auto
-		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x03, 0);	// turn off modulation bits
+		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x03, 0);	/* turn off modulation bits */
 		tda1004x_write_mask(state, TDA1004X_IN_CONF1, 0x60, 0);	// turn off hierarchy bits
 		tda1004x_write_mask(state, TDA1004X_IN_CONF2, 0x3f, 0);	// turn off FEC bits
 	} else {
@@ -755,7 +755,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe)
 			return tmp;
 		tda1004x_write_mask(state, TDA1004X_IN_CONF2, 0x38, tmp << 3);
 
-		// set modulation
+		/* set modulation */
 		switch (fe_params->modulation) {
 		case QPSK:
 			tda1004x_write_mask(state, TDA1004X_IN_CONF1, 3, 0);
@@ -895,7 +895,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int tda1004x_get_fe(struct dvb_frontend* fe)
+static int tda1004x_get_fe(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda1004x_state* state = fe->demodulator_priv;
@@ -948,7 +948,7 @@ static int tda1004x_get_fe(struct dvb_frontend* fe)
 	fe_params->code_rate_LP =
 	    tda1004x_decode_fec((tda1004x_read_byte(state, TDA1004X_OUT_CONF2) >> 3) & 7);
 
-	// modulation
+	/* modulation */
 	switch (tda1004x_read_byte(state, TDA1004X_OUT_CONF1) & 3) {
 	case 0:
 		fe_params->modulation = QPSK;
@@ -1325,7 +1325,7 @@ static struct dvb_frontend_ops tda10046_ops = {
 	.i2c_gate_ctrl = tda1004x_i2c_gate_ctrl,
 
 	.set_frontend = tda1004x_set_fe,
-	.get_frontend= tda1004x_get_fe,
+	.get_frontend = tda1004x_get_fe,
 	.get_tune_settings = tda1004x_get_tune_settings,
 
 	.read_status = tda1004x_read_status,
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 83256d5..e0d2fc1 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -371,9 +371,9 @@ static int tda10086_set_fec(struct tda10086_state *state,
 {
 	u8 fecval;
 
-	dprintk ("%s %i\n", __func__, fe_params->fec_inner);
+	dprintk("%s %i\n", __func__, fe_params->fec_inner);
 
-	switch(fe_params->fec_inner) {
+	switch (fe_params->fec_inner) {
 	case FEC_1_2:
 		fecval = 0x00;
 		break;
@@ -409,7 +409,7 @@ static int tda10086_set_fec(struct tda10086_state *state,
 	return 0;
 }
 
-static int tda10086_set_frontend(struct dvb_frontend* fe)
+static int tda10086_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda10086_state *state = fe->demodulator_priv;
@@ -457,7 +457,7 @@ static int tda10086_set_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int tda10086_get_frontend(struct dvb_frontend* fe)
+static int tda10086_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda10086_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 7a16e8d..b613dfc 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -315,7 +315,7 @@ static int tda8083_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda8083_set_frontend(struct dvb_frontend* fe)
+static int tda8083_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda8083_state* state = fe->demodulator_priv;
@@ -326,8 +326,8 @@ static int tda8083_set_frontend(struct dvb_frontend* fe)
 	}
 
 	tda8083_set_inversion (state, p->inversion);
-	tda8083_set_fec (state, p->fec_inner);
-	tda8083_set_symbolrate (state, p->symbol_rate);
+	tda8083_set_fec(state, p->fec_inner);
+	tda8083_set_symbolrate(state, p->symbol_rate);
 
 	tda8083_writereg (state, 0x00, 0x3c);
 	tda8083_writereg (state, 0x00, 0x04);
@@ -335,7 +335,7 @@ static int tda8083_set_frontend(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int tda8083_get_frontend(struct dvb_frontend* fe)
+static int tda8083_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda8083_state* state = fe->demodulator_priv;
@@ -344,7 +344,7 @@ static int tda8083_get_frontend(struct dvb_frontend* fe)
 	/*p->frequency = ???;*/
 	p->inversion = (tda8083_readreg (state, 0x0e) & 0x80) ?
 			INVERSION_ON : INVERSION_OFF;
-	p->fec_inner = tda8083_get_fec (state);
+	p->fec_inner = tda8083_get_fec(state);
 	/*p->symbol_rate = tda8083_get_symbolrate (state);*/
 
 	return 0;
diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb/frontends/tua6100.c
index aebe260..029384d 100644
--- a/drivers/media/dvb/frontends/tua6100.c
+++ b/drivers/media/dvb/frontends/tua6100.c
@@ -85,18 +85,17 @@ static int tua6100_set_params(struct dvb_frontend *fe)
 #define _ri 4000000
 
 	// setup register 0
-	if (c->frequency < 2000000) {
+	if (c->frequency < 2000000)
 		reg0[1] = 0x03;
-	} else {
+	else
 		reg0[1] = 0x07;
-	}
 
 	// setup register 1
-	if (c->frequency < 1630000) {
+	if (c->frequency < 1630000)
 		reg1[1] = 0x2c;
-	} else {
+	else
 		reg1[1] = 0x0c;
-	}
+
 	if (_P == 64)
 		reg1[1] |= 0x40;
 	if (c->frequency >= 1525000)
@@ -105,15 +104,17 @@ static int tua6100_set_params(struct dvb_frontend *fe)
 	// register 2
 	reg2[1] = (_R >> 8) & 0x03;
 	reg2[2] = _R;
-	if (c->frequency < 1455000) {
+	if (c->frequency < 1455000)
 		reg2[1] |= 0x1c;
-	} else if (c->frequency < 1630000) {
+	else if (c->frequency < 1630000)
 		reg2[1] |= 0x0c;
-	} else {
+	else
 		reg2[1] |= 0x1c;
-	}
 
-	// The N divisor ratio (note: c->frequency is in kHz, but we need it in Hz)
+	/*
+	 * The N divisor ratio (note: c->frequency is in kHz, but we
+	 * need it in Hz)
+	 */
 	prediv = (c->frequency * _R) / (_ri / 1000);
 	div = prediv / _P;
 	reg1[1] |= (div >> 9) & 0x03;
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 37ff9f0..e85a823 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -205,7 +205,7 @@ static int ves1820_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int ves1820_set_parameters(struct dvb_frontend* fe)
+static int ves1820_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1820_state* state = fe->demodulator_priv;
@@ -310,7 +310,7 @@ static int ves1820_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int ves1820_get_frontend(struct dvb_frontend* fe)
+static int ves1820_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1820_state* state = fe->demodulator_priv;
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index 13f3a21..0ccd851 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -385,7 +385,7 @@ static int ves1x93_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int ves1x93_set_frontend(struct dvb_frontend* fe)
+static int ves1x93_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1x93_state* state = fe->demodulator_priv;
@@ -395,15 +395,15 @@ static int ves1x93_set_frontend(struct dvb_frontend* fe)
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 	ves1x93_set_inversion (state, p->inversion);
-	ves1x93_set_fec (state, p->fec_inner);
-	ves1x93_set_symbolrate (state, p->symbol_rate);
+	ves1x93_set_fec(state, p->fec_inner);
+	ves1x93_set_symbolrate(state, p->symbol_rate);
 	state->inversion = p->inversion;
 	state->frequency = p->frequency;
 
 	return 0;
 }
 
-static int ves1x93_get_frontend(struct dvb_frontend* fe)
+static int ves1x93_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1x93_state* state = fe->demodulator_priv;
@@ -421,7 +421,7 @@ static int ves1x93_get_frontend(struct dvb_frontend* fe)
 	if (state->inversion == INVERSION_AUTO)
 		p->inversion = (ves1x93_readreg (state, 0x0f) & 2) ?
 				INVERSION_OFF : INVERSION_ON;
-	p->fec_inner = ves1x93_get_fec (state);
+	p->fec_inner = ves1x93_get_fec(state);
 	/*  XXX FIXME: timing offset !! */
 
 	return 0;
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index e0df729..6ecbcf6 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -1568,7 +1568,7 @@ static int get_firmware(struct av7110* av7110)
 	return ret;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1577,12 +1577,18 @@ static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
 	u32 div = (p->frequency + 479500) / 125;
 
-	if (p->frequency > 2000000) pwr = 3;
-	else if (p->frequency > 1800000) pwr = 2;
-	else if (p->frequency > 1600000) pwr = 1;
-	else if (p->frequency > 1200000) pwr = 0;
-	else if (p->frequency >= 1100000) pwr = 1;
-	else pwr = 2;
+	if (p->frequency > 2000000)
+		pwr = 3;
+	else if (p->frequency > 1800000)
+		pwr = 2;
+	else if (p->frequency > 1600000)
+		pwr = 1;
+	else if (p->frequency > 1200000)
+		pwr = 0;
+	else if (p->frequency >= 1100000)
+		pwr = 1;
+	else
+		pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
@@ -1605,7 +1611,7 @@ static struct ves1x93_config alps_bsrv2_config = {
 	.invert_pwm = 0,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1637,7 +1643,7 @@ static struct ves1820_config alps_tdbe2_config = {
 
 
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1664,7 +1670,7 @@ static struct tda8083_config grundig_29504_451_config = {
 
 
 
-static int philips_cd1516_tuner_set_params(struct dvb_frontend* fe)
+static int philips_cd1516_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1696,7 +1702,7 @@ static struct ves1820_config philips_cd1516_config = {
 
 
 
-static int alps_tdlb7_tuner_set_params(struct dvb_frontend* fe)
+static int alps_tdlb7_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1834,7 +1840,7 @@ static u8 nexusca_stv0297_inittab[] = {
 	0xff, 0xff,
 };
 
-static int nexusca_stv0297_tuner_set_params(struct dvb_frontend* fe)
+static int nexusca_stv0297_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1890,7 +1896,7 @@ static struct stv0297_config nexusca_stv0297_config = {
 
 
 
-static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
+static int grundig_29504_401_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct av7110* av7110 = fe->dvb->priv;
@@ -1903,15 +1909,23 @@ static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
 
 	cfg = 0x88;
 
-	if (p->frequency < 175000000) cpump = 2;
-	else if (p->frequency < 390000000) cpump = 1;
-	else if (p->frequency < 470000000) cpump = 2;
-	else if (p->frequency < 750000000) cpump = 1;
-	else cpump = 3;
+	if (p->frequency < 175000000)
+		cpump = 2;
+	else if (p->frequency < 390000000)
+		cpump = 1;
+	else if (p->frequency < 470000000)
+		cpump = 2;
+	else if (p->frequency < 750000000)
+		cpump = 1;
+	else
+		cpump = 3;
 
-	if (p->frequency < 175000000) band_select = 0x0e;
-	else if (p->frequency < 470000000) band_select = 0x05;
-	else band_select = 0x03;
+	if (p->frequency < 175000000)
+		band_select = 0x0e;
+	else if (p->frequency < 470000000)
+		band_select = 0x05;
+	else
+		band_select = 0x03;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/dvb/ttpci/av7110.h
index 16f0e0e..88b3b2d 100644
--- a/drivers/media/dvb/ttpci/av7110.h
+++ b/drivers/media/dvb/ttpci/av7110.h
@@ -285,7 +285,7 @@ struct av7110 {
 	int (*fe_set_tone)(struct dvb_frontend* fe, fe_sec_tone_mode_t tone);
 	int (*fe_set_voltage)(struct dvb_frontend* fe, fe_sec_voltage_t voltage);
 	int (*fe_dishnetwork_send_legacy_command)(struct dvb_frontend* fe, unsigned long cmd);
-	int (*fe_set_frontend)(struct dvb_frontend* fe);
+	int (*fe_set_frontend)(struct dvb_frontend *fe);
 };
 
 
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index d6a083b..8b32e28 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -513,7 +513,7 @@ static int philips_su1278_ty_ci_tuner_set_params(struct dvb_frontend *fe)
 	if ((c->frequency < 950000) || (c->frequency > 2150000))
 		return -EINVAL;
 
-	div = (c->frequency + (125 - 1)) / 125;	// round correctly
+	div = (c->frequency + (125 - 1)) / 125;	/* round correctly */
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 9a2d3a0..98e5241 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -671,7 +671,7 @@ static int philips_su1278_tt_tuner_set_params(struct dvb_frontend *fe)
 	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = (p->frequency + (500 - 1)) / 500;	// round correctly
+	div = (p->frequency + (500 - 1)) / 500;	/* round correctly */
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 2;
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 1dda7ed..2cb35c2 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -261,7 +261,7 @@ static int budget_patch_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_c
 	return 0;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
@@ -270,11 +270,16 @@ static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
 	u32 div = (p->frequency + 479500) / 125;
 
-	if (p->frequency > 2000000) pwr = 3;
-	else if (p->frequency > 1800000) pwr = 2;
-	else if (p->frequency > 1600000) pwr = 1;
-	else if (p->frequency > 1200000) pwr = 0;
-	else if (p->frequency >= 1100000) pwr = 1;
+	if (p->frequency > 2000000)
+		pwr = 3;
+	else if (p->frequency > 1800000)
+		pwr = 2;
+	else if (p->frequency > 1600000)
+		pwr = 1;
+	else if (p->frequency > 1200000)
+		pwr = 0;
+	else if (p->frequency >= 1100000)
+		pwr = 1;
 	else pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
@@ -298,7 +303,7 @@ static struct ves1x93_config alps_bsrv2_config = {
 	.invert_pwm = 0,
 };
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 10fcc02..b21bcce 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -200,7 +200,7 @@ static int budget_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t m
 	return 0;
 }
 
-static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_bsrv2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -209,11 +209,16 @@ static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe)
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
 	u32 div = (c->frequency + 479500) / 125;
 
-	if (c->frequency > 2000000) pwr = 3;
-	else if (c->frequency > 1800000) pwr = 2;
-	else if (c->frequency > 1600000) pwr = 1;
-	else if (c->frequency > 1200000) pwr = 0;
-	else if (c->frequency >= 1100000) pwr = 1;
+	if (c->frequency > 2000000)
+		pwr = 3;
+	else if (c->frequency > 1800000)
+		pwr = 2;
+	else if (c->frequency > 1600000)
+		pwr = 1;
+	else if (c->frequency > 1200000)
+		pwr = 0;
+	else if (c->frequency >= 1100000)
+		pwr = 1;
 	else pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
@@ -237,7 +242,7 @@ static struct ves1x93_config alps_bsrv2_config =
 	.invert_pwm = 0,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -265,7 +270,7 @@ static struct ves1820_config alps_tdbe2_config = {
 	.selagc = VES1820_SELAGC_SIGNAMPERR,
 };
 
-static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
+static int grundig_29504_401_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget *budget = fe->dvb->priv;
@@ -284,15 +289,23 @@ static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe)
 
 	cfg = 0x88;
 
-	if (c->frequency < 175000000) cpump = 2;
-	else if (c->frequency < 390000000) cpump = 1;
-	else if (c->frequency < 470000000) cpump = 2;
-	else if (c->frequency < 750000000) cpump = 1;
-	else cpump = 3;
+	if (c->frequency < 175000000)
+		cpump = 2;
+	else if (c->frequency < 390000000)
+		cpump = 1;
+	else if (c->frequency < 470000000)
+		cpump = 2;
+	else if (c->frequency < 750000000)
+		cpump = 1;
+	else
+		cpump = 3;
 
-	if (c->frequency < 175000000) band_select = 0x0e;
-	else if (c->frequency < 470000000) band_select = 0x05;
-	else band_select = 0x03;
+	if (c->frequency < 175000000)
+		band_select = 0x0e;
+	else if (c->frequency < 470000000)
+		band_select = 0x05;
+	else
+		band_select = 0x03;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
@@ -315,7 +328,7 @@ static struct l64781_config grundig_29504_401_config_activy = {
 
 static u8 tuner_address_grundig_29504_401_activy = 0x60;
 
-static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe)
+static int grundig_29504_451_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
@@ -339,7 +352,7 @@ static struct tda8083_config grundig_29504_451_config = {
 	.demod_address = 0x68,
 };
 
-static int s5h1420_tuner_set_params(struct dvb_frontend* fe)
+static int s5h1420_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct budget* budget = (struct budget*) fe->dvb->priv;
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 514eff0..5f6ac48 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1017,7 +1017,7 @@ static u32 functionality(struct i2c_adapter *adapter)
 
 
 
-static int alps_tdmb7_tuner_set_params(struct dvb_frontend* fe)
+static int alps_tdmb7_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1072,7 +1072,7 @@ static int philips_tdm1316l_tuner_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int philips_tdm1316l_tuner_set_params(struct dvb_frontend* fe)
+static int philips_tdm1316l_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = (struct ttusb*) fe->dvb->priv;
@@ -1351,7 +1351,7 @@ static struct tda8083_config ttusb_novas_grundig_29504_491_config = {
 	.demod_address = 0x68,
 };
 
-static int alps_tdbe2_tuner_set_params(struct dvb_frontend* fe)
+static int alps_tdbe2_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusb* ttusb = fe->dvb->priv;
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index 96e2fdb..a498f5a 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -87,7 +87,7 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend* fe)
+static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusbdecfe_state* state = (struct ttusbdecfe_state*) fe->demodulator_priv;
@@ -114,7 +114,7 @@ static int ttusbdecfe_dvbt_get_tune_settings(struct dvb_frontend* fe,
 		return 0;
 }
 
-static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend* fe)
+static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusbdecfe_state* state = (struct ttusbdecfe_state*) fe->demodulator_priv;
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 2bfc866..089fa0f 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -183,7 +183,7 @@ static int mt352_avermedia_xc3028_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt352_pinnacle_tuner_set_params(struct dvb_frontend* fe)
+static int mt352_pinnacle_tuner_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 off[] = { 0x00, 0xf1};

