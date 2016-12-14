Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58054 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbcLNWfg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 17:35:36 -0500
Date: Wed, 14 Dec 2016 23:35:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161214223522.GE28424@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
 <20161214201202.GB28424@amd>
 <20161214220749.GA27553@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <20161214220749.GA27553@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Rather some dev_warn()? Do we need stack trace here?
> >=20
> > I don't see what is wrong with WARN(). These are not expected to
> > trigger, if they do we'll fix it. If you feel strongly about this,
> > feel free to suggest a patch.
>=20
> One thing is consistency with other parts of code... On all other places
> is used dev_warn and on above 4 places WARN. dev_warn automatically adds
> device name for easy debugging...
>=20
> Another thing is that above WARNs do not write why it is warning. It
> just write that some condition is not truth...

As I said, I believe it is fine as is.

> > > It was me who copied these sensors settings to kernel driver. And I
> > > chose only Stingray as this is what was needed for my N900 for
> > > testing... Btw, you could add somewhere my and Ivo's Signed-off and
> > > copyright state as we both modified et8ek8.c code...
> >=20
> > Normally, people add copyrights when they modify the code. If you want
> > to do it now, please send me a patch. (With those warn_ons too, if you
> > care, but I think the code is fine as is).
>=20
> I think sending patch in unified diff format for such change is
> overkill. Just place to header it.

Then the change does not happen. Sorry, I do not know what you
modified and when, and if it is copyrightable.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhRySoACgkQMOfwapXb+vLPwQCeId05UJQs1jBBnx2yYocxYup+
CCcAoJ9rAFH74Yn4xRBID+JUozued6dU
=HBu4
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
