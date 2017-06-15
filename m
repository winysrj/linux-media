Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44439 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbdFOJVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 05:21:38 -0400
Date: Thu, 15 Jun 2017 11:21:33 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 1/8] dt: bindings: Add a binding for flash devices
 associated to a sensor
Message-ID: <20170615092133.edwi7szqowbnktev@earth>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="asxt4pmjxf6f757o"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--asxt4pmjxf6f757o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 14, 2017 at 12:47:12PM +0300, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..9723f7e 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -67,6 +67,14 @@ are required in a relevant parent node:
>  		    identifier, should be 1.
>   - #size-cells    : should be zero.
> =20
> +
> +Optional properties
> +-------------------
> +
> +- flash: phandle referring to the flash driver chip. A flash driver may
> +  have multiple flashes connected to it.
> +
> +
>  Optional endpoint properties
>  ----------------------------
> =20
> --=20
> 2.1.4
>=20

--asxt4pmjxf6f757o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllCUZoACgkQ2O7X88g7
+ppcgg//bpZhmnLRACd8mVUt9Fs5oBnWSX3nuFakCDnKyNI1bOpdpc3og7Toe5gi
ig1tTr6nkh4egAlo/U9AvgjPJdJ64/cTa+cO95cESgYHQCxd089HcUwKvfRqkQeg
brjP3ToaaEIYQ2nixrGiEFWpV6r5ZBr5S2cW286LRg/qVRlWmpY0EHDZnOA3AekG
rFVmC5iNcukc6Gvp+28X2pu44HpUf66rZ2Wh2wbiJMBjukkC/c0tIX+2dOkwN5An
wuV3FulbdWHgVRwy4TjTfFzRr+k5y2pkfKcw7E0yKlL5ctOtWCGa0UpGOUI5+YTo
47sb1lCc4OpNxGwnOMrWRCjApSosn6ABT4lSLWrev/+jqKOckirRg+kDZXvPn24G
tMUrdmoObbBkkBycxvTJnroIt7tbLrIJsOnBeuiDCQ3QGYthJl1KIU9dlaRDDu0u
12ELTFtC1NGthFEYwg4noTzUNX5YB3IzvSJ6ppg13dJdrNND2YLH/jCFz9TUf4z+
Waz5EcklMYzqStXjM8T8xjh3dgWFY+pMUulN9vGAzWh8zFkONrn2BABL/3wfpYaQ
UDFLxVoh2wAIpcKhEzV+Luv9svAybwPDJnkcuZ3wW3piAHxNFDgmpxj6O0sNTIcP
BTfiiajlTlw6JHKxhuh4/bRVz39d/vpsH3oVqD9hXck1+VaDxB0=
=Tsvz
-----END PGP SIGNATURE-----

--asxt4pmjxf6f757o--
