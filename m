Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44752 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425851AbdD2JTW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 05:19:22 -0400
Date: Sat, 29 Apr 2017 11:19:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [patch] propagating controls in libv4l2 was Re: support
 autofocus / autogain in libv4l2
Message-ID: <20170429091919.GA14148@amd>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20170426082608.7dd52fbf@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +	devices[index].subdev_fds[0] =3D SYS_OPEN("/dev/video_sensor", O_RDWR=
, 0);
> > +	devices[index].subdev_fds[1] =3D SYS_OPEN("/dev/video_focus", O_RDWR,=
 0);
> > +	devices[index].subdev_fds[2] =3D -1;
>=20
> Hardcoding names here is not a good idea. Ideally, it should open
> the MC, using the newgen API, and parse the media graph.
>=20
> The problem is that, even with newgen API, without the properties API
> you likely won't be able to write a generic parser. So, we need a
> plugin specific for OMAP3 (or at least some database that would teach
> a generic plugin about OMAP3 specifics).
>=20
> I guess that the approach that Jacek was taken were very close to what
> a generic plugin would need:
> 	https://lwn.net/Articles/619449/
>=20
> The last version of his patch set is here:
> 	https://patchwork.linuxtv.org/patch/37496/
>=20
> I didn't review his patchset, but from what I saw, Sakari is the one
> that found some issues on v7.1 patchset.
>=20
> Sakari,
>=20
> Could you shed us a light about why this patchset was not merged?
>=20
> Are there anything really bad at the code, or just minor issues that
> could be fixed later?
>=20
> If it is the last case, perhaps we could merge the code, if this
> would make easier for Pavel to work on a N9 solution using the
> same approach.

It would be nice to get some solution here. Camera without libv4l
support is pretty much useless :-(.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkEWpYACgkQMOfwapXb+vKlJwCdEhmJUcv49Uhh8SkA4PoHlqW+
/v8AnjQBrquXo+PtTCQdMR2aFuVZYAHS
=/iGF
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
