Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46868 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFOWWS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 18:22:18 -0400
Date: Fri, 16 Jun 2017 00:22:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: n900 camera on v4.12-rc (was Re: v4l2-fwnode: status, plans for
 merge, any branch to merge against?)
Message-ID: <20170615222216.GA20714@amd>
References: <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
 <20170306072323.GA23509@amd>
 <20170310225418.GJ3220@valkosipuli.retiisi.org.uk>
 <20170613122240.GA2803@amd>
 <20170613124748.GD12407@valkosipuli.retiisi.org.uk>
 <20170613210900.GA31456@amd>
 <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20170614110634.GP12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Ok, so I played a bit, and now I have working camera in v4.12-rc3.
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-n900.git/
camera-fw5-3 is recommended branch to play with.

Sakari, should I attempt to clean/send you patches, or would it be
better to wait till ccp2 branch is merged upstream? There's one
compile fix, I'll submit that one in following email.

I even have patches for v4l2-utils, so digital camera can be used as
=2E.. digital camera :-). (With rather slow autofocus, and 1Mpix only at
the moment, but hey, its a start, and I already have _one_ nice
picture from it.)

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllDCJgACgkQMOfwapXb+vI42QCgun9KQ5Vvdjjm+Sk89sK2f+U1
DmcAn2+e8xpIEDfbKZcYMmsg1Kz/Z8LE
=CwCo
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
