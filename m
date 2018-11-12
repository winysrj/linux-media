Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53072 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbeKMCrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 21:47:33 -0500
Message-ID: <023f5c1f74560f1974d302197a549ff04d7a3dd9.camel@bootlin.com>
Subject: Re: [PATCH v5 5/5] media: cedrus: Get rid of interrupt bottom-half
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 12 Nov 2018 17:53:26 +0100
In-Reply-To: <20181018180224.3392-6-ezequiel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
         <20181018180224.3392-6-ezequiel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-R1xhX0VQXPRYRVApuspy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-R1xhX0VQXPRYRVApuspy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-10-18 at 15:02 -0300, Ezequiel Garcia wrote:
> Now that the mem2mem framework guarantees that .device_run
> won't be called from interrupt context, it is safe to call
> v4l2_m2m_job_finish directly in the top-half.
>=20
> So this means the bottom-half is no longer needed and we
> can get rid of it.
>=20
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++++---------------
>  1 file changed, 5 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c b/drivers/sta=
ging/media/sunxi/cedrus/cedrus_hw.c
> index 32adbcbe6175..493e65b17b30 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> @@ -98,23 +98,6 @@ void cedrus_dst_format_set(struct cedrus_dev *dev,
>  	}
>  }
> =20
> -static irqreturn_t cedrus_bh(int irq, void *data)
> -{
> -	struct cedrus_dev *dev =3D data;
> -	struct cedrus_ctx *ctx;
> -
> -	ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
> -	if (!ctx) {
> -		v4l2_err(&dev->v4l2_dev,
> -			 "Instance released before the end of transaction\n");
> -		return IRQ_HANDLED;
> -	}
> -
> -	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static irqreturn_t cedrus_irq(int irq, void *data)
>  {
>  	struct cedrus_dev *dev =3D data;
> @@ -165,7 +148,9 @@ static irqreturn_t cedrus_irq(int irq, void *data)
> =20
>  	spin_unlock_irqrestore(&dev->irq_lock, flags);
> =20
> -	return IRQ_WAKE_THREAD;
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> +
> +	return IRQ_HANDLED;
>  }
> =20
>  int cedrus_hw_probe(struct cedrus_dev *dev)
> @@ -187,9 +172,8 @@ int cedrus_hw_probe(struct cedrus_dev *dev)
> =20
>  		return irq_dec;
>  	}
> -	ret =3D devm_request_threaded_irq(dev->dev, irq_dec, cedrus_irq,
> -					cedrus_bh, 0, dev_name(dev->dev),
> -					dev);
> +	ret =3D devm_request_irq(dev->dev, irq_dec, cedrus_irq,
> +			       0, dev_name(dev->dev), dev);
>  	if (ret) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
> =20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-R1xhX0VQXPRYRVApuspy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvpsAYACgkQ3cLmz3+f
v9ElAwf+KYJ2nDLyzk8l1n5mKubM5Z5yi+lBrZ4/0mgQGPRyZV62YssznR3vNv5k
tphxA/qW90xJThSm/0zMKGhqxQTFFd17C0eLu0Yq6uST9Imsvipuu7CgPCF9tR/d
YfgBB7FLkz3Krg/1mY7Yop5iw/SjLewq3Gjjsd1WpvB8fAjec3vsF3Yx/aAKO4ZW
dxVYNJsryDgYWQVLnFF2ffVKUmO+DgpyKIEiM8JUuGG3u4yIdFmY9qw/0A9XfgIF
4WHwAmOjCLjP4akNTEI5K1tfTsvJD6UkzXEKocVAslN07VvSAFonc4fjOwlAzV0l
dVWJn3gHox1GzecgttMqTozgTIwVJQ==
=Wmpo
-----END PGP SIGNATURE-----

--=-R1xhX0VQXPRYRVApuspy--
