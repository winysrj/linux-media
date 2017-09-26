Return-path: <linux-media-owner@vger.kernel.org>
Received: from zimbra.linuxprofi.at ([93.83.54.199]:50554 "EHLO
        zimbra.linuxprofi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdIZLwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:52:10 -0400
Subject: Re: [PATCH 1/6] [media] tda8261: Use common error handling code in
 tda8261_set_params()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
 <28425caf-2736-96ae-00a7-3fb273b1f9d5@users.sourceforge.net>
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>
Message-ID: <bcf8d922-fde7-59a0-f3d9-3f16a2a62d9b@boehmwalder.at>
Date: Tue, 26 Sep 2017 13:45:56 +0200
MIME-Version: 1.0
In-Reply-To: <28425caf-2736-96ae-00a7-3fb273b1f9d5@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JaoT8kduORioKQdmr1dsl7S7WCjAiT5FH"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JaoT8kduORioKQdmr1dsl7S7WCjAiT5FH
Content-Type: multipart/mixed; boundary="uiW3LkmKBnrDbk7ev8H7FV2Xa7uE5l2CD";
 protected-headers="v1"
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Message-ID: <bcf8d922-fde7-59a0-f3d9-3f16a2a62d9b@boehmwalder.at>
Subject: Re: [PATCH 1/6] [media] tda8261: Use common error handling code in
 tda8261_set_params()
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
 <28425caf-2736-96ae-00a7-3fb273b1f9d5@users.sourceforge.net>
In-Reply-To: <28425caf-2736-96ae-00a7-3fb273b1f9d5@users.sourceforge.net>

--uiW3LkmKBnrDbk7ev8H7FV2Xa7uE5l2CD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26.09.2017 13:27, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 26 Sep 2017 11:01:44 +0200
>=20
> * Add a jump target so that a bit of exception handling can be better
>   reused at the end of this function.
>=20
>   This issue was detected by using the Coccinelle software.
>=20
> * The script "checkpatch.pl" pointed information out like the following=
=2E
>=20
>   ERROR: do not use assignment in if condition
>=20
>   Thus fix an affected source code place.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/dvb-frontends/tda8261.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-=
frontends/tda8261.c
> index 4eb294f330bc..5a8a9b6b8107 100644
> --- a/drivers/media/dvb-frontends/tda8261.c
> +++ b/drivers/media/dvb-frontends/tda8261.c
> @@ -129,18 +129,18 @@ static int tda8261_set_params(struct dvb_frontend=
 *fe)
> =20
>  	/* Set params */
>  	err =3D tda8261_write(state, buf);
> -	if (err < 0) {
> -		pr_err("%s: I/O Error\n", __func__);
> -		return err;
> -	}
> +	err =3D tda8261_get_status(fe, &status);
> +	if (err < 0)
> +		goto report_failure;
> +

Is this change really correct? Doesn't it query the status once more
often than before?

>  	/* sleep for some time */
>  	pr_debug("%s: Waiting to Phase LOCK\n", __func__);
>  	msleep(20);
>  	/* check status */
> -	if ((err =3D tda8261_get_status(fe, &status)) < 0) {
> -		pr_err("%s: I/O Error\n", __func__);
> -		return err;
> -	}
> +	err =3D tda8261_get_status(fe, &status);
> +	if (err < 0)
> +		goto report_failure;
> +
>  	if (status =3D=3D 1) {
>  		pr_debug("%s: Tuner Phase locked: status=3D%d\n", __func__,
>  			 status);
> @@ -150,6 +150,10 @@ static int tda8261_set_params(struct dvb_frontend =
*fe)
>  	}
> =20
>  	return 0;
> +
> +report_failure:
> +	pr_err("%s: I/O Error\n", __func__);
> +	return err;
>  }
> =20
>  static void tda8261_release(struct dvb_frontend *fe)
>=20


--=20
Regards,
Christoph


--uiW3LkmKBnrDbk7ev8H7FV2Xa7uE5l2CD--

--JaoT8kduORioKQdmr1dsl7S7WCjAiT5FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZyj35AAoJEM3PQE6B9NDDLOoQAIASDkKFxdJe++DBDJjW1gsy
tCpzHxC9VrZ0FGnZN/Wj3BlocOeUOkPTrwFHA8WIdxpmnAzu3rNvB7wCWCS5Dltm
NVwGpcbyXBuXg56zjZKx64i0bZKBzimgOxe1jTq+TFVk/1IOqo74KebZsm7yiJKC
AinkBAV+xH0ZFqE8WUJTl58vWg8s7XJD5IEj4GfOVebt4V8KATLlCTx4o+P3y2s6
tl28Miak5HIHrf9HxIkRm6RpdMM7hHe0W9p5cWQEast79Y1VFp4Sd2AGsNtL+K30
6irtRLAXuaD3oEI8AsrX1ZPb7zvSOae4DuievQBmeA864oHZC+nxMgbhE8JMWBAX
4+ZTxmQ0uLl3tfDxwdgGBSDErXJwnNbowToZXcHzxlN9Co5kfUykuklxLnh7L4B+
OH0s0oF/1RhAGK9/MEmmFa29v+ABeoecM2lh1LQCaprMzGHthtal/ozpfQsBd5o+
lr946t7PIl3M6/vXMkbUhP4Rq4JKsjHjAiG6YlCAnN3elwqMj/ZzV3bfxM24wQMg
hXBoAR7BgWEG4kLl0b3w7dGsz26RsCB5CZPQ1DBg3bqVzAsXXsVRsM0vrD//579i
2C6s41mnsd0LSt6kXGyIL0ZMtpSnSOE+ALPcvwAVGh4+AqfCduqydDVlvNm3DWsp
VLHqYKafKNOKEitoSBIY
=Ykl6
-----END PGP SIGNATURE-----

--JaoT8kduORioKQdmr1dsl7S7WCjAiT5FH--
