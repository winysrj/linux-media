Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3CDJNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:13:04 -0500
Date: Mon, 4 Mar 2013 10:12:51 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 1/4] [media] sh_veu.c: Convert to devm_ioremap_resource()
Message-ID: <20130304091243.GA13335@avionic-0098.mockup.avionic-design.de>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 01:45:18PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/platform/sh_veu.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_=
veu.c
> index cb54c69..362d88e 100644
> --- a/drivers/media/platform/sh_veu.c
> +++ b/drivers/media/platform/sh_veu.c
> @@ -10,6 +10,7 @@
>   * published by the Free Software Foundation
>   */
> =20
> +#include <linux/err.h>
>  #include <linux/fs.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -1164,9 +1165,9 @@ static int sh_veu_probe(struct platform_device *pde=
v)
> =20
>  	veu->is_2h =3D resource_size(reg_res) =3D=3D 0x22c;
> =20
> -	veu->base =3D devm_request_and_ioremap(&pdev->dev, reg_res);
> -	if (!veu->base)
> -		return -ENOMEM;
> +	veu->base =3D devm_ioremap_resource(&pdev->dev, reg_res);
> +	if (IS_ERR(veu->base))
> +		return PTR_ERR(veu->base);
> =20
>  	ret =3D devm_request_threaded_irq(&pdev->dev, irq, sh_veu_isr, sh_veu_b=
h,
>  					0, "veu", veu);

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNGWLAAoJEN0jrNd/PrOh+MYQAKyFlvEeCkKwJG5o0z/UdMCJ
98GIk+sh9SIvoMwrpJ1MTKEp0qs0oCTaS5KFGCWeFtiFkD6xGyGzKZ9zp/JyDZM0
uRyg9dqVIwDFb3Lx0qyiqOXMIsY9i+bDPEgkXVvLtSFY6IZoC5EF2mrppOp5hS5M
k8ocRU+wsooy3NJ9uozzS52a/cxgWmh1Qe9TbVtd/N3y1uokbC6Kwy6bJWiuYn7/
HZsL3FrBgq6RRFCXfsHCjCxg0OC3/vZHTEPTm5Alm6nn9Y+DVgEziekjD7XQB0pD
7xjPVmDqs9939YO+TCif+aY+R9IjoCgitMC9LXNkzht7TXxL1wchj81cwmhKP4vl
4+XVF/cQAQ5p9hwFuaUCQ19kzKWltk60ylPdboEmOeR9C41tYdEh7lRnPTEWSKKg
YZ4Lz6afOk3Av/GnD4m1L74N5Y8rhhNpecBN6B1ullhgPKvqUTfymDT/7qr07gGu
vWdPMKwWOmTbuuFA4nLJ36ELbp+dqh38gGfahdb12EYvLHUqLs+orv94tFYUgcad
jKVLT+1m+YliZAkgFk319eH/Rv993idVBPDqPJTleLosO2mqdPH8exE2UmHs/iqH
NUoxgwJxpT4Tj/fXHkW8QvTTi9bWpu8N6CSqR4g6P8dgc6i32qMN34pSu4mRMyjk
QSeuJmEXyquxNopd9oG9
=YA4i
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
