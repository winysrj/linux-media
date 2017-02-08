Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59245 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754191AbdBHNAE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 08:00:04 -0500
Date: Wed, 8 Feb 2017 13:57:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170208125738.GA23236@amd>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
 <20170206094956.GA17974@amd>
 <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Obtain the CSI1/CCP2 bus parameters from the OF node.

ISP CSI1 module needs all the bits correctly set to work.

OMAP3430 needs various syscon CONTROL_CSIRXFE bits set in order to
operate. Implement the missing functionality.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

> How about the rest? :-) I guess we could get the CCP2 support in omap3isp
> without the video bus switch. It'd be nice to have this in a single
> patchset.

Ok, here you go, what about this?

									Pavel

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 0321d84..88bc7c6 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2024,21 +2024,92 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
=20
-static int isp_of_parse_node(struct device *dev, struct device_node *node,
-			     struct isp_async_subdev *isd)
+void __isp_of_parse_node_csi1(struct device *dev,
+				   struct isp_ccp2_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
+{
+	buscfg->lanecfg.clk.pos =3D vep->bus.mipi_csi1.clock_lane;
+	buscfg->lanecfg.clk.pol =3D
+		vep->bus.mipi_csi1.lane_polarity[0];
+	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+		buscfg->lanecfg.clk.pol,
+		buscfg->lanecfg.clk.pos);
+
+	buscfg->lanecfg.data[0].pos =3D vep->bus.mipi_csi2.data_lanes[0];
+	buscfg->lanecfg.data[0].pol =3D
+		vep->bus.mipi_csi2.lane_polarities[1];
+	dev_dbg(dev, "data lane polarity %u, pos %u\n",
+		buscfg->lanecfg.data[0].pol,
+		buscfg->lanecfg.data[0].pos);
+
+	buscfg->strobe_clk_pol =3D vep->bus.mipi_csi1.clock_inv;
+	buscfg->phy_layer =3D vep->bus.mipi_csi1.strobe;
+	buscfg->ccp2_mode =3D vep->bus_type =3D=3D V4L2_MBUS_CCP2;
+
+	dev_dbg(dev, "clock_inv %u strobe %u ccp2 %u\n",
+		buscfg->strobe_clk_pol,
+		buscfg->phy_layer,
+		buscfg->ccp2_mode);
+	/*
+	 * FIXME: now we assume the CRC is always there.
+	 * Implement a way to obtain this information from the
+	 * sensor. Frame descriptors, perhaps?
+	 */
+	buscfg->crc =3D 1;
+
+	buscfg->vp_clk_pol =3D 1;
+}
+
+static void isp_of_parse_node_csi1(struct device *dev,
+				   struct isp_bus_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
+{
+	if (vep->base.port =3D=3D ISP_OF_PHY_CSIPHY1)
+		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
+	else
+		buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY2;
+	__isp_of_parse_node_csi1(dev, &buscfg->bus.ccp2, vep);
+}
+
+static void isp_of_parse_node_csi2(struct device *dev,
+				   struct isp_bus_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
 {
-	struct isp_bus_cfg *buscfg =3D &isd->bus;
-	struct v4l2_of_endpoint vep;
 	unsigned int i;
-	int ret;
=20
-	ret =3D v4l2_of_parse_endpoint(node, &vep);
-	if (ret)
-		return ret;
+	if (vep->base.port =3D=3D ISP_OF_PHY_CSIPHY1)
+		buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
+	else
+		buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
+	buscfg->bus.csi2.lanecfg.clk.pos =3D vep->bus.mipi_csi2.clock_lane;
+	buscfg->bus.csi2.lanecfg.clk.pol =3D
+			vep->bus.mipi_csi2.lane_polarities[0];
+	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+		buscfg->bus.csi2.lanecfg.clk.pol,
+		buscfg->bus.csi2.lanecfg.clk.pos);
+
+	for (i =3D 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
+		buscfg->bus.csi2.lanecfg.data[i].pos =3D
+			vep->bus.mipi_csi2.data_lanes[i];
+		buscfg->bus.csi2.lanecfg.data[i].pol =3D
+			vep->bus.mipi_csi2.lane_polarities[i + 1];
+		dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			buscfg->bus.csi2.lanecfg.data[i].pol,
+				buscfg->bus.csi2.lanecfg.data[i].pos);
+	}
=20
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
-		vep.base.port);
+	/*
+	 * FIXME: now we assume the CRC is always there.
+	 * Implement a way to obtain this information from the
+	 * sensor. Frame descriptors, perhaps?
+	 */
+	buscfg->bus.csi2.crc =3D 1;
+}
=20
+static int isp_endpoint_to_buscfg(struct device *dev,
+				  struct v4l2_of_endpoint vep,
+				  struct isp_bus_cfg *buscfg)
+{
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface =3D ISP_INTERFACE_PARALLEL;
@@ -2059,45 +2130,42 @@ static int isp_of_parse_node(struct device *dev, st=
ruct device_node *node,
=20
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
-		/* FIXME: always assume CSI-2 for now. */
-		switch (vep.base.port) {
-		case ISP_OF_PHY_CSIPHY1:
-			buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
-			break;
-		case ISP_OF_PHY_CSIPHY2:
-			buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
-			break;
-		}
-		buscfg->bus.csi2.lanecfg.clk.pos =3D vep.bus.mipi_csi2.clock_lane;
-		buscfg->bus.csi2.lanecfg.clk.pol =3D
-			vep.bus.mipi_csi2.lane_polarities[0];
-		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
-			buscfg->bus.csi2.lanecfg.clk.pol,
-			buscfg->bus.csi2.lanecfg.clk.pos);
-
-		for (i =3D 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
-			buscfg->bus.csi2.lanecfg.data[i].pos =3D
-				vep.bus.mipi_csi2.data_lanes[i];
-			buscfg->bus.csi2.lanecfg.data[i].pol =3D
-				vep.bus.mipi_csi2.lane_polarities[i + 1];
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
-				buscfg->bus.csi2.lanecfg.data[i].pol,
-				buscfg->bus.csi2.lanecfg.data[i].pos);
-		}
-
-		/*
-		 * FIXME: now we assume the CRC is always there.
-		 * Implement a way to obtain this information from the
-		 * sensor. Frame descriptors, perhaps?
-		 */
-		buscfg->bus.csi2.crc =3D 1;
+		if (vep.bus_type =3D=3D V4L2_MBUS_CSI2)
+			isp_of_parse_node_csi2(dev, buscfg, &vep);
+		else
+			isp_of_parse_node_csi1(dev, buscfg, &vep);
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
@@ -2124,7 +2192,7 @@ static int isp_of_parse_nodes(struct device *dev,
=20
 		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
=20
-		if (isp_of_parse_node(dev, node, isd)) {
+		if (isp_of_parse_node_endpoint(dev, node, isd)) {
 			of_node_put(node);
 			return -EINVAL;
 		}
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform=
/omap3isp/isp.h
index 7e6f663..c0b9d1d 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -228,7 +228,7 @@ struct isp_device {
=20
 struct isp_async_subdev {
 	struct v4l2_subdev *sd;
-	struct isp_bus_cfg bus;
+	struct isp_bus_cfg *bus;
 	struct v4l2_async_subdev asd;
 };
=20
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index ca09523..4edb55a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -21,6 +21,9 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/regulator/consumer.h>
+#include <linux/regmap.h>
+
+#include <media/v4l2-of.h>
=20
 #include "isp.h"
 #include "ispreg.h"
@@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_device *ccp2=
, u8 enable)
 			return ret;
 	}
=20
+	if (isp->revision =3D=3D ISP_REVISION_2_0) {
+		struct media_pad *pad;
+		struct v4l2_subdev *sensor;
+		const struct isp_ccp2_cfg *buscfg;
+		u32 csirxfe;
+
+		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
+		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
+		/* Struct isp_bus_cfg has union inside */
+		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
+
+
+		if (enable) {
+			csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
+				  OMAP343X_CONTROL_CSIRXFE_RESET;
+
+			if (buscfg->phy_layer)
+				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_SELFORM;
+
+			if (buscfg->strobe_clk_pol)
+				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
+		} else
+			csirxfe =3D 0;
+
+		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
+	}
+
 	/* Enable/Disable all the LCx channels */
 	for (i =3D 0; i < CCP2_LCx_CHANS_NUM; i++)
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
@@ -213,14 +243,17 @@ static int ccp2_phyif_config(struct isp_ccp2_device *=
ccp2,
 	struct isp_device *isp =3D to_isp_device(ccp2);
 	u32 val;
=20
-	/* CCP2B mode */
 	val =3D isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL) |
-			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
+	      ISPCCP2_CTRL_MODE;
 	/* Data/strobe physical layer */
 	BIT_SET(val, ISPCCP2_CTRL_PHY_SEL_SHIFT, ISPCCP2_CTRL_PHY_SEL_MASK,
 		buscfg->phy_layer);
+	BIT_SET(val, ISPCCP2_CTRL_IO_OUT_SEL_SHIFT,
+		ISPCCP2_CTRL_IO_OUT_SEL_MASK, buscfg->ccp2_mode);
 	BIT_SET(val, ISPCCP2_CTRL_INV_SHIFT, ISPCCP2_CTRL_INV_MASK,
 		buscfg->strobe_clk_pol);
+	BIT_SET(val, ISPCCP2_CTRL_VP_CLK_POL_SHIFT,
+		ISPCCP2_CTRL_VP_CLK_POL_MASK, buscfg->vp_clk_pol);
 	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
=20
 	val =3D isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL);
