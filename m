Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47458 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2B2Woh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 17:44:37 -0500
Received: by eekc41 with SMTP id c41so1795272eek.19
        for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 14:44:35 -0800 (PST)
Message-ID: <4F4EAA4D.4010100@gmail.com>
Date: Wed, 29 Feb 2012 23:44:29 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: sungchun.kang@samsung.com
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, younglak1004.kim@samsung.com,
	june.bae@samsung.com, ym.song@samsung.com, jaeryul.oh@samsung.com,
	sy0816.kang@samsung.com, jtp.park@samsung.com, jiun.yu@samsung.com,
	jonghun.han@samsung.com, jg1.han@samsung.com,
	khw0178.kim@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH] media: media-dev: Add media devices for EXYNOS5
References: <005301cceba7$6be94fe0$43bbefa0$%kang@samsung.com>
In-Reply-To: <005301cceba7$6be94fe0$43bbefa0$%kang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sungchun,

On 02/15/2012 07:02 AM, Sungchun Kang wrote:
> Since the EXYNOS5 SoCs have various multimedia IPs
> such as Gscaler, FIMC-LITE, and MIXER, and so on.
> Additionally, media controller interface is needed
> to configure connection between them and to control each IPs.
> 
> This patch adds support media device for EXYNOS5 SoCs.
> Actually, there are three media devices such as below
> diagram which are using media control framework.
> Since they are not belong to one hardware block, we
> need to manage it for connecting with each devices.
> 
> Follwing is detailed list of them:
> 
> * Gscaler: general scaler
>    Support memory to memory interface
>    Support output interface from memory to display device(LCD, TV)
>    Support capture interface from device(FIMC-LITE, FIMD) to memory
> 
> * MIPI-CSIS
>    Support interconnection(subdev interface) between devices

Is there any difference in s5p/exynos4 and exynos5 MIPI-CSIS devices ?
I suspect there isn't and the existing MIPI-CSIS driver can be used for
exynos5 too. 

> 
> * FIMC-LITE
>    Support capture interface from device(Sensor, MIPI-CSIS) to memory
>    Support interconnection(subdev interface) between devices

This device is also present on exynos4212/4412 SoCs. Can you tell what's
difference between FIMC-LITE on Exynos4 and Exynos5 ?
Either we need separate FIMC-LITE drivers or we need a shared one. I'd like
to clarify this first.

> * MIXER
>    Support output interface from memory to device(HDMI)
>    Support interconnection(subdev interface) between devices
> 
> * FIMD
>    Support framebuffer interface
>    Support subdev interface to display frames sent from Gscaler

What about Exynos DRM driver ? Do you have any plans to integrate the V4L2
and the DRM driver ? IMHO DRM is more appropriate for some tasks on display
side, like 2D operations, multiple outputs, windows, blending, etc.

