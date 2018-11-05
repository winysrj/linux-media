Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46035 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbeKESgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 13:36:17 -0500
Date: Mon, 5 Nov 2018 10:17:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>
Subject: Re: [PATCH 08/11] [media] marvell-ccic/mmp: enable clock before
 accessing registers
Message-ID: <20181105091730.GB4439@amd>
References: <20181105073054.24407-1-lkundrak@v3.sk>
 <20181105073054.24407-9-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <20181105073054.24407-9-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-11-05 08:30:51, Lubomir Rintel wrote:
> The access to REG_CLKCTRL or REG_CTRL1 without the clock enabled hangs
> the machine. Enable the clock first.
>=20
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Acked-by: Pavel Machek <pavel@ucw.cz>

> ---
>  drivers/media/platform/marvell-ccic/mmp-driver.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/m=
edia/platform/marvell-ccic/mmp-driver.c
> index 9e988e527b0d..9c0238f72c40 100644
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -145,6 +145,7 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
>   * Turn on power and clocks to the controller.
>   */
>  	mmpcam_power_up_ctlr(cam);
> +	mcam_clk_enable(mcam);
>  /*
>   * Provide power to the sensor.
>   */
> @@ -158,8 +159,6 @@ static int mmpcam_power_up(struct mcam_camera *mcam)
>  	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
>  	mdelay(5);
> =20
> -	mcam_clk_enable(mcam);
> -
>  	return 0;
>  }
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvgCqoACgkQMOfwapXb+vKVKgCeNOiPzU9OYhyuKCSuVwM+6deQ
b2QAn0dDiYxxa40Iv9wPHEj+r2xHx2Qz
=opxu
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
