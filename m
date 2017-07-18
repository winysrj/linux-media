Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36194 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdGRIxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 04:53:04 -0400
Date: Tue, 18 Jul 2017 10:52:59 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: pavel@ucw.cz, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170718085259.3ojpy5gkrmasfzq3@earth>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zzdqcawg4bis2qtj"
Content-Disposition: inline
In-Reply-To: <20170717220116.17886-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zzdqcawg4bis2qtj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 18, 2017 at 01:01:13AM +0300, Sakari Ailus wrote:
> From: Pavel Machek <pavel@ucw.cz>
>=20
> If regulator returns -EPROBE_DEFER, we need to return it too, so that
> omap3isp will be re-probed when regulator is ready.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c     | 3 ++-
>  drivers/media/platform/omap3isp/ispccp2.c | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 80ed5a5f862a..4e6ba7f90e35 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1880,7 +1880,8 @@ static int isp_initialize_modules(struct isp_device=
 *isp)
> =20
>  	ret =3D omap3isp_ccp2_init(isp);
>  	if (ret < 0) {
> -		dev_err(isp->dev, "CCP2 initialization failed\n");
> +		if (ret !=3D -EPROBE_DEFER)
> +			dev_err(isp->dev, "CCP2 initialization failed\n");
>  		goto error_ccp2;
>  	}
> =20
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/pl=
atform/omap3isp/ispccp2.c
> index 4f8fd0c00748..47210b102bcb 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -1140,6 +1140,11 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>  	if (isp->revision =3D=3D ISP_REVISION_2_0) {
>  		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
>  		if (IS_ERR(ccp2->vdds_csib)) {
> +			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER) {
> +				dev_dbg(isp->dev,
> +					"Can't get regulator vdds_csib, deferring probing\n");
> +				return -EPROBE_DEFER;
> +			}

I wonder if the right approach wouldn't be to always bail out for
errors. devm_regulator_get should provide a dummy regulator if
none is specified. If we get an error here it means something is
configured incorrectly or we have serious problems.

>  			dev_dbg(isp->dev,
>  				"Could not get regulator vdds_csib\n");
>  			ccp2->vdds_csib =3D NULL;

-- Sebastian

--zzdqcawg4bis2qtj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlltzGgACgkQ2O7X88g7
+pr80Q//Qqnww40i+2F39sBMEqVedw2pvSkUhRe0FWGs52rFEmYmLzgOXhe6F1Mz
oGMen8u8XJTCnNFTIA7i/V8m4tsbnoqYw6+C38sUMTdTwSawcYf1Bc/FWYkW6pqr
z6FlHkpIPSi+c1Fkop9zXhVhPGt08tuHNK8+hp+imU3F/gT/ka53rYIS4GEzNSth
FgQQHs0AmoKRVO1ocNp0N+Kq1hP0jKWNQhnWV1IYHqgVor3BIhht9D7yrP4Huj87
rLe16Ly9YnyiWiwu8q6h8Wy3oOZsJXr9WMmvY4VAr/4Q9e/AgIGJi2ZDRuzONONi
uZV0ewHWKdJse3jrHHSq3oQ2SeigNe6bKTXz4gi/XfvHItYdBwcMlUfYIgwXkBVS
ONu8EklSqwNp778r6bdwYOv3m9IXmevJk9p5h8cIy2d2Wrn/wPAdBJeKy2SLaPRv
j0P5JZAEKw1wD9n7sD76xaxerQrwrnBTArK25ZXMAY9VA9JqJ0f+E3RiyYKenMxL
opQ97RG89lCF/885CrT2zVAUabBAUzK+X8uvHqm7sfxtchhnpPbxXjNy6KIdqy+n
1eAM9L7gavowoavs34mfNsmJ3vVxFLpYCSpn5vbuYyyJBT78LFwdme2zh3LWghPM
UivYsluBSxiXxDiM4fD0Azf07XIorBiYVghOChV40KUbwK6JyiA=
=uyHw
-----END PGP SIGNATURE-----

--zzdqcawg4bis2qtj--
