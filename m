Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49579 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbcDTKdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 06:33:22 -0400
Date: Wed, 20 Apr 2016 07:33:17 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>, media-workshop@linuxtv.org
Subject: [ANNOUNCE] Linux Media Summit 2016 Report =?UTF-8?B?4oCT?= San
 Diego (draft)
Message-ID: <20160420073317.4bd1cc50@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the draft of the media summit report. I'll be soon posting an online
version of it, with the group photo, at linuxtv.org.

Please review. Also, for the ones that presented a slide deck there, please
send me the slides, for me to post there too.

Thanks!
Mauro

---

Linux Media Summit 2016 – San Diego
===================================

Attendees list:

 Mauro Carvalho Chehab <mchehab@osg.samsung.com> (Samsung)
 Lars-Peter Clausen <lars@metafoo.de> (Analog Devices)
 Magnus Damm <magnus.damm@gmail.com> (Renesas)
 Shuah Khan <shuahkh@osg.samsung.com> (Samsung)
 Guennadi Liakhovetski <g.liakhovetski@gmx.de> (Intel)
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> (Renesas)
 Benoit Parrot <bparrot@ti.com> (Texas Instruments)
 Laurent Pinchart <laurent.pinchart@ideasonboard.com> (Ideas on Board)
 Niklas Söderland <niklas.soderlund@ragnatech.se> (Ragnatech)
 Hans Verkuil <hverkuil@xs4all.nl> (Cisco)

1. CEC Framework Status update
==============================

First version of the framework close to completion. Will likely be
submitted for Kernel 4.7, although it could be merged only for 4.8.
 Independent framework, allows consumers in V4L2, DRM, ALSA, …

Driver support WIP for Pulse Eight USB dongle, omap4, adv7604/7842/7511.

Future plans:
-------------

-   ARC/CDC hotplug support
-   Implement high level protocol constraints (resend, timeout, rate
    limiting of messages). Whether those constraints can be implemented
    in the kernel remains to be analyzed, as the kernel to userspace API
    might be at a much lower level than the constraints. A userspace
    library might be another option.

2. Quick demo of the new qdisp utility that is in development
=============================================================

The qdisp utility is a simpler alternative to qv4l2 that handles video
capture and show the captured video only.

Currently, qdisp requires OpenGL, OpenGLES support is planned.

Color space and format conversion code is based on GPU shaders. It will
be split into a library to be shared with qv4l2. A CPU-based alternative
would be feasible but isn’t planned at the moment.

The qdisp code is currently available here:
<http://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec>.

3. Request API Status update
============================

At the moment: Allows to chain multiple of the existing IOCTLs into a
request which will either be applied atomicly or not at all

Initial proposal
----------------

-   New IOCTL to start a commit
-   APPLY operation will apply changes in a request immediately. Useful
    to change multiple controls at the same time
-   QUEUE operation will queue changes with a buffer and will be applied
    when the buffer is processed

Alternative proposal
--------------------

One new IOCTL that takes all state and applies it atomicly (like DRM
atomic modesetting)

Open question
-------------

How to perform atomic operations across subssytems? V4L2, DRM, ALSA, MC

Action item
-----------

Hans will contact Pawel to see what/when needs to be upstreamed for e.g.
the rockchip driver.

4. Stream multiplexing (Guennadi Liakhovetski)
==============================================

CSI-2 has up to 4 virtual channels (2 bits), 6 bits for Data Type

Virtual channels do not have to be in sync with one another, so
different virtual channels can carry different framerates.

Within a virtual channel each line is tagged with a data type as well,
so it can be used to pass metadata + videodata in one virtual channel as
well.

Requirements
------------

-   Pipeline validation
-   Format validation
-   Bandwidth/QoS
-   Routing (related to muxing/demuxing)
-   Sounds interesting to have a non-V4L2 specific solution to solve
    cases where there a multiple entities linked into a bus or needing
    switch. For example, the ALSA subsystem supports TDM.

Proposed solution
-----------------

Introduce the concept of virtual channels which are routed on the top of
the physical links. A virtual channel has a route that goes through
multiple physical entities, with routing information at each entity on
how the data is forwarded.

Action item
-----------

Laurent will dig up old router entity code he posted in the past and
re-post it or provide a link to that code.

5. DT Bindings for flash & lens controllers
===========================================

There are drivers that create their MC topology using the device tree
information, which works great for entities that transport data, but how
to detect entities that don’t transport data such as flash devices,
focusers, etc.?

How can those be deduced using the device tree?

Sensor DT node add phandle to focus controller.: add generic v4l binding
properties to reference such devices.

6. How to improve the linux-media patch and review process?
===========================================================

Submaintainership status
------------------------

Currently, sub-maintainership is not working as expected. Also, we’re
currently lacking DVB and RC sub-maintainers.

Reviewers
---------

We also lack reviewers.

Shuah offered help with Media Controller patch reviews

Proposals
---------

Idea from Daniel Vetter to handle public APIs that might need some
tweaking is to have it depend on a debug config option so enabling that
api would make the kernel tainted.

Action items
------------

Post a RFC asking for volunteers for sub-maintainership for DVB and
Remote Controllers at the linux-media ML. In the case of Remote
Ccontrollers: we could also post RFC to linux-input.

Mauro: contact Kamil to ask status of codec sub-maintainership. If no
time, then Hans can take over.

Push on Intel (Sakari, Guennadi) (perhaps talk to Dirk Hohndel), Samsung
(Marek and team), Google (Pawel) to give them time for
upstreaming/reviewing.

Next media workshop
-------------------

Should we organize the next media workshop at ELC-E or LPC/KS ? Let’s
try with a quick survey of who plans to go where. As this workshop is
held in the US Europe would be good to attract more European developers.

