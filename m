Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60962 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdCAMCa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 07:02:30 -0500
Date: Wed, 1 Mar 2017 12:45:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2
 mode
Message-ID: <20170301114545.GA19201@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <2414221.XNA4JCFMRx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ISP CSI1 module needs all the bits correctly set to work.

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

index ca09523..e6584a2 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -213,14 +236,17 @@ static int ccp2_phyif_config(struct isp_ccp2_device *=
ccp2,
 	struct isp_device *isp =3D to_isp_device(ccp2);
 	u32 val;
=20
-	/* CCP2B mode */
 	val =3D isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_CTRL) |
-			    ISPCCP2_CTRL_IO_OUT_SEL | ISPCCP2_CTRL_MODE;
+			    ISPCCP2_CTRL_MODE;
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


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli2tGkACgkQMOfwapXb+vILjQCgt/8J1EdriFx8v9VD4v+XLulD
h40AoL5CdLVTsISAFvZj7FYhcwf93K6H
=6rp0
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
