Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab0EOQn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 12:43:56 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S2NBu/4vcSmPEDR4MCr4"
Date: Sat, 15 May 2010 17:43:51 +0100
Message-ID: <1273941831.2564.29.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 0/4] V4L/DVB: Select correct frontends and tuners
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-S2NBu/4vcSmPEDR4MCr4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I found a few more drivers that don't select the same frontends and
tuners that they reference.

Ben.

Ben Hutchings (4):
  V4L/DVB: dw2102: Select tda10023 frontend, not tda10021
  V4L/DVB: budget: Select correct frontends
  V4L/DVB: dib0700: Select dib0090 frontend
  V4L/DVB: m920x: Select simple tuner

 drivers/media/dvb/dvb-usb/Kconfig |    4 +++-
 drivers/media/dvb/ttpci/Kconfig   |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)


--=-S2NBu/4vcSmPEDR4MCr4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS+7PQee/yOyVhhEJAQJO9Q//ZU9lq0IAUTmHakMGPjuzF41NhiWXcbvP
Io0HGOplnJCy3yML0NYxkHTs5wIvoQGV6waaOgLnoS+wSEYuYH4nkTdZ3ROQJDI1
6nQ5Yu3jWAOsqbjgPd+csJ1GvIKn4bKVv4jL1ZAmC+sSd4PvmgppkuRsfQuu+qFI
padAyqxE6IvHQNpssv6lIn7SlJ1IUO7PofDyyp+m8rgdHjdh1ECZ6YqUsoSJMBdB
AgIPXPNSwSXjALrsEWyGy7c6EcSupuxRCITqnF6Hwq6fntuouIu6BEHI5ka7keS0
uJwaLatyxEObNSi4/GhSEluxLypz4575afdH1zJpSM+wfYtCjn+Cwuql6OaSwT1K
AFQ9QB09MulAoKDnlcnGQc+XJhkmEBByzB09uozdMA48tBsnWVNkP66meTYuCIsf
kA7JtnZyIcHkeIN9dpdr3RRACCUakMdAmbs0D+Vqv5D3Wdj22ZAur11Zfyu3cZTW
zG37iv3H5B1LvVbMeb3BFMo8wYkFere/4YpdcBDCdlZ/K6x8v9pSdHQ5LQausiPa
rhR9DKeT5jkpts7H2iPSRVKX52EFpnTr9R+RbV6AKdcNm/C9olzg+CWtMDEJg2DN
faVREha7rq3M6sZxNGLfnxDebjf9ffzSXUnYWyST4ecEwei+nSwfRY760eczV6vH
lEqAg3kyFsg=
=zU7+
-----END PGP SIGNATURE-----

--=-S2NBu/4vcSmPEDR4MCr4--
