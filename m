Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41532 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933176AbeGJMHt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 08:07:49 -0400
Date: Tue, 10 Jul 2018 14:07:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 1/2] i2c: add SCCB helpers
Message-ID: <20180710120747.s7yg36moaw2xsrim@tetsubishi>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-2-git-send-email-akinobu.mita@gmail.com>
 <5320256.KVvq6sUnyz@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="feyllrxhbs727mq5"
Content-Disposition: inline
In-Reply-To: <5320256.KVvq6sUnyz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--feyllrxhbs727mq5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +static inline int sccb_read_byte(struct i2c_client *client, u8 addr)
> > +{
> > +	int ret;
> > +	union i2c_smbus_data data;
> > +
> > +	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);
> > +
> > +	ret =3D __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> > +				I2C_SMBUS_WRITE, addr, I2C_SMBUS_BYTE, NULL);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret =3D __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> > +				I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &data);
> > +out:
> > +	i2c_unlock_bus(client->adapter, I2C_LOCK_SEGMENT);
> > +
> > +	return ret < 0 ? ret : data.byte;
> > +}
>=20
> I think I mentioned in a previous review of this patch that the function =
is=20
> too big to be a static inline. It should instead be moved to a .c file.

Can be argued. I assume just removing the 'inline' won't do it for you?
I'd be fine with that, there are not many SCCB useres out there...

But if you insist on drivers/i2c/i2c-sccb.c, then it should be a
seperate module, I'd think?


--feyllrxhbs727mq5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltEoZIACgkQFA3kzBSg
KbYdCQ//fi+qF0ElPC36XKuPG0juD6i4a++LKe7G3yFlbql1rBOrvpTYHpOveWFN
K+V/I1n7X6uCm+XrIpGp1o/RZZdv50ZPnZJGMCdqCjJygbhFU+BMmW6B3vZeD3Vi
FEzgnobIjRodU1Umty5nywx4IdCGcKe6VGQ3bqJKRFdN1XiozaExLaf30uT6YBan
Qwv24P9ZxMPdJDWKq9vMriS2cAs5/o/P2Qvt+U5rTBZIFqugNSVQaDoemwL1tvmu
2Ainmm4Jrb2p1h9dnWKCjqA05CVmTf1GTG+JcrqvW6plBmYpbUMH4TGyO6Kf1ARW
4h2RXjFviR59fSQqIz/nhjS7krHeSAZhvBshyf7P3dzCJTayKhAU+Q4tB4/8BsVK
ucKXPHxAjVvB3w1AWy3F/nJxYWbGs7p4Pzs0U2P9qSeMhQUujLUEWaBbAyWtSz2k
Zz1Vz7aAfJogCWdfXa+bgQvTPXdCDs2AEA2g6cLQtwVXenGCsmblpkXTrgNlk0G2
g4aKDE3ZtpsyCZ1jSCM//5lzSWBjcp6XlbjU0yr+DGY4Ehe3o2Vn5ZL7XWLlpUfe
tzx5fIna4IStQ9T46pwyOOHfXcBjOfj9Tso8e5eyHpXoM6RiJr+KZlIsnCLV4jLt
pmuAT4CTaE/Pf4lqO4FWoZc2rWtKmXwn/5iMQJDYc9oiVLNTwuY=
=ADbk
-----END PGP SIGNATURE-----

--feyllrxhbs727mq5--
