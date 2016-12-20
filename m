Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52187 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932586AbcLTWmo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 17:42:44 -0500
Date: Tue, 20 Dec 2016 23:42:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161220224240.GA1885@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
 <20161214201202.GB28424@amd>
 <20161218220105.GS16630@valkosipuli.retiisi.org.uk>
 <20161220123756.GA23035@amd>
 <20161220140119.GE16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20161220140119.GE16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Tue, Dec 20, 2016 at 01:37:56PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > I think WARN() is good. It's a driver bug and it deserves to be notif=
ied.
> > ...
> > > I guess it's been like this since 2008 or so. I guess the comment cou=
ld be
> > > simply removed, it's not a real problem.
> > ...
> > > AFAIR the module is called Stingray.
> >=20
> > Ok, so it seems we are pretty good? Can you take the patch now? Device
>=20
> Did you see this:
>=20
> <URL:http://www.spinics.net/lists/linux-media/msg109426.html>

Yes, I did. I did add the WARN_ON() we discussed, and we are now using
the native units. Adjusting the userspace was "fun", but I agree that
native interface has some advantages, so lets keep it that way. I
truly believe we are ready now :-).=20

> > tree documentation is in
> >=20
> > Subject: [PATCH v6] media: et8ek8: add device tree binding documentation
> >=20
> > and we have
> >=20
> > Acked-by: Rob Herring <robh@kernel.org>
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhZs+AACgkQMOfwapXb+vJ5UQCgrKelAIlqC2+teQjXC1KO6bqk
gc8AoLcxi1YCaobPhSl90c63fdjBe3or
=K6hj
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
