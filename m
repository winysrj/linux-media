Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48429 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1K1NIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 08:08:44 -0500
Date: Mon, 28 Nov 2011 16:08:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Huewe <peterhuewe@gmx.de>,
	Steven Toth <stoth@kernellabs.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] saa7164: fix endian conversion in
 saa7164_bus_set()
Message-ID: <20111128130852.GJ21128@mwanda>
References: <20111123070911.GA8561@elgon.mountain>
 <4ECFD56E.3040200@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Content-Disposition: inline
In-Reply-To: <4ECFD56E.3040200@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The msg->command field is 32 bits, and we should fill it with a call
to cpu_to_le32().  The current code is broke on big endian systems.
On little endian systems it truncates the 32 bit value to 16 bits
which probably still works fine.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Mauro pointed out that I missed the conversion back to cpu endian.

This is a static checker bug.  The current code is definitely broken on
big endian systems.  I'm pretty sure my fix is correct, but I don't
have the hardware to test it.

diff --git a/drivers/media/video/saa7164/saa7164-bus.c b/drivers/media/vide=
o/saa7164/saa7164-bus.c
index 466e1b0..a7f58a9 100644
--- a/drivers/media/video/saa7164/saa7164-bus.c
+++ b/drivers/media/video/saa7164/saa7164-bus.c
@@ -149,7 +149,7 @@ int saa7164_bus_set(struct saa7164_dev *dev, struct tmC=
omResInfo* msg,
 	saa7164_bus_verify(dev);
=20
 	msg->size =3D cpu_to_le16(msg->size);
-	msg->command =3D cpu_to_le16(msg->command);
+	msg->command =3D cpu_to_le32(msg->command);
 	msg->controlselector =3D cpu_to_le16(msg->controlselector);
=20
 	if (msg->size > dev->bus.m_wMaxReqSize) {
@@ -464,7 +464,7 @@ int saa7164_bus_get(struct saa7164_dev *dev, struct tmC=
omResInfo* msg,
=20
 peekout:
 	msg->size =3D le16_to_cpu(msg->size);
-	msg->command =3D le16_to_cpu(msg->command);
+	msg->command =3D le32_to_cpu(msg->command);
 	msg->controlselector =3D le16_to_cpu(msg->controlselector);
 	ret =3D SAA_OK;
 out:

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO04fkAAoJEOnZkXI/YHqRZeIP/Ajr7zhyA3sYflT6964H4Uam
s1E9pMEOXM0ZbDBAopeyTtnTOtpMv6KjBsDFA3WTARfiYSK0UsA+lrBx2rFXTsGw
Xw0GbWZZYadpwh1ISFnWEG2WrCwl7L/hI725LEytFAxL1NzTjTCA1+GjFKy64ynS
opmvA575AyeaP2qHxNFJCJ3/KpSjTGFZT0pJ6qkwPz4hHd2p/B0fR92briIEqAFq
HesngSuD2PNgAosEHvMtqNoHJlnZbDCN3pwSEae1tPHL5K36kfBR6WP8SVgtCOEi
Pzm67y4Gc+iL3FYyY6K9g4YqBDgJjO3Eps4sfiI37T/beQF5qV1Oe1nHLQGg1IMM
f82zSfHb34rhv1jUaa1xEAlzIMe2JfXR+6i7/BJ5OjhhAKUAlf/1OgFS5BzVeLkp
4/s8Qah+B+bq5bI5ju+cEWEasYPp/HS0nVgDDOA0XUAyuVpHcNdG1vEmXKcYZBfx
+FnREtaYg8PNl4YN2kREgNNjr+TG5ui8xahD/qXwzKjn5z80iB01DPWyJ1d1m6jg
L3RAc9hLg+1fv8uTfp81b2jxLvJW6fZUGIe4yKkXDD7Phz1GTfeZMHQOrFrnwZB5
0GF9qDR61nFOi+rjbP+9V/G+GkS3l6RbJHdpOjESXg7jgSJ2Ngt1AEeAjiZxTNkC
9cV2wEpXouPppXmo7+B2
=O/Kx
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
