Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35638 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3BCEAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 23:00:48 -0500
Received: by mail-lb0-f169.google.com with SMTP id m4so5788686lbo.0
        for <linux-media@vger.kernel.org>; Sat, 02 Feb 2013 20:00:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2909559.M1IsAHpWSv@jar7.dominio>
References: <50F05C09.3010104@iki.fi>
	<2909559.M1IsAHpWSv@jar7.dominio>
Date: Sat, 2 Feb 2013 23:00:45 -0500
Message-ID: <CAOcJUbyt418Cg=5JawNq_U_4bUG+ztqB_7n7iOvwWgo-zvROhg@mail.gmail.com>
Subject: Re: af9035 test needed!
From: Michael Krufky <mkrufky@linuxtv.org>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: Antti Palosaari <crope@iki.fi>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 11, 2013 at 6:45 PM, Jose Alberto Reguero
<jareguero@telefonica.net> wrote:
> On Viernes, 11 de enero de 2013 20:38:01 Antti Palosaari escribi�:
>> Hello Jose and Gianluca
>>
>> Could you test that (tda18218 & mxl5007t):
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tune
>> r
>>
>> I wonder if ADC config logic still works for superheterodyne tuners
>> (tuner having IF). I changed it to adc / 2 always due to IT9135 tuner.
>> That makes me wonder it possible breaks tuners having IF, as ADC was
>> clocked just over 20MHz and if it is half then it is 10MHz. For BB that
>> is enough, but I think that having IF, which is 4MHz at least for 8MHz
>> BW it is too less.
>>
>> F*ck I hate to maintain driver without a hardware! Any idea where I can
>> get AF9035 device having tda18218 or mxl5007t?
>>
>> regards
>> Antti
>
> Still pending the changes for  mxl5007t. Attached is a patch for that.
>
> Changes to make work Avermedia Twinstar with the af9035 driver.
>
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>
> Jose Alberto
>
> diff -upr linux/drivers/media/tuners/mxl5007t.c
> linux.new/drivers/media/tuners/mxl5007t.c
> --- linux/drivers/media/tuners/mxl5007t.c       2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/tuners/mxl5007t.c   2013-01-10 19:23:09.247556275
> +0100
> @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
>         mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
>         mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>
> -       set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
>         set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
>         set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>

This is a configurable option - it should not be removed, just
configure your glue code to not use that option if you dont want
it.... unless there's some other reason why you're removing this?

> @@ -531,9 +530,12 @@ static int mxl5007t_tuner_init(struct mx
>         struct reg_pair_t *init_regs;
>         int ret;
>
> -       ret = mxl5007t_soft_reset(state);
> -       if (mxl_fail(ret))
> +       if (!state->config->no_reset) {
> +               ret = mxl5007t_soft_reset(state);
> +               if (mxl_fail(ret))
>                 goto fail;
> +       }
> +

this seems wrong to me.  why would you want to prevent the driver from
doing a soft reset?

>
>         /* calculate initialization reg array */
>         init_regs = mxl5007t_calc_init_regs(state, mode);
> @@ -887,7 +889,12 @@ struct dvb_frontend *mxl5007t_attach(str
>                 if (fe->ops.i2c_gate_ctrl)
>                         fe->ops.i2c_gate_ctrl(fe, 1);
>
> -               ret = mxl5007t_get_chip_id(state);
> +               if (!state->config->no_probe)
> +                       ret = mxl5007t_get_chip_id(state);
> +
> +               ret = mxl5007t_write_reg(state, 0x04,
> +                       state->config->loop_thru_enable);
> +
>

Can you explain why this change was made?  ^^

>                 if (fe->ops.i2c_gate_ctrl)
>                         fe->ops.i2c_gate_ctrl(fe, 0);
> diff -upr linux/drivers/media/tuners/mxl5007t.h
> linux.new/drivers/media/tuners/mxl5007t.h
> --- linux/drivers/media/tuners/mxl5007t.h       2012-08-14 05:45:22.000000000 +0200
> +++ linux.new/drivers/media/tuners/mxl5007t.h   2013-01-10 19:19:11.204379581
> +0100
> @@ -73,8 +73,10 @@ struct mxl5007t_config {
>         enum mxl5007t_xtal_freq xtal_freq_hz;
>         enum mxl5007t_if_freq if_freq_hz;
>         unsigned int invert_if:1;
> -       unsigned int loop_thru_enable:1;
> +       unsigned int loop_thru_enable:3;

Why widen this boolean to three bits?

>         unsigned int clk_out_enable:1;
> +       unsigned int no_probe:1;
> +       unsigned int no_reset:1;
>  };
>
>  #if defined(CONFIG_MEDIA_TUNER_MXL5007T) ||
> (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c 2013-01-07 05:45:57.000000000
> +0100
> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c     2013-01-12
> 00:30:57.557310465 +0100
> @@ -886,13 +886,17 @@ static struct mxl5007t_config af9035_mxl
>                 .loop_thru_enable = 0,
>                 .clk_out_enable = 0,
>                 .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> +               .no_probe = 1,
> +               .no_reset = 1,
>         }, {
>                 .xtal_freq_hz = MxL_XTAL_24_MHZ,
>                 .if_freq_hz = MxL_IF_4_57_MHZ,
>                 .invert_if = 0,
> -               .loop_thru_enable = 1,
> +               .loop_thru_enable = 3,
>                 .clk_out_enable = 1,
>                 .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
> +               .no_probe = 1,
> +               .no_reset = 1,
>         }
>  };
>



This patch cannot be merged as-is.  I'm sorry.  If you could explain
why each change was made, then perhaps I would be able to advise
better how to make this work on your device without breaking others.

-Mike Krufky
