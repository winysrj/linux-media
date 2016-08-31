Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbcHaMKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:10:05 -0400
Date: Wed, 31 Aug 2016 14:09:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] smiapp: Switch to gpiod API for GPIO control
Message-ID: <20160831120956.2ij6bslmf6jg3gpy@earth>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472629325-30875-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lqe76fwspfurxaex"
Content-Disposition: inline
In-Reply-To: <1472629325-30875-6-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lqe76fwspfurxaex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sakari,

On Wed, Aug 31, 2016 at 10:42:05AM +0300, Sakari Ailus wrote:
> -	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
> +	if (client->dev.of_node) {
> +		sensor->xshutdown =
> +			devm_gpiod_get_optional(&client->dev, "xshutdown",
> +						GPIOD_OUT_LOW);
> +	} else if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
>  		rval = devm_gpio_request_one(
>  			&client->dev, sensor->hwcfg->xshutdown, 0,
>  			"SMIA++ xshutdown");
> @@ -2581,8 +2582,13 @@ static int smiapp_init(struct smiapp_sensor *sensor)
>  				sensor->hwcfg->xshutdown);
>  			return rval;
>  		}
> +
> +		sensor->xshutdown = gpio_to_desc(sensor->hwcfg->xshutdown);
>  	}

You can drop the devm_gpio_request_one() part and xshutdown from
smiapp_platform_data. The gpiod consumer interface can also be
used with data provided from boardfiles as documented in
Documentation/gpio/board.txt, section "Platform Data". It basically
works like assigning regulators to devices from platform data.

You will obviously have to change every platform_device users of
smiapp, but it looks like upstream has none:

~/linux/arch $ git grep smiapp_platform_data || echo "Not found"
Not found

-- Sebastian

--lqe76fwspfurxaex
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxskSAAoJENju1/PIO/qabYwQAKGvJ0a1NfagjET8g3/Opyf0
3Mzr58OS12jbLAeNZQ8mBTDJM85kKSdwZzhdBAGChDGx4p7+0AhOorIlEUbYP4Ll
BZ6cmtGJqQ43Wijq04QfEHd4nNbQ/FT8zZxD3seq/AyGLUw+hYxQnTZIZxa68n+O
t2Pqka5Jlf/5eqQV1PcuDUw2mCRZxVM2VSeT8pMl/UXAj1gLwNuVI1lDzvV70rID
jPZNt1IAFjUMXKSgT0EbnFKSmOM37lt/h+OepGPG9TgeoSHVX7Vw+oWk4yLnRhHD
csoNzicRw17ownAELfYYEgImxEkxLEj2dG+8ya3TDj7xgxFfBO6DA7U+eV2ku+OT
DPX/bgMD/xHHHpM4hvT/+f7x7zd5r58CzVcTkKdut14yVoJKbBgrplZ6LIYNRvJ0
wkMr/7rMi/mH3K/vepHFr8RWBo1Z1cGI7MAupNXtYR85oN4VBR9xsuuhM+I5azF5
+IcykPlksd0XH31bi7mNBUjvpsQmW1D6AplfWYFH15WMfEyI9us9OICZKbx00mBI
hG/8ovli0/lNGs9cbyJLl14FFPJ7W8wAFc8D4AIzvxyFUVopgt1UWmJhYnHsD+Vw
SAbeW/DZZpLbbvVTzAuyKyYBGPnHRWJnbcCJr4m8CXI2UHV6T/gERlK+fDWPJ9Wh
4wcTcVKgZBkTkNcQ26aa
=jwTk
-----END PGP SIGNATURE-----

--lqe76fwspfurxaex--
