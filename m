Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:45228 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732205AbeGJVRw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 17:17:52 -0400
Date: Tue, 10 Jul 2018 22:59:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 2/2] media: ov772x: use SCCB helpers
Message-ID: <20180710205919.xu6yizd2k7f65shp@ninjato>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com>
 <20180709161443.ubxu4el6bp6zgerj@ninjato>
 <20180709212306.47xsduu3b5qpq72h@earth.universe>
 <CAC5umyhOsyYZqdgkZDuBwwWUwAHi2y_dizRr=hy8WRfpAr5UGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="73r6hmqqtwkouwdr"
Content-Disposition: inline
In-Reply-To: <CAC5umyhOsyYZqdgkZDuBwwWUwAHi2y_dizRr=hy8WRfpAr5UGA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--73r6hmqqtwkouwdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I think it would be even better to introduce a SSCB regmap layer
> > and use that.
>=20
> I'm fine with introducing a SCCB regmap layer.

I am fine with this approach, too.

> But do we need to provide both a SCCB regmap and these SCCB helpers?

I don't know much about the OV sensor drivers. I'd think they would
benefit from regmap, so a-kind-of enforced conversion to regmap doesn't
sound too bad to me.

> If we have a regmap_init_sccb(), I feel these three SCCB helper functions
> don't need to be exported anymore.

Might be true. But other media guys are probably in a better position to
comment on this?

Note that I found SCCB devices with 16 bit regs: ov2659 & ov 2685. I
think we can cover those with SMBus word accesses. regmap is probably
also the cleanest way to hide this detail?


--73r6hmqqtwkouwdr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltFHiMACgkQFA3kzBSg
KbaQwg//Ymmw7qH90Lr7/yQ6e/fNn8TjbNatI1mavKiPDykp2tYy6xkhuiW65eft
m1klKM8rZAkihXDSSA9FLouvEPTh2nUNOqLgqGbAfFuEz2CwHUTi6PW8SOhTCacc
DNfaLRHHYfwhyPKoCmSJs6hqCTO69ISJQQ8WeYanCN8ogG/wdNmzEfKt+qvloMTR
DhCEi9emgycoPMOvvXG23R7QfwC1T+Y9irwD9XFt+qyuIYIrCGpR2e7tPiyqhSvx
OvT8sDx2ZhQi7qp+CF5vU7h9CsoiTIJDbECZzxWzkMvI5JRb8WPpE1BN3JGiEScY
4jDrYIutH2TpXNYzWlvUH3y/oZyXosJQxbN4xwBe8q8Auw7Sfz0HrxwRWYM248dc
CujWxG02GRg+dlahnfSU/9As1d5IZLtYIJDCZ8G9VlnKVqbjP07IL2+he59cUK7U
ofyppRjjRl8++NoehFZlwT7ef6t6PS1La+kTVKNahAyAuD5Gj7LshyhynhvPa6q7
qTlID5uwkh0nVcOWDd2qC0tdNmJcf8IwjWuXR5lWqnmU1x8NxLOU9t21D481m5k8
kJF1VfeoY/jRdb1JxaZ6+JuqfTaAY2cy2DEE9KkjuCl1TROu4UREsY8stsrQuafP
RLiIFHqu7GrL+QvZ1ipypxH4oJJUrfQYXddXIvLHO4Rc5N9rQ+4=
=2SID
-----END PGP SIGNATURE-----

--73r6hmqqtwkouwdr--
