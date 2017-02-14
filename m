Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59122 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbdBNNk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:28 -0500
Date: Tue, 14 Feb 2017 14:40:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 09/13] media: Add video bus switch
Message-ID: <20170214134009.GA8590@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

N900 contains front and back camera, with a switch between the
two. This adds support for the switch component, and it is now
possible to select between front and back cameras during runtime.

FIXME: need to get acks and merge device tree support.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 .config                                   |   1 +
 drivers/media/platform/Kconfig            |  10 +
 drivers/media/platform/Makefile           |   2 +
 drivers/media/platform/omap3isp/ispccp2.c |  23 +-
 drivers/media/platform/video-bus-switch.c | 389 ++++++++++++++++++++++++++=
++++
 include/media/v4l2-subdev.h               |   9 +-
 include/uapi/linux/media.h                |   2 +
 7 files changed, 432 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/platform/video-bus-switch.c

diff --git a/.config b/.config
index 611fdb8..0f2bdd8 100644
--- a/.config
+++ b/.config
@@ -2128,6 +2128,7 @@ CONFIG_V4L_PLATFORM_DRIVERS=3Dy
 # CONFIG_VIDEO_OMAP2_VOUT is not set
 CONFIG_VIDEO_OMAP3=3Dy
 # CONFIG_VIDEO_OMAP3_DEBUG is not set
+CONFIG_VIDEO_BUS_SWITCH=3Dy
 # CONFIG_SOC_CAMERA is not set
 # CONFIG_VIDEO_XILINX is not set
 # CONFIG_V4L_MEM2MEM_DRIVERS is not set
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c9106e1..b35f11b 100644
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
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makef=
ile
index 349ddf6..6981319 100644
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
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/plat=
form/omap3isp/ispccp2.c
index 4edb55a..c2bc6b7 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -171,7 +171,7 @@ static int ccp2_if_enable(struct isp_ccp2_device *ccp2,=
 u8 enable)
=20
 		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
 		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
-		/* Struct isp_bus_cfg has union inside */
+		/* Struct isp_bus_cfg has union inside */=20
 		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
