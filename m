Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4959 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZIJHNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 03:13:08 -0400
Received: from tschai.lan (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8A7D9sP023032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 09:13:10 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFCv2: Media controller proposal
Date: Thu, 10 Sep 2009 09:13:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909100913.09065.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here is the new Media Controller RFC. It is completely rewritten from the
original RFC. This original RFC can be found here:

http://www.archivum.info/video4linux-list%40redhat.com/2008-07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_media_device

This document will be the basis of the discussions during the Plumbers
Conference in two weeks time.

Open issue #3 is the main unresolved item, but I hope to come up with something
during the weekend.

Regards,

	Hans


RFC: Media controller proposal

Version 2.0

Background
==========

This RFC is a new version of the original RFC that was written in cooperation
with and on behalf of Texas Instruments about a year ago.

Much work has been done in the past year to put the foundation in place to
be able to implement a media controller and now it is time for this updated
version. The intention is to discuss this in more detail during this years
Plumbers Conference.

Although the high-level concepts are the same as in the original RFC, many
of the details have changed based on what was learned over the past year.

This RFC is based on the original discussions with Manjunath Hadli from TI
last year, on discussions during a recent meeting between Laurent Pinchart,
Guennadi Liakhovetski and myself, and on recent discussions with Nokia.
Thanks to Sakari Ailus for doing an initial review of this RFC.

One note regarding terminology: a 'board' is the name I use for the SoC,
PCI or USB device that contains the video hardware. Each board has its own
driver instance and its own v4l2_device struct. Originally I called it
'device', but that name is already used in too many places.


What is a media controller?
===========================

In a nutshell: a media controller is a new v4l device node that can be used
to discover and modify the topology of the board and to give access to the 
low-level nodes (such as previewers, resizers, color space converters, etc.)
that are part of the topology.

It does not do any streaming, that is the exclusive domain of video nodes.
It is meant purely for controlling a board as a whole.


Why do we need one?
===================

There are currently several problems that are impossible to solve within the
current V4L2 API:

1) Discovering the various device nodes that are typically created by a video
board, such as: video nodes, vbi nodes, dvb nodes, alsa nodes, framebuffer
nodes, input nodes (for e.g. webcam button events or IR remotes).

It would be very handy if an application can just open an /dev/v4l/mc0 node
and be able to figure out where all the nodes are, and to be able to figure
out what the capabilities of the board are (e.g. does it support DVB, is the
audio going through a loopback cable or is there an alsa device, can it do
compressed MPEG video, etc. etc.). Currently the end-user has no choice but to
supply the device nodes manually.

2) Some of the newer SoC devices can connect or disconnect internal components
dynamically. As an example, the omap3 can either connect a sensor output to a
CCDC module to a previewer module to a resizer module and finally to a capture
device node. But it is also possible to capture the sensor output directly
after the CCDC module. The previewer can get its input from another video
device node and output either to the resizer or to another video capture
device node. The same is true for the resizer, that too can get its input from
a device node.

So there are lots of connections here that can be modified at will depending
on what the application wants. And in real life there are even more links than
I mentioned here. And it will only get more complicated in the future.

All this requires that there has to be a way to connect and disconnect parts
of the internal topology of a video board at will.

3) There is increasing demand to be able to control e.g. sensors or video
encoders/decoders at a much more precise manner. Currently the V4L2 API
provides only limited support in the form of a set of controls. But when
building a high-end camera the developer of the application controlling it
needs very detailed control of the sensor and image processing devices.
On the other hand, you do not want to have all this polluting the V4L2 API
since there is absolutely no sense in exporting this as part of the existing
controls, or to allow for a large number of private ioctls.

What would be a good solution is to give access to the various components of
the board and allow the application to send component-specific ioctls or
controls to it. Any application that will do this is by default tailored to
that board. In addition, none of these new controls or commands will pollute
the namespace of V4L2.

A media controller can solve all these problems: it will provide a window into
the architecture of the board and all its device nodes. Since it is already
enumerating the nodes and components of the board and how they are linked up,
it is only a small step to also use it to change links and to send commands to
specific components.


Restrictions
============

1) These API additions should not affect existing applications.

2) The new API should not attempt to be too smart. All it should do it to give
the application full control of the board and to provide some initial support
for existing applications. E.g. in the case of omap3 you will have an initial
setup where the sensor is connected through all components to a capture device
node. This will provide sufficient support for a standard webcam application,
but if you want something more advanced then the application will have to set
it up explicitly. It may even be too complicated to use the resizer in this
case, and instead only a few resolutions optimal for the sensor are reported.

3) Provide automatic media controller support for drivers that do not create
one themselves. This new functionality should become available to all drivers,
not just new ones. Otherwise it will take a long time before applications like
MythTV will start to use it.


Implementation
==============

Many of the building blocks needed to implement a media controller already
exist: the v4l core can easily be extended with a media controller type, the
media controller device node can be held by the v4l2_device top-level struct,
and to represent an internal component we have the v4l2_subdev struct.

