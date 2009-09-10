Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbZIJUUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 16:20:40 -0400
Date: Thu, 10 Sep 2009 17:20:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090910172013.55825d2e@caramujo.chehab.org>
In-Reply-To: <200909100913.09065.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hi Hans,

Em Thu, 10 Sep 2009 09:13:09 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

First of all, a generic comment: you enumerated on your RFC several needs that
you expect to be solved with a media controller, but you didn't mention what
userspace API will be used to solve it (e. g. what ioctls, sysfs interfaces,
etc). As this is missing, I'm adding a few notes about how this can be
implemented. For example, as I've already pointed when you sent the first
proposal and at LPC, sysfs is the proper kernel API for enumerating things.

> Why do we need one?
> ===================
> 
> There are currently several problems that are impossible to solve within the
> current V4L2 API:
> 
> 1) Discovering the various device nodes that are typically created by a video
> board, such as: video nodes, vbi nodes, dvb nodes, alsa nodes, framebuffer
> nodes, input nodes (for e.g. webcam button events or IR remotes).

In fact, this can already be done by using the sysfs interface. the current
version of v4l2-sysfs-path.c already enumerates the associated nodes to
a /dev/video device, by just navigating at the already existing device
description nodes at sysfs. I hadn't tried yet, but I bet that a similar kind
of topology can be obtained from a dvb device (probably, we need to do some
adjustments).

The big missing component is an userspace library that will properly return the
device components to the applications. Maybe we need to do also some
adjustments at the sysfs nodes to represent all that it is needed.

> It would be very handy if an application can just open an /dev/v4l/mc0 node
> and be able to figure out where all the nodes are, and to be able to figure
> out what the capabilities of the board are (e.g. does it support DVB, is the
> audio going through a loopback cable or is there an alsa device, can it do
> compressed MPEG video, etc. etc.). Currently the end-user has no choice but to
> supply the device nodes manually.

The better would be to create a /sys/class/media node, and having the
media controllers above that struct. So, mc0 will be at /sys/class/media/mc0.
 
> 2) Some of the newer SoC devices can connect or disconnect internal components
> dynamically. As an example, the omap3 can either connect a sensor output to a
> CCDC module to a previewer module to a resizer module and finally to a capture
> device node. But it is also possible to capture the sensor output directly
> after the CCDC module. The previewer can get its input from another video
> device node and output either to the resizer or to another video capture
> device node. The same is true for the resizer, that too can get its input from
> a device node.
> 
> So there are lots of connections here that can be modified at will depending
> on what the application wants. And in real life there are even more links than
> I mentioned here. And it will only get more complicated in the future.
> 
> All this requires that there has to be a way to connect and disconnect parts
> of the internal topology of a video board at will.

We should design this with care, since each change at the internal topology may
create/delete devices. If you do such changes at topology, udev will need to
delete the old devices and create the new ones. This will happen on separate
threads and may cause locking issues at the device, especially since you can be
modifying several components at the same time (being even possible to do it on
separate threads).

I've seen some high-end core network routers that implements topology changes
on an interesting way: any changes done are not immediately applied at the
node, but are stored into a file, where the configuration that can be changed
anytime. However, the topology changes only happen after giving a commit
command. After commit, it validates the new config and apply them atomically
(e. g. or all changes are applied or none), to avoid bad effects that
intermediate changes could cause.

As we are at kernelspace, we need to take care to not create a very complex
interface. Yet, the idea of applying the new topology atomically seems
interesting. 

Alsa is facing a similar problem with pinup quirks needed with HD-audio boards.
They are proposing a firmware like interface:
	http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-09/msg03198.html

On their case, they are just using request_firmware() for it, at board probing
time.

IMO, the same approach can be used here.

> 3) There is increasing demand to be able to control e.g. sensors or video
> encoders/decoders at a much more precise manner. Currently the V4L2 API
> provides only limited support in the form of a set of controls. But when
> building a high-end camera the developer of the application controlling it
> needs very detailed control of the sensor and image processing devices.
> On the other hand, you do not want to have all this polluting the V4L2 API
> since there is absolutely no sense in exporting this as part of the existing
> controls, or to allow for a large number of private ioctls.

For those static configs, request_firmware() could also be one alternative for it.

