Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:52038 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3BEKKS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 05:10:18 -0500
Message-ID: <1360057113.5004.29.camel@mattotaupa>
Subject: Re: [PATCH v4 1/1] video: drm: exynos: Adds display-timing node
 parsing using video helper function
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, l.krishna@samsung.com,
	kgene.kim@samsung.com, linux-media@vger.kernel.org
Date: Tue, 05 Feb 2013 10:38:33 +0100
In-Reply-To: <1360042367-16397-2-git-send-email-vikas.sajjan@linaro.org>
References: <1360042367-16397-1-git-send-email-vikas.sajjan@linaro.org>
	 <1360042367-16397-2-git-send-email-vikas.sajjan@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8g6tEjELB1oZ4vrDJzKB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8g6tEjELB1oZ4vrDJzKB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Vikas,


thank you for the patch. Please send a fifth iteration with the
following changes to the commit message.

Am Dienstag, den 05.02.2013, 11:02 +0530 schrieb Vikas Sajjan:

The summary should not implicitly assume =C2=BBpatch=C2=AB written before i=
t. So
do not add third person s to =C2=BBAdd=C2=AB.

        video: drm: exynos: Add display-timing node parsing using video hel=
per function

> This patch adds display-timing node parsing using video helper function

As this is the same as the summary you should leave it out. Also it is
good style not to use =C2=BBThis/The patch=C2=AB in the commit message.

Please use the commit message to explain your change. For example the if
statement. Why is the original code put into the else branch and is not
needed if the first condition is true?

> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   41 ++++++++++++++++++++++++=
+++---
>  1 file changed, 37 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/e=
xynos/exynos_drm_fimd.c
> index bf0d9ba..978e866 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -19,6 +19,7 @@
>  #include <linux/clk.h>
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
> =20
>  #include <video/samsung_fimd.h>
>  #include <drm/exynos_drm.h>
> @@ -905,16 +906,48 @@ static int __devinit fimd_probe(struct platform_dev=
ice *pdev)
>  	struct exynos_drm_subdrv *subdrv;
>  	struct exynos_drm_fimd_pdata *pdata;
>  	struct exynos_drm_panel_info *panel;
> +	struct fb_videomode *fbmode;
> +	struct pinctrl *pctrl;
>  	struct resource *res;
>  	int win;
>  	int ret =3D -EINVAL;
> =20
>  	DRM_DEBUG_KMS("%s\n", __FILE__);
> =20
> -	pdata =3D pdev->dev.platform_data;
> -	if (!pdata) {
> -		dev_err(dev, "no platform data specified\n");
> -		return -EINVAL;
> +	if (pdev->dev.of_node) {
> +		pdata =3D devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			DRM_ERROR("memory allocation for pdata failed\n");
> +			return -ENOMEM;
> +		}
> +
> +		fbmode =3D devm_kzalloc(dev, sizeof(*fbmode), GFP_KERNEL);
> +		if (!fbmode) {
> +			DRM_ERROR("memory allocation for fbmode failed\n");
> +			return -ENOMEM;
> +		}
> +
> +		ret =3D of_get_fb_videomode(dev->of_node, fbmode, -1);
> +		if (ret) {
> +			DRM_ERROR("failed: of_get_fb_videomode() :"
> +				"return value: %d\n", ret);
> +			return ret;
> +		}
> +		pdata->panel.timing =3D (struct fb_videomode) *fbmode;
> +
> +		pctrl =3D devm_pinctrl_get_select_default(dev);
> +		if (IS_ERR_OR_NULL(pctrl)) {
> +			DRM_ERROR("failed: devm_pinctrl_get_select_default()"
> +				"return value: %d\n", PTR_RET(pctrl));
> +			return PTR_RET(pctrl);
> +		}
> +
> +	} else {
> +		pdata =3D pdev->dev.platform_data;
> +		if (!pdata) {
> +			DRM_ERROR("no platform data specified\n");
> +			return -EINVAL;
> +		}
>  	}
> =20
>  	panel =3D &pdata->panel;


Thanks,

Paul

--=-8g6tEjELB1oZ4vrDJzKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlEQ0xkACgkQPX1aK2wOHVh+hwCgiFBvZnbfyOHF18dAIP8QqH3G
veMAoIJcUPX7VpUd8IljC8Mfeim5ypCz
=BQ9F
-----END PGP SIGNATURE-----

--=-8g6tEjELB1oZ4vrDJzKB--

