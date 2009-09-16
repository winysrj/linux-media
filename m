Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3493 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZIPVeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 17:34:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Wed, 16 Sep 2009 23:34:08 +0200
Cc: linux-media@vger.kernel.org
References: <200909100913.09065.hverkuil@xs4all.nl> <200909162121.16606.hverkuil@xs4all.nl> <20090916175043.0d462a18@pedra.chehab.org>
In-Reply-To: <20090916175043.0d462a18@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909162334.08807.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 September 2009 22:50:43 Mauro Carvalho Chehab wrote:
> Em Wed, 16 Sep 2009 21:21:16 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Wednesday 16 September 2009 20:15:20 Mauro Carvalho Chehab wrote:
> > > Em Sat, 12 Sep 2009 00:39:50 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > > > From my previous understanding, those are the needs:
> > > > > 
> > > > > 1) V4L2 API will keep being used to control the devices and to do streaming,
> > > > > working under the already well defined devices;
> > > > 
> > > > Yes.
> > > >  
> > > > > 2) One Kernel object is needed to represent the entire board as a hole, to
> > > > > enumerate its sub-devices and to change their topology;
> > > > 
> > > > Yes.
> > > > 
> > > > > 3) For some very specific cases, it should be possible to "tweak" some
> > > > > sub-devices to act on a non-usual way;
> > > > 
> > > > This will not be for 'some very specific cases'. This will become an essential
> > > > feature on embedded platforms. It's probably the most important part of the
> > > > media controller proposal.
> > > 
> > > Embedded platforms is an specific use case. 
> > 
> > However you look at it, it is certainly a very important use case. 
> 
> Yes, and I never said we shouldn't address embedded platform needs.
> > It's a
> > huge and important industry and we should have proper support for it in v4l-dvb.
> 
> Agreed.
> 
> > And embedded platforms are used quite differently. Where device drivers for
> > comsumer market products should hide complexity (because the end-user or the
> > generic webcam/video application doesn't want to be bothered with that), they
> > should expose that complexity for embedded platforms since there the
> > application writes want to take full control.
> 
> I'm just guessing, but If the two usecases are so different, maybe we shouldn't
> try to find a common solution for the two problems, or maybe we should use an
> approach similar to debufs, where you enable/mount only were needed (embedded).

They are not *that* different. You still want the ability to discover the
available device nodes for consumer products (e.g. the alsa device belonging
to the video device). And there will no doubt be some borderline products
belonging to, say, the professional consumer market. It's not black-and-white.

<snip>

> v4l2-object seems good. also the -host/-client terms that Guennadi is proposing.

Just an idea: why not rename struct v4l2_device to v4l2_mc and v4l2_subdev to
v4l2_object? And if we decide to go all the way, then we can rename video_device
to v4l2_devnode. Or perhaps we go straight to the media_ prefix instead.

The term 'client' has for me similar problems as 'device': it's used in so many
different contexts that it is easy to get confused.

> > > 4) Creating device for "sub-devices" is the approach already taken on all other
> > > drivers over the kernel.
> > 
> > I gather that when you use the term 'device' you mean a 'device node' that
> > userspace can access. It is an option to have sub-devices create a device
> > node. Note that that would have to be a device node created by v4l; an i2c
> > device node for example is quite useless to us since you can only use it
> > for i2c ioctls.
> > 
> > I have considered this myself as well. The reason I decided against it was
> > that I think it is a lot of extra overhead and the creation of even more
> > device nodes when adding a single media controller would function just as
> > well. Especially since all this is quite uninteresting for most of the non-
> > embedded drivers.
> 
> This can be easily solved: Just add a Kconfig option for the tweak interfaces
> eventually making it depending on CONFIG_EMBEDDED.

An interesting idea. I don't think you want to make this specific for embedded
devices only. It can be done as a separate config option within V4L.

I have a problem though: what to do with sub-devices (if you don't mind, I'll
just keep using that term for now) that want to expose some advanced control.
We have seen several requests for that lately. E.g. an AGC-TOP control for
fine-tuning the AGC of tuners.

I think this example will be quite typical of several sub-devices: they may
have one or two 'advanced' controls that can be useful in very particular
cases for end-users.

There are a few possible ways of doing this:

1) With the mediacontroller concept from the RFC you can select the tuner
subdev through the mc device node and call VIDIOC_S_CTRL on that node (and
with QUERYCTRL you can also query all controls supported by that subdev,
including these advanced controls).

2) Create a device node for each subdev even if they have just a single control
to expose. Possible, but this still seems overkill for me.

3) Use your idea of only creating a device node for subdevs if a kernel config
is set. If no device nodes should be created, then the control framework can
still export such advanced controls to sysfs, allowing end-users to change
them. This is actually quite a nice idea: embedded systems or power-users can
get full control through the device nodes, while the average end-user can
just use the control from sysfs if he needs to tweak something.

4) Same as 3) but you can still use the mc to select a sub-device and call
ioctl on it. In other words, allow both mechanisms. It's trivial to implement,
but I got to admit that I don't like it. It's not clean, somehow.

So IF we go with the idea to create separate device nodes to access sub-devices,
then a good scheme would be this:

A) if a sub-device needs no control from outside, then no device node is ever
created. It is still enumerated in the media controller, but it has no associated
node.

B) if a sub-device needs a lot of control from outside, then we always create a
device node. This would typically be the case for e.g. a resizer or previewer
that is a core part of an embedded platform.

C) in all other cases you only get it if a kernel config option is on. And since
any advanced controls are still exposed in sysfs you can still change those even
if the config option was off.

What do you think about that? I would certainly like to hear what people think
about this.

Regards,

	Hans

> > In fact, many of the current sub-devices have nothing or
> > almost nothing that needs to be controlled by userspace, so creating a device
> > node just for the sake of consistency sits not well with me.
> 
> If the device will never needed to be seen on userspace then we can just not create
> a device for it.
> 
> > And as I explained above, a v4l2_subdev just implements an interface. It has
> > no relation to devices. And yes, I'm beginning to agree with you that subdevice
> > was a bad name because it suggested something that it simply isn't.
> > 
> > That said, I also see some advantages in doing this. For statistics or
> > histogram sub-devices you can implement a read() call to read the data
> > instead of using ioctl. It is more flexible in that respect.
> 
> I think this will be more flexible and will be less complex than creating a proxy
> device. For example, as you'll be directly addressing a device, you don't need to
> have any locking to avoid the risk that different threads accessing different
> sub-devices at the same time would result on a command sending to the wrong device.
> So, both kernel driver and userspace app can be simpler.
> 
> > This is definitely an interesting topic that can be discussed both during
> > the LPC and here on the list.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
