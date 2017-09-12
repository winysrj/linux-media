Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41301 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdILVzb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 17:55:31 -0400
Date: Tue, 12 Sep 2017 23:55:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170912215529.GA17218@amd>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
 <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-09-12 20:53:33, Jacek Anaszewski wrote:
> Hi Pavel,
>=20
> On 09/12/2017 12:36 PM, Pavel Machek wrote:
> > Hi!
> >=20
> > There were some changes to as3645a flash controller. Before we have
> > stable interface we have to keep forever I want to ask:
>=20
> Note that we have already two LED flash class drivers - leds-max77693
> and leds-aat1290. They have been present in mainline for over two years
> now.

Well.. that's ok. No change there is neccessary.

> > What directory are the flash controls in?
> >=20
> > /sys/class/leds/led-controller:flash ?
> >=20
> > Could we arrange for something less generic, like
> >=20
> > /sys/class/leds/main-camera:flash ?
>=20
> I'd rather avoid overcomplicating this. LED class device name pattern
> is well defined to devicename:colour:function
> (see Documentation/leds/leds-class.txt, "LED Device Naming" section).
>=20
> In this case "flash" in place of the "function" segment makes the
> things clear enough I suppose.

It does not.

Phones usually have two cameras, front and back, and these days both
cameras have their flash.

And poor userspace flashlight application can not know if as3645
drivers front LED or back LED. Thus, I'd set devicename to
front-camera or main-camera -- because that's what it is associated
with. Userspace does not care what hardware drives the LED, but needs
to know if it is front or back camera.

If LEDs control keyboard backlight, I'd expect the LED name to be
"keyboard::backlight", not "i2c-0020-adp1643::backlight".

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm4V9EACgkQMOfwapXb+vLdcwCgk3Ik5igvylPGOQXku9KF7w7L
tB0AnjFAMGKZiq1ZG5rx1o0WYkF5vDWu
=xQx3
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
