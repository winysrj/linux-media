Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:59692 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754070AbeGEUBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 16:01:11 -0400
Date: Thu, 5 Jul 2018 21:16:06 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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
Message-ID: <20180705211606.79a96d22@wiggum>
In-Reply-To: <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
References: <cover.1530740760.git.mchehab+samsung@kernel.org>
 <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/NIYOq_0/6TravqEW+Ov+Q=9"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/NIYOq_0/6TravqEW+Ov+Q=9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  4 Jul 2018 23:46:56 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
> index 145407dee3db..a983899c6b0b 100644
> --- a/drivers/media/tuners/fc0011.c
> +++ b/drivers/media/tuners/fc0011.c
> @@ -472,10 +472,10 @@ static int fc0011_get_bandwidth(struct dvb_frontend=
 *fe, u32 *bandwidth)
> =20
>  static const struct dvb_tuner_ops fc0011_tuner_ops =3D {
>  	.info =3D {
> -		.name		=3D "Fitipower FC0011",
> +		.name		  =3D "Fitipower FC0011",
> =20
> -		.frequency_min	=3D 45000000,
> -		.frequency_max	=3D 1000000000,
> +		.frequency_min_hz =3D   45 * MHz,
> +		.frequency_max_hz =3D 1000 * MHz,
>  	},
> =20
>  	.release		=3D fc0011_release,

Acked-by: Michael B=C3=BCsch <m@bues.ch>

What about a GHz definition for 1000 * MHz?

--=20
Michael

--Sig_/NIYOq_0/6TravqEW+Ov+Q=9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAls+bnYACgkQ9TK+HZCN
iw5c5w//VYXsmuTefQuyln+RqGlTVZ1IkKOXKkOufZCo5NvJQ1D9XV7Xpk6wSdRA
3Ril9Q4u0CIwJHwKLPM0Y1G2Na7ZlNhtX8Wm2wgYJbAdWs4Nbsx6rE6t/Pddf9M1
jn/G9CVuvp4ohnOUTt+S8vqufvJ0X12nNNQga3GhfXAPKbKpvy2GIu3Xaz+dHpF1
MARP2b5DdVpieWJye5Cya9QjFGtjpUFRwX9lPCPKITAIQ9WFFIim1GZ0R81F9W8t
RFfIhN4SBehVWzLutdNnDLfmJT6/JGTzdSCjfYFx1xDWmqM9nJ723JdAdtfL7Nd9
w8+396yp7t4cnp5RfanUTI4CPVvPkShkVvq7yO6ZF8yzzj2wza4r01zFrt04zaXN
Jq0TL/lWazaKxHmDj44xsMH2mQd1T6/Ny7qP2DkrcInbcJWnPZ96lqWSRgCfGyuG
CXK9t/mI45TQ4nEwRYGZH/M1BOe8ycSnulEGgTWcNpifiW9Pi7qrG65hjKO/8Vda
oBipTBhrTT+gGLnCWJw46u1tdks4X9uSMjRXBcBxZIraW9Nk37tqQu1wjdB14HuA
bCD6Z/0WztyPO6s1BEXPcBSIk6d3LL5xFqx71/obs6a2NYJUZBlD4kvzTLnNxZO8
8oo3mNnqH785je/qQgh1/PAIK9lk87hEwPwMiIT0VuibyCcofFk=
=j00R
-----END PGP SIGNATURE-----

--Sig_/NIYOq_0/6TravqEW+Ov+Q=9--
