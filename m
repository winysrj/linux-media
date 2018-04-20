Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41587 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754987AbeDTOHa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 10:07:30 -0400
Date: Fri, 20 Apr 2018 16:07:18 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com,
        mchehab@kernel.org
Subject: Re: [PATCH 3/3] media: ov5640: add support for xclk frequency control
Message-ID: <20180420140718.glvufiaau75oumgp@flea>
References: <20180420094419.11267-1-daniel@zonque.org>
 <20180420094419.11267-3-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aw6w4me2pmlkl3d6"
Content-Disposition: inline
In-Reply-To: <20180420094419.11267-3-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aw6w4me2pmlkl3d6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 20, 2018 at 11:44:19AM +0200, Daniel Mack wrote:
> Allow setting the xclk rate via an optional 'clock-frequency' property in
> the device tree node.
>=20
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov5640.txt |  2 ++
>  drivers/media/i2c/ov5640.c                             | 10 ++++++++++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Doc=
umentation/devicetree/bindings/media/i2c/ov5640.txt
> index 8e36da0d8406..584bbc944978 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> @@ -13,6 +13,8 @@ Optional Properties:
>  	       This is an active low signal to the OV5640.
>  - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
>  		   if any. This is an active high signal to the OV5640.
> +- clock-frequency: frequency to set on the xclk input clock. The clock
> +		   is left untouched if this property is missing.

This can be done through assigned-clocks, right?

>  The device node must contain one 'port' child node for its digital output
>  video port, in accordance with the video interface bindings defined in
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 78669ed386cd..2d94d6dbda5d 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2685,6 +2685,7 @@ static int ov5640_probe(struct i2c_client *client,
>  	struct fwnode_handle *endpoint;
>  	struct ov5640_dev *sensor;
>  	struct v4l2_mbus_framefmt *fmt;
> +	u32 freq;
>  	int ret;
> =20
>  	sensor =3D devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> @@ -2731,6 +2732,15 @@ static int ov5640_probe(struct i2c_client *client,
>  		return PTR_ERR(sensor->xclk);
>  	}
> =20
> +	ret =3D of_property_read_u32(dev->of_node, "clock-frequency", &freq);
> +	if (ret =3D=3D 0) {
> +		ret =3D clk_set_rate(sensor->xclk, freq);
> +		if (ret) {
> +			dev_err(dev, "could not set xclk frequency\n");
> +			return ret;
> +		}
> +	}
> +

I'm wondering what the use case for that would be. The clock rate is
subject to various changes depending on the resolution and framerate
used, so that's very likely to change. Wouldn't we be better off to
simply try to change the rate at runtime, depending on those factors?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--aw6w4me2pmlkl3d6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrZ9BUACgkQ0rTAlCFN
r3Tb/g/8DQDJFvW9FZQotExe0fdSyTV0tNMFZc+CaVARKahlC+1YcTzlW+/HX582
QTnR4bTiT2uuPtgLCDRb9Ulkq5GBYRcjsnoLt0A401nlkrhZcP+L+XU+V7etiBeg
C+kVZoZ9qCXy07GaiMnrL83rDk1ws4ftUOuZQVdPwBZE2lvQyv5sl7aVJd/pZYMt
tDjuAVX59eGg+DCJ9Fc9HUyzT+gTrl33aU4VzpS/JnuRFFGPoBl56Kc1COcXxcJs
PlOhxnqPh0S9XCgUFmGJu5Mub47SRNBf7pUajo2FBKxARo3eT+VUIH9sNeUgGS7+
H2MF/Ta0eA9AxrJYA9Vj17gZnk598AJjtM+sGB5wHqwZOgzPy1VcvGKrDV28EBcu
fu+Jb8w4HvLpCL4U9cnzdZsHCsPNgKdZfYM8WpBZwuStf5dDsnT7/ZvnClDB/5ka
OWfO1luMBO8o/yqcEdWVsKYmBzvlXC853F0/LuoTnP3Na4CLadvs0JBNhDW6ZKX4
cOne4PCNR9xJPKssUccVh6/z7WgaNr+P8sblKpR1pnbILdYc0nSvU+WPnfmUuWge
VWEtcdCPh3iqopZalOAfA0AWJn544QjivK49Hyxd3HU39N9JD9A3+zspxPRW9RzR
J/DE3z0D7ClVkp/AnB4KIBmICBFZ1HdetgP1I2Zplhl1Bp25eJI=
=VvQH
-----END PGP SIGNATURE-----

--aw6w4me2pmlkl3d6--
