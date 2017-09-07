Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50755 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754862AbdIGMu3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 08:50:29 -0400
Date: Thu, 7 Sep 2017 14:50:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 2/3] leds: as3645a: Add LED flash class driver
Message-ID: <20170907125027.GA3108@amd>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-3-sakari.ailus@linux.intel.com>
 <20170828110451.GB492@amd>
 <20170907102657.stoqw5e7glbkbz2z@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20170907102657.stoqw5e7glbkbz2z@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Mon, Aug 28, 2017 at 01:04:51PM +0200, Pavel Machek wrote:
> > On Wed 2017-08-23 11:10:59, Sakari Ailus wrote:
> > > Add a LED flash class driver for the as3654a flash controller. A V4L2=
 flash
> > > driver for it already exists (drivers/media/i2c/as3645a.c), and this =
driver
> > > is based on that.
> >=20
> > We do not want to have two drivers for same hardware... how is that
> > supposed to work?
>=20
> No, we don't. The intent is to remove the other driver later on, as it's
> implemented as a V4L2 sub-device driver. It also lacks DT support.

Could we perhaps remove the driver with the same patch that merges
this?

Having two drivers would be confusing.

> > Yes, we might want to have both LED and v4l2 interface for a single
> > LED, because v4l2 is just too hairy to use, but we should not
> > duplicate drivers for that.
> >=20
> > We _might_ want to do some helpers; as these LED drivers are all quite
> > similar, it should be possible to have "flash led driver" and just
> > link it to v4l2 and LED interfaces...
>=20
> This is what the new LED (flash) class driver does. Feature-wise it's a
> superset of the old one. There's a minor matter left, though, which is
> querying the flash strobe status which the old driver did and the new one
> does not do yet. I don't know if anyone ever even used that feature thoug=
h.

Yes, I don't think anyone will notice...

Anyway,

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmxQJMACgkQMOfwapXb+vKEsQCfec8p+fVkB0ncl6BBPSmH8icS
C4MAoKhpw8XP0DAU8BXBO1yZMg8zoRks
=JFXp
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
