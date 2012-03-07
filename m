Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47096 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2CGXOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 18:14:50 -0500
Received: by eekc41 with SMTP id c41so2516966eek.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 15:14:49 -0800 (PST)
Message-ID: <4F57EBD8.5020404@gmail.com>
Date: Thu, 08 Mar 2012 00:14:32 +0100
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
References: <005301cceba7$6be94fe0$43bbefa0$%kang@samsung.com> <4F4EAA4D.4010100@gmail.com> <005001ccfabe$31d5fee0$9581fca0$%kang@samsung.com>
In-Reply-To: <005001ccfabe$31d5fee0$9581fca0$%kang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sungchun,

On 03/05/2012 11:53 AM, Sungchun Kang wrote:
> On 03/01/2012 07:44 AM, Sylwester Nawrocki wrote:
>> On 02/15/2012 07:02 AM, Sungchun Kang wrote:
>>> Since the EXYNOS5 SoCs have various multimedia IPs such as Gscaler,
>>> FIMC-LITE, and MIXER, and so on.
>>> Additionally, media controller interface is needed to configure
>>> connection between them and to control each IPs.
>>>
>>> This patch adds support media device for EXYNOS5 SoCs.
>>> Actually, there are three media devices such as below diagram which
>>> are using media control framework.
>>> Since they are not belong to one hardware block, we need to manage
>> it
>>> for connecting with each devices.
>>>
>>> Follwing is detailed list of them:
>>>
>>> * Gscaler: general scaler
>>>     Support memory to memory interface
>>>     Support output interface from memory to display device(LCD, TV)
>>>     Support capture interface from device(FIMC-LITE, FIMD) to memory
>>>
>>> * MIPI-CSIS
>>>     Support interconnection(subdev interface) between devices
>>
>> Is there any difference in s5p/exynos4 and exynos5 MIPI-CSIS devices ?
>> I suspect there isn't and the existing MIPI-CSIS driver can be used
>> for
>> exynos5 too.
>>
> It is same hardware, and driver is almost identical.
> But I copied from s5p-fimc directory to exynos directory, because we use
> media controller framework in each other hardware. - reference from my first mail

I see, you register the subdevs in a bit different way. You're not justified
to copy the code all around though :-) Code duplication in short term might
look like a quick and easy solution, but it's more a recipe for disaster.
Certainly there is no place for such in the mainline.

Technically, supporting your sub-devices registration method in the s5p-csis
module is rather trivial (thanks to that I've designed it as an independent 
driver), except that the initialization scheme you've adopted doesn't seem
right to me.

Do you have plans on how to instantiate your exynos5 media drivers, including
sensor/video encoder subdevs, from the device tree ?
I bet you'll find easier to do it in the case, where the media device driver
coordinates (sub)devices' probing/initialization.

> Surely, you are author of mipi-csis driver in s5p-fimc directory and I 
> re-used most of your code.
> So, I will not submit mipi-csis driver.

But you need it, so we should agree on the directory/files layout and 
the kernel APIs to allow the common modules to be freely reused.
 
I've seen patches for the other devices, like HDMI/TV out, JPEG, etc. They 
are basically extending the existing drivers/media/video/s5p-* drivers.

I wonder, if we could do something similar with FIMC, e.g. rename 
drivers/media/video/s5p-fimc to drivers/media/video/fimc and implement there
an uniform user interface for as many SoC revisions as possible ?

Common headers would have been in include/media, and include/video if needed.

What do you think ?

>>> * FIMC-LITE
>>>     Support capture interface from device(Sensor, MIPI-CSIS) to memory
>>>     Support interconnection(subdev interface) between devices
>>
>> This device is also present on exynos4212/4412 SoCs. Can you tell
>> what's difference between FIMC-LITE on Exynos4 and Exynos5 ?
>> Either we need separate FIMC-LITE drivers or we need a shared one. I'd
>> like to clarify this first.
>>
>>> * MIXER
>>>     Support output interface from memory to device(HDMI)
>>>     Support interconnection(subdev interface) between devices
>>>
>>> * FIMD
>>>     Support framebuffer interface
>>>     Support subdev interface to display frames sent from Gscaler
>>
>> What about Exynos DRM driver ? Do you have any plans to integrate the
>> V4L2 and the DRM driver ? IMHO DRM is more appropriate for some tasks
>> on display side, like 2D operations, multiple outputs, windows,
>> blending, etc.
>>
> I don't know about DRM, can you explain to me about it, or let me know mail-thread?

