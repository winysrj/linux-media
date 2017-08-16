Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:57522 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdHPU62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 16:58:28 -0400
Date: Wed, 16 Aug 2017 22:58:26 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] i2c: add helpers to ease DMA handling
Message-ID: <20170816205825.zq5u7gqgyrcqptsb@ninjato>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
 <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
 <20170723122242.7fd0edf4@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iw76m45wyrc7u532"
Content-Disposition: inline
In-Reply-To: <20170723122242.7fd0edf4@jic23.retrosnub.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iw76m45wyrc7u532
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

> I like the basic idea of this patch set a lot btw!

Thanks!

> Jonathan

Could you delete irrelevant parts of the message, please? I nearly
missed your other comment which would have been a great loss!

> I'm trying to get my head around whether this is a sufficient set of cond=
itions
> for a dma safe buffer and I'm not sure it is.
>=20
> We go to a lot of effort with SPI buffers to ensure they are in their own=
 cache
> lines.  Do we not need to do the same here?  The issue would be the
> classic case of embedding a buffer inside a larger structure which is on
> the stack.  Need the magic of __cacheline_aligned to force it into it's
> own line for devices with dma-incoherent caches.
> DMA-API-HOWTO.txt (not read that for a while at it is a rather good
> at describing this stuff these days!)
>=20
> So that one is easy enough to check by checking if it is cache line align=
ed,
> but what do you do to know there is nothing much after it?

Thank you, really!

This patch series addressed all cases I have created, but I also
wondered if there are cases left which I missed. Now, also because you
mentioned cacheline alignments, the faint idea of "maybe it could be
fragile" became a strong "it is too fragile"! lib/dma-debug.c is >40KB
for a reason. I just rewrote this series...

> Not sure there is a way around this short of auditing i2c drivers to
> change any that do this.

=2E.. to do something like this, more precisely: an opt-in approach. I
introduce a new flag for i2c_msg, namely I2C_M_DMA_SAFE which can opt-in
DMA if we know the i2c_msg buffer is DMA safe. I finished a
proof-of-concept this evening and pushed it here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/topic/i=
2c-core-dma-rfc-v4

I will test it on HW tomorrow and send it out, then. There are still
some bits missing, but for getting opinions, it should be good enough.

Thanks and kind regards,

   Wolfram


--iw76m45wyrc7u532
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmUsfEACgkQFA3kzBSg
KbYvTA/9GfvNkpGoyhvY6GHFOWPKNXd8Z3pDbev1Kh9OZIV9fveLjRa8Sq20pdiI
o0YKCO4ljVL41BDXt/4GOHbONYjmrbPO6KequfqRhn/Eb1QZHgO5lpLuFkIqnSbW
oWecM6dZqzzhRHIteRKgUYw+d7CU7FdT7RFOZrRllRaPjxZ+fnbw+Mh/fWXapQlK
/Qz73224MOCDoQgmVqfGIlvwK4pAB6pv7rpV+Qu0S8TOI5NT/j3Ne/hFgMHDQj/E
fphOGr4/V9UKPAoz6KasbuUgAlqqN8qIs2MwOwLBB+qZV/odTJDvG7+JvH2rLIMe
QOGZwFxbTVnEllEdKgk056a7rFkSBVFA5jmmLKAPw8CtbNKvpYVKMYXPUih5ea4u
FNKl2bcxXawuVLyvmovfPzZOhRu85Cw6eS+MFsMZGK32XVL6fd6ZjX0YDhA6+wkt
BEtFQHLO1K1UCeEFtLmFn9f71pXOX+RZtGgKFuGzNSb9tDN540kanc1Oxpm4KEuz
jJv9FM9QWkUGFxT+yuRaX4AxXAQNBt46HiWjPNEbpf906Ef4ghf74vj+xM9UxuRQ
ABhKkOp5RIFYpUHJgnUfgdco36XIMLoF52aUP5+5OAYZ4msnGMy0sEcr3sHQ7Nlg
Y1zlV9yyesdPAI5soo126qDlFbEpIljXOoMKGk/G5oI5ANl3xD4=
=UtP7
-----END PGP SIGNATURE-----

--iw76m45wyrc7u532--
