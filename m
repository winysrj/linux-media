Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34643 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbcFPQNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:13:23 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so10647949wmz.1
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2016 09:13:22 -0700 (PDT)
Subject: Re: [PATCH 31/38] media: imx: Add video switch
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-32-git-send-email-steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <a0771fe0-ab96-1f33-703f-e224f056390f@gmail.com>
Date: Thu, 16 Jun 2016 17:13:19 +0100
MIME-Version: 1.0
In-Reply-To: <1465944574-15745-32-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For me this fails when I try to enable both video muxes (mx6dl, though 
mx6q should be the same).

I get a sysfs duplicate name failure for 34.videomux. I realise passing 
the GPR13 register offset and a bitfield mask as a tuple in the reg 
value of the of_node is handy, but how should we account for multiple 
devices with the same name and address?

A quick and dirty hack would be to have of_get_reg_field do something like

	field->reg = reg_bit_mask[0] & 0xff;

and then use values in the DT that differ in the bits masked off, but 
there must be a nicer way.

Trace below, fyi. This is from the v2 patches posted here, not your v2.1 
tree.

Regards,
IanJ


[    0.096004] ------------[ cut here ]------------
[    0.096035] WARNING: CPU: 0 PID: 1 at 
/home/ian/tx6/yoctomaster/build/tmp/work-shared/tx6u-vid/kernel-source/fs/sysfs/dir.c:31 
sysfs_warn_dup+0x70/0x80
[    0.096046] sysfs: cannot create duplicate filename 
'/devices/soc0/34.videomux'
[    0.096053] Modules linked in:
[    0.096071] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
4.7.0-rc1-yocto-standard #1
[    0.096079] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    0.096116] [<80018d8c>] (unwind_backtrace) from [<8001427c>] 
(show_stack+0x18/0x1c)
[    0.096138] [<8001427c>] (show_stack) from [<802c85fc>] 
(dump_stack+0x88/0x9c)
[    0.096157] [<802c85fc>] (dump_stack) from [<80024d90>] 
(__warn+0xf4/0x10c)
[    0.096175] [<80024d90>] (__warn) from [<80024de8>] 
(warn_slowpath_fmt+0x40/0x50)
[    0.096194] [<80024de8>] (warn_slowpath_fmt) from [<80176118>] 
(sysfs_warn_dup+0x70/0x80)
[    0.096212] [<80176118>] (sysfs_warn_dup) from [<80176204>] 
(sysfs_create_dir_ns+0x8c/0x9c)
[    0.096231] [<80176204>] (sysfs_create_dir_ns) from [<802cafd0>] 
(kobject_add_internal+0xc0/0x360)
[    0.096249] [<802cafd0>] (kobject_add_internal) from [<802cb2b8>] 
(kobject_add+0x48/0x98)
[    0.096269] [<802cb2b8>] (kobject_add) from [<803b90e0>] 
(device_add+0xf0/0x5a0)
[    0.096295] [<803b90e0>] (device_add) from [<8051ae20>] 
(of_platform_device_create_pdata+0x8c/0xc4)
[    0.096316] [<8051ae20>] (of_platform_device_create_pdata) from 
[<8051af7c>] (of_platform_bus_create+0x110/0x2a0)
[    0.096333] [<8051af7c>] (of_platform_bus_create) from [<8051b29c>] 
(of_platform_populate+0x64/0xb4)
[    0.096358] [<8051b29c>] (of_platform_populate) from [<808f1a88>] 
(imx6q_init_machine+0x104/0x2b4)
[    0.096377] [<808f1a88>] (imx6q_init_machine) from [<808eba7c>] 
(customize_machine+0x24/0x44)
[    0.096395] [<808eba7c>] (customize_machine) from [<8000980c>] 
(do_one_initcall+0x4c/0x174)
[    0.096414] [<8000980c>] (do_one_initcall) from [<808ead60>] 
(kernel_init_freeable+0x158/0x1e8)
[    0.096435] [<808ead60>] (kernel_init_freeable) from [<8062b4b0>] 
(kernel_init+0x14/0x100)
[    0.096457] [<8062b4b0>] (kernel_init) from [<800104b8>] 
(ret_from_fork+0x14/0x3c)
[    0.096482] ---[ end trace 394e7b4d22c2be44 ]---
[    0.096491] ------------[ cut here ]------------
[    0.096507] WARNING: CPU: 0 PID: 1 at 
/home/ian/tx6/yoctomaster/build/tmp/work-shared/tx6u-vid/kernel-source/lib/kobject.c:240 
kobject_add_internal+0x2e0/0x360
[    0.096518] kobject_add_internal failed for 34.videomux with -EEXIST, 
don't try to register things with the same name in the same directory.
[    0.096525] Modules linked in:
[    0.096539] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G W       
4.7.0-rc1-yocto-standard #1
[    0.096548] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[    0.096570] [<80018d8c>] (unwind_backtrace) from [<8001427c>] 
(show_stack+0x18/0x1c)
[    0.096585] [<8001427c>] (show_stack) from [<802c85fc>] 
(dump_stack+0x88/0x9c)
[    0.096601] [<802c85fc>] (dump_stack) from [<80024d90>] 
(__warn+0xf4/0x10c)
[    0.096616] [<80024d90>] (__warn) from [<80024de8>] 
(warn_slowpath_fmt+0x40/0x50)
[    0.096632] [<80024de8>] (warn_slowpath_fmt) from [<802cb1f0>] 
(kobject_add_internal+0x2e0/0x360)
[    0.096647] [<802cb1f0>] (kobject_add_internal) from [<802cb2b8>] 
(kobject_add+0x48/0x98)
[    0.096664] [<802cb2b8>] (kobject_add) from [<803b90e0>] 
(device_add+0xf0/0x5a0)
[    0.096681] [<803b90e0>] (device_add) from [<8051ae20>] 
(of_platform_device_create_pdata+0x8c/0xc4)
[    0.096700] [<8051ae20>] (of_platform_device_create_pdata) from 
[<8051af7c>] (of_platform_bus_create+0x110/0x2a0)
[    0.096716] [<8051af7c>] (of_platform_bus_create) from [<8051b29c>] 
(of_platform_populate+0x64/0xb4)
[    0.096735] [<8051b29c>] (of_platform_populate) from [<808f1a88>] 
(imx6q_init_machine+0x104/0x2b4)
[    0.096752] [<808f1a88>] (imx6q_init_machine) from [<808eba7c>] 
(customize_machine+0x24/0x44)
[    0.096767] [<808eba7c>] (customize_machine) from [<8000980c>] 
(do_one_initcall+0x4c/0x174)
[    0.096782] [<8000980c>] (do_one_initcall) from [<808ead60>] 
(kernel_init_freeable+0x158/0x1e8)
[    0.096798] [<808ead60>] (kernel_init_freeable) from [<8062b4b0>] 
(kernel_init+0x14/0x100)
[    0.096814] [<8062b4b0>] (kernel_init) from [<800104b8>] 
(ret_from_fork+0x14/0x3c)
[    0.096822] ---[ end trace 394e7b4d22c2be45 ]---