I'm no expert in the DRM area, you might get better results contacting 
Mr. Inki Dae, Seung-Wo Kim or Joonyoung Shim directly.

Please check this site for an ELCE presentation slides:
http://elinux.org/ELCE_2011_Presentations_redirect#Table_of_Presentations
("DRM Driver Development For Embedded Systems")

>>> * Rotator
>>>     Support memory to memory interface
>>>
>>> * m2m-scaler
>>>     Support only memory to memory interface
>>>
>>> * And so on...
>>>
>>>    1) media 0
>>>     LCD Output path consists of Gscaler and FIMD(display controller).
>>>     +----------------+     +------+
>>>     | Gscaler-output | -->   | FIMD | -->   LCD
>>>     +----------------+     +------+
>>>
>>>     HDMI Output path consists of Gscaler, Mixer and HDMI.
>>>     +----------------+     +-------+     +------+
>>>     | Gscaler-output | -->   | MIXER | -->   | HDMI | -->   TV
>>>     +----------------+     +-------+     +------+
>>>
>>> +--------+     +-----------+     +-----------+     +-----------------+
>>>
>>>    2) media 1
>>>     Camera Capture path consists of MIPI-CSIS, FIMC-LITE and Gscaler
>>>     +--------+     +-----------+     +-----------------+
>>>     | Sensor | -->   | FIMC-LITE | -->   | Gscaler-capture |
>>>     +--------+     +-----------+     +-----------------+
>>>
>>>     +--------+     +-----------+     +-----------+     +-----------------
>> +
>>>     | Sensor | -->   | MIPI-CSIS | -->   | FIMC-LITE | -->   | Gscaler-
>> capture |
>>>     +--------+     +-----------+     +-----------+     +-----------------
>> +
>>>
>>> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
>>> ---
>>>    drivers/media/video/exynos/mdev/Kconfig       |    8 ++
>>>    drivers/media/video/exynos/mdev/Makefile      |    2 +
>>>    drivers/media/video/exynos/mdev/exynos-mdev.c |  115
>> ++++++++++++++++++
>>>    include/media/exynos_mc.h                     |  160
>> +++++++++++++++++++++++++
>>>    4 files changed, 285 insertions(+), 0 deletions(-)
>>>    create mode 100644 drivers/media/video/exynos/mdev/Kconfig
>>>    create mode 100644 drivers/media/video/exynos/mdev/Makefile
>>>    create mode 100644 drivers/media/video/exynos/mdev/exynos-mdev.c
>>>    create mode 100644 include/media/exynos_mc.h
>>>
>>> diff --git a/drivers/media/video/exynos/mdev/Kconfig
>>> b/drivers/media/video/exynos/mdev/Kconfig
>>> new file mode 100644
>>> index 0000000..15134b0
>>> --- /dev/null
>>> +++ b/drivers/media/video/exynos/mdev/Kconfig
>>> @@ -0,0 +1,8 @@
>>> +config EXYNOS_MEDIA_DEVICE
>>> +	bool
>>> +	depends on MEDIA_EXYNOS
>>> +	select MEDIA_CONTROLLER
>>> +	select VIDEO_V4L2_SUBDEV_API
>>> +	default y
>>> +	help
>>> +	  This is a v4l2 driver for exynos media device.
>>> diff --git a/drivers/media/video/exynos/mdev/Makefile
>>> b/drivers/media/video/exynos/mdev/Makefile
>>> new file mode 100644
>>> index 0000000..175a4bc
>>> --- /dev/null
>>> +++ b/drivers/media/video/exynos/mdev/Makefile
>>> @@ -0,0 +1,2 @@
>>> +mdev-objs := exynos-mdev.o
>>> +obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev.o
>>> diff --git a/drivers/media/video/exynos/mdev/exynos-mdev.c
>>> b/drivers/media/video/exynos/mdev/exynos-mdev.c
>>> new file mode 100644
>>> index 0000000..a76e7c3
>>> --- /dev/null
>>> +++ b/drivers/media/video/exynos/mdev/exynos-mdev.c
>>> @@ -0,0 +1,115 @@
>>> +/* drviers/media/video/exynos/mdev/exynos-mdev.c
>>> + *
>>> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
>>> + *		http://www.samsung.com
>>> + *
>>> + * EXYNOS5 SoC series media device driver
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> +modify
>>> + * it under the terms of the GNU General Public License version 2
>> as
>>> + * published by the Free Software Foundation.
>>> +*/
>>> +
>>> +#include<linux/bug.h>
>>> +#include<linux/device.h>
>>> +#include<linux/errno.h>
>>> +#include<linux/i2c.h>
>>> +#include<linux/kernel.h>
>>> +#include<linux/list.h>
>>> +#include<linux/module.h>
>>> +#include<linux/platform_device.h>
>>> +#include<linux/pm_runtime.h>
>>> +#include<linux/types.h>
>>> +#include<linux/slab.h>
>>> +#include<linux/version.h>
>>> +#include<media/v4l2-ctrls.h>
>>> +#include<media/media-device.h>
>>> +#include<media/exynos_mc.h>
>>> +
>>> +static int __devinit mdev_probe(struct platform_device *pdev) {
>>> +	struct v4l2_device *v4l2_dev;
>>> +	struct exynos_md *mdev;
>>> +	int ret;
>>> +
>>> +	mdev = kzalloc(sizeof(struct exynos_md), GFP_KERNEL);
>>> +	if (!mdev)
>>> +		return -ENOMEM;
>>> +
>>> +	mdev->id = pdev->id;
>>> +	mdev->pdev = pdev;
>>> +	spin_lock_init(&mdev->slock);
>>> +
>>> +	snprintf(mdev->media_dev.model, sizeof(mdev->media_dev.model),
>> "%s%d",
>>> +		 dev_name(&pdev->dev), mdev->id);
>>> +
>>> +	mdev->media_dev.dev =&pdev->dev;
>>> +
>>> +	v4l2_dev =&mdev->v4l2_dev;
>>> +	v4l2_dev->mdev =&mdev->media_dev;
>>> +	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s",
>>> +		 dev_name(&pdev->dev));
>>> +
>>> +	ret = v4l2_device_register(&pdev->dev,&mdev->v4l2_dev);
>>> +	if (ret<   0) {
>>> +		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n",
>> ret);
>>> +		goto err_v4l2_reg;
>>> +	}
>>> +	ret = media_device_register(&mdev->media_dev);
>>> +	if (ret<   0) {
>>> +		v4l2_err(v4l2_dev, "Failed to register media device: %d\n",
>> ret);
>>> +		goto err_mdev_reg;
>>> +	}
>>
>> At this point you have registered a media device which isn't
>> functional, i.e. it doesn't have all expected entities. What is the
>> rationale behind such decision ? If you look at the s5p-fimc driver,
>> it ensures all entities and their drivers are present and then
>> registers a media device itself.
>> The data describing which entities are present in the system is
>> contained in the media device's platform_data. This is also helpful
>> for instantiation from the device tree, the media entities would be
>> described by child nodes of an aggregate node - which would bound to
>> the platform device driver registering a media device.
>>
> In exynos5, there are 3 media devices.(media0~2)

