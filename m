Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:28180 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753526AbaCaJJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 05:09:52 -0400
Message-ID: <533930D2.8060106@imgtec.com>
Date: Mon, 31 Mar 2014 10:09:38 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 04/11] rc-core: do not change 32bit NEC scancode format
 for now
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161105.13234.40393.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329161105.13234.40393.stgit@zeus.muc.hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="WDrt7nPlTD2FPotuw8tIDthmWgkLniu61"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--WDrt7nPlTD2FPotuw8tIDthmWgkLniu61
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29/03/14 16:11, David H=C3=A4rdeman wrote:
> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
>=20
> The patch ignores the fact that NEC32 scancodes are generated not only =
in the
> NEC raw decoder but also directly in some drivers. Whichever approach i=
s chosen
> it should be consistent across drivers and this patch needs more discus=
sion.
>=20
> Furthermore, I'm convinced that we have to stop playing games trying to=

> decipher the "meaning" of NEC scancodes (what's the customer/vendor/add=
ress,
> which byte is the MSB, etc).
>=20
> This patch is in preparation for the next few patches in this series.
>=20
> Signed-off-by: David H=C3=A4rdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/img-ir/img-ir-nec.c |   27 ++++++-----
>  drivers/media/rc/ir-nec-decoder.c    |    5 --
>  drivers/media/rc/keymaps/rc-tivo.c   |   86 +++++++++++++++++---------=
--------
>  3 files changed, 59 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/im=
g-ir/img-ir-nec.c
> index c0111d6..40ee844 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> @@ -5,6 +5,7 @@
>   */
> =20
>  #include "img-ir-hw.h"
> +#include <linux/bitrev.h>
> =20
>  /* Convert NEC data to a scancode */
>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protoco=
l,
> @@ -23,11 +24,11 @@ static int img_ir_nec_scancode(int len, u64 raw, en=
um rc_type *protocol,
>  	data_inv =3D (raw >> 24) & 0xff;
>  	if ((data_inv ^ data) !=3D 0xff) {
>  		/* 32-bit NEC (used by Apple and TiVo remotes) */
> -		/* scan encoding: aaAAddDD */
> -		*scancode =3D addr_inv << 24 |
> -			    addr     << 16 |
> -			    data_inv <<  8 |
> -			    data;
> +		/* scan encoding: AAaaDDdd (LSBit first) */
> +		*scancode =3D bitrev8(addr)     << 24 |
> +			    bitrev8(addr_inv) << 16 |
> +			    bitrev8(data)     <<  8 |
> +			    bitrev8(data_inv);
>  	} else if ((addr_inv ^ addr) !=3D 0xff) {
>  		/* Extended NEC */
>  		/* scan encoding: AAaaDD */
> @@ -56,13 +57,15 @@ static int img_ir_nec_filter(const struct rc_scanco=
de_filter *in,
> =20
>  	if ((in->data | in->mask) & 0xff000000) {
>  		/* 32-bit NEC (used by Apple and TiVo remotes) */
> -		/* scan encoding: aaAAddDD */
> -		addr_inv   =3D (in->data >> 24) & 0xff;
> -		addr_inv_m =3D (in->mask >> 24) & 0xff;
> -		addr       =3D (in->data >> 16) & 0xff;
> -		addr_m     =3D (in->mask >> 16) & 0xff;
> -		data_inv   =3D (in->data >>  8) & 0xff;
> -		data_inv_m =3D (in->mask >>  8) & 0xff;
> +		/* scan encoding: AAaaDDdd (LSBit first) */
> +		addr       =3D bitrev8((in->data >> 24) & 0xff);
> +		addr_m     =3D (in->mask >> 24) & 0xff;
> +		addr_inv   =3D bitrev8((in->data >> 16) & 0xff);
> +		addr_inv_m =3D (in->mask >> 16) & 0xff;
> +		data       =3D bitrev8((in->data >>  8) & 0xff);
> +		data_m     =3D (in->mask >>  8) & 0xff;
> +		data_inv   =3D bitrev8((in->data >>  0) & 0xff);
> +		data_inv_m =3D (in->mask >>  0) & 0xff;

I think the masks need bit reversing too, otherwise the mask bits won't
line up with the data as intended.

Otherwise this patch looks okay to me.

Cheers
James


--WDrt7nPlTD2FPotuw8tIDthmWgkLniu61
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOTDSAAoJEGwLaZPeOHZ6ph8P/2GKlUujbSDCr49/axN405zP
tS8RFxC1wkuGMwa9F2ADt7XI1VKWpd1m8ySPpGUJmvL9CMRgQpNFsgea8hl2SczA
MqMDCGRMOLvhoc31XAAnKqNzEG/gDap37JmFsZj45T7X5IG3gKHpEjpEDC9wJVpl
0mFTWhzAyT9ikUTFluWR5TRyQ/uGcNALQEWrGH0K+CyApWn5tu3rSbNEafYxGDYN
YAaXucGUwdtr6AA25EWWmqiRmGERdCxQEEZLgwzEHM5ZjxWkpNJViuWwWg33xziI
Xspvi3myB64Kye0CmZ53TemjoZFe4AT8noPDERBuu3K2APUvtVb6Q1IhMWWUqwil
Zt3JzzXPdj0HQrzro6mgivDejN7sqDs/hhnTmqHeLLH65iBLi/k8qUNVbya1g/HJ
q8xeC9EQQhFFA4YFsd5xyS8qfgQtWG+vAAmsx35OZT+Et32jr5Nxla8+GoDDjV0v
1DUHWkUUx3ET1NJpaKGFwxOGSI4Qq2g46xgwQsbTH7r2WA5zI5/U0QqmHbsDc1sw
5aHASaB6yHkhKIPRVqDaXr2knnoeq/UJ+q9Ono+u9ZL6fiCZ5Erkb9wddCYPlzOO
tUNDh13t5V5xjbUnxP7RtSbZudKIP33fsDBEDEzFXjhtUl85SKgBJCN8cMp18SAp
Y2alWCESRFRIjNvG+IAR
=1ycY
-----END PGP SIGNATURE-----

--WDrt7nPlTD2FPotuw8tIDthmWgkLniu61--
