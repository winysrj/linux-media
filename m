Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1BXTEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 14:04:21 -0500
Message-ID: <4D66ABAF.5020908@infradead.org>
Date: Thu, 24 Feb 2011 16:04:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/9 v2] ds3000: clean up in tune procedure
References: <201102020040.49656.liplianin@me.by>
In-Reply-To: <201102020040.49656.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Igor,

Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
> Variable 'retune' does not make sense.
> Loop is not needed for only one try.
> Remove unnecessary dprintk's.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>

This patch didn't apply. Please fix and resend.

Thanks!
Mauro.

> ---
>  drivers/media/dvb/frontends/ds3000.c |  442 +++++++++++++++++-----------------
>  1 files changed, 216 insertions(+), 226 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
> index 3373890..7c61936 100644
> --- a/drivers/media/dvb/frontends/ds3000.c
> +++ b/drivers/media/dvb/frontends/ds3000.c
> @@ -1049,7 +1049,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
>  	struct ds3000_state *state = fe->demodulator_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  
> -	int ret = 0, retune, i;
> +	int ret = 0, i;
>  	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf;
>  	u16 value, ndiv;
>  	u32 f3db;
> @@ -1072,249 +1072,239 @@ static int ds3000_tune(struct dvb_frontend *fe,
>  	/* discard the 'current' tuning parameters and prepare to tune */
>  	ds3000_clone_params(fe);
>  
> -	retune = 1;	/* try 1 times */
> -	dprintk("%s:   retune = %d\n", __func__, retune);
> -	dprintk("%s:   frequency   = %d\n", __func__, state->dcur.frequency);
> -	dprintk("%s:   symbol_rate = %d\n", __func__, state->dcur.symbol_rate);
> -	dprintk("%s:   FEC	 = %d \n", __func__,
> -		state->dcur.fec);
> -	dprintk("%s:   Inversion   = %d\n", __func__, state->dcur.inversion);
> -
> -	do {
> -		/* Reset status register */
> -		status = 0;
> -		/* Tune */
> -		/* unknown */
> -		ds3000_tuner_writereg(state, 0x07, 0x02);
> -		ds3000_tuner_writereg(state, 0x10, 0x00);
> -		ds3000_tuner_writereg(state, 0x60, 0x79);
> -		ds3000_tuner_writereg(state, 0x08, 0x01);
> -		ds3000_tuner_writereg(state, 0x00, 0x01);
> -		/* calculate and set freq divider */
> -		if (state->dcur.frequency < 1146000) {
> -			ds3000_tuner_writereg(state, 0x10, 0x11);
> -			ndiv = ((state->dcur.frequency * (6 + 8) * 4) +
> -					(DS3000_XTAL_FREQ / 2)) /
> -					DS3000_XTAL_FREQ - 1024;
> -		} else {
> -			ds3000_tuner_writereg(state, 0x10, 0x01);
> -			ndiv = ((state->dcur.frequency * (6 + 8) * 2) +
> -					(DS3000_XTAL_FREQ / 2)) /
> -					DS3000_XTAL_FREQ - 1024;
> -		}
> +	/* Reset status register */
> +	status = 0;
> +	/* Tune */
> +	/* unknown */
> +	ds3000_tuner_writereg(state, 0x07, 0x02);
> +	ds3000_tuner_writereg(state, 0x10, 0x00);
> +	ds3000_tuner_writereg(state, 0x60, 0x79);
> +	ds3000_tuner_writereg(state, 0x08, 0x01);
> +	ds3000_tuner_writereg(state, 0x00, 0x01);
> +	/* calculate and set freq divider */
> +	if (state->dcur.frequency < 1146000) {
> +		ds3000_tuner_writereg(state, 0x10, 0x11);
> +		ndiv = ((state->dcur.frequency * (6 + 8) * 4) +
> +				(DS3000_XTAL_FREQ / 2)) /
> +				DS3000_XTAL_FREQ - 1024;
> +	} else {
> +		ds3000_tuner_writereg(state, 0x10, 0x01);
> +		ndiv = ((state->dcur.frequency * (6 + 8) * 2) +
> +				(DS3000_XTAL_FREQ / 2)) /
> +				DS3000_XTAL_FREQ - 1024;
> +	}
>  
> -		ds3000_tuner_writereg(state, 0x01, (ndiv & 0x0f00) >> 8);
> -		ds3000_tuner_writereg(state, 0x02, ndiv & 0x00ff);
> -
> -		/* set pll */
> -		ds3000_tuner_writereg(state, 0x03, 0x06);
> -		ds3000_tuner_writereg(state, 0x51, 0x0f);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x10);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -		msleep(5);
> -
> -		/* unknown */
> -		ds3000_tuner_writereg(state, 0x51, 0x17);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x08);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -		msleep(5);
> -
> -		value = ds3000_tuner_readreg(state, 0x3d);
> -		value &= 0x0f;
> -		if ((value > 4) && (value < 15)) {
> -			value -= 3;
> -			if (value < 4)
> -				value = 4;
> -			value = ((value << 3) | 0x01) & 0x79;
> -		}
> +	ds3000_tuner_writereg(state, 0x01, (ndiv & 0x0f00) >> 8);
> +	ds3000_tuner_writereg(state, 0x02, ndiv & 0x00ff);
> +
> +	/* set pll */
> +	ds3000_tuner_writereg(state, 0x03, 0x06);
> +	ds3000_tuner_writereg(state, 0x51, 0x0f);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x10);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	/* unknown */
> +	ds3000_tuner_writereg(state, 0x51, 0x17);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x08);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	value = ds3000_tuner_readreg(state, 0x3d);
> +	value &= 0x0f;
> +	if ((value > 4) && (value < 15)) {
> +		value -= 3;
> +		if (value < 4)
> +			value = 4;
> +		value = ((value << 3) | 0x01) & 0x79;
> +	}
>  
> -		ds3000_tuner_writereg(state, 0x60, value);
> -		ds3000_tuner_writereg(state, 0x51, 0x17);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x08);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -
> -		/* set low-pass filter period */
> -		ds3000_tuner_writereg(state, 0x04, 0x2e);
> -		ds3000_tuner_writereg(state, 0x51, 0x1b);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x04);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -		msleep(5);
> -
> -		f3db = ((state->dcur.symbol_rate / 1000) << 2) / 5 + 2000;
> -		if ((state->dcur.symbol_rate / 1000) < 5000)
> -			f3db += 3000;
> -		if (f3db < 7000)
> -			f3db = 7000;
> -		if (f3db > 40000)
> -			f3db = 40000;
> -
> -		/* set low-pass filter baseband */
> -		value = ds3000_tuner_readreg(state, 0x26);
> -		mlpf = 0x2e * 207 / ((value << 1) + 151);
> -		mlpf_max = mlpf * 135 / 100;
> -		mlpf_min = mlpf * 78 / 100;
> -		if (mlpf_max > 63)
> -			mlpf_max = 63;
> -
> -		/* rounded to the closest integer */
> -		nlpf = ((mlpf * f3db * 1000) + (2766 * DS3000_XTAL_FREQ / 2))
> -				/ (2766 * DS3000_XTAL_FREQ);
> -		if (nlpf > 23)
> -			nlpf = 23;
> -		if (nlpf < 1)
> -			nlpf = 1;
> -
> -		/* rounded to the closest integer */
> +	ds3000_tuner_writereg(state, 0x60, value);
> +	ds3000_tuner_writereg(state, 0x51, 0x17);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x08);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +
> +	/* set low-pass filter period */
> +	ds3000_tuner_writereg(state, 0x04, 0x2e);
> +	ds3000_tuner_writereg(state, 0x51, 0x1b);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x04);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	f3db = ((state->dcur.symbol_rate / 1000) << 2) / 5 + 2000;
> +	if ((state->dcur.symbol_rate / 1000) < 5000)
> +		f3db += 3000;
> +	if (f3db < 7000)
> +		f3db = 7000;
> +	if (f3db > 40000)
> +		f3db = 40000;
> +
> +	/* set low-pass filter baseband */
> +	value = ds3000_tuner_readreg(state, 0x26);
> +	mlpf = 0x2e * 207 / ((value << 1) + 151);
> +	mlpf_max = mlpf * 135 / 100;
> +	mlpf_min = mlpf * 78 / 100;
> +	if (mlpf_max > 63)
> +		mlpf_max = 63;
> +
> +	/* rounded to the closest integer */
> +	nlpf = ((mlpf * f3db * 1000) + (2766 * DS3000_XTAL_FREQ / 2))
> +			/ (2766 * DS3000_XTAL_FREQ);
> +	if (nlpf > 23)
> +		nlpf = 23;
> +	if (nlpf < 1)
> +		nlpf = 1;
> +
> +	/* rounded to the closest integer */
> +	mlpf_new = ((DS3000_XTAL_FREQ * nlpf * 2766) +
> +			(1000 * f3db / 2)) / (1000 * f3db);
> +
> +	if (mlpf_new < mlpf_min) {
> +		nlpf++;
>  		mlpf_new = ((DS3000_XTAL_FREQ * nlpf * 2766) +
>  				(1000 * f3db / 2)) / (1000 * f3db);
> +	}
>  
> -		if (mlpf_new < mlpf_min) {
> -			nlpf++;
> -			mlpf_new = ((DS3000_XTAL_FREQ * nlpf * 2766) +
> -					(1000 * f3db / 2)) / (1000 * f3db);
> -		}
> +	if (mlpf_new > mlpf_max)
> +		mlpf_new = mlpf_max;
> +
> +	ds3000_tuner_writereg(state, 0x04, mlpf_new);
> +	ds3000_tuner_writereg(state, 0x06, nlpf);
> +	ds3000_tuner_writereg(state, 0x51, 0x1b);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x04);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +	msleep(5);
> +
> +	/* unknown */
> +	ds3000_tuner_writereg(state, 0x51, 0x1e);
> +	ds3000_tuner_writereg(state, 0x51, 0x1f);
> +	ds3000_tuner_writereg(state, 0x50, 0x01);
> +	ds3000_tuner_writereg(state, 0x50, 0x00);
> +	msleep(60);
> +
> +	/* ds3000 global reset */
> +	ds3000_writereg(state, 0x07, 0x80);
> +	ds3000_writereg(state, 0x07, 0x00);
> +	/* ds3000 build-in uC reset */
> +	ds3000_writereg(state, 0xb2, 0x01);
> +	/* ds3000 software reset */
> +	ds3000_writereg(state, 0x00, 0x01);
> +
> +	switch (c->delivery_system) {
> +	case SYS_DVBS:
> +		/* initialise the demod in DVB-S mode */
> +		for (i = 0; i < sizeof(ds3000_dvbs_init_tab); i += 2)
> +			ds3000_writereg(state,
> +				ds3000_dvbs_init_tab[i],
> +				ds3000_dvbs_init_tab[i + 1]);
> +		value = ds3000_readreg(state, 0xfe);
> +		value &= 0xc0;
> +		value |= 0x1b;
> +		ds3000_writereg(state, 0xfe, value);
> +		break;
> +	case SYS_DVBS2:
> +		/* initialise the demod in DVB-S2 mode */
> +		for (i = 0; i < sizeof(ds3000_dvbs2_init_tab); i += 2)
> +			ds3000_writereg(state,
> +				ds3000_dvbs2_init_tab[i],
> +				ds3000_dvbs2_init_tab[i + 1]);
> +		ds3000_writereg(state, 0xfe, 0x98);
> +		break;
> +	default:
> +		return 1;
> +	}
>  
> -		if (mlpf_new > mlpf_max)
> -			mlpf_new = mlpf_max;
> -
> -		ds3000_tuner_writereg(state, 0x04, mlpf_new);
> -		ds3000_tuner_writereg(state, 0x06, nlpf);
> -		ds3000_tuner_writereg(state, 0x51, 0x1b);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x04);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -		msleep(5);
> -
> -		/* unknown */
> -		ds3000_tuner_writereg(state, 0x51, 0x1e);
> -		ds3000_tuner_writereg(state, 0x51, 0x1f);
> -		ds3000_tuner_writereg(state, 0x50, 0x01);
> -		ds3000_tuner_writereg(state, 0x50, 0x00);
> -		msleep(60);
> -
> -		/* ds3000 global reset */
> -		ds3000_writereg(state, 0x07, 0x80);
> -		ds3000_writereg(state, 0x07, 0x00);
> -		/* ds3000 build-in uC reset */
> -		ds3000_writereg(state, 0xb2, 0x01);
> -		/* ds3000 software reset */
> -		ds3000_writereg(state, 0x00, 0x01);
> +	/* enable 27MHz clock output */
> +	ds3000_writereg(state, 0x29, 0x80);
> +	/* enable ac coupling */
> +	ds3000_writereg(state, 0x25, 0x8a);
> +
> +	/* enhance symbol rate performance */
> +	if ((state->dcur.symbol_rate / 1000) <= 5000) {
> +		value = 29777 / (state->dcur.symbol_rate / 1000) + 1;
> +		if (value % 2 != 0)
> +			value++;
> +		ds3000_writereg(state, 0xc3, 0x0d);
> +		ds3000_writereg(state, 0xc8, value);
> +		ds3000_writereg(state, 0xc4, 0x10);
> +		ds3000_writereg(state, 0xc7, 0x0e);
> +	} else if ((state->dcur.symbol_rate / 1000) <= 10000) {
> +		value = 92166 / (state->dcur.symbol_rate / 1000) + 1;
> +		if (value % 2 != 0)
> +			value++;
> +		ds3000_writereg(state, 0xc3, 0x07);
> +		ds3000_writereg(state, 0xc8, value);
> +		ds3000_writereg(state, 0xc4, 0x09);
> +		ds3000_writereg(state, 0xc7, 0x12);
> +	} else if ((state->dcur.symbol_rate / 1000) <= 20000) {
> +		value = 64516 / (state->dcur.symbol_rate / 1000) + 1;
> +		ds3000_writereg(state, 0xc3, value);
> +		ds3000_writereg(state, 0xc8, 0x0e);
> +		ds3000_writereg(state, 0xc4, 0x07);
> +		ds3000_writereg(state, 0xc7, 0x18);
> +	} else {
> +		value = 129032 / (state->dcur.symbol_rate / 1000) + 1;
> +		ds3000_writereg(state, 0xc3, value);
> +		ds3000_writereg(state, 0xc8, 0x0a);
> +		ds3000_writereg(state, 0xc4, 0x05);
> +		ds3000_writereg(state, 0xc7, 0x24);
> +	}
> +
> +	/* normalized symbol rate rounded to the closest integer */
> +	value = (((state->dcur.symbol_rate / 1000) << 16) +
> +			(DS3000_SAMPLE_RATE / 2)) / DS3000_SAMPLE_RATE;
> +	ds3000_writereg(state, 0x61, value & 0x00ff);
> +	ds3000_writereg(state, 0x62, (value & 0xff00) >> 8);
> +
> +	/* co-channel interference cancellation disabled */
> +	ds3000_writereg(state, 0x56, 0x00);
> +
> +	/* equalizer disabled */
> +	ds3000_writereg(state, 0x76, 0x00);
> +
> +	/*ds3000_writereg(state, 0x08, 0x03);
> +	ds3000_writereg(state, 0xfd, 0x22);
> +	ds3000_writereg(state, 0x08, 0x07);
> +	ds3000_writereg(state, 0xfd, 0x42);
> +	ds3000_writereg(state, 0x08, 0x07);*/
>  
> +	if (state->config->ci_mode) {
>  		switch (c->delivery_system) {
>  		case SYS_DVBS:
> -			/* initialise the demod in DVB-S mode */
> -			for (i = 0; i < sizeof(ds3000_dvbs_init_tab); i += 2)
> -				ds3000_writereg(state,
> -					ds3000_dvbs_init_tab[i],
> -					ds3000_dvbs_init_tab[i + 1]);
> -			value = ds3000_readreg(state, 0xfe);
> -			value &= 0xc0;
> -			value |= 0x1b;
> -			ds3000_writereg(state, 0xfe, value);
> -			break;
> +		default:
> +			ds3000_writereg(state, 0xfd, 0x80);
> +		break;
>  		case SYS_DVBS2:
> -			/* initialise the demod in DVB-S2 mode */
> -			for (i = 0; i < sizeof(ds3000_dvbs2_init_tab); i += 2)
> -				ds3000_writereg(state,
> -					ds3000_dvbs2_init_tab[i],
> -					ds3000_dvbs2_init_tab[i + 1]);
> -			ds3000_writereg(state, 0xfe, 0x98);
> +			ds3000_writereg(state, 0xfd, 0x01);
>  			break;
> -		default:
> -			return 1;
>  		}
> +	}
>  
> -		/* enable 27MHz clock output */
> -		ds3000_writereg(state, 0x29, 0x80);
> -		/* enable ac coupling */
> -		ds3000_writereg(state, 0x25, 0x8a);
> -
> -		/* enhance symbol rate performance */
> -		if ((state->dcur.symbol_rate / 1000) <= 5000) {
> -			value = 29777 / (state->dcur.symbol_rate / 1000) + 1;
> -			if (value % 2 != 0)
> -				value++;
> -			ds3000_writereg(state, 0xc3, 0x0d);
> -			ds3000_writereg(state, 0xc8, value);
> -			ds3000_writereg(state, 0xc4, 0x10);
> -			ds3000_writereg(state, 0xc7, 0x0e);
> -		} else if ((state->dcur.symbol_rate / 1000) <= 10000) {
> -			value = 92166 / (state->dcur.symbol_rate / 1000) + 1;
> -			if (value % 2 != 0)
> -				value++;
> -			ds3000_writereg(state, 0xc3, 0x07);
> -			ds3000_writereg(state, 0xc8, value);
> -			ds3000_writereg(state, 0xc4, 0x09);
> -			ds3000_writereg(state, 0xc7, 0x12);
> -		} else if ((state->dcur.symbol_rate / 1000) <= 20000) {
> -			value = 64516 / (state->dcur.symbol_rate / 1000) + 1;
> -			ds3000_writereg(state, 0xc3, value);
> -			ds3000_writereg(state, 0xc8, 0x0e);
> -			ds3000_writereg(state, 0xc4, 0x07);
> -			ds3000_writereg(state, 0xc7, 0x18);
> -		} else {
> -			value = 129032 / (state->dcur.symbol_rate / 1000) + 1;
> -			ds3000_writereg(state, 0xc3, value);
> -			ds3000_writereg(state, 0xc8, 0x0a);
> -			ds3000_writereg(state, 0xc4, 0x05);
> -			ds3000_writereg(state, 0xc7, 0x24);
> -		}
> +	/* ds3000 out of software reset */
> +	ds3000_writereg(state, 0x00, 0x00);
> +	/* start ds3000 build-in uC */
> +	ds3000_writereg(state, 0xb2, 0x00);
>  
> -		/* normalized symbol rate rounded to the closest integer */
> -		value = (((state->dcur.symbol_rate / 1000) << 16) +
> -				(DS3000_SAMPLE_RATE / 2)) / DS3000_SAMPLE_RATE;
> -		ds3000_writereg(state, 0x61, value & 0x00ff);
> -		ds3000_writereg(state, 0x62, (value & 0xff00) >> 8);
> -
> -		/* co-channel interference cancellation disabled */
> -		ds3000_writereg(state, 0x56, 0x00);
> -
> -		/* equalizer disabled */
> -		ds3000_writereg(state, 0x76, 0x00);
> -
> -		/*ds3000_writereg(state, 0x08, 0x03);
> -		ds3000_writereg(state, 0xfd, 0x22);
> -		ds3000_writereg(state, 0x08, 0x07);
> -		ds3000_writereg(state, 0xfd, 0x42);
> -		ds3000_writereg(state, 0x08, 0x07);*/
> -
> -		if (state->config->ci_mode) {
> -			switch (c->delivery_system) {
> -			case SYS_DVBS:
> -			default:
> -				ds3000_writereg(state, 0xfd, 0x80);
> -			break;
> -			case SYS_DVBS2:
> -				ds3000_writereg(state, 0xfd, 0x01);
> -				break;
> -			}
> -		}
> +	/* TODO: calculate and set carrier offset */
>  
> -		/* ds3000 out of software reset */
> -		ds3000_writereg(state, 0x00, 0x00);
> -		/* start ds3000 build-in uC */
> -		ds3000_writereg(state, 0xb2, 0x00);
> -
> -		/* TODO: calculate and set carrier offset */
> -
> -		/* wait before retrying */
> -		for (i = 0; i < 30 ; i++) {
> -			if (ds3000_is_tuned(fe)) {
> -				dprintk("%s: Tuned\n", __func__);
> -				ds3000_dump_registers(fe);
> -				goto tuned;
> -			}
> -			msleep(1);
> +	/* wait before retrying */
> +	for (i = 0; i < 30 ; i++) {
> +		if (ds3000_is_tuned(fe)) {
> +			dprintk("%s: Tuned\n", __func__);
> +			ds3000_dump_registers(fe);
> +			goto tuned;
>  		}
> +		msleep(1);
> +	}
>  
> -		dprintk("%s: Not tuned\n", __func__);
> -		ds3000_dump_registers(fe);
> +	dprintk("%s: Not tuned\n", __func__);
> +	ds3000_dump_registers(fe);
>  
> -	} while (--retune);
>  
>  tuned:
>  	return ret;

