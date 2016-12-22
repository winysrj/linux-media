Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44995 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756730AbcLVWma (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 17:42:30 -0500
Date: Thu, 22 Dec 2016 23:42:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161222224226.GB31151@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <20161222143244.ykza4wdxmop2t7bg@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2016-12-22 15:32:44, Sebastian Reichel wrote:
> Hi Pavel,
>=20
> On Thu, Dec 22, 2016 at 02:39:38PM +0100, Pavel Machek wrote:
> > N900 contains front and back camera, with a switch between the
> > two. This adds support for the swich component.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > --
> >=20
> > I see this needs dts documentation, anything else than needs to be
> > done?
>=20
> Yes. This driver takes care of the switch gpio, but the cameras also
> use different bus settings. Currently omap3isp gets the bus-settings
> from the link connected to the CCP2 port in DT at probe time (*).
>=20
> So there are two general problems:
>=20
> 1. Settings must be applied before the streaming starts instead of
> at probe time, since the settings may change (based one the selected
> camera). That should be fairly easy to implement by just moving the
> code to the s_stream callback as far as I can see.
>=20
> 2. omap3isp should try to get the bus settings from using a callback
> in the connected driver instead of loading it from DT. Then the
> video-bus-switch can load the bus-settings from its downstream links
> in DT and propagate the correct ones to omap3isp based on the
> selected port. The DT loading part should actually remain in omap3isp
> as fallback, in case it does not find a callback in the connected driver.
> That way everything is backward compatible and the DT variant is
> nice for 1-on-1 scenarios.

So... did I understood it correctly? (Needs some work to be done...)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform=
/omap3isp/isp.c
index 45c69ed..1f44da1 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -702,6 +704,33 @@ static int isp_pipeline_enable(struct isp_pipeline *pi=
pe,
=20
 	entity =3D &pipe->output->video.entity;
 	while (1) {
+		struct v4l2_of_endpoint vep;
+		pad =3D &entity->pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+
+		pad =3D media_entity_remote_pad(pad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			break;
+
+		entity =3D pad->entity;
+		subdev =3D media_entity_to_v4l2_subdev(entity);
+
+	       	printk("Entity =3D %p\n", entity);
+		ret =3D v4l2_subdev_call(subdev, video, g_endpoint_config, &vep);
+		/* Is there better method than walking a list?
+		   Can I easily get dev and isd pointers here? */
+#if 0
+		if (ret =3D=3D 0) {
+			printk("success\n");
+			/* notifier->subdevs[notifier->num_subdevs] ... contains isd */
+			isp_endpoint_to_buscfg(dev, vep, isd->bus);
+		}
+#endif
+	}
+
+	entity =3D &pipe->output->video.entity;
+	while (1) {
 		pad =3D &entity->pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
@@ -2099,27 +2128,8 @@ static void isp_of_parse_node_csi2(struct device *de=
v,
 	buscfg->bus.csi2.crc =3D 1;
 }
=20
-static int isp_of_parse_node_endpoint(struct device *dev,
-				      struct device_node *node,
-				      struct isp_async_subdev *isd)
+static int isp_endpoint_to_buscfg(struct device *dev, struct v4l2_of_endpo=
int vep, struct isp_bus_cfg *buscfg)
 {
-	struct isp_bus_cfg *buscfg;
-	struct v4l2_of_endpoint vep;
-	int ret;
-
-	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
-	if (!isd->bus)
-		return -ENOMEM;
-
-	buscfg =3D isd->bus;
-
-	ret =3D v4l2_of_parse_endpoint(node, &vep);
-	if (ret)
-		return ret;
-
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
-		vep.base.port);
-
 	switch (vep.base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface =3D ISP_INTERFACE_PARALLEL;
@@ -2147,10 +2157,35 @@ static int isp_of_parse_node_endpoint(struct device=
 *dev,
 		break;
=20
 	default:
+		return -1;
+	}
+	return 0;
+}
+
+static int isp_of_parse_node_endpoint(struct device *dev,
+				      struct device_node *node,
+				      struct isp_async_subdev *isd)
+{
+	struct isp_bus_cfg *buscfg;
+	struct v4l2_of_endpoint vep;
+	int ret;
+
+	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
+	if (!isd->bus)
+		return -ENOMEM;
+
+	buscfg =3D isd->bus;
+
+	ret =3D v4l2_of_parse_endpoint(node, &vep);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
+		vep.base.port);
+
+	if (isp_endpoint_to_buscfg(dev, vep, buscfg))
 		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
 			 vep.base.port);
-		break;
-	}
=20
 	return 0;
 }
@@ -2262,6 +2297,10 @@ static int isp_of_parse_nodes(struct device *dev,
 	}
=20
 	return notifier->num_subdevs;
+
+error:
+	of_node_put(node);
+	return -EINVAL;
 }
=20
 static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/plat=
form/video-bus-switch.c
index 1a5d944..3a2d442 100644
--- a/drivers/media/platform/video-bus-switch.c
+++ b/drivers/media/platform/video-bus-switch.c
@@ -247,12 +247,21 @@ static int vbs_s_stream(struct v4l2_subdev *sd, int e=
nable)
 {
 	struct v4l2_subdev *subdev =3D vbs_get_remote_subdev(sd);
=20
+	/* FIXME: we need to set the GPIO here */
+
 	if (IS_ERR(subdev))
 		return PTR_ERR(subdev);
=20
 	return v4l2_subdev_call(subdev, video, s_stream, enable);
 }
=20
+static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct isp_bus_cf=
g *cfg)
+{
+	printk("vbs_g_endpoint_config...\n");
+	return 0;
+}
+
+
 static const struct v4l2_subdev_internal_ops vbs_internal_ops =3D {
 	.registered =3D &vbs_registered,
 };
@@ -265,6 +274,7 @@ static const struct media_entity_operations vbs_media_o=
ps =3D {
 /* subdev video operations */
 static const struct v4l2_subdev_video_ops vbs_video_ops =3D {
 	.s_stream =3D vbs_s_stream,
+	.g_endpoint_config =3D vbs_g_endpoint_config,
 };
=20
 static const struct v4l2_subdev_ops vbs_ops =3D {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..30457b0 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -415,6 +415,8 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*g_endpoint_config)(struct v4l2_subdev *sd,
+			    struct v4l2_of_endpoint *cfg);
 };
=20
 /**





--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhcVtIACgkQMOfwapXb+vJFFQCeKha0YQAkH3VnygPbIL4w0G4M
HDkAoLGG/tapDe0LgjtdQ0wxgyEkgUZe
=17LJ
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
