Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53491 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3BCWuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Feb 2013 17:50:51 -0500
Message-ID: <510EE9A3.5090803@iki.fi>
Date: Mon, 04 Feb 2013 00:50:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATH 2/2] mxl5007 move loop_thru to attach
References: <2289340.7RydykYGjZ@jar7.dominio> <3605279.72np2izzp3@jar7.dominio>
In-Reply-To: <3605279.72np2izzp3@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2013 12:40 AM, Jose Alberto Reguero wrote:
> This patch move the loop_thru configuration to the attach function,
> because with dual tuners until loop_tru configuration the other tuner
> don't work.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Reviewed-by: Antti Palosaari <crope@iki.fi>


>
> diff -upr linux/drivers/media/tuners/mxl5007t.c linux.new/drivers/media/tuners/mxl5007t.c
> --- linux/drivers/media/tuners/mxl5007t.c	2013-02-03 23:16:08.031628907 +0100
> +++ linux.new/drivers/media/tuners/mxl5007t.c	2013-02-03 23:14:12.196089297 +0100
> @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
>   	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
>   	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>
> -	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
>   	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
>   	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>
> @@ -908,6 +907,18 @@ struct dvb_frontend *mxl5007t_attach(str
>   	if (mxl_fail(ret))
>   		goto fail;
>
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +	ret = mxl5007t_write_reg(state, 0x04,
> +		state->config->loop_thru_enable);
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	if (mxl_fail(ret))
> +		goto fail;
> +
>   	fe->tuner_priv = state;
>
>   	mutex_unlock(&mxl5007t_list_mutex);
>

Looks good for my eyes!

Is clock output is enabled by default?

Are these two patches enough in order to get it working?

regards
Antti

-- 
http://palosaari.fi/
