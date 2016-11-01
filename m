Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44187 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbcKAPjZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 11:39:25 -0400
Date: Tue, 1 Nov 2016 16:39:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161101153921.GA15268@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I'll have to go through the patches, et8ek8 driver is probably not
> > enough to get useful video. platform/video-bus-switch.c is needed for
> > camera switching, then some omap3isp patches to bind flash and
> > autofocus into the subdevice.
> >=20
> > Then, device tree support on n900 can be added.
>=20
> I briefly discussed with with Sebastian.
>=20
> Do you think the elusive support for the secondary camera is worth keeping
> out the main camera from the DT in mainline? As long as there's a reasona=
ble
> way to get it working, I'd just merge that. If someone ever gets the
> secondary camera working properly and nicely with the video bus switch,
> that's cool, we'll somehow deal with the problem then. But frankly I don't
> think it's very useful even if we get there: the quality is really
> bad.

Well, I am a little bit worried that /dev/video* entries will
renumber themself when the the front camera support is merged,
breaking userspace.

But the first step is still the same: get et8ek8 support merged :-).

> > > Do all the modes work for you currently btw.?
> >=20
> > I don't think I got 5MP mode to work. Even 2.5MP mode is tricky (needs
> > a lot of continuous memory).
>=20
> The OMAP 3 ISP has got an MMU, getting some contiguous memory is not real=
ly
> a problem when you have a 4 GiB empty space to use.

Ok, maybe it is something else. 2.5MP mode seems to work better when
there is free memory.

> > Anyway, I have to start somewhere, and I believe this is a good
> > starting place; I'd like to get the code cleaned up and merged, then
> > move to the next parts.
>=20
> I wonder if something else could be the problem. I think the data rate is
> higher in the 5 MP mode, and that might be the reason. I don't remember h=
ow
> similar is the clock tree in the 3430 to the 3630. Could it be that the I=
SP
> clock is lower than it should be for some reason, for instance?

No idea, really. I'd like to get the support merged, and then debug
the code when we have common code base in the mainline.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgYtykACgkQMOfwapXb+vLp0gCggrqPKd9JC26qfA7D7k1fKcfI
Wd4An0HRcWdabe9i1dRD4BfRxmf3P6ad
=LPJl
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
