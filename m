Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45446 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbeGRQKL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 12:10:11 -0400
Date: Wed, 18 Jul 2018 16:31:40 +0100
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
Message-ID: <20180718153140.GP5700@sirena.org.uk>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
 <20180718152832.ylu6rlcsaom2q4xm@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GIP5y49pbaVPin6k"
Content-Disposition: inline
In-Reply-To: <20180718152832.ylu6rlcsaom2q4xm@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GIP5y49pbaVPin6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2018 at 05:28:32PM +0200, Wolfram Sang wrote:
> On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:

> > +	ret = __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> > +			       I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL);

> Mark: __i2c_smbus_xfer is a dependency on i2c/for-next. Do you want an
> immutable branch for that?

Oh dear, that dependency wasn't mentioned anywhere I can see in the
submissions and I already applied this and created a signed tag :( .
I'll need a branch to pull in if I'm going to apply this (which I'd
prefer, it tends to make life easier).

--GIP5y49pbaVPin6k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltPXVsACgkQJNaLcl1U
h9DjXgf/axsR8NQUNk9IvtOlgTc/b9f/inR7NzaGZITDNx/h9Xt59O+lR7c/7k9x
8FrzAFuWll0JMhJhDtFHEV9IeraaxByMbIiVffaP0fVh1JWOeoG4jur/aQOvGiov
cEBrpudcsjyqlKvQHor2SqQz+GrCGuuK0zuFcv5Jpe0UV8C02zwGTiy7fAzJSvTC
pPAu/YnExqNOk/p8dj9xlWhBk77OrAS7d4PRDHoMIb0OSOazg0UJc6i/CiJfR2Go
EVRFNCIG+9hBOWEyXS0IBMmFI6tObVUztAmmlGQm5LrYPhNJQPw73O71MRcOy2vs
M5G4s54lbQ8B4D/gipZGKWI6QddT2Q==
=iQ+9
-----END PGP SIGNATURE-----

--GIP5y49pbaVPin6k--