7. Fix broken media_device alloc/remove – Media Device Allocator API
=====================================================================

Slides: <https://drive.google.com/open?id=0B0NIL0BQg-AlTUQxdG1zWW15Tmc>

The media module (media.ko) needs to be owner of the media devnode.cdev,
and not the first driver that registers it. With the such change,
`media_devnode_register()` and `__media_device_register()` don’t need
struct module passed in. This can be cleaned up.
 Setting cdev parent should be set correctly. It was suggested to look
on how looking howiio-core handles it.

All drivers that use the media conroller should use the Media Device
Allocator API.
 Dynamic changes ate the graph (with happens when two drivers bind to
MC) doesn’t produce an event to use space. So, application would need to
poll to find changes to the topology. This is not ideal and require more
work.

8. Media Controller connection Entities
=======================================

MC currently lacks a way to expose how external sources and outputs (RF,
S-Video, composite, etc) are connected.

Mauro explained what are the userspace needs that are not covered by our
APIs today and that could benefit from the MC API : basically one of the
goals for the MC, back on the 2009 discussions, were to be able to show
the device nodes that related and should used together to capture analog
TV, digital TV and ALSA, and to be able to prevent the related drivers
to stream on unexpected ways. So, when an analog TV connector is in use,
the DVB API can’t be enabled and vice-versa. The device nodes issue is
unrelated to connectors, but supporting the connectors is needed to be
able to prevent using two incompatible paths at the same time. In other
words, Analog and digital paths are usually exclusive, and without MC
and MC connectors, there’s no way for userspace to know what the
constraints are.

Physical x Logical representation
---------------------------------

While media cards/boards have physical connectors, the chips managed by
the Kernel driver sees a “logical” connection, in the sense that each
different input/output is mapped via a pin set with a corresponding
register setup.

Due to that, the representation used by V4L2 (VIDIOC_ENUM_INPUT,
VIDIOC_G_INPUT, VIDIOC_S_INPUT) is to represent the logical
connection.

Another desired feature of represent MC connections is to present
information about connectors to the user to make it easier to know where
to plug the cables. Such representation is physical connector based.

A connection-based representation in MC would require properties to map
them to physical connectors. A connector-based representation in MC
would require properties to map them to logical connections. Provided
that both mappings are possible, the MC representation could either use
logical connections or physical connectors.

This problem is similar to virtual channels over a logical link (like
CSI-2, see “4. Stream multiplexing”), in the sense that logical
connectors can be thought of as a specific routing of one or more
signals from the physical connector through some fabric (e.g. switch,
crossbar) to the demodulator.

For RF and Composite, the physical and logical representation are the
same, as those connectors have just one analog signal.

S-Video has two signals on it (Y+C). When a S-Video signal is sent to
the connector, the physical and logical representation matches. However,
some devices allow to use the S-Video connector to send a composite
signal, by using a Composite->S-Video cable, but requiring a different
setup at the chipset. On such cases, the physical and logical
representation is different.

There’s also one case that it was not covered yet: how to handle the
cases where one logical connection is mapped via several different
connectors? This is common on ALSA, where the stereo input/output can be
either a single jack or two RCAs.

Proposal for complex connections
--------------------------------

Model physical connectors and support a routing ioctl for the entities
that they are connected to. For existing drivers that use S_INPUT, we
can either not show the logical connectors at all, or we just show the
logical connectors in the absence of knowledge about the actual physical
connectors.

How that routing ioctl should look like is unknown, but this might be
done the same way as the routing as discussed in the context of CSI-2.

Some subdevs that have complex routing are saa7115, msp34xx and adv7842.

Action items:
-------------

It was decided that, for now, we’ll map via MC only the cases where the
physical and logical representation is the same, e. g. RF, Composite and
S-Video signals over a S-Video connector, postponing the other cases to
where we have a routing ioctl.

-   For S-Video, use 2 pads.
-   Use only one sink PAD per input at the analog demod;
-   RF and Connections are OK – just one pad;
-   not map complex cases like Composite over S-Video.

9. Pad identification
=====================

Currently, a pad is identified by index and whether it is a input or
output pad. If the index changes between kernel versions, the userspace
ABI breaks.

While we don’t have the properties API, we could use an enum to give a
type to the pad. Don’t expose this to userspace yet, as exposing it to
userspace requires more discussions, plus the properties API.

Adding pad names exposed to userspace can also be useful. However,
there’s a risk of userspace relying on specific string names to identify
the pad. So, in order to avoid repeating the same mistake we did with
subdev and entity names, the API should define in details what the name
should contain and how it should be constructed. What userspace can
expect from the name, including information that can be extracted from
the name (e.g. can I sscanf(“%u”) to get the pad number ?) also needs to
be defined in the API.

Action item
-----------

Create a pad type enum.

10. Other topics
================

When adding a new API that is still experimental, the DRM/KMS subsystem
covers the API with a configuration option and taints the kernel when
the option is selected. This lasts for a few kernel versions until the
API stabilizes and is then removed. This could be experimented in V4L2,
effectively giving us back CONFIG_EXPERIMENTAL.

Should we avoid reserved fields in new ioctls, or use API versioning (as
in DRM/KMS) ? Versioning is a bit more work in userspace, but avoids
issues with application that don’t zero reserved fields and break when
the API is extended.

Other action items
------------------

-   Review MC virtual driver v3 patch (vimc) from Hellen (MC
    developers);
-   Submit/review the “dynamically allocates pad config” patch
    (Laurent);
-   Split off legacy defines in media.h to media-legacy.h (Hans);
-   User versioning for CEC ioctls instead of reserved fields (Hans).

Cheers,
 Mauro

-- 
Thanks,
Mauro
