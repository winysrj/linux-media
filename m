Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50618 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbbCFNPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 08:15:44 -0500
Received: from recife.lan (unknown [177.180.174.227])
	by lists.s-osg.org (Postfix) with ESMTPSA id 7A43F462BE
	for <linux-media@vger.kernel.org>; Fri,  6 Mar 2015 05:15:42 -0800 (PST)
Date: Fri, 6 Mar 2015 10:15:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [RFC] Supporting DVB device in MC
Message-ID: <20150306101538.09c7598c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This e-mail contains the results of the discussions we had at #v4l irc
channel, related to how to properly export DVB via the Media Controller
API. A good part of the content of e-mail was written by Sakari Ailus.

Let's use it as a reference point for the discussions, and reply to it
with our personal comments about how to solve the pending issues.

Issues to be addressed
----------------------

According to Laurent Pinchart, originally, the Media Controller (MC) was
designed to represent the data flow between hardware parts on media devices.
As such, there's no direct representation of the device nodes there, as
this is a Linux abstraction. Yet, the DMA engine that provides output
to userspace is represented via a "devnode" type of entity, with is
associated with the corresponding /dev/video? node.

>From userspace standpoint, representing the device nodes that are used
to control a given device is fundamental, as all the hardware control
happen via those control entry points. So, userspace needs to know
what device nodes are associated to each entity at the MC, in order to
get control of the hardware.

Except for a few cases, the current MC model works well for usual V4L2
drivers, but it fails to represent devices without DMA engines, or
where the DMA is not associated with a control entry point. Also,
devices like flash and led hardware are somewhat abusing of the API,
as those hardware are not associated with the data flow. They're just
some hardware pieces that needs to be controlled from userspace.

With the addition of the DVB media controller patches, it become
clear that the current MC model doesn't properly represent device
nodes on the way it was originally conceived (e. g. one device node
would represent one DMA engine).

On DVB, the frontend, demux, ca and net device nodes are associated
to the hardware components or hardware blocks[1]. The DMA is, currently,
an internal component of the MC dataflow. The dvr device node is
the output node, whose data was produced by Kernel filters, and not
directly associated with the hardware's DMA.

Also, the demux entity can either be a hardware entity (for more 
expensive chipsets that have a MPEG-TS demux inside) or a software
entity, where the Kernel emulates a MPEG-TS demux hardware.

So, the media controller concept needs to be extended, in order to
properly represent the entities that implement software handling
inside the Kernel (like a software demux filter), and to support
the entities that are used to control the hardware.

For DVB, it is needed to properly represent the device nodes associated
with the hardware control and the pure hardware entities that controls
the satellite antena system via DiSEqC 1.0, 1.1 and 2.0 protocols.

[1] A DVB frontend is a block of components with tuner, digital TV demod
and Satellite Equipment Control. They're commanded by one device node,
but it is needed to represent each of those components individually
via MC in the near future.

What has been agreed on March, 4 2015
-------------------------------------

- The current Media Controller API exposes device topologies as a data
stream-oriented graph of entities. Links connect those entities through pads
that represent data stream endpoints.

- Entities representing software blocks need to be supported as well in cases
where they are expected by existing user space APIs. DVB demuxers are an
example, as they are often absent in cheap devices and are then implemented in
software inside the kernel.

- Entities are not device nodes. Entities correspond to hardware devices or
part thereof, or logical abstractions of those. Entities can be controlled
through device nodes, and their drivers can expose device nodes to userspace,
but the nature of an entity in the existing MC model is not intrinsiquely a
device node.

- Tuner, demod and DMA engine are hardware devices. These are or should be
described by entities in a Media Controller graph.

- When a tuner is modeled by its driver as a V4L2 sub-device, the driver can
implement a V4L2 subdev device node. In that case the tuner entity in an MC
graph must report the V4L2 subdev device node associated with the tuner.

- The tuners have traditionally been controlled as part of a video, radio, vbi
or dvb device. In that case the control of the tuner is performed through
video, radio, vbi or dvb devices, and is indirect.

- User space need to find out how to control entities, both in the direct and
indirect controls cases. In the direct control case an entity should report
which device node(s) it can be controlled through. In the indirect control
case, the control device node(s) should be reported by the entities that are
directly controlled by them, e. g. the entities created by the bridge driver.
User space will use the MC data stream graph to locate those other entities,
and from there find the indirect control device nodes.