> * Rotator
>    Support memory to memory interface
> 
> * m2m-scaler
>    Support only memory to memory interface
> 
> * And so on...
> 
>   1) media 0
>    LCD Output path consists of Gscaler and FIMD(display controller).
>    +----------------+     +------+
>    | Gscaler-output | -->  | FIMD | -->  LCD
>    +----------------+     +------+
> 
>    HDMI Output path consists of Gscaler, Mixer and HDMI.
>    +----------------+     +-------+     +------+
>    | Gscaler-output | -->  | MIXER | -->  | HDMI | -->  TV
>    +----------------+     +-------+     +------+
> 
> +--------+     +-----------+     +-----------+     +-----------------+
> 
>   2) media 1
>    Camera Capture path consists of MIPI-CSIS, FIMC-LITE and Gscaler
>    +--------+     +-----------+     +-----------------+
>    | Sensor | -->  | FIMC-LITE | -->  | Gscaler-capture |
>    +--------+     +-----------+     +-----------------+
> 
>    +--------+     +-----------+     +-----------+     +-----------------+
>    | Sensor | -->  | MIPI-CSIS | -->  | FIMC-LITE | -->  | Gscaler-capture |
>    +--------+     +-----------+     +-----------+     +-----------------+
> 
> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
> ---
>   drivers/media/video/exynos/mdev/Kconfig       |    8 ++
>   drivers/media/video/exynos/mdev/Makefile      |    2 +
>   drivers/media/video/exynos/mdev/exynos-mdev.c |  115 ++++++++++++++++++
>   include/media/exynos_mc.h                     |  160 +++++++++++++++++++++++++
>   4 files changed, 285 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/exynos/mdev/Kconfig
>   create mode 100644 drivers/media/video/exynos/mdev/Makefile
>   create mode 100644 drivers/media/video/exynos/mdev/exynos-mdev.c
>   create mode 100644 include/media/exynos_mc.h
> 
> diff --git a/drivers/media/video/exynos/mdev/Kconfig b/drivers/media/video/exynos/mdev/Kconfig
> new file mode 100644
> index 0000000..15134b0
> --- /dev/null
> +++ b/drivers/media/video/exynos/mdev/Kconfig
> @@ -0,0 +1,8 @@
> +config EXYNOS_MEDIA_DEVICE
> +	bool
> +	depends on MEDIA_EXYNOS
> +	select MEDIA_CONTROLLER
> +	select VIDEO_V4L2_SUBDEV_API
> +	default y
> +	help
> +	  This is a v4l2 driver for exynos media device.
> diff --git a/drivers/media/video/exynos/mdev/Makefile b/drivers/media/video/exynos/mdev/Makefile
> new file mode 100644
> index 0000000..175a4bc
> --- /dev/null
> +++ b/drivers/media/video/exynos/mdev/Makefile
> @@ -0,0 +1,2 @@
> +mdev-objs := exynos-mdev.o
> +obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev.o
> diff --git a/drivers/media/video/exynos/mdev/exynos-mdev.c b/drivers/media/video/exynos/mdev/exynos-mdev.c
> new file mode 100644
> index 0000000..a76e7c3
> --- /dev/null
> +++ b/drivers/media/video/exynos/mdev/exynos-mdev.c
> @@ -0,0 +1,115 @@
> +/* drviers/media/video/exynos/mdev/exynos-mdev.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * EXYNOS5 SoC series media device driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include<linux/bug.h>
> +#include<linux/device.h>
> +#include<linux/errno.h>
> +#include<linux/i2c.h>
> +#include<linux/kernel.h>
> +#include<linux/list.h>
> +#include<linux/module.h>
> +#include<linux/platform_device.h>
> +#include<linux/pm_runtime.h>
> +#include<linux/types.h>
> +#include<linux/slab.h>
> +#include<linux/version.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/media-device.h>
> +#include<media/exynos_mc.h>
> +
> +static int __devinit mdev_probe(struct platform_device *pdev)
> +{
> +	struct v4l2_device *v4l2_dev;
> +	struct exynos_md *mdev;
> +	int ret;
> +
> +	mdev = kzalloc(sizeof(struct exynos_md), GFP_KERNEL);
> +	if (!mdev)
> +		return -ENOMEM;
> +
> +	mdev->id = pdev->id;
> +	mdev->pdev = pdev;
> +	spin_lock_init(&mdev->slock);
> +
> +	snprintf(mdev->media_dev.model, sizeof(mdev->media_dev.model), "%s%d",
> +		 dev_name(&pdev->dev), mdev->id);
> +
> +	mdev->media_dev.dev =&pdev->dev;
> +
> +	v4l2_dev =&mdev->v4l2_dev;
> +	v4l2_dev->mdev =&mdev->media_dev;
> +	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
> +		 dev_name(&pdev->dev));
> +
> +	ret = v4l2_device_register(&pdev->dev,&mdev->v4l2_dev);
> +	if (ret<  0) {
> +		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
> +		goto err_v4l2_reg;
> +	}
> +	ret = media_device_register(&mdev->media_dev);
> +	if (ret<  0) {
> +		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
> +		goto err_mdev_reg;
> +	}

At this point you have registered a media device which isn't functional, 
i.e. it doesn't have all expected entities. What is the rationale behind 
such decision ? If you look at the s5p-fimc driver, it ensures all entities 
and their drivers are present and then registers a media device itself.
The data describing which entities are present in the system is contained
in the media device's platform_data. This is also helpful for instantiation
from the device tree, the media entities would be described by child nodes
of an aggregate node - which would bound to the platform device driver
registering a media device.

At this point exynos5 drivers are incompatible with s5p-fimc driver, 
effectively preventing the modules reuse.

> +
> +	platform_set_drvdata(pdev, mdev);
> +	v4l2_info(v4l2_dev, "Media%d[0x%08x] was registered successfully\n",
> +		  mdev->id, (unsigned int)mdev);
> +	return 0;
> +
> +err_mdev_reg:
> +	v4l2_device_unregister(&mdev->v4l2_dev);
> +err_v4l2_reg:
> +	kfree(mdev);
> +	return ret;
> +}
> +
> +static int __devexit mdev_remove(struct platform_device *pdev)
> +{
> +	struct exynos_md *mdev = platform_get_drvdata(pdev);
> +
> +	if (!mdev)
> +		return 0;
> +	media_device_unregister(&mdev->media_dev);
> +	v4l2_device_unregister(&mdev->v4l2_dev);
> +	kfree(mdev);
> +	return 0;
> +}
> +
> +static struct platform_driver mdev_driver = {
> +	.probe		= mdev_probe,
> +	.remove		= __devexit_p(mdev_remove),
> +	.driver = {
> +		.name	= MDEV_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +	}
> +};
> +
> +int __init mdev_init(void)
> +{
> +	int ret = platform_driver_register(&mdev_driver);
> +	if (ret)
> +		err("platform_driver_register failed: %d\n", ret);
> +	return ret;
> +}
> +
> +void __exit mdev_exit(void)
> +{
> +	platform_driver_unregister(&mdev_driver);
> +}
> +
> +module_init(mdev_init);
> +module_exit(mdev_exit);
> +
> +MODULE_AUTHOR("Hyunwoong Kim<khw0178.kim@samsung.com>");
> +MODULE_DESCRIPTION("EXYNOS5 SoC series media device driver");
> +MODULE_LICENSE("GPL");
<snip>

---

Thanks,
Sylwester
