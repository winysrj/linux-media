Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2XDV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:03:21 -0400
Date: Mon, 30 Oct 2017 00:03:18 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 27/32] dt: bindings: smiapp: Document lens-focus and
 flash-leds properties
Message-ID: <20171029230318.qzf4lfawjam4bqvg@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-28-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sdqeuk7kqid37qbs"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-28-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sdqeuk7kqid37qbs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:37AM +0300, Sakari Ailus wrote:
> Document optional lens-focus and flash-leds properties for the smiapp
> driver.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b=
/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> index 855e1faf73e2..33f10a94c381 100644
> --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> @@ -27,6 +27,8 @@ Optional properties
>  - nokia,nvm-size: The size of the NVM, in bytes. If the size is not give=
n,
>    the NVM contents will not be read.
>  - reset-gpios: XSHUTDOWN GPIO
> +- flash-leds: See ../video-interfaces.txt
> +- lens-focus: See ../video-interfaces.txt
> =20
> =20
>  Endpoint node mandatory properties
> --=20
> 2.11.0
>=20

--sdqeuk7kqid37qbs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XjYACgkQ2O7X88g7
+pr7FA/+LHZ2mwOtND9sJRCoyjQDggsOr1TzkHSmwbNNLngaeh8YCGehmfDvKWr5
R4v6GGVwXkc/39HPB42BpXjGDC2tBpXAA74vk91AR7DOQe8eJRwXMWSmlulomU3J
u1/NQaSFO2/2qZJIOxLziS0D7jgagZ0n+YcjSk+QpQbivBKBmXXzmkn/uzoezJiw
QBTWc3TY8ZxdvG9WTz42Skt5/3BnLni2NtuPflmXgn/9kO1M8wSCmVuRuUGKX86l
t1nxRPvIaJtdT2vbCQ7wcV1W1sh+CCEpMcv4KwV4S47ODDA51Ks0rAaytKkLmvrF
M7R2UHauG0tpTJRFQhgJ+ySL/MRBu2+8e3W0RN97NzyfvjlW32fh/XqjELywN/oq
iNvobmTK5z+AkUXtDzIp1+Ez5bv3jqPfnYFxxbrS8J0czL69HW07vo6FWKmKzuMD
VtmtUjg/8F0vbbSy6Kupe4dciAumIFOc9BBBV2M0cznsYlHhc99xTmFnHId5pevi
8IwG0u4OXrliVC9Bjm7SqpqhUPat2VtzHKp46FZhRz/BVkh848tSlVATDAWS836n
6EJF1rjgbwIe7sGtIQFbpE8KxNIICKF54tE8KW7eOCwO8siwvVEY9Jker6NV4yKt
nGGwa8ROyz0CgWKe/TxJjyBDRheE424pDwdwB5aoHn9/N5PQ64Q=
=goB8
-----END PGP SIGNATURE-----

--sdqeuk7kqid37qbs--
