Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56896 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752514AbdBCWZZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 17:25:25 -0500
Date: Sat, 4 Feb 2017 00:25:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Add video bus switch
Message-ID: <20170203222520.GE12291@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170112111731.GA27541@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112111731.GA27541@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Jan 12, 2017 at 12:17:31PM +0100, Pavel Machek wrote:
> On Sat 2016-12-24 16:20:31, Pavel Machek wrote:
> > 
> > N900 contains front and back camera, with a switch between the
> > two. This adds support for the switch component, and it is now
> > possible to select between front and back cameras during runtime.
> > 
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Can I get some feedback here? This works for me -- I can use both
> cameras during one boot -- can I get it applied?
> 
> Thanks,
> 								Pavel
> 
> > diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.txt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > new file mode 100644
> > index 0000000..1b9f8e0
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > @@ -0,0 +1,63 @@
> > +Video Bus Switch Binding
> > +========================
> > +
> > +This is a binding for a gpio controlled switch for camera interfaces. Such a
> > +device is used on some embedded devices to connect two cameras to the same
> > +interface of a image signal processor.
> > +
> > +Required properties
> > +===================
> > +
> > +compatible	: must contain "video-bus-switch"
> > +switch-gpios	: GPIO specifier for the gpio, which can toggle the
> > +		  selected camera. The GPIO should be configured, so
> > +		  that a disabled GPIO means, that the first port is
> > +		  selected.
> > +
> > +Required Port nodes
> > +===================
> > +
> > +More documentation on these bindings is available in
> > +video-interfaces.txt in the same directory.
> > +
> > +reg		: The interface:
> > +		  0 - port for image signal processor
> > +		  1 - port for first camera sensor
> > +		  2 - port for second camera sensor
> > +
> > +Example
> > +=======
> > +
> > +video-bus-switch {
> > +	compatible = "video-bus-switch"
> > +	switch-gpios = <&gpio1 1 GPIO_ACTIVE_HIGH>;
> > +
> > +	ports {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		port@0 {
> > +			reg = <0>;
> > +
> > +			csi_switch_in: endpoint {
> > +				remote-endpoint = <&csi_isp>;
> > +			};
> > +		};
> > +
> > +		port@1 {
> > +			reg = <1>;
> > +
> > +			csi_switch_out1: endpoint {
> > +				remote-endpoint = <&csi_cam1>;
> > +			};
> > +		};
> > +
> > +		port@2 {
> > +			reg = <2>;
> > +
> > +			csi_switch_out2: endpoint {
> > +				remote-endpoint = <&csi_cam2>;
> > +			};
> > +		};
> > +	};
> > +};
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index ce4a96f..a4b509e 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -91,6 +91,16 @@ config VIDEO_OMAP3_DEBUG
> >  	---help---
> >  	  Enable debug messages on OMAP 3 camera controller driver.
> >  
> > +config VIDEO_BUS_SWITCH
> > +	tristate "Video Bus switch"
> > +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> > +	depends on MEDIA_CONTROLLER
> > +	depends on OF
> > +	---help---
> > +	  Driver for a GPIO controlled video bus switch, which is used to
> > +	  connect two camera sensors to the same port a the image signal
> > +	  processor.
> > +
> >  config VIDEO_PXA27x
> >  	tristate "PXA27x Quick Capture Interface driver"
> >  	depends on VIDEO_DEV && HAS_DMA
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> > index 40b18d1..8eafc27 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -11,6 +11,8 @@ obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
> >  obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
> >  obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
> >  
> > +obj-$(CONFIG_VIDEO_BUS_SWITCH) += video-bus-switch.o
> > +
> >  obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
> >  
> >  obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
> > diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/platform/video-bus-switch.c
> > new file mode 100644
> > index 0000000..6400cfc
> > --- /dev/null
> > +++ b/drivers/media/platform/video-bus-switch.c
> > @@ -0,0 +1,387 @@
> > +/*
> > + * Generic driver for video bus switches
> > + *
> > + * Copyright (C) 2015 Sebastian Reichel <sre@kernel.org>
> > + * Copyright (C) 2016 Pavel Machek <pavel@ucw.cz>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + */
> > +
> > +#define DEBUG

