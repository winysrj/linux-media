Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42443 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbdIIVr1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 17:47:27 -0400
Date: Sat, 9 Sep 2017 23:47:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: [RFC] et8ek8: Add support for flash and lens devices
Message-ID: <20170909214724.GA18677@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-18-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-18-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Parse async sub-devices by using
v4l2_subdev_fwnode_reference_parse_sensor_common().

These types devices aren't directly related to the sensor, but are
nevertheless handled by the et8ek8 driver due to the relationship of these
component to the main part of the camera module --- the sensor.

Signed-off-by: Pavel Machek <pavel@ucw.cz> # Not yet ready -- broken whites=
pace

---

Whitespace is horribly bad. But otherwise... does it look ok?


diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index c14f0fd..7714d2c 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -34,10 +34,12 @@
 #include <linux/sort.h>
 #include <linux/v4l2-mediabus.h>
=20
+#include <media/v4l2-async.h>
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-fwnode.h>
=20
 #include "et8ek8_reg.h"
=20
@@ -46,6 +48,7 @@
 #define ET8EK8_MAX_MSG		8
=20
 struct et8ek8_sensor {
+	struct v4l2_async_notifier notifier;
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
 	struct v4l2_mbus_framefmt format;
@@ -1446,6 +1449,11 @@ static int et8ek8_probe(struct i2c_client *client,
 	sensor->subdev.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sensor->subdev.internal_ops =3D &et8ek8_internal_ops;
=20
+	ret =3D v4l2_fwnode_reference_parse_sensor_common(
+                &client->dev, &sensor->notifier);
+        if (ret < 0 && ret !=3D -ENOENT)
+                return ret;
+
 	sensor->pad.flags =3D MEDIA_PAD_FL_SOURCE;
 	ret =3D media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
 	if (ret < 0) {
@@ -1453,14 +1461,21 @@ static int et8ek8_probe(struct i2c_client *client,
 		goto err_mutex;
 	}
=20
+        ret =3D v4l2_async_subdev_notifier_register(&sensor->subdev,
+						  &sensor->notifier);
+	if (ret)
+		goto err_entity;
+
 	ret =3D v4l2_async_register_subdev(&sensor->subdev);
 	if (ret < 0)
-		goto err_entity;
+		goto err_async;
=20
 	dev_dbg(dev, "initialized!\n");
=20
 	return 0;
=20
+err_async:
+	v4l2_async_notifier_unregister(&sensor->notifier);
 err_entity:
 	media_entity_cleanup(&sensor->subdev.entity);
 err_mutex:
@@ -1480,6 +1495,7 @@ static int __exit et8ek8_remove(struct i2c_client *cl=
ient)
 	}
=20
 	v4l2_device_unregister_subdev(&sensor->subdev);
+	v4l2_async_notifier_unregister(&sensor->notifier);
 	device_remove_file(&client->dev, &dev_attr_priv_mem);
 	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
 	v4l2_async_unregister_subdev(&sensor->subdev);


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm0YWwACgkQMOfwapXb+vI5LwCdGGZ6Fws0gfHlx+JaebUPe+6k
OOgAn3PCwf7UwIUZyYg/oUjHeQtmnHYT
=4xH7
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
