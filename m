Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29517 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3FYQzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 12:55:52 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOY00MWLKCRPG10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 17:55:50 +0100 (BST)
Message-id: <51C9CB95.2040006@samsung.com>
Date: Tue, 25 Jun 2013 18:55:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
References: <201306241054.11604.hverkuil@xs4all.nl>
In-reply-to: <201306241054.11604.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Cc: Laurent and Sakari

On 06/24/2013 10:54 AM, Hans Verkuil wrote:
> Hi Sylwester,
> 
> It came to my attention that several i2c subdev drivers overwrite the sd->name
> as set by v4l2_i2c_subdev_init with a custom name.
> 
> This is wrong if it is possible that there are multiple identical sensors in
> the system. The sd->name must be unique since it is used to prefix kernel
> messages etc, so you have to be able to tell the sensor devices apart.

This has been discussed in the past, please see thread [1]. 

> It concerns the following Samsung-contributed drivers:
> 
> drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
> drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
> drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));

It seems ov9650 is missing on this list,

$ git grep ".*cpy.*(.*sd\|subdev.*name" -- drivers/media/i2c
drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
drivers/media/i2c/ov9650.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
drivers/media/i2c/smiapp/smiapp-core.c:         subdev->name, code->pad, code->index);
drivers/media/i2c/smiapp/smiapp-core.c: strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));
drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
drivers/media/i2c/tvp514x.c:    strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));

> If there can be only one sensor (because it is integrated in the SoC),
> then there is no problem with doing this. But it is not obvious to me
> which of these drivers are for integrated systems, and which aren't.

Those sensors are standalone devices, I'm not aware of any of them to be 
integrated with an Application Processor SoC. I've never seen something 
like that. However some of those devices are hybrid modules with a raw 
image sensor and an ISP SoC.
So in theory there could be multiple such devices in a single system, 
although personally I've never seen something like that.

> I can make patches for those that need to be fixed if you can tell me
> which drivers are affected.

You may want to have a look at the commits listed below, and the comments 
I received to that [2] patch series...

commit 2138d73b69be1cfa4982c9949f2445ec77ea9edc
[media] noon010pc30: Make subdev name independent of the I2C slave address

commit 14b702dd71d38b6d0662251b3f8cd60da98602ce
[media] s5k6aa: Make subdev name independent of the I2C slave address

commit c5024a70bb60b678f08586ed786340ec162d250f
[media] m5mols: Make subdev name independent of the I2C slave address

Before we start messing with those drivers it would be nice to have 
defined rules of the media entity naming. I2C bus number and address
is not something that's useful in the media entity name. And multiple
sensors (smiapp, s5c73m3, upcoming s5k6bafx) have "logical" subdevs 
that are not initialized with the i2c specific v4l2 functions.

I guess there are other means to ensure the subdev's name is unique,
rather than appending I2C bus info to it that changes from board to
board and is totally irrelevant in user space.

Presumably we could have subdev name postfixed with I2C bus id/slave
address as it is done currently and the media core would be using only
a part of subdev's name up to ' ' character to initialize the entity
name ? The media entities have unique ID, hence it would have probably
been OK to have entities with same name, should it happen there are 
multiple identical devices in a single system.

To summarize, I would prefer to avoid modifying those drivers in a
backward incompatible way, for a sake of pure API correctness and
due to vague reasons. There is currently no board in mainline for
which the subdev names wouldn't have been unique. Usually there 
are different types of image sensors used for the front and the 
rear facing camera. But for stereoscopy there most likely would
be two identical image sensors on a board. 

Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg58437.html
[2] http://www.spinics.net/lists/linux-media/msg44445.html
