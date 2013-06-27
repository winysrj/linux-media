Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3876 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3F0Gnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 02:43:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Samsung i2c subdev drivers that set sd->name
Date: Thu, 27 Jun 2013 08:43:11 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
References: <201306241054.11604.hverkuil@xs4all.nl> <51C9CB95.2040006@samsung.com> <20130626090050.GK2064@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130626090050.GK2064@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306270843.11817.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed June 26 2013 11:00:51 Sakari Ailus wrote:
> Hi Sylwester and Hans,
> 
> On Tue, Jun 25, 2013 at 06:55:49PM +0200, Sylwester Nawrocki wrote:
> > Hi Hans,
> > 
> > Cc: Laurent and Sakari
> > 
> > On 06/24/2013 10:54 AM, Hans Verkuil wrote:
> > > Hi Sylwester,
> > > 
> > > It came to my attention that several i2c subdev drivers overwrite the sd->name
> > > as set by v4l2_i2c_subdev_init with a custom name.
> > > 
> > > This is wrong if it is possible that there are multiple identical sensors in
> > > the system. The sd->name must be unique since it is used to prefix kernel
> > > messages etc, so you have to be able to tell the sensor devices apart.
> > 
> > This has been discussed in the past, please see thread [1]. 
> > 
> > > It concerns the following Samsung-contributed drivers:
> > > 
> > > drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> > > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> > > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
> > > drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
> > > drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > > drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > > drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> > 
> > It seems ov9650 is missing on this list,
> > 
> > $ git grep ".*cpy.*(.*sd\|subdev.*name" -- drivers/media/i2c
> > drivers/media/i2c/m5mols/m5mols_core.c: strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > drivers/media/i2c/noon010pc30.c:        strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
> > drivers/media/i2c/ov9650.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> > drivers/media/i2c/s5c73m3/s5c73m3-core.c:       strcpy(oif_sd->name, "S5C73M3-OIF");
> > drivers/media/i2c/s5k4ecgx.c:   strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> > drivers/media/i2c/s5k6aa.c:     strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> > drivers/media/i2c/smiapp/smiapp-core.c:         subdev->name, code->pad, code->index);
> > drivers/media/i2c/smiapp/smiapp-core.c: strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));
> 
> For smiapp the issue is that smiapp is the name of the driver; there's no
> sensor which would be called "smiapp" but a large number of different
> devices that implement the SMIA or SMIA++ standard. The driver can recognise
> some of them and call them according to their real name.

But the smiapp driver can still prefix that real name with the i2c bus info,
right? Just as v4l2_i2c_subdev_init does.

> > drivers/media/i2c/sr030pc30.c:  strcpy(sd->name, MODULE_NAME);
> > drivers/media/i2c/tvp514x.c:    strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> > 
> > > If there can be only one sensor (because it is integrated in the SoC),
> > > then there is no problem with doing this. But it is not obvious to me
> > > which of these drivers are for integrated systems, and which aren't.
> > 
> > Those sensors are standalone devices, I'm not aware of any of them to be 
> > integrated with an Application Processor SoC. I've never seen something 
> > like that. However some of those devices are hybrid modules with a raw 
> > image sensor and an ISP SoC.
> > So in theory there could be multiple such devices in a single system, 
> > although personally I've never seen something like that.
> > 
> > > I can make patches for those that need to be fixed if you can tell me
> > > which drivers are affected.
> > 
> > You may want to have a look at the commits listed below, and the comments 
> > I received to that [2] patch series...

What comments? I see no comments.

I would have Nacked those patches, but I probably never saw them since you posted
them during a period where I was mostly absent from the list.

> > 
> > commit 2138d73b69be1cfa4982c9949f2445ec77ea9edc
> > [media] noon010pc30: Make subdev name independent of the I2C slave address
> > 
> > commit 14b702dd71d38b6d0662251b3f8cd60da98602ce
> > [media] s5k6aa: Make subdev name independent of the I2C slave address
> > 
> > commit c5024a70bb60b678f08586ed786340ec162d250f
> > [media] m5mols: Make subdev name independent of the I2C slave address
> > 
> > Before we start messing with those drivers it would be nice to have 
> > defined rules of the media entity naming. I2C bus number and address
> > is not something that's useful in the media entity name. And multiple
> 
> Isn't it?

