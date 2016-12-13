Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44993 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753250AbcLMTH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 14:07:59 -0500
Date: Tue, 13 Dec 2016 20:05:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pali.rohar@gmail.com,
        sakari.ailus@linux.intel.com, mark.rutland@arm.com,
        CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v6 1/2] Add OV5647 device tree documentation
Message-ID: <20161213190554.GD8676@amd>
References: <cover.1481639091.git.roliveir@synopsys.com>
 <c47834c1c9c2a8e23f41a12c8717601f4a901506.1481639091.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <c47834c1c9c2a8e23f41a12c8717601f4a901506.1481639091.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2016-12-13 14:32:36, Ramiro Oliveira wrote:
> Create device tree bindings documentation.
>=20
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++=
++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Doc=
umentation/devicetree/bindings/media/i2c/ov5647.txt
> new file mode 100644
> index 0000000..46e5e30
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> @@ -0,0 +1,35 @@
> +Omnivision OV5647 raw image sensor
> +---------------------------------
> +
> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfa=
ces
> +and CCI (I2C compatible) control bus.
> +
> +Required properties:
> +
> +- compatible	: "ovti,ov5647";
> +- reg		: I2C slave address of the sensor;
> +- clocks	: Reference to the xclk clock.
> +- clock-names	: Should be "xclk".
> +- clock-frequency: Frequency of the xclk clock

Nit pick: you end the lines here with ';', '.' and nothing. Pick one
:-).

Otherwise it looks good.

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhQRpIACgkQMOfwapXb+vLh0QCghGL62LMN0HleUeagxAK5WrXe
IWgAoIdaoxc8y8dvhZpVHBZ7QD8oHz88
=dOWd
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
