Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40225 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdFQM7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 08:59:21 -0400
Date: Sat, 17 Jun 2017 14:59:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170617125919.GB13133@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
 <20170616124242.GA8145@amd>
 <20170616124526.GM15419@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20170616124526.GM15419@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is quite a lot of boilerplate for that. Would it make sense to
> > provide helper function at least for this?
>=20
> Yes. I've been thinking of having helper functions for notifiers and
> sub-notifiers. Most of the receiver drivers are implementing exactly the
> same thing but with different twists (read: bugs).

Perhaps something like this is a starting point?

									Pavel

commit 22d722b7ee7cb437ae2013fa83a215f91151621c
Author: Pavel <pavel@ucw.cz>
Date:   Sat Jun 17 14:14:08 2017 +0200

    Subdev support for et8ek8.
   =20
    Subdev code is ready for moving to some other place -- this is really
    common code.
   =20
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index 05b9bd9..a6899fc 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -32,13 +32,90 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
-#include <linux/v4l2-mediabus.h>
=20
+#include <media/v4l2-async.h>
+#include <linux/v4l2-mediabus.h>
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
=20
+static int simple_subdev_notifier_bound(struct v4l2_async_notifier *notifi=
er,
+                                       struct v4l2_subdev *sd,
+                                       struct v4l2_async_subdev *asd)
+{
+       return 0;
+}
+
+static int simple_subdev_notifier_complete(
+       struct v4l2_async_notifier *notifier)
+{
+       struct v4l2_async_notifier_simple *notifier_s =3D
+               container_of(notifier, struct v4l2_async_notifier_simple, n=
otifier);
+
+       return v4l2_device_register_subdev_nodes(notifier_s->v4l2_dev);
+}
+
+static inline int v4l2_simple_subnotifier_register(struct v4l2_subdev *sub=
dev,
+				     struct v4l2_async_notifier_simple *notifier_s)
+{
+	struct v4l2_async_notifier *notifier =3D &notifier_s->notifier;
+	int rval;
+	if (!notifier->num_subdevs)
+		return 0;
+
+	notifier_s->v4l2_dev =3D subdev->v4l2_dev;
+	notifier->bound =3D simple_subdev_notifier_bound;
+	notifier->complete =3D simple_subdev_notifier_complete;
+	rval =3D v4l2_async_subnotifier_register(subdev, notifier);
+	return rval;
+}
+
+static inline int simple_subdev_probe(struct device *dev,
+				      struct v4l2_async_notifier *notifier)
+{
+	static const char *props[] =3D { "flash", "lens", "eeprom" };
+	unsigned int i;
+	const int max_subdevs =3D 3;
+=09
+	notifier->subdevs =3D
+		devm_kcalloc(dev, max_subdevs,
+			     sizeof(struct v4l2_async_subdev *), GFP_KERNEL);
+	if (!notifier->subdevs)
+		return -ENOMEM;
+
+	for (i =3D 0; i < ARRAY_SIZE(props); i++) {
+		struct device_node *node;
+		unsigned int j =3D 0;
+
+		while ((node =3D of_parse_phandle(dev->of_node, props[i], j++))) {
+			struct v4l2_async_subdev **asd =3D
+                                &notifier->subdevs[
+                                        notifier->num_subdevs];
+
+			if (WARN_ON(notifier->num_subdevs >=3D max_subdevs)) {
+				of_node_put(node);
+				return 0;
+			}
+
+			*asd =3D devm_kzalloc(
+				dev, sizeof(struct v4l2_async_subdev),
+				GFP_KERNEL);
+			if (!*asd) {
+				of_node_put(node);
+				return 0;
+			}
+
+			(*asd)->match.fwnode.fwnode =3D of_fwnode_handle(node);
+			(*asd)->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
+			notifier->num_subdevs++;
+
+			of_node_put(node);
+		}
+	}
+	return 0;
+}
+
 #include "et8ek8_reg.h"
=20
 #define ET8EK8_NAME		"et8ek8"
@@ -67,6 +144,8 @@ struct et8ek8_sensor {
=20
 	struct mutex power_lock;
 	int power_count;
+
+	struct v4l2_async_notifier_simple notifier_s;
 };
=20
 #define to_et8ek8_sensor(sd)	container_of(sd, struct et8ek8_sensor, subdev)
@@ -1510,6 +1589,8 @@ et8ek8_registered(struct v4l2_subdev *subdev)
 		goto err_file;
 	}
=20
+	v4l2_simple_subnotifier_register(subdev, &sensor->notifier_s);
+=09
 	__et8ek8_get_pad_format(sensor, NULL, 0, V4L2_SUBDEV_FORMAT_ACTIVE);
=20
 	return 0;
@@ -1680,6 +1761,8 @@ static int et8ek8_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_entity;
=20
+	simple_subdev_probe(dev, &sensor->notifier_s.notifier);
+
 	dev_dbg(dev, "initialized!\n");
=20
 	return 0;
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index f7e2a1a..63bcf80 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -104,6 +104,11 @@ struct v4l2_async_notifier {
 		       struct v4l2_async_subdev *asd);
 };
=20
+struct v4l2_async_notifier_simple {
+	struct v4l2_async_notifier notifier;
+	struct v4l2_device * v4l2_dev;
+};
+
 /**
  * v4l2_async_notifier_register - registers a subdevice asynchronous subno=
tifier
  *


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllFJ6cACgkQMOfwapXb+vLfvQCeJrMg5QFfHq+zf4ihP8Jw56yX
H8sAoJd4ywuzzBHNM5i+rQ+/ivaNcg6e
=2LVg
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
