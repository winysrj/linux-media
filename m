Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42109 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbdFNUl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 16:41:28 -0400
Date: Wed, 14 Jun 2017 22:41:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: add sdlcam example for testing digital still
 camera functionality
Message-ID: <20170614204118.GA10200@amd>
References: <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170521103315.GA10716@amd>
 <57f24742-f039-dce3-8c8f-65b114dfd7d2@xs4all.nl>
 <20170529073227.GA11921@amd>
 <9c846164-a7aa-eb2f-a78f-c14685ab248f@xs4all.nl>
 <20170614111609.GQ12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20170614111609.GQ12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Utilities like v4l2-ctl are tied closely to the kernel and are updated =
whenever
> > new APIs appear. But yet another viewer?
> >=20
> > Mauro, I find that v4l-utils is a bit polluted with non-core utilities.
> > IMHO it should only contain the core libv4l2, core utilities and driver=
-specific
> > utilities. I wonder if we should make a media-utils-contrib for all the=
 non-core
> > stuff.
> >=20
> > What is your opinion?
>=20
> One of the purposes the v4l-utils repository has is that the distributions
> get these programs included to their v4l-utils package as it's typically
> called. It's debatable whether or how much it should contain device speci=
fic
> or otherwise random projects, but having a common location for such progr=
ams
> has clear benefits, too.
>=20
> Based on how this one looks it is definitely not an end user application =
(I
> hope I'm not miscategorising it) and as Pavel mentioned, it has been usef=
ul
> in testing automatic focus / gain control on N900.

Well, I intend to take some photos with it. But yes, it is more useful
for testing -- it is hard to test digital camera without taking photos
-- and eventually I'd like to turn most of it into a library which
"real" camera application would link to.

But that's future. For now I'd like to have something I can test the
kernel drivers with, and perhaps take some photos in the process.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllBn20ACgkQMOfwapXb+vJa1QCcC6HWm1bIs6ySzfOiq3NSY6Hd
AbwAnix2U8QEgeDvVPzaTt6eJDdcCf9w
=JjHu
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
