Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37955 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdCBKQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 05:16:07 -0500
Date: Thu, 2 Mar 2017 11:16:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170302101603.GE27818@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <20170302090143.GB27818@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > >> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > > >> @@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_dev=
ice
> > > >> *ccp2, u8 enable) return ret;
> > > >>=20
> > > >>  	}
> > > >>=20
> > > >> +	if (isp->revision =3D=3D ISP_REVISION_2_0) {
> > > >=20
> > > > The isp_csiphy.c code checks phy->isp->phy_type for the same purpos=
e,
> > > > shouldn't you use that too ?
> > >=20
> > > Do you want me to do phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430 check
> > > here? Can do...
> >=20
> > Yes that's what I meant.
>=20
> Ok, that's something I can do.
>=20
> But code is still somewhat "interesting". Code in omap3isp_csiphy_acquire=
()
> assumes csi2, and I don't need most of it.. so I'll just not use it,
> but it looks strange. I'll post new patch shortly.

Ok, how about this one?

									Pavel

omap3isp: add rest of CSI1 support
   =20
CSI1 needs one more bit to be set up. Do just that.
   =20
It is not as straightforward as I'd like, see the comments in the code
for explanation.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

index ca09523..b6e055e 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -21,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/regulator/consumer.h>
+#include <linux/regmap.h>
=20
 #include "isp.h"
 #include "ispreg.h"
@@ -160,6 +163,22 @@ static int ccp2_if_enable(struct isp_ccp2_device *ccp2=
, u8 enable)
 			return ret;
 	}
=20
+	if (isp->phy_type =3D=3D ISP_PHY_TYPE_3430) {
+		struct media_pad *pad;
+		struct v4l2_subdev *sensor;
+		const struct isp_ccp2_cfg *buscfg;
+
+		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
+		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
+		/* Struct isp_bus_cfg has union inside */
+		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
+
+		csiphy_routing_cfg_3430(&isp->isp_csiphy2,
+					ISP_INTERFACE_CCP2B_PHY1,
+					enable, !!buscfg->phy_layer,
+					buscfg->strobe_clk_pol);
+	}
+
 	/* Enable/Disable all the LCx channels */
 	for (i =3D 0; i < CCP2_LCx_CHANS_NUM; i++)
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
@@ -1137,10 +1159,19 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	if (isp->revision =3D=3D ISP_REVISION_2_0) {
 		ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
+			if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER)
+				return -EPROBE_DEFER;
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib =3D NULL;
 		}
+		/*
+		 * If we set up ccp2->phy here,
+		 * omap3isp_csiphy_acquire() will go ahead and assume
+		 * csi2, dereferencing some null pointers.
+		 *
+		 * ccp2->phy =3D &isp->isp_csiphy2;
+		 */
 	} else if (isp->revision =3D=3D ISP_REVISION_15_0) {
 		ccp2->phy =3D &isp->isp_csiphy1;
 	}
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 871d4fe..897097b 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -68,8 +68,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *ph=
y,
 	regmap_write(phy->isp->syscon, phy->isp->syscon_offset, reg);
 }
=20
-static void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, boo=
l on,
-				    bool ccp2_strobe)
+void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
+			     bool ccp2_strobe, bool strobe_clk_pol)
 {
 	u32 csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ
 		| OMAP343X_CONTROL_CSIRXFE_RESET;
@@ -85,6 +85,9 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy *ph=
y, u32 iface, bool on,
=20
 	if (ccp2_strobe)
 		csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_SELFORM;
+=09
+	if (strobe_clk_pol)
+		csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
=20
 	regmap_write(phy->isp->syscon, phy->isp->syscon_offset, csirxfe);
 }
@@ -108,7 +111,7 @@ static void csiphy_routing_cfg(struct isp_csiphy *phy,
 	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3630 && on)
 		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
 	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430)
-		return csiphy_routing_cfg_3430(phy, iface, on, ccp2_strobe);
+		return csiphy_routing_cfg_3430(phy, iface, on, ccp2_strobe, false);
 }
=20
 /*
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.h b/drivers/media/pl=
atform/omap3isp/ispcsiphy.h
index 28b63b2..88c5c1e8 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.h
+++ b/drivers/media/platform/omap3isp/ispcsiphy.h
@@ -40,4 +40,7 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
=20
+void csiphy_routing_cfg_3430(struct isp_csiphy *phy, u32 iface, bool on,
+				    bool ccp2_strobe, bool strobe_clk_pol);
+
 #endif	/* OMAP3_ISP_CSI_PHY_H */



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli38OMACgkQMOfwapXb+vJirgCfQlEpyDOVG/w6E6tKF6EQRKIH
8C8AnRowyBAhY5AGOWI2NdDac6ctY3Ev
=2Mj3
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
