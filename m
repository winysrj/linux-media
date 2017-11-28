Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:37994 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753799AbdK1Peu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 10:34:50 -0500
Date: Tue, 28 Nov 2017 15:34:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171128153446.6pyqtkcvuepil5gi@sirena.org.uk>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
 <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
 <20171127185116.j2vmkhbik33vk4f7@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g4qm2fugrwbwjqft"
Content-Disposition: inline
In-Reply-To: <20171127185116.j2vmkhbik33vk4f7@ninjato>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--g4qm2fugrwbwjqft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 27, 2017 at 07:51:16PM +0100, Wolfram Sang wrote:
> On Wed, Nov 08, 2017 at 10:50:37PM +0000, Mark Brown wrote:

> > We pretty much assume everything is DMA safe already, the majority of
> > transfers go to/from kmalloc()ed scratch buffers so actually are DMA
> > safe but for bulk transfers we use the caller buffer and there might be
> > some problem users.

> So, pretty much the situation I2C was in before this patch set: we
> pretty much assume DMA safety but there might be problem users.

It's a bit different in that it's much more likely that a SPI controller
will actually do DMA than an I2C one since the speeds are higher and
there's frequent applications that do large transfers so it's more
likely that people will do the right thing as issues would tend to come
up if they don't.

> > I can't really think of a particularly good way of
> > handling it off the top of my head, obviously not setting the flag is
> > easy but doesn't get the benefit while always using a bounce buffer
> > would involve lots of unneeded memcpy().  Doing _dmasafe() isn't
> > particularly appealing either but might be what we end up with.

> Okay. That sounds you are fine with the approach taken here, in general?

It's hard to summon enthusiasm but yes, without changes to the DMA stuff
it's probably as good as we can do.

--g4qm2fugrwbwjqft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlodghYACgkQJNaLcl1U
h9DF7Qf/RFs7DXkOGZIsos7EWmLKM4MQxypTYejz8u46jh7yQ9XNHHZMhhr8at6D
J4bSqVSfTI4wQHzUwWK9tfzM3v1BT1ZnEFU8zvTTLMwVyZO9tVIPqjunnGR3vHvf
/N+bbI1NKK6zWlp5vaV8OaVL0Utzm0DEY+2mpWVn3I5Q9OI5JkJ0KlZV+xOE5kLk
5alC3IStVFb+3TiaSXJY9WEiLe21Xau6/xA51iQOdenUgIHfeg2TnLuJiMyvPIRq
6VH1Hm9AQoNx+SuF4fWIVfzsMtz41iU7GBuJRFtdM6Jp+OftlBCIaUaO19GyqipF
EOuxWHDGqOCs0wINJJ9EhR07XVDQZA==
=RZ/Y
-----END PGP SIGNATURE-----

--g4qm2fugrwbwjqft--