@@ -339,6 +372,9 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp=
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
@@ -1137,6 +1173,8 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	if (isp->revision =3D=3D ISP_REVISION_2_0) {
 		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
+			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER)
+				return -EPROBE_DEFER;
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib =3D NULL;
diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platf=
orm/omap3isp/ispreg.h
index b5ea8da..d084839 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -87,6 +87,8 @@
 #define ISPCCP2_CTRL_PHY_SEL_MASK	0x1
 #define ISPCCP2_CTRL_PHY_SEL_SHIFT	1
 #define ISPCCP2_CTRL_IO_OUT_SEL		(1 << 2)
+#define ISPCCP2_CTRL_IO_OUT_SEL_MASK	0x1
+#define ISPCCP2_CTRL_IO_OUT_SEL_SHIFT	2
 #define ISPCCP2_CTRL_MODE		(1 << 4)
 #define ISPCCP2_CTRL_VP_CLK_FORCE_ON	(1 << 9)
 #define ISPCCP2_CTRL_INV		(1 << 10)
@@ -94,6 +96,8 @@
 #define ISPCCP2_CTRL_INV_SHIFT		10
 #define ISPCCP2_CTRL_VP_ONLY_EN		(1 << 11)
 #define ISPCCP2_CTRL_VP_CLK_POL		(1 << 12)
