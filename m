Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49678 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbcL1SlW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Dec 2016 13:41:22 -0500
Date: Wed, 28 Dec 2016 19:31:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l: add support for CSI-1 bus
Message-ID: <20161228183116.GA13407@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sakari Ailus <sakari.ailus@iki.fi>

The function to parse CSI2 bus parameters was called
v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
anticipation of CSI1/CCP2 support.

Obtain data bus type from bus-type property. Only try parsing bus
specific properties in this case.

Add CSI1 and CCP2 bus type to enum v4l2_mbus_type. CCP2, or CSI-1, is
an older single data lane serial bus.

Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
need these as well, separate them into a different
function. have_clk_lane and num_data_lanes arguments may be NULL; the
CSI-1 bus will have no use for them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4=
l2-of.c
index 93b3368..60bbc5f 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -20,53 +20,88 @@
=20
 #include <media/v4l2-of.h>
=20
-static int v4l2_of_parse_csi_bus(const struct device_node *node,
-				 struct v4l2_of_endpoint *endpoint)
+enum v4l2_of_bus_type {
+	V4L2_OF_BUS_TYPE_CSI2 =3D 0,
+	V4L2_OF_BUS_TYPE_PARALLEL,
+};
+
+static int v4l2_of_parse_lanes(const struct device_node *node,
+			       unsigned char *clock_lane,
+			       bool *have_clk_lane,
+			       unsigned char *data_lanes,
+			       bool *lane_polarities,
+			       unsigned short *__num_data_lanes,
+			       unsigned int max_data_lanes)
 {
-	struct v4l2_of_bus_mipi_csi2 *bus =3D &endpoint->bus.mipi_csi2;
 	struct property *prop;
-	bool have_clk_lane =3D false;
-	unsigned int flags =3D 0;
+	unsigned short num_data_lanes =3D 0;
 	u32 v;
=20
 	prop =3D of_find_property(node, "data-lanes", NULL);
 	if (prop) {
 		const __be32 *lane =3D NULL;
-		unsigned int i;
=20
-		for (i =3D 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
+		for (num_data_lanes =3D 0; num_data_lanes < max_data_lanes;
+		     num_data_lanes++) {
 			lane =3D of_prop_next_u32(prop, lane, &v);
 			if (!lane)
 				break;
-			bus->data_lanes[i] =3D v;
+			data_lanes[num_data_lanes] =3D v;
 		}
-		bus->num_data_lanes =3D i;
 	}
+	if (__num_data_lanes)
+		*__num_data_lanes =3D num_data_lanes;
=20
 	prop =3D of_find_property(node, "lane-polarities", NULL);
 	if (prop) {
 		const __be32 *polarity =3D NULL;
 		unsigned int i;
=20
-		for (i =3D 0; i < ARRAY_SIZE(bus->lane_polarities); i++) {
+		for (i =3D 0; i < 1 + max_data_lanes; i++) {
 			polarity =3D of_prop_next_u32(prop, polarity, &v);
 			if (!polarity)
 				break;
-			bus->lane_polarities[i] =3D v;
+			lane_polarities[i] =3D v;
 		}
=20
-		if (i < 1 + bus->num_data_lanes /* clock + data */) {
+		if (i < 1 + num_data_lanes /* clock + data */) {
 			pr_warn("%s: too few lane-polarities entries (need %u, got %u)\n",
-				node->full_name, 1 + bus->num_data_lanes, i);
+				node->full_name, 1 + num_data_lanes, i);
 			return -EINVAL;
 		}
 	}
=20
+	if (have_clk_lane)
+		*have_clk_lane =3D false;
+
 	if (!of_property_read_u32(node, "clock-lanes", &v)) {
-		bus->clock_lane =3D v;
-		have_clk_lane =3D true;
+		*clock_lane =3D v;
+		if (have_clk_lane)
+			*have_clk_lane =3D true;
 	}
=20
+	return 0;
+}
+
+static int v4l2_of_parse_csi2_bus(const struct device_node *node,
+				 struct v4l2_of_endpoint *endpoint)
+{
+	struct v4l2_of_bus_mipi_csi2 *bus =3D &endpoint->bus.mipi_csi2;
+	bool have_clk_lane =3D false;
+	unsigned int flags =3D 0;
+	int rval;
+	u32 v;
+
+	rval =3D v4l2_of_parse_lanes(node, &bus->clock_lane, &have_clk_lane,
+				   bus->data_lanes, bus->lane_polarities,
+				   &bus->num_data_lanes,
+				   ARRAY_SIZE(bus->data_lanes));
+	if (rval)
+		return rval;
+
+	BUILD_BUG_ON(1 + ARRAY_SIZE(bus->data_lanes)
+		       !=3D ARRAY_SIZE(bus->lane_polarities));
+
 	if (of_get_property(node, "clock-noncontinuous", &v))
 		flags |=3D V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
 	else if (have_clk_lane || bus->num_data_lanes > 0)
@@ -151,6 +186,7 @@ static void v4l2_of_parse_parallel_bus(const struct dev=
ice_node *node,
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
+	u32 bus_type;
 	int rval;
=20
 	of_graph_parse_endpoint(node, &endpoint->base);
@@ -158,17 +194,33 @@ int v4l2_of_parse_endpoint(const struct device_node *=
node,
 	memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
 	       offsetof(typeof(*endpoint), bus_type));
=20
-	rval =3D v4l2_of_parse_csi_bus(node, endpoint);
-	if (rval)
-		return rval;
-	/*
-	 * Parse the parallel video bus properties only if none
-	 * of the MIPI CSI-2 specific properties were found.
-	 */
-	if (endpoint->bus.mipi_csi2.flags =3D=3D 0)
-		v4l2_of_parse_parallel_bus(node, endpoint);
+	rval =3D of_property_read_u32(node, "bus-type", &bus_type);
+	if (rval < 0) {
+		endpoint->bus_type =3D 0;
+		rval =3D v4l2_of_parse_csi2_bus(node, endpoint);
+		if (rval)
+			return rval;
+		/*
+		 * Parse the parallel video bus properties only if none
+		 * of the MIPI CSI-2 specific properties were found.
+		 */
+		if (endpoint->bus.mipi_csi2.flags =3D=3D 0)
+			v4l2_of_parse_parallel_bus(node, endpoint);
+
+		return 0;
+	}
=20
-	return 0;
+	switch (bus_type) {
+	case V4L2_OF_BUS_TYPE_CSI2:
+		return v4l2_of_parse_csi2_bus(node, endpoint);
+	case V4L2_OF_BUS_TYPE_PARALLEL:
+		v4l2_of_parse_parallel_bus(node, endpoint);
+		return 0;
+	default:
+		pr_warn("bad bus-type %u, device_node \"%s\"\n",
+			bus_type, node->full_name);
+		return -EINVAL;
+	}
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
=20
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e..315c167 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -69,11 +69,15 @@
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
+ * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
+ * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
+	V4L2_MBUS_CSI1,
+	V4L2_MBUS_CCP2,
 	V4L2_MBUS_CSI2,
 };
=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhkBPQACgkQMOfwapXb+vJtuQCgjPZYL48hUYrchZLiEbUqnbin
RfkAniOrd06tYduhooasm48fbYTSsWGW
=pbwN
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
