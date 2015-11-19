Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36087 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbbKSN2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 08:28:31 -0500
Date: Thu, 19 Nov 2015 11:28:26 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, crope@iki.fi, xpert-reactos@gmx.de
Subject: Re: [PATCH 4/4] si2165: Add DVB-C support for HVR-4400/HVR-5500
Message-ID: <20151119112826.7ad9b688@recife.lan>
In-Reply-To: <1447455298-5562-4-git-send-email-zzam@gentoo.org>
References: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
	<1447455298-5562-4-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Nov 2015 23:54:58 +0100
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> It works only for HVR-4400/HVR-5500.
> For WinTV-HVR-930C-HD it fails with bad/no reception
> for unknown reasons.

Patch 3/4 of this series is broken. As this one depends on it, please
resend both patches 3 and 4 on your next patch series.

Regards,
Mauro

PS.: patches 1 and 2 are ok and got applied upstream already.


> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>  drivers/media/dvb-frontends/si2165.c | 132 +++++++++++++++++++++++++++++++----
>  1 file changed, 120 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index c87d927..97a6eac 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -760,7 +760,7 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
>  	do_div(oversamp, dvb_rate);
>  	reg_value = oversamp & 0x3fffffff;
>  
> -	/* oversamp, usbdump contained 0x03100000; */
> +	dprintk("%s: Write oversamp=%#x\n", __func__, reg_value);
>  	return si2165_writereg32(state, 0x00e4, reg_value);
>  }
>  
> @@ -823,7 +823,7 @@ static const struct si2165_reg_value_pair dvbt_regs[] = {
>  	{ 0x0387, 0x00 }
>  };
>  
> -static int si2165_set_parameters(struct dvb_frontend *fe)
> +static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
>  {
>  	int ret;
>  	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> @@ -851,9 +851,6 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = si2165_set_if_freq_shift(state);
> -	if (ret < 0)
> -		return ret;
>  	ret = si2165_writereg8(state, 0x08f8, 0x00);
>  	if (ret < 0)
>  		return ret;
> @@ -874,6 +871,110 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
>  	if (ret < 0)
>  		return ret;
>  
> +	return 0;
> +}
> +
> +static const struct si2165_reg_value_pair dvbc_regs[] = {
> +	/* agc2 */
> +	{ 0x016e, 0x50 },
> +	{ 0x016c, 0x0e },
> +	{ 0x016d, 0x10 },
> +	/* agc */
> +	{ 0x015b, 0x03 },
> +	{ 0x0150, 0x68 },
> +	/* agc */
> +	{ 0x01a0, 0x68 },
> +	{ 0x01c8, 0x50 },
> +
> +	{ 0x0278, 0x0d },
> +
> +	{ 0x023a, 0x05 },
> +	{ 0x0261, 0x09 },
> +	REG16(0x0350, 0x3e80),
> +	{ 0x02f4, 0x00 }
> +};
> +
> +static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
> +{
> +	struct si2165_state *state = fe->demodulator_priv;
> +	int ret;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	const u32 dvb_rate = p->symbol_rate;
> +	const u32 bw_hz = p->bandwidth_hz;
> +
> +	if (!state->has_dvbc)
> +		return -EINVAL;
> +
> +	if (dvb_rate == 0)
> +		return -EINVAL;
> +
> +	/* standard = DVB-C */
> +	ret = si2165_writereg8(state, 0x00ec, 0x05);
> +	if (ret < 0)
> +		return ret;
> +	ret = si2165_adjust_pll_divl(state, 14);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = si2165_writereg8(state, 0x08f8, 0x00);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Oversampling */
> +	ret = si2165_set_oversamp(state, dvb_rate);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = si2165_write_reg_list(state, dvbc_regs, ARRAY_SIZE(dvbc_regs));
> +	if (ret < 0)
> +		return ret;
> +
> +	/* dsp_addr_jump */
> +	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
> +	if (ret < 0)
> +		return ret;
> +
> +	si2165_writereg32(state, 0x00c4, bw_hz);
> +	si2165_writereg8(state, 0x00cb, 0x01);
> +	si2165_writereg8(state, 0x00c0, 0x00);
> +	si2165_writereg16(state, 0x024c, 0x0000);
> +	si2165_writereg16(state, 0x027c, 0x0000);
> +	si2165_writereg8(state, 0x0232, 0x03);
> +	si2165_writereg8(state, 0x02f4, 0x0b);
> +	si2165_writereg8(state, 0x00c0, 0x00);
> +	si2165_writereg8(state, 0x018b, 0x00);
> +
> +	return 0;
> +}
> +
> +static int si2165_set_frontend(struct dvb_frontend *fe)
> +{
> +	struct si2165_state *state = fe->demodulator_priv;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	u32 delsys = p->delivery_system;
> +	int ret;
> +	u8 val[3];
> +
> +	/* initial setting of if freq shift */
> +	ret = si2165_set_if_freq_shift(state);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (delsys) {
> +	case SYS_DVBT:
> +		ret = si2165_set_frontend_dvbt(fe);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	case SYS_DVBC_ANNEX_A:
> +		ret = si2165_set_frontend_dvbc(fe);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>  	if (fe->ops.tuner_ops.set_params)
>  		fe->ops.tuner_ops.set_params(fe);
>  
> @@ -889,6 +990,7 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
>  	ret = si2165_writereg8(state, 0x0341, 0x00);
>  	if (ret < 0)
>  		return ret;
> +
>  	/* reset all */
>  	ret = si2165_writereg8(state, 0x00c0, 0x00);
>  	if (ret < 0)
> @@ -902,7 +1004,7 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
>  	ret = si2165_write_reg_list(state, agc_rewrite,
>  				    ARRAY_SIZE(agc_rewrite));
>  	if (ret < 0)
> -		goto error;
> +		return ret;
>  
>  	/* start_synchro */
>  	ret = si2165_writereg8(state, 0x02e0, 0x01);
> @@ -927,7 +1029,12 @@ static void si2165_release(struct dvb_frontend *fe)
>  static struct dvb_frontend_ops si2165_ops = {
>  	.info = {
>  		.name = "Silicon Labs ",
> -		.caps =	FE_CAN_FEC_1_2 |
> +		 /* For DVB-C */
> +		.symbol_rate_min = 1000000,
> +		.symbol_rate_max = 7200000,
> +		/* For DVB-T */
> +		.frequency_stepsize = 166667,
> +		.caps = FE_CAN_FEC_1_2 |
>  			FE_CAN_FEC_2_3 |
>  			FE_CAN_FEC_3_4 |
>  			FE_CAN_FEC_5_6 |
> @@ -940,7 +1047,6 @@ static struct dvb_frontend_ops si2165_ops = {
>  			FE_CAN_QAM_128 |
>  			FE_CAN_QAM_256 |
>  			FE_CAN_QAM_AUTO |
> -			FE_CAN_TRANSMISSION_MODE_AUTO |
>  			FE_CAN_GUARD_INTERVAL_AUTO |
>  			FE_CAN_HIERARCHY_AUTO |
>  			FE_CAN_MUTE_TS |
> @@ -953,7 +1059,7 @@ static struct dvb_frontend_ops si2165_ops = {
>  	.init = si2165_init,
>  	.sleep = si2165_sleep,
>  
> -	.set_frontend      = si2165_set_parameters,
> +	.set_frontend      = si2165_set_frontend,
>  	.read_status       = si2165_read_status,
>  
>  	.release = si2165_release,
> @@ -1052,9 +1158,11 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
>  		strlcat(state->frontend.ops.info.name, " DVB-T",
>  			sizeof(state->frontend.ops.info.name));
>  	}
> -	if (state->has_dvbc)
> -		dev_warn(&state->i2c->dev, "%s: DVB-C is not yet supported.\n",
> -		       KBUILD_MODNAME);
> +	if (state->has_dvbc) {
> +		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
> +		strlcat(state->frontend.ops.info.name, " DVB-C",
> +			sizeof(state->frontend.ops.info.name));
> +	}
>  
>  	return &state->frontend;
>  