=20
=20
@@ -383,7 +383,7 @@ void __isp_of_parse_node_csi1(struct device *dev,
  */
 static int ccp2_if_configure(struct isp_ccp2_device *ccp2)
 {
-	const struct isp_bus_cfg *buscfg;
+	struct isp_bus_cfg *buscfg;
 	struct v4l2_mbus_framefmt *format;
 	struct media_pad *pad;
 	struct v4l2_subdev *sensor;
@@ -396,6 +396,25 @@ static int ccp2_if_configure(struct isp_ccp2_device *c=
cp2)
 	sensor =3D media_entity_to_v4l2_subdev(pad->entity);
 	buscfg =3D sensor->host_priv;
=20
+	{
+		struct v4l2_subdev *subdev2;
+		struct v4l2_of_endpoint vep;
+	=09
+		subdev2 =3D media_entity_to_v4l2_subdev(pad->entity);
+
+		printk("if_configure... subdev %p\n", subdev2);
+		/* fixme: vep.base.port is wrong? */
+		ret =3D v4l2_subdev_call(subdev2, video, g_endpoint_config, &vep);
+		printk("if_configure ret %d\n", ret);
+		if (ret =3D=3D 0) {
+			struct isp_ccp2_cfg prev_cfg =3D buscfg->bus.ccp2;
+			printk("Success: have configuration\n");
+			printk("Compare: %d\n", memcmp(&prev_cfg, &buscfg->bus.ccp2, sizeof(pre=
v_cfg)));		=09
+			__isp_of_parse_node_csi1(NULL, &buscfg->bus.ccp2, &vep);
+			printk("Configured ok?\n");
+		}
+	}
+
 	ret =3D ccp2_phyif_config(ccp2, &buscfg->bus.ccp2);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/plat=
form/video-bus-switch.c
new file mode 100644
index 0000000..1de611d
--- /dev/null
+++ b/drivers/media/platform/video-bus-switch.c
@@ -0,0 +1,389 @@
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
+#define DEBUG // FIXME: remove
+
+#include <linux/gpio/consumer.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+/*
+ * TODO:
+ * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_nodes()
+ */
+
+enum vbs_state {
+	VBS_DISABLED =3D 0,
+	VBS_PORT_1 =3D 1,
+	VBS_PORT_2 =3D 2,
+	VBS_PORTS =3D 3,
+};
+
+#define VBS_SUBDEVS (VBS_PORTS - 1)
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
+	struct media_pad pads[VBS_PORTS];
+	struct vbs_src_pads src_pads[VBS_PORTS];
+	struct v4l2_of_endpoint vep[VBS_PORTS];
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
+	notifier->subdevs =3D devm_kcalloc(dev, VBS_SUBDEVS,
+		sizeof(*notifier->subdevs), GFP_KERNEL);
+	if (!notifier->subdevs)
+		return -ENOMEM;
+
+	notifier->num_subdevs =3D 0;
+	while (notifier->num_subdevs < VBS_SUBDEVS &&
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
+
+	pdata =3D v4l2_get_subdevdata(sd);
+
+	return v4l2_async_notifier_register(v4l2_dev, &pdata->notifier);
+}
+
+static void vbs_unregistered(struct v4l2_subdev *sd)
+{
+	struct v4l2_device *v4l2_dev =3D sd->v4l2_dev;
+	struct vbs_data *pdata;
+
+	pdata =3D v4l2_get_subdevdata(sd);
+
+	v4l2_async_notifier_unregister(&pdata->notifier);
+}
+
+static struct v4l2_subdev *vbs_get_remote_subdev(struct v4l2_subdev *sd)
+{
+	struct vbs_data *pdata =3D v4l2_get_subdevdata(sd);
+	struct media_entity *src;
+
+	if (pdata->state =3D=3D VBS_DISABLED)
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
+	if (local->index > VBS_PORTS - 1)
+		return -ENXIO;
+
+	/* no configuration needed on source port */
+	if (local->index =3D=3D 0)
+		return 0;
+
+	if (!enable) {
+		if (local->index =3D=3D pdata->state) {
+			pdata->state =3D VBS_DISABLED;
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
+	if (pdata->state !=3D VBS_DISABLED)
+		return -EBUSY;
+
+	dev_dbg(sd->dev, "Link setup: going to config %d\n", local->index);
+
+	gpiod_set_value(pdata->swgpio, local->index =3D=3D VBS_PORT_2);
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
+	for (sink_pad =3D 1; sink_pad < VBS_PORTS; sink_pad++) {
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
+	/* FIXME: current ISP code may have problem with that */
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
+static const struct v4l2_subdev_internal_ops vbs_internal_ops =3D {
+	.registered =3D &vbs_registered,
+	.unregistered =3D &vbs_unregistered,
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
+//	.g_endpoint_config =3D vbs_g_endpoint_config,
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
+	pdata->state =3D VBS_DISABLED;
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
+	strncpy(pdata->subdev.name, dev_name(&pdev->dev), sizeof(pdata->subdev.na=
me));
+	v4l2_set_subdevdata(&pdata->subdev, pdata);
+	pdata->subdev.entity.function =3D MEDIA_ENT_F_PROC_VIDEO_SWITCH;
+	pdata->subdev.entity.ops =3D &vbs_media_ops;
+	pdata->subdev.internal_ops =3D &vbs_internal_ops;
+	err =3D media_entity_pads_init(&pdata->subdev.entity, VBS_PORTS,
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
+	dev_dbg(&pdev->dev, "video-bus-switch registered\n");
+
+	return 0;
+}
+
+static int video_bus_switch_remove(struct platform_device *pdev)
+{
+	struct vbs_data *pdata =3D platform_get_drvdata(pdev);
+
+	v4l2_async_unregister_subdev(&pdata->subdev);
+	media_entity_cleanup(&pdata->subdev.entity);
+
+	return 0;
+}
+
+static const struct of_device_id video_bus_switch_of_match[] =3D {
+	{ .compatible =3D "video-bus-switch-gpio" },
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
index 0ab1c5d..c6bb5fd 100644
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
@@ -351,7 +352,7 @@ struct v4l2_mbus_frame_desc {
  *	OUTPUT device. This is ignored by video capture devices.
  *
  * @g_input_status: get input status. Same as the status field in the
- *	&struct &v4l2_input
+ *	&struct &v4l2_input.
  *
  * @s_stream: used to notify the driver that a video stream will start or =
has
  *	stopped.
@@ -374,7 +375,7 @@ struct v4l2_mbus_frame_desc {
  *
  * @query_dv_timings: callback for %VIDIOC_QUERY_DV_TIMINGS ioctl handler =
code.
  *
- * @g_mbus_config: get supported mediabus configurations
+ * @g_mbus_config: get supported mediabus configurations.
  *
  * @s_mbus_config: set a certain mediabus configuration. This operation is=
 added
  *	for compatibility with soc-camera drivers and should not be used by new
@@ -383,6 +384,8 @@ struct v4l2_mbus_frame_desc {
  * @s_rx_buffer: set a host allocated memory buffer for the subdev. The su=
bdev
  *	can adjust @size to a lower value and must not write more data to the
  *	buffer starting at @data than the original value of @size.
+ *
+ * @g_endpoint_config: get link configuration required by this device.
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 confi=
g);
@@ -415,6 +418,8 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*g_endpoint_config)(struct v4l2_subdev *sd,
+			    struct v4l2_of_endpoint *cfg);
 };
=20
 /**
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4890787..a250456 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -103,6 +103,7 @@ struct media_device_info {
 #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
 #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
 #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
+#define MEDIA_ENT_F_PROC_VIDEO_SWITCH		(MEDIA_ENT_F_BASE + 0x4007)
=20
 /*
  * Connectors
@@ -148,6 +149,7 @@ struct media_device_info {
  */
 #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
=20
+
 #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
=20
 #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCLkACgkQMOfwapXb+vK7QgCgm20tUmAxMR9mwnrHYRbr+NSs
sxUAnjee+0JOKmkcRKiinfd3KCarBENy
=y5xS
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
