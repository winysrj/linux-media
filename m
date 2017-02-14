Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59086 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdBNNjz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:39:55 -0500
Date: Tue, 14 Feb 2017 14:39:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 05/13] omap3isp: Add subdevices support
Message-ID: <20170214133951.GA8510@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Add subdevices support to omap3isp. It is neccessary for connecting
subdevices (camera flash and autofocus coil) for N900 camera subsystem.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/omap3isp/isp.c       | 128 ++++++++++++++++++++++--=
----
 drivers/media/platform/omap3isp/isp.h       |   1 +
 drivers/media/platform/omap3isp/ispcsiphy.c |   2 +-
 3 files changed, 102 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 61b7359..edc4300 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -42,6 +42,8 @@
  * published by the Free Software Foundation.
  */
=20
+#define DEBUG
+
 #include <asm/cacheflush.h>
=20
 #include <linux/clk.h>
@@ -699,7 +701,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pip=
e,
 	spin_unlock_irqrestore(&pipe->lock, flags);
=20
 	pipe->do_propagation =3D false;
-
+=09
 	entity =3D &pipe->output->video.entity;
 	while (1) {
 		pad =3D &entity->pads[0];
@@ -2059,7 +2061,7 @@ void __isp_of_parse_node_csi1(struct device *dev,
=20
 	buscfg->vp_clk_pol =3D 1;
 }
-
+=09
 static void isp_of_parse_node_csi1(struct device *dev,
 				   struct isp_bus_cfg *buscfg,
 				   struct v4l2_of_endpoint *vep)
@@ -2106,9 +2108,7 @@ static void isp_of_parse_node_csi2(struct device *dev,
 	buscfg->bus.csi2.crc =3D 1;
 }
=20
-static int isp_endpoint_to_buscfg(struct device *dev,
-				  struct v4l2_of_endpoint vep,
-				  struct isp_bus_cfg *buscfg)
+static int isp_endpoint_to_buscfg(struct device *dev, struct v4l2_of_endpo=
int vep, struct isp_bus_cfg *buscfg)
 {
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
@@ -2170,10 +2170,51 @@ static int isp_of_parse_node_endpoint(struct device=
 *dev,
 	return 0;
 }
=20
+static int isp_of_parse_node(struct device *dev, struct device_node *node,
+			     struct v4l2_async_notifier *notifier,
+			     u32 group_id, bool link)
+{
+	struct isp_async_subdev *isd;
+
+	isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+	if (!isd) {
+		of_node_put(node);
+		return -ENOMEM;
+	}
+
+	notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
+
+	if (link) {
+		if (isp_of_parse_node_endpoint(dev, node, isd)) {
+			of_node_put(node);
+			return -EINVAL;
+		}
+
+		isd->asd.match.of.node =3D of_graph_get_remote_port_parent(node);
+		of_node_put(node);
+	} else {
+		isd->asd.match.of.node =3D node;
+	}
+
+	if (!isd->asd.match.of.node) {
+		dev_warn(dev, "bad remote port parent\n");
+		return -EINVAL;
+	}
+
+	isd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
+	isd->group_id =3D group_id;
+	notifier->num_subdevs++;
+
+	return 0;
+}
+
 static int isp_of_parse_nodes(struct device *dev,
 			      struct v4l2_async_notifier *notifier)
 {
 	struct device_node *node =3D NULL;
+	int ret;
+	unsigned int flash =3D 0;
+	u32 group_id =3D 0;
=20
 	notifier->subdevs =3D devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2182,32 +2223,60 @@ static int isp_of_parse_nodes(struct device *dev,
=20
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
 	       (node =3D of_graph_get_next_endpoint(dev->of_node, node))) {
-		struct isp_async_subdev *isd;
+		ret =3D isp_of_parse_node(dev, node, notifier, group_id++, true);
+		if (ret)
+			return ret;
+	}
=20
-		isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
-		if (!isd)
-			goto error;
+	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
+	       (node =3D of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					flash++))) {
+		struct device_node *sensor_node =3D
+			of_parse_phandle(dev->of_node, "ti,camera-flashes",
+					 flash++);
+		unsigned int i;
+		u32 flash_group_id;
=20
-		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
+		if (!sensor_node)
+			return -EINVAL;
=20
-		if (isp_of_parse_node_endpoint(dev, node, isd))
-			goto error;
+		for (i =3D 0; i < notifier->num_subdevs; i++) {
+			struct isp_async_subdev *isd =3D container_of(
+				notifier->subdevs[i], struct isp_async_subdev,
+				asd);
=20
-		isd->asd.match.of.node =3D of_graph_get_remote_port_parent(node);
-		if (!isd->asd.match.of.node) {
-			dev_warn(dev, "bad remote port parent\n");
-			goto error;
+			if (!isd->bus)
+				continue;
+
+			dev_dbg(dev, "match \"%s\", \"%s\"\n",sensor_node->name,
+				isd->asd.match.of.node->name);
+
+			if (sensor_node !=3D isd->asd.match.of.node)
+				continue;
+
+			dev_dbg(dev, "found\n");
+
+			flash_group_id =3D isd->group_id;
+			break;
 		}
=20
-		isd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
-		notifier->num_subdevs++;
+		/*
+		 * No sensor was found --- complain and allocate a new
+		 * group ID.
+		 */
+		if (i =3D=3D notifier->num_subdevs) {
+			dev_warn(dev, "no device node \"%s\" was found",
+				 sensor_node->name);
+			flash_group_id =3D group_id++;
+		}
+
+		ret =3D isp_of_parse_node(dev, node, notifier, flash_group_id,
+					false);
+		if (ret)
+			return ret;
 	}
=20
 	return notifier->num_subdevs;
-
-error:
-	of_node_put(node);
-	return -EINVAL;
 }
=20
 static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
@@ -2218,7 +2287,7 @@ static int isp_subdev_notifier_bound(struct v4l2_asyn=
c_notifier *async,
 		container_of(asd, struct isp_async_subdev, asd);
=20
 	isd->sd =3D subdev;
-	isd->sd->host_priv =3D &isd->bus;
+	isd->sd->host_priv =3D isd->bus;
=20
 	return 0;
 }
@@ -2421,12 +2490,15 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_register_entities;
=20
-	isp->notifier.bound =3D isp_subdev_notifier_bound;
-	isp->notifier.complete =3D isp_subdev_notifier_complete;
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		isp->notifier.bound =3D isp_subdev_notifier_bound;
+		isp->notifier.complete =3D isp_subdev_notifier_complete;
=20
-	ret =3D v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
-	if (ret)
-		goto error_register_entities;
+		ret =3D v4l2_async_notifier_register(&isp->v4l2_dev,
+						   &isp->notifier);
+		if (ret)
+			goto error_register_entities;
+	}
=20
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform=
/omap3isp/isp.h
index c0b9d1d..639b3ca 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -230,6 +230,7 @@ struct isp_async_subdev {
 	struct v4l2_subdev *sd;
 	struct isp_bus_cfg *bus;
 	struct v4l2_async_subdev asd;
+	u32 group_id;
 };
=20
 #define v4l2_dev_to_isp_device(dev) \
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 871d4fe..6b814e1 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -177,7 +177,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *ph=
y)
 		struct isp_async_subdev *isd =3D
 			container_of(pipe->external->asd,
 				     struct isp_async_subdev, asd);
-		buscfg =3D &isd->bus;
+		buscfg =3D isd->bus;
 	}
=20
 	if (buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY1
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCKcACgkQMOfwapXb+vLXugCfUmgd2t893OjQ0/qyrl0B8bjs
Uv4AnRlYRSkWBmbYx9brm26ypEfeDoZa
=hFsG
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
