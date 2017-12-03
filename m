Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41603 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752182AbdLCTnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Dec 2017 14:43:49 -0500
Date: Sun, 3 Dec 2017 20:43:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171203194347.bbds47a72xbc4nvl@ninjato>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
 <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
 <20171127185116.j2vmkhbik33vk4f7@ninjato>
 <20171128153446.6pyqtkcvuepil5gi@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6wukw5ozyhf42gtr"
Content-Disposition: inline
In-Reply-To: <20171128153446.6pyqtkcvuepil5gi@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6wukw5ozyhf42gtr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > We pretty much assume everything is DMA safe already, the majority of
> > > transfers go to/from kmalloc()ed scratch buffers so actually are DMA
> > > safe but for bulk transfers we use the caller buffer and there might =
be
> > > some problem users.
>=20
> > So, pretty much the situation I2C was in before this patch set: we
> > pretty much assume DMA safety but there might be problem users.
>=20
> It's a bit different in that it's much more likely that a SPI controller
> will actually do DMA than an I2C one since the speeds are higher and
> there's frequent applications that do large transfers so it's more
> likely that people will do the right thing as issues would tend to come
> up if they don't.

Yes, for SPI this is true. I was thinking more of regmap with its
usage of different transport mechanisms. But I guess they should all be
DMA safe because some of them need to be DMA safe?

> > > I can't really think of a particularly good way of
> > > handling it off the top of my head, obviously not setting the flag is
> > > easy but doesn't get the benefit while always using a bounce buffer
> > > would involve lots of unneeded memcpy().  Doing _dmasafe() isn't
> > > particularly appealing either but might be what we end up with.
>=20
> > Okay. That sounds you are fine with the approach taken here, in general?
>=20
> It's hard to summon enthusiasm but yes, without changes to the DMA stuff
> it's probably as good as we can do.

That sums it up pretty nicely. However, despite even my limited
enthusiasm for this extra flag, I think this set of rules has value. For
some platforms, DMA works more or less by coincidence and can lead to
surprises with e.g. virtual stacks. This is not good engineering
practice, I'd say.

I am going to apply this series now. Thanks for your input!


--6wukw5ozyhf42gtr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlokU+8ACgkQFA3kzBSg
KbZEAw/8C7qguWXZiHqgBFRSBkOKH3nnp7e5WxxGz2maAzQuUOzwoAYTAURYOvM5
kQ0dIvhOd1rTJRVlEUqCgQnf3jVVzrZLq9iaS/KSiPBi4i18inBnoKSTm/+4tlfS
HeaXxGokKiQQFwzokP8IkLN4VHWIXTL3yXwByJW8aJlTFSdAVfd8gTs97IOeSAQj
URF+MfBNSgacEKicgJnfFU6ZFo3ds+tP909xA4lRTDDFLg4GSNPN/9ITUihPb8VW
jGMRG6WPd8rsH4HDpUpzahQ3Jzy6Kx8WZOjuJNRf1/kgvYK2eFtkzAUcnU2ZMg92
Za4PJOpY7qB1mMNldZikoXlDkdj3+emlCVlgNt//6/XBvsC6Vxcw4NtnL4B7+JfR
Zs2Ur1TUbEh0qin4U13piz0GCLTAhosjCwMHvs9luDnuRTAqK9HvnWtTRm/u+Xqs
Kg9I5v0K9rSwbtTcSbsigahfcRdesbQPchLmDSmZP54EYTg54Ddqqkhki9dAzY7G
ULy+/MxPOZGjUa6LwLM9Gg8mbS/cLWZZ+WuyGn0k1MerUeRkQYmotR9fRVmGw85Y
cBYHZo9Dc8SGUtW5yknLDw5bWmKZmHjFMvaJy9i6oGJ5mNfxOi1XCV2uESMMPzRV
+VRnmHmt37BhIv0ylX8ObdQwmsYVO0vc/W3F+S4xesOJ14B8Btc=
=pT0C
-----END PGP SIGNATURE-----

--6wukw5ozyhf42gtr--
