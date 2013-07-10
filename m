Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43897 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJX0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 19:26:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
Date: Thu, 11 Jul 2013 01:27:12 +0200
Message-ID: <3272716.OC8ELh3xsc@avalon>
In-Reply-To: <51D88318.70904@gmail.com>
References: <201306241054.11604.hverkuil@xs4all.nl> <27462886.lEP1apMFVe@avalon> <51D88318.70904@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Saturday 06 July 2013 22:50:32 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 07/05/2013 01:30 PM, Laurent Pinchart wrote:
> > On Thursday 04 July 2013 22:19:20 Sylwester Nawrocki wrote:
> >> On 07/04/2013 01:13 PM, Hans Verkuil wrote:
> >>> On Thu 4 July 2013 00:49:36 Laurent Pinchart wrote:
> >>>> On Thursday 27 June 2013 11:53:15 Sylwester Nawrocki wrote:
> >>>>> On 06/27/2013 08:43 AM, Hans Verkuil wrote:
> >>>>>> On Wed June 26 2013 11:00:51 Sakari Ailus wrote:
> >>>>>>> On Tue, Jun 25, 2013 at 06:55:49PM +0200, Sylwester Nawrocki wrote:
> >>>>>>>> On 06/24/2013 10:54 AM, Hans Verkuil wrote:
> > [snip]
> > 
> >>>>>>>> Before we start messing with those drivers it would be nice to have
> >>>>>>>> defined rules of the media entity naming. I2C bus number and
> >>>>>>>> address is not something that's useful in the media entity name.
> >>>>>>>> And multiple
> >>>>>>> 
> >>>>>>> Isn't it?
> >>>>>> 
> >>>>>> Why not? As long as the format is strictly adhered to then I see no
> >>>>>> reason not to use it. Not only does it make the name unique, it also
> >>>>>> tells you where the device is in the hardware topology.
> >>>> 
> >>>> It's a shame that entities don't have a bus info field in addition to
> >>>> their name, but we have to live with that.
> >>>> 
> >>>> Userspace needs a way to distinguish between multiple identical
> >>>> subdevs. We can't rely on IDs only, as they're not guaranteed to be
> >>>> stable. We thus need to use names and possibly connection information.
> >>>> 
> >>>> Two identical sensors connected to separate receivers could be
> >>>> distinguished by checking which receiver they're connected to.
> >>>> Unfortunately this breaks when the two sensors are connected to the
> >>>> same receiver, in which case we can only rely on the name. Media entity
> >>>> names thus need to be unique when connection information can't help
> >>>> distinguishing otherwise identical subdevs, which implies that subdev
> >>>> names must be unique.
> >>>> 
> >>>>>> We could make the simple rule that the driver name is the first word
> >>>>>> of the name. So it would be easy to provide a function that matches
> >>>>>> just the first word and ignores the bus info (if there is any).
> >>>>> 
> >>>>> Yes, and that's basically all I needed before "fixing" those affected
> >>>>> drivers. No matter what exact rules, if there are any, user space
> >>>>> could handle various hardware configurations without issues.
> >>>>> 
> >>>>> Besides, the drivers would need to strip/replace with something else
> >>>>> any spaces when initializing subddev name, as that character would be
> >>>>> used as the bus info delimiter ?
> >>>> 
> >>>> Or we could decide that the bus info can't contain any space, in which
> >>>> case the last space would be the delimiter.
> >> 
> >> Sounds reasonable as well.
> >> 
> >>> Frankly, I don't think either should contain a space :-) Today nobody is
> >>> using spaces anywhere to the best of my knowledge.
> >> 
> >> OK, then there would be spaces neither in<name>  nor in<bus-info>. From
> >> a quick grep I can't see any driver currently using spaces in its subdev
> >> name.
> > 
> > In case of multi-subdev sensors (when the sensor includes a scaler for
> > instance) the subdev names will likely be made of the sensor name (or
> > driver name) and a subdev description. Something like "xxxxx pixel array"
> > and "xxxxxx scaler". We could use a dash or underscore to replace spaces
> > though.
>
> Yes, I guess dash or underscore could be well used instead of spaces.
> But my feeling is that 32 characters might be often not enough to hold
> longer names and bus info. Also it would be good to denote what sort of
> bus we refer to, i2c, spi, usb, platform, etc. I doesn't look like we
> can always fit that information in 32 characters.
> 
> [...]
> 
> >>>> How should bus info be retrieved if it's not part of the media entity
> >>>> name ?
> >>> 
> >>> If that subdev name is also going to be used in the MC, then yes, it
> >>> should contain the i2c bus info. At the moment the v4l2 core makes no
> >>> assumptions on the subdev name, other than that it must be unique. which
> >>> is generally achieved by appending the i2c bus info. But some platform
> >>> subdevs (non-i2c) may not have any bus info since that doesn't apply in
> >>> all cases.
> >>> 
> >>> I would propose a guideline for the subdev naming like this:
> >>> 	<name>   <bus-info>
> >>> 
> >>> where<bus-info>  is optional and neither string contains spaces.
> >> 
> >> Hmm, it might be inconvenient for platform subdevs. E.g. it could mean
> >> something like:
> >> 
> >> currently             |<name>  <bus-info>
> >> ----------------------+------------------------------------------
> >> s5p-mipi-csis.0       | s5p-mipi-csis 11800000.csis
> >> s5p-mipi-csis.1       | s5p-mipi-csis 11810000.csis
> >> FIMC-LITE.0           | FIMC-LITE 12040000.fimc-lite
> >> FIMC-LITE.0           | FIMC-LITE 12050000.fimc-lite
> >> 
> >> 
> >> The register window addresses can vary across various SoCs and it doesn't
> >> sound very clever to expose that to user space, when a device is exactly
> >> same from the user point of view.
> >> 
> >> Presumably the ".<index>" part in the names in the above cases should be
> >> kept, and user space could just ignore bus-info, e.g.
> >> 
> >> s5p-mipi-csis.0       | s5p-mipi-csis.0 11800000.csis
> >> FIMC-LITE.0           | FIMC-LITE.0 12050000.fimc-lite
> >> 
> >> If the bus info is too long it would get truncated.
> > 
> > We're limited to 32 characters, which isn't much to store both the name
> > and bus info.
> 
> Indeed, it's a pretty serious limitation IMHO.
> 
> >>>>> While we are at it, how about v4l2_i2c_subdev_init() ? It initializes
> >>>>> sd->name with SPI driver name. It doesn't look like it could be unique
> >>>>> then ?
> >>>>> 
> >>>>>>>> Presumably we could have subdev name postfixed with I2C bus
> >>>>>>>> id/slave address as it is done currently and the media core would
> >>>>>>>> be using only a part of subdev's name up to ' ' character to
> >>>>>>>> initialize the entity name ?
> >>>>>> 
> >>>>>> Yes, that's an option. But I would like Laurent's opinion on this.
> >>>>>> The problem I see with that is that it would actually make it hard to
> >>>>>> map an entity name to a subdev since there is no bus_info information
> >>>>>> associated with the entity, just an ID.
> >>>>> 
> >>>>> Yes, without bus info in the entity structure this would likely not be
> >>>>> a good idea.
> >>>> 
> >>>> As explained above, userspace needs to know which entity corresponds to
> >>>> which piece of hardware, so non-unique (in the context of a media
> >>>> device, and when connection information doesn't provide the required
> >>>> information) entity names are a bad idea in the general case.
> >>>> 
> >>>>>> So if you have two identical subdevs, e.g. "saa7115 6-0021" and
> >>>>>> "saa7115 7-0021", and you name the corresponding entities "saa7115",
> >>>>>> but with different IDs, then how do you know which ID maps to which
> >>>>>> subdev? If you keep the i2c postfix, then that's unambiguous.
> >>>>> 
> >>>>> The I2C bus info in the subdev's name can be a completely random
> >>>>> string. Please note that I2C bus id can be assigned dynamically. So
> >>>>> there is no guarantee you get reproducible bus IDs assigned to each
> >>>>> sensor in all cases. That's said I2C bus info is not reliable means to
> >>>>> identify physical device.
> >>>> 
> >>>> I'm afraid you're right :-) (I don't know whether I2C bus IDs will be
> >>>> assigned dynamically in practice on systems where the information is
> >>>> important though).
> >>> 
> >>> i2c devices on an embedded system (i.e. hooked up to the SoC i2c bus)
> >>> will always get the same bus number. Obviously, if the i2c device is on
> >>> a PCI(e) or USB board,
> >> 
> >> That has not always been true, before patch [1] most drivers used to
> >> register I2C adapters with dynamically assigned IDs. Now there is a
> >> standard way to specify the adapter's id in DT.
> >> 
> >>> then it becomes dynamic (but still unique, and still it specifies
> >>> exactly where the device can be found in the hardware topology).
> >> 
> >> Presumably it allows to locate exactly a specific hardware device
> >> indirectly, by e.g. parsing some additional data from sysfs. But it is
> >> not very useful as an absolute identifier of a device.
> >> 
> >> Perhaps a sysfs link would have been a better way to expose the media
> >> entity's underlying device, its placement in the hardware topology, etc.
> >> But not all subdevs have struct device associated with them, not all
> >> have /dev entry. Perhaps the entities could be listed in sysfs under
> >> corresponding media device, with relevant bus information associated
> >> with them.
> > 
> > I'd rather not get started with the whole "media controller should have
> > been implemented in sysfs" discussion again :-)
> 
> Ok, I just wanted to point out some alternatives. ;-)
> 
> > We need an ioctl to report additional information about media entities
> > (it's been on my to-do list for wayyyyyyyyy too long). It could be used
> > to report bus information as well.
> 
> Yes, that sounds much more interesting than using just subdev name to sqeeze
> all the information in. Why we don't have such an ioctl yet anyway ? Were
> there some arguments against it, or its been just a low priority issue ?

It has just been a low-priority issue.

All we need here is a way for userspace to pass a buffer pointer to the kernel 
that will be filled with typed key-value pairs. I'm not sure whether a 
hierarchical structured format such as ASN.1 would be useful or if a flat 
hierarchy would be enough.

-- 
Regards,

Laurent Pinchart

