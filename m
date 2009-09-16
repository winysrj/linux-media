Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3589 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZIPTVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 15:21:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Wed, 16 Sep 2009 21:21:16 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909120039.50343.hverkuil@xs4all.nl> <20090916151520.53537714@pedra.chehab.org>
In-Reply-To: <20090916151520.53537714@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909162121.16606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 September 2009 20:15:20 Mauro Carvalho Chehab wrote:
> Em Sat, 12 Sep 2009 00:39:50 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > From my previous understanding, those are the needs:
> > > 
> > > 1) V4L2 API will keep being used to control the devices and to do streaming,
> > > working under the already well defined devices;
> > 
> > Yes.
> >  
> > > 2) One Kernel object is needed to represent the entire board as a hole, to
> > > enumerate its sub-devices and to change their topology;
> > 
> > Yes.
> > 
> > > 3) For some very specific cases, it should be possible to "tweak" some
> > > sub-devices to act on a non-usual way;
> > 
> > This will not be for 'some very specific cases'. This will become an essential
> > feature on embedded platforms. It's probably the most important part of the
> > media controller proposal.
> 
> Embedded platforms is an specific use case. 

However you look at it, it is certainly a very important use case. It's a
huge and important industry and we should have proper support for it in v4l-dvb.
And embedded platforms are used quite differently. Where device drivers for
comsumer market products should hide complexity (because the end-user or the
generic webcam/video application doesn't want to be bothered with that), they
should expose that complexity for embedded platforms since there the
application writes want to take full control.

> > > 4) Some new ioctls are needed to control some parts of the devices that aren't
> > > currently covered by V4L2 API.
> > 
> > No, that is not part of the proposal. Of course, as drivers for the more
> > advanced devices are submitted there may be some functionality that is general
> > enough to warrant inclusion in the V4L2 API, but that's business as usual.
> > 
> > > 
> > > Right?
> > > 
> > > If so:
> > > 
> > > (1) already exists;
> > 
> > Obviously.
> >  
> > > (2) is the "topology manager" of the media controller, that should use
> > > sysfs, due to its nature.
> > 
> > See the separate thread I started on sysfs vs ioctl.
> > 
> > > For (3), there are a few alternatives. IMO, the better is to use also sysfs,
> > > since we'll have all subdevs already represented there. So, to change
> > > something, it is just a matter to write something to a sysfs node.
> > 
> > See that same thread why that is a really bad idea.
> > 
> > > Another 
> > > alternative would be to create separate subdevs at /dev, but this will end on
> > > creating much more complex drivers than probably needed.
> > 
> > I agree with this.
> > 
> > > (4) is implemented by some new ioctl additions at V4L2 API.
> > 
> > Not an issue as stated above.
> 
> I can't avoid to be distracted from my merge duties to address some points that
> seem to be important to bold on those new RFC discussions.
> 
> We need to take care of not creating a "mess controller" instead of "media controller".
> 
> From a few emails at the mailing list, It seems to me that some people are
> thinking that the media controller is a replacement for what we have, or as
> a "solution for all our problems".
> 
> It won't solve all our problems, nor it should be a replacement for what we have.
> 
> Basically, there's no reason for firing the V4L2 API.  We can extend it,
> improve, add new capabilities, etc, but, considering the experiences learned
> from moving from V4L1 to V4L2, for bad or for good, we can't get rid of it.
> 
> See the history: V4L2 was proposed in 1999 and added on kernel on 2002. Seven
> years after its implementation, and ten years after its proposal, and there are
> yet drivers needing to be ported. So, creating a "media controller" as a
> replacement for it won't work.

I have absolutely no idea where you got the impression that the media
controller would replace V4L2. V4L2 has proven itself as an API and IMHO was
very well designed for the future. Sure, in hindsight there were a few things
we would do differently now, but especially in the video world it is very hard
to predict the future so the V4L2 API has and is doing an excellent job.

The media controller complements the V4L2 API and will in no way replace it.
 