Please remove.

> > +
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/of.h>
> > +#include <linux/of_graph.h>
> > +#include <linux/gpio/consumer.h>

Alphabetical order, please.

> > +#include <media/v4l2-async.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-of.h>
> > +
> > +/*
> > + * TODO:
> > + * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_nodes()
> > + */
> > +
> > +#define CSI_SWITCH_SUBDEVS 2
> > +#define CSI_SWITCH_PORTS 3

This could go to the enum below.

I guess the CSI_SWITCH_SUBDEVS could be (CSI_SWITCH_PORTS - 1).

I'd just replace CSI_SWITCH by VBS. The bus could be called differently.

> > +
> > +enum vbs_state {
> > +	CSI_SWITCH_DISABLED = 0,
> > +	CSI_SWITCH_PORT_1 = 1,
> > +	CSI_SWITCH_PORT_2 = 2,
> > +};
> > +
> > +struct vbs_src_pads {
> > +	struct media_entity *src;
> > +	int src_pad;
> > +};
> > +
> > +struct vbs_data {
> > +	struct gpio_desc *swgpio;
> > +	struct v4l2_subdev subdev;
> > +	struct v4l2_async_notifier notifier;
> > +	struct media_pad pads[CSI_SWITCH_PORTS];
> > +	struct vbs_src_pads src_pads[CSI_SWITCH_PORTS];
> > +	struct v4l2_of_endpoint vep[CSI_SWITCH_PORTS];
> > +	enum vbs_state state;
> > +};
> > +
> > +struct vbs_async_subdev {
> > +	struct v4l2_subdev *sd;
> > +	struct v4l2_async_subdev asd;
> > +	u8 port;
> > +};
> > +
> > +static int vbs_of_parse_nodes(struct device *dev, struct vbs_data *pdata)
> > +{
> > +	struct v4l2_async_notifier *notifier = &pdata->notifier;
> > +	struct device_node *node = NULL;
> > +
> > +	notifier->subdevs = devm_kcalloc(dev, CSI_SWITCH_SUBDEVS,
> > +		sizeof(*notifier->subdevs), GFP_KERNEL);
> > +	if (!notifier->subdevs)
> > +		return -ENOMEM;
> > +
> > +	notifier->num_subdevs = 0;
> > +	while (notifier->num_subdevs < CSI_SWITCH_SUBDEVS &&
> > +	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
> > +		struct v4l2_of_endpoint vep;
> > +		struct vbs_async_subdev *ssd;
> > +
> > +		/* skip first port (connected to isp) */
> > +		v4l2_of_parse_endpoint(node, &vep);
> > +		if (vep.base.port == 0) {
> > +			struct device_node *ispnode;
> > +
> > +			ispnode = of_graph_get_remote_port_parent(node);
> > +			if (!ispnode) {
> > +				dev_warn(dev, "bad remote port parent\n");
> > +				return -EINVAL;
> > +			}
> > +
> > +			of_node_put(node);
> > +			continue;
> > +		}
> > +
> > +		ssd = devm_kzalloc(dev, sizeof(*ssd), GFP_KERNEL);
> > +		if (!ssd) {
> > +			of_node_put(node);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		ssd->port = vep.base.port;
> > +
> > +		notifier->subdevs[notifier->num_subdevs] = &ssd->asd;
> > +
> > +		ssd->asd.match.of.node = of_graph_get_remote_port_parent(node);
> > +		of_node_put(node);
> > +		if (!ssd->asd.match.of.node) {
> > +			dev_warn(dev, "bad remote port parent\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		ssd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> > +		pdata->vep[notifier->num_subdevs] = vep;
> > +		notifier->num_subdevs++;
> > +	}
> > +
> > +	return notifier->num_subdevs;
> > +}
> > +
> > +static int vbs_registered(struct v4l2_subdev *sd)
> > +{
> > +	struct v4l2_device *v4l2_dev = sd->v4l2_dev;
> > +	struct vbs_data *pdata;
> > +	int err;
> > +
> > +	dev_dbg(sd->dev, "registered, init notifier...\n");

Looks like a development time debug message. :-)

> > +
> > +	pdata = v4l2_get_subdevdata(sd);
> > +
> > +	err = v4l2_async_notifier_register(v4l2_dev, &pdata->notifier);
> > +	if (err)
> > +		return err;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_subdev *vbs_get_remote_subdev(struct v4l2_subdev *sd)
> > +{
> > +	struct vbs_data *pdata = v4l2_get_subdevdata(sd);
> > +	struct media_entity *src;
> > +
> > +	if (pdata->state == CSI_SWITCH_DISABLED)
> > +		return ERR_PTR(-ENXIO);
> > +
> > +	src = pdata->src_pads[pdata->state].src;
> > +
> > +	return media_entity_to_v4l2_subdev(src);
> > +}
> > +
> > +static int vbs_link_setup(struct media_entity *entity,
> > +			  const struct media_pad *local,
> > +			  const struct media_pad *remote, u32 flags)
> > +{
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct vbs_data *pdata = v4l2_get_subdevdata(sd);
> > +	bool enable = flags & MEDIA_LNK_FL_ENABLED;
> > +
> > +	if (local->index > CSI_SWITCH_PORTS - 1)
> > +		return -ENXIO;
> > +
> > +	/* no configuration needed on source port */
> > +	if (local->index == 0)
> > +		return 0;
> > +
> > +	if (!enable) {
> > +		if (local->index == pdata->state) {
> > +			pdata->state = CSI_SWITCH_DISABLED;
> > +
> > +			/* Make sure we have both cameras enabled */
> > +			gpiod_set_value(pdata->swgpio, 1);
> > +			return 0;
> > +		} else {
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	/* there can only be one active sink at the same time */
> > +	if (pdata->state != CSI_SWITCH_DISABLED)
> > +		return -EBUSY;
> > +
> > +	dev_dbg(sd->dev, "Link setup: going to config %d\n", local->index);
> > +
> > +	gpiod_set_value(pdata->swgpio, local->index == CSI_SWITCH_PORT_2);
> > +	pdata->state = local->index;
> > +
> > +	sd = vbs_get_remote_subdev(sd);
> > +	if (IS_ERR(sd))
> > +		return PTR_ERR(sd);
> > +
> > +	pdata->subdev.ctrl_handler = sd->ctrl_handler;

This is ugly. You're exposing all the controls through another sub-device.

How does link validation work now?

I wonder if it'd be less so if you just pass through the LINK_FREQ and
PIXEL_RATE controls. It'll certainly be more code though.

I think the link frequency could be something that goes to the frame
descriptor as well. Then we wouldn't need to worry about the controls
separately, just passing the frame descriptor would be enough.

I apologise that I don't have patches quite ready for posting to the list.

> > +
> > +	return 0;
> > +}
> > +
> > +static int vbs_subdev_notifier_bound(struct v4l2_async_notifier *async,
> > +				     struct v4l2_subdev *subdev,
> > +				     struct v4l2_async_subdev *asd)
> > +{
> > +	struct vbs_data *pdata = container_of(async,
> > +		struct vbs_data, notifier);
> > +	struct vbs_async_subdev *ssd =
> > +		container_of(asd, struct vbs_async_subdev, asd);
> > +	struct media_entity *sink = &pdata->subdev.entity;
> > +	struct media_entity *src = &subdev->entity;
> > +	int sink_pad = ssd->port;
> > +	int src_pad;
> > +
> > +	if (sink_pad >= sink->num_pads) {
> > +		dev_err(pdata->subdev.dev, "no sink pad in internal entity!\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (src_pad = 0; src_pad < subdev->entity.num_pads; src_pad++) {
> > +		if (subdev->entity.pads[src_pad].flags & MEDIA_PAD_FL_SOURCE)
> > +			break;
> > +	}
> > +
> > +	if (src_pad >= src->num_pads) {
> > +		dev_err(pdata->subdev.dev, "no source pad in external entity\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	pdata->src_pads[sink_pad].src = src;
> > +	pdata->src_pads[sink_pad].src_pad = src_pad;
> > +	ssd->sd = subdev;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vbs_subdev_notifier_complete(struct v4l2_async_notifier *async)
> > +{
> > +	struct vbs_data *pdata = container_of(async, struct vbs_data, notifier);
> > +	struct media_entity *sink = &pdata->subdev.entity;
> > +	int sink_pad;
> > +
> > +	for (sink_pad = 1; sink_pad < CSI_SWITCH_PORTS; sink_pad++) {
> > +		struct media_entity *src = pdata->src_pads[sink_pad].src;
> > +		int src_pad = pdata->src_pads[sink_pad].src_pad;
> > +		int err;
> > +
> > +		err = media_create_pad_link(src, src_pad, sink, sink_pad, 0);
> > +		if (err < 0)
> > +			return err;
> > +
> > +		dev_dbg(pdata->subdev.dev, "create link: %s[%d] -> %s[%d])\n",
> > +			src->name, src_pad, sink->name, sink_pad);
> > +	}
> > +
> > +	return v4l2_device_register_subdev_nodes(pdata->subdev.v4l2_dev);

The ISP driver's complete() callback calls
v4l2_device_register_subdev_nodes() already. Currently it cannot handle
being called more than once --- that needs to be fixed.

> > +}
> > +
> > +static int vbs_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct v4l2_subdev *subdev = vbs_get_remote_subdev(sd);
> > +
> > +	if (IS_ERR(subdev))
> > +		return PTR_ERR(subdev);
> > +
> > +	return v4l2_subdev_call(subdev, video, s_stream, enable);
> > +}
> > +
> > +static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct v4l2_of_endpoint *cfg)
> > +{
> > +	struct vbs_data *pdata = v4l2_get_subdevdata(sd);
> > +	dev_dbg(sd->dev, "vbs_g_endpoint_config... active port is %d\n", pdata->state);
> > +	*cfg = pdata->vep[pdata->state - 1];
> > +
> > +	return 0;
> > +}
> > +
> > +

I'd say that's an extra newline.

> > +static const struct v4l2_subdev_internal_ops vbs_internal_ops = {
> > +	.registered = &vbs_registered,
> > +};
> > +
> > +static const struct media_entity_operations vbs_media_ops = {
> > +	.link_setup = vbs_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> > +};
> > +
> > +/* subdev video operations */
> > +static const struct v4l2_subdev_video_ops vbs_video_ops = {
> > +	.s_stream = vbs_s_stream,
> > +	.g_endpoint_config = vbs_g_endpoint_config,
> > +};
> > +
> > +static const struct v4l2_subdev_ops vbs_ops = {
> > +	.video = &vbs_video_ops,
> > +};
> > +
> > +static int video_bus_switch_probe(struct platform_device *pdev)
> > +{
> > +	struct vbs_data *pdata;
> > +	int err = 0;
> > +
> > +	/* platform data */
> > +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata) {
> > +		dev_dbg(&pdev->dev, "video-bus-switch: not enough memory\n");
> > +		return -ENOMEM;
> > +	}
> > +	platform_set_drvdata(pdev, pdata);
> > +
> > +	/* switch gpio */
> > +	pdata->swgpio = devm_gpiod_get(&pdev->dev, "switch", GPIOD_OUT_HIGH);
> > +	if (IS_ERR(pdata->swgpio)) {
> > +		err = PTR_ERR(pdata->swgpio);
> > +		dev_err(&pdev->dev, "Failed to request gpio: %d\n", err);
> > +		return err;
> > +	}
> > +
> > +	/* find sub-devices */
> > +	err = vbs_of_parse_nodes(&pdev->dev, pdata);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "Failed to parse nodes: %d\n", err);
> > +		return err;
> > +	}
> > +
> > +	pdata->state = CSI_SWITCH_DISABLED;
> > +	pdata->notifier.bound = vbs_subdev_notifier_bound;
> > +	pdata->notifier.complete = vbs_subdev_notifier_complete;
> > +
> > +	/* setup subdev */
> > +	pdata->pads[0].flags = MEDIA_PAD_FL_SOURCE;
> > +	pdata->pads[1].flags = MEDIA_PAD_FL_SINK;
> > +	pdata->pads[2].flags = MEDIA_PAD_FL_SINK;
> > +
> > +	v4l2_subdev_init(&pdata->subdev, &vbs_ops);
> > +	pdata->subdev.dev = &pdev->dev;
> > +	pdata->subdev.owner = pdev->dev.driver->owner;
> > +	strncpy(pdata->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);

How about sizeof(pdata->subdev.name) ?

I'm not sure I like V4L2_SUBDEV_NAME_SIZE in general. It could be even
removed. But not by this patch. :-)

> > +	v4l2_set_subdevdata(&pdata->subdev, pdata);
> > +	pdata->subdev.entity.function = MEDIA_ENT_F_SWITCH;
> > +	pdata->subdev.entity.flags |= MEDIA_ENT_F_SWITCH;

MEDIA_ENT_FL_*

> > +	pdata->subdev.entity.ops = &vbs_media_ops;
> > +	pdata->subdev.internal_ops = &vbs_internal_ops;
> > +	err = media_entity_pads_init(&pdata->subdev.entity, CSI_SWITCH_PORTS,
> > +				pdata->pads);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "Failed to init media entity: %d\n", err);
> > +		return err;
> > +	}
> > +
> > +	/* register subdev */
> > +	err = v4l2_async_register_subdev(&pdata->subdev);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "Failed to register v4l2 subdev: %d\n", err);
> > +		media_entity_cleanup(&pdata->subdev.entity);
> > +		return err;
> > +	}
> > +
> > +	dev_info(&pdev->dev, "video-bus-switch registered\n");

