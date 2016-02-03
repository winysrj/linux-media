Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:59047 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbcBCOXa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 09:23:30 -0500
Date: Wed, 3 Feb 2016 15:23:24 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160203142323.GA8620@tetsubishi>
References: <56B204CB.60602@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <56B204CB.60602@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for reporting the issue!

> Not filling the OMAP I2C driver's runtime PM callbacks does not help eith=
er.
>=20
> Any hints about the proper way to fix this issue?

Can the I2C device be en-/disabled in some way? Which board is this
happening with? Any specs for it publicly available?

Regards,

   Wolfram


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWsg1bAAoJEBQN5MwUoCm2X6kQAImG58xwqBPFOCNd0o+b1AND
I6ACswtwwqQJjaHk5QQjLTX+Q6jCFPGLeNG8W+i5znhJ94V6/fQLhN5sGTuIuHGW
jjJNdk1w6+8HczL5X6/ieNZ7LdNT9bJCA0FLU7lWSQIqwdR1ufSWpZsqthDNFfSZ
xF7Za4qOSdux7L89FjGN3rqFcT5T6bkCjxnjC0u6Zzer5ZYbwZ7k34yUjYyyakll
aZP1dtDi5CPTSiry8Auez7Gdww7v3dw0aKwAOADpov2SLeGhtaLCZdZg4OPdET2Y
8kJFR8iSbECeNh+4v9QxN/XYYAcL0j/CLI0ZEuL9ApF1X+kaLcxuHHTemXdQ50lB
Ulrw54ADoZdInCDChvIeyrMzX4xZRPsy7DxoQWDPGc1KJeEWPtSNPVxbew45y7Ai
zxWMbdLL08lxzryzfQqYdfjiK/xBNNuyOFNpuQk2WwKLtnt+cPtgY1aXwC7DD13S
ma/uusQ9Y/Mbwqspl8apVWH9Cc/mIpQZ1Lt5ubQgWcs1tyEuOhXGEcwTA5eDQvlb
fT6PCLoLnsy9sIOJGQFsU9rZIlgsyRNQDDJqzEu8ie4iS/2xv35Szb8RI1BZD2jE
/Z8HsX+2F5ORXWMzXpqw56/XY6/ci3iiU7wPG1vd7ICVLEUvKYWIyeqntTF95qDu
D7/K7b8iRSdpp+PVIDHC
=jbFB
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
