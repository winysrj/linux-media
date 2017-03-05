Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45822 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbdCEOWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 09:22:49 -0500
Date: Sun, 5 Mar 2017 15:13:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] omap3isp: add support for CSI1 bus
Message-ID: <20170305141347.GA28830@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
 <20170302090143.GB27818@amd>
 <20170302101603.GE27818@amd>
 <20170302112401.GF3220@valkosipuli.retiisi.org.uk>
 <20170302123848.GA28230@amd>
 <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20170304130318.GU3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This will probably fail.
> >=20
> > 	        rval =3D omap3isp_csi2_reset(phy->csi2);
> > 	        if (rval < 0)
> > 		                goto done;
>=20
> Could you try to two patches I've applied on the ccp2 branch (I'll remove
> them if there are issues).
>=20
> That's compile tested for now only.

They help a lot. Now I can use similar code paths...

Not yet a mergeable patch, but already better than it was.

Thanks and best regards,
									Pavel


diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 24a9fc5..79838bd 100644
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
@@ -1149,6 +1170,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib =3D NULL;
 		}
+		ccp2->phy =3D &isp->isp_csiphy2;
 	} else if (isp->revision =3D=3D ISP_REVISION_15_0) {
 		ccp2->phy =3D &isp->isp_csiphy1;
 	}
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 50c0f64..94461df 100644
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
@@ -197,27 +200,40 @@ static int omap3isp_csiphy_config(struct isp_csiphy *=
phy)
 	}
=20
 	if (buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY1
-	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2)
+	    || buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY2) {
 		lanes =3D &buscfg->bus.ccp2.lanecfg;
-	else
+		phy->num_data_lanes =3D 1;
+	} else
 		lanes =3D &buscfg->bus.csi2.lanecfg;
=20
+	printk("lane verification... %d\n", phy->num_data_lanes);
+
 	/* Clock and data lanes verification */
 	for (i =3D 0; i < phy->num_data_lanes; i++) {
-		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
-			return -EINVAL;
+		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3) {
+			printk("Bad cfg\n");
+			//return -EINVAL;
+		}
=20
-		if (used_lanes & (1 << lanes->data[i].pos))
-			return -EINVAL;
+		if (used_lanes & (1 << lanes->data[i].pos)) {
+			printk("Already used\n");
+			//return -EINVAL;
+		}
=20
 		used_lanes |=3D 1 << lanes->data[i].pos;
 	}
=20
-	if (lanes->clk.pol > 1 || lanes->clk.pos > 3)
-		return -EINVAL;
+	printk("used lanes... %d\n", used_lanes);=09
=20
-	if (lanes->clk.pos =3D=3D 0 || used_lanes & (1 << lanes->clk.pos))
-		return -EINVAL;
+	if (lanes->clk.pol > 1 || lanes->clk.pos > 3) {
+		printk("Bad clock\n");
+		//return -EINVAL;
+	}
+
+	if (lanes->clk.pos =3D=3D 0 || used_lanes & (1 << lanes->clk.pos)) {
+		printk("Reused clock\n");
+		//return -EINVAL;
+	}
=20
 	/*
 	 * The PHY configuration is lost in off mode, that's not an
@@ -302,13 +318,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 	if (rval < 0)
 		goto done;
=20
-	rval =3D csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
-	if (rval) {
-		regulator_disable(phy->vdd);
-		goto done;
+	if (phy->isp->revision =3D=3D ISP_REVISION_15_0) {
+		rval =3D csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
+		if (rval) {
+			regulator_disable(phy->vdd);
+			goto done;
+		}
+	=09
+		csiphy_power_autoswitch_enable(phy, true);	=09
 	}
=20
-	csiphy_power_autoswitch_enable(phy, true);
 	phy->phy_in_use =3D 1;
=20
 done:

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli8HRsACgkQMOfwapXb+vK/ZgCfasdKWRRraxu/YYp5e3CdTwG4
+ZgAoMCj/jN6KDWkiY827IJyBfyseora
=ezM5
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
