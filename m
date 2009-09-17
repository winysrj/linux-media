Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZIQMpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 08:45:12 -0400
Date: Thu, 17 Sep 2009 09:44:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090917094436.7e217227@pedra.chehab.org>
In-Reply-To: <200909162334.08807.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<200909162121.16606.hverkuil@xs4all.nl>
	<20090916175043.0d462a18@pedra.chehab.org>
	<200909162334.08807.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Sep 2009 23:34:08 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > I'm just guessing, but If the two usecases are so different, maybe we shouldn't
> > try to find a common solution for the two problems, or maybe we should use an
> > approach similar to debufs, where you enable/mount only were needed (embedded).
> 
> They are not *that* different. You still want the ability to discover the
> available device nodes for consumer products (e.g. the alsa device belonging
> to the video device). And there will no doubt be some borderline products
> belonging to, say, the professional consumer market. It's not black-and-white.

Agreed.

> > v4l2-object seems good. also the -host/-client terms that Guennadi is proposing.
> 
> Just an idea: why not rename struct v4l2_device to v4l2_mc and v4l2_subdev to
> v4l2_object? And if we decide to go all the way, then we can rename video_device
> to v4l2_devnode. Or perhaps we go straight to the media_ prefix instead.
> 
> The term 'client' has for me similar problems as 'device': it's used in so many
> different contexts that it is easy to get confused.

IMO, let's patch the docs, but, at least for a while, let's not change API names again.

Perhaps, I'm just too stressed with all the merge extra work I had to do this time due
to the last function rename that stopped me merging patches while the arch changes
were not upstream... I generally take one or two days for merging most patches,
but I'm working hardly this entire week due to that.

> > This can be easily solved: Just add a Kconfig option for the tweak interfaces
> > eventually making it depending on CONFIG_EMBEDDED.
> 
> An interesting idea. I don't think you want to make this specific for embedded
> devices only. It can be done as a separate config option within V4L.
> 
> I have a problem though: what to do with sub-devices (if you don't mind, I'll
> just keep using that term for now) that want to expose some advanced control.
> We have seen several requests for that lately. 

I think we should discuss this case by case. When I said that people were considering the
media controller as a replacement for V4L2 API, I was referring to the fact that lately,
all proposals are thinking on doing things only at the sub-devices, where, on most cases,
the control should be applied via an already-existing API call.

> E.g. an AGC-TOP control for fine-tuning the AGC of tuners.

In this specific case, there's already AFC parameter for vidioc_[g/s]_tuner, being
also an example of advanced control for tuners. So, IMO, the proper place for
AGC-TOP is together with AFC, e. g., at struct v4l2_tuner.

> I think this example will be quite typical of several sub-devices: they may
> have one or two 'advanced' controls that can be useful in very particular
> cases for end-users.

On some cases, they can be just one extra G/S_CTRL. 

We need to have a clear rule of what kind of controls should go via the current
V4L2 standard way for those that will go via a subdev interface, to avoid the
"mess controller" scenario.

IMO, They should only use the sub-dev interface when there are more than one
subdev associated to the same /dev/video interface and were each may need
different settings for the same control.

Let me use an arbitrary scenario:

/dev/video0 -> dsp0 -> dsp1 -> ...

let's imagine that both dsp0 and dsp1 blocks are identical, and can do
a set of image enhancement functions, including movement detection and image
filtering.

If we need to set dsp0 block to do image filtering and dsp block 2 to do
movement detection, no V4L2 current methods will fit. In this case, subdev
interface should be used.

> There are a few possible ways of doing this:
> 
> 1) With the mediacontroller concept from the RFC you can select the tuner
> subdev through the mc device node and call VIDIOC_S_CTRL on that node (and
> with QUERYCTRL you can also query all controls supported by that subdev,
> including these advanced controls).

In this case, what would happen if the S_CTRL were applied at /dev/video? There
will be several possible ways (refuse, apply to all subdevs, apply to the first
one that accepts, etc), each with advantages and dis-advantages. IMO, too messy.

> 2) Create a device node for each subdev even if they have just a single control
> to expose. Possible, but this still seems overkill for me.
> 
> 3) Use your idea of only creating a device node for subdevs if a kernel config
> is set. If no device nodes should be created, then the control framework can
> still export such advanced controls to sysfs, allowing end-users to change
> them. This is actually quite a nice idea: embedded systems or power-users can
> get full control through the device nodes, while the average end-user can
> just use the control from sysfs if he needs to tweak something.

IMO, both 2 and 3 are OK. Considering Andy's argument that we can always avoid
creating a device at udev, (2) seems better.
> 
> 4) Same as 3) but you can still use the mc to select a sub-device and call
> ioctl on it. In other words, allow both mechanisms. It's trivial to implement,
> but I got to admit that I don't like it. It's not clean, somehow.

I also don't like it.

> So IF we go with the idea to create separate device nodes to access sub-devices,
> then a good scheme would be this:
> 
> A) if a sub-device needs no control from outside, then no device node is ever
> created. It is still enumerated in the media controller, but it has no associated
> node.
> 
> B) if a sub-device needs a lot of control from outside, then we always create a
> device node. This would typically be the case for e.g. a resizer or previewer
> that is a core part of an embedded platform.

(A) and (B) are OK.

> C) in all other cases you only get it if a kernel config option is on. And since
> any advanced controls are still exposed in sysfs you can still change those even
> if the config option was off.

Again, considering Andy's argument, maybe we can avoid having an extra config
for it, letting distros to disable or enable those interfaces at sysfs.




Cheers,
Mauro
