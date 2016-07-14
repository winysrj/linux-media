Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:49048 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbcGNU1g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 16:27:36 -0400
Received: from mail-it0-f48.google.com (mail-it0-f48.google.com [209.85.214.48])
	by imap.netup.ru (Postfix) with ESMTPA id E787D7C052A
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 23:27:32 +0300 (MSK)
Received: by mail-it0-f48.google.com with SMTP id f6so2460698ith.0
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2016 13:27:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <61dea922c711592c5bf13a2ced7da4b31fa8a9fc.1467381792.git.mchehab@s-opensource.com>
References: <75889448cdfcea311a0c0f5e1c8cc022915dd4fe.1467381792.git.mchehab@s-opensource.com>
 <61dea922c711592c5bf13a2ced7da4b31fa8a9fc.1467381792.git.mchehab@s-opensource.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Thu, 14 Jul 2016 16:27:11 -0400
Message-ID: <CAK3bHNXefzLVu9tVPSNq0qp7ECpEmUWzCqsaq-TaaZUNcV9EMw@mail.gmail.com>
Subject: Re: [PATCH 2/4] cxd2841er: provide signal strength for DVB-C
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sergey Kozlov <serjk@netup.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a mistake. Instead of 'cxd2841er_read_agc_gain_t_t2' should
'cxd2841er_read_agc_gain_c' be used for SYS_DVBC_ANNEX_ case.

and should we use all DVB-C variants (  case SYS_DVBC_ANNEX_A, case
SYS_DVBC_ANNEX_B, case SYS_DVBC_ANNEX_C ) here ?


2016-07-01 10:03 GMT-04:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Currently, there's no stats for DVB-C. Let's at least return
> signal strength. The scale is different than on DVB-T, so let's
> use a relative scale, for now.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 543b20155efc..e35f5d0d3f34 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -1752,6 +1752,12 @@ static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
>                 /* Formula was empirically determinated @ 410 MHz */
>                 p->strength.stat[0].uvalue = ((s32)strength) * 366 / 100 - 89520;
>                 break;  /* Code moved out of the function */
> +       case SYS_DVBC_ANNEX_A:
> +               strength = cxd2841er_read_agc_gain_t_t2(priv,
> +                                                       p->delivery_system);
> +               p->strength.stat[0].scale = FE_SCALE_RELATIVE;
> +               p->strength.stat[0].uvalue = strength;
> +               break;
>         case SYS_ISDBT:
>                 strength = 65535 - cxd2841er_read_agc_gain_i(
>                                 priv, p->delivery_system);
> --
> 2.7.4
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
