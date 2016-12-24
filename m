Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59161 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753608AbcLXOnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 09:43:35 -0500
Date: Sat, 24 Dec 2016 15:43:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161224144331.GA28469@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222224226.GB31151@amd>
 <20161222234028.oxntlek2oy62cjnh@earth>
 <20161224142657.GA28257@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20161224142657.GA28257@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2016-12-24 15:26:57, Pavel Machek wrote:
> Hi!
>=20
> > > So... did I understood it correctly? (Needs some work to be done...)
> >=20
> > I had a quick look and yes, that's basically what I had in mind to
> > solve the issue. If callback is not available the old system should
> > be used of course.
>=20
> Ok, got it to work, thanks for all the help. I'll clean it up now.

Relative to sre's version, patch is this:

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n90=
0.dts
index 8043290..7189dfd 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -230,6 +230,15 @@
=20
 				csi_switch_out1: endpoint {
 					remote-endpoint =3D <&csi_cam1>;
+				bus-type =3D <3>; /* CCP2 */
+				clock-lanes =3D <0>;
+				data-lanes =3D <1>;
+				lane-polarity =3D <0 0>;
+				clock-inv =3D <0>;
+				/* Select strobe =3D <1> for back camera, <0> for front camera */
+				strobe =3D <1>;
+				crc =3D <0>;
+				=09
 				};
 			};
=20
@@ -238,6 +247,15 @@
=20
 				csi_switch_out2: endpoint {
 					remote-endpoint =3D <&csi_cam2>;
+				bus-type =3D <3>; /* CCP2 */
+				clock-lanes =3D <0>;
+				data-lanes =3D <1>;
+				lane-polarity =3D <0 0>;
+				clock-inv =3D <0>;
+				/* Select strobe =3D <1> for back camera, <0> for front camera */
+				strobe =3D <0>;
+				crc =3D <0>;
+				=09
 				};
 			};
 		};
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 45c69ed..b8cc29b 100644
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
@@ -480,8 +482,8 @@ void omap3isp_hist_dma_done(struct isp_device *isp)
 	    omap3isp_stat_pcr_busy(&isp->isp_hist)) {
 		/* Histogram cannot be enabled in this frame anymore */
 		atomic_set(&isp->isp_hist.buf_err, 1);
-		dev_dbg(isp->dev, "hist: Out of synchronization with "
-				  "CCDC. Ignoring next buffer.\n");
+		dev_dbg(isp->dev,
+			"hist: Out of synchronization with CCDC. Ignoring next buffer.\n");
 	}
 }
