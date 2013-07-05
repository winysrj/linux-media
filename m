Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33821 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab3GELaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 07:30:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: Samsung i2c subdev drivers that set sd->name
Date: Fri, 05 Jul 2013 13:30:31 +0200
Message-ID: <27462886.lEP1apMFVe@avalon>
In-Reply-To: <51D5D8C8.2030400@gmail.com>
References: <201306241054.11604.hverkuil@xs4all.nl> <201307041313.25318.hverkuil@xs4all.nl> <51D5D8C8.2030400@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday 04 July 2013 22:19:20 Sylwester Nawrocki wrote:
> On 07/04/2013 01:13 PM, Hans Verkuil wrote:
> > On Thu 4 July 2013 00:49:36 Laurent Pinchart wrote:
> >> On Thursday 27 June 2013 11:53:15 Sylwester Nawrocki wrote:
> >>> On 06/27/2013 08:43 AM, Hans Verkuil wrote:
> >>>> On Wed June 26 2013 11:00:51 Sakari Ailus wrote:
> >>>>> On Tue, Jun 25, 2013 at 06:55:49PM +0200, Sylwester Nawrocki wrote:
> >>>>>> On 06/24/2013 10:54 AM, Hans Verkuil wrote:

[snip]

> >>>>>> Before we start messing with those drivers it would be nice to have
> >>>>>> defined rules of the media entity naming. I2C bus number and address
> >>>>>> is not something that's useful in the media entity name. And multiple
> >>>>> 
> >>>>> Isn't it?
> >>>> 
> >>>> Why not? As long as the format is strictly adhered to then I see no
> >>>> reason not to use it. Not only does it make the name unique, it also
> >>>> tells you where the device is in the hardware topology.
> >> 
> >> It's a shame that entities don't have a bus info field in addition to
> >> their name, but we have to live with that.
> >> 
> >> Userspace needs a way to distinguish between multiple identical subdevs.
> >> We can't rely on IDs only, as they're not guaranteed to be stable. We
> >> thus need to use names and possibly connection information.
> >> 
> >> Two identical sensors connected to separate receivers could be
> >> distinguished by checking which receiver they're connected to.
> >> Unfortunately this breaks when the two sensors are connected to the same
> >> receiver, in which case we can only rely on the name. Media entity names
> >> thus need to be unique when connection information can't help
> >> distinguishing otherwise identical subdevs, which implies that subdev
> >> names must be unique.
> >> 
> >>>> We could make the simple rule that the driver name is the first word of
> >>>> the name. So it would be easy to provide a function that matches just
> >>>> the first word and ignores the bus info (if there is any).
> >>> 
> >>> Yes, and that's basically all I needed before "fixing" those affected
> >>> drivers. No matter what exact rules, if there are any, user space could
> >>> handle various hardware configurations without issues.
> >>> 
> >>> Besides, the drivers would need to strip/replace with something else any
> >>> spaces when initializing subddev name, as that character would be used
> >>> as the bus info delimiter ?
> >> 
> >> Or we could decide that the bus info can't contain any space, in which
> >> case the last space would be the delimiter.
> 
> Sounds reasonable as well.
> 
> > Frankly, I don't think either should contain a space :-) Today nobody is
> > using spaces anywhere to the best of my knowledge.
> 
> OK, then there would be spaces neither in <name> nor in <bus-info>. From
> a quick grep I can't see any driver currently using spaces in its subdev
> name.

In case of multi-subdev sensors (when the sensor includes a scaler for 
instance) the subdev names will likely be made of the sensor name (or driver 
name) and a subdev description. Something like "xxxxx pixel array" and "xxxxxx 
scaler". We could use a dash or underscore to replace spaces though.

