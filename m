Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42393 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756382AbdIHNgy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 09:36:54 -0400
Date: Fri, 8 Sep 2017 15:36:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 23/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
Message-ID: <20170908133652.GR18365@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-19-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PY8tzLeNxmyMVNR3"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-19-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PY8tzLeNxmyMVNR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Document optional lens-focus and flash properties for the smiapp driver.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b=
/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> index 855e1faf73e2..a052969365d9 100644
> --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> @@ -27,6 +27,8 @@ Optional properties
>  - nokia,nvm-size: The size of the NVM, in bytes. If the size is not give=
n,
>    the NVM contents will not be read.
>  - reset-gpios: XSHUTDOWN GPIO
> +- flash-leds: One or more phandles to refer to flash LEDs
> +- lens-focus: Phandle for lens focus

Should we simply reference the generic documentation here? If it needs
changing, it will be easier changing single place.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PY8tzLeNxmyMVNR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmynPQACgkQMOfwapXb+vJcswCfWf09m/YpAtrvjLAB+fF8kE9j
33YAn32cQxtad8C8WHyoxtX1oEhymdtg
=TstK
-----END PGP SIGNATURE-----

--PY8tzLeNxmyMVNR3--
