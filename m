Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59152 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbdBNNkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:45 -0500
Date: Tue, 14 Feb 2017 14:40:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 13/13] adp1653: add subdevs
Message-ID: <20170214134033.GA8674@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Needed for number of camera devices to match and fcam-dev to work.
---
 drivers/media/i2c/adp1653.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index ba1ec4a..b3d8e60 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -497,11 +497,13 @@ static int adp1653_probe(struct i2c_client *client,
 		flash->platform_data =3D client->dev.platform_data;
 	}
=20
+	dev_info(&client->dev, "adp1653 probe: subdev\n");=09
 	mutex_init(&flash->power_lock);
=20
 	v4l2_i2c_subdev_init(&flash->subdev, client, &adp1653_ops);
 	flash->subdev.internal_ops =3D &adp1653_internal_ops;
 	flash->subdev.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strcpy(flash->subdev.name, "adp1653 flash");
=20
 	ret =3D adp1653_init_controls(flash);
 	if (ret)
@@ -509,12 +511,21 @@ static int adp1653_probe(struct i2c_client *client,
=20
 	ret =3D media_entity_pads_init(&flash->subdev.entity, 0, NULL);
 	if (ret < 0)
-		goto free_and_quit;
+		goto free_pads;
+
+	dev_info(&client->dev, "adp1653 probe: should be ok\n");
+
+	ret =3D v4l2_async_register_subdev(&flash->subdev);
+	if (ret < 0)
+		goto free_pads;
+
+	dev_info(&client->dev, "adp1653 probe: async register subdev ok\n");=09
=20
 	flash->subdev.entity.function =3D MEDIA_ENT_F_FLASH;
=20
 	return 0;
-
+free_pads:
+	media_entity_cleanup(&flash->subdev.entity);
 free_and_quit:
 	dev_err(&client->dev, "adp1653: failed to register device\n");
 	v4l2_ctrl_handler_free(&flash->ctrls);
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCNEACgkQMOfwapXb+vJ1vQCfbUpp5vhchNqjgvHX/B5AJtl9
5D4AoLzUxBEUID4g9fVK/Ibt3eERAkUy
=N6Dq
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
