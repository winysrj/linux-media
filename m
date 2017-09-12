Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46809 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdILLkx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 07:40:53 -0400
Date: Tue, 12 Sep 2017 13:40:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: as3645a flash userland interface
Message-ID: <20170912114051.GA1655@amd>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd>
 <20170912104720.ifyouc5pa5et6gzk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20170912104720.ifyouc5pa5et6gzk@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Sep 12, 2017 at 12:36:28PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > There were some changes to as3645a flash controller. Before we have
> > stable interface we have to keep forever I want to ask:
> >=20
> > What directory are the flash controls in?
> >=20
> > /sys/class/leds/led-controller:flash ?
> >=20
> > Could we arrange for something less generic, like
> >=20
> > /sys/class/leds/main-camera:flash ?
> >=20
> > Thanks,
>=20
> The LEDs are called as3645a:flash and as3645a:indicator currently, based =
on
> the name of the LED controller's device node. There are no patches related
> to this set though; these have already been merged.
>=20
> The label should be a "human readable string describing the device" (from
> ePAPR, please excuse me for not having a newer spec), and the led common
> bindings define it as:
>=20
> - label : The label for this LED. If omitted, the label is taken from the=
 node
>           name (excluding the unit address). It has to uniquely identify
>           a device, i.e. no other LED class device can be assigned the sa=
me
>           label.

Ok, can we set the label to "main_camera" for N9 and n950 cases?

"as3645a:flash" is really wrong name for a LED. Information that
as3645 is already present elsewhere in /sys. Information where the LED
is and what it does is not.

I'd like to have torch application that just writes
/sys/class/leds/main_camera:white:flash/brightness . It should not
need to know hardware details of differnet phones.

> I don't think that you should be looking to use this to associate it with
> the camera as such. The association information with the sensor is
> available to the kernel but there's no interface that could meaningfully
> expose it to the user right now.

Yeah, I'm not looking for sensor association. I'm looking for
reasonable userland interface.

Thanks,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm3x8MACgkQMOfwapXb+vJruACgvXqnXR5o/7rhska7wPeJDBrX
7HkAn2hHmz2zVpyZQ5Xlo+9KKf03jVV1
=9UsP
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
