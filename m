Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54097 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1430214AbdDYM2X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 08:28:23 -0400
Date: Tue, 25 Apr 2017 14:28:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170425122820.GD7926@amd>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170425080538.GA30380@amd>
 <20170425080815.GD30553@pali>
 <20170425112330.GB7926@amd>
 <20170425113009.GH30553@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <20170425113009.GH30553@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-04-25 13:30:09, Pali Roh=E1r wrote:
> On Tuesday 25 April 2017 13:23:30 Pavel Machek wrote:
> > Hi!
> > On Tue 2017-04-25 10:08:15, Pali Roh=E1r wrote:
> > > On Tuesday 25 April 2017 10:05:38 Pavel Machek wrote:
> > > > > > It would be nice if more than one application could be accessin=
g the
> > > > > > camera at the same time... (I.e. something graphical running pr=
eview
> > > > > > then using command line tool to grab a picture.) This one is
> > > > > > definitely not solveable inside a library...
> > > > >=20
> > > > > Someone once suggested to have something like pulseaudio for V4L.
> > > > > For such usage, a server would be interesting. Yet, I would code =
it
> > > > > in a way that applications using libv4l will talk with such daemon
> > > > > in a transparent way.
> > > >=20
> > > > Yes, we need something like pulseaudio for V4L. And yes, we should
> > > > make it transparent for applications using libv4l.
> > >=20
> > > IIRC there is already some effort in writing such "video" server which
> > > would support accessing more application into webcam video, like
> > > pulseaudio server for accessing more applications to microphone input.
> >=20
> > Do you have project name / url / something?
>=20
> Pinos (renamed from PulseVideo)
>=20
> https://blogs.gnome.org/uraeus/2015/06/30/introducing-pulse-video/
> https://cgit.freedesktop.org/~wtay/pinos/
>=20
> But from git history it looks like it is probably dead now...

Actually, last commit is an hour ago on "work" branch. Seems alive to
me ;-).

Thanks for pointer...
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj/QOQACgkQMOfwapXb+vLofgCbBkdPWyCO189iWJQH52URbxCP
V0MAn3ll1IdttAg0cFZWuuSSRNGbvFB0
=OJ60
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--
