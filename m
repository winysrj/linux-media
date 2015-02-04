Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:40627 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966930AbbBDRaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 12:30:21 -0500
Message-ID: <54D2572B.5050607@imgtec.com>
Date: Wed, 4 Feb 2015 17:30:19 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] rc: img-ir: Add and enable sys clock for img-ir
References: <1423068494-9360-1-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1423068494-9360-1-git-send-email-sifan.naeem@imgtec.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="69E7RjnldRsvSBedGGcKVQenI0Ds58aas"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--69E7RjnldRsvSBedGGcKVQenI0Ds58aas
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/02/15 16:48, Sifan Naeem wrote:
> Gets a handle to the system clock, already described in the binding
> document, and calls the appropriate common clock framework functions
> to mark it prepared/enabled, the common clock framework initially
> enables the clock and doesn't disable it at least until the
> device/driver is removed.
> It's important the systen clock is enabled before register interface is=

> accessed by the driver.
> The system clock to IR is needed for the driver to communicate with the=

> IR hardware via MMIO accesses on the system bus, so it must not be
> disabled during use or the driver will malfunction.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>

Thanks Sifan, looks good to me, doesn't break tz1090, and seems to still
cope with no clocks provided in DT.

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
> Changes from v1:
> System clock enabled in probe function before any hardware is accessed.=

> Error handling in probe function ensures ISR doesn't get called with=20
> system clock disabled.
>=20
>  drivers/media/rc/img-ir/img-ir-core.c |   29 +++++++++++++++++++++++++=
----
>  drivers/media/rc/img-ir/img-ir.h      |    2 ++
>  2 files changed, 27 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/i=
mg-ir/img-ir-core.c
> index 77c78de..a10d666 100644
> --- a/drivers/media/rc/img-ir/img-ir-core.c
> +++ b/drivers/media/rc/img-ir/img-ir-core.c
> @@ -110,16 +110,32 @@ static int img_ir_probe(struct platform_device *p=
dev)
>  	priv->clk =3D devm_clk_get(&pdev->dev, "core");
>  	if (IS_ERR(priv->clk))
>  		dev_warn(&pdev->dev, "cannot get core clock resource\n");
> +
> +	/* Get sys clock */
> +	priv->sys_clk =3D devm_clk_get(&pdev->dev, "sys");
> +	if (IS_ERR(priv->sys_clk))
> +		dev_warn(&pdev->dev, "cannot get sys clock resource\n");
>  	/*
> -	 * The driver doesn't need to know about the system ("sys") or power
> -	 * modulation ("mod") clocks yet
> +	 * Enabling the system clock before the register interface is
> +	 * accessed. ISR shouldn't get called with Sys Clock disabled,
> +	 * hence exiting probe with an error.
>  	 */
> +	if (!IS_ERR(priv->sys_clk)) {
> +		error =3D clk_prepare_enable(priv->sys_clk);
> +		if (error) {
> +			dev_err(&pdev->dev, "cannot enable sys clock\n");
> +			return error;
> +		}
> +	}
> =20
>  	/* Set up raw & hw decoder */
>  	error =3D img_ir_probe_raw(priv);
>  	error2 =3D img_ir_probe_hw(priv);
> -	if (error && error2)
> -		return (error =3D=3D -ENODEV) ? error2 : error;
> +	if (error && error2) {
> +		if (error =3D=3D -ENODEV)
> +			error =3D error2;
> +		goto err_probe;
> +	}
> =20
>  	/* Get the IRQ */
>  	priv->irq =3D irq;
> @@ -139,6 +155,9 @@ static int img_ir_probe(struct platform_device *pde=
v)
>  err_irq:
>  	img_ir_remove_hw(priv);
>  	img_ir_remove_raw(priv);
> +err_probe:
> +	if (!IS_ERR(priv->sys_clk))
> +		clk_disable_unprepare(priv->sys_clk);
>  	return error;
>  }
> =20
> @@ -152,6 +171,8 @@ static int img_ir_remove(struct platform_device *pd=
ev)
> =20
>  	if (!IS_ERR(priv->clk))
>  		clk_disable_unprepare(priv->clk);
> +	if (!IS_ERR(priv->sys_clk))
> +		clk_disable_unprepare(priv->sys_clk);
>  	return 0;
>  }
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir.h b/drivers/media/rc/img-ir=
/img-ir.h
> index 2ddf560..f1387c0 100644
> --- a/drivers/media/rc/img-ir/img-ir.h
> +++ b/drivers/media/rc/img-ir/img-ir.h
> @@ -138,6 +138,7 @@ struct clk;
>   * @dev:		Platform device.
>   * @irq:		IRQ number.
>   * @clk:		Input clock.
> + * @sys_clk:		System clock.
>   * @reg_base:		Iomem base address of IR register block.
>   * @lock:		Protects IR registers and variables in this struct.
>   * @raw:		Driver data for raw decoder.
> @@ -147,6 +148,7 @@ struct img_ir_priv {
>  	struct device		*dev;
>  	int			irq;
>  	struct clk		*clk;
> +	struct clk		*sys_clk;
>  	void __iomem		*reg_base;
>  	spinlock_t		lock;
> =20
>=20


--69E7RjnldRsvSBedGGcKVQenI0Ds58aas
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU0lcrAAoJEGwLaZPeOHZ6jzgP/27caJf/fca18kTXwTL87P/H
Zi7QDi0HeFSmk59bLCA/SAId9V29EffhOdCNsbqFlw1+qNiPiuYXxXcKGNa9okL1
pho+YcthSTm7ELVUOgO3RMVbawFNXMl9wKDgpUfCYD/jip1lmah5QgSeTxzaYQZm
bANB9wLX5Bha8oUW4dFkbzdYBAjgbBxl3rK2b5aDIMSO1+L3Qh7fcEL49GHUAWJS
EZOISURAbc6uqiN3juweDhzXO8wNGPHg9c2ddO+0bhUEsIVjDt71+qiT2XyL3qeB
1wCdlHpf/8UliiMYneIPd9M8PLqJ6ZOnmJf8O4ifEGejKfftC9SGkL3QoymcVS4B
yX0kbWbD5IuOH28Q87oZz6KEhACSFuJ8yLYHdPLLLcLbDXonjhqVQBMrSWHuqpYN
VNneg5WZjAbxLxdZMZh0yfzZF+AIghxgct7pJNCqDCiPIZVWFNerw/6J5ZMIqo2m
OxfW4h5BVB0GlJzyc9+3n5TAQtn6pn1T01BJogc2jKwLFo3HcVZT3bTK3NXtLOrg
ULTBNTkbXHuu14DUtkxj1bDSceqrykmAysoJIhcDBUteWuXw26ULP9rDwlDmR5sr
5DHIGLzXSdNtHnHttHJ9k6NVHQEZfYY/90zg+ovCyzQrsGzwwxBWIiP/4yQMvEIu
PQ4f36tle7RqHJI3Z/PY
=aNGF
-----END PGP SIGNATURE-----

--69E7RjnldRsvSBedGGcKVQenI0Ds58aas--
