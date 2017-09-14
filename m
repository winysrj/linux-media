Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35853 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINKHV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:07:21 -0400
Date: Thu, 14 Sep 2017 12:07:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170914100718.GA3843@amd>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
 <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
 <20170912215529.GA17218@amd>
 <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
 <CGME20170914092415epcas2p26c049a698851778673034c16afb290b9@epcas2p2.samsung.com>
 <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>>>What directory are the flash controls in?
> >>>>
> >>>>/sys/class/leds/led-controller:flash ?
> >>>>
> >>>>Could we arrange for something less generic, like
> >>>>
> >>>>/sys/class/leds/main-camera:flash ?
> >>>
> >>>I'd rather avoid overcomplicating this. LED class device name pattern
> >>>is well defined to devicename:colour:function
> >>>(see Documentation/leds/leds-class.txt, "LED Device Naming" section).
> >>>
> >>>In this case "flash" in place of the "function" segment makes the
> >>>things clear enough I suppose.
> >>
> >>It does not.
> >>
> >>Phones usually have two cameras, front and back, and these days both
> >>cameras have their flash.
> >>
> >>And poor userspace flashlight application can not know if as3645
> >>drivers front LED or back LED. Thus, I'd set devicename to
> >>front-camera or main-camera -- because that's what it is associated
> >>with. Userspace does not care what hardware drives the LED, but needs
> >>to know if it is front or back camera.
> >
> >The name of a LED flash class device isn't fixed and is derived
> >from DT label property. Name in the example of some DT bindings
> >will not force people to apply similar pattern for the other
> >drivers and even for the related one. No worry about having
> >to keep anything forever basing on that.
>=20
> Isn't the V4L2 subdev/Media Controller API supposed to provide means
> for associating flash LEDs with camera sensors? You seem to be insisting
> on using the sysfs leds interface for that, which is not a primary
> interface for camera flash AFAICT.

a) subdev/media controller API currently does not provide such means.

b) if we have /sys/class/leds interface to userland, it should be
useful.

c) having flashlight application going through media controller API is
a bad joke.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm6VNYACgkQMOfwapXb+vIu4wCfcERX0wrdAVt5HeogfBdgba5W
SnIAnReSCKgIbWpDTsfX3/BRFNgx6t/C
=MD5V
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
