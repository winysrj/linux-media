Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36245 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdAFB0M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 20:26:12 -0500
Subject: Re: [PATCH v2 10/19] media: Add i.MX media core driver
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-11-git-send-email-steve_longerbeam@mentor.com>
 <c04a85dc-4f62-798f-2e37-d7848657730a@mentor.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <21871007-5243-7fc8-5087-f2ce5185180a@gmail.com>
Date: Thu, 5 Jan 2017 17:21:53 -0800
MIME-Version: 1.0
In-Reply-To: <c04a85dc-4f62-798f-2e37-d7848657730a@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 01/04/2017 05:33 AM, Vladimir Zapolskiy wrote:
> Hi Steve,
>
> On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
>> Add the core media driver for i.MX SOC.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   Documentation/devicetree/bindings/media/imx.txt   | 205 +++++
> v2 was sent before getting Rob's review comments, but still they
> should be addressed in v3.

yes, those changes will be part of v3 as well.

>
> Also I would suggest to separate device tree binding documentation
> change and place it as the first patch in the series, this should
> make the following DTS changes valid.

done.

>
>>   Documentation/media/v4l-drivers/imx.rst           | 430 ++++++++++
>>   drivers/staging/media/Kconfig                     |   2 +
>>   drivers/staging/media/Makefile                    |   1 +
>>   drivers/staging/media/imx/Kconfig                 |   8 +
>>   drivers/staging/media/imx/Makefile                |   6 +
>>   drivers/staging/media/imx/TODO                    |  18 +
>>   drivers/staging/media/imx/imx-media-common.c      | 985 ++++++++++++++++++++++
>>   drivers/staging/media/imx/imx-media-dev.c         | 479 +++++++++++
>>   drivers/staging/media/imx/imx-media-fim.c         | 509 +++++++++++
>>   drivers/staging/media/imx/imx-media-internal-sd.c | 457 ++++++++++
>>   drivers/staging/media/imx/imx-media-of.c          | 291 +++++++
>>   drivers/staging/media/imx/imx-media-of.h          |  25 +
>>   drivers/staging/media/imx/imx-media.h             | 299 +++++++
>>   include/media/imx.h                               |  15 +
>>   include/uapi/Kbuild                               |   1 +
>>   include/uapi/linux/v4l2-controls.h                |   4 +
>>   include/uapi/media/Kbuild                         |   2 +
>>   include/uapi/media/imx.h                          |  30 +
> Probably Greg should ack the UAPI changes, you may consider
> to split them into a separate patch.

I split out the one-line addition to include/uapi/Kbuild with an empty
include/uapi/media/Kbuild into a new patch "UAPI: Add media UAPI Kbuild 
file".
Also added a patch "media: Add userspace header file for i.MX".


