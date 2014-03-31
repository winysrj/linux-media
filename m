Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:16061 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753467AbaCaJo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 05:44:56 -0400
Message-ID: <5339390B.6030709@imgtec.com>
Date: Mon, 31 Mar 2014 10:44:43 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC scancodes
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kLggSAB6JbkfgQasjkWpakiScigs3BVA5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--kLggSAB6JbkfgQasjkWpakiScigs3BVA5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29/03/14 16:11, David H=C3=A4rdeman wrote:
> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-cor=
e
> and the nec decoder without any loss of functionality.
>=20
> In order to maintain backwards compatibility, some heuristics are added=

> in rc-main.c to convert scancodes to NEC32 as necessary.
>=20
> I plan to introduce a different ioctl later which makes the protocol
> explicit (and which expects all NEC scancodes to be 32 bit, thereby
> removing the need for guesswork).
>=20
> Signed-off-by: David H=C3=A4rdeman <david@hardeman.nu>
> ---
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/im=
g-ir/img-ir-nec.c
> index 40ee844..133ea45 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> @@ -5,42 +5,20 @@
>   */
> =20
>  #include "img-ir-hw.h"
> -#include <linux/bitrev.h>
> =20
>  /* Convert NEC data to a scancode */
>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protoco=
l,
>  			       u32 *scancode, u64 enabled_protocols)
>  {
> -	unsigned int addr, addr_inv, data, data_inv;
>  	/* a repeat code has no data */
>  	if (!len)
>  		return IMG_IR_REPEATCODE;
> +
>  	if (len !=3D 32)
>  		return -EINVAL;
> -	/* raw encoding: ddDDaaAA */
> -	addr     =3D (raw >>  0) & 0xff;
> -	addr_inv =3D (raw >>  8) & 0xff;
> -	data     =3D (raw >> 16) & 0xff;
> -	data_inv =3D (raw >> 24) & 0xff;
> -	if ((data_inv ^ data) !=3D 0xff) {
> -		/* 32-bit NEC (used by Apple and TiVo remotes) */
> -		/* scan encoding: AAaaDDdd (LSBit first) */
> -		*scancode =3D bitrev8(addr)     << 24 |
> -			    bitrev8(addr_inv) << 16 |
> -			    bitrev8(data)     <<  8 |
> -			    bitrev8(data_inv);
> -	} else if ((addr_inv ^ addr) !=3D 0xff) {
> -		/* Extended NEC */
> -		/* scan encoding: AAaaDD */
> -		*scancode =3D addr     << 16 |
> -			    addr_inv <<  8 |
> -			    data;
> -	} else {
> -		/* Normal NEC */
> -		/* scan encoding: AADD */
> -		*scancode =3D addr << 8 |
> -			    data;
> -	}
> +
> +	/* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
> +	*scancode =3D swab32((u32)raw);

What's the point of the byte swapping?

Surely the most natural NEC encoding would just treat it as a single
32-bit (LSBit first) field rather than 4 8-bit fields that needs swapping=
=2E

Cheers
James


--kLggSAB6JbkfgQasjkWpakiScigs3BVA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOTkLAAoJEGwLaZPeOHZ61zIP+QHeTrZem6sOGmPHqh4ufqWP
3rd1jgnS0smu3vYQIryvUo8AtiGHAv1L+LgCxTqQCHBzTL4f3/NZ2aE7dZmwEVPh
eujfjVvqKXEefcO0Y+jNujx60/EGXjH02wJRosbdFnME9dF7NRC6Nbi1SYFY61sm
5vQ8s2rushvhvWtG6WXPZBFfVbWQnHdyLa+F2WOub3heT0er2SuloDK/dmDyBAn/
rKEklrvJxJFvxizbtnNVVS8jYdOIl84JT2fqlxHp1DoqGHw16so6pZXbkC+09Azh
VttL8sVuVzQsFEF/45cfm2klkPoGiS+U+1Gs4/gpFN1kk15/0NbCE+bIgVNr25If
i/tod3MZJRlaKtTi+61fAoKZzb5nTSxbQVdHP4OFkhSS0kGg7ZAlbnqNnU9znATB
plYUgOyMx3Da0fiRR0GY0uO6ygwO53vaoRGd4mCOr03U+pdS3pRa5guWJk87E1QI
VNyyvffXYlzbB0nzzHwqKBuK6OABPHI4ffpudXPPrGbReuIKjhaL3jZ1pRcrmeHT
s8kB5WsU6ZNjOkKiVbivcU0kkGJvtcowwKamoN7eOgSKGQG/mWS9FSXTALWeOBHf
Rw5RfNnEyjKC+i7GDmx+xjlVfHWHmxRtziLUZwKf+045oIG3BvgtrvXsUhec4QWa
rTRZTL6GgFD4QgxQ42EF
=DbTR
-----END PGP SIGNATURE-----

--kLggSAB6JbkfgQasjkWpakiScigs3BVA5--
