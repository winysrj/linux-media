Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60485 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbZKHByG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 20:54:06 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1257644422.6895.8.camel@palomino.walls.org>
References: <1257630681.15927.423.camel@localhost>
	 <1257644422.6895.8.camel@palomino.walls.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S0beu7D3epMmxCTaC8kD"
Date: Sun, 08 Nov 2009 01:53:58 +0000
Message-ID: <1257645238.15927.624.camel@localhost>
Mime-Version: 1.0
Subject: Re: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-S0beu7D3epMmxCTaC8kD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-07 at 20:40 -0500, Andy Walls wrote:
> On Sat, 2009-11-07 at 21:51 +0000, Ben Hutchings wrote:
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/media/video/cx18/cx18-av-firmware.c |    1 +
> >  drivers/media/video/cx18/cx18-dvb.c         |    2 ++
> >  drivers/media/video/cx18/cx18-firmware.c    |    3 +++
> >  3 files changed, 6 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/medi=
a/video/cx18/cx18-av-firmware.c
> > index b9e8cc5..137445c 100644
> > --- a/drivers/media/video/cx18/cx18-av-firmware.c
> > +++ b/drivers/media/video/cx18/cx18-av-firmware.c
> > @@ -32,6 +32,7 @@
> >  #define CX18_AI1_MUX_INVALID 0x30
> > =20
> >  #define FWFILE "v4l-cx23418-dig.fw"
> > +MODULE_FIRMWARE(FWFILE);
> > =20
> >  static int cx18_av_verifyfw(struct cx18 *cx, const struct firmware *fw=
)
> >  {
> > diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/=
cx18/cx18-dvb.c
> > index 51a0c33..9f70168 100644
> > --- a/drivers/media/video/cx18/cx18-dvb.c
> > +++ b/drivers/media/video/cx18/cx18-dvb.c
> > @@ -131,6 +131,8 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stre=
am *stream,
> >  	return ret;
> >  }
> > =20
> > +MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
> > +
>=20
> Ben,
>=20
> This particular firmware is only needed by one relatively rare TV card.
> Is there any way for MODULE_FIRMWARE advertisements to hint at
> "mandatory" vs. "particular case(s)"?

No, but perhaps there ought to be.  In this case the declaration could
be left out for now.  It is only critical to list all firmware in
drivers that may be needed for booting.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-S0beu7D3epMmxCTaC8kD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASvYksOe/yOyVhhEJAQLvbg//dB0wBWg1Yf8EZSMGKgaFtaDSbHGWuDXK
pyYlgk2gY5Udhq2kSYt8A+UWBADfoNWWV7wiQnLJfLi2IiQ3BeZr20WxUEz4fdwr
LVJVNZMIsXTEDQCE467PG9yGYjqU9WOjUDOaEtW4wNEvvJXgIbxQTcocbAo1+W0G
QnD90f0cbb279/apoYhvuiB7gNbEdD27sz36C0vh8l6gYDeKdwRRRwk7ooXpo+si
yU+PIH2kemzbfHN1sRTlQJDvXk7kXaMLBaYZ9JxbBOQmR6r4BxfSdFpUtiVpqfsy
wk7CtvUOF8Cqfav4/AG3+xizgGe1+mDEKK1v8tbIdob8L7MMMNktTQjr1PIgeiLj
E2adPL6W1Avi/R8Oseh5TF+sdrZuUc/BFOMF9zD1ueauEEWQw+RQU0Mva3cz6Xyb
VmviVUlla/pT8NDrI+PwO5rv19WY32UhFQS1MX6ddgyyqBx+Xqvjm+2Oc/05xo+o
02md4RNlOmHpwD1o9rQarE5lFQjHrfssyG7N+eFzOLybaejcsnagoMJ4ZVvyvejt
eobVMs7e+O3m0/MdLvzrI+0Yyw7xt3IdlCzM3V0HbYEFLPLPlvNaCL3Ule9+KsC2
nXkR/qaHgdTTW2tFr8Cx4r77nVC8GaLXrr24fXDh150RRp4vcOYd43bYalIQ7q70
7GIYOiNiLP0=
=CWkn
-----END PGP SIGNATURE-----

--=-S0beu7D3epMmxCTaC8kD--
