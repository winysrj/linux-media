Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:50749 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab1EZHrk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 03:47:40 -0400
Date: Thu, 26 May 2011 09:47:30 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] gspca/kinect: wrap gspca_debug with GSPCA_DEBUG
Message-Id: <20110526094730.bbf9d1e9.ospite@studenti.unina.it>
In-Reply-To: <20110526084912.1ac3ac37@tele>
References: <1306305788.2390.4.camel@porites>
	<1306359272-30792-1-git-send-email-jarod@redhat.com>
	<20110526084912.1ac3ac37@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_May_2011_09_47_30_+0200_ro5L3Ga5A_XO4E9L"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Thu__26_May_2011_09_47_30_+0200_ro5L3Ga5A_XO4E9L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 May 2011 08:49:12 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 25 May 2011 17:34:32 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>=20
> > diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/g=
spca/kinect.c
> > index 66671a4..26fc206 100644
> > --- a/drivers/media/video/gspca/kinect.c
> > +++ b/drivers/media/video/gspca/kinect.c
> > @@ -34,7 +34,7 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.=
it>");
> >  MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
> >  MODULE_LICENSE("GPL");
> > =20
> > -#ifdef DEBUG
> > +#ifdef GSPCA_DEBUG
> >  int gspca_debug =3D D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_P=
ACK |
> >  	D_USBI | D_USBO | D_V4L2;
> >  #endif
>=20
> Hi Jarod,
>=20
> Sorry, it is not the right fix. In fact, the variable gspca_debug must
> not be defined in gspca subdrivers:
>=20
> --- a/drivers/media/video/gspca/kinect.c
> +++ b/drivers/media/video/gspca/kinect.c
> @@ -34,11 +34,6 @@
>  MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
>  MODULE_LICENSE("GPL");
> =20
> -#ifdef DEBUG
> -int gspca_debug =3D D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PAC=
K |
> -	D_USBI | D_USBO | D_V4L2;
> -#endif
> -
>  struct pkt_hdr {
>  	uint8_t magic[2];
>  	uint8_t pad;
>=20

OK.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__26_May_2011_09_47_30_+0200_ro5L3Ga5A_XO4E9L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3eBZIACgkQ5xr2akVTsAEuAACfeKV4rMuJt52Hl8OeFvdjXmTM
rgUAoK8nHMltRxUpKyF5kwjuTgr/ell0
=8bL+
-----END PGP SIGNATURE-----

--Signature=_Thu__26_May_2011_09_47_30_+0200_ro5L3Ga5A_XO4E9L--
