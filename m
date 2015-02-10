Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:9878 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbbBJMEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 07:04:14 -0500
Date: Tue, 10 Feb 2015 12:04:10 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Sifan Naeem <sifan.naeem@imgtec.com>
CC: <mchehab@osg.samsung.com>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] rc: img-ir: fix error in parameters passed to irq_free()
Message-ID: <20150210120410.GM30459@jhogan-linux.le.imgtec.org>
References: <1423564916-29805-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RNRUMt0ZF5Yaq/Aq"
Content-Disposition: inline
In-Reply-To: <1423564916-29805-1-git-send-email-sifan.naeem@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--RNRUMt0ZF5Yaq/Aq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2015 at 10:41:56AM +0000, Sifan Naeem wrote:
> img_ir_remove() passes a pointer to the ISR function as the 2nd
> parameter to irq_free() instead of a pointer to the device data
> structure.
> This issue causes unloading img-ir module to fail with the below
> warning after building and loading img-ir as a module.
>=20
> WARNING: CPU: 2 PID: 155 at ../kernel/irq/manage.c:1278
> __free_irq+0xb4/0x214() Trying to free already-free IRQ 58
> Modules linked in: img_ir(-)
> CPU: 2 PID: 155 Comm: rmmod Not tainted 3.14.0 #55 ...
> Call Trace:
> ...
> [<8048d420>] __free_irq+0xb4/0x214
> [<8048d6b4>] free_irq+0xac/0xf4
> [<c009b130>] img_ir_remove+0x54/0xd4 [img_ir] [<8073ded0>]
> platform_drv_remove+0x30/0x54 ...
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> Fixes: 160a8f8aec4d ("[media] rc: img-ir: add base driver")
> Cc: <stable@vger.kernel.org> # 3.15+

Thanks for catching this Sifan. It appears to have been introduced while
getting the driver ready for upstream (it used to use the devm_* API to
request the IRQ, but I changed it to avoid the ISR racing with module
removal).

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  drivers/media/rc/img-ir/img-ir-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img=
-ir/img-ir-core.c
> index 77c78de..7020659 100644
> --- a/drivers/media/rc/img-ir/img-ir-core.c
> +++ b/drivers/media/rc/img-ir/img-ir-core.c
> @@ -146,7 +146,7 @@ static int img_ir_remove(struct platform_device *pdev)
>  {
>  	struct img_ir_priv *priv =3D platform_get_drvdata(pdev);
> =20
> -	free_irq(priv->irq, img_ir_isr);
> +	free_irq(priv->irq, priv);
>  	img_ir_remove_hw(priv);
>  	img_ir_remove_raw(priv);
> =20
> --=20
> 1.7.9.5
>=20

--RNRUMt0ZF5Yaq/Aq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU2fO6AAoJEGwLaZPeOHZ6hTsP/AkHlJ4MJgtkrIBNWKZTa18F
7jW51xuqEsOgb5mzWCO+M5710sdPOlDehJ9RX+HrremsVX5Mon0Ta3UKpdnq1Zva
QP3CNn57R3V/4OJpDYMCl320dn0jnQ2tRGLuQmwdT0upFV2ziKmJ2PKsvW0aflyQ
uRnOaXDWWVS756+dfjHj59N8WxrMTk5BvESVO9/QAGp3CkhbmoUTqMX2DmrU/YyT
yXBpGGJ+VVj8fxXzLP8pT64fq7rbd6hnU5M5xHUwmmIWrLOLnI0Vt5RtYR4UyLLb
nInboOdFglkdTQOfadBTFchLFJZ0LN9aSmc1ZLQWhRBEq2Fiu+r0+icX6hALT11y
p8ghYM3aqMvkHN8DuUH9V389kFIyiW1Afa2uzcUsOgr8mAbVDI7MokFhQwb5U6yv
6NOHBWWnVqAvYm6AXYLY3v9D4yUtSzyjfW468urE0IgudjeGj9sBsKlR2mkxwKH9
z2NGnRNR/Fo7JeYF/Llf/LfzME4QqVyBJAiBAdPVpp/BMw8jgJiFOw9W7BUnLBh9
9/aLn+DPvD23baNEzPVpl+oWqrW8qQDc6nibAD+S1zLzMwaXIqiHeParSd8jkadc
KvWh4INtrYY3k2YYztNCdU7dCyW5DfhFfNPk5x6bTSZ4N56AQkmwvrMXrOlckNPa
jO+hdq34fGf+ghbzhHX2
=iAz+
-----END PGP SIGNATURE-----

--RNRUMt0ZF5Yaq/Aq--
