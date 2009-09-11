Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4650 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbZIKWVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 18:21:47 -0400
Received: from tschai.lan (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8BMLmSr027194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 00:21:49 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Media controller: sysfs vs ioctl
Date: Sat, 12 Sep 2009 00:21:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909120021.48353.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've started this as a new thread to prevent polluting the discussions of the
media controller as a concept.

First of all, I have no doubt that everything that you can do with an ioctl,
you can also do with sysfs and vice versa. That's not the problem here.

The problem is deciding which approach is the best.

What is sysfs? (taken from http://lwn.net/Articles/31185/)

"Sysfs is a virtual filesystem which provides a userspace-visible representation
of the device model. The device model and sysfs are sometimes confused with each
other, but they are distinct entities. The device model functions just fine
without sysfs (but the reverse is not true)."

Currently both a v4l driver and the device nodes are all represented in sysfs.
This is handled automatically by the kernel.

Sub-devices are not represented in sysfs since they are not based on struct
device. They are v4l-internal structures. Actually, if the subdev represents
an i2c device, then that i2c device will be present in sysfs, but not all
subdevs are i2c devices.

Should we make all sub-devices based on struct device? Currently this is not
required. Doing this would probably mean registering a virtual bus, then
attaching the sub-device to that. Of course, this only applies to sub-devices
that represent something that is not an i2c device (e.g. something internal
to the media board like a resizer, or something connected to GPIO pins).

If we decide to go with sysfs, then we have to do this. This part shouldn't
be too difficult to implement. And also if we do not go with sysfs this might
be interesting to do eventually.

The media controller topology as I see it should contain the device nodes
since the application has to know what device node to open to do the streaming.
It should also contain the sub-devices so the application can control them.
Is this enough? I think that eventually we also want to show the physical
connectors. I left them out (mostly) from the initial media controller proposal,
but I suspect that we want those as well eventually. But connectors are
definitely not devices. In that respect the entity concept of the media
controller is more abstract than sysfs.

However, for now I think we can safely assume that sub-devices can be made
visible in sysfs.

The next point is how to access sub-devices.

One approach is to create sub-device attributes that can be read and written.
The other approach is to use a media controller device node and use ioctls.

A third approach would be to create device nodes for each sub-device. This was
the original idea I had when they were still called 'media processors'. I no
longer think that is a good idea. The problem with that is that it will create
even more device nodes (dozens in some cases) in addition to the many streaming
device nodes that we already have. We have no choice in the case of streaming,
but very few sub-devices (if any) will need to do read/write or streaming.
Should this be needed, then it is always possible to create a device node just
for that and link it as an output to the sub-device. In 99% of the cases we
just need to be able to call ioctl on the sub-device. And we can do that
through a media controller device just as well.

What sort of interaction do we need with sub-devices?

1) Controls. Most sub-devices will have controls. Some of these controls are
the same as are exposed through a v4l device node (brightness, contrast, etc),
but others are more advanced controls. E.g. fine-grained gain controls. We have
seen this lately in several driver submissions that there are a lot of controls
that are hardware specific and that we do not want to expose to the average
xawtv-type application. But advanced apps still want to be able to use them.

Making such controls private to the sub-device is a good solution. What that
means is that they do not appear when you do QUERYCTRL on the video device node,
but you can set/get them when dealing directly to the sub-device.

If we do this with an ioctl then we can just reuse the existing ioctls for
dealing with controls. As you know I am working on a control framework that
will move most of the implementation details to the core. It is easy to make
this available as well to sub-devices. So calling QUERYCTRL through a media
controller will also enumerate all the 'private' controls. In addition, with
VIDIOC_S/G_EXT_CTRLS you can set and get multiple controls atomically.

Such a control framework can also expose those controls as sysfs attributes.
This works fine except for setting multiple controls atomically. E.g. for
motor control you will definitely want this.

You can do this I guess by implementing an 'all' attribute that will output
all the control values when queried and you can write things like:

motor_x=100
motor_y=200

to the 'all' attribute.

Yuck.

Oh, and I don't see how you can implement the information that v4l2_queryctrl
and v4l2_querymenu can return in sysfs. Except by creating even more
attributes.

Note that I would like to see controls in sysfs. They can be very handy for
scripting purposes. But that API is simply not powerful enough for use in
applications.


2) Private ioctls. Basically a way to set and get data that is hardware
specific from the sub-device. This can be anything from statistics, histogram
information, setting resizer coefficients, configuring colorspace converters,
whatever. Furthermore, just like the regular V4L2 API it has to be designed
with future additions in mind (i.e. it should use something like reserved
fields).

