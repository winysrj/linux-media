Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54615 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbcL0UqB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 15:46:01 -0500
Date: Tue, 27 Dec 2016 21:45:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161227204558.GA23676@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Tue 2016-12-27 11:26:35, Sakari Ailus wrote:
> On Thu, Dec 22, 2016 at 11:01:04AM +0100, Pavel Machek wrote:
> >=20
> > Add driver for et8ek8 sensor, found in Nokia N900 main camera. Can be
> > used for taking photos in 2.5MP resolution with fcam-dev.
> >=20
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> Thanks!
>=20
> I fixed a few checkpatch warnings and one or two minor matters, the diff =
is
> here. No functional changes. I'm a bit surprised checkpatch.pl suggests to
> use numerical values for permissions but I think I agree with that. Reason
> is prioritised agains the rules. :-)

Yeah, there was big flamewar about the permissions. In the end Linus
decided that everyone knows the octal numbers, but the constants are
tricky. It began with patch series with 1000 patches...

> Btw. should we update maintainers as well? Would you like to put yourself
> there? Feel free to add me, too...

Ok, will do.

> The patches are here. I think they should be good to go to v4.11.
>=20
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Det8ek8>
>=20
> Let me know if you're (not) happy with these:

Happy, thanks for doing that. And looking forward for v4.11 :-).

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhi0wYACgkQMOfwapXb+vLu+QCgoGygUJSuELp2CO8Qf6L/5sxy
LEMAoJPKTPoiyT2XtwgwFmvRjZ6CxebP
=Wv6V
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
