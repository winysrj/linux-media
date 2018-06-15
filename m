Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:55280 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755750AbeFOFIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 01:08:42 -0400
Date: Fri, 15 Jun 2018 14:08:30 +0900
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Message-ID: <20180615050829.n5siddzqxwfsv2ep@ninjato>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
 <843b1253-67ec-883f-9683-134528320791@axentia.se>
 <be2c81ed-c37a-c178-0c8e-7029474ff316@axentia.se>
 <20180614154139.eu7fznytzf4rkt4g@ninjato>
 <55f65c0d-662d-bd6a-67eb-84796fa5fa1b@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e43i4jofxzmk6jig"
Content-Disposition: inline
In-Reply-To: <55f65c0d-662d-bd6a-67eb-84796fa5fa1b@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--e43i4jofxzmk6jig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > It sounds tempting, yet I am concerned about regressions. From that
> > point of view, it is safer to introduce i2c_lock_segment() and convert =
the
> > users which would benefit from that. How many drivers would be affected?
>=20
> Right, there is also the aspect that changing a function like this
> might surprise people. Maybe i2c_lock_adapter should be killed and
> all callers changed to one of i2c_lock_segment and i2c_lock_root?

Yes, I like this one. It makes the change very clear to people.

> It's not that much churn...

OK, convinced. Are you willing/able to take on this? We are close to rc1
which would be a very good timing because a) linux-next should be almost
empty and b) we have nearly one cycle for linux-next and one cycle for
the rc-phase to get as much testing as possible. But also, there is no
actual need to rush...

This means for the original SCCB patch, it is independent of our
thoughts here. If SCCB gets in first, we will just convert it, too.

Thanks Peter!


--e43i4jofxzmk6jig
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsjScgACgkQFA3kzBSg
KbZN6BAAqXq4dhKLao+eVQHAzp38MYgMK2HVaQ2JRQxsYFe9PxWaLUNpwneMRpDM
rZ5zUQXV+rdziHAqP2TIHzVtHgaZ62TGT1eiq8ovkM/eQ1HIBkvdbZKhhV//0WnU
lsRA/hX0QjzeY80SwPFkbP7MztIFZLcUwuR495GZS1gRzLqx4qOw1cq14NpDMrXc
GcMPHYawdrRZDkC61zYcPQw0jRr4l7Mxq73Egz4spreZqzaANtClqcRkwVM64uyg
zSEa3mba4s57fwgT5n12zcbJTNJqwqE+nMFDdRuUqjmGY83kJz67GgCeryVppHmP
/8m0J+7EL73vhk6hENcKBrbhaLJpWlz1rl7SrRh7GCs+Aya0YHUL2orM8iOgX+by
jEtiDvUIsuM6xajNy1ygtXjiwHBXNjw7W0xgid2D65EbWoCMhui6PbYoh/1tiZ94
d8zi9boeg/KSOvXCY5IaiWoeOdwRwNc2Pfz0y6rq1CrC3z/l8Sw2bNXpFDI/l6aV
i9FEpgeySsLFsu0msUveuQWiHnC7TAoLt0NoZ5BeHja8J0YETl8uH0b00xsHOpB9
VjE7q33fDa6TvqgojhZmcM1By7Kl/XeLbypq+dLhMceZbCDQAfMHM49JhEVAv1E+
xQBhEan4T5nJG00AwOj1g3m+yfeWqS5ELlqRIEAcXYsC3I2tMCg=
=H6/G
-----END PGP SIGNATURE-----

--e43i4jofxzmk6jig--
