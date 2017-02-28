Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45310 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdB1LiX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 06:38:23 -0500
Date: Tue, 28 Feb 2017 12:38:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: [PATCH] omap3isp: Parse CSI1 configuration from the device tree.
Message-ID: <20170228113815.GA4206@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225221255.GA6411@amd>
 <20170227205420.GF16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20170227205420.GF16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Add support for parsing CSI1 configuration.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

> Please find my comments below.

Thanks for comments. They are fixed now, plus I fixed the checkpatch
stuff that was possible.

It should be ready to apply to the right branch.

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 245225a..b8eef2f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2032,6 +2032,7 @@ static int isp_fwnode_parse(struct device *dev, struc=
t fwnode_handle *fwn,
 	struct v4l2_fwnode_endpoint vfwn;
 	unsigned int i;
 	int ret;
+	bool csi1 =3D false;
=20
 	ret =3D v4l2_fwnode_endpoint_parse(fwn, &vfwn);
 	if (ret)
@@ -2059,38 +2060,88 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwn,
=20
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
-		/* FIXME: always assume CSI-2 for now. */
+		switch (vfwn.bus_type) {
+		case V4L2_MBUS_CCP2:
+		case V4L2_MBUS_CSI1:
+			dev_dbg(dev, "csi1 configuration\n");
+			csi1 =3D true;
+			break;
+		case V4L2_MBUS_CSI2:
+			dev_dbg(dev, "csi2 configuration\n");
+			csi1 =3D false;
+			break;
+		default:
+			dev_err(dev, "unkonwn bus type\n");
+		}
+
 		switch (vfwn.base.port) {
 		case ISP_OF_PHY_CSIPHY1:
-			buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
+			if (csi1)
+				buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY1;
+			else
+				buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
 			break;
 		case ISP_OF_PHY_CSIPHY2:
-			buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
+			if (csi1)
+				buscfg->interface =3D ISP_INTERFACE_CCP2B_PHY2;
+			else
+				buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
 			break;
+		default:
+			dev_err(dev, "bad port\n");
 		}
-		buscfg->bus.csi2.lanecfg.clk.pos =3D vfwn.bus.mipi_csi2.clock_lane;
-		buscfg->bus.csi2.lanecfg.clk.pol =3D
-			vfwn.bus.mipi_csi2.lane_polarities[0];
-		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
-			buscfg->bus.csi2.lanecfg.clk.pol,
-			buscfg->bus.csi2.lanecfg.clk.pos);
-
-		for (i =3D 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
-			buscfg->bus.csi2.lanecfg.data[i].pos =3D
-				vfwn.bus.mipi_csi2.data_lanes[i];
-			buscfg->bus.csi2.lanecfg.data[i].pol =3D
-				vfwn.bus.mipi_csi2.lane_polarities[i + 1];
+		if (csi1) {
+			buscfg->bus.ccp2.lanecfg.clk.pos =3D
+				vfwn.bus.mipi_csi1.clock_lane;
+			buscfg->bus.ccp2.lanecfg.clk.pol =3D
+				vfwn.bus.mipi_csi1.lane_polarity[0];
+			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+				buscfg->bus.ccp2.lanecfg.clk.pol,
+				buscfg->bus.ccp2.lanecfg.clk.pos);
+
+			buscfg->bus.ccp2.lanecfg.data[0].pos =3D
+				vfwn.bus.mipi_csi1.data_lane;
+			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
+				vfwn.bus.mipi_csi1.lane_polarity[1];
+
 			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
-				buscfg->bus.csi2.lanecfg.data[i].pol,
-				buscfg->bus.csi2.lanecfg.data[i].pos);
+				buscfg->bus.ccp2.lanecfg.data[0].pol,
+				buscfg->bus.ccp2.lanecfg.data[0].pos);
+
+			buscfg->bus.ccp2.strobe_clk_pol =3D
+				vfwn.bus.mipi_csi1.clock_inv;
+			buscfg->bus.ccp2.phy_layer =3D vfwn.bus.mipi_csi1.strobe;
+			buscfg->bus.ccp2.ccp2_mode =3D
+				vfwn.bus_type =3D=3D V4L2_MBUS_CCP2;
+			buscfg->bus.ccp2.vp_clk_pol =3D 1;
+
+			buscfg->bus.ccp2.crc =3D 1;
+		} else {
+			buscfg->bus.csi2.lanecfg.clk.pos =3D
+				vfwn.bus.mipi_csi2.clock_lane;
+			buscfg->bus.csi2.lanecfg.clk.pol =3D
+				vfwn.bus.mipi_csi2.lane_polarities[0];
+			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+				buscfg->bus.csi2.lanecfg.clk.pol,
+				buscfg->bus.csi2.lanecfg.clk.pos);
+
+			for (i =3D 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
+				buscfg->bus.csi2.lanecfg.data[i].pos =3D
+					vfwn.bus.mipi_csi2.data_lanes[i];
+				buscfg->bus.csi2.lanecfg.data[i].pol =3D
+					vfwn.bus.mipi_csi2.lane_polarities[i + 1];
+				dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+					buscfg->bus.csi2.lanecfg.data[i].pol,
+					buscfg->bus.csi2.lanecfg.data[i].pos);
+			}
+			/*
+			 * FIXME: now we assume the CRC is always there.
+			 * Implement a way to obtain this information from the
+			 * sensor. Frame descriptors, perhaps?
+			 */
+
+			buscfg->bus.csi2.crc =3D 1;
 		}
-
-		/*
-		 * FIXME: now we assume the CRC is always there.
-		 * Implement a way to obtain this information from the
-		 * sensor. Frame descriptors, perhaps?
-		 */
-		buscfg->bus.csi2.crc =3D 1;
 		break;
=20
 	default:
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

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli1YScACgkQMOfwapXb+vJYVACfV7ZEJaaRYpjr4cQBwzr0DMTB
WmsAn11UViph2Kk5QowbPYYRnQ1nwN2A
=09SW
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
