Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:52405 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754751AbdIHI4o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 04:56:44 -0400
Date: Fri, 8 Sep 2017 10:56:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170908085640.42wzzgd2s2roikyd@ninjato>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
 <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
 <20170827083748.248e2430@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pyvw5k7cs3klgvb6"
Content-Disposition: inline
In-Reply-To: <20170827083748.248e2430@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pyvw5k7cs3klgvb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

thanks for your comments. Much appreciated!

> There are also a couple of things here that Sphinx would complain.
> So, it could be worth to rename it to *.rst, while you're writing
> it, and see what:
> 	make htmldocs
> will complain and how it will look in html.

OK, I'll check that.

> > +Given that I2C is a low-speed bus where largely small messages are tra=
nsferred,
> > +it is not considered a prime user of DMA access. At this time of writi=
ng, only
> > +10% of I2C bus master drivers have DMA support implemented.
>=20
> Are you sure about that? I'd say that, on media, at least half of the
> drivers use DMA for I2C bus access, as the I2C bus is on a remote
> board that talks with CPU via USB, using DMA, and all communication
> with USB should be DMA-safe.

Well, the DMA-safe requirement comes then from the USB subsystem,
doesn't it? Or do you really use DMA on the remote board to transfer
data via I2C to an I2C client?

> I guess what you really wanted to say on most of this section is
> about SoC (and other CPUs) where the I2C bus master is is at the
> mainboard, and not on some peripheral.

I might be biased to that, yes. So, it is good talking about it.

> > And the vast
> > +majority of transactions are so small that setting up DMA for it will =
likely
> > +add more overhead than a plain PIO transfer.
> > +
> > +Therefore, it is *not* mandatory that the buffer of an I2C message is =
DMA safe.
>=20
> Again, that may not be true on media boards. The code that implements the
> I2C transfers there, on most boards, have to be DMA safe, as it won't
> otherwise send/receive commands from the chips that are after the USB
> bridge.

That still sounds to me like the DMA-safe requirement comes from USB
(which is fine, of course.). In any case, a sentence like "Other
subsystem you might use for bridging I2C might impose other DMA
requirements" sounds like to nice to have.

> > +Drivers wishing to implement DMA can use helper functions from the I2C=
 core.
> > +One gives you a DMA-safe buffer for a given i2c_msg as long as a certa=
in
> > +threshold is met.
> > +
> > +	dma_buf =3D i2c_get_dma_safe_msg_buf(msg, threshold_in_byte);
>=20
> I'm concerned about the new bits added by this call. Right now,
> USB drivers just use kalloc() for transfer buffers used to send and
> receive URB control messages for both setting the main device and
> for I2C messages. Before this changeset, buffers allocated this
> way are DMA save and have been working for years.

Can you give me a pointer to a driver doing this? I glimpsed around in
drivers/media/usb and found that most drivers are having their i2c_msg
buffers on the stack. Which is clearly not DMA-safe.

> When you add some flags that would make the I2C subsystem aware
> that a buffer is now DMA safe, I guess you could be breaking
> those drivers, as a DMA safe buffer will now be considered as
> DMA-unsafe.

Well, this flag is only relevant for i2c master drivers wishing to do
DMA. So, grepping in the above directory

	grep dma $(grep -rl i2c_add_adapter *)

only gives one driver which is irrelevant because the i2c master it
registers is not doing any DMA?

Am I missing something? We are clearly not aligned yet...

Regards,

   Wolfram


--pyvw5k7cs3klgvb6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmyW0QACgkQFA3kzBSg
KbYZNg/9EnabaEpCNVqzi+wqs6ncXDgpJtRDPBdRcXGFqjA56pjIUzsIcVUoNYzT
jXhwBFxrUoSrgf0lefnyXhR5kRW6IIi2y+xz+GQFUlx/wETiaJ5k+U7Xq17QF9WM
/BGszke18iiaySHzA5wrv0oTt3wVH5i5zU0Ly5XD1lL0Hxy2UIUXiJLSKPighX0V
6ChQ++Jly8iC+zV4W95AQ5sTydm9+buNiaoy6EapUmIjls4Kt0xbdjk30S1dquew
vf0130vnX6bJf2FLo8gTOuy3LZVPJ6R7hdHe9ffxfcGg5lL77Xx8Xn5hdDLfk/zU
4Gi9dhoKkhMZJ23MOVmnTCgIRvrKwCzmvKSl2lTdvuAGr4CA5FtjmeRJrx2FN5cC
Va9jfcE7RUIlLkP/N7pA7m7Shbxdkm0AnbLTo8Ppud7swfLatvyICCBTlm9qPTya
YkMuRuprP4UtER+q9vglcsnNKmxjAPfVWY2cuLVRFnM4e/HbHErSPh/T6hbiJ939
Gv2zrX+ZgXxtw96KJbfjszqzkuZOEqHSKfzE5c5a+xqy0m167bVb+gxJBjPs1kzP
nctGfp02cr7x9UAJa23ePhi6O9NWeXcMj3YKxrOzQhuOqpgIYZKc86JLQKi+PC9N
KF9ZU5x4TOG3fTIn1iFba0ykHvJgI025Y3v4sptw5Zt6gLT4h4o=
=EPyl
-----END PGP SIGNATURE-----

--pyvw5k7cs3klgvb6--
