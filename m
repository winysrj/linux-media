Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37142 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaIVXj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 19:39:57 -0400
Date: Mon, 22 Sep 2014 20:39:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Si2165: Add experimental DVB-C support for
 HVR-4400/HVR-5500
Message-ID: <20140922203952.0e1787ab@recife.lan>
In-Reply-To: <1410291118-5818-1-git-send-email-zzam@gentoo.org>
References: <1410291118-5818-1-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  9 Sep 2014 21:31:58 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> This patch is sent out, because I got multiple requests for it.
> So here it is.
> 
> It works only for HVR-4400/HVR-5500.
> For WinTV-HVR-930C-HD it fails with bad/no reception for unknown reasons.

There are some coding style issues on this patch, like the usage of // for
comments and some bad whitespacing...

> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>  drivers/media/dvb-frontends/si2165.c | 132 +++++++++++++++++++++++++++++++++--
>  1 file changed, 125 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index c807180..660298b 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -781,7 +781,7 @@ static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
>  	return si2165_writereg32(state, 0x00e8, reg_value);
>  }
>  
> -static int si2165_set_parameters(struct dvb_frontend *fe)
> +static int si2165_set_parameters_t(struct dvb_frontend *fe)
>  {
>  	int ret;
>  	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> @@ -929,6 +929,119 @@ static int si2165_set_parameters(struct dvb_frontend *fe)
>  	return 0;
>  }
>  
> +static int si2165_set_parameters_c(struct dvb_frontend *fe)
> +{
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	struct si2165_state *state = fe->demodulator_priv;
> +	u8 val[3];
> +	u32 IF;
> +
> +	if (!state->has_dvbc)
> +		return -EINVAL;
> +
> +	si2165_writereg8(state, 0x00e0, 0x00);
> +
> +	si2165_readreg8(state, 0x0118, val); /* returned 0x07 */

Huh? I didn't understand the comment. The same applies to other similar
comments.

> +	
> +	si2165_writereg8(state, 0x012a, 0x46);
> +	si2165_writereg8(state, 0x012c, 0x00);
> +	si2165_writereg8(state, 0x012e, 0x0a);
> +	si2165_writereg8(state, 0x012f, 0xff);
> +	si2165_writereg8(state, 0x0123, 0x70);
> +	{
> +	  si2165_writereg8(state, 0x00ec, 0x05);
> +	  si2165_adjust_pll_divl(state, 0x0e);
> +	}

Also, why are you adding those { } here? Same applies to other
similar blocks.

> +	si2165_readreg8(state, 0x00e0, val); /* returned 0x00 */
> +	{
> +	  si2165_writereg32(state, 0x00e8, 0x02db6db6);
> +	}
> +	si2165_writereg8(state, 0x08f8, 0x00);
> +	si2165_readreg8(state, 0x04e4, val); /* returned 0x21 */
> +	si2165_writereg8(state, 0x04e4, 0x20); // clear bit 1
> +	si2165_writereg16(state, 0x04ef, 0x00fe);
> +	si2165_writereg24(state, 0x04f4, 0x555555);
> +	si2165_readreg8(state, 0x04e4, val); /* returned 0x20 */
> +	si2165_writereg8(state, 0x04e4, 0x20);
> +	si2165_readreg8(state, 0x04e5, val); /* returned 0x03 */
> +	si2165_writereg8(state, 0x04e5, 0x03);
> +	si2165_readreg8(state, 0x04e5, val); /* returned 0x03 */
> +	si2165_writereg8(state, 0x04e5, 0x01);
> +	{
> +	  si2165_writereg32(state, 0x00e4, 0x0494f77e);
> +	  si2165_writereg8(state, 0x016e, 0x50);
> +	}
> +	si2165_writereg8(state, 0x016c, 0x0e);
> +	si2165_writereg8(state, 0x016d, 0x10);
> +	si2165_writereg8(state, 0x015b, 0x03);
> +	{
> +	  si2165_writereg8(state, 0x0150, 0x68);
> +	  si2165_writereg8(state, 0x01a0, 0x68);
> +	  si2165_writereg8(state, 0x01c8, 0x50);
> +	  si2165_readreg8(state, 0x0278, val); /* returned 0x0d */
> +	  si2165_writereg8(state, 0x0278, 0x0d);
> +	  si2165_writereg8(state, 0x023a, 0x05); // or 0x05
> +	  si2165_writereg8(state, 0x0261, 0x09);
> +	  si2165_writereg16(state, 0x0350, 0x3e80);
> +	  si2165_writereg8(state, 0x02f4, 0x00);
> +	}
> +	si2165_writereg32(state, 0x0348, 0xf4000000);
> +	{
> +	  si2165_writereg32(state, 0x00c4, 0x007a1200);
> +	  si2165_writereg8(state, 0x00cb, 0x01);
> +	  si2165_writereg8(state, 0x00c0, 0x00);
> +	  si2165_writereg8(state, 0x012a, 0x46);
> +	  si2165_writereg8(state, 0x012c, 0x00);
> +	  si2165_writereg8(state, 0x012e, 0x0a);
> +	  si2165_writereg8(state, 0x012f, 0xff);
> +	  si2165_writereg8(state, 0x0123, 0x70);
> +	  si2165_writereg16(state, 0x024c, 0x0000);
> +	  si2165_writereg16(state, 0x027c, 0x0000);
> +	  si2165_writereg8(state, 0x0232, 0x03);
> +	  si2165_writereg8(state, 0x02f4, 0x0b);
> +	  si2165_writereg32(state, 0x00e4, 0x040ed730); // or 0x040ed730
> +	  si2165_writereg8(state, 0x00c0, 0x00);
> +	  si2165_readreg8(state, 0x0118, val); /* returned 0x07 */
> +	  si2165_writereg8(state, 0x018b, 0x00);
> +	}
> +
> +	if (!fe->ops.tuner_ops.get_if_frequency) {
> +		pr_err("Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (fe->ops.tuner_ops.set_params)
> +		fe->ops.tuner_ops.set_params(fe);
> +	
> +	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
> +
> +	{
> +	  si2165_writereg32(state, 0x00e8, 0x02db6db6);
> +	}
> +	si2165_readreg8(state, 0x0341, val); /* returned 0x01 */
> +	si2165_writereg8(state, 0x0341, 0x00);
> +	si2165_writereg8(state, 0x00c0, 0x00);
> +	si2165_writereg32(state, 0x0384, 0x00000000);
> +	si2165_writereg8(state, 0x02e0, 0x01);
> +	
> +	return 0;
> +}
> +
> +static int si2165_set_parameters(struct dvb_frontend *fe)
> +{
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	u32 delsys  = p->delivery_system;
> +
> +	switch (delsys) {
> +	case SYS_DVBT:
> +		return si2165_set_parameters_t(fe);
> +	case SYS_DVBC_ANNEX_A:
> +		return si2165_set_parameters_c(fe);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static void si2165_release(struct dvb_frontend *fe)
>  {
>  	struct si2165_state *state = fe->demodulator_priv;
> @@ -940,20 +1053,23 @@ static void si2165_release(struct dvb_frontend *fe)
>  static struct dvb_frontend_ops si2165_ops = {
>  	.info = {
>  		.name = "Silicon Labs ",
> -		.caps =	FE_CAN_FEC_1_2 |
> +		 /* For DVB-C */
> +		.symbol_rate_min = 870000,
> +		.symbol_rate_max = 11700000,
> +		/* For DVB-T */
> +		.frequency_stepsize = 166667,
> +		.caps = FE_CAN_FEC_1_2 |
>  			FE_CAN_FEC_2_3 |
>  			FE_CAN_FEC_3_4 |
>  			FE_CAN_FEC_5_6 |
>  			FE_CAN_FEC_7_8 |
>  			FE_CAN_FEC_AUTO |
> -			FE_CAN_QPSK |
>  			FE_CAN_QAM_16 |
>  			FE_CAN_QAM_32 |
>  			FE_CAN_QAM_64 |
>  			FE_CAN_QAM_128 |
>  			FE_CAN_QAM_256 |
>  			FE_CAN_QAM_AUTO |
> -			FE_CAN_TRANSMISSION_MODE_AUTO |
>  			FE_CAN_GUARD_INTERVAL_AUTO |
>  			FE_CAN_HIERARCHY_AUTO |
>  			FE_CAN_MUTE_TS |
> @@ -1065,9 +1181,11 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
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
