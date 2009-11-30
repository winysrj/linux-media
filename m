Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.uniroma2.it ([160.80.6.16]:40580 "EHLO smtp.uniroma2.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZK3T3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 14:29:51 -0500
Received: from lists.uniroma2.it (lists.uniroma2.it [160.80.1.182])
	by smtp.uniroma2.it (8.13.6/8.13.6) with ESMTP id nAUKCWgQ028532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 30 Nov 2009 21:12:34 +0100
Received: from apple-juice.homenet.telecomitalia.it (host21-215-dynamic.18-79-r.retail.telecomitalia.it [79.18.215.21])
	(authenticated bits=0)
	by lists.uniroma2.it (8.13.1/8.13.1) with ESMTP id nAUJEZwq002687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 30 Nov 2009 20:14:35 +0100
Message-ID: <4B14195D.6000205@autistici.org>
Date: Mon, 30 Nov 2009 20:13:33 +0100
From: "OrazioPirataDelloSpazio (Lorenzo)" <ziducaixao@autistici.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DIY Satellite Web Radio
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4ED987A93660AF70DBAFC6D7"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4ED987A93660AF70DBAFC6D7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi all,
I'm not a DVB expert but I'm wondering if this idea is feasible:
For an "amateur" web radio, for what I know, it is really hard to
being listened in cars, like people do with commercial satellite radio
[1] . Basically this is unaffortable for private user and this is
probably the most relevant factor that penalize web radios againt
terrestrial one.

My question is: is there any way to use the current, cheap, satellite
internet connections to stream some data above all the coverage of a geo
satellite? and make the receiver handy (so without any dishes) ?

Probably by introducing some _very_ redundant code inside the stream
that we upload through the modem and that the satellite will stream from
the sky, we can get some S/N db. The patch to do at the receiver is just
software or maybe hardware?




Lorenzo


[1] http://www.xmradio.com/



--------------enig4ED987A93660AF70DBAFC6D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLFBlhAAoJEBuiD2h8GyB+or4H/0J5Czv7D3kDNH3jVpraPXeT
3IDeKdCyxwA8K/fiRBOYIMr7UUtijVxR4q23qUzI4mqcZfEyMrTOuAV5OUomt1ki
6Wd9z5YlnvR2CGxWfFKYWt7Ri6pRSFkPHT/L5H0V0l6s3q3zpqvlb2VSGBIIGlos
ZXk95+IEL/hledbXClgBffmzjf6Yk2JTjk1Q33eekLcwJ5fLjJ7fFJ17Uc1LwWTe
P3BOPH4jdqj7fk5fT7L3U2sprrKKSAu0Vj6jpvrjv9YBVdY3gy1XZAKZZp0P8NvK
1qAL4O7MiPwioXGk+YV8MnZ15ZX23EFnp9jOPYI/+3EGUg4qFeOqV9D+BjY0Umc=
=OB3k
-----END PGP SIGNATURE-----

--------------enig4ED987A93660AF70DBAFC6D7--
