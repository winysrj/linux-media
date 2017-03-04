Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55323 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbdCDTU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 14:20:27 -0500
Date: Sat, 4 Mar 2017 20:20:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170304192023.GB31766@amd>
References: <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
 <20170304085551.GA19769@amd>
 <20170304123010.GT3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <20170304123010.GT3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=C4=8C=C3=A1go Belo =C5=A0=C3=ADlenci! :-)

> > +static int camera_subdev_parse(struct device *dev, struct v4l2_async_n=
otifier *notifier,
> > +			       const char *key)
> > +{
> > +	struct device_node *node;
> > +	struct isp_async_subdev *isd;
> > +
> > +	printk("Looking for %s\n", key);
> > +=09
> > +	node =3D of_parse_phandle(dev->of_node, key, 0);
>=20
> There may be more than one flash associated with a sensor. Speaking of wh=
ich
> --- how is it associated to the sensors?
>=20
> One way to do this could be to simply move the flash property to the sens=
or
> OF node. We could have it here, too, if the flash was not associated with
> any sensor, but I doubt that will ever be needed.

I don't know what you mean here. Anyway, here's updated version.

Best regards,
								Pavel

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index c80397a..22d0e4a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2162,10 +2162,57 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwn,
 	return 0;
 }
=20
+static int camera_subdev_parse(struct device *dev, struct v4l2_async_notif=
ier *notifier,
+			       const char *key, int max)
+{
+	struct device_node *node;
+	struct isp_async_subdev *isd;
+	int num =3D 0;
+
+	printk("Looking for %s\n", key);
+
+	while (notifier->num_subdevs < max) {
+		node =3D of_parse_phandle(dev->of_node, key, num++);
+		if (!node)
+			return 0;
+
+		printk("Having subdevice: %p\n", node);
+	=09
+		isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+		if (!isd)
+			return -ENOMEM;
+
+		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
+
+		isd->asd.match.fwnode.fwn =3D of_fwnode_handle(node);
+		isd->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
+		notifier->num_subdevs++;
+	}
+
+	return 0;
+}
+
+static int camera_subdevs_parse(struct device *dev, struct v4l2_async_noti=
fier *notifier,
+				int max)
+{
+	int res;
+
+	res =3D camera_subdev_parse(dev, notifier, "flash", max);
+	if (res)
+		return res;
+
+	res =3D camera_subdev_parse(dev, notifier, "lens-focus", max);
+	if (res)
+		return res;
+=09
+	return 0;
+}
+
 static int isp_fwnodes_parse(struct device *dev,
 			     struct v4l2_async_notifier *notifier)
 {
 	struct fwnode_handle *fwn =3D NULL;
+	int res;
=20
 	notifier->subdevs =3D devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2199,6 +2246,15 @@ static int isp_fwnodes_parse(struct device *dev,
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

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli7E3cACgkQMOfwapXb+vJO5gCeN8VCvGMtuDQ6o4J2E9fu6449
nk8An2G8fjNsCqqjzFSZfolvL3MuN515
=UZ/I
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