How about dev_dbg()?

> > +
> > +	return 0;
> > +}
> > +
> > +static int video_bus_switch_remove(struct platform_device *pdev)
> > +{
> > +	struct vbs_data *pdata = platform_get_drvdata(pdev);
> > +
> > +	v4l2_async_notifier_unregister(&pdata->notifier);

Shouldn't you unregister the notifier in the .unregister() callback?

> > +	v4l2_async_unregister_subdev(&pdata->subdev);
> > +	media_entity_cleanup(&pdata->subdev.entity);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id video_bus_switch_of_match[] = {
> > +	{ .compatible = "video-bus-switch" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, video_bus_switch_of_match);
> > +
> > +static struct platform_driver video_bus_switch_driver = {
> > +	.driver = {
> > +		.name	= "video-bus-switch",
> > +		.of_match_table = video_bus_switch_of_match,
> > +	},
> > +	.probe		= video_bus_switch_probe,
> > +	.remove		= video_bus_switch_remove,
> > +};
> > +
> > +module_platform_driver(video_bus_switch_driver);
> > +
> > +MODULE_AUTHOR("Sebastian Reichel <sre@kernel.org>");
> > +MODULE_DESCRIPTION("Video Bus Switch");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("platform:video-bus-switch");
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index cf778c5..448dbb5 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -25,6 +25,7 @@
> >  #include <media/v4l2-dev.h>
> >  #include <media/v4l2-fh.h>
> >  #include <media/v4l2-mediabus.h>
> > +#include <media/v4l2-of.h>
> >  
> >  /* generic v4l2_device notify callback notification values */
> >  #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
> > @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> >  			     const struct v4l2_mbus_config *cfg);
> >  	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> >  			   unsigned int *size);
> > +	int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > +			    struct v4l2_of_endpoint *cfg);

This should be in a separate patch --- assuming we'll add this one.

> >  };
> >  
> >  /**
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 4890787..94648ab 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -147,6 +147,7 @@ struct media_device_info {
> >   * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
> >   */
> >  #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> > +#define MEDIA_ENT_F_SWITCH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)

I wonder if MEDIA_ENT_F_PROC_ would be a better prefix.
We shouldn't have new entries in MEDIA_ENT_F_OLD_SUBDEV_BASE anymore.

> >  
> >  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
> >  
> > 
> > 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
