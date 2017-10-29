Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2W0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:26:46 -0400
Date: Sun, 29 Oct 2017 23:26:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v16 20/32] dt: bindings: Add a binding for flash LED
 devices associated to a sensor
Message-ID: <20171029222643.hncpyrvlkbrg2k57@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-21-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y2d6l53w2cbhvhga"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-21-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--y2d6l53w2cbhvhga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:30AM +0300, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: devicetree@vger.kernel.org
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index bd6474920510..dc66e3224692 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -76,6 +76,14 @@ are required in a relevant parent node:
>  		    identifier, should be 1.
>   - #size-cells    : should be zero.
> =20
> +
> +Optional properties
> +-------------------
> +
> +- flash-leds: An array of phandles, each referring to a flash LED, a sub=
-node
> +  of the LED driver device node.
> +
> +
>  Optional endpoint properties
>  ----------------------------
> =20
> --=20
> 2.11.0
>=20

--y2d6l53w2cbhvhga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2VaMACgkQ2O7X88g7
+pqpyA//ZAshtDhYm9LJqNOpXhw0XSjSWGgNwpayFfoLZ/G7TcpTROB7tYE9atjZ
6Cbbl7bYdBDr07d4r4QI5/AgzsjZnjUDhvkCW8vT+6em7vY37nHPkcoTv2VOcqgJ
IVrSzPybs94CKrhc8u1x4qJWRaLzcPi9Gi8T/wgC8ayOG0RybwvenwNY+xqJ1UD7
65Hlqa5c3JNjaTNEfRLGMJxVbeO/eS4M946YJDzoCjCZwX1vJBBvBpqgnO10paaa
WVx90XCDbY3t/asMH6ld8q8jmszzauSXy0jTmt5U8kS+giqY5IorcRSLRctOd0kp
OJqEMszDEKYkAHagztnBvcc27UD+l77GMnQZm6syo0jhiC3GwkXm0+NnChPL+ZGz
NErLudA2Y6uHJO0IfaH4Dk80rPFTnoFJrPY7T+71B6Nla8Cakm6OTsMGp5OcySBo
QugHMHbLzFLTAasB3nnXPykBLHqQNIB1zTk79fKFutUmXH03DoQGUr8o0iBnCodU
8z3wIyJaCk2M0wRNu9/BuHbzUyYqNqF6bULl6AC2k0ApCIBl2efONq44Yy+3KF0i
X1uLwVN1ZX1dIwcOpR1BwMNnSALK5C8GT/SLrxK4p9Nzy83+PZzHKoWA4sW/1BhO
SCXZLAiJSNDCyZ9+w8tD0x0DwQFd5n70hObQJ4BTB7lgVGJXAFo=
=/v65
-----END PGP SIGNATURE-----

--y2d6l53w2cbhvhga--
