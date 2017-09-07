Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38071 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdIGURJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 16:17:09 -0400
Date: Thu, 7 Sep 2017 22:17:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 2/3] leds: as3645a: Add LED flash class driver
Message-ID: <20170907201706.GA5478@amd>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-3-sakari.ailus@linux.intel.com>
 <20170828110451.GB492@amd>
 <20170907102657.stoqw5e7glbkbz2z@valkosipuli.retiisi.org.uk>
 <20170907125027.GA3108@amd>
 <20170907145205.k3uzwwgvv3hxrb5t@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20170907145205.k3uzwwgvv3hxrb5t@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-09-07 17:52:05, Sakari Ailus wrote:
> On Thu, Sep 07, 2017 at 02:50:27PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > On Mon, Aug 28, 2017 at 01:04:51PM +0200, Pavel Machek wrote:
> > > > On Wed 2017-08-23 11:10:59, Sakari Ailus wrote:
> > > > > Add a LED flash class driver for the as3654a flash controller. A =
V4L2 flash
> > > > > driver for it already exists (drivers/media/i2c/as3645a.c), and t=
his driver
> > > > > is based on that.
> > > >=20
> > > > We do not want to have two drivers for same hardware... how is that
> > > > supposed to work?
> > >=20
> > > No, we don't. The intent is to remove the other driver later on, as i=
t's
> > > implemented as a V4L2 sub-device driver. It also lacks DT support.
> >=20
> > Could we perhaps remove the driver with the same patch that merges
> > this?
>=20
> This patch is already merged, but I can submit another patch removing the
> other driver.

Yes, that would be nice.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmxqUIACgkQMOfwapXb+vJhWwCdEs9+IDelxw3fI3yoxETelcew
/HUAoL9709t/qByf7xi8MKjsIFQmCEuY
=TuVo
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