Can you please list how the devices are partitioned onto each media device ?
Perhaps you could provide a graph using the media-ctl tool from Laurent ?

Here are some details:
 http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2011-September/023373.html

And the media-ctl sources are available here: 
 http://git.ideasonboard.org/?p=media-ctl.git;a=summary

> First, media devices is probed according to "Makefile".
> And the last probed driver called v4l2_device_register_subdev_nodes using 
> late_initcall.
> I know this is not great method. But in order to use mc, I think this is out
> of our control.

Does it mean you don't support camera, display,.. drivers as modules at all ? 

If you haven't anticipated using those drivers as the loadable kernel 
modules then there might long way before you until they are merged upstream. 
We will eventually have kernels covering multiple SoC and the LKM support is
an important feature. You can have different plans for your internal 
implementations, but for the mainline I don't think I'm going to agree
to ignore it.

We probably need some notification mechanism that would be registered by each 
media device driver and then the subdevs would use it, so that an aggregate 
driver can complete initialization.

>> At this point exynos5 drivers are incompatible with s5p-fimc driver,
>> effectively preventing the modules reuse.
>>
> In exynos5, the fimc hardware is removed.

It's rather irrelevant. What's important is that some IPs are used in unchanged
form within multiple SoC series. I was referring to s5p-fimc as the whole camera
interface driver for s5pv210, exynos4210/4x12 SoC, with MIPI-CSIS included.

--
Regards,
Sylwester
