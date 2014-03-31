Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:15819 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753419AbaCaJzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 05:55:12 -0400
Message-ID: <53393B73.3010405@imgtec.com>
Date: Mon, 31 Mar 2014 10:54:59 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 03/11] rc-core: document the protocol type
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161100.13234.82892.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329161100.13234.82892.stgit@zeus.muc.hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UP4hsVl9Xm43u42mKQBa8ibHRE0ih4vlw"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--UP4hsVl9Xm43u42mKQBa8ibHRE0ih4vlw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29/03/14 16:11, David H=C3=A4rdeman wrote:
> Right now the protocol information is not preserved, rc-core gets hande=
d a
> scancode but has no idea which protocol it corresponds to.
>=20
> This patch (which required reading through the source/keymap for all dr=
ivers,
> not fun) makes the protocol information explicit which is important
> documentation and makes it easier to e.g. support multiple protocols wi=
th one
> decoder (think rc5 and rc-streamzap). The information isn't used yet so=
 there
> should be no functional changes.
>=20
> Signed-off-by: David H=C3=A4rdeman <david@hardeman.nu>

Good stuff. I very much approve of the concept, and had considered doing
the same thing myself.

Cheers
James


--UP4hsVl9Xm43u42mKQBa8ibHRE0ih4vlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOTtzAAoJEGwLaZPeOHZ6fbsQALOBdufqH3JMvI01UN5tivx+
IWnd4MDGhM8GIGJroWmBIM5Fer3DtOtyJipAKoB+uFE2evlU2Ol5GxGrxm75ZflA
anRC5zFWyF6VEMrHZ8Sc/0c7JWZIBYnhcXg6fY5THBevCVhqY/o2vEFF3CR3tA8j
YFfiW6ns18YpsR1w9bqi4qp8+Ti9ykhYW+5XH9BvEghOwSYOUyRa1HZWuKIfJObl
0Lc52mYxnqsl+vVFVbPGiHgUqpTooVzHTtKUnhAq9LLdvSeJwq1iG/1VFuY8C+qb
3l4EkzvcvPOOnifGA2bD0HMpLblhZTqNKe6BLYmVwlorynE456dSSXrdv32ReAED
T2nZhQ3lfLS1noEfz7CNcdoRjs8IFT75cm2TkqXWbuFiBjLNmeJiQ6seAHhNGYDW
q9dwJfg5NhVC5Q9p/VgtLC4a2fB4iMLeQdoCkohpfwEPA5RePssxurZY3BgDAAJE
HG4mC56ZCSBCPCesNwMrbVwS91ApeHeZDpS1I2q6YTamtBEs5n98Wf4GCO9yhkdI
Ka1jrWhcqqk8mDX/CJS5bIrcYoor3fKkWAvVWn9KHTZBbPvXCQCdk20mgad+dQ0I
Q+wcNpPHtT2F98eDHdi8FKW8rlf6PzXpIlYY3YCzreX16KbW7swkS5zl/jIc5c9s
TxXS/h27SzYekag0n2Ec
=JYdm
-----END PGP SIGNATURE-----

--UP4hsVl9Xm43u42mKQBa8ibHRE0ih4vlw--
