Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55377 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932277AbeCSMAq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:00:46 -0400
Date: Mon, 19 Mar 2018 13:00:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180319120043.GA20451@amd>
References: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd>
 <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Pavel,
> >=20
> > I appreciate your efforts of adding support for mc-based devices to
> > libv4l.

Thanks.

> > I guess the main poin that Hans is pointing is that we should take
> > extra care in order to avoid adding new symbols to libv4l ABI/API
> > without being sure that they'll be needed in long term, as removing
> > or changing the API is painful for app developers, and keeping it
> > ABI compatible with apps compiled against previous versions of the
> > library is very painful for us.
>=20
> Indeed. Sorry if I wasn't clear on that.

Aha, ok, no, I did not get that.

> > The hole idea is that generic applications shouldn't notice
> > if the device is using a mc-based device or not.
>=20
> What is needed IMHO is an RFC that explains how you want to solve this
> problem, what the parser would look like, how this would configure a
> complex pipeline for use with libv4l-using applications, etc.
>=20
> I.e., a full design.
>=20
> And once everyone agrees that that design is solid, then it needs to be
> implemented.
>=20
> I really want to work with you on this, but I am not looking for partial
> solutions.

Well, expecting design to be done for opensource development is a bit
unusual :-).

I really see two separate tasks

1) support for configuring pipeline. I believe this is best done out
of libv4l2. It outputs description file, format below. Currently I
have implemented this is in Python. File format is below.

2) support for running libv4l2 on mc-based devices. I'd like to do
that.

Description file would look like. (# comments would not be not part of file=
).

V4L2MEDIADESC
3 # number of files to open
/dev/video2
/dev/video6
/dev/video3
3 # number of controls to map. Controls not mentioned here go to
  # device 0 automatically. Sorted by control id.
  # Device 0=20
00980913 1
009a0003 1
009a000a 2

We can parse that easily without requiring external libraries. Sorted
data allow us to do binary search.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqvpmsACgkQMOfwapXb+vJseQCggDRv+6zWVrfjCHaXCQnH02OM
xrQAnifPY34ezC2u9xwW7udb9BtXYQsP
=QMQR
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
