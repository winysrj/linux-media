Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33303 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdGMVNh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 17:13:37 -0400
Date: Thu, 13 Jul 2017 23:13:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3ISP CCP2 support
Message-ID: <20170713211335.GA13502@amd>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I took the liberty of changing your patch a bit. I added another to extra=
ct
> the number of lanes from the endpoint instead as it's not really a proper=
ty
> of the PHY. (Not tested yet, will check with N9.)

No problem.

Notice that the 1/2 does not apply on top of ccp2 branch; my merge
resolution was this:

I broke something in my userspace; I'll continue testing tommorow.

Thanks,
								Pavel

commit 895f4f28972942d1ee77d98dd38dc3d59afaa5c4
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Thu Jul 13 19:19:02 2017 +0300

    omap3isp: Explicitly set the number of CSI-2 lanes used in lane cfg
   =20
    The omap3isp driver extracts the CSI-2 lane configuration from the V4L2
    fwnode endpoint but misses the number of lanes itself. Get this informa=
tion
    and use it in PHY configuration.
   =20
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index b80debf..776f708 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2118,7 +2118,10 @@ static int isp_fwnode_parse(struct device *dev, stru=
ct fwnode_handle *fwnode,
 				buscfg->bus.csi2.lanecfg.clk.pol,
 				buscfg->bus.csi2.lanecfg.clk.pos);
=20
-			for (i =3D 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
+			buscfg->bus.csi2.num_data_lanes =3D
+				vep.bus.mipi_csi2.num_data_lanes;
+
+			for (i =3D 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
 				buscfg->bus.csi2.lanecfg.data[i].pos =3D
 					vep.bus.mipi_csi2.data_lanes[i];
 				buscfg->bus.csi2.lanecfg.data[i].pol =3D
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 50c0f64..958ac7b 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -181,7 +181,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *ph=
y)
 	struct isp_bus_cfg *buscfg;
 	struct isp_csiphy_lanes_cfg *lanes;
 	int csi2_ddrclk_khz;
-	unsigned int used_lanes =3D 0;
+	unsigned int num_data_lanes, used_lanes =3D 0;
 	unsigned int i;
 	u32 reg;
=20
@@ -197,13 +197,19 @@ static int omap3isp_csiphy_config(struct isp_csiphy *=
phy)
 	}
=20
 	if (buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY1
-	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2)
+	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2) {
 		lanes =3D &buscfg->bus.ccp2.lanecfg;
-	else
+		num_data_lanes =3D 1;
+	} else {
 		lanes =3D &buscfg->bus.csi2.lanecfg;
+		num_data_lanes =3D buscfg->bus.csi2.num_data_lanes;
+	}
+
+	if (num_data_lanes > phy->num_data_lanes)
+		return -EINVAL;
=20
 	/* Clock and data lanes verification */
-	for (i =3D 0; i < phy->num_data_lanes; i++) {
+	for (i =3D 0; i < num_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;
=20
@@ -259,7 +265,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *ph=
y)
 	/* DPHY lane configuration */
 	reg =3D isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
=20
-	for (i =3D 0; i < phy->num_data_lanes; i++) {
+	for (i =3D 0; i < num_data_lanes; i++) {
 		reg &=3D ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
 			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
 		reg |=3D (lanes->data[i].pol <<
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/pla=
tform/omap3isp/omap3isp.h
index f6d1d0d..672a9cf 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -115,10 +115,13 @@ struct isp_ccp2_cfg {
 /**
  * struct isp_csi2_cfg - CSI2 interface configuration
  * @crc: Enable the cyclic redundancy check
+ * @lanecfg: CSI-2 lane configuration
+ * @num_data_lanes: The number of data lanes in use
  */
 struct isp_csi2_cfg {
 	unsigned crc:1;
 	struct isp_csiphy_lanes_cfg lanecfg;
+	u8 num_data_lanes;
 };
=20
 struct isp_bus_cfg {


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlln4n8ACgkQMOfwapXb+vLvrQCfYbeDGQQ4at5/zGkvA+9DNYB9
G3wAnjSr9gx3vdqF6jffw2bDyPMK+SMl
=HYzU
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
