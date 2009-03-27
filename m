Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC0J5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 05:57:34 -0400
Date: Fri, 27 Mar 2009 06:57:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX
 China  DMB-TH digital demodulator
Message-ID: <20090327065726.5e4b4211@pedra.chehab.org>
In-Reply-To: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Mar 2009 23:55:05 +0800
David Wong <davidtlwong@gmail.com> wrote:

> +#undef USE_FAKE_SIGNAL_STRENGTH

Hmm... why do you need this upstream? Is the signal strength working? If so,
just remove this test code.

> +
> +static void lgs8gxx_auto_lock(struct lgs8gxx_state *priv);

I don't see why do you need to prototype this function.

> +
> +static int debug = 0;

Don't initialize static vars to zero. Kernel already does this, and static
initialization requires eats some space.

> +static int lgs8gxx_set_fe(struct dvb_frontend *fe,
> +			  struct dvb_frontend_parameters *fe_params)
> +{
> +	struct lgs8gxx_state *priv = fe->demodulator_priv;
> +
> +	dprintk("%s\n", __func__);
> +
> +	/* set frequency */
> +	if (fe->ops.tuner_ops.set_params) {
> +		fe->ops.tuner_ops.set_params(fe, fe_params);
> +		if (fe->ops.i2c_gate_ctrl)
> +			fe->ops.i2c_gate_ctrl(fe, 0);
> +	}
> +
> +	/* Hardcoded to use auto as much as possible */
> +	fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
> +	fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
> +	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;

Hmm... this is weird.

That's said, maybe you may need some DVBS2 API additions for DMB. You should
propose some API additions and provide a patch for it.

> +	/* FEC. No exact match for DMB-TH, pick approx. value */
> +	switch(t & LGS_FEC_MASK) {
> +	case  LGS_FEC_0_4: /* FEC 0.4 */
> +		translated_fec = FEC_1_2;
> +		break;
> +	case  LGS_FEC_0_6: /* FEC 0.6 */
> +		translated_fec = FEC_2_3;
> +		break;
> +	case  LGS_FEC_0_8: /* FEC 0.8 */
> +		translated_fec = FEC_5_6;
> +		break;
> +	default:
> +		translated_fec = FEC_1_2;
> +	}

Same here: if there's no exact match, we should first patch the core files to
improve the API, and then use the correct values.

> +	fe_params->u.ofdm.code_rate_HP =
> +	fe_params->u.ofdm.code_rate_LP = translated_fec;

The above seems weird. It would be better to do:

+	fe_params->u.ofdm.code_rate_HP = translated_fec;
+	fe_params->u.ofdm.code_rate_LP = translated_fec;

The gcc optimizer will produce the same code, but this way would be cleaner for
those who are reading the source code.

> +static
> +int lgs8gxx_get_tune_settings(struct dvb_frontend *fe,
> +			      struct dvb_frontend_tune_settings *fesettings)
> +{
> +	/* FIXME: copy from tda1004x.c */

It would be nice if you fix those FIXME's.

> +	fesettings->min_delay_ms = 800;
> +	/* Drift compensation makes no sense for DVB-T */

DVB-T???

> +static int lgs8gxx_read_snr(struct dvb_frontend *fe, u16 *snr)
> +{
> +	struct lgs8gxx_state *priv = fe->demodulator_priv;
> +	u8 t;
> +	*snr = 0;
> +
> +	lgs8gxx_read_reg(priv, 0x95, &t);
> +	dprintk("AVG Noise=0x%02X\n", t);
> +	*snr = 256 - t;
> +	*snr <<= 8;
> +	dprintk("snr=0x%x\n", *snr);
> +	
> +	return 0;
> +}

I dunno if you are following all those discussions about SNR. We're trying to
standardize the meaning for all those status reads (SNR, signal strength, etc.

Nothing were decided yet, but while we don't take a decision, the better is if
you provide some comments at the source code specifying what's the unit for
each of those status (dB? 0.1 dB steps? dB * 256 ?).

> +static struct dvb_frontend_ops lgs8gxx_ops = {
> +	.info = {
> +		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
> +		.type = FE_OFDM,
> +		.frequency_min = 474000000,
> +		.frequency_max = 858000000,
> +		.frequency_stepsize = 10000,
> +		.caps =
> +		    FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> +		    FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +		    FE_CAN_QPSK |
> +		    FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
> +		    FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO
> +	},

Also here we should reflect the proper DMB parameters, after the API additions.

--- 

Before submitting patches, please check they with checkpatch.pl ( see
http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches for the submission
procedures). 

Please fix the CodingStyle errors detected by the tool:


ERROR: do not initialise statics to 0 or NULL
#91: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:43:
+static int debug = 0;

WARNING: printk() should include KERN_ facility level
#145: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:97:
+		printk("%s: reg=0x%02X, data=0x%02X\n", __func__, reg, b1[0]);

ERROR: do not use C99 // comments
#164: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:116:
+	if_conf = 0x10; // AGC output on;

ERROR: spaces required around that ':' (ctx:VxV)
#167: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:119:
+		((config->ext_adc) ? 0x80:0x00) |
 		                         ^

ERROR: spaces required around that ':' (ctx:VxV)
#168: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:120:
+		((config->if_neg_center) ? 0x04:0x00) |
 		                               ^

ERROR: spaces required around that ':' (ctx:VxV)
#169: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:121:
+		((config->if_freq == 0) ? 0x08:0x00) | /* Baseband */
 		                              ^

ERROR: spaces required around that ':' (ctx:VxV)
#170: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:122:
+		((config->ext_adc && config->adc_signed) ? 0x02:0x00) |
 		                                               ^

ERROR: spaces required around that ':' (ctx:VxV)
#171: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:123:
+		((config->ext_adc && config->if_neg_edge) ? 0x01:0x00);
 		                                                ^

WARNING: braces {} are not necessary for single statement blocks
#216: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:168:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8gxx_write_reg(priv, 0xC6, 0x01);
+	}

ERROR: do not use C99 // comments
#223: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:175:
+	// clear FEC self reset

WARNING: braces {} are not necessary for single statement blocks
#244: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:196:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8G52) {
+		lgs8gxx_write_reg(priv, 0xD9, 0x40);
+	}

ERROR: trailing whitespace
#300: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:252:
+^Iint err; $

ERROR: space required after that ',' (ctx:VxV)
#327: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:279:
+	int i,j;
 	     ^

ERROR: spaces required around that '=' (ctx:WxV)
#338: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:290:
+		for (j =0 ; j < 2; j++) {
 		       ^

ERROR: trailing statements should be on next line
#341: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:293:
+			if (err) goto out;
+			if (err) goto out;
ERROR: trailing statements should be on next line
#342: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:294:
+			if (locked) goto locked;
+			if (locked) goto locked;
ERROR: spaces required around that '=' (ctx:WxV)
#344: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:296:
+		for (j =0 ; j < 2; j++) {
 		       ^

ERROR: trailing statements should be on next line
#347: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:299:
+			if (err) goto out;
+			if (err) goto out;
ERROR: trailing statements should be on next line
#348: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:300:
+			if (locked) goto locked;
+			if (locked) goto locked;
ERROR: trailing statements should be on next line
#352: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:304:
+		if (err) goto out;
+		if (err) goto out;
ERROR: trailing statements should be on next line
#353: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:305:
+		if (locked) goto locked;
+		if (locked) goto locked;
ERROR: do not use C99 // comments
#381: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:333:
+	//u8 ctrl_frame = 0, mode = 0, rate = 0;

ERROR: trailing whitespace
#395: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:347:
+^I$

WARNING: braces {} are not necessary for single statement blocks
#404: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:356:
+	if (priv->config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8gxx_write_reg(priv, 0xC0, detected_param);
+	}

ERROR: do not use C99 // comments
#407: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:359:
+	//lgs8gxx_soft_reset(priv);

WARNING: suspect code indent for conditional statements (8, 8)
#412: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:364:
+	if (gi == 0x2)
+	switch(gi) {

ERROR: space required before the open parenthesis '('
#413: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:365:
+	switch(gi) {

ERROR: trailing whitespace
#467: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:419:
+^Ilgs8gxx_write_reg(priv, 0x2C, 0); $

WARNING: line over 80 characters
#477: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:429:
+	struct lgs8gxx_state *priv = (struct lgs8gxx_state *)fe->demodulator_priv;

WARNING: braces {} are not necessary for single statement blocks
#493: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:445:
+	if (config->prod == LGS8GXX_PROD_LGS8913) {
+		lgs8913_init(priv);
+	}

WARNING: suspect code indent for conditional statements (8, 8)
#550: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:502:
+	if ((fe_params->u.ofdm.code_rate_HP == FEC_AUTO) ||
[...]
+	} else {

ERROR: space required before the open parenthesis '('
#629: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:581:
+	switch(t & LGS_FEC_MASK) {

ERROR: space required before the open parenthesis '('
#646: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:598:
+	switch(t & SC_MASK) {

WARNING: line over 80 characters
#707: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:659:
+			*fe_status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;

ERROR: trailing whitespace
#724: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:676:
+^Idprintk("%s()\n", __func__);^I$

ERROR: space prohibited before that close parenthesis ')'
#734: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:686:
+	if (v < 0x100 )

ERROR: trailing whitespace
#748: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:700:
+^I^I$

ERROR: trailing whitespace
#818: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:770:
+^I$

ERROR: "foo* bar" should be "foo *bar"
#865: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:817:
+static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)

WARNING: braces {} are not necessary for any arm of this statement
#871: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:823:
+	if (enable) {
[...]
+	} else {
[...]

WARNING: line over 80 characters
#872: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:824:
+		return lgs8gxx_write_reg(priv, 0x01, 0x80 | priv->config->tuner_address);

ERROR: do not use C99 // comments
#896: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:848:
+	//.sleep = lgs8gxx_sleep,

ERROR: space required after that ',' (ctx:VxV)
#917: FILE: linux/drivers/media/dvb/frontends/lgs8gxx.c:869:
+	dprintk("%s()\n",__func__);
 	                ^

ERROR: trailing whitespace
#1111: FILE: linux/drivers/media/dvb/frontends/lgs8gxx_priv.h:58:
+#define GI_595^I0x01^I$



Cheers,
Mauro