> >>> Then in media-ctl or any user space code the entity name could be
> >>> matched exactly, and if that fails a fuzzy matching could be done, with
> >>> the bus info discarded.
> >> 
> >> That's a good idea, it would help making media-ctl based scripts more
> >> portable.
> >> 
> >>>>> Well... there's currently no other way to figure out which I2C bus and
> >>>>> address the device has, to find the I2C device. It'd be very, very
> >>>>> good if entities had bus information which is currently is limited to
> >>>>> the media device itself.
> >>>>> 
> >>>>> But beyond that I see no use for it.
> >>>> 
> >>>> I don't really care all that much how the name is made unique, as long
> >>>> as it is. It's used in the kernel log as a prefix and it is used for
> >>>> async loading of drivers. Probably there are other uses as well.
> >> 
> >> I actually care, as we need to provide a meaningful way for userspace to
> >> relate those unique names to the hardware instance they correspond to.
> >> 
> >>>> The problem by taking a shortcut now is that *when* somebody uses two
> >>>> identical sensors he'll uncover a big mess that needs to be cleaned up.
> >>> 
> >>> True, I'm not against fixing it, I'd like to respect your name
> >>> uniqueness rule. :) But I'm against modifying drivers in a way that
> >>> doesn't give user space a chance to handle it correctly.
> >>> 
> >>>> As an aside: perhaps we should start making checklists for subdev
> >>>> drivers for developers. Ensuring that the subdev name is unique would
> >>>> be one of them.
> >>> 
> >>> Sounds good.
> >>> 
> >>>>>> sensors (smiapp, s5c73m3, upcoming s5k6bafx) have "logical" subdevs
> >>>>>> that are not initialized with the i2c specific v4l2 functions.
> >>>>>> 
> >>>>>> I guess there are other means to ensure the subdev's name is unique,
> >>>>>> rather than appending I2C bus info to it that changes from board to
> >>>>>> board and is totally irrelevant in user space.
> >>>>> 
> >>>>> There may be cases where the same board contains two sensors that are
> >>>>> exactly similar (think of stereo cameras!) but the user still must
> >>>>> know which one is which. I2C bus information might not be that bad way
> >>>>> to tell it.
> >>>>> 
> >>>>> But I don't think it necessarily should be part of the subdev's name.
> >>>> 
> >>>> If you mean that the i2c bus info doesn't have to be part of the
> >>>> subdev's name, then that's correct. But it does have to be unique. It's
> >>>> how it was designed. Since I designed it, I should know :-)
> >> 
> >> How should bus info be retrieved if it's not part of the media entity
> >> name ?
> > 
> > If that subdev name is also going to be used in the MC, then yes, it
> > should contain the i2c bus info. At the moment the v4l2 core makes no
> > assumptions on the subdev name, other than that it must be unique. which
> > is generally achieved by appending the i2c bus info. But some platform
> > subdevs (non-i2c) may not have any bus info since that doesn't apply in
> > all cases.
> > 
> > I would propose a guideline for the subdev naming like this:
> > 	<name>  <bus-info>
> > 
> > where <bus-info> is optional and neither string contains spaces.
> 
> Hmm, it might be inconvenient for platform subdevs. E.g. it could mean
> something like:
> 
> currently             | <name> <bus-info>
> ----------------------+------------------------------------------
> s5p-mipi-csis.0       | s5p-mipi-csis 11800000.csis
> s5p-mipi-csis.1       | s5p-mipi-csis 11810000.csis
> FIMC-LITE.0           | FIMC-LITE 12040000.fimc-lite
> FIMC-LITE.0           | FIMC-LITE 12050000.fimc-lite
> 
> 
> The register window addresses can vary across various SoCs and it doesn't
> sound very clever to expose that to user space, when a device is exactly
> same from the user point of view.
> 
> Presumably the ".<index>" part in the names in the above cases should be
> kept, and user space could just ignore bus-info, e.g.
> 
> s5p-mipi-csis.0       | s5p-mipi-csis.0 11800000.csis
> FIMC-LITE.0           | FIMC-LITE.0 12050000.fimc-lite
> 
> If the bus info is too long it would get truncated.

