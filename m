Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36076 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754430AbdCBJH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 04:07:57 -0500
Date: Thu, 2 Mar 2017 10:07:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170302090727.GC27818@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Making the sub-device bus configuration a pointer should be in a separate
> patch. It makes sense since the entire configuration is not valid for all
> sub-devices attached to the ISP anymore. I think it originally was a
> separate patch, but they probably have been merged at some point. I can't
> find it right now anyway.

Something like this?
									Pavel

commit df9141c66678b549fac9d143bd55ed0b242cf36e
Author: Pavel <pavel@ucw.cz>
Date:   Wed Mar 1 13:27:56 2017 +0100

    Turn bus in struct isp_async_subdev into pointer; some of our subdevs
    (flash, focus) will not need bus configuration.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 8a456d4..36bd359 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2030,12 +2030,18 @@ enum isp_of_phy {
 static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
 			    struct isp_async_subdev *isd)
 {
-	struct isp_bus_cfg *buscfg =3D &isd->bus;
+	struct isp_bus_cfg *buscfg;
 	struct v4l2_fwnode_endpoint vfwn;
 	unsigned int i;
 	int ret;
 	bool csi1 =3D false;
=20
+	buscfg =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
+	if (!buscfg)
+		return -ENOMEM;
+
+	isd->bus =3D buscfg;
+
 	ret =3D v4l2_fwnode_endpoint_parse(fwn, &vfwn);
 	if (ret)
 		return ret;
@@ -2246,7 +2252,7 @@ static int isp_subdev_notifier_bound(struct v4l2_asyn=
c_notifier *async,
 		container_of(asd, struct isp_async_subdev, asd);
=20
 	isd->sd =3D subdev;
-	isd->sd->host_priv =3D &isd->bus;
+	isd->sd->host_priv =3D isd->bus;
=20
 	return 0;
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
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index f20abe8..be23408 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -202,7 +202,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *ph=
y)
 		struct isp_async_subdev *isd =3D
 			container_of(pipe->external->asd,
 				     struct isp_async_subdev, asd);
-		buscfg =3D &isd->bus;
+		buscfg =3D isd->bus;
 	}
=20
 	if (buscfg->interface =3D=3D ISP_INTERFACE_CCP2B_PHY1


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli34M8ACgkQMOfwapXb+vJe1wCffNltjuOWtDYEoa5pXXpshmVc
DlkAni2zQPEP4PV4YqEFF+UXGCiUi+GB
=vPNP
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
