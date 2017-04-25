Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46993 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176305AbdDYIUo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 04:20:44 -0400
Date: Tue, 25 Apr 2017 10:20:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170425082041.GB30380@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424220701.GA27846@amd>
 <20170424225731.7532e368@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20170424225731.7532e368@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Please don't add a new application under lib/. It is fine if you want
> > > some testing application, if the ones there aren't enough, but please
> > > place it under contrib/test/.
> > >=20
> > > You should likely take a look at v4l2grab first, as it could have
> > > almost everything you would need. =20
> >=20
> > I really need some kind of video output. v4l2grab is not useful
> > there. v4l2gl might be, but I don't think I have enough dependencies.
>=20
> Well, you could use some app to show the snaps that v4l2grab takes.

That would be too slow :-(.

> Yeah, compiling v4l2gl on N9 can indeed be complex. I suspect that it=20
> shouldn't hard to compile xawtv there (probably disabling some optional
> features).

I do have mplayer working, but that one is not linked against libv4l2
:-(.

> > Umm, and it looks like libv4l can not automatically convert from
> > GRBG10.. and if it could, going through RGB24 would probably be too
> > slow on this device :-(.
>=20
> I suspect it shouldn't be hard to add support for GRBG10. It already
> supports 8 and 16 bits Bayer formats, at lib/libv4lconvert/bayer.c
> (to both RGB and YUV formats).

Is 16bit bayer a recent development? I can't see it in

commit 374806e868f5a7a48ecffde4c6a1abfcfa5ccd65
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Fri Apr 22 09:31:57 2016 +0200

> > Is there an example using autogain/autowhitebalance from
> > libv4lconvert?
>=20
> Well, if you plug a USB camera without those controls, it should
> automatically expose controls for it, as if the device had such
> controls.

And settings are persistent, so I can enable autogain, then lauch
something like xawtv, and it will automatically get autogain? Ok,
good.

Regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj/BtkACgkQMOfwapXb+vJe3QCcCv3uqYxUvmrbnex/J2lUUTgb
4l8An3okpbiQHihtU2qOW5sxLkVOwOJj
=8wAy
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
