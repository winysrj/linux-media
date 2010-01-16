Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:3304 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab0APOe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 09:34:58 -0500
Date: Sat, 16 Jan 2010 15:33:45 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] ov534: allow enumerating supported framerates
Message-Id: <20100116153345.c54db7aa.ospite@studenti.unina.it>
In-Reply-To: <1262997691-20651-1-git-send-email-ospite@studenti.unina.it>
References: <1262997691-20651-1-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jan_2010_15_33_45_+0100_B7PaxtSX6v=aA3iH"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__16_Jan_2010_15_33_45_+0100_B7PaxtSX6v=aA3iH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat,  9 Jan 2010 01:41:31 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:



> Index: gspca/linux/drivers/media/video/gspca/ov534.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- gspca.orig/linux/drivers/media/video/gspca/ov534.c
> +++ gspca/linux/drivers/media/video/gspca/ov534.c
> @@ -282,6 +282,21 @@
>  	 .priv =3D 0},
>  };
> =20
> +static const int qvga_rates[] =3D {125, 100, 75, 60, 50, 40, 30};
> +static const int vga_rates[] =3D {60, 50, 40, 30, 15};
> +

Hmm, after double checking compilation messages, having these as 'const'
produces two:
  warning: initialization discards qualifiers from pointer target type
in the assignments below.

If I remove the 'const' qualifiers here, the messages go away, so I'd
say we can do also without them. If that's ok I'll send a v2 soon,
sorry.

Thanks,
   Antonio

> +static const struct framerates ov772x_framerates[] =3D {
> +	{ /* 320x240 */
> +		.rates =3D qvga_rates,
> +		.nrates =3D ARRAY_SIZE(qvga_rates),
> +	},
> +	{ /* 640x480 */
> +		.rates =3D vga_rates,
> +		.nrates =3D ARRAY_SIZE(vga_rates),
> +	},
> +};
> +
> +
>  static const u8 bridge_init[][2] =3D {
>  	{ 0xc2, 0x0c },
>  	{ 0x88, 0xf8 },
> @@ -799,6 +814,7 @@
> =20
>  	cam->cam_mode =3D ov772x_mode;
>  	cam->nmodes =3D ARRAY_SIZE(ov772x_mode);
> +	cam->mode_framerates =3D ov772x_framerates;
> =20
>  	cam->bulk =3D 1;
>  	cam->bulk_size =3D 16384;


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sat__16_Jan_2010_15_33_45_+0100_B7PaxtSX6v=aA3iH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktRzkkACgkQ5xr2akVTsAHDOQCgmmXYGvDU2XA14VUbkXHB+6ks
7rIAn3IryQ71iVkcQfxATBIJVaqzI3XU
=FreX
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jan_2010_15_33_45_+0100_B7PaxtSX6v=aA3iH--
