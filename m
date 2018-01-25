Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out-3.itc.rwth-aachen.de ([134.130.5.48]:36834 "EHLO
        mail-out-3.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933099AbeAYDnC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 22:43:02 -0500
From: Stefan =?ISO-8859-1?Q?Br=FCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH v1 0/2] Remove duplicate driver for MyGica T230C
Date: Thu, 25 Jan 2018 04:42:46 +0100
Message-ID: <1815413.bUCumXEykP@pebbles>
In-Reply-To: <20180109233339.8147-1-stefan.bruens@rwth-aachen.de>
References: <20180109233339.8147-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1776030.ZtoRHm6gkv";
        micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1776030.ZtoRHm6gkv
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday, 10 January 2018 00:33:37 CET Stefan Br=FCns wrote:
> In 2017-02, two drivers for the T230C where submitted, but until now
> only the one based on the older dvb-usb/cxusb.c driver has been part
> of the mainline kernel. As a dvb-usb-v2 driver is preferable, remove
> the other driver.
>=20
> The cxusb.c patch also contained an unrelated change for the T230,
> i.e. a correction of the RC model. As this change apparently is
> correct, restore it. This has not been tested due to lack of hardware.
>=20
>=20
> Evgeny Plehov (1):
>   Revert "[media] dvb-usb-cxusb: Geniatech T230C support"
>=20
> Stefan Br=FCns (1):
>   [media] cxusb: restore RC_MAP for MyGica T230
>=20
>  drivers/media/usb/dvb-usb/cxusb.c | 137
> -------------------------------------- 1 file changed, 137 deletions(-)


Ping!

=2D-=20
Stefan Br=FCns  /  Bergstra=DFe 21  /  52062 Aachen
home: +49 241 53809034     mobile: +49 151 50412019
--nextPart1776030.ZtoRHm6gkv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSwWRWIpJbl0W4DemNvf0o9jP6qUwUCWmlSNgAKCRBvf0o9jP6q
U6ZzAKCJ935lTQpMb827Owymsgx4TBFXcwCfXubF/mzbAuccwgC6zWFEHPgA4tQ=
=eAcf
-----END PGP SIGNATURE-----

--nextPart1776030.ZtoRHm6gkv--