Why not? As long as the format is strictly adhered to then I see no reason
not to use it. Not only does it make the name unique, it also tells you
where the device is in the hardware topology.

We could make the simple rule that the driver name is the first word of
the name. So it would be easy to provide a function that matches just the
first word and ignores the bus info (if there is any).

> Well... there's currently no other way to figure out which I2C bus and
> address the device has, to find the I2C device. It'd be very, very good if
> entities had bus information which is currently is limited to the media
> device itself.
> 
> But beyond that I see no use for it.

I don't really care all that much how the name is made unique, as long as it
is. It's used in the kernel log as a prefix and it is used for async loading of
drivers. Probably there are other uses as well.

The problem by taking a shortcut now is that *when* somebody uses two identical
sensors he'll uncover a big mess that needs to be cleaned up.

As an aside: perhaps we should start making checklists for subdev drivers for
developers. Ensuring that the subdev name is unique would be one of them.

> > sensors (smiapp, s5c73m3, upcoming s5k6bafx) have "logical" subdevs 
> > that are not initialized with the i2c specific v4l2 functions.
> > 
> > I guess there are other means to ensure the subdev's name is unique,
> > rather than appending I2C bus info to it that changes from board to
> > board and is totally irrelevant in user space.
> 
> There may be cases where the same board contains two sensors that are
> exactly similar (think of stereo cameras!) but the user still must know
> which one is which. I2C bus information might not be that bad way to tell
> it.
> 
> But I don't think it necessarily should be part of the subdev's name.

If you mean that the i2c bus info doesn't have to be part of the subdev's
name, then that's correct. But it does have to be unique. It's how it was
designed. Since I designed it, I should know :-)

> 
> > Presumably we could have subdev name postfixed with I2C bus id/slave
> > address as it is done currently and the media core would be using only
> > a part of subdev's name up to ' ' character to initialize the entity
> > name ?

Yes, that's an option. But I would like Laurent's opinion on this. The problem
I see with that is that it would actually make it hard to map an entity
name to a subdev since there is no bus_info information associated with the
entity, just an ID.

So if you have two identical subdevs, e.g. "saa7115 6-0021" and "saa7115 7-0021",
and you name the corresponding entities "saa7115", but with different IDs, then
how do you know which ID maps to which subdev? If you keep the i2c postfix,
then that's unambiguous.

The problem is that the entity documentation gives no guidelines as to what
can be expected of the entity name. In my opinion the entity name should be
copied from the subdev name, thus making it unique (at least between subdevs).
In addition, the first word of the name should be the driver name, the
remainder is the identifier (usually the i2c bus).

> > The media entities have unique ID, hence it would have probably
> > been OK to have entities with same name, should it happen there are 
> > multiple identical devices in a single system.

Actually, from what I remember the name was just a way to make things more
understandable for humans and the ID was meant to be used as the real identifier.
I'm not 100% sure that that was the idea behind the original design, I would
have to go back to my first RFCs to confirm that.

But since that time there has been a movement inside the kernel away from
numerical IDs towards unique strings. So if I were to design it today I would
definitely specify that the entity name must be unique, at least within the
set of entities of the same type.

> > To summarize, I would prefer to avoid modifying those drivers in a
> > backward incompatible way, for a sake of pure API correctness and
> > due to vague reasons. There is currently no board in mainline for
> > which the subdev names wouldn't have been unique. Usually there 
> > are different types of image sensors used for the front and the 
> > rear facing camera. But for stereoscopy there most likely would
> > be two identical image sensors on a board. 

This isn't about what it in the mainline. If you make a product that
uses two identical sensor drivers then you will reuse the sensor driver
code but you will not typically try to upstream your bridge driver since
that's unique for your product and generally useless for anyone else.

Clean subdev drivers using the API correctly *are* important to promote
reuse. I would like to fix the non-Samsung, non-smiapp subdev drivers soon.
With regards to the Samsung/smiapp drivers we need at the very least a
comment in the driver mentioning that they behave in a non-standard way with
possible complications if there are more than one of them in a system.
(Frankly, that's a particular concern for the smiapp driver. I do think that
it would be good if that one can be fixed soon).

Regards,

	Hans
