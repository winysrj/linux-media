Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbZIPUvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 16:51:19 -0400
Date: Wed, 16 Sep 2009 17:50:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090916175043.0d462a18@pedra.chehab.org>
In-Reply-To: <200909162121.16606.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909120039.50343.hverkuil@xs4all.nl>
	<20090916151520.53537714@pedra.chehab.org>
	<200909162121.16606.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Sep 2009 21:21:16 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Wednesday 16 September 2009 20:15:20 Mauro Carvalho Chehab wrote:
> > Em Sat, 12 Sep 2009 00:39:50 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > > From my previous understanding, those are the needs:
> > > > 
> > > > 1) V4L2 API will keep being used to control the devices and to do streaming,
> > > > working under the already well defined devices;
> > > 
> > > Yes.
> > >  
> > > > 2) One Kernel object is needed to represent the entire board as a hole, to
> > > > enumerate its sub-devices and to change their topology;
> > > 
> > > Yes.
> > > 
> > > > 3) For some very specific cases, it should be possible to "tweak" some
> > > > sub-devices to act on a non-usual way;
> > > 
> > > This will not be for 'some very specific cases'. This will become an essential
> > > feature on embedded platforms. It's probably the most important part of the
> > > media controller proposal.
> > 
> > Embedded platforms is an specific use case. 
> 
> However you look at it, it is certainly a very important use case. 

Yes, and I never said we shouldn't address embedded platform needs.
> It's a
> huge and important industry and we should have proper support for it in v4l-dvb.

Agreed.

> And embedded platforms are used quite differently. Where device drivers for
> comsumer market products should hide complexity (because the end-user or the
> generic webcam/video application doesn't want to be bothered with that), they
> should expose that complexity for embedded platforms since there the
> application writes want to take full control.

I'm just guessing, but If the two usecases are so different, maybe we shouldn't
try to find a common solution for the two problems, or maybe we should use an
approach similar to debufs, where you enable/mount only were needed (embedded).

> > IMO, it is better to avoid using "sub-device", as this cause confusion with the
> > widely used pci subdevice designation.
> 
> We discussed this on the list at the time. I think my original name was
> v4l2-client. If you can come up with a better name, then I'm happy to do a
> search and replace.
> 
> Suggestions for a better name are welcome! Perhaps something more abstract
> like v4l2-block? v4l2-part? v4l2-object? v4l2-function?
> 
> But the concept behind it will really not change with a different name.
> 
> Anyway, the definition of a sub-device within v4l is 'anything that has a
> struct v4l2_subdev'. Seen in C++ terms a v4l2_subdev struct defines several
> possible abstract interfaces. And objects can implement ('inherit') one or
> more of these. Perhaps v4l2-object is a much better term since that removes
> the association with a kernel device, which it is most definitely not.

v4l2-object seems good. also the -host/-client terms that Guennadi is proposing.

> > 4) Creating device for "sub-devices" is the approach already taken on all other
> > drivers over the kernel.
> 
> I gather that when you use the term 'device' you mean a 'device node' that
> userspace can access. It is an option to have sub-devices create a device
> node. Note that that would have to be a device node created by v4l; an i2c
> device node for example is quite useless to us since you can only use it
> for i2c ioctls.
> 
> I have considered this myself as well. The reason I decided against it was
> that I think it is a lot of extra overhead and the creation of even more
> device nodes when adding a single media controller would function just as
> well. Especially since all this is quite uninteresting for most of the non-
> embedded drivers.

This can be easily solved: Just add a Kconfig option for the tweak interfaces
eventually making it depending on CONFIG_EMBEDDED.

> In fact, many of the current sub-devices have nothing or
> almost nothing that needs to be controlled by userspace, so creating a device
> node just for the sake of consistency sits not well with me.

If the device will never needed to be seen on userspace then we can just not create
a device for it.

> And as I explained above, a v4l2_subdev just implements an interface. It has
> no relation to devices. And yes, I'm beginning to agree with you that subdevice
> was a bad name because it suggested something that it simply isn't.
> 
> That said, I also see some advantages in doing this. For statistics or
> histogram sub-devices you can implement a read() call to read the data
> instead of using ioctl. It is more flexible in that respect.

I think this will be more flexible and will be less complex than creating a proxy
device. For example, as you'll be directly addressing a device, you don't need to
have any locking to avoid the risk that different threads accessing different
sub-devices at the same time would result on a command sending to the wrong device.
So, both kernel driver and userspace app can be simpler.

> This is definitely an interesting topic that can be discussed both during
> the LPC and here on the list.
> 
> Regards,
> 
> 	Hans
> 




Cheers,
Mauro
