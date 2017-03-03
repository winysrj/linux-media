Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33599 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbdCCXYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 18:24:10 -0500
Date: Sat, 4 Mar 2017 00:24:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170303232400.GA6442@amd>
References: <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170302090727.GC27818@amd>
 <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
 <20170302145808.GA3315@amd>
 <20170302151321.GH3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20170302151321.GH3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > Making the sub-device bus configuration a pointer should be in a =
separate
> > > > > patch. It makes sense since the entire configuration is not valid=
 for all
> > > > > sub-devices attached to the ISP anymore. I think it originally wa=
s a
> > > > > separate patch, but they probably have been merged at some point.=
 I can't
> > > > > find it right now anyway.
> > > >=20
> > > > Something like this?
> > > >=20
> > > > commit df9141c66678b549fac9d143bd55ed0b242cf36e
> > > > Author: Pavel <pavel@ucw.cz>
> > > > Date:   Wed Mar 1 13:27:56 2017 +0100
> > > >=20
> > > >     Turn bus in struct isp_async_subdev into pointer; some of our s=
ubdevs
> > > >     (flash, focus) will not need bus configuration.
> > > >=20
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >=20
> > > I applied this to the ccp2 branch with an improved patch
> > > description.
> >=20
> > Thanks!
> >=20
> > [But the important part is to get subdevices to work on ccp2 based
> > branch, and it still fails to work at all if I attempt to enable
> > them. I'd like to understand why...]
>=20
> Did you add the flash / lens to the async list? The patches currently in =
the
> ccp branch do not include that --- it should be in parsing the flash /
> lens-focus properties in omap3isp device's node.

I retried, and it fails different way than I assumed. I might be able
to debug this one as sensor (and mplayer) still works.

Best regards,
								Pavel

--

    This is what subdevs support should look like, I guess; but I don't
    know fwnode stuff well enough.
   =20
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index c80397a..36bd359 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2166,6 +2166,8 @@ static int isp_fwnodes_parse(struct device *dev,
 			     struct v4l2_async_notifier *notifier)
 {
 	struct fwnode_handle *fwn =3D NULL;
+	struct device_node *node;
+	int flash =3D 0;
=20
 	notifier->subdevs =3D devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2199,6 +2201,42 @@ static int isp_fwnodes_parse(struct device *dev,
 		notifier->num_subdevs++;
 	}
=20
+	printk("Going through camera-flashes\n");
+	while (notifier->num_subdevs < ISP_MAX_SUBDEVS) {
+	       /* FIXME: fwnode_graph_get_remote_endpoint()
+	       (fwn =3D fwnode_graph_get_next_endpoint(device_fwnode_handle(dev),=
 fwn, ))  */
+		struct isp_async_subdev *isd;
+
+		node =3D of_parse_phandle(dev->of_node, "ti,camera-flashes", flash++);
+		flash++;
+		if (!node)
+			break;
+
+		printk("Having subdevice: %p\n", node);
+	=09
+#if 1
+		isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
+		if (!isd)
+			goto error;
+
+		notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
+
+
+		isd->asd.match.of.node =3D node;
+		if (!isd->asd.match.of.node) {
+			dev_warn(dev, "bad remote port parent\n");
+			goto error;
+		}
+
+		isd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
+		notifier->num_subdevs++;
+#endif
+	}
+
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

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli5+xAACgkQMOfwapXb+vKh1ACgxLNl8/uwoTnDapoXP0YtkqZo
0nkAoK8Wo7hXhxJDOCz6O2/qPJtT1NiA
=rigT
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
