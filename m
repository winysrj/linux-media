Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59073 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753335AbdBNNjo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:39:44 -0500
Date: Tue, 14 Feb 2017 14:39:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 03/13] v4l: split lane parsing code
Message-ID: <20170214133941.GA8469@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sakari Ailus <sakari.ailus@iki.fi>

The function to parse CSI2 bus parameters was called
v4l2_of_parse_csi_bus(), rename it as v4l2_of_parse_csi2_bus() in
anticipation of CSI1/CCP2 support.

Obtain data bus type from bus-type property. Only try parsing bus
specific properties in this case.

Separate lane parsing from CSI-2 bus parameter parsing. The CSI-1 will
need these as well, separate them into a different
function. have_clk_lane and num_data_lanes arguments may be NULL; the
CSI-1 bus will have no use for them.

Add support for parsing of CSI-1 and CCP2 bus related properties
documented in video-interfaces.txt.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/v4l2-core/v4l2-of.c | 141 ++++++++++++++++++++++++++++++----=
----
 1 file changed, 114 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4=
l2-of.c
index 4f59f44..9ffe2d3 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -20,64 +20,101 @@
=20
 #include <media/v4l2-of.h>
=20
-static int v4l2_of_parse_csi_bus(const struct device_node *node,
-				 struct v4l2_of_endpoint *endpoint)
+enum v4l2_of_bus_type {
+	V4L2_OF_BUS_TYPE_CSI2 =3D 0,
+	V4L2_OF_BUS_TYPE_PARALLEL,
+	V4L2_OF_BUS_TYPE_CSI1,
+	V4L2_OF_BUS_TYPE_CCP2,
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
-	unsigned int flags =3D 0, lanes_used =3D 0;
+	unsigned int lanes_used =3D 0;
+	short num_data_lanes =3D 0;
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
+			data_lanes[num_data_lanes] =3D v;
=20
 			if (lanes_used & BIT(v))
 				pr_warn("%s: duplicated lane %u in data-lanes\n",
 					node->full_name, v);
 			lanes_used |=3D BIT(v);
-
-			bus->data_lanes[i] =3D v;
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
+		*clock_lane =3D v;
+		if (have_clk_lane)
+			*have_clk_lane =3D true;
+
 		if (lanes_used & BIT(v))
 			pr_warn("%s: duplicated lane %u in clock-lanes\n",
 				node->full_name, v);
 		lanes_used |=3D BIT(v);
-
-		bus->clock_lane =3D v;
-		have_clk_lane =3D true;
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
@@ -139,6 +176,35 @@ static void v4l2_of_parse_parallel_bus(const struct de=
vice_node *node,
=20
 }
=20
+void v4l2_of_parse_csi1_bus(const struct device_node *node,
+			    struct v4l2_of_endpoint *endpoint,
+			    enum v4l2_of_bus_type bus_type)
+{
+	struct v4l2_of_bus_mipi_csi1 *bus =3D &endpoint->bus.mipi_csi1;
+	u32 v;
+
+	v4l2_of_parse_lanes(node, &bus->clock_lane, NULL,
+			    &bus->data_lane, bus->lane_polarity,
+			    NULL, 1);
+
+	if (!of_property_read_u32(node, "clock-inv", &v))
+		bus->clock_inv =3D v;
+
+	if (!of_property_read_u32(node, "strobe", &v))
+		bus->strobe =3D v;
+
+	if (!of_property_read_u32(node, "data-lane", &v))
+		bus->data_lane =3D v;
+
+	if (!of_property_read_u32(node, "clock-lane", &v))
+		bus->clock_lane =3D v;
+
+	if (bus_type =3D=3D V4L2_OF_BUS_TYPE_CSI1)
+		endpoint->bus_type =3D V4L2_MBUS_CSI1;
+	else
+		endpoint->bus_type =3D V4L2_MBUS_CCP2;
+}
+
 /**
  * v4l2_of_parse_endpoint() - parse all endpoint node properties
  * @node: pointer to endpoint device_node
@@ -162,6 +228,7 @@ static void v4l2_of_parse_parallel_bus(const struct dev=
ice_node *node,
 int v4l2_of_parse_endpoint(const struct device_node *node,
 			   struct v4l2_of_endpoint *endpoint)
 {
+	u32 bus_type;
 	int rval;
=20
 	of_graph_parse_endpoint(node, &endpoint->base);
@@ -169,17 +236,37 @@ int v4l2_of_parse_endpoint(const struct device_node *=
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
+	case V4L2_OF_BUS_TYPE_CSI1:
+	case V4L2_OF_BUS_TYPE_CCP2:
+		v4l2_of_parse_csi1_bus(node, endpoint, bus_type);
+		return 0;
+	default:
+		pr_warn("bad bus-type %u, device_node \"%s\"\n",
+			bus_type, node->full_name);
+		return -EINVAL;
+	}
 }
 EXPORT_SYMBOL(v4l2_of_parse_endpoint);
=20
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCJ0ACgkQMOfwapXb+vJwoACeObmZh2k538TmSniUYLxPlD+g
GBUAnjeaOyx/TUGCveC00Ie3ITphmwyr
=6313
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
