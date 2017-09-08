Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59275 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdIHVpq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 17:45:46 -0400
Date: Fri, 8 Sep 2017 23:45:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 23/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
Message-ID: <20170908214544.GB27428@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-19-sakari.ailus@linux.intel.com>
 <20170908133652.GR18365@amd>
 <20170908134226.m5ts637dej7oa4jw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <20170908134226.m5ts637dej7oa4jw@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:42:26, Sakari Ailus wrote:
> Hi Pavel,
>=20
> On Fri, Sep 08, 2017 at 03:36:52PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > Document optional lens-focus and flash properties for the smiapp driv=
er.
> > >=20
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.t=
xt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > index 855e1faf73e2..a052969365d9 100644
> > > --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > @@ -27,6 +27,8 @@ Optional properties
> > >  - nokia,nvm-size: The size of the NVM, in bytes. If the size is not =
given,
> > >    the NVM contents will not be read.
> > >  - reset-gpios: XSHUTDOWN GPIO
> > > +- flash-leds: One or more phandles to refer to flash LEDs
> > > +- lens-focus: Phandle for lens focus
> >=20
> > Should we simply reference the generic documentation here? If it needs
> > changing, it will be easier changing single place.
>=20
> Good question.
>=20
> Ideally the properties at least would never change; we do have a common
> parser for the properties which is part of the patchset so in theory it
> would be possible to change the documentation in a backward-compatible wa=
y.
>=20
> I added these properties as well as all the other properties supported by
> the sensor driver are documented here. That has been the practice AFAIU,
> albeit omissions do happen occasionally.
>=20
> The issue I see with omitting the documentation here is that the user
> otherwise won't know whether a driver uses a given property or not: it
> shouldn't be necessary to read driver code to write DT source.

I see... OTOH documentation in central place _is_ a bit more verbose:

+- flash-leds: An array of phandles, each referring to a flash LED, a sub-n=
ode
+  of the LED driver device node.

What about:

flash-leds, lens-focus: see <reference to central place>

?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmzD4gACgkQMOfwapXb+vJg3gCdFHDoYN/4wdVf9lsg2ODFOle7
EhgAmwevFhan9WjuQkPNYZxXby0dOGP1
=AHq7
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
