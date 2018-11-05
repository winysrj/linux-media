Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45804 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKES03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 13:26:29 -0500
Date: Mon, 5 Nov 2018 10:07:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>
Subject: Re: [PATCH 05/11] [media] marvell-ccic: don't generate EOF on
 parallel bus
Message-ID: <20181105090745.GA3004@amd>
References: <20181105073054.24407-1-lkundrak@v3.sk>
 <20181105073054.24407-6-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20181105073054.24407-6-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-11-05 08:30:48, Lubomir Rintel wrote:
> The commit 05fed81625bf ("[media] marvell-ccic: add MIPI support for
> marvell-ccic driver") that claimed to add CSI2 turned on C0_EOF_VSYNC for
> parallel bus without a very good explanation.
>=20
> That broke camera on OLPC XO-1.75 which precisely uses a sensor on a
> parallel bus. Revert that chunk.
>=20
> Tested on an OLPC XO-1.75.
>=20
> Fixes: 05fed81625bf755cc67c5864cdfd18b69ea828d1
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

You should really Cc original author and people that signed off on
that patch.
									Pavel
	=09

>  drivers/media/platform/marvell-ccic/mcam-core.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
> index d97f39bde9bd..d24e5b7a3bc5 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -792,12 +792,6 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
>  	 * Make sure it knows we want to use hsync/vsync.
>  	 */
>  	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC, C0_SIFM_MASK);
> -	/*
> -	 * This field controls the generation of EOF(DVP only)
> -	 */
> -	if (cam->bus_type !=3D V4L2_MBUS_CSI2_DPHY)
> -		mcam_reg_set_bit(cam, REG_CTRL0,
> -				C0_EOF_VSYNC | C0_VEDGE_CTRL);
>  }
> =20
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvgCGEACgkQMOfwapXb+vI9WgCgsEqx2RQdGs9oaavW+qRbZ4CA
V0oAniu36udRA2sfIBY2IWDen8lMUPfq
=Ntxd
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
