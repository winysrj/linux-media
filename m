Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57040 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752382Ab3FZJAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 05:00:55 -0400
Date: Wed, 26 Jun 2013 12:00:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
Message-ID: <20130626090050.GK2064@valkosipuli.retiisi.org.uk>
References: <201306241054.11604.hverkuil@xs4all.nl>
 <51C9CB95.2040006@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C9CB95.2040006@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Hans,

On Tue, Jun 25, 2013 at 06:55:49PM +0200, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> Cc: Laurent and Sakari
> 
> On 06/24/2013 10:54 AM, Hans Verkuil wrote:
> > Hi Sylwester,
> > 
> > It came to my attention that several i2c subdev drivers overwrite the sd->name
> > as set by v4l2_i2c_subdev_init with a custom name.
> > 
> > This is wrong if it is possible that there are multiple identical sensors in
> > the system. The sd->name must be unique since it is used to prefix kernel
> > messages etc, so you have to be able to tell the sensor devices apart.
> 
> This has been discussed in the past, please see thread [1]. 
> 
> > It concerns the following Samsung-contributed drivers:
> > 
> > drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
> > drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
> > drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> 
> It seems ov9650 is missing on this list,
> 
> $ git grep ".*cpy.*(.*sd\|subdev.*name" -- drivers/media/i2c
> drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> drivers/media/i2c/ov9650.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
> drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> drivers/media/i2c/smiapp/smiapp-core.c:         subdev->name, code->pad, code->index);
> drivers/media/i2c/smiapp/smiapp-core.c: strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));

For smiapp the issue is that smiapp is the name of the driver; there's no
sensor which would be called "smiapp" but a large number of different
devices that implement the SMIA or SMIA++ standard. The driver can recognise
some of them and call them according to their real name.

> drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
> drivers/media/i2c/tvp514x.c:    strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> 
> > If there can be only one sensor (because it is integrated in the SoC),
> > then there is no problem with doing this. But it is not obvious to me
> > which of these drivers are for integrated systems, and which aren't.
> 
> Those sensors are standalone devices, I'm not aware of any of them to be 
> integrated with an Application Processor SoC. I've never seen something 
> like that. However some of those devices are hybrid modules with a raw 
> image sensor and an ISP SoC.
> So in theory there could be multiple such devices in a single system, 
> although personally I've never seen something like that.
> 
> > I can make patches for those that need to be fixed if you can tell me
> > which drivers are affected.
> 
> You may want to have a look at the commits listed below, and the comments 
> I received to that [2] patch series...
> 
> commit 2138d73b69be1cfa4982c9949f2445ec77ea9edc
> [media] noon010pc30: Make subdev name independent of the I2C slave address
> 
> commit 14b702dd71d38b6d0662251b3f8cd60da98602ce
> [media] s5k6aa: Make subdev name independent of the I2C slave address
> 
> commit c5024a70bb60b678f08586ed786340ec162d250f
> [media] m5mols: Make subdev name independent of the I2C slave address
> 
> Before we start messing with those drivers it would be nice to have 
> defined rules of the media entity naming. I2C bus number and address
> is not something that's useful in the media entity name. And multiple

Isn't it?

Well... there's currently no other way to figure out which I2C bus and
address the device has, to find the I2C device. It'd be very, very good if
entities had bus information which is currently is limited to the media
device itself.

But beyond that I see no use for it.

> sensors (smiapp, s5c73m3, upcoming s5k6bafx) have "logical" subdevs 
> that are not initialized with the i2c specific v4l2 functions.
> 
> I guess there are other means to ensure the subdev's name is unique,
> rather than appending I2C bus info to it that changes from board to
> board and is totally irrelevant in user space.

There may be cases where the same board contains two sensors that are
exactly similar (think of stereo cameras!) but the user still must know
which one is which. I2C bus information might not be that bad way to tell
it.

But I don't think it necessarily should be part of the subdev's name.

> Presumably we could have subdev name postfixed with I2C bus id/slave
> address as it is done currently and the media core would be using only
> a part of subdev's name up to ' ' character to initialize the entity
> name ? The media entities have unique ID, hence it would have probably
> been OK to have entities with same name, should it happen there are 
> multiple identical devices in a single system.
> 
> To summarize, I would prefer to avoid modifying those drivers in a
> backward incompatible way, for a sake of pure API correctness and
> due to vague reasons. There is currently no board in mainline for
> which the subdev names wouldn't have been unique. Usually there 
> are different types of image sensors used for the front and the 
> rear facing camera. But for stereoscopy there most likely would
> be two identical image sensors on a board. 

:-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
