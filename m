Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46905 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdBCVGO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 16:06:14 -0500
Date: Fri, 3 Feb 2017 22:06:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203210610.GA18379@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> My apologies for the delays in reviewing. Feel free to ping me in the fut=
ure
> if this happens. :-)

No problem :-). If you could review the C-code, too... that would be
nice. It should be in your inbox somewhere (and I attached it below,
without the dts part).


> > +Required properties
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +compatible	: must contain "video-bus-switch"
>=20
> How generic is this? Should we have e.g. nokia,video-bus-switch? And if s=
o,
> change the file name accordingly.

Generic for "single GPIO controls the switch", AFAICT. But that should
be common enough...

> > +reg		: The interface:
> > +		  0 - port for image signal processor
> > +		  1 - port for first camera sensor
> > +		  2 - port for second camera sensor
>=20
> I'd say this must be pretty much specific to the one in N900. You could h=
ave
> more ports. Or you could say that ports beyond 0 are camera sensors. I gu=
ess
> this is good enough for now though, it can be changed later on with the
> source if a need arises.

Well, I'd say that selecting between two sensors is going to be the
common case. If someone needs more than two, it will no longer be
simple GPIO, so we'll have some fixing to do.

> Btw. was it still considered a problem that the endpoint properties for t=
he
> sensors can be different? With the g_routing() pad op which is to be adde=
d,
> the ISP driver (should actually go to a framework somewhere) could parse =
the
> graph and find the proper endpoint there.

I don't know about g_routing. I added g_endpoint_config method that
passes the configuration, and that seems to work for me.

I don't see g_routing in next-20170201 . Is there place to look?

Best regards,
								Pavel

---

N900 contains front and back camera, with a switch between the
two. This adds support for the switch component, and it is now
possible to select between front and back cameras during runtime.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ce4a96f..a4b509e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,6 +91,16 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.
=20
+config VIDEO_BUS_SWITCH
+	tristate "Video Bus switch"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on MEDIA_CONTROLLER
+	depends on OF
+	---help---
+	  Driver for a GPIO controlled video bus switch, which is used to
+	  connect two camera sensors to the same port a the image signal
+	  processor.
+
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
 	depends on VIDEO_DEV && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makef=
ile
index 40b18d1..8eafc27 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) +=3D marvell-ccic/
 obj-$(CONFIG_VIDEO_OMAP3)	+=3D omap3isp/
 obj-$(CONFIG_VIDEO_PXA27x)	+=3D pxa_camera.o
=20
+obj-$(CONFIG_VIDEO_BUS_SWITCH) +=3D video-bus-switch.o
+
 obj-$(CONFIG_VIDEO_VIU) +=3D fsl-viu.o
=20
 obj-$(CONFIG_VIDEO_VIVID)		+=3D vivid/
diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/plat=
form/video-bus-switch.c
new file mode 100644
index 0000000..6400cfc
--- /dev/null
+++ b/drivers/media/platform/video-bus-switch.c
@@ -0,0 +1,387 @@
+/*
+ * Generic driver for video bus switches
+ *
+ * Copyright (C) 2015 Sebastian Reichel <sre@kernel.org>
+ * Copyright (C) 2016 Pavel Machek <pavel@ucw.cz>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#define DEBUG
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/gpio/consumer.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+/*
+ * TODO:
+ * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_nodes()
+ */
+
+#define CSI_SWITCH_SUBDEVS 2
+#define CSI_SWITCH_PORTS 3
+
+enum vbs_state {
+	CSI_SWITCH_DISABLED =3D 0,
+	CSI_SWITCH_PORT_1 =3D 1,
+	CSI_SWITCH_PORT_2 =3D 2,
+};
+
+struct vbs_src_pads {
+	struct media_entity *src;
+	int src_pad;
+};
+
+struct vbs_data {
+	struct gpio_desc *swgpio;
+	struct v4l2_subdev subdev;
+	struct v4l2_async_notifier notifier;
+	struct media_pad pads[CSI_SWITCH_PORTS];
+	struct vbs_src_pads src_pads[CSI_SWITCH_PORTS];
+	struct v4l2_of_endpoint vep[CSI_SWITCH_PORTS];
+	enum vbs_state state;
+};
+
+struct vbs_async_subdev {
+	struct v4l2_subdev *sd;
+	struct v4l2_async_subdev asd;
+	u8 port;
+};
+
+static int vbs_of_parse_nodes(struct device *dev, struct vbs_data *pdata)
+{
+	struct v4l2_async_notifier *notifier =3D &pdata->notifier;
+	struct device_node *node =3D NULL;
+
+	notifier->subdevs =3D devm_kcalloc(dev, CSI_SWITCH_SUBDEVS,
+		sizeof(*notifier->subdevs), GFP_KERNEL);
+	if (!notifier->subdevs)
+		return -ENOMEM;
+
+	notifier->num_subdevs =3D 0;
+	while (notifier->num_subdevs < CSI_SWITCH_SUBDEVS &&
+	       (node =3D of_graph_get_next_endpoint(dev->of_node, node))) {
+		struct v4l2_of_endpoint vep;
+		struct vbs_async_subdev *ssd;
+
+		/* skip first port (connected to isp) */
+		v4l2_of_parse_endpoint(node, &vep);
+		if (vep.base.port =3D=3D 0) {
+			struct device_node *ispnode;
+
+			ispnode =3D of_graph_get_remote_port_parent(node);
+			if (!ispnode) {
+				dev_warn(dev, "bad remote port parent\n");
+				return -EINVAL;
+			}
+
+			of_node_put(node);
+			continue;
+		}
+
+		ssd =3D devm_kzalloc(dev, sizeof(*ssd), GFP_KERNEL);
+		if (!ssd) {
+			of_node_put(node);
+			return -ENOMEM;
+		}
+
+		ssd->port =3D vep.base.port;
+
+		notifier->subdevs[notifier->num_subdevs] =3D &ssd->asd;
+
+		ssd->asd.match.of.node =3D of_graph_get_remote_port_parent(node);
+		of_node_put(node);
+		if (!ssd->asd.match.of.node) {
+			dev_warn(dev, "bad remote port parent\n");
+			return -EINVAL;
+		}
+
+		ssd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
+		pdata->vep[notifier->num_subdevs] =3D vep;
+		notifier->num_subdevs++;
+	}
+
+	return notifier->num_subdevs;
+}
+
+static int vbs_registered(struct v4l2_subdev *sd)
+{
+	struct v4l2_device *v4l2_dev =3D sd->v4l2_dev;
+	struct vbs_data *pdata;
+	int err;
+
+	dev_dbg(sd->dev, "registered, init notifier...\n");
+
+	pdata =3D v4l2_get_subdevdata(sd);
+
+	err =3D v4l2_async_notifier_register(v4l2_dev, &pdata->notifier);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static struct v4l2_subdev *vbs_get_remote_subdev(struct v4l2_subdev *sd)
+{
+	struct vbs_data *pdata =3D v4l2_get_subdevdata(sd);
+	struct media_entity *src;
+
+	if (pdata->state =3D=3D CSI_SWITCH_DISABLED)
+		return ERR_PTR(-ENXIO);
+
+	src =3D pdata->src_pads[pdata->state].src;
+
+	return media_entity_to_v4l2_subdev(src);
+}
+
+static int vbs_link_setup(struct media_entity *entity,
+			  const struct media_pad *local,
+			  const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd =3D media_entity_to_v4l2_subdev(entity);
+	struct vbs_data *pdata =3D v4l2_get_subdevdata(sd);
+	bool enable =3D flags & MEDIA_LNK_FL_ENABLED;
+
+	if (local->index > CSI_SWITCH_PORTS - 1)
+		return -ENXIO;
+
+	/* no configuration needed on source port */
+	if (local->index =3D=3D 0)
+		return 0;
+
+	if (!enable) {
+		if (local->index =3D=3D pdata->state) {
+			pdata->state =3D CSI_SWITCH_DISABLED;
+
+			/* Make sure we have both cameras enabled */
+			gpiod_set_value(pdata->swgpio, 1);
+			return 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	/* there can only be one active sink at the same time */
+	if (pdata->state !=3D CSI_SWITCH_DISABLED)
+		return -EBUSY;
+
+	dev_dbg(sd->dev, "Link setup: going to config %d\n", local->index);
+
+	gpiod_set_value(pdata->swgpio, local->index =3D=3D CSI_SWITCH_PORT_2);
+	pdata->state =3D local->index;
+
+	sd =3D vbs_get_remote_subdev(sd);
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+
+	pdata->subdev.ctrl_handler =3D sd->ctrl_handler;
+
+	return 0;
+}
+
+static int vbs_subdev_notifier_bound(struct v4l2_async_notifier *async,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
+{
+	struct vbs_data *pdata =3D container_of(async,
+		struct vbs_data, notifier);
+	struct vbs_async_subdev *ssd =3D
+		container_of(asd, struct vbs_async_subdev, asd);
+	struct media_entity *sink =3D &pdata->subdev.entity;
+	struct media_entity *src =3D &subdev->entity;
+	int sink_pad =3D ssd->port;
+	int src_pad;
+
+	if (sink_pad >=3D sink->num_pads) {
+		dev_err(pdata->subdev.dev, "no sink pad in internal entity!\n");
+		return -EINVAL;
+	}
+
+	for (src_pad =3D 0; src_pad < subdev->entity.num_pads; src_pad++) {
+		if (subdev->entity.pads[src_pad].flags & MEDIA_PAD_FL_SOURCE)
+			break;
+	}
+
+	if (src_pad >=3D src->num_pads) {
+		dev_err(pdata->subdev.dev, "no source pad in external entity\n");
+		return -EINVAL;
+	}
+
+	pdata->src_pads[sink_pad].src =3D src;
+	pdata->src_pads[sink_pad].src_pad =3D src_pad;
+	ssd->sd =3D subdev;
+
+	return 0;
+}
+
+static int vbs_subdev_notifier_complete(struct v4l2_async_notifier *async)
+{
+	struct vbs_data *pdata =3D container_of(async, struct vbs_data, notifier);
+	struct media_entity *sink =3D &pdata->subdev.entity;
+	int sink_pad;
+
+	for (sink_pad =3D 1; sink_pad < CSI_SWITCH_PORTS; sink_pad++) {
+		struct media_entity *src =3D pdata->src_pads[sink_pad].src;
+		int src_pad =3D pdata->src_pads[sink_pad].src_pad;
+		int err;
+
+		err =3D media_create_pad_link(src, src_pad, sink, sink_pad, 0);
+		if (err < 0)
+			return err;
+
+		dev_dbg(pdata->subdev.dev, "create link: %s[%d] -> %s[%d])\n",
+			src->name, src_pad, sink->name, sink_pad);
+	}
+
+	return v4l2_device_register_subdev_nodes(pdata->subdev.v4l2_dev);
+}
+
+static int vbs_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct v4l2_subdev *subdev =3D vbs_get_remote_subdev(sd);
+
+	if (IS_ERR(subdev))
+		return PTR_ERR(subdev);
+
+	return v4l2_subdev_call(subdev, video, s_stream, enable);
+}
+
+static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct v4l2_of_en=
dpoint *cfg)
+{
+	struct vbs_data *pdata =3D v4l2_get_subdevdata(sd);
+	dev_dbg(sd->dev, "vbs_g_endpoint_config... active port is %d\n", pdata->s=
tate);
+	*cfg =3D pdata->vep[pdata->state - 1];
+
+	return 0;
+}
+
+
+static const struct v4l2_subdev_internal_ops vbs_internal_ops =3D {
+	.registered =3D &vbs_registered,
+};
+
+static const struct media_entity_operations vbs_media_ops =3D {
+	.link_setup =3D vbs_link_setup,
+	.link_validate =3D v4l2_subdev_link_validate,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops vbs_video_ops =3D {
+	.s_stream =3D vbs_s_stream,
+	.g_endpoint_config =3D vbs_g_endpoint_config,
+};
+
+static const struct v4l2_subdev_ops vbs_ops =3D {
+	.video =3D &vbs_video_ops,
+};
+
+static int video_bus_switch_probe(struct platform_device *pdev)
+{
+	struct vbs_data *pdata;
+	int err =3D 0;
+
+	/* platform data */
+	pdata =3D devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_dbg(&pdev->dev, "video-bus-switch: not enough memory\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, pdata);
+
+	/* switch gpio */
+	pdata->swgpio =3D devm_gpiod_get(&pdev->dev, "switch", GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->swgpio)) {
+		err =3D PTR_ERR(pdata->swgpio);
+		dev_err(&pdev->dev, "Failed to request gpio: %d\n", err);
+		return err;
+	}
+
+	/* find sub-devices */
+	err =3D vbs_of_parse_nodes(&pdev->dev, pdata);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to parse nodes: %d\n", err);
+		return err;
+	}
+
+	pdata->state =3D CSI_SWITCH_DISABLED;
+	pdata->notifier.bound =3D vbs_subdev_notifier_bound;
+	pdata->notifier.complete =3D vbs_subdev_notifier_complete;
+
+	/* setup subdev */
+	pdata->pads[0].flags =3D MEDIA_PAD_FL_SOURCE;
+	pdata->pads[1].flags =3D MEDIA_PAD_FL_SINK;
+	pdata->pads[2].flags =3D MEDIA_PAD_FL_SINK;
+
+	v4l2_subdev_init(&pdata->subdev, &vbs_ops);
+	pdata->subdev.dev =3D &pdev->dev;
+	pdata->subdev.owner =3D pdev->dev.driver->owner;
+	strncpy(pdata->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
+	v4l2_set_subdevdata(&pdata->subdev, pdata);
+	pdata->subdev.entity.function =3D MEDIA_ENT_F_SWITCH;
+	pdata->subdev.entity.flags |=3D MEDIA_ENT_F_SWITCH;
+	pdata->subdev.entity.ops =3D &vbs_media_ops;
+	pdata->subdev.internal_ops =3D &vbs_internal_ops;
+	err =3D media_entity_pads_init(&pdata->subdev.entity, CSI_SWITCH_PORTS,
+				pdata->pads);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to init media entity: %d\n", err);
+		return err;
+	}
+
+	/* register subdev */
+	err =3D v4l2_async_register_subdev(&pdata->subdev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to register v4l2 subdev: %d\n", err);
+		media_entity_cleanup(&pdata->subdev.entity);
+		return err;
+	}
+
+	dev_info(&pdev->dev, "video-bus-switch registered\n");
+
+	return 0;
+}
+
+static int video_bus_switch_remove(struct platform_device *pdev)
+{
+	struct vbs_data *pdata =3D platform_get_drvdata(pdev);
+
+	v4l2_async_notifier_unregister(&pdata->notifier);
+	v4l2_async_unregister_subdev(&pdata->subdev);
+	media_entity_cleanup(&pdata->subdev.entity);
+
+	return 0;
+}
+
+static const struct of_device_id video_bus_switch_of_match[] =3D {
+	{ .compatible =3D "video-bus-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, video_bus_switch_of_match);
+
+static struct platform_driver video_bus_switch_driver =3D {
+	.driver =3D {
+		.name	=3D "video-bus-switch",
+		.of_match_table =3D video_bus_switch_of_match,
+	},
+	.probe		=3D video_bus_switch_probe,
+	.remove		=3D video_bus_switch_remove,
+};
+
+module_platform_driver(video_bus_switch_driver);
+
+MODULE_AUTHOR("Sebastian Reichel <sre@kernel.org>");
+MODULE_DESCRIPTION("Video Bus Switch");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:video-bus-switch");
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5..448dbb5 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -25,6 +25,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-of.h>
=20
 /* generic v4l2_device notify callback notification values */
 #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
@@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*g_endpoint_config)(struct v4l2_subdev *sd,
+			    struct v4l2_of_endpoint *cfg);
 };
=20
 /**
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4890787..94648ab 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -147,6 +147,7 @@ struct media_device_info {
  * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
  */
 #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
+#define MEDIA_ENT_F_SWITCH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)
=20
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
=20


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliU8MIACgkQMOfwapXb+vIOQwCfRgwVQTY6HK2lc0swIxQ7/8cd
BloAnjZwBAEhdHTZ58NmwoCYcQbbRzEy
=dGRS
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
