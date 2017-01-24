Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46217 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750842AbdAXMD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 07:03:27 -0500
Message-ID: <1485259368.3600.126.camel@pengutronix.de>
Subject: Re: [PATCH v3 13/24] platform: add video-multiplexer subdevice
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 24 Jan 2017 13:02:48 +0100
In-Reply-To: <b7695d77-4078-f171-d592-ff679e28b8e0@xs4all.nl>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-14-git-send-email-steve_longerbeam@mentor.com>
         <b7695d77-4078-f171-d592-ff679e28b8e0@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 2017-01-20 at 15:03 +0100, Hans Verkuil wrote:
> On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > This driver can handle SoC internal and external video bus multiplexers,
> > controlled either by register bit fields or by a GPIO. The subdevice
> > passes through frame interval and mbus configuration of the active input
> > to the output side.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > --
> > 
> > - fixed a cut&paste error in vidsw_remove(): v4l2_async_register_subdev()
> >   should be unregister.
> > 
> > - added media_entity_cleanup() and v4l2_device_unregister_subdev()
> >   to vidsw_remove().
> > 
> > - there was a line left over from a previous iteration that negated
> >   the new way of determining the pad count just before it which
> >   has been removed (num_pads = of_get_child_count(np)).
> > 
> > - Philipp Zabel has developed a set of patches that allow adding
> >   to the subdev async notifier waiting list using a chaining method
> >   from the async registered callbacks (v4l2_of_subdev_registered()
> >   and the prep patches for that). For now, I've removed the use of
> >   v4l2_of_subdev_registered() for the vidmux driver's registered
> >   callback. This doesn't affect the functionality of this driver,
> >   but allows for it to be merged now, before adding the chaining
> >   support.
> > 
> > Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> > ---
> >  .../bindings/media/video-multiplexer.txt           |  59 +++
> >  drivers/media/platform/Kconfig                     |   8 +
> >  drivers/media/platform/Makefile                    |   2 +
> >  drivers/media/platform/video-multiplexer.c         | 472 +++++++++++++++++++++
> >  4 files changed, 541 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
> >  create mode 100644 drivers/media/platform/video-multiplexer.c
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-multiplexer.txt b/Documentation/devicetree/bindings/media/video-multiplexer.txt
> > new file mode 100644
> > index 0000000..9d133d9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/video-multiplexer.txt
> > @@ -0,0 +1,59 @@
> > +Video Multiplexer
> > +=================
> > +
> > +Video multiplexers allow to select between multiple input ports. Video received
> > +on the active input port is passed through to the output port. Muxes described
> > +by this binding may be controlled by a syscon register bitfield or by a GPIO.
> > +
> > +Required properties:
> > +- compatible : should be "video-multiplexer"
> > +- reg: should be register base of the register containing the control bitfield
> > +- bit-mask: bitmask of the control bitfield in the control register
> > +- bit-shift: bit offset of the control bitfield in the control register
> > +- gpios: alternatively to reg, bit-mask, and bit-shift, a single GPIO phandle
> > +  may be given to switch between two inputs
> > +- #address-cells: should be <1>
> > +- #size-cells: should be <0>
> > +- port@*: at least three port nodes containing endpoints connecting to the
> > +  source and sink devices according to of_graph bindings. The last port is
> > +  the output port, all others are inputs.
> > +
> > +Example:
> > +
> > +syscon {
> > +	compatible = "syscon", "simple-mfd";
> > +
> > +	mux {
> > +		compatible = "video-multiplexer";
> > +		/* Single bit (1 << 19) in syscon register 0x04: */
> > +		reg = <0x04>;
> > +		bit-mask = <1>;
> > +		bit-shift = <19>;
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		port@0 {
> > +			reg = <0>;
> > +
> > +			mux_in0: endpoint {
> > +				remote-endpoint = <&video_source0_out>;
> > +			};
> > +		};
> > +
> > +		port@1 {
> > +			reg = <1>;
> > +
> > +			mux_in1: endpoint {
> > +				remote-endpoint = <&video_source1_out>;
> > +			};
> > +		};
> > +
> > +		port@2 {
> > +			reg = <2>;
> > +
> > +			mux_out: endpoint {
> > +				remote-endpoint = <&capture_interface_in>;
> > +			};
> > +		};
> > +	};
> > +};
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index d944421..65614b5 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -74,6 +74,14 @@ config VIDEO_M32R_AR_M64278
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called arv.
> >  
> > +config VIDEO_MULTIPLEXER
> > +	tristate "Video Multiplexer"
> > +	depends on VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> > +	help
> > +	  This driver provides support for SoC internal N:1 video bus
> > +	  multiplexers controlled by register bitfields as well as external
> > +	  2:1 video multiplexers controlled by a single GPIO.
> > +
> >  config VIDEO_OMAP3
> >  	tristate "OMAP 3 Camera support"
> >  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> > diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> > index 5b3cb27..7cf0ee5 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
> >  
> >  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
> >  
> > +obj-$(CONFIG_VIDEO_MULTIPLEXER)		+= video-multiplexer.o
> > +
> >  obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
> >  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
> >  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
> > diff --git a/drivers/media/platform/video-multiplexer.c b/drivers/media/platform/video-multiplexer.c
> > new file mode 100644
> > index 0000000..48980c4
> > --- /dev/null
> > +++ b/drivers/media/platform/video-multiplexer.c
> > @@ -0,0 +1,472 @@
> > +/*
> > + * video stream multiplexer controlled via gpio or syscon
> > + *
> > + * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> > + * Copyright (C) 2016 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_graph.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/regmap.h>
> > +#include <media/v4l2-async.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-subdev.h>
> > +#include <media/v4l2-of.h>
> > +
> > +struct vidsw {
> > +	struct v4l2_subdev subdev;
> > +	unsigned int num_pads;
> > +	struct media_pad *pads;
> > +	struct v4l2_mbus_framefmt *format_mbus;
> > +	struct v4l2_fract timeperframe;
> > +	struct v4l2_of_endpoint *endpoint;
> > +	struct regmap_field *field;
> > +	struct gpio_desc *gpio;
> > +	int active;
> > +};
> > +
> > +static inline struct vidsw *v4l2_subdev_to_vidsw(struct v4l2_subdev *sd)
> > +{
> > +	return container_of(sd, struct vidsw, subdev);
> > +}
> > +
> > +static void vidsw_set_active(struct vidsw *vidsw, int active)
> > +{
> > +	vidsw->active = active;
> > +	if (active < 0)
> > +		return;
> > +
> > +	dev_dbg(vidsw->subdev.dev, "setting %d active\n", active);
> > +
> > +	if (vidsw->field)
> > +		regmap_field_write(vidsw->field, active);
> > +	else if (vidsw->gpio)
> > +		gpiod_set_value(vidsw->gpio, active);
> > +}
> > +
> > +static int vidsw_link_setup(struct media_entity *entity,
> > +			    const struct media_pad *local,
> > +			    const struct media_pad *remote, u32 flags)
> > +{
> > +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> > +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> > +
> > +	/* We have no limitations on enabling or disabling our output link */
> > +	if (local->index == vidsw->num_pads - 1)
> > +		return 0;
> > +
> > +	dev_dbg(sd->dev, "link setup %s -> %s", remote->entity->name,
> > +		local->entity->name);
> > +
> > +	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> > +		if (local->index == vidsw->active) {
> > +			dev_dbg(sd->dev, "going inactive\n");
> > +			vidsw->active = -1;
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	if (vidsw->active >= 0) {
> > +		struct media_pad *pad;
> > +
> > +		if (vidsw->active == local->index)
> > +			return 0;
> > +
> > +		pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
> > +		if (pad) {
> > +			struct media_link *link;
> > +			int ret;
> > +
> > +			link = media_entity_find_link(pad,
> > +						&vidsw->pads[vidsw->active]);
> > +			if (link) {
> > +				ret = __media_entity_setup_link(link, 0);
> > +				if (ret)
> > +					return ret;
> > +			}
> > +		}
> > +	}
> > +
> > +	vidsw_set_active(vidsw, local->index);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct media_entity_operations vidsw_ops = {
> > +	.link_setup = vidsw_link_setup,
> > +};
> > +
> > +static bool vidsw_endpoint_disabled(struct device_node *ep)
> > +{
> > +	struct device_node *rpp;
> > +
> > +	if (!of_device_is_available(ep))
> > +		return true;
> > +
> > +	rpp = of_graph_get_remote_port_parent(ep);
> > +	if (!rpp)
> > +		return true;
> > +
> > +	return !of_device_is_available(rpp);
> > +}
> > +
> > +static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)
> > +{
> > +	struct device_node *ep;
> > +	u32 portno;
> > +	int numports;
> > +	int ret;
> > +	int i;
> > +	bool active_link = false;
> > +
> > +	numports = vidsw->num_pads;
> > +
> > +	for (i = 0; i < numports - 1; i++)
> > +		vidsw->pads[i].flags = MEDIA_PAD_FL_SINK;
> > +	vidsw->pads[numports - 1].flags = MEDIA_PAD_FL_SOURCE;
> > +
> > +	vidsw->subdev.entity.function = MEDIA_ENT_F_MUX;
> > +	ret = media_entity_pads_init(&vidsw->subdev.entity, numports,
> > +				     vidsw->pads);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	vidsw->subdev.entity.ops = &vidsw_ops;
> > +
> > +	for_each_endpoint_of_node(node, ep) {
> > +		struct v4l2_of_endpoint endpoint;
> > +
> > +		v4l2_of_parse_endpoint(ep, &endpoint);
> > +
> > +		portno = endpoint.base.port;
> > +		if (portno >= numports - 1)
> > +			continue;
> > +
> > +		if (vidsw_endpoint_disabled(ep)) {
> > +			dev_dbg(vidsw->subdev.dev, "port %d disabled\n", portno);
> > +			continue;
> > +		}
> > +
> > +		vidsw->endpoint[portno] = endpoint;
> > +
> > +		if (portno == vidsw->active)
> > +			active_link = true;
> > +	}
> > +
> > +	for (portno = 0; portno < numports - 1; portno++) {
> > +		if (!vidsw->endpoint[portno].base.local_node)
> > +			continue;
> > +
> > +		/* If the active input is not connected, use another */
> > +		if (!active_link) {
> > +			vidsw_set_active(vidsw, portno);
> > +			active_link = true;
> > +		}
> > +	}
> > +
> > +	return v4l2_async_register_subdev(&vidsw->subdev);
> > +}
> > +
> > +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg)
> > +{
> > +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> > +	struct media_pad *pad;
> > +	int ret;
> > +
> > +	if (vidsw->active == -1) {
> > +		dev_err(sd->dev, "no configuration for inactive mux\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Retrieve media bus configuration from the entity connected to the
> > +	 * active input
> > +	 */
> > +	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
> > +	if (pad) {
> > +		sd = media_entity_to_v4l2_subdev(pad->entity);
> > +		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
> > +		if (ret == -ENOIOCTLCMD)
> > +			pad = NULL;
> > +		else if (ret < 0) {
> > +			dev_err(sd->dev, "failed to get source configuration\n");
> > +			return ret;
> > +		}
> > +	}
> > +	if (!pad) {
> > +		/* Mirror the input side on the output side */
> > +		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
> > +		if (cfg->type == V4L2_MBUS_PARALLEL ||
> > +		    cfg->type == V4L2_MBUS_BT656)
> > +			cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> I am not certain this op is needed at all. In the current kernel this op is only
> used by soc_camera, pxa_camera and omap3isp (somewhat dubious). Normally this
> information should come from the device tree and there should be no need for this op.
> 
> My (tentative) long-term plan was to get rid of this op.
> 
> If you don't need it, then I recommend it is removed.

We currently use this to make the CSI capture interface understand
whether its source from the MIPI CSI-2 or from the parallel bus. That is
probably something that should be fixed, but I'm not quite sure how.

The Synopsys DesignWare MIPI CSI-2 reciever turns the incoming MIPI
CSI-2 signal into a 32-bit parallel pixel bus plus some signals for the
MIPI specific metadata (virtual channel, data type).

Then the CSI2IPU gasket turns this input bus into four separate parallel
16-bit pixel buses plus an 8-bit "mct_di" bus for each of them, that
carries the MIPI metadata. The incoming data is split into the four
outputs according to the MIPI virtual channel.

Two of these 16-bit + 8-bit parallel buses are routed through a
multiplexer before finally arriving at the CSI on the other side.

We need to configure the CSI to either use or ignore the data from the
8-bit mct_di bus depending on whether the source of the mux is
configured to the MIPI CSI-2 receiver / CSI2IPU gasket, or to a parallel
input.

Currently we let g_mbus_config pretend that even the internal 32-bit +
metadata and 16-bit + 8-bit metadata parallel buses are of type
V4L2_MBUS_CSI so that the CSI can ask the mux, which propagates to the
CSI-2 receiver, if connected.

Without g_mbus_config we'd need to get that information from somewhere
else. One possibility would be to extend MEDIA_BUS formats to describe
these "parallelized MIPI data" buses separately.

regards
Philipp

