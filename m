Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35158 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752670AbdKHWuk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Nov 2017 17:50:40 -0500
Date: Wed, 8 Nov 2017 22:50:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7n4kimk7twrwe2wm"
Content-Disposition: inline
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7n4kimk7twrwe2wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 04, 2017 at 09:20:00PM +0100, Wolfram Sang wrote:

> While previous versions until v3 tried to magically apply bounce buffers when
> needed, it became clear that detecting DMA safe buffers is too fragile. This
> approach is now opt-in, a DMA_SAFE flag needs to be set on an i2c_msg. The
> outcome so far is very convincing IMO. The core additions are simple and easy
> to understand. The driver changes for the Renesas IP cores became easy to
> understand, too.

It would really help a lot of things if there were a way to detect if a
given memory block is DMA safe, having to pass the information around
causes so much pain.  There's the fun with vmalloc() mappings too
needing to be handled differently too though that's less likely to bite
I2C.

> I am still not sure how we can teach regmap this new flag. regmap is a heavy
> user of I2C, so broonie's opinion here would be great to have. The rest should
> mostly be updating individual drivers which can be done when needed.

We pretty much assume everything is DMA safe already, the majority of
transfers go to/from kmalloc()ed scratch buffers so actually are DMA
safe but for bulk transfers we use the caller buffer and there might be
some problem users.  I can't really think of a particularly good way of
handling it off the top of my head, obviously not setting the flag is
easy but doesn't get the benefit while always using a bounce buffer
would involve lots of unneeded memcpy().  Doing _dmasafe() isn't
particularly appealing either but might be what we end up with.

--7n4kimk7twrwe2wm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAloDijwACgkQJNaLcl1U
h9DAxgf/WmS2l1fy0LIY6tamV8LhAiBqI23y7IQSnDP9BaVFEcqc/W2FJDzbS+fi
2DlKoGi4pRg+iHzvQlizoijoqq3njMrLP1dOm/zZ2dTE9NFCyOg1+pmcK2AyFfSs
Jl7aXXN46p2ZJQp6H4d6lP4fmHz5YV16lEs/FRjGOQw/1najjj5Pu3erea7cNJcM
f7wWkq3uUYYtmWnbSY3b0cz3x6N3XEK+wBbqiQyzQwNlS91d2US08ZYfkP1iUW7d
M18obQUFr5Shz0B8x74dL6hSC8lD1IWVpWiUu3hlNu7viYIgSy6h6s8ocnWf0Nk7
TXiSbEiuHFukUKkEFVLbc7Rmke3lTg==
=2nyJ
-----END PGP SIGNATURE-----

--7n4kimk7twrwe2wm--
