Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40310 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdINLxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 07:53:25 -0400
Date: Thu, 14 Sep 2017 13:53:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170914115323.GA1850@amd>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
 <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
 <20170912215529.GA17218@amd>
 <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
 <CGME20170914092415epcas2p26c049a698851778673034c16afb290b9@epcas2p2.samsung.com>
 <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
 <20170914100718.GA3843@amd>
 <1f34a891-edb1-251c-86a8-ba4a90c485d3@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <1f34a891-edb1-251c-86a8-ba4a90c485d3@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-09-14 13:01:19, Sylwester Nawrocki wrote:
> On 09/14/2017 12:07 PM, Pavel Machek wrote:
> >>Isn't the V4L2 subdev/Media Controller API supposed to provide means
> >>for associating flash LEDs with camera sensors? You seem to be insisting
> >>on using the sysfs leds interface for that, which is not a primary
> >>interface for camera flash AFAICT.
> >
> >a) subdev/media controller API currently does not provide such means.
>=20
> Yes, but it should, that's what it was designed for AFAIK.
>=20
> >b) if we have /sys/class/leds interface to userland, it should be
> >useful.
>=20
> At the same time we shouldn't overcomplicate it with the camera
> functionality.

I'm advocating adding label =3D "main_camera" into the .dts. That's all.

> >c) having flashlight application going through media controller API is
> >a bad joke.
>=20
> It doesn't have to, maybe I misunderstood what you exactly ask for.
> Nevertheless what's missing is some user visible name/label for each
> flash LED, right? Currently enumerating flash LEDs can be done by looking
> at the function part of /sys/class/leds/<led-controller>:<colour>:
> <function> path.
>=20
> Could additional information be appended to the <function> part, so
> user can identify which LED is which? E.g. "flash(rear)", "flash(front)",
> etc. This could be achieved by simply adding label property in DT.
> Or is the list of supported <function> strings already standardized?

label =3D "flash_main_camera" would work for me, yes. And yes, I'd
prefer to do this before 4.14 release, so that userland-visible
interface does not change.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm6bbMACgkQMOfwapXb+vLs5ACfSHGpLyqkbp6oPuWYh9pfwq6S
9RkAmwabXDg4cqAZMqZP9Si2IOvyxCDb
=yM0y
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
