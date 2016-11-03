Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52220 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbcKCIOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 04:14:38 -0400
Date: Thu, 3 Nov 2016 09:14:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161103081433.GA12609@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161101153921.GA15268@amd>
 <20161101200831.GE3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20161101200831.GE3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I'll have to go through the patches, et8ek8 driver is probably not
> > > > enough to get useful video. platform/video-bus-switch.c is needed f=
or
> > > > camera switching, then some omap3isp patches to bind flash and
> > > > autofocus into the subdevice.
> > > >=20
> > > > Then, device tree support on n900 can be added.
> > >=20
> > > I briefly discussed with with Sebastian.
> > >=20
> > > Do you think the elusive support for the secondary camera is worth ke=
eping
> > > out the main camera from the DT in mainline? As long as there's a rea=
sonable
> > > way to get it working, I'd just merge that. If someone ever gets the
> > > secondary camera working properly and nicely with the video bus switc=
h,
> > > that's cool, we'll somehow deal with the problem then. But frankly I =
don't
> > > think it's very useful even if we get there: the quality is really
> > > bad.
> >=20
> > Well, I am a little bit worried that /dev/video* entries will
> > renumber themself when the the front camera support is merged,
> > breaking userspace.
> >=20
> > But the first step is still the same: get et8ek8 support merged :-).
>=20
> Do you happen to have a patch for the DT part as well? People could more
> easily test this...

If you want complete/working tree for testing, it is at

https://git.kernel.org/cgit/linux/kernel/git/pavel/linux-n900.git/?h=3Dcame=
ra-v4.9

If you want userspace to go with that, there's fcam-dev. It is on
gitlab:

https://gitlab.com/pavelm/fcam-dev


> > > > > Do all the modes work for you currently btw.?
> > > >=20
> > > > I don't think I got 5MP mode to work. Even 2.5MP mode is tricky (ne=
eds
> > > > a lot of continuous memory).
> > >=20
> > > The OMAP 3 ISP has got an MMU, getting some contiguous memory is not =
really
> > > a problem when you have a 4 GiB empty space to use.
> >=20
> > Ok, maybe it is something else. 2.5MP mode seems to work better when
> > there is free memory.
>=20
> That's very odd. Do you use MMAP or USERPTR buffers btw.? I remember the
> cache was different on 3430, that could be an issue as well (VIVT AFAIR, =
so
> flushing requires making sure there are no other mappings or flushing the
> entire cache).

The userland code I'm using does

 struct v4l2_requestbuffers req;
 memset(&req, 0, sizeof(req));
 req.type   =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
 req.memory =3D V4L2_MEMORY_MMAP;
 req.count  =3D 8;
 printf("Reqbufs\n");
 if (ioctl(fd, VIDIOC_REQBUFS, &req) < 0) {
 ...
	=09

so I guess answer to your question is "MMAP". The v4l interface is at

https://gitlab.com/pavelm/fcam-dev/blob/master/src/N900/V4L2Sensor.cpp

=2E
Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlga8ekACgkQMOfwapXb+vKWggCfS0GP6sM8tAu27F9KckDAYRWy
Jj8AoLoOWFJdFOqMATESI+M5JppUtVdj
=pXf2
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
