Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52922 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752530AbdJ3VTd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 17:19:33 -0400
Date: Mon, 30 Oct 2017 22:19:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [patch] libv4l2: SDL test application
Message-ID: <20171030211931.GA19901@amd>
References: <20171028195742.GB20127@amd>
 <478fd1ae-6f25-5cda-3035-1d5894c8caab@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <478fd1ae-6f25-5cda-3035-1d5894c8caab@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-10-30 17:30:53, Hans Verkuil wrote:
> Hi Pavel,
>=20
> On 10/28/2017 09:57 PM, Pavel Machek wrote:
> > Add support for simple SDL test application. Allows taking jpeg
> > snapshots, and is meant to run on phone with touchscreen. Not
> > particulary useful on PC with webcam, but should work.
>=20
> When I try to build this I get:
>=20
> make[3]: Entering directory '/home/hans/work/src/v4l/v4l-utils/contrib/te=
st'
>   CCLD     sdlcam
> /usr/bin/ld: sdlcam-sdlcam.o: undefined reference to symbol 'log2@@GLIBC_=
2.2.5'
> //lib/x86_64-linux-gnu/libm.so.6: error adding symbols: DSO missing from =
command line
> collect2: error: ld returned 1 exit status
> Makefile:561: recipe for target 'sdlcam' failed
> make[3]: *** [sdlcam] Error 1
> make[3]: Leaving directory '/home/hans/work/src/v4l/v4l-utils/contrib/tes=
t'
> Makefile:475: recipe for target 'all-recursive' failed
> make[2]: *** [all-recursive] Error 1
> make[2]: Leaving directory '/home/hans/work/src/v4l/v4l-utils/contrib'
> Makefile:589: recipe for target 'all-recursive' failed
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory '/home/hans/work/src/v4l/v4l-utils'
> Makefile:516: recipe for target 'all' failed
> make: *** [all] Error 2
>=20
> I had to add -lm -ldl -lrt to sdlcam_LDFLAGS. Is that correct?

Yes, that should be correct. I had that problem, too, but I thought I
solved it with simpler configure.ac.

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAln3l2MACgkQMOfwapXb+vJHHQCfWG79S57+V5f5iaJ4mAJLy2jH
f8MAniXlgVmZV0cFsYla+gGeHBOMnIRV
=Zawd
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
