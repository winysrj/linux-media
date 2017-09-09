Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48516 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIIJIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 05:08:21 -0400
Date: Sat, 9 Sep 2017 11:08:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 17/24] ACPI: Document how to refer to LEDs from remote
 nodes
Message-ID: <20170909090817.GG27428@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-13-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eVzOFob/8UvintSX"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-13-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--eVzOFob/8UvintSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:18:15, Sakari Ailus wrote:
> Document referring to LEDs from remote device nodes, such as from camera
> sensors.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> diff --git a/Documentation/acpi/dsd/leds.txt b/Documentation/acpi/dsd/led=
s.txt
> new file mode 100644
> index 000000000000..6217fcda15c9
> --- /dev/null
> +++ b/Documentation/acpi/dsd/leds.txt
> @@ -0,0 +1,92 @@
> +Describing and referring to LEDs in ACPI
> +
> +Individual LEDs are described by hierarchical data extension [6] nodes
> +under the device node, the LED driver chip. The "led" property in the
> +LED specific nodes tells the numerical ID of each individual LED. The
> +"led" property is used here in a similar fashion as the "reg" property
> +in DT. [3]
> +
> +Referring to LEDs in Devicetree is documented in [4], in "flash-leds"
> +property documentation. In short, LEDs are directly referred to by
> +using phandles.
> +
> +While Devicetree allows referring to any node in the tree[1], in

Documentation/devicetree/usage-model.txt talks about "device tree" or
"Device Tree" . Single word looks strange to me...

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--eVzOFob/8UvintSX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmzr4EACgkQMOfwapXb+vLf8gCeK2pBgd7UqLUBZ/mHDV4jTLkZ
ixsAniVaWicTXQzKE4erA50jgdo79qF+
=lQ1r
-----END PGP SIGNATURE-----

--eVzOFob/8UvintSX--
