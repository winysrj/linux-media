Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3CDJNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:13:41 -0500
Date: Mon, 4 Mar 2013 10:13:33 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 3/4] [media] soc_camera/sh_mobile_ceu_camera: Convert to
 devm_ioremap_resource()
Message-ID: <20130304091331.GC13335@avionic-0098.mockup.avionic-design.de>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
 <1362384921-7344-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <1362384921-7344-3-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 01:45:20PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/d=
rivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> index bb08a46..be1af08 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> @@ -20,6 +20,7 @@
>  #include <linux/completion.h>
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
>  #include <linux/interrupt.h>
> @@ -2110,11 +2111,9 @@ static int sh_mobile_ceu_probe(struct platform_dev=
ice *pdev)
>  	pcdev->max_width =3D pcdev->pdata->max_width ? : 2560;
>  	pcdev->max_height =3D pcdev->pdata->max_height ? : 1920;
> =20
> -	base =3D devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base) {
> -		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
> -		return -ENXIO;
> -	}
> +	base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> =20
>  	pcdev->irq =3D irq;
>  	pcdev->base =3D base;

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNGW7AAoJEN0jrNd/PrOheecQAMAvf1DCfTccFXn8ht3x+deI
YAqDBgp+butJUj5xbeKqlRbkqJdc0JhaXh83++DZDWDDiAmhmG78pqZ93/kZllUz
mhVq9p7DrQqwRW9cNQJkos/2du0mVUpwa3DyKveQ8Sgeb/9/O5BvBcg9j6UWQfDr
GOzydYL9Eis4IJkU8O67Epb6gS/qK9ZjF82aKDxSehvLSAu21J65XnfEjgp7xC/9
3x0eONckZ2ZdHtt4l43rmEZU3M8mpSm8P21+QK2KLz2dvJz7d5DQlbFghseh5T58
+WIiGYp8LIwAsvzV7MERfiy0V27uPA/nYzpp99o/SiTmh+B7QSvQmawi2Ay/VNCG
RrFHVe5s+U2QG5qv8mATs+N1KlWQJ31T6nWXIoNY1ysMSklLEurFhA3S54QJmyaR
LtnBTYXpX/leOvyZK7CWIhuxKbYMcVbvdv6hDV8EVjZVWKNZBjIguMNTUA7d+4YR
tIsbshtq5r/7w/qFF5NBWsbRWu9SyjkSqlZtPAHCG9IMUTqGdiESp/QTY74UFUCd
EvoQAclwV8MXo8PaMSFdu61c3NIqkPZGnKrGQtXJKueEzyV7uLtIS+wBozZsEYNM
gvFmbD+yfPuAFxDOcliGsSEa3lnKDyfCnddehssjQGgaNVRXaAthmVT8tK2NlZli
SvabmBy3/3mdlSLQOSgy
=k1bq
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
