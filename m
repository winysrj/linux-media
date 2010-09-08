Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0IHTQG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 15:16:06 -0400
Message-ID: <4C87E0F3.3080304@redhat.com>
Date: Wed, 08 Sep 2010 16:16:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Josef Pavlik <josef@pavlik.it>
CC: linux-media@vger.kernel.org, "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [PATCH] DiSEqC bug fixed for stv0288 based interfaces
References: <201009011435.42753.josef@pavlik.it>
In-Reply-To: <201009011435.42753.josef@pavlik.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 01-09-2010 09:35, Josef Pavlik escreveu:
> Fixed problem with DiSEqC communication. The message was wrongly modulated, 
> so the DiSEqC switch was not work.
> 
> This patch fixes DiSEqC messages, simple tone burst and tone on/off. 
> I verified it with osciloscope against the DiSEqC documentation.
> 
> Interface: PCI DVB-S TV tuner TeVii S420
> Kernel: 2.6.32-24-generic (UBUNTU 10.4)
> 
> Signed-off-by: Josef Pavlik <josef@pavlik.it>

Patch doesn't apply against the latest version, at my -git tree. 
Not sure if the bugs you're pointing were already fixed.

Cheers,
Mauro.
> 
> 
> 
> 
> diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
> index 2930a5d..6a32535 100644
> --- a/drivers/media/dvb/frontends/stv0288.c
> +++ b/drivers/media/dvb/frontends/stv0288.c
> @@ -6,6 +6,8 @@
>         Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
>                 Removed stb6000 specific tuner code and revised some
>                 procedures.
> +       2010-09-01 Josef Pavlik <josef@pavlik.it>
> +               Fixed diseqc_msg, diseqc_burst and set_tone problems
> 
>         This program is free software; you can redistribute it and/or modify
>         it under the terms of the GNU General Public License as published by
> @@ -156,14 +158,13 @@ static int stv0288_send_diseqc_msg(struct dvb_frontend *fe,
> 
>         stv0288_writeregI(state, 0x09, 0);
>         msleep(30);
> -       stv0288_writeregI(state, 0x05, 0x16);
> +       stv0288_writeregI(state, 0x05, 0x12); /* modulated mode, single shot */
> 
>         for (i = 0; i < m->msg_len; i++) {
>                 if (stv0288_writeregI(state, 0x06, m->msg[i]))
>                         return -EREMOTEIO;
> -               msleep(12);
>         }
> -
> +       msleep(m->msg_len*12);
>         return 0;
>  }
> 
> @@ -174,13 +175,14 @@ static int stv0288_send_diseqc_burst(struct dvb_frontend *fe,
> 
>         dprintk("%s\n", __func__);
> 
> -       if (stv0288_writeregI(state, 0x05, 0x16))/* burst mode */
> +       if (stv0288_writeregI(state, 0x05, 0x03)) /* "simple tone burst" mode, single shot */
>                 return -EREMOTEIO;
> 
>         if (stv0288_writeregI(state, 0x06, burst == SEC_MINI_A ? 0x00 : 0xff))
>                 return -EREMOTEIO;
> 
> -       if (stv0288_writeregI(state, 0x06, 0x12))
> +       msleep(15);
> +       if (stv0288_writeregI(state, 0x05, 0x12))
>                 return -EREMOTEIO;
> 
>         return 0;
> @@ -192,18 +194,19 @@ static int stv0288_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
> 
>         switch (tone) {
>         case SEC_TONE_ON:
> -               if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode */
> +               if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode, continuous carrier */
>                         return -EREMOTEIO;
> -               return stv0288_writeregI(state, 0x06, 0xff);
> +               break;
> 
>         case SEC_TONE_OFF:
> -               if (stv0288_writeregI(state, 0x05, 0x13))/* burst mode */
> +               if (stv0288_writeregI(state, 0x05, 0x12))/* burst mode off*/
>                         return -EREMOTEIO;
> -               return stv0288_writeregI(state, 0x06, 0x00);
> +               break;
> 
>         default:
>                 return -EINVAL;
>         }
> +       return 0;
>  }
> 
>  static u8 stv0288_inittab[] = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

