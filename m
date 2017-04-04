Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43604 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753471AbdDDMsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 08:48:12 -0400
Date: Tue, 4 Apr 2017 15:47:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v6 17/39] platform: add video-multiplexer subdevice driver
Message-ID: <20170404124732.GD3288@valkosipuli.retiisi.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Philipp and Pavel,

On Mon, Mar 27, 2017 at 05:40:34PM -0700, Steve Longerbeam wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
> 
> This driver can handle SoC internal and external video bus multiplexers,
> controlled either by register bit fields or by a GPIO. The subdevice
> passes through frame interval and mbus configuration of the active input
> to the output side.

The MUX framework is already in linux-next. Could you use that instead of
adding new driver + bindings that are not compliant with the MUX framework?
I don't think it'd be much of a change in terms of code, using the MUX
framework appears quite simple.

In general the driver looks pretty good, especially regarding the user space
API implementation which is important for use with other drivers.

I have some more detailed comments below.

> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> - fixed a cut&paste error in vidsw_remove(): v4l2_async_register_subdev()
>   should be unregister.
> 
> - added media_entity_cleanup() to vidsw_remove().
> 
> - added missing MODULE_DEVICE_TABLE().
>   Suggested-by: Javier Martinez Canillas <javier@dowhile0.org>
> 
> - there was a line left over from a previous iteration that negated
>   the new way of determining the pad count just before it which
>   has been removed (num_pads = of_get_child_count(np)).
> 
> - removed [gs]_frame_interval ops. timeperframe is not used anywhwere
>   in this subdev, and currently it has no control over frame rate.
> 
> - add link_validate to media_entity_operations.
> 
> - moved devicetree binding doc to a separate commit.
> 
> - Philipp Zabel has developed a set of patches that allow adding
>   to the subdev async notifier waiting list using a chaining method
>   from the async registered callbacks (v4l2_of_subdev_registered()
>   and the prep patches for that). For now, I've removed the use of
>   v4l2_of_subdev_registered() for the vidmux driver's registered
>   callback. This doesn't affect the functionality of this driver,
>   but allows for it to be merged now, before adding the chaining
>   support.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/platform/Kconfig             |   8 +
>  drivers/media/platform/Makefile            |   2 +
>  drivers/media/platform/video-multiplexer.c | 451 +++++++++++++++++++++++++++++
>  3 files changed, 461 insertions(+)
>  create mode 100644 drivers/media/platform/video-multiplexer.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index ab0bb48..c9b8d9c 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -74,6 +74,14 @@ config VIDEO_M32R_AR_M64278
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called arv.
>  
> +config VIDEO_MULTIPLEXER
> +	tristate "Video Multiplexer"
> +	depends on VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> +	help
> +	  This driver provides support for SoC internal N:1 video bus
> +	  multiplexers controlled by register bitfields as well as external
> +	  2:1 video multiplexers controlled by a single GPIO.
> +
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 8959f6e..d418add 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
>  
>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
>  
> +obj-$(CONFIG_VIDEO_MULTIPLEXER)		+= video-multiplexer.o
> +
>  obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
> diff --git a/drivers/media/platform/video-multiplexer.c b/drivers/media/platform/video-multiplexer.c
> new file mode 100644
> index 0000000..b18c317
> --- /dev/null
> +++ b/drivers/media/platform/video-multiplexer.c
> @@ -0,0 +1,451 @@
> +/*
> + * video stream multiplexer controlled via gpio or syscon
> + *
> + * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> + * Copyright (C) 2016 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +
> +struct vidsw {
> +	struct v4l2_subdev subdev;
> +	unsigned int num_pads;

You could use subdev.entity.num_pads instead of caching the value locally.

> +	struct media_pad *pads;
> +	struct v4l2_mbus_framefmt *format_mbus;
> +	struct v4l2_of_endpoint *endpoint;
> +	struct regmap_field *field;
> +	struct gpio_desc *gpio;
> +	int active;
> +};
> +
> +static inline struct vidsw *v4l2_subdev_to_vidsw(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct vidsw, subdev);
> +}
> +
> +static void vidsw_set_active(struct vidsw *vidsw, int active)
> +{
> +	vidsw->active = active;
> +	if (active < 0)
> +		return;
> +
> +	dev_dbg(vidsw->subdev.dev, "setting %d active\n", active);
> +
> +	if (vidsw->field)
> +		regmap_field_write(vidsw->field, active);
> +	else if (vidsw->gpio)
> +		gpiod_set_value(vidsw->gpio, active);
> +}
> +
> +static int vidsw_link_setup(struct media_entity *entity,
> +			    const struct media_pad *local,
> +			    const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> +
> +	/* We have no limitations on enabling or disabling our output link */
> +	if (local->index == vidsw->num_pads - 1)
> +		return 0;
> +
> +	dev_dbg(sd->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> +		if (local->index == vidsw->active) {
> +			dev_dbg(sd->dev, "going inactive\n");
> +			vidsw->active = -1;
> +		}
> +		return 0;
> +	}
> +
> +	if (vidsw->active >= 0) {
> +		struct media_pad *pad;
> +
> +		if (vidsw->active == local->index)
> +			return 0;
> +
> +		pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
> +		if (pad) {
> +			struct media_link *link;
> +			int ret;
> +
> +			link = media_entity_find_link(pad,
> +						&vidsw->pads[vidsw->active]);
> +			if (link) {
> +				ret = __media_entity_setup_link(link, 0);

I wouldn't implicitly disable a link, even if only one can be active at a
given time. No other drivers do that either.

Perhaps returning an error might be a better thing to do: if you're
reconfiguring the pipeline anyway, there are likely issues elsewhere in it.

We could also change the behaviour later to allow implicit changes but we
can't later on go the other way without breaking the user space.

> +				if (ret)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	vidsw_set_active(vidsw, local->index);
> +
> +	return 0;
> +}
> +
> +static struct media_entity_operations vidsw_ops = {
> +	.link_setup = vidsw_link_setup,
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static bool vidsw_endpoint_disabled(struct device_node *ep)
> +{
> +	struct device_node *rpp;
> +
> +	if (!of_device_is_available(ep))

ep here is the endpoint, whereas the argument to of_device_is_available()
should correspond to the actual device.

> +		return true;
> +
> +	rpp = of_graph_get_remote_port_parent(ep);
> +	if (!rpp)
> +		return true;
> +
> +	return !of_device_is_available(rpp);
> +}
> +
> +static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)

I think I'd arrange this closer to probe as it's related to probe directly.
Up to you.

> +{
> +	struct device_node *ep;
> +	u32 portno;
> +	int numports;
> +	int ret;
> +	int i;
> +	bool active_link = false;
> +
> +	numports = vidsw->num_pads;
> +
> +	for (i = 0; i < numports - 1; i++)
> +		vidsw->pads[i].flags = MEDIA_PAD_FL_SINK;
> +	vidsw->pads[numports - 1].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	vidsw->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
> +	ret = media_entity_pads_init(&vidsw->subdev.entity, numports,
> +				     vidsw->pads);
> +	if (ret < 0)
> +		return ret;
> +
> +	vidsw->subdev.entity.ops = &vidsw_ops;
> +
> +	for_each_endpoint_of_node(node, ep) {
> +		struct v4l2_of_endpoint endpoint;
> +
> +		v4l2_of_parse_endpoint(ep, &endpoint);
> +
> +		portno = endpoint.base.port;
> +		if (portno >= numports - 1)
> +			continue;
> +
> +		if (vidsw_endpoint_disabled(ep)) {
> +			dev_dbg(vidsw->subdev.dev,
> +				"port %d disabled\n", portno);
> +			continue;
> +		}
> +
> +		vidsw->endpoint[portno] = endpoint;
> +
> +		if (portno == vidsw->active)
> +			active_link = true;
> +	}
> +
> +	for (portno = 0; portno < numports - 1; portno++) {
> +		if (!vidsw->endpoint[portno].base.local_node)
> +			continue;
> +
> +		/* If the active input is not connected, use another */
> +		if (!active_link) {
> +			vidsw_set_active(vidsw, portno);
> +			active_link = true;
> +		}
> +	}
> +
> +	return v4l2_async_register_subdev(&vidsw->subdev);
> +}
> +
> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg)

We should get rid of g_mbus_config() in the long run, but as we don't have
the alternative (frame descriptors) isn't up to the job yet I guess it's ok.
I don't think we'll have too many users for the video switch right now.

> +{
> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> +	struct media_pad *pad;
> +	int ret;
> +
> +	if (vidsw->active == -1) {
> +		dev_err(sd->dev, "no configuration for inactive mux\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Retrieve media bus configuration from the entity connected to the
> +	 * active input
> +	 */
> +	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
> +	if (pad) {
> +		sd = media_entity_to_v4l2_subdev(pad->entity);
> +		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
> +		if (ret == -ENOIOCTLCMD)
> +			pad = NULL;
> +		else if (ret < 0) {
> +			dev_err(sd->dev, "failed to get source configuration\n");
> +			return ret;
> +		}
> +	}
> +	if (!pad) {
> +		/* Mirror the input side on the output side */
> +		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
> +		if (cfg->type == V4L2_MBUS_PARALLEL ||
> +		    cfg->type == V4L2_MBUS_BT656)
> +			cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidsw_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> +	struct v4l2_subdev *upstream_sd;
> +	struct media_pad *pad;
> +
> +	if (vidsw->active == -1) {
> +		dev_err(sd->dev, "Can not start streaming on inactive mux\n");
> +		return -EINVAL;
> +	}
> +
> +	pad = media_entity_remote_pad(&sd->entity.pads[vidsw->active]);
> +	if (!pad) {
> +		dev_err(sd->dev, "Failed to find remote source pad\n");
> +		return -ENOLINK;
> +	}
> +
> +	if (!is_media_entity_v4l2_subdev(pad->entity)) {
> +		dev_err(sd->dev, "Upstream entity is not a v4l2 subdev\n");
> +		return -ENODEV;
> +	}
> +
> +	upstream_sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +	return v4l2_subdev_call(upstream_sd, video, s_stream, enable);

Now that we'll have more than two drivers involved in the same pipeline it
becomes necessary to define the behaviour of s_stream() throughout the
pipeline --- i.e. whose responsibility is it to call s_stream() on the
sub-devices in the pipeline?

I can submit a patch for that. I think the way you do it here is good, as it
enables the caller to choose the appropriate behaviour, i.e. start the local
device before or after the upstream sub-device.

> +}
> +
> +static const struct v4l2_subdev_video_ops vidsw_subdev_video_ops = {
> +	.g_mbus_config = vidsw_g_mbus_config,
> +	.s_stream = vidsw_s_stream,
> +};
> +
> +static struct v4l2_mbus_framefmt *
> +__vidsw_get_pad_format(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       unsigned int pad, u32 which)
> +{
> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> +
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &vidsw->format_mbus[pad];
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int vidsw_get_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	sdformat->format = *__vidsw_get_pad_format(sd, cfg, sdformat->pad,
> +						   sdformat->which);
> +	return 0;
> +}
> +
> +static int vidsw_set_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	if (sdformat->pad >= vidsw->num_pads)
> +		return -EINVAL;

This check is already performed in v4l2-subdev.c.

> +
> +	mbusformat = __vidsw_get_pad_format(sd, cfg, sdformat->pad,
> +					    sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	/* Output pad mirrors active input pad, no limitations on input pads */

Source and sink pads.

> +	if (sdformat->pad == (vidsw->num_pads - 1) && vidsw->active >= 0)

I think it'd be cleaner to test for the pad flag instead of the number. Or,
add a macro to obtain the source pad number.

> +		sdformat->format = vidsw->format_mbus[vidsw->active];
> +
> +	*mbusformat = sdformat->format;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_pad_ops vidsw_pad_ops = {
> +	.get_fmt = vidsw_get_format,
> +	.set_fmt = vidsw_set_format,
> +};
> +
> +static struct v4l2_subdev_ops vidsw_subdev_ops = {
> +	.pad = &vidsw_pad_ops,
> +	.video = &vidsw_subdev_video_ops,
> +};
> +
> +static int of_get_reg_field(struct device_node *node, struct reg_field *field)
> +{
> +	u32 bit_mask;
> +	int ret;
> +
> +	ret = of_property_read_u32(node, "reg", &field->reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = of_property_read_u32(node, "bit-mask", &bit_mask);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = of_property_read_u32(node, "bit-shift", &field->lsb);
> +	if (ret < 0)
> +		return ret;

I think the above would look nice in a MUX driver. :-)

> +
> +	field->msb = field->lsb + fls(bit_mask) - 1;
> +
> +	return 0;
> +}
> +
> +static int vidsw_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct of_endpoint endpoint;
> +	struct device_node *ep;
> +	struct reg_field field;
> +	struct vidsw *vidsw;
> +	struct regmap *map;
> +	unsigned int num_pads;
> +	int ret;
> +
> +	vidsw = devm_kzalloc(&pdev->dev, sizeof(*vidsw), GFP_KERNEL);
> +	if (!vidsw)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, vidsw);
> +
> +	v4l2_subdev_init(&vidsw->subdev, &vidsw_subdev_ops);
> +	snprintf(vidsw->subdev.name, sizeof(vidsw->subdev.name), "%s",
> +			np->name);
> +	vidsw->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	vidsw->subdev.dev = &pdev->dev;
> +
> +	/*
> +	 * The largest numbered port is the output port. It determines
> +	 * total number of pads
> +	 */
> +	num_pads = 0;

You can initialise num_pads in variable declaration.

> +	for_each_endpoint_of_node(np, ep) {
> +		of_graph_parse_endpoint(ep, &endpoint);
> +		num_pads = max(num_pads, endpoint.port + 1);

Port numbers come directly from DT.

Shouldn't num_pads be only the number of pads that have links with actual
physical connections? I.e. if a device is disabled, it shouldn't be
counted here.

> +	}
> +
> +	if (num_pads < 2) {
> +		dev_err(&pdev->dev, "Not enough ports %d\n", num_pads);
> +		return -EINVAL;
> +	}
> +
> +	ret = of_get_reg_field(np, &field);
> +	if (ret == 0) {
> +		map = syscon_node_to_regmap(np->parent);
> +		if (!map) {
> +			dev_err(&pdev->dev, "Failed to get syscon register map\n");
> +			return PTR_ERR(map);
> +		}
> +
> +		vidsw->field = devm_regmap_field_alloc(&pdev->dev, map, field);
> +		if (IS_ERR(vidsw->field)) {
> +			dev_err(&pdev->dev, "Failed to allocate regmap field\n");
> +			return PTR_ERR(vidsw->field);
> +		}
> +
> +		regmap_field_read(vidsw->field, &vidsw->active);
> +	} else {
> +		if (num_pads > 3) {
> +			dev_err(&pdev->dev, "Too many ports %d\n", num_pads);
> +			return -EINVAL;
> +		}
> +
> +		vidsw->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
> +		if (IS_ERR(vidsw->gpio)) {
> +			dev_warn(&pdev->dev,
> +				 "could not request control gpio: %d\n", ret);
> +			vidsw->gpio = NULL;
> +		}
> +
> +		vidsw->active = gpiod_get_value(vidsw->gpio) ? 1 : 0;
> +	}
> +
> +	vidsw->num_pads = num_pads;
> +	vidsw->pads = devm_kzalloc(&pdev->dev, sizeof(*vidsw->pads) * num_pads,
> +			GFP_KERNEL);
> +	vidsw->format_mbus = devm_kzalloc(&pdev->dev,
> +			sizeof(*vidsw->format_mbus) * num_pads, GFP_KERNEL);
> +	vidsw->endpoint = devm_kzalloc(&pdev->dev,
> +			sizeof(*vidsw->endpoint) * (num_pads - 1), GFP_KERNEL);
> +
> +	ret = vidsw_async_init(vidsw, np);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int vidsw_remove(struct platform_device *pdev)
> +{
> +	struct vidsw *vidsw = platform_get_drvdata(pdev);
> +	struct v4l2_subdev *sd = &vidsw->subdev;
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id vidsw_dt_ids[] = {
> +	{ .compatible = "video-multiplexer", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, vidsw_dt_ids);
> +
> +static struct platform_driver vidsw_driver = {
> +	.probe		= vidsw_probe,
> +	.remove		= vidsw_remove,
> +	.driver		= {
> +		.of_match_table = vidsw_dt_ids,
> +		.name = "video-multiplexer",
> +	},
> +};
> +
> +module_platform_driver(vidsw_driver);
> +
> +MODULE_DESCRIPTION("video stream multiplexer");
> +MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> +MODULE_AUTHOR("Philipp Zabel, Pengutronix");
> +MODULE_LICENSE("GPL");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
