Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59547 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932425AbdBHNLd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 08:11:33 -0500
Date: Wed, 8 Feb 2017 14:11:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] smiapp: add CCP2 support
Message-ID: <20170208131127.GA29237@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Add support for CCP2 connected SMIA sensors as found
on the Nokia N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smi=
app/smiapp-core.c
index 44f8c7e..c217bc6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2997,13 +2997,19 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(=
struct device *dev)
 	switch (bus_cfg->bus_type) {
 	case V4L2_MBUS_CSI2:
 		hwcfg->csi_signalling_mode =3D SMIAPP_CSI_SIGNALLING_MODE_CSI2;
+		hwcfg->lanes =3D bus_cfg->bus.mipi_csi2.num_data_lanes;
+		break;
+	case V4L2_MBUS_CCP2:
+		hwcfg->csi_signalling_mode =3D (bus_cfg->bus.mipi_csi1.strobe) ?
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE :
+		SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK;
+		hwcfg->lanes =3D 1;
 		break;
-		/* FIXME: add CCP2 support. */
 	default:
+		dev_err(dev, "unknown bus protocol\n");
 		goto out_err;
 	}
=20
-	hwcfg->lanes =3D bus_cfg->bus.mipi_csi2.num_data_lanes;
 	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
=20
 	/* NVM size is not mandatory */
@@ -3017,8 +3023,8 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(st=
ruct device *dev)
 		goto out_err;
 	}
=20
-	dev_dbg(dev, "nvm %d, clk %d, csi %d\n", hwcfg->nvm_size,
-		hwcfg->ext_clk, hwcfg->csi_signalling_mode);
+	dev_dbg(dev, "nvm %d, clk %d, mode %d\n",
+		hwcfg->nvm_size, hwcfg->ext_clk, hwcfg->csi_signalling_mode);
=20
 	if (!bus_cfg->nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined\n");

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlibGP8ACgkQMOfwapXb+vKquQCeJ7P0nxm1on/HHn+rP9/qJdeB
faUAn0tdzu87ygAhBWOR5fnzayO11APe
=cTNE
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
