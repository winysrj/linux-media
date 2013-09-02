Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60558 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816Ab3IBAhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 20:37:10 -0400
Message-ID: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 0/4] [media] Make lirc_bt829 a well-behaved PCI driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 01:36:53 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jON0BMZo7RRwBgH+WK96"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jON0BMZo7RRwBgH+WK96
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed lirc_bt829 didn't have a module device ID table, so I set out
to fix that and ended up with this series.

It still appears to do everything else wrong (like reinventing
i2c-algo-bit) though...

This is compile-tested only.

Ben.

Ben Hutchings (4):
  [media] lirc_bt829: Make it a proper PCI driver
  [media] lirc_bt829: Fix physical address type
  [media] lirc_bt829: Fix iomap leak
  [media] lirc_bt829: Enable and disable memory BAR

 drivers/staging/media/lirc/lirc_bt829.c | 286 +++++++++++++++++-----------=
----
 1 file changed, 154 insertions(+), 132 deletions(-)



--=-jON0BMZo7RRwBgH+WK96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPdpee/yOyVhhEJAQq2zw/7BP6DDZCo3elSc0epMvX3asM1J3uoEZGl
OH2b4Yu5KQs14X4wUzfFk6E9ctv+46MV28WY6W61bGKcQbkDccWs7IiiZa4NBk0B
r1cdYxZv3Ye1c/ZymTXsmXRQQR3lqGAuHgYJJy0pCciW0aLqWCkSZiaEiSMZ9fP8
XUIWiImr5GWU/IZcMUeY0TnWE9KkS63mR+V6WZCC93pjZ3NBY+G34VU7olZpzwGq
r3o/MI1h6ZQmV4U/lhuxZ1mJ6M4gHdrnwTOMzTQEkEwIx3QR02v2SYq204+9brGI
s8IwDKmqNYyWp34ZKWt1OAaT8h4h9bvon/3a/4ht64vrB4O/R4t/HsxDpiIvhhIr
oHnUsL2doEC8n12Y7XHTAHWEIoTzy7CJ+hFuRKqEDhGyMRc1aoyHd5Vxduc9riOD
PMB2wUoXVYjsjvRv7o65o//ubl+4MP3oU38j2sxtaOAiC4V4OdgBTAaY899jX80Z
obfUKTaeSoLAVu2GIYipXMOqhVGTUiRmlaNlkJRfSEDQNfkfuxq6OyQ1xQdLcovb
5oiV42DCrwDG60gyTh0xJMEeTXpjaK+axr939h7168FArTZSGC8lb++eE4J4/HAZ
cTWANJCEGHkHd9qlQdjiBjVUWuMBrTFIKj/EpUWwDxuDT9oS/I4sFghzZGoDZUks
KVf2t8P6GCw=
=2cmm
-----END PGP SIGNATURE-----

--=-jON0BMZo7RRwBgH+WK96--
