Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:51131 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754184AbeEaInH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 04:43:07 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "'Abylay Ospan'" <aospan@netup.ru>,
        =?utf-8?B?U3V6dWtpLCBLYXRzdWhpcm8v6Yi05pyoIOWLneWNmg==?=
        <suzuki.katsuhiro@socionext.com>
Cc: "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20180516084111.28618-1-suzuki.katsuhiro@socionext.com> <CAK3bHNW8=z2WH6xCijAP2XCX94iE5z-HwHRYNhbJwZvbOav10A@mail.gmail.com>
In-Reply-To: <CAK3bHNW8=z2WH6xCijAP2XCX94iE5z-HwHRYNhbJwZvbOav10A@mail.gmail.com>
Subject: Re: [PATCH] media: helene: fix tuning frequency of satellite
Date: Thu, 31 May 2018 17:43:01 +0900
Message-ID: <004201d3f8bb$629d38c0$27d7aa40$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Abylay,

I got a mistake in this patch.

DTV_FREQUENCY for satellite delivery systems, the frequency is in 'kHz' not 'Hz',
so original code is correct. Sorry for confusing...


Regards,
--
Katsuhiro Suzuki


> -----Original Message-----
> From: Abylay Ospan <aospan@netup.ru>
> Sent: Wednesday, May 16, 2018 7:58 PM
> To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; linux-media
> <linux-media@vger.kernel.org>; Masami Hiramatsu <masami.hiramatsu@linaro.org>;
> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] media: helene: fix tuning frequency of satellite
> 
> True.
> I'm curious but how did it worked before ...
> Which hardware (dvb adapter) are you using ?
> 
> 2018-05-16 4:41 GMT-04:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> > This patch fixes tuning frequency of satellite to kHz. That as same
> > as terrestrial one.
> >
> > Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> > ---
> >  drivers/media/dvb-frontends/helene.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/dvb-frontends/helene.c
> b/drivers/media/dvb-frontends/helene.c
> > index 04033f0c278b..0a4f312c4368 100644
> > --- a/drivers/media/dvb-frontends/helene.c
> > +++ b/drivers/media/dvb-frontends/helene.c
> > @@ -523,7 +523,7 @@ static int helene_set_params_s(struct dvb_frontend *fe)
> >         enum helene_tv_system_t tv_system;
> >         struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> >         struct helene_priv *priv = fe->tuner_priv;
> > -       int frequencykHz = p->frequency;
> > +       int frequencykHz = p->frequency / 1000;
> >         uint32_t frequency4kHz = 0;
> >         u32 symbol_rate = p->symbol_rate/1000;
> >
> > --
> > 2.17.0
> >
> 
> 
> 
> --
> Abylay Ospan,
> NetUP Inc.
> http://www.netup.tv
