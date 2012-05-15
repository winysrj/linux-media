Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39077 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964781Ab2EOBgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 21:36:52 -0400
Message-ID: <1337045809.9080.76.camel@deadeye>
Subject: Re: [PATCH] [media] rc: Fix invalid free_region and/or free_irq on
 probe failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Date: Tue, 15 May 2012 02:36:49 +0100
In-Reply-To: <1337045760.9080.75.camel@deadeye>
References: <1337045760.9080.75.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gYV3ApEPg7Hv9r8C6d6B"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-gYV3ApEPg7Hv9r8C6d6B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 02:36 +0100, Ben Hutchings wrote:
> fintek-cir, ite-cir and nuvoton-cir may try to free an I/O region
> and/or IRQ handler that was never allocated after a failure in their
> respective probe functions.  Add and use separate labels on the
> failure path so they will do the right cleanup after each possible
> point of failure.
>=20
> Compile-tested only.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

And this should probably go to stable as well, if you agree it's a valid
fix.

Ben.

> ---
>  drivers/media/rc/fintek-cir.c  |   13 ++++++-------
>  drivers/media/rc/ite-cir.c     |   14 ++++++--------
>  drivers/media/rc/nuvoton-cir.c |   26 ++++++++++++--------------
>  3 files changed, 24 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.=
c
> index 4a3a238..6aabf7a 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -556,11 +556,11 @@ static int fintek_probe(struct pnp_dev *pdev, const=
 struct pnp_device_id *dev_id
> =20
>  	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
>  			FINTEK_DRIVER_NAME, (void *)fintek))
> -		goto failure;
> +		goto failure2;
> =20
>  	ret =3D rc_register_device(rdev);
>  	if (ret)
> -		goto failure;
> +		goto failure3;
> =20
>  	device_init_wakeup(&pdev->dev, true);
>  	fintek->rdev =3D rdev;
> @@ -570,12 +570,11 @@ static int fintek_probe(struct pnp_dev *pdev, const=
 struct pnp_device_id *dev_id
> =20
>  	return 0;
> =20
> +failure3:
> +	free_irq(fintek->cir_irq, fintek);
> +failure2:
> +	release_region(fintek->cir_addr, fintek->cir_port_len);
>  failure:
> -	if (fintek->cir_irq)
> -		free_irq(fintek->cir_irq, fintek);
> -	if (fintek->cir_addr)
> -		release_region(fintek->cir_addr, fintek->cir_port_len);
> -
>  	rc_free_device(rdev);
>  	kfree(fintek);
> =20
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 0e49c99..36fe5a3 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -1598,24 +1598,22 @@ static int ite_probe(struct pnp_dev *pdev, const =
struct pnp_device_id
> =20
>  	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
>  			ITE_DRIVER_NAME, (void *)itdev))
> -		goto failure;
> +		goto failure2;
> =20
>  	ret =3D rc_register_device(rdev);
>  	if (ret)
> -		goto failure;
> +		goto failure3;
> =20
>  	itdev->rdev =3D rdev;
>  	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
> =20
>  	return 0;
> =20
> +failure3:
> +	free_irq(itdev->cir_irq, itdev);
> +failure2:
> +	release_region(itdev->cir_addr, itdev->params.io_region_size);
>  failure:
> -	if (itdev->cir_irq)
> -		free_irq(itdev->cir_irq, itdev);
> -
> -	if (itdev->cir_addr)
> -		release_region(itdev->cir_addr, itdev->params.io_region_size);
> -
>  	rc_free_device(rdev);
>  	kfree(itdev);
> =20
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-ci=
r.c
> index 8b2c071..dc8a7dd 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -1075,19 +1075,19 @@ static int nvt_probe(struct pnp_dev *pdev, const =
struct pnp_device_id *dev_id)
> =20
>  	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
>  			NVT_DRIVER_NAME, (void *)nvt))
> -		goto failure;
> +		goto failure2;
> =20
>  	if (!request_region(nvt->cir_wake_addr,
>  			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
> -		goto failure;
> +		goto failure3;
> =20
>  	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
>  			NVT_DRIVER_NAME, (void *)nvt))
> -		goto failure;
> +		goto failure4;
> =20
>  	ret =3D rc_register_device(rdev);
>  	if (ret)
> -		goto failure;
> +		goto failure5;
> =20
>  	device_init_wakeup(&pdev->dev, true);
>  	nvt->rdev =3D rdev;
> @@ -1099,17 +1099,15 @@ static int nvt_probe(struct pnp_dev *pdev, const =
struct pnp_device_id *dev_id)
> =20
>  	return 0;
> =20
> +failure5:
> +	free_irq(nvt->cir_wake_irq, nvt);
> +failure4:
> +	release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
> +failure3:
> +	free_irq(nvt->cir_irq, nvt);
> +failure2:
> +	release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
>  failure:
> -	if (nvt->cir_irq)
> -		free_irq(nvt->cir_irq, nvt);
> -	if (nvt->cir_addr)
> -		release_region(nvt->cir_addr, CIR_IOREG_LENGTH);
> -
> -	if (nvt->cir_wake_irq)
> -		free_irq(nvt->cir_wake_irq, nvt);
> -	if (nvt->cir_wake_addr)
> -		release_region(nvt->cir_wake_addr, CIR_IOREG_LENGTH);
> -
>  	rc_free_device(rdev);
>  	kfree(nvt);
> =20

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-gYV3ApEPg7Hv9r8C6d6B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7GzMee/yOyVhhEJAQqvqQ/+IlFAG7Bg9I+vwobSnKRr6pelgM8mTZMG
tdRzQW6OBW2ZS+Q0nJTIFGv3wL7K/b39YHQtA4CnbjSEOXpKka/yoE+NyUfzlWGU
UWpyqlNLrTMKWBJzLyJhoWCc8HUSNsfmnGTKy/44SWX16dvZk2YA7YhPUdwYchCs
Sk7R9K9xNUJxGCH7GBaT0k6KoLpdnf/fa2PogY36Rs4R/TGwpadIL38VCNi/+C0N
DTFC+UOwmIltDoA4tahB1g2LIMKs+54esoCbtbQ1irugDbmFpjmMZP4wDE78P9KT
Paldy1/0mcgqnOC/xGxqC+W7i7xjIsT6N1Kvdnqjw309AT5DHHBZa35RH4H5/N4U
UCJ8YPU8LE44RfGTfnmwV9OvNsOalU0/nfDVGroNDi7buIic5X9To1kNoRtTVKGW
z79Peq7qnCtKEdH+noMpt/3AtiVQGYZRABb+CPcHPRdu3/fMHJ0k7NGTn+R68PtT
FwCsgMqsL7ciW0MD42AHTmndBg2rQrrMfgj97S1Op05F4rJm+oHbjsnyl1rwNsmw
NA1rX9xpjrkqvCYhnls44mS29/A6+zBbpMPOnkw43yw6XRnBGdYoRxhzqOolIXUh
GwM+ie5pe2gw7O09I2E+sZvv4npPlA0ixH655ZVlHql9Rw+eiMoylxdtZiRfp4VK
5bNVtiG1shs=
=PGJc
-----END PGP SIGNATURE-----

--=-gYV3ApEPg7Hv9r8C6d6B--
