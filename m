Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3CDJN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:13:56 -0500
Date: Mon, 4 Mar 2013 10:13:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 4/4] [media] soc_camera/sh_mobile_csi2: Convert to
 devm_ioremap_resource()
Message-ID: <20130304091346.GD13335@avionic-0098.mockup.avionic-design.de>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
 <1362384921-7344-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <1362384921-7344-4-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 01:45:21PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers=
/media/platform/soc_camera/sh_mobile_csi2.c
> index 42c559e..09cb4fc 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> @@ -9,6 +9,7 @@
>   */
> =20
>  #include <linux/delay.h>
> +#include <linux/err.h>
>  #include <linux/i2c.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> @@ -324,11 +325,9 @@ static int sh_csi2_probe(struct platform_device *pde=
v)
> =20
>  	priv->irq =3D irq;
> =20
> -	priv->base =3D devm_request_and_ioremap(&pdev->dev, res);
> -	if (!priv->base) {
> -		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
> -		return -ENXIO;
> -	}
> +	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> =20
>  	priv->pdev =3D pdev;
>  	platform_set_drvdata(pdev, priv);

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNGXJAAoJEN0jrNd/PrOhjOkQAKCZ3dcmZqAr1bPCM7HRaaSp
i38rJrGWqQ4t6I5rW8ugcdpHhvV4odMwXAMO9i+hvvhZeiIbjaT1B+WjI3K+0/Np
jbsmDTqzRdoQn35ph1rM0VAlva0KRIvuc0q00QCa1S4cwaUFc1GDIp1eiU3yy9w9
a8tEilJM3Rc98zTIF3fbQi1bHLgKWIAln0cGiuZf05GCcdXjKYX39PeJFnZqMwbc
DGz5tNXgo5taFySs/lIgVYNQ0WtfBfzRAGAwQA4OJYokcYaY+sl9OeyD8HtcwdJi
480r8OCR8uRk2nBObr+MXRuDZUH8pe5shs952TDXZzjfmCgMWb9lloztN+uKO8av
FNPiKCaipt894sWs8WRqpGmEbvRwdaoTUWkeR18f4NWgUhQvHy1kiJjTIJeU+ffJ
ZJB5pDOXqyr/sNkTxfCTAzTJRqf0t7LXMQ1fn3rVbRQdQRXTttxanmFNm7GBkdTj
MI73L+T46DQKue3TA2DHqZfXW7I+Yihqdfy2Uf8bj4BfZty78PnMP2YPw1NyDW8X
xEaBQdNTONITD/3L0bQEff4LPPKUwYA8hHwr+cK+7EKl79sMQE92Z3FLw+SCp9jx
k0vpMxgAYfYkmscLD3Q5ozlLoDAvq1zmXdZnQ1zOz0J8qLhAjSzAqyEsSNTesQCN
OaiwVHB6L+yXw9aCbJ+F
=9h6A
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
