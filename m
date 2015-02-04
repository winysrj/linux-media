Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:23657 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332AbbBDKPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 05:15:55 -0500
Message-ID: <54D1F150.9040202@imgtec.com>
Date: Wed, 4 Feb 2015 10:15:44 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rc: img-ir: Add and enable sys clock for IR
References: <1422984629-13313-1-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1422984629-13313-1-git-send-email-sifan.naeem@imgtec.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="PhD8x6nsIqVPLr2jMhjk0tGDQTBkmHWW3"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--PhD8x6nsIqVPLr2jMhjk0tGDQTBkmHWW3
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Sifan,

On 03/02/15 17:30, Sifan Naeem wrote:
> Gets a handle to the system clock, already described in the binding
> document, and calls the appropriate common clock
> framework functions to mark it prepared/enabled, the common clock
> framework initially enables the clock and doesn't disable it at least
> until the device/driver is removed.
> The system clock to IR is needed for the driver to communicate with the=

> IR hardware via MMIO accesses on the system bus, so it must not be
> disabled during use or the driver will malfunction.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/img-ir-core.c |   13 +++++++++----
>  drivers/media/rc/img-ir/img-ir.h      |    2 ++
>  2 files changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/i=
mg-ir/img-ir-core.c
> index 77c78de..783dd21 100644
> --- a/drivers/media/rc/img-ir/img-ir-core.c
> +++ b/drivers/media/rc/img-ir/img-ir-core.c
> @@ -60,6 +60,8 @@ static void img_ir_setup(struct img_ir_priv *priv)
> =20
>  	if (!IS_ERR(priv->clk))
>  		clk_prepare_enable(priv->clk);
> +	if (!IS_ERR(priv->sys_clk))
> +		clk_prepare_enable(priv->sys_clk);

The patch mostly looks good, however I just realised this only enables
the system clock after it has already used the register interface. To be
safe it should really be enabled before any hardware accesses, so before
img_ir_ident() is called (and certainly before the img_ir_setup_raw()
and img_ir_setup_hw() functions are called since they set up the default
timings / irq mask etc).

Currently img_ir_probe_raw() and img_ir_probe_hw() don't appear to
access the hardware, but I can imagine they may want to access hardware
in future to read the revision register, so I think its worth doing it
from img_ir_probe() before they get called too, which should also ensure
the ISR doesn't get called with sysclock disabled (obviously error
handling in probe function would need to take it into account).

I suspect you would see this causing a problem when the driver is built
as a module and loaded after unused clocks have been automatically
disabled by the common clock framework at the end of the init sequence.

Thanks
James

>  }
> =20
>  static void img_ir_ident(struct img_ir_priv *priv)
> @@ -110,10 +112,11 @@ static int img_ir_probe(struct platform_device *p=
dev)
>  	priv->clk =3D devm_clk_get(&pdev->dev, "core");
>  	if (IS_ERR(priv->clk))
>  		dev_warn(&pdev->dev, "cannot get core clock resource\n");
> -	/*
> -	 * The driver doesn't need to know about the system ("sys") or power
> -	 * modulation ("mod") clocks yet
> -	 */
> +
> +	/* Get sys clock */
> +	priv->sys_clk =3D devm_clk_get(&pdev->dev, "sys");
> +	if (IS_ERR(priv->sys_clk))
> +		dev_warn(&pdev->dev, "cannot get sys clock resource\n");
> =20
>  	/* Set up raw & hw decoder */
>  	error =3D img_ir_probe_raw(priv);
> @@ -152,6 +155,8 @@ static int img_ir_remove(struct platform_device *pd=
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


--PhD8x6nsIqVPLr2jMhjk0tGDQTBkmHWW3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU0fFXAAoJEGwLaZPeOHZ6OzsP/j2kconKU/eblyyzviQt09Ef
bzeSJYnJcCMu32ql8NmMYZwN1488SwvddGLC65w11IlyH51dAgPAbvWOIt85Htln
sEzBCY5vOXVRmqkk4F51dRoygJ/Arki95OG5m+l1ITJxtDcg9LTQMzENJmaQF00V
VneR8+9i+ySu5805+mDka0h8w2Ach7MtNR3+KLs2rZYE9JvDJux26QFOb/hjC+Tj
K2YTo1ihIRH4Ryn34xwCx+Jj/WN3qwsiOG1khjCCTKhd6tC4xO1pWESYmgRzWa/F
QpzfNMkVnJUTcYy6BbEUxtvlSRmDJstxWBvl9crBcQwPjOunrsnmdKy703d4sl4w
OhsfArpVq9Qtb53aabd7AQ6C/SvNg4KbSilz7b8yaET7+Tin6G28kTcz3mRGbReS
c58PcmoPsiKy7DIZ7WsSlSKALuvkKAEu5D360PXdJF2ES8zyu8zGsOHGH62Pmx1h
6WgqgWBhKTMf6AkB3Dhyg9wkHnaxdD3ebzMXAzhSmOD5PMXAQi+NfUKgYfVHwmUP
Dr2W2FYUDa5sUa0ro8bA1wwjFVA/gR0/NBAXFmB7MkEv6oKYzmL0VvrhxaY5GePV
xi3Xvma2FLsI1MkOdxNQUtA+MnifP+NejwdVfaL01OXyNrZ/njtxQlo6f2LlTdgO
nI0qfGjn0qdAUy3JpgAV
=Cz5a
-----END PGP SIGNATURE-----

--PhD8x6nsIqVPLr2jMhjk0tGDQTBkmHWW3--