=20
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
@@ -2024,44 +2026,51 @@ enum isp_of_phy {
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
@@ -2099,27 +2108,8 @@ static void isp_of_parse_node_csi2(struct device *de=
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
@@ -2147,10 +2137,35 @@ static int isp_of_parse_node_endpoint(struct device=
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
@@ -2262,6 +2277,10 @@ static int isp_of_parse_nodes(struct device *dev,
 	}
=20
 	return notifier->num_subdevs;
+
+error:
+	of_node_put(node);
+	return -EINVAL;
 }
=20
 static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 2d1463a..c2bc6b7 100644
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
@@ -377,7 +383,7 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp=
2,
  */
 static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
 {
-	const struct isp_bus_cfg *buscfg;
+	struct isp_bus_cfg *buscfg;
 	struct v4l2_mbus_framefmt *format;
 	struct media_pad *pad;
 	struct v4l2_subdev *sensor;
@@ -390,6 +396,25 @@ static int ccp2_if_configure(struct isp_ccp2_device *c=
cp2)
 	sensor =3D media_entity_to_v4l2_subdev(pad->entity);
 	buscfg =3D sensor->host_priv;
=20
+	{
+		struct v4l2_subdev *subdev2;
+		struct v4l2_of_endpoint vep;
+	=09
+		subdev2 =3D media_entity_to_v4l2_subdev(pad->entity);
+
+		printk("if_configure... subdev %p\n", subdev2);
+		/* fixme: vep.base.port is wrong? */
+		ret =3D v4l2_subdev_call(subdev2, video, g_endpoint_config, &vep);
+		printk("if_configure ret %d\n", ret);
+		if (ret =3D=3D 0) {
+			struct isp_ccp2_cfg prev_cfg =3D buscfg->bus.ccp2;
+			printk("Success: have configuration\n");
+			printk("Compare: %d\n", memcmp(&prev_cfg, &buscfg->bus.ccp2, sizeof(pre=
v_cfg)));		=09
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
index 1a5d944..b238dac 100644
--- a/drivers/media/platform/video-bus-switch.c
+++ b/drivers/media/platform/video-bus-switch.c
@@ -2,6 +2,7 @@
  * Generic driver for video bus switches
  *
  * Copyright (C) 2015 Sebastian Reichel <sre@kernel.org>
+ * Copyright (C) 2016 Pavel Machek <pavel@ucw.cz>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -33,9 +34,9 @@
 #define CSI_SWITCH_PORTS 3
=20
 enum vbs_state {
-	CSI_SWITCH_DISABLED,
-	CSI_SWITCH_PORT_1,
-	CSI_SWITCH_PORT_2,
+	CSI_SWITCH_DISABLED =3D 0,
+	CSI_SWITCH_PORT_1 =3D 1,
+	CSI_SWITCH_PORT_2 =3D 2,
 };
=20
 struct vbs_src_pads {
@@ -49,6 +50,7 @@ struct vbs_data {
 	struct v4l2_async_notifier notifier;
 	struct media_pad pads[CSI_SWITCH_PORTS];
 	struct vbs_src_pads src_pads[CSI_SWITCH_PORTS];
+	struct v4l2_of_endpoint vep[CSI_SWITCH_PORTS];
 	enum vbs_state state;
 };
=20
@@ -107,6 +109,7 @@ static int vbs_of_parse_nodes(struct device *dev, struc=
t vbs_data *pdata)
 		}
=20
 		ssd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
+		pdata->vep[notifier->num_subdevs] =3D vep;
 		notifier->num_subdevs++;
 	}
=20
@@ -174,6 +177,8 @@ static int vbs_link_setup(struct media_entity *entity,
 	if (pdata->state !=3D CSI_SWITCH_DISABLED)
 		return -EBUSY;
=20
+	printk("Link setup: going to config %d\n", local->index);
+
 	gpiod_set_value(pdata->swgpio, local->index =3D=3D CSI_SWITCH_PORT_2);
 	pdata->state =3D local->index;
=20
@@ -253,6 +258,17 @@ static int vbs_s_stream(struct v4l2_subdev *sd, int en=
able)
 	return v4l2_subdev_call(subdev, video, s_stream, enable);
 }
=20
+static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct v4l2_of_en=
dpoint *cfg)
+{
+	struct vbs_data *pdata =3D v4l2_get_subdevdata(sd);
+	printk("vbs_g_endpoint_config...\n");
+	printk("active port is %d\n", pdata->state);
+	*cfg =3D pdata->vep[pdata->state - 1];
+
+	return 0;
+}
+
+
 static const struct v4l2_subdev_internal_ops vbs_internal_ops =3D {
 	.registered =3D &vbs_registered,
 };
@@ -265,6 +281,7 @@ static const struct media_entity_operations vbs_media_o=
ps =3D {
 /* subdev video operations */
 static const struct v4l2_subdev_video_ops vbs_video_ops =3D {
 	.s_stream =3D vbs_s_stream,
+	.g_endpoint_config =3D vbs_g_endpoint_config,
 };
=20
 static const struct v4l2_subdev_ops vbs_ops =3D {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..448dbb5 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -25,6 +25,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-of.h>
=20
 /* generic v4l2_device notify callback notification values */
 #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
@@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
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

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlheiZMACgkQMOfwapXb+vIJaQCfZXiZf3EucsbpPopbqGEuenww
6BcAni77zAElcS4nm6SjdbOAZvWJclyx
=/5lu
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
