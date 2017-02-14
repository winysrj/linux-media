Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44784 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdBNWiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:38:51 -0500
Date: Tue, 14 Feb 2017 23:38:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Reichel <sre@kernel.org>

If v4l2_device_register_subdev_nodes() is called multiple times, it is
better to return early than corrupt memory.

Without this, exposure / gain controls do not work in the camera
application on N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/v4l2-core/v4l2-device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-cor=
e/v4l2-device.c
index f364cc1..937c6de 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -235,6 +235,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_devic=
e *v4l2_dev)
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
 			continue;
=20
+		if (sd->devnode)
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

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijhvkACgkQMOfwapXb+vKp2QCfV599CsYEI5XIXVbZXcy5UYt+
DJoAniECdmpwd0U/HUVhmRr70d0LPd//
=/wu+
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