> The media controller, as proposed, has two very specific capabilities:
> 
> 1) enumerate and change media device topology. 
> 
> This is something that it is out of the scope of V4L2 API, so it is valid to
> think on implementing an API for it.
> 
> 2) "sub-device" control. I think the mess started here.
> 
> We need to go one more step behind and see what this exactly means.
> 
> Let me try to identify the concepts and seek for the answers.
> 
> What's a sub-device?
> ====================
> 
> Well, if we strip v4l2-framework.txt and driver/media from "git grep", we have:
> 
> For "subdevice", there are several occurences. All of them refers to
> subvendor/subdevice PCI ID.
> 
> For "sub-device": most references also talk about PCI subdevices. On all places
> (except for V4L), where a subdevice exists, a kernel device is created.
> 
> So, basically, only V4L is using sub-device with a different meaning than what's at kernel.
> On all other places, a subdevice is just another device.
> 
> It seems that we have a misconception here: sub-device is just an alias for
> "device". 
> 
> IMO, it is better to avoid using "sub-device", as this cause confusion with the
> widely used pci subdevice designation.

We discussed this on the list at the time. I think my original name was
v4l2-client. If you can come up with a better name, then I'm happy to do a
search and replace.

Suggestions for a better name are welcome! Perhaps something more abstract
like v4l2-block? v4l2-part? v4l2-object? v4l2-function?

But the concept behind it will really not change with a different name.

Anyway, the definition of a sub-device within v4l is 'anything that has a
struct v4l2_subdev'. Seen in C++ terms a v4l2_subdev struct defines several
possible abstract interfaces. And objects can implement ('inherit') one or
more of these. Perhaps v4l2-object is a much better term since that removes
the association with a kernel device, which it is most definitely not.

> 
> How kernel deals with (sub-)device ?
> ====================================
> 
> A device has nothing to do with a single physical component. In fact, since the
> beginning of Linux, physical devices like superIO chips (now called as "south
> bridge") exports several kernel devices associated to it, for example, to
> serial interface , printer interface, rtc, pci controllers, etc.
> 
> Using another example from a driver I'm working for checking memory errors at
> the i7 core machines: In order to get errors from each processor, the driver needs
> to talk with 18 devices. All of those 18 kernel devices are part of just one
> physical CPU chip. Worse than that, they are the memory controller part of a
> single logical unit (called QPI- Quick Path Interconnet). All those 18 devices
> are bound to an specific PCI bus for each memory controller (on a machine with
> 2 CPU sockets, there are 2 buses, 36 total PCI devices, each with lots of
> registers).
> 
> So, basically, a kernel device is the kernel representation for a block element
> inside physical device that needs to be controlled by kernel. A driver may need
> to deal with and to export several different devices for userspace.
> 
> One of the concepts of the "media controller" is that a media controller device
> will act like a proxy entity, sending commands to hidden devices, acting like a
> bus to communicate with the physical components that aren't represented as
> devices.
> 
> So, I want to return back to one question: 
> 
> Should we create a device for each "v4l sub-device"?
> ====================================================
> 
> While I said before that this would result into a complex representation, after
> a careful study and analysis, I'm fully convinced that the answer should be:
> 
> YES, each "v4l sub-device" should be a device.
> 
> Rationale:
> 
> 1) We already do this for several components: i2c devices, i2c bus, IR, audio;
> 
> 2) On most cases, those components are already a device, being an i2c device or
> another kind of device connected to another bus;
> 
> 3) Userspace needs to communicate with them. The kernel model is to create a
> device for device <=> userspace communication, and not to use proxy entities;
> 
> 4) Creating device for "sub-devices" is the approach already taken on all other
> drivers over the kernel.

I gather that when you use the term 'device' you mean a 'device node' that
userspace can access. It is an option to have sub-devices create a device
node. Note that that would have to be a device node created by v4l; an i2c
device node for example is quite useless to us since you can only use it
for i2c ioctls.

I have considered this myself as well. The reason I decided against it was
that I think it is a lot of extra overhead and the creation of even more
device nodes when adding a single media controller would function just as
well. Especially since all this is quite uninteresting for most of the non-
embedded drivers. In fact, many of the current sub-devices have nothing or
almost nothing that needs to be controlled by userspace, so creating a device
node just for the sake of consistency sits not well with me.

And as I explained above, a v4l2_subdev just implements an interface. It has
no relation to devices. And yes, I'm beginning to agree with you that subdevice
was a bad name because it suggested something that it simply isn't.

That said, I also see some advantages in doing this. For statistics or
histogram sub-devices you can implement a read() call to read the data
instead of using ioctl. It is more flexible in that respect.

This is definitely an interesting topic that can be discussed both during
the LPC and here on the list.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
