Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33835 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2K2TlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 14:41:22 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so12686470iea.19
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 11:41:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <165401354217258@web24d.yandex.ru>
References: <165401354217258@web24d.yandex.ru>
Date: Thu, 29 Nov 2012 16:41:21 -0300
Message-ID: <CALF0-+UXuhvYomsn1L9tY4QHsf9VOcwdoHXHFtCjodLc49zT-w@mail.gmail.com>
Subject: Re: [PATCH] stv0900: Multistream support
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: CrazyCat <crazycat69@yandex.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Evgeny,

On Thu, Nov 29, 2012 at 4:27 PM, CrazyCat <crazycat69@yandex.ru> wrote:
> Multistream support for stv0900. For Netup Dual S2 CI with STV0900BAC/AAC.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
> index b551ca3..0fb34e1 100644
> --- a/drivers/media/dvb-frontends/stv0900_core.c
> +++ b/drivers/media/dvb-frontends/stv0900_core.c
> @@ -1558,6 +1558,27 @@ static int stv0900_status(struct stv0900_internal *intp,
>         return locked;
>  }
>
> +static int stv0900_set_mis(struct stv0900_internal *intp,
> +                               enum fe_stv0900_demod_num demod, int mis)
> +{
> +       enum fe_stv0900_error error = STV0900_NO_ERROR;
> +
> +       dprintk("%s\n", __func__);
> +

Mmm, that's a pretty useless printk, IMHO.
If someone wants to trace a driver it's better to use ftrace, again IMHO.


> +       if (mis < 0 || mis > 255) {
> +               dprintk("Disable MIS filtering\n");
> +               stv0900_write_bits(intp, FILTER_EN, 0);
> +       } else {
> +               dprintk("Enable MIS filtering - %d\n", mis);
> +               stv0900_write_bits(intp, FILTER_EN, 1);
> +               stv0900_write_reg(intp, ISIENTRY, mis);
> +               stv0900_write_reg(intp, ISIBITENA, 0xff);
> +       }
> +
> +       return error;

What's the point in returning an error if you don't use set it and
don't use it below?
I believe you can have this function return void.

> +}
> +
> +
>  static enum dvbfe_search stv0900_search(struct dvb_frontend *fe)
>  {
>         struct stv0900_state *state = fe->demodulator_priv;
> @@ -1578,6 +1599,8 @@ static enum dvbfe_search stv0900_search(struct dvb_frontend *fe)
>         if (state->config->set_ts_params)
>                 state->config->set_ts_params(fe, 0);
>
> +       stv0900_set_mis(intp, demod, c->stream_id);
> +
>         p_result.locked = FALSE;
>         p_search.path = demod;
>         p_search.frequency = c->frequency;
> @@ -1935,6 +1958,9 @@ struct dvb_frontend *stv0900_attach(const struct stv0900_config *config,
>                 if (err_stv0900)
>                         goto error;
>
> +               if (state->internal->chip_id >= 0x30)
> +                       state->frontend.ops.info.caps |= FE_CAN_MULTISTREAM;
> +
>                 break;
>         default:
>                 goto error;
> diff --git a/drivers/media/dvb-frontends/stv0900_reg.h b/drivers/media/dvb-frontends/stv0900_reg.h
> index 731afe9..511ed2a 100644
> --- a/drivers/media/dvb-frontends/stv0900_reg.h
> +++ b/drivers/media/dvb-frontends/stv0900_reg.h
> @@ -3446,8 +3446,11 @@ extern s32 shiftx(s32 x, int demod, s32 shift);
>  #define R0900_P1_PDELCTRL1 0xf550
>  #define PDELCTRL1 REGx(R0900_P1_PDELCTRL1)
>  #define F0900_P1_INV_MISMASK 0xf5500080
> +#define INV_MISMASK FLDx(F0900_P1_INV_MISMASK)
>  #define F0900_P1_FILTER_EN 0xf5500020
> +#define FILTER_EN FLDx(F0900_P1_FILTER_EN)
>  #define F0900_P1_EN_MIS00 0xf5500002
> +#define EN_MIS00 FLDx(F0900_P1_EN_MIS00)
>  #define F0900_P1_ALGOSWRST 0xf5500001
>  #define ALGOSWRST FLDx(F0900_P1_ALGOSWRST)
>
> --

Thanks,

    Ezequiel