We're limited to 32 characters, which isn't much to store both the name and 
bus info.

> >>> While we are at it, how about v4l2_i2c_subdev_init() ? It initializes
> >>> sd->name with SPI driver name. It doesn't look like it could be unique
> >>> then ?
> >>> 
> >>>>>> Presumably we could have subdev name postfixed with I2C bus id/slave
> >>>>>> address as it is done currently and the media core would be using
> >>>>>> only a part of subdev's name up to ' ' character to initialize the
> >>>>>> entity name ?
> >>>> 
> >>>> Yes, that's an option. But I would like Laurent's opinion on this. The
> >>>> problem I see with that is that it would actually make it hard to map
> >>>> an entity name to a subdev since there is no bus_info information
> >>>> associated with the entity, just an ID.
> >>> 
> >>> Yes, without bus info in the entity structure this would likely not be a
> >>> good idea.
> >> 
> >> As explained above, userspace needs to know which entity corresponds to
> >> which piece of hardware, so non-unique (in the context of a media
> >> device, and when connection information doesn't provide the required
> >> information) entity names are a bad idea in the general case.
> >> 
> >>>> So if you have two identical subdevs, e.g. "saa7115 6-0021" and
> >>>> "saa7115 7-0021", and you name the corresponding entities "saa7115",
> >>>> but with different IDs, then how do you know which ID maps to which
> >>>> subdev? If you keep the i2c postfix, then that's unambiguous.
> >>> 
> >>> The I2C bus info in the subdev's name can be a completely random string.
> >>> Please note that I2C bus id can be assigned dynamically. So there is no
> >>> guarantee you get reproducible bus IDs assigned to each sensor in all
> >>> cases. That's said I2C bus info is not reliable means to identify
> >>> physical
> >>> device.
> >> 
> >> I'm afraid you're right :-) (I don't know whether I2C bus IDs will be
> >> assigned dynamically in practice on systems where the information is
> >> important though).
> > 
> > i2c devices on an embedded system (i.e. hooked up to the SoC i2c bus) will
> > always get the same bus number. Obviously, if the i2c device is on a
> > PCI(e) or USB board,
>
> That has not always been true, before patch [1] most drivers used to
> register I2C adapters with dynamically assigned IDs. Now there is a standard
> way to specify the adapter's id in DT.
> 
> > then it becomes dynamic (but still unique, and still it specifies exactly
> > where the device can be found in the hardware topology).
> 
> Presumably it allows to locate exactly a specific hardware device
> indirectly, by e.g. parsing some additional data from sysfs. But it is not
> very useful as an absolute identifier of a device.
> 
> Perhaps a sysfs link would have been a better way to expose the media
> entity's underlying device, its placement in the hardware topology, etc. But
> not all subdevs have struct device associated with them, not all have /dev
> entry. Perhaps the entities could be listed in sysfs under corresponding
> media device, with relevant bus information associated with them.

I'd rather not get started with the whole "media controller should have been 
implemented in sysfs" discussion again :-)

We need an ioctl to report additional information about media entities (it's 
been on my to-do list for wayyyyyyyyy too long). It could be used to report 
bus information as well.

