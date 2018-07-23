Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35068 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388357AbeGWSFV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 14:05:21 -0400
Date: Mon, 23 Jul 2018 18:02:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
Message-ID: <20180723170258.GE13981@sirena.org.uk>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
 <20180718152832.ylu6rlcsaom2q4xm@ninjato>
 <20180718153140.GP5700@sirena.org.uk>
 <20180720215344.6it2k5wckxvwx25p@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <20180720215344.6it2k5wckxvwx25p@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 20, 2018 at 11:53:44PM +0200, Wolfram Sang wrote:

> Here is it:

> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/smbus_xfer_unlock-immutable

Thanks, pulled in now.

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltWCkEACgkQJNaLcl1U
h9CUSwf/ff7c4xQ3H5UVhWpnejDy6b/lHNNiaXrNY25CTtpjuxEX1WndcpmFYvpg
/T15gDyN+Dny+vgyXQKGsUvMjnVkq2JUFt7IgS9o+fuBjEWHsBI0tQtNeUrom1Zq
NmpTd4vo2+bl+8B5W/JvRsdQgwYStObWTIYQ0kE0NKoLvsEGnXgNbN2ODw6ULxPP
/CCRjd6WWgfdqgePs35YzX28Fk3gCiSG72/XcVBqfi9L8OZGCqe80wjwkZWDYKm8
8NczvX0NjWBaDbze7X6EzDHJtLhuB8UNzRlB2B81uharBAe+xKQidKpg4iq01/9o
6VESvzgunrriKHiMaX949CE8fGAWEg==
=NakS
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
