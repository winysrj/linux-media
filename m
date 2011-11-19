Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:41606 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab1KSWs4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 17:48:56 -0500
Date: Sat, 19 Nov 2011 23:48:45 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Ezequiel <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org, elezegarcia@yahoo.com.ar,
	moinejf@free.fr
Subject: Re: [PATCH v2] [media] gspca: replaced static allocation by
 video_device_alloc/video_device_release
Message-Id: <20111119234845.df8dd3f244c2044a26798941@studenti.unina.it>
In-Reply-To: <20111119214621.GA2739@localhost>
References: <20111119214621.GA2739@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Nov_2011_23_48_45_+0100_fQa1ZxSVFeItGVsL"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Sat__19_Nov_2011_23_48_45_+0100_fQa1ZxSVFeItGVsL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Nov 2011 18:46:21 -0300
Ezequiel <elezegarcia@gmail.com> wrote:

> Pushed video_device initialization into a separate function.
> Replace static allocation of struct video_device by=20
> video_device_alloc/video_device_release usage.
>=20
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---

Hi Ezequiel,

just a general comment on commit messages: when doing some invasive
changes it is especially important to explain the WHY next to the WHAT
and the high-level HOW.

[...]
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspc=
a/gspca.c
> index 881e04c..1f27f05 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -1292,10 +1292,12 @@ static int vidioc_enum_frameintervals(struct file=
 *filp, void *priv,
> =20
[...]

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__19_Nov_2011_23_48_45_+0100_fQa1ZxSVFeItGVsL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7IMk0ACgkQ5xr2akVTsAEjQQCgri47XCgnyaXZYP1DUmyh29KZ
gBsAn0+n6O3VaEVWTn9tFYHJoTgDpVCp
=g+hm
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Nov_2011_23_48_45_+0100_fQa1ZxSVFeItGVsL--
