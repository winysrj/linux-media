Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:51438 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbeIMUmg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:42:36 -0400
Received: from gagarine.paulk.fr (gagarine [192.168.1.127])
        by leonov.paulk.fr (Postfix) with ESMTPS id D1F73C01AB
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 17:32:34 +0200 (CEST)
Message-ID: <86a7faba8ada2c7be9175704215dc5f317671a5b.camel@paulk.fr>
Subject: Re: [PATCH v2] staging: cedrus: Fix checkpatch issues
From: Paul Kocialkowski <contact@paulk.fr>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Thu, 13 Sep 2018 17:32:21 +0200
In-Reply-To: <20180913115349.608531f8@coco.lan>
References: <20180913144047.6390-1-maxime.ripard@bootlin.com>
         <20180913115349.608531f8@coco.lan>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-thNy3T/Ti4HX5A/txHfS"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-thNy3T/Ti4HX5A/txHfS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-09-13 at 11:53 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Sep 2018 16:40:47 +0200
> Maxime Ripard <maxime.ripard@bootlin.com> escreveu:
>=20
>=20
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > @@ -82,10 +82,7 @@ static struct cedrus_format *cedrus_find_format(u32 =
pixelformat, u32 directions,
> >  static bool cedrus_check_format(u32 pixelformat, u32 directions,
> >  				unsigned int capabilities)
> >  {
> > -	struct cedrus_format *fmt =3D cedrus_find_format(pixelformat, directi=
ons,
> > -						       capabilities);
> > -
> > -	return fmt !=3D NULL;
> > +	return cedrus_find_format(pixelformat, directions, capabilities);
> >  }
>=20
> Hmm... just occurred to me... Why do you need this? I mean, you=20
> could simply do something like:
>=20
> $ git filter-branch -f --tree-filter 'for i in $(git grep -l cedrus_check=
_format); do \
> 	sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g -i $i; done ' or=
igin/master..
>=20
> (or just do a sed -E s,\\bcedrus_check_format\\b,cedrus_find_format,g as
> a separate patch)
>=20
> and get rid of cedrus_check_format() for good.

Agreed, the name is probably explicit enough anyway. I probably should
have done that in the first place anyway.

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-thNy3T/Ti4HX5A/txHfS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJFBAABCAAvFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluagwURHGNvbnRhY3RA
cGF1bGsuZnIACgkQhP3B6o/ulQw1aw/+OlZvSXJddM2R2JTRUTIKwdR2aobS11Hs
X1D749ApzfG9y2cqGPP9S2zfpmMqJZs3hNPRBLvfcL8lvBD0+FJLU10r6vTuZo3K
KHt1mJiv/+B7Zqgo6D9s+3U2kqXop6zoXu+pt6v5Dn3ESRKX+fqpH0jGSDP2B8b7
GcdQv6MVTTsTX4v5EE2wTfAaOcZ4yJu4OhSD+Qt1r87SzIYsfHy5Vddw4Be/8R85
eyw60iozLwZYr2BXU0adZ7A9XkPiwIJZQwWTCIckkfaxNlDdzxWZ0JGNB17k/c/k
szFHoitahftGIPhigHfj89RLg3skLWPpWz+WlvibQ/uOYECbPiWaIoey7Z/Uatay
RIAjaNdUbRrxN1RqMlY84huxa2yZKj8JNNRp4TpeVK9U3D/mWtn6ISWiK9F6pHT2
gBFe64y/ZLU9+0H1Y6YBxqzSJrIO1ls20RIHFr/vVzpEoxUDyRMnFjA8IHVR37J0
JWpryxup7JeXubID00ra43J31HQ1UTMbFJKPtOYtJMpOyop10uxBOdxMwLw0ygev
NCwWI6rCtuDxXpCu/9OVTygDtCeNxfhaScNfnguDyz/agbWKoPXtIDxbPcT9UEWU
8amjPv1+35JeAochMztTrmoCvKuEP7hh9lOIZCs/TXSN07JTYde/6QGOEngU0GAj
AYuK/ZyCzNQ=
=ftPw
-----END PGP SIGNATURE-----

--=-thNy3T/Ti4HX5A/txHfS--
