Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:58928 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752904AbdLDWFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 17:05:45 -0500
Date: Mon, 4 Dec 2017 22:05:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171204220541.GA11658@finisterre>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
 <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
 <20171127185116.j2vmkhbik33vk4f7@ninjato>
 <20171128153446.6pyqtkcvuepil5gi@sirena.org.uk>
 <20171203194347.bbds47a72xbc4nvl@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20171203194347.bbds47a72xbc4nvl@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 03, 2017 at 08:43:47PM +0100, Wolfram Sang wrote:

> > It's a bit different in that it's much more likely that a SPI controller
> > will actually do DMA than an I2C one since the speeds are higher and
> > there's frequent applications that do large transfers so it's more
> > likely that people will do the right thing as issues would tend to come
> > up if they don't.

> Yes, for SPI this is true. I was thinking more of regmap with its
> usage of different transport mechanisms. But I guess they should all be
> DMA safe because some of them need to be DMA safe?

Possibly.  Hopefully.  I guess we'll find out.

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlolxrEACgkQJNaLcl1U
h9BIpwgAgHPDxEsQuguVjEwmYUaDlg6+A7KqNKkDscBkBtcjuJjy6wdqhhhRiyzU
JNcqsxq2Ogb83mLZGQnsibgWunG+z1deqiEd55t5V+SvRL/tkdBvu89jZu3CptXF
2XX50fgea8FDLlShznSwBzkLUfKX8klKJidfZ0d8VWy8xxZPcXf36WF2g+JWtIzT
YHoCbhoIgNemyfwMVoa/CIiqm1dy9jflCzIRR23mWKTTBBU9sXITRl5/Ytq+pBlw
B+pSwFfzRA6FiuDDa493eIk2Ktrtb4ONFR7o2Tz2wDMCAN+b3ABpRoS+WPWgSfbt
8EKHoaQTLPpRohGy3CPZvJiZ4wZznA==
=OkaE
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
