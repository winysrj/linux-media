Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48548 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMKhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 06:37:02 -0400
Date: Thu, 13 Jul 2017 12:36:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH] omap3isp: add CSI1 support
Message-ID: <20170713103659.GF1363@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

omap3isp: add CSI1 support
   =20
Use proper code path for csi1/ccp2 support.
   =20
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 24a9fc5..47210b1 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1149,6 +1149,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib =3D NULL;
 		}
+		ccp2->phy =3D &isp->isp_csiphy2;
 	} else if (isp->revision =3D=3D ISP_REVISION_15_0) {
 		ccp2->phy =3D &isp->isp_csiphy1;
 	}
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 50c0f64..a5ac2b40 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -197,9 +197,10 @@ static int omap3isp_csiphy_config(struct isp_csiphy *p=
hy)
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
 	/* Clock and data lanes verification */
@@ -302,13 +303,16 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
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
+
+		csiphy_power_autoswitch_enable(phy, true);
 	}
=20
-	csiphy_power_autoswitch_enable(phy, true);
 	phy->phy_in_use =3D 1;
=20
 done:
@@ -326,8 +330,10 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
=20
 		csiphy_routing_cfg(phy, buscfg->interface, false,
 				   buscfg->bus.ccp2.phy_layer);
-		csiphy_power_autoswitch_enable(phy, false);
-		csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
+		if (phy->isp->revision =3D=3D ISP_REVISION_15_0) {
+			csiphy_power_autoswitch_enable(phy, false);
+			csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
+		}
 		regulator_disable(phy->vdd);
 		phy->phy_in_use =3D 0;
 	}



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllnTUsACgkQMOfwapXb+vKRvwCgpdjeTYXRLDUprv/jG7ahj7H1
hTYAn199WFSH252+gKnLZ3A45AvvP6zY
=Ow9x
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
