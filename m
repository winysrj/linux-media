Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42637 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbdCDIz4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 03:55:56 -0500
Date: Sat, 4 Mar 2017 09:55:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170304085551.GA19769@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dobry den! :-)

> > > > Ok, I got the camera sensor to work. No subdevices support, so I do=
n't
> > > > have focus (etc) working, but that's a start. I also had to remove
> > > > video-bus-switch support; but I guess it will be easier to use
> > > > video-multiplexer patches...=20
> > > >=20
> > > > I'll have patches over weekend.
> > >=20
> > > I briefly looked at what's there --- you do miss the video nodes for =
the
> > > non-sensor sub-devices, and they also don't show up in the media grap=
h,
> > > right?
> >=20
> > Yes.
> >=20
> > > I guess they don't end up matching in the async list.
> >=20
> > How should they get to the async list?
>=20
> The patch you referred to does that. The problem is, it does make the bus
> configuration a pointer as well. There should be two patches. That's not a
> lot of work to separate them though. But it should be done.
>=20
> >=20
> > > I think we need to make the non-sensor sub-device support more generi=
c;
> > > it's not just the OMAP 3 ISP that needs it. I think we need to docume=
nt
> > > the property for the flash phandle as well; I can write one, or refre=
sh
> > > an existing one that I believe already exists.
> > >=20
> > > How about calling it either simply "flash" or "camera-flash"? Similar=
ly
> > > for lens: "lens" or "camera-lens". I have a vague feeling the "camera=
-"
> > > prefix is somewhat redundant, so I'd just go for "flash" or "lens".
> >=20
> > Actually, I'd go for "flash" and "focus-coil". There may be other
> > lens properties, such as zoom, mirror movement, lens identification,
> > ...
>=20
> Good point. Still there may be other ways to move the lens than the voice
> coil (which sure is cheap), so how about "flash" and "lens-focus"?

Ok, so something like this? (Yes, needs binding documentation and you
wanted it in the core.. can fix.)

BTW, fwnode_handle_put() seems to be missing in the success path of
isp_fwnodes_parse() -- can you check that?

Best regards,
								Pavel


diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index c80397a..6f6fbed 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2114,7 +2114,7 @@ static int isp_fwnode_parse(struct device *dev, struc=
t fwnode_handle *fwn,
 			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
 				vfwn.bus.mipi_csi1.lane_polarity[1];
=20
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", 0,
 				buscfg->bus.ccp2.lanecfg.data[0].pol,
 				buscfg->bus.ccp2.lanecfg.data[0].pos);
=20
@@ -2162,10 +2162,64 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwn,
 	return 0;
 }
=20
+static int camera_subdev_parse(struct device *dev, struct v4l2_async_notif=
ier *notifier,
+			       const char *key)
+{
+	struct device_node *node;
+	struct isp_async_subdev *isd;
+
+	printk("Looking for %s\n", key);
+=09
+	node =3D of_parse_phandle(dev->of_node, key, 0);
+	if (!node)
+		return 0;
+
+	printk("Having subdevice: %p\n", node);
+	=09
+	isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+	if (!isd)
+		return -ENOMEM;
+
+	notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
+
+	isd->asd.match.of.node =3D node;
+	if (!isd->asd.match.of.node) {
+		dev_warn(dev, "bad remote port parent\n");
+		return -EIO;
+	}
+
+	isd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
+	notifier->num_subdevs++;
+
+	return 0;
+}
+
+static int camera_subdevs_parse(struct device *dev, struct v4l2_async_noti=
fier *notifier,
+				int max)
+{
+	int res =3D 0;
+
+	printk("Going through camera-flashes\n");
+	if (notifier->num_subdevs < max) {
+		res =3D camera_subdev_parse(dev, notifier, "flash");
+		if (res)
+			return res;
+	}
+
+	if (notifier->num_subdevs < max) {
+		res =3D camera_subdev_parse(dev, notifier, "lens-focus");
+		if (res)
+			return res;
+	}
+=09
+	return 0;
+}
+
 static int isp_fwnodes_parse(struct device *dev,
 			     struct v4l2_async_notifier *notifier)
 {
 	struct fwnode_handle *fwn =3D NULL;
+	int res =3D 0;
=20
 	notifier->subdevs =3D devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2199,6 +2253,15 @@ static int isp_fwnodes_parse(struct device *dev,
 		notifier->num_subdevs++;
 	}
=20
+	/* FIXME: missing put in the success path? */
+
+	res =3D camera_subdevs_parse(dev, notifier, ISP_MAX_SUBDEVS);
+	if (res)
+		goto error;
+
+	if (notifier->num_subdevs =3D=3D ISP_MAX_SUBDEVS) {
+		printk("isp: Maybe too many devices?\n");
+	}
 	return notifier->num_subdevs;
=20
 error:


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli6gRcACgkQMOfwapXb+vKwwQCfUotuchmgrCXrpUZkt00mR8Sc
b3cAoMDfNNOBY3YADQLFFfcSPrlKkkzp
=Bqxz
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
