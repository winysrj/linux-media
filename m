Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55591 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3CDJNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:13:35 -0500
Date: Mon, 4 Mar 2013 10:13:16 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 2/4] [media] soc_camera/pxa_camera: Convert to
 devm_ioremap_resource()
Message-ID: <20130304091313.GB13335@avionic-0098.mockup.avionic-design.de>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
 <1362384921-7344-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1362384921-7344-2-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 01:45:19PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/med=
ia/platform/soc_camera/pxa_camera.c
> index 395e2e0..42abbce 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -15,6 +15,7 @@
>  #include <linux/io.h>
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
>  #include <linux/interrupt.h>
> @@ -1710,9 +1711,10 @@ static int pxa_camera_probe(struct platform_device=
 *pdev)
>  	/*
>  	 * Request the regions.
>  	 */
> -	base =3D devm_request_and_ioremap(&pdev->dev, res);
> -	if (!base)
> -		return -ENOMEM;
> +	base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
>  	pcdev->irq =3D irq;
>  	pcdev->base =3D base;
> =20

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNGWpAAoJEN0jrNd/PrOhGK4QAJWw4xJhuaPIDgBeke5LdSFs
d82A5sAudMpoqJ9c3sg3Jo4HsZodwW5yJGx7VDr1pwHTqoqjGgMp3CXUEa0VR39t
zpcCJO2eJn3IK3uDPbF5jVszSHDUT1HLDokHx005mqzRrNaSo7xAflns4QXfl7uk
tI4wYFLY0pdMFdnoSJVWLITPTUDDtB0sYjtS3vIZmeh9EMW6leU9R7t8RCoGCWXs
2nh/yLgoHVH8fW9Qhe1aPnqqEUyPHnpbiTgKtUzXe23/tHKuxrU6hmkhFtwFFd65
T4psbbzQtJ5RiDVxFSU/P1eHp7WywBSPe0tD+EP+4ml69+tPMr11REnfrqSVkh1u
8WcAefFFqnyHqApSuiE28cTL0APfGJk1dhm97Fro1lGl7aU2y4/IFi2+4mYp761j
2m8ljx8nmHgmrrUdl5qwIWxCejeCFJPp/2wgo0iFivg46HsbkDZlb7gVHxbXkQGU
SvyxwmgZjowPCesvL3bwRX+eMBkxKB377NQllS7g7qHh9qFhWtT2gfUcPPVEPidi
mUVmME+vth9sfeGestscc5+z8GitvCQhRXCvyRoCtyT4xl2ruOL/464mugookbXk
5Ceia4hlxEH4cb6AK6dx2gxUBt3hc4m+sA2yGVZQ+PrVnINPt0/xznxbGoQCl2BD
cqU/xjvD8JG+r5Tbgos9
=ACK/
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