>
>
>> +
>> +struct imx_media_subdev *
>> +imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
>> +			    struct v4l2_subdev *sd)
>> +{
>> +	struct imx_media_subdev *imxsd;
>> +	int i, ret = -ENODEV;
>> +
>> +	for (i = 0; i < imxmd->num_subdevs; i++) {
>> +		imxsd = &imxmd->subdev[i];
>> +		if (sd == imxsd->sd) {
> This can be simplifed:
>
> ...
>
> 	if (sd == imxsd->sd)
> 		return imxsd;
> }
>
> return ERR_PTR(-ENODEV);

yep, done.

>
>> +struct imx_media_subdev *
>> +imx_media_find_subdev_by_id(struct imx_media_dev *imxmd, u32 grp_id)
>> +{
>> +	struct imx_media_subdev *imxsd;
>> +	int i, ret = -ENODEV;
>> +
>> +	for (i = 0; i < imxmd->num_subdevs; i++) {
>> +		imxsd = &imxmd->subdev[i];
>> +		if (imxsd->sd && imxsd->sd->grp_id == grp_id) {
>> +			ret = 0;
>> +			break;
> This can be simplifed:
>
> ...
>
> 	if (imxsd->sd && imxsd->sd->grp_id == grp_i)
> 		return imxsd;
> }
>
> return ERR_PTR(-ENODEV);

done.

>
>
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
>> new file mode 100644
>> index 0000000..8d22730
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>> @@ -0,0 +1,479 @@
>> +/*
>> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/timer.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/of_platform.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-mc.h>
> Please sort out the list of headers alphabetically.

done.

>> +#include <video/imx-ipu-v3.h>
>> +#include <media/imx.h>
>> +#include "imx-media.h"
>> +#include "imx-media-of.h"
>> +
>> +#define DEVICE_NAME "imx-media"
> I suppose you don't need this macro.

sure why not, removed.

>
> [snip]
>
>> + */
>> +static int imx_media_create_links(struct imx_media_dev *imxmd)
>> +{
>> +	struct imx_media_subdev *local_sd;
>> +	struct imx_media_subdev *remote_sd;
>> +	struct v4l2_subdev *source, *sink;
>> +	struct imx_media_link *link;
>> +	struct imx_media_pad *pad;
>> +	u16 source_pad, sink_pad;
>> +	int num_pads, i, j, k;
>> +	int ret = 0;
>> +
>> +	for (i = 0; i < imxmd->num_subdevs; i++) {
>> +		local_sd = &imxmd->subdev[i];
>> +		num_pads = local_sd->num_sink_pads + local_sd->num_src_pads;
>> +
>> +		for (j = 0; j < num_pads; j++) {
>> +			pad = &local_sd->pad[j];
>> +
>> +			for (k = 0; k < pad->num_links; k++) {
>> +				link = &pad->link[k];
>> +
>>   <snip>
> Indentation depth is quite terrific.

yes, it needs to iterate by subdev, pads in the subdev, then links
in the pad. But I moved the code under the innermost loop into a
function imx_media_create_link(), which creates a single media
link. So it's not so much an eye-sore now.

>
>
>> +static struct platform_driver imx_media_pdrv = {
>> +	.probe		= imx_media_probe,
>> +	.remove		= imx_media_remove,
>> +	.driver		= {
>> +		.name	= DEVICE_NAME,
>> +		.owner	= THIS_MODULE,
> Setting of .owner is not needed nowadays IIRC.

a quick look at struct device_driver definition didn't mention that
.owner member is deprecated or not needed, so for now I'll leave
it in place. We can revisit that later.

>
>> +		.of_match_table	= imx_media_dt_ids,
>> +	},
>> +};
>> +
>> +module_platform_driver(imx_media_pdrv);
>> +
>> +MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
>> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
>> new file mode 100644
>> index 0000000..52bfa8d
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-fim.c
>> @@ -0,0 +1,509 @@
>> +/*
>> + * Frame Interval Monitor.
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/slab.h>
>> +#include <linux/platform_device.h>
>> +#ifdef CONFIG_IMX_GPT_ICAP
>> +#include <linux/mxc_icap.h>
>> +#endif
> This looks clumsy. Include it unconditionally, if needed
> do #ifdef's inside the header file.

The i.MX input capture patch will come later. These are just
placeholders until then, the config name could even change.
For now I just removed the above conditional include.

>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
> Please sort out the list alphabetically.

done.

>> +	if (IS_ENABLED(CONFIG_IMX_GPT_ICAP)) {
>> +		ret = of_property_read_u32_array(fim_np,
>> +						 "input-capture-channel",
>> +						 icap, 2);
>> +		if (!ret) {
>> +			fim->icap_channel = icap[0];
>> +			fim->icap_flags = icap[1];
>> +		}
> Should you return error otherwise?

nope, it's an optional property.

>
>> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
>> new file mode 100644
>> index 0000000..018d05a
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-of.c
>> @@ -0,0 +1,291 @@
>> +/*
>> + * Media driver for Freescale i.MX5/6 SOC
>> + *
>> + * Open Firmware parsing.
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/of_platform.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
> Please sort out the list alphabetically.

done.

>>
>> +static int of_get_port_count(const struct device_node *np)
>> +{
>> +	struct device_node *child;
>> +	int num = 0;
>> +
>> +	/* if this node is itself a port, return 1 */
>> +	if (of_node_cmp(np->name, "port") == 0)
>> +		return 1;
>> +
>> +	for_each_child_of_node(np, child) {
>> +		if (of_node_cmp(child->name, "port") == 0)
>> +			num++;
>> +	}
> Unneeded bracers.

fixed.

>
>> +static struct imx_media_subdev *
>> +of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
>> +		bool is_csi_port)
>> +{
>> +	struct imx_media_subdev *imxsd;
>> +	int i, num_pads, ret;
>> +
>> +	if (!of_device_is_available(sd_np)) {
>> +		dev_dbg(imxmd->dev, "%s: %s not enabled\n", __func__,
>> +			sd_np->name);
>> +		return NULL;
>> +	}
>> +
>> +	/* register this subdev with async notifier */
>> +	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
>> +	if (!imxsd)
>> +		return NULL;
>> +	if (IS_ERR(imxsd))
>> +		return imxsd;
> if (IS_ERR_OR_NULL(imxsd))
> 	return imxsd;

yep, done.

>> +
>> +	if (imxsd->num_sink_pads == 0) {
>> +		/* this might be a sensor */
>> +		of_parse_sensor(imxmd, imxsd, sd_np);
>> +	}
> Unneeded bracers.

ok removed.

>
>> +
>> +	for (i = 0; i < num_pads; i++) {
>> +		struct device_node *epnode = NULL, *port, *remote_np;
>> +		struct imx_media_subdev *remote_imxsd;
>> +		struct imx_media_pad *pad;
>> +		int remote_pad;
> Too deep indentation, may be move the cycle body into a separate function?

in this case I prefer not to, of_parse_subdev() is called recursively, and I
think it's bad form to hide that fact by moving the recursive call into a
separate function. The indentation is not that deep, only two loops deep.


>
>> +
>> +		/* init this pad */
>> +		pad = &imxsd->pad[i];
>> +		pad->pad.flags = (i < imxsd->num_sink_pads) ?
>> +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
>> +
>> +		if (is_csi_port)
>> +			port = (i < imxsd->num_sink_pads) ? sd_np : NULL;
>> +		else
>> +			port = of_graph_get_port_by_id(sd_np, i);
>> +		if (!port)
>> +			continue;
>> +
>> +		while ((epnode = of_get_next_child(port, epnode))) {
> Please reuse for_each_child_of_node() here.

done.

>
>> +			of_get_remote_pad(epnode, &remote_np, &remote_pad);
>> +			if (!remote_np) {
>> +				of_node_put(epnode);
> Please remove of_node_put() here, of_get_next_child() does it.

oops, good catch, fixed.

>
>> +				continue;
>> +			}
>> +
>> +			ret = of_add_pad_link(imxmd, pad, sd_np, remote_np,
>> +					      i, remote_pad);
>> +			if (ret) {
>> +				imxsd = ERR_PTR(ret);
>> +				break;
>> +			}
>> +
>> +			if (i < imxsd->num_sink_pads) {
>> +				/* follow sink endpoints upstream */
>> +				remote_imxsd = of_parse_subdev(imxmd,
>> +							       remote_np,
>> +							       false);
>> +				if (IS_ERR(remote_imxsd)) {
>> +					imxsd = remote_imxsd;
>> +					break;
>> +				}
>> +			}
>> +
>> +			of_node_put(remote_np);
>> +			of_node_put(epnode);

also removed this put of epnode.

>>
>> +
>> +int imx_media_of_parse(struct imx_media_dev *imxmd,
>> +		       struct imx_media_subdev *(*csi)[4],
>> +		       struct device_node *np)
>> +{
>> +	struct device_node *csi_np;
>> +	struct imx_media_subdev *lcsi;
> Please swap two lines above to get the reverse christmas tree ordering.

done.

>
>> +	u32 ipu_id, csi_id;
>> +	int i, ret;
>> +
>> +	for (i = 0; ; i++) {
>> +		csi_np = of_parse_phandle(np, "ports", i);
>> +		if (!csi_np)
>> +			break;
>> +
>> +		lcsi = of_parse_subdev(imxmd, csi_np, true);
>> +		if (IS_ERR(lcsi)) {
>> +			ret = PTR_ERR(lcsi);
>> +			goto err_put;
>> +		}
>> +
>> +		of_property_read_u32(csi_np, "reg", &csi_id);
> Not sure if it is safe enough to ignore return value and potentially
> left csi_id uninitialized.

The CSI nodes are port nodes, and the reg property is required,
so I added a check and error return here.

>
>> +		ipu_id = of_alias_get_id(csi_np->parent, "ipu");
>> +
>> +		if (ipu_id > 1 || csi_id > 1) {
>> +			dev_err(imxmd->dev, "%s: invalid ipu/csi id (%u/%u)\n",
>> +				__func__, ipu_id, csi_id);
>> +			ret = -EINVAL;
>> +			goto err_put;
>> +		}
>> +
>> +		of_node_put(csi_np);
> You can put the node right after of_alias_get_id() call, then in case
> of error return right from the if block and remove the goto label.

done.

>
>> +
>> +		(*csi)[ipu_id * 2 + csi_id] = lcsi;
>> +	}
>> +
>> +	return 0;
>> +err_put:
>> +	of_node_put(csi_np);
>> +	return ret;
>> +}
>> diff --git a/drivers/staging/media/imx/imx-media-of.h b/drivers/staging/media/imx/imx-media-of.h
>> new file mode 100644
>> index 0000000..0c61b05
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-of.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
>> + *
>> + * Open Firmware parsing.
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#ifndef _IMX_MEDIA_OF_H
>> +#define _IMX_MEDIA_OF_H
>> +
> I do believe you should include some headers or add declarations
> of "struct imx_media_dev", "struct imx_media_subdev", "struct device_node".

actually imx-media-of.h isn't really needed, I just moved those prototypes
into imx-media.h and removed imx-media-of.h.

>> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
>> new file mode 100644
>> index 0000000..6a018a9
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media.h
>> @@ -0,0 +1,299 @@
>> +/*
>> + * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#ifndef _IMX_MEDIA_H
>> +#define _IMX_MEDIA_H
> Please insert here an empty line to improve readability.

done.

>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-of.h>
> Please sort out the list alphabetically.

done.

Steve

