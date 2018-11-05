Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45913 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbeKESaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 13:30:22 -0500
Date: Mon, 5 Nov 2018 10:11:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>
Subject: Re: [PATCH 06/11] [media] marvell-ccic: drop ctlr_reset()
Message-ID: <20181105091135.GB3004@amd>
References: <20181105073054.24407-1-lkundrak@v3.sk>
 <20181105073054.24407-7-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20181105073054.24407-7-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-11-05 08:30:49, Lubomir Rintel wrote:
> This accesses the clock registers directly and thus is not too
> devicetree friendly. If it's actually needed it needs to be done
> differently.

Device-tree unfriendly is bad, but you still don't want to cause
regression to people needing this.

(Perhaps noone uses this, but...)

> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Git blame says: 7c269f454 . Perhaps its authors should be Cced here,
too?
								Pavel

> ---
>  .../media/platform/marvell-ccic/mcam-core.c   |  6 -----
>  .../media/platform/marvell-ccic/mcam-core.h   |  1 -
>  .../media/platform/marvell-ccic/mmp-driver.c  | 23 -------------------
>  3 files changed, 30 deletions(-)
>=20
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/me=
dia/platform/marvell-ccic/mcam-core.c
> index d24e5b7a3bc5..1b879035948c 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -1154,12 +1154,6 @@ static void mcam_vb_stop_streaming(struct vb2_queu=
e *vq)
>  	if (cam->state !=3D S_STREAMING)
>  		return;
>  	mcam_ctlr_stop_dma(cam);
> -	/*
> -	 * Reset the CCIC PHY after stopping streaming,
> -	 * otherwise, the CCIC may be unstable.
> -	 */
> -	if (cam->ctlr_reset)
> -		cam->ctlr_reset(cam);
>  	/*
>  	 * VB2 reclaims the buffers, so we need to forget
>  	 * about them.
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/me=
dia/platform/marvell-ccic/mcam-core.h
> index ad8955f9f0a1..f93f23faf364 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -137,7 +137,6 @@ struct mcam_camera {
>  	int (*plat_power_up) (struct mcam_camera *cam);
>  	void (*plat_power_down) (struct mcam_camera *cam);
>  	void (*calc_dphy) (struct mcam_camera *cam);
> -	void (*ctlr_reset) (struct mcam_camera *cam);
> =20
>  	/*
>  	 * Everything below here is private to the mcam core and
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
> index 70a2833db0d1..92a79ad8a12c 100644
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -183,28 +183,6 @@ static void mmpcam_power_down(struct mcam_camera *mc=
am)
>  	mcam_clk_disable(mcam);
>  }
> =20
> -static void mcam_ctlr_reset(struct mcam_camera *mcam)
> -{
> -	unsigned long val;
> -	struct mmp_camera *cam =3D mcam_to_cam(mcam);
> -
> -	if (mcam->ccic_id) {
> -		/*
> -		 * Using CCIC2
> -		 */
> -		val =3D ioread32(cam->power_regs + REG_CCIC2_CRCR);
> -		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC2_CRCR);
> -		iowrite32(val | 0x2, cam->power_regs + REG_CCIC2_CRCR);
> -	} else {
> -		/*
> -		 * Using CCIC1
> -		 */
> -		val =3D ioread32(cam->power_regs + REG_CCIC_CRCR);
> -		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC_CRCR);
> -		iowrite32(val | 0x2, cam->power_regs + REG_CCIC_CRCR);
> -	}
> -}
> -
>  /*
>   * calc the dphy register values
>   * There are three dphy registers being used.
> @@ -352,7 +330,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	mcam =3D &cam->mcam;
>  	mcam->plat_power_up =3D mmpcam_power_up;
>  	mcam->plat_power_down =3D mmpcam_power_down;
> -	mcam->ctlr_reset =3D mcam_ctlr_reset;
>  	mcam->calc_dphy =3D mmpcam_calc_dphy;
>  	mcam->dev =3D &pdev->dev;
>  	mcam->use_smbus =3D 0;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvgCUcACgkQMOfwapXb+vL/EQCfTvq7om7dzfYtQC4RLAqHwqtQ
8fsAn3V2YfVKotiBeGNyzlUwTMaD++aK
=fPCW
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
