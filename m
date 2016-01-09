Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:41148 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbcAINTS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 08:19:18 -0500
Date: Sat, 9 Jan 2016 14:19:15 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] soc_camera: cleanup control device on async_unbind
Message-ID: <20160109131915.GB1520@katana>
References: <1451911723-10868-1-git-send-email-wsa@the-dreams.de>
 <Pine.LNX.4.64.1601091226440.15612@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1601091226440.15612@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> this? Until then I'll just push this for the forthcoming 4.5.

Come to think of it: I don't have the setup to test this, and the people
which have that are hopefully off for the weekend. Since 4.4 is to be
released on Sunday anyhow, 4.5 sounds just fine to me.


--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWkQjTAAoJEBQN5MwUoCm2w8gP/RLLOLroBEqcHgRoevmTnujn
OIk6PkAuwbm+fYgOfE06DSZks6Lc+GAWIaRsp/wW7UCa3MaGcf3I6Izmu5OAMaMm
lJxI6Vqu4hbbckDd/cTpBRz9rOoyIZMeSNJd7qamTo0bVwey3Hovp7dAoen09VoL
2IiQ2SLxEclpE6KwCYEF6iJez9uNdSJAjqCXDIW9BikNlX3K779P5/g2qze5ioU1
rHqH/vakc7n+glziigWt3KowENVtW1nujQWdKMqKxuAnNr1o+ATGm78cnWDZn+M7
VcKQyCFTQDnGSeAtxa/Gupc5G7WK0sJzIAUVXp4g0i42nQTGgIa6Y5Ef8JTd5BBS
1tDs+HfVRkUdQxnltWhjVNaZim8jKTVmUwui+PAfToWFh3j4LdXLsynbRCSZIsEz
xIDRWscu7m8NR74vprgG/69afZWW8JPzJVSppjVH9jKo0j9RU511+9njkwvWXbCL
jfg//sdxmaUye+BdTOyWWC2CnA65+0CJJHVxMYWzh3QutjpOvIyP7eN/aY6bLqkD
49WsY/GAYX+szI0Jwipq25oXVnytVGJhPpMwL0VQVIoY0D2/V/OIyO5SfA99zItz
HWXEsxnJ0DIz/GeaoIymflmvamMzi2it6E6G66ULRE1DYxPdrZG4UU5kdC0qLSGM
GhEvHbt8nai0wtlCd3ih
=AquR
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
