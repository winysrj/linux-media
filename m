Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42467 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755563AbdIHNin (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 09:38:43 -0400
Date: Fri, 8 Sep 2017 15:38:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] as3645a: Use integer numbers for parsing LEDs
Message-ID: <20170908133841.GS18365@amd>
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
 <20170908124213.18904-4-sakari.ailus@linux.intel.com>
 <20170908131758.GQ18365@amd>
 <20170908132333.rlhurlwrzq43ss2k@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3sseE1tnmEs+TkKq"
Content-Disposition: inline
In-Reply-To: <20170908132333.rlhurlwrzq43ss2k@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3sseE1tnmEs+TkKq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:23:34, Sakari Ailus wrote:
> Hi Pavel,
>=20
> Thanks for the review.
>=20
> On Fri, Sep 08, 2017 at 03:17:58PM +0200, Pavel Machek wrote:
> > On Fri 2017-09-08 15:42:13, Sakari Ailus wrote:
> > > Use integer numbers for LEDs, 0 is the flash and 1 is the indicator.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >=20
> > Dunno. Old code is shorter, old device tree is shorter, ... IMO both
> > versions are fine, because the LEDs are really different. Do we have
> > documentation somewhere saying that reg=3D should be used for this? Are
> > you doing this for consistency?
>=20
> Well, actually for ACPI support. :-) It requires less driver changes this
> way. See 17th and 18th patches in "[PATCH v9 00/23] Unified fwnode endpoi=
nt
> parser, async sub-device notifier support, N9 flash DTS".

ACPI, I hate ACPI.

> A number of chips have LED binding that is aligned, see e.g.
> Documentation/devicetree/bindings/leds/leds-bcm6328.txt .

Ok, yes, that's common way LED controllers are handled. Usually all
the LEDs are "same", but...

Acked-by: Pavel Machek <pavel@ucw.cz>

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3sseE1tnmEs+TkKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmynWEACgkQMOfwapXb+vJvGgCeN2aFZ7VFkP4zwan+XVr7SQNy
xH4AnAv/X6P9KegVI000ek5O0pc//Alo
=YBVY
-----END PGP SIGNATURE-----

--3sseE1tnmEs+TkKq--
