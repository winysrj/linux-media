Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0I2M3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 08:29:14 -0400
Received: by eyb6 with SMTP id 6so173654eyb.19
        for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 05:29:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928154659.0e7e4147@pedra>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154659.0e7e4147@pedra>
Date: Wed, 29 Sep 2010 08:29:12 -0400
Message-ID: <AANLkTi=0hoZm4QR_QnK5fpV3D-kQcJqQdOawZgYsAfOD@mail.gmail.com>
Subject: Re: [PATCH 08/10] V4L/DVB: tda18271: allow restricting max out to 4 bytes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> By default, tda18271 tries to optimize I2C bus by updating all registers
> at the same time. Unfortunately, some devices doesn't support it.
>
> The current logic has a problem when small_i2c is equal to 8, since there
> are some transfers using 11 + 1 bytes.
>
> Fix the problem by enforcing the max size at the right place, and allows
> reducing it to max = 3 + 1.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
> index e1f6782..195b30e 100644
> --- a/drivers/media/common/tuners/tda18271-common.c
> +++ b/drivers/media/common/tuners/tda18271-common.c
> @@ -193,20 +193,46 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>        unsigned char *regs = priv->tda18271_regs;
>        unsigned char buf[TDA18271_NUM_REGS + 1];
>        struct i2c_msg msg = { .addr = priv->i2c_props.addr, .flags = 0,
> -                              .buf = buf, .len = len + 1 };
> -       int i, ret;
> +                              .buf = buf };
> +       int i, ret = 1, max;
>
>        BUG_ON((len == 0) || (idx + len > sizeof(buf)));
>
> -       buf[0] = idx;
> -       for (i = 1; i <= len; i++)
> -               buf[i] = regs[idx - 1 + i];
> +
> +       switch (priv->small_i2c) {
> +       case TDA18271_03_BYTE_CHUNK_INIT:
> +               max = 3;
> +               break;
> +       case TDA18271_08_BYTE_CHUNK_INIT:
> +               max = 8;
> +               break;
> +       case TDA18271_16_BYTE_CHUNK_INIT:
> +               max = 16;
> +               break;
> +       case TDA18271_39_BYTE_CHUNK_INIT:
> +       default:
> +               max = 39;
> +       }
>
>        tda18271_i2c_gate_ctrl(fe, 1);
> +       while (len) {
> +               if (max > len)
> +                       max = len;
>
> -       /* write registers */
> -       ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
> +               buf[0] = idx;
> +               for (i = 1; i <= max; i++)
> +                       buf[i] = regs[idx - 1 + i];
>
> +               msg.len = max + 1;
> +
> +               /* write registers */
> +               ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
> +               if (ret != 1)
> +                       break;
> +
> +               idx += max;
> +               len -= max;
> +       }
>        tda18271_i2c_gate_ctrl(fe, 0);
>
>        if (ret != 1)
> @@ -326,24 +352,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>        regs[R_EB22] = 0x48;
>        regs[R_EB23] = 0xb0;
>
> -       switch (priv->small_i2c) {
> -       case TDA18271_08_BYTE_CHUNK_INIT:
> -               tda18271_write_regs(fe, 0x00, 0x08);
> -               tda18271_write_regs(fe, 0x08, 0x08);
> -               tda18271_write_regs(fe, 0x10, 0x08);
> -               tda18271_write_regs(fe, 0x18, 0x08);
> -               tda18271_write_regs(fe, 0x20, 0x07);
> -               break;
> -       case TDA18271_16_BYTE_CHUNK_INIT:
> -               tda18271_write_regs(fe, 0x00, 0x10);
> -               tda18271_write_regs(fe, 0x10, 0x10);
> -               tda18271_write_regs(fe, 0x20, 0x07);
> -               break;
> -       case TDA18271_39_BYTE_CHUNK_INIT:
> -       default:
> -               tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
> -               break;
> -       }
> +       tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
>
>        /* setup agc1 gain */
>        regs[R_EB17] = 0x00;
> diff --git a/drivers/media/common/tuners/tda18271.h b/drivers/media/common/tuners/tda18271.h
> index d7fcc36..3abb221 100644
> --- a/drivers/media/common/tuners/tda18271.h
> +++ b/drivers/media/common/tuners/tda18271.h
> @@ -80,8 +80,9 @@ enum tda18271_output_options {
>
>  enum tda18271_small_i2c {
>        TDA18271_39_BYTE_CHUNK_INIT = 0,
> -       TDA18271_16_BYTE_CHUNK_INIT = 1,
> -       TDA18271_08_BYTE_CHUNK_INIT = 2,
> +       TDA18271_16_BYTE_CHUNK_INIT = 16,
> +       TDA18271_08_BYTE_CHUNK_INIT = 8,
> +       TDA18271_03_BYTE_CHUNK_INIT = 3,
>  };
>
>  struct tda18271_config {
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index fa406b9..1a047c5 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -428,7 +428,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
>        {
>                struct tda18271_config cfg = {
>                        .config = t->config,
> -                       .small_i2c = TDA18271_08_BYTE_CHUNK_INIT,
> +                       .small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
>                };
>
>                if (!dvb_attach(tda18271_attach, &t->fe, t->i2c->addr,
> --
> 1.7.1
>
>
>

Adding the maintainer for the 18271 driver to the CC.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