On 14/06/16 23:49, Steve Longerbeam wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>
>
> This driver can handle SoC internal and extern video bus multiplexers,
> controlled either by register bit fields or by GPIO.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>   drivers/staging/media/imx/capture/Kconfig          |   9 +
>   drivers/staging/media/imx/capture/Makefile         |   1 +
>   .../staging/media/imx/capture/imx-video-switch.c   | 348 +++++++++++++++++++++
>   3 files changed, 358 insertions(+)
>   create mode 100644 drivers/staging/media/imx/capture/imx-video-switch.c
>
> diff --git a/drivers/staging/media/imx/capture/Kconfig b/drivers/staging/media/imx/capture/Kconfig
> index ac6fce0..ecd09abe 100644
> --- a/drivers/staging/media/imx/capture/Kconfig
> +++ b/drivers/staging/media/imx/capture/Kconfig
> @@ -8,4 +8,13 @@ config IMX_MIPI_CSI2
>            MIPI CSI-2 Receiver driver support. This driver is required
>   	 for sensor drivers with a MIPI CSI2 interface.
>   
> +config IMX_VIDEO_SWITCH
> +	tristate "i.MX5/6 Video Bus Multiplexer"
> +	depends on VIDEO_IMX_CAMERA
> +	default y
> +	---help---
> +	  This driver provides support for the i.MX5/6 internal video bus
> +	  multiplexer controlled by register bitfields as well as
> +	  external multiplexers controller by a GPIO.
> +
>   endmenu
> diff --git a/drivers/staging/media/imx/capture/Makefile b/drivers/staging/media/imx/capture/Makefile
> index 8961a4f..f17b199 100644
> --- a/drivers/staging/media/imx/capture/Makefile
> +++ b/drivers/staging/media/imx/capture/Makefile
> @@ -4,3 +4,4 @@ imx-camera-objs := imx-camif.o imx-ic-prpenc.o imx-of.o \
>   obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camera.o
>   obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
>   obj-$(CONFIG_IMX_MIPI_CSI2) += mipi-csi2.o
> +obj-$(CONFIG_IMX_VIDEO_SWITCH) += imx-video-switch.o
> diff --git a/drivers/staging/media/imx/capture/imx-video-switch.c b/drivers/staging/media/imx/capture/imx-video-switch.c
> new file mode 100644
> index 0000000..0c86679
> --- /dev/null
> +++ b/drivers/staging/media/imx/capture/imx-video-switch.c
> @@ -0,0 +1,348 @@
> +/*
> + * devicetree probed mediacontrol video multiplexer.
> + *
> + * Copyright (C) 2013 Sascha Hauer, Pengutronix
> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
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
> +#include <linux/gpio.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/of_graph.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +
> +struct vidsw {
> +	struct device *dev;
> +	struct v4l2_subdev subdev;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_pad *pads;
> +#endif
> +	struct v4l2_mbus_framefmt *format_mbus;
> +	struct v4l2_of_endpoint *endpoint;
> +	struct regmap_field *field;
> +	unsigned int gpio;
> +	int output_pad;
> +	int numpads;
> +	int active;
> +};
> +
> +#define to_vidsw(sd) container_of(sd, struct vidsw, subdev)
> +
> +static int vidsw_set_mux(struct vidsw *vidsw, int input_index)
> +{
> +	if (vidsw->active >= 0) {
> +		if (vidsw->active == input_index)
> +			return 0;
> +		else
> +			return -EBUSY;
> +	}
> +
> +	vidsw->active = input_index;
> +
> +	dev_dbg(vidsw->dev, "setting %d active\n", vidsw->active);
> +
> +	if (vidsw->field)
> +		regmap_field_write(vidsw->field, vidsw->active);
> +	else if (gpio_is_valid(vidsw->gpio))
> +		gpio_set_value(vidsw->gpio, vidsw->active);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +static int vidsw_link_setup(struct media_entity *entity,
> +		const struct media_pad *local,
> +		const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct vidsw *vidsw = to_vidsw(sd);
> +
> +	dev_dbg(vidsw->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> +		if (local->index == vidsw->active) {
> +			dev_dbg(vidsw->dev, "going inactive\n");
> +			vidsw->active = -1;
> +		}
> +		return 0;
> +	}
> +
> +	return vidsw_set_mux(vidsw, local->index);
> +}
> +
> +static struct media_entity_operations vidsw_ops = {
> +	.link_setup = vidsw_link_setup,
> +};
> +#endif
> +
> +static int vidsw_s_routing(struct v4l2_subdev *sd, u32 input,
> +			   u32 output, u32 config)
> +{
> +	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
> +
> +	return vidsw_set_mux(vidsw, input);
> +}
> +
> +static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)
> +{
> +	struct v4l2_of_endpoint endpoint;
> +	struct device_node *epnode;
> +	int pad, numpads;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	int ret;
> +#endif
> +
> +	numpads = of_get_child_count(node);
> +	if (numpads < 2) {
> +		dev_err(vidsw->dev, "Not enough ports %d\n", numpads);
> +		return -EINVAL;
> +	}
> +
> +	vidsw->numpads = numpads;
> +
> +	/*
> +	 * the last endpoint must define the mux output pad,
> +	 * the rest are the mux input pads.
> +	 */
> +	vidsw->output_pad = numpads - 1;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	vidsw->pads = devm_kzalloc(vidsw->dev,
> +				   numpads * sizeof(*vidsw->pads),
> +				   GFP_KERNEL);
> +	if (!vidsw->pads)
> +		return -ENOMEM;
> +#endif
> +
> +	vidsw->endpoint = devm_kzalloc(vidsw->dev,
> +				       numpads * sizeof(*vidsw->endpoint),
> +				       GFP_KERNEL);
> +	if (!vidsw->endpoint)
> +		return -ENOMEM;
> +
> +	vidsw->format_mbus = devm_kzalloc(vidsw->dev,
> +					  numpads * sizeof(*vidsw->format_mbus),
> +					  GFP_KERNEL);
> +	if (!vidsw->format_mbus)
> +		return -ENOMEM;
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	vidsw->subdev.entity.ops = &vidsw_ops;
> +
> +	/* init the pad directions */
> +	for (pad = 0; pad < vidsw->output_pad; pad++)
> +		vidsw->pads[pad].flags = MEDIA_PAD_FL_SINK;
> +	vidsw->pads[vidsw->output_pad].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&vidsw->subdev.entity,
> +				     vidsw->numpads, vidsw->pads);
> +	if (ret < 0)
> +		return ret;
> +#endif
> +
> +	epnode = NULL;
> +	for (pad = 0; pad < vidsw->numpads; pad++) {
> +		epnode = of_graph_get_next_endpoint(node, epnode);
> +		if (!epnode)
> +			return -EINVAL;
> +
> +		v4l2_of_parse_endpoint(epnode, &endpoint);
> +		vidsw->endpoint[pad] = endpoint;
> +		of_node_put(epnode);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidsw_registered(struct v4l2_subdev *sd)
> +{
> +	return 0;
> +}
> +
> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg)
> +{
> +	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
> +
> +	dev_dbg(vidsw->dev, "reporting configration %d\n", vidsw->active);
> +
> +	/* Mirror the input side on the output side */
> +	cfg->type = vidsw->endpoint[vidsw->active].bus_type;
> +	if (cfg->type == V4L2_MBUS_PARALLEL || cfg->type == V4L2_MBUS_BT656)
> +		cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops vidsw_subdev_video_ops = {
> +	.g_mbus_config = vidsw_g_mbus_config,
> +	.s_routing = vidsw_s_routing,
> +};
> +
> +static int vidsw_get_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
> +
> +	sdformat->format = vidsw->format_mbus[sdformat->pad];
> +
> +	return 0;
> +}
> +
> +static int vidsw_set_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct vidsw *vidsw = container_of(sd, struct vidsw, subdev);
> +
> +	if (sdformat->pad >= vidsw->numpads)
> +		return -EINVAL;
> +
> +	/* Output pad mirrors active input pad, no limitations on input pads */
> +	if (sdformat->pad == vidsw->output_pad && vidsw->active >= 0)
> +		sdformat->format = vidsw->format_mbus[vidsw->active];
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
> +		cfg->try_fmt = sdformat->format;
> +	else
> +		vidsw->format_mbus[sdformat->pad] = sdformat->format;
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
> +static struct v4l2_subdev_internal_ops vidsw_internal_ops = {
> +	.registered = vidsw_registered,
> +};
> +
> +static int of_get_reg_field(struct device_node *node, struct reg_field *field)
> +{
> +	u32 reg_bit_mask[2];
> +	int ret;
> +
> +	ret = of_property_read_u32_array(node, "reg", reg_bit_mask, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	field->reg = reg_bit_mask[0];
> +	field->lsb = __ffs(reg_bit_mask[1]);
> +	field->msb = __fls(reg_bit_mask[1]);
> +
> +	return 0;
> +}
> +
> +static int vidsw_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct reg_field field;
> +	struct vidsw *vidsw;
> +	struct regmap *map;
> +	int ret;
> +
> +	vidsw = devm_kzalloc(&pdev->dev, sizeof(*vidsw), GFP_KERNEL);
> +	if (!vidsw)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, vidsw);
> +
> +	v4l2_subdev_init(&vidsw->subdev, &vidsw_subdev_ops);
> +	v4l2_set_subdevdata(&vidsw->subdev, &pdev->dev);
> +	vidsw->subdev.internal_ops = &vidsw_internal_ops;
> +	snprintf(vidsw->subdev.name, sizeof(vidsw->subdev.name), "%s",
> +			np->name);
> +	vidsw->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	vidsw->subdev.dev = &pdev->dev;
> +	vidsw->dev = &pdev->dev;
> +	vidsw->active = -1;
> +
> +	ret = of_get_reg_field(np, &field);
> +	if (ret == 0) {
> +		map = syscon_regmap_lookup_by_phandle(np, "gpr");
> +		if (!map) {
> +			dev_err(&pdev->dev,
> +				"Failed to get syscon register map\n");
> +			return PTR_ERR(map);
> +		}
> +
> +		vidsw->field = devm_regmap_field_alloc(&pdev->dev, map, field);
> +		if (IS_ERR(vidsw->field)) {
> +			dev_err(&pdev->dev,
> +				"Failed to allocate regmap field\n");
> +			return PTR_ERR(vidsw->field);
> +		}
> +	} else {
> +		vidsw->gpio = of_get_named_gpio_flags(np, "gpios", 0, NULL);
> +		ret = gpio_request_one(vidsw->gpio,
> +				       GPIOF_OUT_INIT_LOW, np->name);
> +		if (ret < 0) {
> +			dev_warn(&pdev->dev,
> +				 "could not request control gpio %d: %d\n",
> +				 vidsw->gpio, ret);
> +			vidsw->gpio = -1;
> +		}
> +	}
> +
> +	ret = vidsw_async_init(vidsw, np);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&vidsw->subdev);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int vidsw_remove(struct platform_device *pdev)
> +{
> +	/* FIXME */
> +
> +	return -EBUSY;
> +}
> +
> +static const struct of_device_id vidsw_dt_ids[] = {
> +	{ .compatible = "imx-video-mux", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, vidsw_dt_ids);
> +
> +static struct platform_driver vidsw_driver = {
> +	.probe		= vidsw_probe,
> +	.remove		= vidsw_remove,
> +	.driver		= {
> +		.of_match_table = vidsw_dt_ids,
> +		.name	= "imx-video-mux",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(vidsw_driver);
> +
> +MODULE_DESCRIPTION("i.MX video stream multiplexer");
> +MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> +MODULE_LICENSE("GPL");