Open questions
--------------

- How does the user space discover how to control the tuner, if it is
controlled through by a video node exposed by the bridge driver?

- Simple examples of bt878 tuner hardware pipeline:

  video: tuner -> bt878 core -> bt878 video dma

  vbi: tuner -> bt878 core -> bt878 vbi dma

  radio: tuner -> bt878 core

  Radio has no DMA, otherwise the pipeline is the same, but the
  control is different: it goes through radio device node. There is no
  DMA associated with radio.

- The entities in the previous example report following interfaces
  (device nodes) in entity enumeration:

  tuner: /dev/v4l-subdev (optional)
  bt878 core: /dev/radio, /dev/vbi and /dev/video
  bt878 video dma: /dev/video
  bt878 vbi dma: /dev/vbi

Summary of the discussions that happened on March, 5 2015
---------------------------------------------------------

As pointed, if we had at most a single device node to report per entity,
we would just use media_entity_desc.dev (or .v4l, ...) and we would be done
with it. But we sometimes have more than one device node to report. So,
while a 1:1 mapping would be easy things become a way trickier when we
need to support both 1:n and n:1 mapping (or, generically, n:n).
We currently have no solution for that. 

So the problem pretty much boils down to coming up with a new API for the
n:1 and n:n cases possibly using that API for the 1:n case instead (or in
addition to) media_entity_desc.dev.

Another associated problem is that some device nodes provide indirect
control of the elements inside the pipeline, e. g. video devnodes may or
may not control the non DMA elements, depending on the MC implementation.
It is currently not possible for userspace to know if either a devnode
has indirect control over an entity.

It was bold on the discussions that a flash entity is a violation
of the MC model, as such entity has no data, but just an entity that
controls a piece of the hardware.

Both Hans and Mauro thinks that MC as a way to describe the system
(for want of a better word) in terms of blocks and links. Whether a block
is mapped to software, IP core or hw is immaterial and if was never meant
to be constricted to that. They also think that entities that controls
the hardware ("control entities") also need to be mapped via MC.

Laurent, on the other hand, understands that the MC should represent
only to entities in the current sense of the term and not to "control
entities". In other words, he doesn't agree that the proper solution
would be to create entities for devnodes. He thinks that a "property
API" for direct control should be used for that. However, there were
no discussions or proposals for a property API during the meeting.

The indirect control report also has some technical issues, as the
subdevs don't use know about the indirect control. Only the bridge
driver has such knowledge. The indirect control is also subject to
runtime parameters, like input select (with actually changes the
pipeline).

Yet, everybody in the discussions agreed that devnode(s) are associated
with each entity should be reported.

Mauro then discussed about complex usecase scenarios, where several
subsystems could be envolved (V4L2, DVB, ALSA, DRM) to provide a
pipeline for devices like a TV set or a Set Top Boxes.

On such scenarios, there will be lots of device nodes, and indirect
control will be constrained to certain entities.

For example, on a device with "t" tuners and "d" demods, where "t"
and "d" represents the amount of entities, a possible scenario is
to have t != d. In such scenario, a frontend node will control both
a tuner and a demod at the same time, but the actual tuner/demod that
will be controlled will depend on the active pipeline.

It was discussed if it would be possible to handle the tuner via
a separate subdev node, instead of using the indirect control.

However, Mauro pointed that both the tuner and the demod should
be programmed at the same time, as there are parameters that needs
to be negociated by both drivers (IF frequency, bandwidth filter,
AGC, etc) that will depend on the same set of properties requested
by the userspace.

That's the way the current DVB core does, and trying to split it
would case a major redesign, and the result will be worse than
keeping both controlled by a single device node. It might be
possible to use the atomic supported planned for MC, but Mauro
is afraid that this won't really work, as, on some tuners like
the ones that dib0700 driver supports, the demod actually 
changes lots of tuning parameters in runtime, in order to improve
the signal quality. Also, both tuner and demod could contribute
to provide statistics parameters via DVBv5 stats API.

On the other hand, the tuner should still be exposed via MC, as
it is an entity that it is shared by both analog and digital TV
part of the hybrid boards, and the pipeline should represent if
either the tuner is part of the analog or the digital circuit.

No agreements were archived on this meetings, as we ran
out of time to finish the discussions.