In my opinion ioctls are ideal for this since they are very flexible and easy
to use and efficient. Especially because you can combine multiple fields into
one unit. So getting histogram data through an ioctl will also provide the
timestamp. And you can both write and read data in one atomic system call.
Yes, you can combine data in sysfs reads as well. Although an IORW ioctls is
hard to model in sysfs. But whereas an ioctl can just copy a struct from kernel
to userspace, for sysfs you have to go through a painful process of parsing and
formatting.

And not all this data is small. Histogram data can be 10s of kilobytes. 'cat'
will typically only read 4 kB at a time, so you will probably have to keep
track of how much is read in the read implementation of the attribute. Or does
the kernel do that for you?

And how do you make sysfs attribute data flexible enough to be able to add new
fields in the future? Of course, having each bit of data in a separate
attribute is one way of doing it, but then you loose atomicity. And I don't
think you can just add new fields at the end of the data you read from an
attribute: that would really mess up the parsing.

Finally, some of these ioctls might have to be called very frequently.
Statistics and histogram information is generally obtained for every captured
frame. Having to format and parse all that information at that frequency will
become a real performance hog. I'm sorry, but sysfs is simply not designed for
that.


3) Setting up formatting for inputs and outputs. This is related to open issue
#3 in the media controller RFC. The current V4L2 API does not provide precise
enough control when dealing with e.g. a sensor able to capture certain
resolutions combines with a scaler that has restrictions of its own. Depending
on the final resolution it may be better to upscale or downscale from a
particular sensor resolution (this is an actual problem with omap3). You want
to be able to set this up by commanding the sensor and resizer sub-devices and
explicitly configuring them.

I need to think more about this. It is a complex issue that needs to be broken
down into more manageable pieces first.


The final part is how to represent the topology. Device nodes and sub-devices
can be exposed to sysfs as discussed earlier. Representing both the possible
and current links between them is a lot harder. This is especially true for
non-v4l device nodes since we cannot just add attributes there. I think this
can be done though by providing that information as attributes of an mc sysfs
node. That way it remains under control of the v4l core.

Per entity you can make attributes like this:

inputs: number of inputs to the entity
outputs: number of outputs of the entity

input0_possible_sources: give a list of possible sources (each source in the
form entity:output)
input0_current_sources: a bitmask (or perhaps a string like 00010001) that
returns the current selected sources or can be set to select the sources.

Ditto for all inputs and outputs.

I agree, this is perfectly possible. You are going to generate a shitload of
attributes and you need a userspace library to organize all this information
in a sensible set of enumeration functions.

Alternatively, you can just implement enumeration ioctls directly. No need
to do a zillion open/read/close syscalls just to get hold of all this
information. We might still add sysfs support later, in addition to the ioctls,
but I see no advantage whatsoever in doing this in sysfs.

I also really, really do not bloat the core with all the formatting and
parsing that is needed to make this work. It's all unnecessary complex and
error-prone.

I see sysfs as a means of exposing kernel structures to the outside world.
Should we also start exposing driver internals in this way? In some cases
we can do that as an extra service (e.g. exposing sub-devices and controls),
but *not* as the primary API.

Of course, one more reason is that this forces applications do use two wildly
different APIs to control a media board: ioctls and sysfs. That's particularly
bad.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
