Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57578 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753353AbcLWLmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 06:42:40 -0500
Date: Fri, 23 Dec 2016 12:42:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161223114237.GA5879@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222224226.GB31151@amd>
 <20161222234028.oxntlek2oy62cjnh@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20161222234028.oxntlek2oy62cjnh@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > [...]
> >
> >  static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
> > diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/=
platform/video-bus-switch.c
> > index 1a5d944..3a2d442 100644
> > --- a/drivers/media/platform/video-bus-switch.c
> > +++ b/drivers/media/platform/video-bus-switch.c
> > @@ -247,12 +247,21 @@ static int vbs_s_stream(struct v4l2_subdev *sd, i=
nt enable)
> >  {
> >  	struct v4l2_subdev *subdev =3D vbs_get_remote_subdev(sd);
> > =20
> > +	/* FIXME: we need to set the GPIO here */
> > +
>=20
> The gpio is set when the pad is selected, so no need to do it again.
> The gpio selection actually works with your branch (assuming its
> based on Ivo's).

Yes. I did not notice... is there actually some interface to select
the camera from userland?

> >  	if (IS_ERR(subdev))
> >  		return PTR_ERR(subdev);
> > =20
> >  	return v4l2_subdev_call(subdev, video, s_stream, enable);
> >  }
> > =20
> > +static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct isp_bu=
s_cfg *cfg)
> > +{
> > +	printk("vbs_g_endpoint_config...\n");
> > +	return 0;
> > +}
>=20
> Would be nice to find something more abstract than isp_bus_cfg,
> which is specific to omap3isp.

Yes, that should be doable.

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 45c69ed..f0aa8cd 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2024,44 +2054,51 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
=20
-static void isp_of_parse_node_csi1(struct device *dev,
-				   struct isp_bus_cfg *buscfg,
+void __isp_of_parse_node_csi1(struct device *dev,
+				   struct isp_ccp2_cfg *buscfg,
 				   struct v4l2_of_endpoint *vep)
 {
-	if (vep->base.port =3D=3D ISP_OF_PHY_CSIPHY1)
-		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
-	else
-		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY2;
-	buscfg->bus.ccp2.lanecfg.clk.pos =3D vep->bus.mipi_csi1.clock_lane;
-	buscfg->bus.ccp2.lanecfg.clk.pol =3D
+	buscfg->lanecfg.clk.pos =3D vep->bus.mipi_csi1.clock_lane;
+	buscfg->lanecfg.clk.pol =3D
 		vep->bus.mipi_csi1.lane_polarity[0];
 	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
-		buscfg->bus.ccp2.lanecfg.clk.pol,
-		buscfg->bus.ccp2.lanecfg.clk.pos);
+		buscfg->lanecfg.clk.pol,
+		buscfg->lanecfg.clk.pos);
=20
-	buscfg->bus.ccp2.lanecfg.data[0].pos =3D vep->bus.mipi_csi2.data_lanes[0];
-	buscfg->bus.ccp2.lanecfg.data[0].pol =3D
+	buscfg->lanecfg.data[0].pos =3D vep->bus.mipi_csi2.data_lanes[0];
+	buscfg->lanecfg.data[0].pol =3D
 		vep->bus.mipi_csi2.lane_polarities[1];
 	dev_dbg(dev, "data lane polarity %u, pos %u\n",
-		buscfg->bus.ccp2.lanecfg.data[0].pol,
-		buscfg->bus.ccp2.lanecfg.data[0].pos);
+		buscfg->lanecfg.data[0].pol,
+		buscfg->lanecfg.data[0].pos);
=20
-	buscfg->bus.ccp2.strobe_clk_pol =3D vep->bus.mipi_csi1.clock_inv;
-	buscfg->bus.ccp2.phy_layer =3D vep->bus.mipi_csi1.strobe;
-	buscfg->bus.ccp2.ccp2_mode =3D vep->bus_type =3D=3D V4L2_MBUS_CCP2;
+	buscfg->strobe_clk_pol =3D vep->bus.mipi_csi1.clock_inv;
+	buscfg->phy_layer =3D vep->bus.mipi_csi1.strobe;
+	buscfg->ccp2_mode =3D vep->bus_type =3D=3D V4L2_MBUS_CCP2;
=20
 	dev_dbg(dev, "clock_inv %u strobe %u ccp2 %u\n",
-		buscfg->bus.ccp2.strobe_clk_pol,
-		buscfg->bus.ccp2.phy_layer,
-		buscfg->bus.ccp2.ccp2_mode);
+		buscfg->strobe_clk_pol,
+		buscfg->phy_layer,
+		buscfg->ccp2_mode);
 	/*
 	 * FIXME: now we assume the CRC is always there.
 	 * Implement a way to obtain this information from the
 	 * sensor. Frame descriptors, perhaps?
 	 */
