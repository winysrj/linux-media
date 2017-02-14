Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59097 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753972AbdBNNkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:03 -0500
Date: Tue, 14 Feb 2017 14:40:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 07/13] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170214134000.GA8550@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Reichel <sre@kernel.org>

Without this, exposure / gain controls do not work in the camera applicatio=
n.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/v4l2-core/v4l2-device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-cor=
e/v4l2-device.c
index f364cc1..b3afbe8 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -235,6 +235,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_devic=
e *v4l2_dev)
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
 			continue;
=20
+		if(sd->devnode)
+			continue;
+
 		vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
 		if (!vdev) {
 			err =3D -ENOMEM;
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlijCLAACgkQMOfwapXb+vJWdwCXZ3sY0dJFQk9BNu57G4+GbPvU
qgCeIseO/NVgeifDbK6BwVR+4rumhh0=
=JTKX
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
