Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35186 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbdBTMGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 07:06:51 -0500
Date: Mon, 20 Feb 2017 13:06:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH] omap3isp: avoid uninitialized memory
Message-ID: <20170220120647.GA19951@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <2414221.XNA4JCFMRx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Code in ispcsiphy is quite confusing, and does not initialize phy1 in
case of isp rev. 2. Set it to zero, to prevent confusion.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

index 8f73f6d..a2474b6 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -362,14 +374,16 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	phy2->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY2;
 	mutex_init(&phy2->mutex);
=20
-	if (isp->revision =3D=3D ISP_REVISION_15_0) {
-		phy1->isp =3D isp;
-		phy1->csi2 =3D &isp->isp_csi2c;
-		phy1->num_data_lanes =3D ISP_CSIPHY1_NUM_DATA_LANES;
-		phy1->cfg_regs =3D OMAP3_ISP_IOMEM_CSI2C_REGS1;
-		phy1->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY1;
-		mutex_init(&phy1->mutex);
+	if (isp->revision !=3D ISP_REVISION_15_0) {
+		memset(phy1, sizeof(*phy1), 0);
+		return 0;
 	}
=20
+	phy1->isp =3D isp;
+	phy1->csi2 =3D &isp->isp_csi2c;
+	phy1->num_data_lanes =3D ISP_CSIPHY1_NUM_DATA_LANES;
+	phy1->cfg_regs =3D OMAP3_ISP_IOMEM_CSI2C_REGS1;
+	phy1->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY1;
+	mutex_init(&phy1->mutex);
 	return 0;
 }


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliq29cACgkQMOfwapXb+vJ1FgCghP4v8/SWR9Vabwt88Bvg6rzV
ZzEAn1lLXlS7D8cKbOPblqyTP7K0GWBt
=R5L+
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
