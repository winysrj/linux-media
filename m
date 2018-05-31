Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:42439 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754820AbeEaNXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 09:23:04 -0400
MIME-Version: 1.0
In-Reply-To: <004201d3f8bb$629d38c0$27d7aa40$@socionext.com>
References: <20180516084111.28618-1-suzuki.katsuhiro@socionext.com>
 <CAK3bHNW8=z2WH6xCijAP2XCX94iE5z-HwHRYNhbJwZvbOav10A@mail.gmail.com> <004201d3f8bb$629d38c0$27d7aa40$@socionext.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Thu, 31 May 2018 09:22:39 -0400
Message-ID: <CAK3bHNWTw72sMB-X6ChtakAKi2TmJ6K8ZJZdjMoiMpVqPPBMoA@mail.gmail.com>
Subject: Re: [PATCH] media: helene: fix tuning frequency of satellite
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok, got it !

2018-05-31 4:43 GMT-04:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>=
:
> Hello Abylay,
>
> I got a mistake in this patch.
>
> DTV_FREQUENCY for satellite delivery systems, the frequency is in 'kHz' n=
ot 'Hz',
> so original code is correct. Sorry for confusing...
>
>
> Regards,
> --
> Katsuhiro Suzuki
>
>
>> -----Original Message-----
>> From: Abylay Ospan <aospan@netup.ru>
>> Sent: Wednesday, May 16, 2018 7:58 PM
>> To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzuki.kats=
uhiro@socionext.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>; linux-media
>> <linux-media@vger.kernel.org>; Masami Hiramatsu <masami.hiramatsu@linaro=
.org>;
>> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradea=
d.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] media: helene: fix tuning frequency of satellite
>>
>> True.
>> I'm curious but how did it worked before ...
>> Which hardware (dvb adapter) are you using ?
>>
>> 2018-05-16 4:41 GMT-04:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.c=
om>:
>> > This patch fixes tuning frequency of satellite to kHz. That as same
>> > as terrestrial one.
>> >
>> > Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
>> > ---
>> >  drivers/media/dvb-frontends/helene.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/media/dvb-frontends/helene.c
>> b/drivers/media/dvb-frontends/helene.c
>> > index 04033f0c278b..0a4f312c4368 100644
>> > --- a/drivers/media/dvb-frontends/helene.c
>> > +++ b/drivers/media/dvb-frontends/helene.c
>> > @@ -523,7 +523,7 @@ static int helene_set_params_s(struct dvb_frontend=
 *fe)
>> >         enum helene_tv_system_t tv_system;
>> >         struct dtv_frontend_properties *p =3D &fe->dtv_property_cache;
>> >         struct helene_priv *priv =3D fe->tuner_priv;
>> > -       int frequencykHz =3D p->frequency;
>> > +       int frequencykHz =3D p->frequency / 1000;
>> >         uint32_t frequency4kHz =3D 0;
>> >         u32 symbol_rate =3D p->symbol_rate/1000;
>> >
>> > --
>> > 2.17.0
>> >
>>
>>
>>
>> --
>> Abylay Ospan,
>> NetUP Inc.
>> http://www.netup.tv
>
>



--=20
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