The core v4l2_subdev ops already has a generic 'ioctl' callback that can be
used by the media controller to pass custom ioctls to the subdev.

What is missing is that device nodes should be registered with struct
v4l2_device. All that is needed to do that is to ensure that when registering
a video node you always pass a pointer to the v4l2_device struct. A lot of
drivers do this already. In addition one should also be able to register
non-video device nodes (alsa, fb, etc.), so that they can be enumerated.

Since sub-devices are already registered with the v4l2_device there is not
much to do there.

Topology
--------

The topology is represented by entities. Each entity has 0 or more inputs and
0 or more outputs. Each input or output can be linked to 0 or more possible
outputs or inputs from other entities. This is either mutually exclusive 
(i.e. an input/output can be connected to only one output/input at a time)
or it can be connected to multiple inputs/outputs at the same time.

A device node is a special kind of entity with just one input (capture node)
or output (video node). It may have both if it does some in-place operation.

Each entity has a unique numerical ID (unique for the board). Each input or
output has a unique numerical ID as well, but that ID is only unique to the
entity. To specify a particular input or output of an entity one would give
an <entity ID, input/output ID> tuple.

When enumerating over entities you will need to retrieve at least the
following information:

- type (subdev or device node)
- entity ID
- entity description (can be quite long)
- subtype (what sort of device node or subdev is it?)
- capabilities (what can the entity do? Specific to the subtype and more
precise than the v4l2_capability struct which only deals with the board
capabilities)
- addition subtype-specific data (union)
- number of inputs and outputs. The input IDs should probably just be a value
of 0 - (#inputs - 1) (ditto for output IDs).

Another ioctl is needed to obtain the list of possible links that can be made
for each input and output.

It is good to realize that most applications will just enumerate e.g. capture
device nodes. Few applications will do a full scan of the whole topology.
Instead they will just specify the unique entity ID and if needed the
input/output ID as well. These IDs are declared in the board or sub-device
specific header.

A full enumeration will typically only be done by some sort of generic
application like v4l2-ctl.

In addition, most entities will have only one or two inputs/outputs at most.
So we might optimize the data structures for this. We probably will have to
see how it goes when we implement it.

We obviously need ioctls to make and break links between entities. It
shouldn't be hard to do this.

Access to sub-devices
---------------------

What is a bit trickier is how to select a sub-device as the target for ioctls.
Normally ioctls like S_CTRL are sent to a /dev/v4l/videoX node and the driver
will figure out which sub-device (or possibly the bridge itself) will receive
it. There is no way of hijacking this mechanism to e.g. specify a specific
entity ID without also having to modify most of the v4l2 structs by adding
such an ID field. But with the media controller we can at least create an
ioctl that specifies a 'target entity' that will receive any non-media
controller ioctl. Note that for now we only support sub-devices as the target
entity.

The idea is this:

// Select a particular target entity
ioctl(mc, VIDIOC_S_SUBDEV, &entityID);
// Send S_FMT directly to that entity
ioctl(mc, VIDIOC_S_FMT, &fmt);
// Send a custom ioctl to that entity
ioctl(mc, VIDIOC_OMAP3_G_HISTOGRAM, &hist);

This requires no API changes and is very easy to implement. One problem is
that this is not thread-safe. We can either supply some sort of locking
mechanism, or just tell the application programmer to do the locking in the
application. I'm not sure what is the correct approach here. A reasonable
compromise would be to store the target entity as part of the filehandle.
So you can open the media controller multiple times and each handle can set
its own target entity.

This also has the advantage that you can have a filehandle 'targeted' at a
resizer and a filehandle 'targeted' at the previewer, etc. If you want to use
the same filehandle from multiple threads, then you have to implement locking
yourself.


Open issues
===========

In no particular order:

1) How to tell the application that this board uses an audio loopback cable
to the PC's audio input?

2) There can be a lot of device nodes in complicated boards. One suggestion
is to only register them when they are linked to an entity (i.e. can be
active). Should we do this or not?

3) Format and bus configuration and enumeration. Sub-devices are connected
together by a bus. These busses can have different configurations that will
influence the list of possible formats that can be received or sent from
device nodes. This was always pretty straightforward, but if you have several
sub-devices such as scalers and colorspace converters in a pipeline then this
becomes very complex indeed. This is already a problem with soc-camera, but
that is only the tip of the iceberg.

How to solve this problem is something that requires a lot more thought.

4) One interesting idea is to create an ioctl with an entity ID as argument
that returns a timestamp of frame (audio or video) it is processing. That
would solve not only sync problems with alsa, but also when reading a stream
in general (read/write doesn't provide for a timestamp as streaming I/O does).

5) I propose that we return -ENOIOCTLCMD when an ioctl isn't supported by the
media controller. Much better than -EINVAL that is currently used in V4L2.

6) For now I think we should leave enumerating input and output connectors
to the bridge drivers (ENUMINPUT/ENUMOUTPUT). But as a future step it would
make sense to also enumerate those in the media controller. However, it is
not entirely clear what the relationship will be between that and the
existing enumeration ioctls.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
