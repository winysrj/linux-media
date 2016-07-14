Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:48947 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbcGNUZ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 16:25:27 -0400
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com [209.85.223.172])
	by imap.netup.ru (Postfix) with ESMTPA id 64B1F7C0515
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 23:25:23 +0300 (MSK)
Received: by mail-io0-f172.google.com with SMTP id m101so86175467ioi.2
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 13:25:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2a0edab5ab7b0e0743b04a64c935d798d3930856.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
 <2a0edab5ab7b0e0743b04a64c935d798d3930856.1467381792.git.mchehab@s-opensource.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Thu, 14 Jul 2016 16:25:02 -0400
Message-ID: <CAK3bHNUWPuYZ6rn_Ktqgn8f4C+Axk1i_gsTGcB9zZCWcpd0KrA@mail.gmail.com>
Subject: Re: [PATCH 4/4] cxd2841er: adjust the dB scale for DVB-C
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Acked-by: Abylay Ospan <aospan@netup.ru>

I have checked values with reference signal from my modulator for
DVB-C. Formula is working fine. Thanks !


2016-07-01 10:03 GMT-04:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Instead of using a relative frequency range, calibrate it to
> show the results in dB. The callibration was done getting
> samples with a signal generated from -50dBm to -12dBm,
> incremented in steps of 0.5 dB, using 3 frequencies:
> 175 MHz, 410 MHz and 800 MHz. The modulated signal was
> using QAM64, and it was used a linear interpolation of all
> the results.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index e2f3ea55897b..6c660761563d 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -1746,8 +1746,13 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
>         case SYS_DVBC_ANNEX_A:
>                 strength = cxd2841er_read_agc_gain_t_t2(priv,
>                                                         p->delivery_system);
> -               p->strength.stat[0].scale = FE_SCALE_RELATIVE;
> -               p->strength.stat[0].uvalue = strength;
> +               p->strength.stat[0].scale = FE_SCALE_DECIBEL;
> +               /*
> +                * Formula was empirically determinated via linear regression,
> +                * using frequencies: 175 MHz, 410 MHz and 800 MHz, and a
> +                * stream modulated with QAM64
> +                */
> +               p->strength.stat[0].uvalue = ((s32)strength) * 4045 / 1000 - 85224;
>                 break;
>         case SYS_ISDBT:
>                 strength = 65535 - cxd2841er_read_agc_gain_i(
> --
> 2.7.4
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
