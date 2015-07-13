Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33950 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbGMJtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 05:49:01 -0400
Received: by wgkl9 with SMTP id l9so21369609wgk.1
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2015 02:49:00 -0700 (PDT)
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >= 4.1.x
To: Jose Alberto Reguero <jareguero@telefonica.net>
References: <mhnd10gxck9p5yqwsxbonfty.1436213845281@email.android.com>
 <559B9261.4050409@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: poma <pomidorabelisima@gmail.com>
Message-ID: <55A38988.80404@gmail.com>
Date: Mon, 13 Jul 2015 11:48:56 +0200
MIME-Version: 1.0
In-Reply-To: <559B9261.4050409@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.07.2015 10:48, poma wrote:
> On 06.07.2015 22:17, Jose Alberto Reguero wrote:
>> I made the patch for the af9035. I have not a af9015 whith mxl5007 and dual channel. Revert it, if it cause regresions.
>>
>> Jose Alberto
>>
> 
> Thanks.
> 
> From e19560ea038e54dc57be717db55f19d449df63f0 Mon Sep 17 00:00:00 2001
> From: poma <pomidorabelisima@gmail.com>
> Date: Tue, 7 Jul 2015 10:26:13 +0200
> Subject: [PATCH] Fix for AF9015 DVB-T USB2.0 stick
> 
> This reverts commitas:
> 
> - 02f9cf96df57575acea2e6eb4041e9f3ecd32548
>   "[media] [PATH,2/2] mxl5007 move loop_thru to attach"
> - fe4860af002a4516dd878f7297b61e186c475b35
>   "[media] [PATH,1/2] mxl5007 move reset to attach"
> 
> This is the conclusion after extensive testing,
> these two commitas produce:
> 
> mxl5007t_soft_reset: 521: failed!
> mxl5007t_attach: error -121 on line 907
> 
> causing AF9015 DVB-T USB2.0 stick completely unusable.
> 
> 
> Tested-by: poma <pomidorabelisima@gmail.com>
> ---
>  drivers/media/tuners/mxl5007t.c | 30 +++++-------------------------
>  1 file changed, 5 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
> index f4ae04c..f8c4ba2 100644
> --- a/drivers/media/tuners/mxl5007t.c
> +++ b/drivers/media/tuners/mxl5007t.c
> @@ -374,6 +374,7 @@ static struct reg_pair_t *mxl5007t_calc_init_regs(struct mxl5007t_state *state,
>  	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
>  	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>  
> +	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
>  	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
>  	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>  
> @@ -530,6 +531,10 @@ static int mxl5007t_tuner_init(struct mxl5007t_state *state,
>  	struct reg_pair_t *init_regs;
>  	int ret;
>  
> +	ret = mxl5007t_soft_reset(state);
> +	if (mxl_fail(ret))
> +		goto fail;
> +
>  	/* calculate initialization reg array */
>  	init_regs = mxl5007t_calc_init_regs(state, mode);
>  
> @@ -895,32 +900,7 @@ struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
>  		/* existing tuner instance */
>  		break;
>  	}
> -
> -	if (fe->ops.i2c_gate_ctrl)
> -		fe->ops.i2c_gate_ctrl(fe, 1);
> -
> -	ret = mxl5007t_soft_reset(state);
> -
> -	if (fe->ops.i2c_gate_ctrl)
> -		fe->ops.i2c_gate_ctrl(fe, 0);
> -
> -	if (mxl_fail(ret))
> -		goto fail;
> -
> -	if (fe->ops.i2c_gate_ctrl)
> -		fe->ops.i2c_gate_ctrl(fe, 1);
> -
> -	ret = mxl5007t_write_reg(state, 0x04,
> -		state->config->loop_thru_enable);
> -
> -	if (fe->ops.i2c_gate_ctrl)
> -		fe->ops.i2c_gate_ctrl(fe, 0);
> -
> -	if (mxl_fail(ret))
> -		goto fail;
> -
>  	fe->tuner_priv = state;
> -
>  	mutex_unlock(&mxl5007t_list_mutex);
>  
>  	memcpy(&fe->ops.tuner_ops, &mxl5007t_tuner_ops,
> 


Guys, any chance to push this any time soon?


