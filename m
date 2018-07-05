Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbeGEVbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 17:31:13 -0400
Date: Thu, 5 Jul 2018 18:31:04 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Antti Palosaari <crope@iki.fi>, Sergey Kozlov <serjk@netup.ru>,
        Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 1/2] media: dvb: convert tuner_info frequencies to Hz
Message-ID: <20180705183056.7ce1bf6c@coco.lan>
In-Reply-To: <20180705211606.79a96d22@wiggum>
References: <cover.1530740760.git.mchehab+samsung@kernel.org>
        <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
        <20180705211606.79a96d22@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Jul 2018 21:16:06 +0200
Michael B=C3=BCsch <m@bues.ch> escreveu:

> On Wed,  4 Jul 2018 23:46:56 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
>=20
> > diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc001=
1.c
> > index 145407dee3db..a983899c6b0b 100644
> > --- a/drivers/media/tuners/fc0011.c
> > +++ b/drivers/media/tuners/fc0011.c
> > @@ -472,10 +472,10 @@ static int fc0011_get_bandwidth(struct dvb_fronte=
nd *fe, u32 *bandwidth)
> > =20
> >  static const struct dvb_tuner_ops fc0011_tuner_ops =3D {
> >  	.info =3D {
> > -		.name		=3D "Fitipower FC0011",
> > +		.name		  =3D "Fitipower FC0011",
> > =20
> > -		.frequency_min	=3D 45000000,
> > -		.frequency_max	=3D 1000000000,
> > +		.frequency_min_hz =3D   45 * MHz,
> > +		.frequency_max_hz =3D 1000 * MHz,
> >  	},
> > =20
> >  	.release		=3D fc0011_release, =20
>=20
> Acked-by: Michael B=C3=BCsch <m@bues.ch>
>=20
> What about a GHz definition for 1000 * MHz?

Not sure if it would be worth. The main goal of using the multiplier
macros it so make easier to recognize values. Reading up to 4-5
digits is usually easy for humans.

In particular, my main goal is to make it easier to check if the
values for each driver is OK for me, while writing the patch,
and for reviewers to check if the values make sense.

Also, almost all DVB-T and DVB-C drivers use a max frequency around=20
850 MHz, and almost all DVB-S uses 2150 MHz. On both cases, it
is better to write the values in MHz.

So, the only case where GHZ would be used, in practice would be
on two drivers:

$ git grep "1000 \* MHz"
drivers/media/tuners/fc0011.c:          .frequency_max_hz =3D 1000 * MHz,
drivers/media/tuners/mc44s803.c:                .frequency_max_hz  =3D 1000=
 * MHz,

Thanks,
Mauro
