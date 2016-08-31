Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933214AbcHaOSv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 10:18:51 -0400
Date: Wed, 31 Aug 2016 16:18:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 5/5] smiapp: Switch to gpiod API for GPIO control
Message-ID: <20160831141846.3wfdgosly5z7y6h5@earth>
References: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
 <1472648456-26608-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="deouasal256xgimc"
Content-Disposition: inline
In-Reply-To: <1472648456-26608-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--deouasal256xgimc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 31, 2016 at 04:00:56PM +0300, Sakari Ailus wrote:
> Switch from the old gpio API to the new descriptor based gpiod API.
>
> [...]
>
> @@ -2572,17 +2569,10 @@ static int smiapp_init(struct smiapp_sensor *sens=
or)
>  		}
>  	}
> =20
> -	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
> -		rval =3D devm_gpio_request_one(
> -			&client->dev, sensor->hwcfg->xshutdown, 0,
> -			"SMIA++ xshutdown");
> -		if (rval < 0) {
> -			dev_err(&client->dev,
> -				"unable to acquire reset gpio %d\n",
> -				sensor->hwcfg->xshutdown);
> -			return rval;
> -		}
> -	}
> +	sensor->xshutdown =3D devm_gpiod_get_optional(&client->dev, "xshutdown",
> +						    GPIOD_OUT_LOW);
> +	if (!sensor->xshutdown)
> +		dev_dbg(&client->dev, "no xshutdown GPIO available\n");

devm_gpiod_get_optional may return an error pointer, e.g. for
-EPROBE_DEFER, so you should add:

if (IS_ERR(sensor->xshutdown)) {
    rval =3D PTR_ERR(sensor->xshutdown);
    dev_err(&client->dev, "Could not get gpio (%ld)\n", rval);
    return rval;
}

> [...]

Otherwise the patch looks fine, so with this fixed:

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--deouasal256xgimc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxudDAAoJENju1/PIO/qab38P/3OvMNiHej9FIwrvgtMUa2uL
ni7QXyVyVHsZWGSAOGmYKRTdPL8792pGRct7qsZRiRL+3z3iTEnWdwrDrFU8ZkN5
X+EdA4WfvajKK8BATnuwkAYv5FjNBdcdE4t7FeGAt/bEY9Uw3uG2VYetIBh0lsyn
Wi0dQi6cxHFlSqfTcXzTxbQUcOxzycp4xaqpwkS373xkqiYmJjhLMXHJvOZKahLr
YkYdEDJcC6mEyLwojizcdKEpNq7CC7KwsslluZGHGV2MbDUUxSTLJCjXO0b33/kh
U/C9r3YUz/CMKE5hn60QbdocNgZfucYrXBpD+azvz8s4W6EtFQKTU22DR5sAWM+1
ShdXLU9fG5j8NqkEu/z7K+iJ6LpwazX+hby7riHkItH2QpivAISNtaujRNec+I+A
hK1Aq0gRblsVfw7PVeSzLeqwXAKCBqBOQx8bPMcfnOEVIVZuyhekzv7MjH5r+U/S
xM1OQqvJhovfasRCKMzJ3iIS1x2fQlQlms7B4+ZO0ZsFLtlk8mqJMlNJAOq+eVZJ
B+1VXEFUkIrAhaSiMdeLljm1aqw13W9nQZJA19RUDS4LvCM7EHGGPIWrSCJcsiLd
Fe1YvF6wjb7uyKxqhaRcU0n8K/0gXx5pTbt81EksHifjedpnVAUlpvOIUAo23e1Z
bKsaW93Kkmt/gZui0S8P
=oXA9
-----END PGP SIGNATURE-----

--deouasal256xgimc--
