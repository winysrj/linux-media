Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42221 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0LZTTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 14:19:31 -0500
Received: by fxm20 with SMTP id 20so8757841fxm.19
        for <linux-media@vger.kernel.org>; Sun, 26 Dec 2010 11:19:30 -0800 (PST)
Message-ID: <4D17953E.7080008@gmail.com>
Date: Sun, 26 Dec 2010 20:19:26 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v10 4/8] davinci vpbe: VENC( Video Encoder) implementation
References: <1293105271-17254-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1293105271-17254-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Manjunath,

On 12/23/2010 12:54 PM, Manjunath Hadli wrote:
> This patch adds the VENC or the Video encoder, whichis responsible
> for the blending of al source planes and timing generation for Video
> modes like NTSC, PAL and other digital outputs. the VENC implementation
> currently supports COMPOSITE and COMPONENT outputs and NTSC and PAL
> resolutions through the analog DACs. The venc block is implemented
> as a subdevice, allowing for additional extenal and internal encoders
> of other kind to plug-in.
>
> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
> ---
>   drivers/media/video/davinci/vpbe_venc.c      |  568 ++++++++++++++++++++++++++
>   drivers/media/video/davinci/vpbe_venc_regs.h |  189 +++++++++
>   include/media/davinci/vpbe_venc.h            |   38 ++
>   3 files changed, 795 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/davinci/vpbe_venc.c
>   create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
>   create mode 100644 include/media/davinci/vpbe_venc.h
>
> diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
> new file mode 100644
> index 0000000..a4849eb
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpbe_venc.c
> @@ -0,0 +1,568 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +#include<linux/module.h>
> +#include<linux/kernel.h>
> +#include<linux/init.h>
> +#include<linux/ctype.h>
> +#include<linux/delay.h>
> +#include<linux/device.h>
> +#include<linux/interrupt.h>
> +#include<linux/platform_device.h>
> +#include<linux/videodev2.h>
> +#include<linux/slab.h>
> +
> +#include<mach/hardware.h>
> +#include<mach/mux.h>
> +#include<mach/io.h>
> +#include<mach/i2c.h>
> +
> +#include<linux/io.h>
> +
> +#include<media/davinci/vpbe_types.h>
> +#include<media/davinci/vpbe_venc.h>
> +#include<media/davinci/vpss.h>
> +#include<media/v4l2-device.h>
> +
> +#include "vpbe_venc_regs.h"
> +
> +#define MODULE_NAME	VPBE_VENC_SUBDEV_NAME
> +
> +static int debug = 2;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level 0-2");
> +
> +struct venc_state {
> +	struct v4l2_subdev sd;
> +	struct venc_callback *callback;
> +	struct venc_platform_data *pdata;
> +	struct device *pdev;
> +	u32 output;
> +	v4l2_std_id std;
> +	spinlock_t lock;
> +	void __iomem *venc_base;
> +	void __iomem *vdaccfg_reg;
> +};
> +
> +static inline struct venc_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct venc_state, sd);
> +}
> +
> +static inline u32 venc_read(struct v4l2_subdev *sd, u32 offset)
> +{
> +	struct venc_state *venc = to_state(sd);
> +
> +	return __raw_readl(venc->venc_base + offset);

Isn't it more appropriate to use readl instead of its __raw_*
counterpart to access the ioremapped memory?

> +}
> +
> +static inline u32 venc_write(struct v4l2_subdev *sd, u32 offset, u32 val)
> +{
> +	struct venc_state *venc = to_state(sd);
> +	__raw_writel(val, (venc->venc_base + offset));
> +	return val;
> +}
> +
> +static inline u32 venc_modify(struct v4l2_subdev *sd, u32 offset,
> +				 u32 val, u32 mask)
> +{
> +	u32 new_val = (venc_read(sd, offset)&  ~mask) | (val&  mask);
> +
> +	venc_write(sd, offset, new_val);
> +	return new_val;
> +}
> +
> +static inline u32 vdaccfg_write(struct v4l2_subdev *sd, u32 val)
> +{
> +	struct venc_state *venc = to_state(sd);
> +
> +	__raw_writel(val, venc->vdaccfg_reg);
> +
> +	val = __raw_readl(venc->vdaccfg_reg);
> +	return val;
> +}
> +
<snip>
> +
> +static const struct v4l2_subdev_core_ops venc_core_ops = {
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = venc_g_register,
> +#endif
> +};
> +
> +static const struct v4l2_subdev_video_ops venc_video_ops = {
> +	.s_routing = venc_s_routing,
> +	.s_std_output = venc_s_std_output,
> +	.s_dv_preset = venc_s_dv_preset,
> +};
> +
> +static const struct v4l2_subdev_ops venc_ops = {
> +	.core =&venc_core_ops,
> +	.video =&venc_video_ops,
> +};
> +
> +static int venc_initialize(struct v4l2_subdev *sd)
> +{
> +	struct venc_state *venc = to_state(sd);
> +	int ret = 0;
> +
> +	/* Set default to output to composite and std to NTSC */
> +	venc->output = 0;
> +	venc->std = V4L2_STD_525_60;
> +
> +	ret = venc_s_routing(sd, 0, venc->output, 0);
> +	if (ret<  0) {
> +		v4l2_err(sd, "Error setting output during init\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = venc_s_std_output(sd, venc->std);
> +	if (ret<  0) {
> +		v4l2_err(sd, "Error setting std during init\n");
> +		return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static int venc_device_get(struct device *dev, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct venc_state **venc = data;
> +
> +	if (strcmp(MODULE_NAME, pdev->name) == 0)
> +		*venc = platform_get_drvdata(pdev);
> +	return 0;
> +}
> +
> +struct v4l2_subdev *venc_sub_dev_init(struct v4l2_device *v4l2_dev,
> +		const char *venc_name)
> +{
> +	struct venc_state *venc;
> +	int err;
> +
> +	err = bus_for_each_dev(&platform_bus_type, NULL,&venc,
> +			venc_device_get);
> +	if (venc == NULL)
> +		return NULL;
> +
> +	v4l2_subdev_init(&venc->sd,&venc_ops);
> +
> +	strcpy(venc->sd.name, venc_name);
> +	if (v4l2_device_register_subdev(v4l2_dev,&venc->sd)<  0) {
> +		v4l2_err(v4l2_dev,
> +			"vpbe unable to register venc sub device\n");
> +		return NULL;
> +	}
> +	if (venc_initialize(&venc->sd)) {
> +		v4l2_err(v4l2_dev,
> +			"vpbe venc initialization failed\n");
> +		return NULL;
> +	}
> +	return&venc->sd;
> +}
> +EXPORT_SYMBOL(venc_sub_dev_init);
> +
> +static int venc_probe(struct platform_device *pdev)
> +{
> +	struct venc_state *venc;
> +	struct resource *res;
> +	int ret;
> +
> +	venc = kzalloc(sizeof(struct venc_state), GFP_KERNEL);
> +	if (venc == NULL)
> +		return -ENOMEM;
> +
> +	venc->pdev =&pdev->dev;
> +	venc->pdata = pdev->dev.platform_data;
> +	if (NULL == venc->pdata) {
> +		dev_err(venc->pdev, "Unable to get platform data for"
> +			" VENC sub device");
> +		ret = -ENOENT;
> +		goto free_mem;
> +	}
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(venc->pdev,
> +			"Unable to get VENC register address map\n");
> +		ret = -ENODEV;
> +		goto free_mem;
> +	}

You are not calling request_mem_region here?
Note: release_mem_region is invoked below and in venc_remove(...).

> +
> +	venc->venc_base = ioremap_nocache(res->start, resource_size(res));
> +	if (!venc->venc_base) {
> +		dev_err(venc->pdev, "Unable to map VENC IO space\n");
> +		ret = -ENODEV;
> +		goto release_venc_mem_region;
> +	}
> +
> +	spin_lock_init(&venc->lock);
> +	platform_set_drvdata(pdev, venc);
> +	dev_notice(venc->pdev, "VENC sub device probe success\n");
> +	return 0;
> +
> +release_venc_mem_region:

"res" is already initialized at this point so the line below
seems superfluous.

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(res->start, resource_size(res));
> +free_mem:
> +	kfree(venc);
> +	return ret;
> +}
> +
> +static int venc_remove(struct platform_device *pdev)
> +{
> +	struct venc_state *venc = platform_get_drvdata(pdev);
> +	struct resource *res;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	iounmap((void *)venc->venc_base);
> +	release_mem_region(res->start, resource_size(res));
> +	kfree(venc);
> +	return 0;
> +}
> +
> +static struct platform_driver venc_driver = {
> +	.probe		= venc_probe,
> +	.remove		= venc_remove,
> +	.driver		= {
> +		.name	= MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int venc_init(void)
> +{
> +	/* Register the driver */
> +	if (platform_driver_register(&venc_driver)) {
> +		printk(KERN_ERR "Unable to register venc driver\n");
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +static void venc_exit(void)
> +{
> +	platform_driver_unregister(&venc_driver);
> +	return;
> +}
> +
> +module_init(venc_init);
> +module_exit(venc_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("VPBE VENC Driver");
> +MODULE_AUTHOR("Texas Instruments");

<snip>


Regards,

Sylwester
