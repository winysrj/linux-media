Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.neotion.com ([5.39.84.84]:54011 "EHLO mx1.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaLOJW6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 04:22:58 -0500
Received: from mail.neotion.com (21.55.7.109.rev.sfr.net [109.7.55.21])
	by mx1.neotion.com (Postfix) with ESMTPS id 73321732D4
	for <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 10:43:52 +0100 (CET)
Received: from smtp.neotion.int (unknown [10.140.2.203])
	by mail.neotion.com (Postfix) with ESMTP id 0EC3024D
	for <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 10:13:35 +0100 (CET)
Message-ID: <548EA630.3020801@neotion.com>
Date: Mon, 15 Dec 2014 10:13:20 +0100
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: libucsi: dvb_id_selector_byte_000b not needed for dvb_ip_mac_notification_info
 iteration
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wCBNlUxmWLHhw4FD1EbC65Va8OQ18nM2j"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wCBNlUxmWLHhw4FD1EbC65Va8OQ18nM2j
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

For the dvb_ip_mac_notification_info iteration, the field dvb_id_selector=
_byte_000b
is only needed in the first iteration.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 lib/libucsi/dvb/data_broadcast_id_descriptor.h |  1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/libucsi/dvb/data_broadcast_id_descriptor.h b/lib/libucsi=
/dvb/data_broadcast_id_descriptor.h
--- a/lib/libucsi/dvb/data_broadcast_id_descriptor.h
+++ b/lib/libucsi/dvb/data_broadcast_id_descriptor.h
@@ -201,7 +201,6 @@
 {
     uint8_t *end =3D (uint8_t *) d + d->platform_id_data_length;
     uint8_t *next =3D    (uint8_t *) pos +
-            sizeof(struct dvb_id_selector_byte_000b) +
             sizeof(struct dvb_ip_mac_notification_info);
=20
     if (next >=3D end)



--wCBNlUxmWLHhw4FD1EbC65Va8OQ18nM2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSOpjAACgkQb5rmahFm9IUimACeOjVGat+2KTvYfhkU5DF3m6Gy
9kAAoNFtSX23A0AW45YOe/lwpZl//sOr
=SeG8
-----END PGP SIGNATURE-----

--wCBNlUxmWLHhw4FD1EbC65Va8OQ18nM2j--
