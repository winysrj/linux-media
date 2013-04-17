Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38825 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966116Ab3DQNzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 09:55:06 -0400
Date: Wed, 17 Apr 2013 14:55:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Message-ID: <20130417135503.GL13687@opensource.wolfsonmicro.com>
References: <3775187.HOcoQVPfEE@avalon>
 <8085333.TIMqcSUBaO@avalon>
 <20130415094248.2272db90@redhat.com>
 <1471330.zeTIWizKy8@avalon>
 <516D8C1E.2080704@redhat.com>
 <516D92C4.2040403@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4VOKWutKNZEOIPu"
Content-Disposition: inline
In-Reply-To: <516D92C4.2040403@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--I4VOKWutKNZEOIPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 08:04:52PM +0200, Sylwester Nawrocki wrote:

> It's probably more clean to provide a dummy clock/regulator in a host driver
> (platform) than to add something in a sub-device drivers that would resolve
> which resources should be requested and which not.

Yes, that's the general theory for regulators at least - it allows the
device driver to just trundle along and not worry about how the board is
hooked up.  The other issue it resolves that you didn't mention is that
it avoids just ignoring errors which isn't terribly clever.

--I4VOKWutKNZEOIPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbqmwAAoJELSic+t+oim94QYP/1jAdxa8zEnvjmSO7vTyt8TO
iCAjaLtLegxdmmuv7y+JO1tS+eObWOiuGhjyC8gPe11/9vlHBqI59qqscazrXNCR
xfGRgERN8yL9lfjuclCcTS0yr+reUcKsfX/AOJoy/S/bZd/ycSrcFPO/U9TUbrSD
LJs+/8cBZJ3n7NehrqgLAEeG1qR+ei5zmy2oTBb/tAPRyP7u0xcBNnFjOMdL6Wcd
ZtKCeNVgO/GP4sDOrLO/dl1VgwNjGJ8TrRcwdySvgXKw1IokeP3LREVB9l8s0aRa
08FbCcp0v/Ws11/N/Zkl5PUxQU33ihN/Uoox54WNiHWnHjZv3jtpOx7GWYcyFJVE
c9G2WA5HU2uls3Z+TIjDhTbmDmJASGtwyd2b9noasXoaVgqkbce3E2ezAIi848No
EWPjJBYmcxtmRgsRjLYX28L3/cVJKd7ATVv9upGzFakUYM6c8juvga/Hnf2ePvaA
MfIMRfXvMoAv3LkYtBHsfViVSU6mXBLYlLwQaTuAy7kAstmyqfnVT5W04UVoO6jE
QOR30N1+1JMwL2/aD9f6C2p64lyArLpNKMARWle6PwretYtMXCaC0Z+sKafskyuj
irCtGRAPhQvY6yyEkaJG0EOOd6CT79M2JTKTaT7ykk9WGDJOpctj0K6NbwyxqLmt
U5gQc17vTBuRpSiBxus4
=9wcs
-----END PGP SIGNATURE-----

--I4VOKWutKNZEOIPu--