+#define ISPCCP2_CTRL_VP_CLK_POL_MASK	0x1
+#define ISPCCP2_CTRL_VP_CLK_POL_SHIFT	12
 #define ISPCCP2_CTRL_VPCLK_DIV_SHIFT	15
 #define ISPCCP2_CTRL_VPCLK_DIV_MASK	0x1ffff /* [31:15] */
 #define ISPCCP2_CTRL_VP_OUT_CTRL_SHIFT	8 /* 3430 bits */
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/pla=
tform/omap3isp/omap3isp.h
index 443e8f7..f6d1d0d 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -108,6 +108,7 @@ struct isp_ccp2_cfg {
 	unsigned int ccp2_mode:1;
 	unsigned int phy_layer:1;
 	unsigned int vpclk_div:2;
+	unsigned int vp_clk_pol:1;
 	struct isp_csiphy_lanes_cfg lanecfg;
 };
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
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 4dc34b2..63a52ee 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -53,6 +53,22 @@ struct v4l2_of_bus_parallel {
 };
=20
 /**
+ * struct v4l2_of_bus_csi1 - CSI-1/CCP2 data bus structure
+ * @clock_inv: polarity of clock/strobe signal
+ *	       false - not inverted, true - inverted
+ * @strobe: false - data/clock, true - data/strobe
+ * @data_lane: the number of the data lane
+ * @clock_lane: the number of the clock lane
+ */
+struct v4l2_of_bus_mipi_csi1 {
+	bool clock_inv;
+	bool strobe;
+	bool lane_polarity[2];
+	unsigned char data_lane;
+	unsigned char clock_lane;
+};
+
+/**
  * struct v4l2_of_endpoint - the endpoint data structure
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
@@ -66,6 +82,7 @@ struct v4l2_of_endpoint {
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
+		struct v4l2_of_bus_mipi_csi1 mipi_csi1;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
 	u64 *link_frequencies;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlibFcIACgkQMOfwapXb+vLqWgCeIgoZBhby5KQjfGW4ApVLGB0/
4BIAnjUBjy1panc3iPRIDcrhFoTdblhA
=slLM
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
