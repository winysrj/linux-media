Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48036 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752774AbdK0SvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 13:51:18 -0500
Date: Mon, 27 Nov 2017 19:51:16 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171127185116.j2vmkhbik33vk4f7@ninjato>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
 <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mn6nogm4h73ihrkm"
Content-Disposition: inline
In-Reply-To: <20171108225037.i4dx5iu5zxc542oq@sirena.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mn6nogm4h73ihrkm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 08, 2017 at 10:50:37PM +0000, Mark Brown wrote:
> On Sat, Nov 04, 2017 at 09:20:00PM +0100, Wolfram Sang wrote:
>=20
> > While previous versions until v3 tried to magically apply bounce buffer=
s when
> > needed, it became clear that detecting DMA safe buffers is too fragile.=
 This
> > approach is now opt-in, a DMA_SAFE flag needs to be set on an i2c_msg. =
The
> > outcome so far is very convincing IMO. The core additions are simple an=
d easy
> > to understand. The driver changes for the Renesas IP cores became easy =
to
> > understand, too.
>=20
> It would really help a lot of things if there were a way to detect if a
> given memory block is DMA safe, having to pass the information around
> causes so much pain.

I so agree.

> > I am still not sure how we can teach regmap this new flag. regmap is a =
heavy
> > user of I2C, so broonie's opinion here would be great to have. The rest=
 should
> > mostly be updating individual drivers which can be done when needed.
>=20
> We pretty much assume everything is DMA safe already, the majority of
> transfers go to/from kmalloc()ed scratch buffers so actually are DMA
> safe but for bulk transfers we use the caller buffer and there might be
> some problem users.

So, pretty much the situation I2C was in before this patch set: we
pretty much assume DMA safety but there might be problem users.

> I can't really think of a particularly good way of
> handling it off the top of my head, obviously not setting the flag is
> easy but doesn't get the benefit while always using a bounce buffer
> would involve lots of unneeded memcpy().  Doing _dmasafe() isn't
> particularly appealing either but might be what we end up with.

Okay. That sounds you are fine with the approach taken here, in general?

Thanks,

   Wolfram


--mn6nogm4h73ihrkm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlocXqMACgkQFA3kzBSg
KbZHtxAArjFGCUHWEI0mb69aZ3Afheaj+Ng9703s+B3PW5cz951UVm1iOueCdVIB
un5esGb+m9z1cP/tJ5BaFO8uveRdwioQ98J33odSQb420mjqrTmRFSecjEyNW7Vv
6MAQhHXsRNqfACrlRcVsXfbwMvXBt1bE2dzZ6eBle/dG6RX5f9krXklQBzfRbZ54
3NCZ2lnRJ8aijxWAnqiwMYqHRHP+5L3jxFWGkmdNC0cbogUg/edahv0r63DH+Jn9
KmF2g/5ANZ1PlXDb+VdTLpmcmYWRniCwcxiVgEoFtb0DAUaExi44boKN6GiJc4Op
2m2RsxHXjHuAZqbpbPX0zTCDaBnzZTUXJnBFKWEDxJGs+3sxUEsrxDvGCmyYxElE
fbFMAbuOFdxOWebQPVUZbnWjFqZxD9qsuG36VAhe4qzA3PJrjrCTk+sIHm1a0VwK
X1IpgUUmCj3Cff/hO8ZKUQgHwBFnp8qpaPrVBpiDX/MLrkt8ngfCj1Km3MCC4O2A
7ks6G+DD++Bw7Vf1aHUp5aD6+wberxoHSPUKB3CpDXjPusVghKgRb/oz6Il+xFr8
STcCrzmmAgeIl3RHA2pFKh7B8zMynwte+/2BdoKPN9RH7KGqi5BcC2cdXMXeN/yz
icSgbMKoMnut/5l5RfMl/1RjAIPb0Mw8OkV/Ye/l3vCqpp06enc=
=ux9A
-----END PGP SIGNATURE-----

--mn6nogm4h73ihrkm--