> What would be a good solution is to give access to the various components of
> the board and allow the application to send component-specific ioctls or
> controls to it. Any application that will do this is by default tailored to
> that board. In addition, none of these new controls or commands will pollute
> the namespace of V4L2.

For dynamic configs, I see this a problem: we had already some troubles in
the past where certain webcam drivers works fine only with an specific (closed
source, paid) application, since the driver had a generic interface to allow
raw changes at the registers, and those registers weren't documented. That's
basically why all direct register access are under the advanced debug Kconfig
option. So, no matter how we expose such controls, they need to be properly
documented to allow open source applications to make use of them.

> Topology
> --------
> 
> The topology is represented by entities. Each entity has 0 or more inputs and
> 0 or more outputs. Each input or output can be linked to 0 or more possible
> outputs or inputs from other entities. This is either mutually exclusive 
> (i.e. an input/output can be connected to only one output/input at a time)
> or it can be connected to multiple inputs/outputs at the same time.
> 
> A device node is a special kind of entity with just one input (capture node)
> or output (video node). It may have both if it does some in-place operation.
> 
> Each entity has a unique numerical ID (unique for the board). Each input or
> output has a unique numerical ID as well, but that ID is only unique to the
> entity. To specify a particular input or output of an entity one would give
> an <entity ID, input/output ID> tuple.
> 
> When enumerating over entities you will need to retrieve at least the
> following information:
> 
> - type (subdev or device node)
> - entity ID
> - entity description (can be quite long)
> - subtype (what sort of device node or subdev is it?)
> - capabilities (what can the entity do? Specific to the subtype and more
> precise than the v4l2_capability struct which only deals with the board
> capabilities)
> - addition subtype-specific data (union)
> - number of inputs and outputs. The input IDs should probably just be a value
> of 0 - (#inputs - 1) (ditto for output IDs).
> 
> Another ioctl is needed to obtain the list of possible links that can be made
> for each input and output.

Again, the above seems more appropriate to be used via sysfs, instead of via an ioctl.


> Access to sub-devices
> ---------------------
> 
> What is a bit trickier is how to select a sub-device as the target for ioctls.
> Normally ioctls like S_CTRL are sent to a /dev/v4l/videoX node and the driver
> will figure out which sub-device (or possibly the bridge itself) will receive
> it. There is no way of hijacking this mechanism to e.g. specify a specific
> entity ID without also having to modify most of the v4l2 structs by adding
> such an ID field. But with the media controller we can at least create an
> ioctl that specifies a 'target entity' that will receive any non-media
> controller ioctl. Note that for now we only support sub-devices as the target
> entity.
> 
> The idea is this:
> 
> // Select a particular target entity
> ioctl(mc, VIDIOC_S_SUBDEV, &entityID);
> // Send S_FMT directly to that entity
> ioctl(mc, VIDIOC_S_FMT, &fmt);
> // Send a custom ioctl to that entity
> ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);
> 
> This requires no API changes and is very easy to implement.

Huh? This is an API change. 

Also, in the above particular case, I'm assuming that you want to just change
the format of a subdevice specified at the first ioctl, and call a new ioctl
for it, right?

You'll need to specify the API for the two new ioctls, specify at the API specs
how this is supposed to work and maybe add some new return errors, that will
need to be reflected inside the code. 

Also, on almost all user cases, if you set the v4l device to one video
standard and the v4l subdevice to another one, the device won't work.
So, it may be needed to be protect those actions with permission check flags
(for example, requiring CAP_SYS_ADMIN permissions).

> One problem is
> that this is not thread-safe. We can either supply some sort of locking
> mechanism, or just tell the application programmer to do the locking in the
> application. I'm not sure what is the correct approach here. A reasonable
> compromise would be to store the target entity as part of the filehandle.
> So you can open the media controller multiple times and each handle can set
> its own target entity.

A lock at application won't work, since there's nothing to prevent that another
application will open the device at the same time.

What are the needs in this specific case? If there are just a few ioctls, IMO,
the better is to have an specific set of ioctls for it.

> This also has the advantage that you can have a filehandle 'targeted' at a
> resizer and a filehandle 'targeted' at the previewer, etc. If you want to use
> the same filehandle from multiple threads, then you have to implement locking
> yourself.

I'll later comment the open issues.



Cheers,
Mauro
