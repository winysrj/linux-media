Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:46553 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2DCPda (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 11:33:30 -0400
Date: Tue, 3 Apr 2012 17:33:20 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
Message-ID: <20120403173320.2d3df3f8@milhouse>
In-Reply-To: <4F7B1624.8020401@iki.fi>
References: <20120403110503.392c8432@milhouse>
	<4F7B1624.8020401@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wj9_KSHQIg__Z17Ntu_tVX4"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/wj9_KSHQIg__Z17Ntu_tVX4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Apr 2012 18:24:20 +0300
Antti Palosaari <crope@iki.fi> wrote:

> On 03.04.2012 12:05, Michael B=C3=BCsch wrote:
> > Now that i2c transfers are fixed, 3 retries are enough.
> >
> > Signed-off-by: Michael Buesch<m@bues.ch>
>=20
> Applied, thanks!
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_e=
xperimental
>=20
> I think I will update original af9035 PULL request soon for the same=20
> level as af9035_experimental is currently.

That's great. The driver really works well for me.

On another thing:
The af9035 driver doesn't look multi-device safe. There are lots of static
variables around that keep device state. So it looks like this will
blow up if multiple devices are present in the system. Unlikely, but still.=
.. .
Are there any plans to fix this up?
If not, I'll probably take a look at this. But don't hold your breath.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/wj9_KSHQIg__Z17Ntu_tVX4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPexhAAAoJEPUyvh2QjYsOwvkP/ieEs7biaeP/BC982W2JQkMG
HfKqJJahnnOaGmRRjrOUrbzQT9R2G7YeV5aKKuFjhZrTmXhKfTrFqYRrMoe0htdQ
oCFoVAr6GSZaRo2ZjpvdxpBnR4YEdN+hPmflKH+jp11ruLbektFQZL49dcp/ovbR
5we/hN7w9eV2YAtjGCun3A1IZzoooODLklPC7uMCd+ZtZMoCh/zgps+vMm6QxK0P
3WKUj6GooX67I8z3DValUOljcgjLsGXebGSfPD580fogkel1jqcAnFE90V7QvAbZ
NzEqvCBl/PbAgGiiNYF9YSwUk3VDIKktF907pLSydCMxvaP0N9O4aC/MvJ0sP+1k
0SDkPCEPxdDJpPo5vMS87u6OQdmhRP/s+FQPpKM6ArxvMu8gWQb8T+ADFn1QLbB7
CB9aeGxo2vVhIszsiNwUPV6AkmXhczGUoW1T4MPbEgCgrIw3XG3vTVg1S/XMBUlE
+Ke2Xc4aD6S+lDDtac4jb/KmUWDIfzfYuRT8q2Uw6arQgGPxyuchlly9IBcdyVTf
4XPmGuPrlynwl+GvPr755TeWWT90JADxK/FFkNJ460ihNyVtPujO6k804gLMGZKb
g6xw0f3AXO26SYxrPcJt94ppHcPHGkN8j9mKAS4Dp0SkB8Du6NMH9Y1ZUkb+5ZD2
YRwYzX63qLqFBJ8zpM5W
=AFfu
-----END PGP SIGNATURE-----

--Sig_/wj9_KSHQIg__Z17Ntu_tVX4--