> > In other words, the i2c bus info is by no means a random string.
> > 
> >> If we can't use the bus info then I see few options other than getting
> >> the name directly from platform data or DT. We could use the full device
> >> path, but
>
> AFAIK it is valid to put in DT information required for user visible labels
> identifying parts of hardware.
> 
> >> that will become too long for the media entity and subdev name fields.
> 
> Yes, that wouldn't work I'm afraid.
> 
> >>>> The problem is that the entity documentation gives no guidelines as to
> >>>> what can be expected of the entity name. In my opinion the entity name
> >>>> should be copied from the subdev name, thus making it unique (at least
> >>>> between subdevs). In addition, the first word of the name should be the
> >>>> driver name, the remainder is the identifier (usually the i2c bus).
> >>> 
> >>> Sounds reasonable. The specific use case this causes problems to us is
> >>> when there are multiple revisions of similar product, where same sensor
> >>> is on different I2C busses. Either physically or on a device tree based
> >>> system, where bus IDs can be assigned dynamically.
> >>> 
> >>> Then same sensor will have different media entity names, and without
> >>> some rules it quickly becomes impossible to specify pipeline
> >>> configuration in, e.g. text file. This makes the media controller
> >>> drivers even less portable.
> >>> 
> >>>>>> The media entities have unique ID, hence it would have probably been
> >>>>>> OK to have entities with same name, should it happen there are
> >>>>>> multiple identical devices in a single system.
> >>>> 
> >>>> Actually, from what I remember the name was just a way to make things
> >>>> more understandable for humans and the ID was meant to be used as the
> >>>> real identifier. I'm not 100% sure that that was the idea behind the
> >>>> original design, I would have to go back to my first RFCs to confirm
> >>>> that.
> >>>> 
> >>>> But since that time there has been a movement inside the kernel away
> >>>> from numerical IDs towards unique strings. So if I were to design it
> >>>> today I would definitely specify that the entity name must be unique,
> >>>> at least within the set of entities of the same type.
> >>> 
> >>> Not sure such uniqueness would be much useful as long as those names are
> >>> random.
> >> 
> >> Uniqueness will only be useful if we have a way to relate names to
> >> hardware device instances. If that relationship is provide through a
> >> different API then there's not much added value in having unique media
> >> entity names.
> >> 
> >>>>>> To summarize, I would prefer to avoid modifying those drivers in a
> >>>>>> backward incompatible way, for a sake of pure API correctness and
> >>>>>> due to vague reasons. There is currently no board in mainline for
> >>>>>> which the subdev names wouldn't have been unique. Usually there
> >>>>>> are different types of image sensors used for the front and the
> >>>>>> rear facing camera. But for stereoscopy there most likely would
> >>>>>> be two identical image sensors on a board.
> >>>> 
> >>>> This isn't about what it in the mainline. If you make a product that
> >>>> uses two identical sensor drivers then you will reuse the sensor driver
> >>>> code but you will not typically try to upstream your bridge driver
> >>>> since that's unique for your product and generally useless for anyone
> >>>> else.
> >>> 
> >>> Not sure if that's a "proper" philosophy, in general there is likely
> >>> plenty out of tree drivers. But if everyone thought like this we would
> >>> have very little drivers in mainline. And little chances to adapt the
> >>> core frameworks to the needs of those "unique" devices. Resulting in
> >>> various incompatible forks of the core frameworks.
> >>> 
> >>> However I see you point we shouldn't come up with a code that is known
> >>> to possibly cause problems.
> >>> 
> >>>> Clean subdev drivers using the API correctly *are* important to promote
> >>>> reuse. I would like to fix the non-Samsung, non-smiapp subdev drivers
> >>>> soon. With regards to the Samsung/smiapp drivers we need at the very
> >>>> least a comment in the driver mentioning that they behave in a non-
> >>>> standard way with possible complications if there are more than one of
> >>>> them in a system. (Frankly, that's a particular concern for the smiapp
> >>>> driver. I do think that it would be good if that one can be fixed
> >>>> soon).
> >>> 
> >>> I can prepare patches for all the affected Samsung device drivers,
> >>> reverting back the I2C bus info postfix. No need to add any ugly
> >>> comments to them :)
> >>> 
> >>> I not sure what exactly are the reasons smiapp chose not to postfix the
> >>> name with I2C bus info like v4l2_i2c_subdev_init() does. Presumably
> >>> this driver could be modified to do that, if there is chance to handle
> >>> it in standard way in user space.
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e
> e5c27440cc24d62ec463cce4c000bb32c5692c7

-- 
Regards,

Laurent Pinchart

