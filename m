Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55335 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754473AbcKCK1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 06:27:31 -0400
Date: Thu, 3 Nov 2016 11:27:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20161103102727.GA10084@amd>
References: <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <20160810120105.GP3182@valkosipuli.retiisi.org.uk>
 <20160808232323.GC2946@xo-6d-61-c0.localdomain>
 <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
 <20160818104539.GA7427@amd>
 <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20160818202559.GF3182@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > Yeah. I just compiled it but haven't tested it. I presume it'll w=
ork. :-)
> > > >=20
> > > > I'm testing it on n900. I guess simpler hardware with ad5820 would =
be better for the
> > > > test...
> > > >=20
> > > > What hardware do you have?
> > >=20
> > > N900. What else could it be? :-) :-)
> >=20
> > Heh. Basically anything is easier to develop for than n900 :-(.
>=20
> Is it?
>=20
> I actually find the old Nokia devices very practical. It's easy to boot y=
our
> own kernel and things just work... until musb broke a bit recently. It
> requires reconnecting the usb cable again to function.
>=20
> I have to admit I mostly use an N9.

Well, if you compare that to development on PC, I prefer PC.

Even arm development boards are usually easier, as they don't need too
complex userspace, and do have working serial ports.

But I do have a serial adapter for N900 now (thanks, sre), so my main
problem now is that N900 takes a lot of time to boot into usable
state.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgbEQ8ACgkQMOfwapXb+vKhQQCfcJlJ7yvxB3FtoUg8aQQ02yYa
WZ0An15sp7dXK6wjiUkR8LNpejkMskg1
=SgiJ
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