-	buscfg->bus.ccp2.crc =3D 1;
+	buscfg->crc =3D 1;
=20
-	buscfg->bus.ccp2.vp_clk_pol =3D 1;
+	buscfg->vp_clk_pol =3D 1;
+}
+=09
+static void isp_of_parse_node_csi1(struct device *dev,
+				   struct isp_bus_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
+{
+	if (vep->base.port =3D=3D ISP_OF_PHY_CSIPHY1)
+		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
+	else
+		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY2;
+	__isp_of_parse_node_csi1(dev, &buscfg->bus.ccp2, vep);
 }
=20
 static void isp_of_parse_node_csi2(struct device *dev,
@@ -2099,27 +2136,8 @@ static void isp_of_parse_node_csi2(struct device *de=
v,
 	buscfg->bus.csi2.crc =3D 1;
 }
=20
-static int isp_of_parse_node_endpoint(struct device *dev,
-				      struct device_node *node,
-				      struct isp_async_subdev *isd)
+static int isp_endpoint_to_buscfg(struct device *dev, struct v4l2_of_endpo=
int vep, struct isp_bus_cfg *buscfg)
 {
-	struct isp_bus_cfg *buscfg;
-	struct v4l2_of_endpoint vep;
-	int ret;
-
-	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
-	if (!isd->bus)
-		return -ENOMEM;
-
-	buscfg =3D isd->bus;
-
-	ret =3D v4l2_of_parse_endpoint(node, &vep);
-	if (ret)
-		return ret;
-
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
-		vep.base.port);
-
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface =3D ISP_INTERFACE_PARALLEL;
@@ -2147,10 +2165,35 @@ static int isp_of_parse_node_endpoint(struct device=
 *dev,
 		break;
=20
 	default:
+		return -1;
+	}
+	return 0;
+}
+
+static int isp_of_parse_node_endpoint(struct device *dev,
+				      struct device_node *node,
+				      struct isp_async_subdev *isd)
+{
+	struct isp_bus_cfg *buscfg;
+	struct v4l2_of_endpoint vep;
+	int ret;
+
+	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
+	if (!isd->bus)
+		return -ENOMEM;
+
+	buscfg =3D isd->bus;
+
+	ret =3D v4l2_of_parse_endpoint(node, &vep);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
+		vep.base.port);
+
+	if (isp_endpoint_to_buscfg(dev, vep, buscfg))
 		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
 			 vep.base.port);
-		break;
-	}
=20
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 2d1463a..a6763b3 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -23,6 +23,8 @@
 #include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
=20
+#include <media/v4l2-of.h>
+
 #include "isp.h"
 #include "ispreg.h"
 #include "ispccp2.h"
@@ -169,6 +171,7 @@ static int ccp2_if_enable(struct isp_ccp2_device *ccp2,=
 u8 enable)
=20
 		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
 		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
+		/* Struct isp_bus_cfg has union inside */=20
 		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
=20
=20
@@ -369,6 +372,9 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp=
2,
 	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LC01_IRQENABLE, val);
 }
=20
+void __isp_of_parse_node_csi1(struct device *dev,
+			      struct isp_ccp2_cfg *buscfg,
+			      struct v4l2_of_endpoint *vep);
 /*
  * ccp2_if_configure - Configure ccp2 with data from sensor
  * @ccp2: Pointer to ISP CCP2 device
@@ -390,6 +396,21 @@ static int ccp2_if_configure(struct isp_ccp2_device *c=
cp2)
 	sensor =3D media_entity_to_v4l2_subdev(pad->entity);
 	buscfg =3D sensor->host_priv;
=20
+	{
+		struct v4l2_subdev *subdev2;
+		subdev2 =3D media_entity_to_v4l2_subdev(pad->entity);
+		struct v4l2_of_endpoint vep;
+
+		printk("if_configure...\n");
+		printk("2: %p\n", subdev2);
+		ret =3D v4l2_subdev_call(subdev2, video, g_endpoint_config, &vep);
+		if (ret =3D=3D 0) {
+			printk("Success: have configuration\n");
+			__isp_of_parse_node_csi1(NULL, &buscfg->bus.ccp2, &vep);
+			printk("Configured ok?\n");
+		}
+	}
+
 	ret =3D ccp2_phyif_config(ccp2, &buscfg->bus.ccp2);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/plat=
form/video-bus-switch.c
index 1a5d944..3a2d442 100644
--- a/drivers/media/platform/video-bus-switch.c
+++ b/drivers/media/platform/video-bus-switch.c
@@ -247,12 +247,21 @@ static int vbs_s_stream(struct v4l2_subdev *sd, int e=
nable)
 {
 	struct v4l2_subdev *subdev =3D vbs_get_remote_subdev(sd);
=20
+
+
 	if (IS_ERR(subdev))
 		return PTR_ERR(subdev);
=20
 	return v4l2_subdev_call(subdev, video, s_stream, enable);
 }
=20
+static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct isp_bus_cf=
g *cfg)
+{
+	printk("vbs_g_endpoint_config...\n");
+	return 0;
+}
+
+
 static const struct v4l2_subdev_internal_ops vbs_internal_ops =3D {
 	.registered =3D &vbs_registered,
 };
@@ -265,6 +274,7 @@ static const struct media_entity_operations vbs_media_o=
ps =3D {
 /* subdev video operations */
 static const struct v4l2_subdev_video_ops vbs_video_ops =3D {
 	.s_stream =3D vbs_s_stream,
+	.g_endpoint_config =3D vbs_g_endpoint_config,
 };
=20
 static const struct v4l2_subdev_ops vbs_ops =3D {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..30457b0 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -415,6 +415,8 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*g_endpoint_config)(struct v4l2_subdev *sd,
+			    struct v4l2_of_endpoint *cfg);
 };
=20
 /**


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhdDa0ACgkQMOfwapXb+vL8BACePT7RJ3+tHH3mShxpIIVacEUB
uKcAnR6pMbgpWrFsJISMzLHrUk8i2B2z
=UQR3
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
