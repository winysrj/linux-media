Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54464 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbCHMDd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 08:03:33 -0400
Date: Sun, 8 Mar 2015 09:03:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] Supporting DVB device in MC
Message-ID: <20150308090326.0e695ab8@recife.lan>
In-Reply-To: <20150306101538.09c7598c@recife.lan>
References: <20150306101538.09c7598c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Mar 2015 10:15:38 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> This e-mail contains the results of the discussions we had at #v4l irc
> channel, related to how to properly export DVB via the Media Controller
> API. A good part of the content of e-mail was written by Sakari Ailus.
> 
> Let's use it as a reference point for the discussions, and reply to it
> with our personal comments about how to solve the pending issues.
> 
> Issues to be addressed
> ----------------------
> 
> According to Laurent Pinchart, originally, the Media Controller (MC) was
> designed to represent the data flow between hardware parts on media devices.
> As such, there's no direct representation of the device nodes there, as
> this is a Linux abstraction. Yet, the DMA engine that provides output
> to userspace is represented via a "devnode" type of entity, with is
> associated with the corresponding /dev/video? node.
> 
> From userspace standpoint, representing the device nodes that are used
> to control a given device is fundamental, as all the hardware control
> happen via those control entry points. So, userspace needs to know
> what device nodes are associated to each entity at the MC, in order to
> get control of the hardware.
> 
> Except for a few cases, the current MC model works well for usual V4L2
> drivers, but it fails to represent devices without DMA engines, or
> where the DMA is not associated with a control entry point. Also,
> devices like flash and led hardware are somewhat abusing of the API,
> as those hardware are not associated with the data flow. They're just
> some hardware pieces that needs to be controlled from userspace.
> 
> With the addition of the DVB media controller patches, it become
> clear that the current MC model doesn't properly represent device
> nodes on the way it was originally conceived (e. g. one device node
> would represent one DMA engine).
> 
> On DVB, the frontend, demux, ca and net device nodes are associated
> to the hardware components or hardware blocks[1]. The DMA is, currently,
> an internal component of the MC dataflow. The dvr device node is
> the output node, whose data was produced by Kernel filters, and not
> directly associated with the hardware's DMA.
> 
> Also, the demux entity can either be a hardware entity (for more 
> expensive chipsets that have a MPEG-TS demux inside) or a software
> entity, where the Kernel emulates a MPEG-TS demux hardware.
> 
> So, the media controller concept needs to be extended, in order to
> properly represent the entities that implement software handling
> inside the Kernel (like a software demux filter), and to support
> the entities that are used to control the hardware.
> 
> For DVB, it is needed to properly represent the device nodes associated
> with the hardware control and the pure hardware entities that controls
> the satellite antena system via DiSEqC 1.0, 1.1 and 2.0 protocols.
> 
> [1] A DVB frontend is a block of components with tuner, digital TV demod
> and Satellite Equipment Control. They're commanded by one device node,
> but it is needed to represent each of those components individually
> via MC in the near future.
> 
> What has been agreed on March, 4 2015
> -------------------------------------
> 
> - The current Media Controller API exposes device topologies as a data
> stream-oriented graph of entities. Links connect those entities through pads
> that represent data stream endpoints.
> 
> - Entities representing software blocks need to be supported as well in cases
> where they are expected by existing user space APIs. DVB demuxers are an
> example, as they are often absent in cheap devices and are then implemented in
> software inside the kernel.
> 
> - Entities are not device nodes. Entities correspond to hardware devices or
> part thereof, or logical abstractions of those. Entities can be controlled
> through device nodes, and their drivers can expose device nodes to userspace,
> but the nature of an entity in the existing MC model is not intrinsiquely a
> device node.
> 
> - Tuner, demod and DMA engine are hardware devices. These are or should be
> described by entities in a Media Controller graph.
> 
> - When a tuner is modeled by its driver as a V4L2 sub-device, the driver can
> implement a V4L2 subdev device node. In that case the tuner entity in an MC
> graph must report the V4L2 subdev device node associated with the tuner.
> 
> - The tuners have traditionally been controlled as part of a video, radio, vbi
> or dvb device. In that case the control of the tuner is performed through
> video, radio, vbi or dvb devices, and is indirect.
> 
> - User space need to find out how to control entities, both in the direct and
> indirect controls cases. In the direct control case an entity should report
> which device node(s) it can be controlled through. In the indirect control
> case, the control device node(s) should be reported by the entities that are
> directly controlled by them, e. g. the entities created by the bridge driver.
> User space will use the MC data stream graph to locate those other entities,
> and from there find the indirect control device nodes.
> 
> 
> Open questions
> --------------
> 
> - How does the user space discover how to control the tuner, if it is
> controlled through by a video node exposed by the bridge driver?
> 
> - Simple examples of bt878 tuner hardware pipeline:
> 
>   video: tuner -> bt878 core -> bt878 video dma
> 
>   vbi: tuner -> bt878 core -> bt878 vbi dma
> 
>   radio: tuner -> bt878 core
> 
>   Radio has no DMA, otherwise the pipeline is the same, but the
>   control is different: it goes through radio device node. There is no
>   DMA associated with radio.
> 
> - The entities in the previous example report following interfaces
>   (device nodes) in entity enumeration:
> 
>   tuner: /dev/v4l-subdev (optional)
>   bt878 core: /dev/radio, /dev/vbi and /dev/video
>   bt878 video dma: /dev/video
>   bt878 vbi dma: /dev/vbi
> 
> Summary of the discussions that happened on March, 5 2015
> ---------------------------------------------------------
> 
> As pointed, if we had at most a single device node to report per entity,
> we would just use media_entity_desc.dev (or .v4l, ...) and we would be done
> with it. But we sometimes have more than one device node to report. So,
> while a 1:1 mapping would be easy things become a way trickier when we
> need to support both 1:n and n:1 mapping (or, generically, n:n).
> We currently have no solution for that. 
> 
> So the problem pretty much boils down to coming up with a new API for the
> n:1 and n:n cases possibly using that API for the 1:n case instead (or in
> addition to) media_entity_desc.dev.
> 
> Another associated problem is that some device nodes provide indirect
> control of the elements inside the pipeline, e. g. video devnodes may or
> may not control the non DMA elements, depending on the MC implementation.
> It is currently not possible for userspace to know if either a devnode
> has indirect control over an entity.
> 
> It was bold on the discussions that a flash entity is a violation
> of the MC model, as such entity has no data, but just an entity that
> controls a piece of the hardware.
> 
> Both Hans and Mauro thinks that MC as a way to describe the system
> (for want of a better word) in terms of blocks and links. Whether a block
> is mapped to software, IP core or hw is immaterial and if was never meant
> to be constricted to that. They also think that entities that controls
> the hardware ("control entities") also need to be mapped via MC.
> 
> Laurent, on the other hand, understands that the MC should represent
> only to entities in the current sense of the term and not to "control
> entities". In other words, he doesn't agree that the proper solution
> would be to create entities for devnodes. He thinks that a "property
> API" for direct control should be used for that. However, there were
> no discussions or proposals for a property API during the meeting.
> 
> The indirect control report also has some technical issues, as the
> subdevs don't use know about the indirect control. Only the bridge
> driver has such knowledge. The indirect control is also subject to
> runtime parameters, like input select (with actually changes the
> pipeline).
> 
> Yet, everybody in the discussions agreed that devnode(s) are associated
> with each entity should be reported.
> 
> Mauro then discussed about complex usecase scenarios, where several
> subsystems could be envolved (V4L2, DVB, ALSA, DRM) to provide a
> pipeline for devices like a TV set or a Set Top Boxes.
> 
> On such scenarios, there will be lots of device nodes, and indirect
> control will be constrained to certain entities.
> 
> For example, on a device with "t" tuners and "d" demods, where "t"
> and "d" represents the amount of entities, a possible scenario is
> to have t != d. In such scenario, a frontend node will control both
> a tuner and a demod at the same time, but the actual tuner/demod that
> will be controlled will depend on the active pipeline.
> 
> It was discussed if it would be possible to handle the tuner via
> a separate subdev node, instead of using the indirect control.
> 
> However, Mauro pointed that both the tuner and the demod should
> be programmed at the same time, as there are parameters that needs
> to be negociated by both drivers (IF frequency, bandwidth filter,
> AGC, etc) that will depend on the same set of properties requested
> by the userspace.
> 
> That's the way the current DVB core does, and trying to split it
> would case a major redesign, and the result will be worse than
> keeping both controlled by a single device node. It might be
> possible to use the atomic supported planned for MC, but Mauro
> is afraid that this won't really work, as, on some tuners like
> the ones that dib0700 driver supports, the demod actually 
> changes lots of tuning parameters in runtime, in order to improve
> the signal quality. Also, both tuner and demod could contribute
> to provide statistics parameters via DVBv5 stats API.
> 
> On the other hand, the tuner should still be exposed via MC, as
> it is an entity that it is shared by both analog and digital TV
> part of the hybrid boards, and the pipeline should represent if
> either the tuner is part of the analog or the digital circuit.
> 
> No agreements were archived on this meetings, as we ran
> out of time to finish the discussions.

As nobody replied with a comment to change the above summary, let's continue
the discussions with my proposal about how to solve the issues.

Please notice that this is a rough proposal, imagining that we would
start MC today. In other words, after we archive an agreement about
what's the best solution, we'll need to discuss how implement it in
a way that it won't break the existing implementation.

MC ISSUES ON REPRESENTING CONTROL HW BLOCKS
===========================================

For me, it is clear that the current MC approach is OK to represent the
data bus and the data interactions of the media stream. This is done by
creating data flow entities. Each entity can have multiple input pads and
multiple output pads, and those are connected via data flow links.

However, the DMA engines are misrepresented, as they're shown as devnode
entity types.

The 1:1 map between a DMA engine and a devnode is true only for a very
specific subset of V4L2 devices: PCI or SoC IP blocks whose device node
is put exactly as the last element (or first element, on input devices)
of the pipeline.

Thus, the V4L2 devnode is not a DMA for:
- USB devices, where a Kernel software filters out the USB
  protocol from the stream sent to userspace.

On those, the simplified data pipeline, for a webcam, would be

	[sensor] --> [USB bridge] --> [DMA] --> [USB core] --> [bridge driver's data filter] --> [devnode]

- radio devnodes, where the DMA is not associated with a V4L2
  device, but, instead, the DMA is at the ALSA pipeline, on devices
  where it is present.

On those, the data pipeline is:

	[tuner] --> [FM demod] --> [DMA] --> [ALSA core] --> [ALSA capture devnode]

The radio device node, used to control both the tuner and the FM demod,
is not part of the data pipeline.

In the last case, the MC fails to represent the device node that is
needed by userspace applications to control the radio hardware.

Moreover, while there are several types of DVB devnodes (frontend, demux,
ca, net, dvr), none of them are directly associated with the DMA entity.
The device that has a closest match is the dvr devnode, but the DVB core
may use a software block to filter specific packet IDs. So, the dvr
devnode is actually not the DMA itself, but just an IP or a Kernel software
block.

WHAT'S A DEVNODE FROM THE HARDWARE'S PERSPECTIVE
================================================

All devnodes are the POSIX way to represent the hardware control points. 
Each devnode defines the API that abstracts the hardware differences and
controls the device, or a subset of the device. This is true not only to
Linux, but to all flavors of Unix and to other systems that follows POSIX.

So, the devnodes are actually "control entities" that controls a set of 
hardware components, and can be represented themself as a graph.

In the specific case of the DVB model, the "frontend" entity actually
represents the control entrypoint for 3 hardware IP blocks:
	- the tuner, when it is in DVB mode;
	- the digital TV demodulator;
	- the satellite equipment control (SEC), for Satellite receivers.

That's said, the current MC model is currently abused on V4L2 to represent
other control entities on a media pipeline.

FLASH ENTITIES
==============

The flash entity is actually a control entity, as it is not associated
with a the data stream at all.

The flash entity actually represents a piece of the hardware that it is
either controled via a subdev devnode or indirectly via the bridge driver,
by a set of controls made available via the video device node.

On both cases, the flash entity is actually a hardware abstraction
interface that controls a set of hardware registers that turns on the
flash/LED of a camera when taking a picture. On simpler hardware, it is
just a standard way to control a GPIO pin used to enable/disable the LED
on a cell phone.

On a pure data-flow only MC representation, the flash should not appear
at the graph.

However, as this entity needs to be controlled, right now the MC
represents it. Yet, it fails to properly tell what devnode is used
to control the flash entity.

The control flow of a flash entity could be represented as bellow:

a) in the case where the flash can only be controlled via a subdev:

	userspace --> [flash subdev] --> [flash]

b) in the case where the flash device can only be controlled by a video subdev:

		      [            ]     [      ] --> [flash]
	userspace --> [video subdev] --> [bridge] --> [dma]
		      [		   ]     [      ] --> [analog demod]
		      [		   ]     [      ] --> [sensor]

c) if the flash can either be controlled by an associated subdev or by
the bridge driver via the video subdev, it should be represented as:

		      [            ]     [      ] --> [flash] <-- [flash subdev] <-- userspace
	userspace --> [video subdev] --> [bridge] --> [dma]
		      [		   ]     [      ] --> [analog demod]
		      [		   ]     [      ] --> [sensor]

FRONTEND ENTITY
===============

The frontend represents the part of the DVB hardware that controls the
reception of a digital TV physical channel. It consists of a several
IP blocks: a tuner, a digital TV demodulator and, for Satellite systems, 
a Satellite Equipment Control (SEC).

Please notice that the same tuner can be used by either analog or
digital reception. Also, some hardware may dynamically associate one
of the existing tuners to one existing demod. It could even be possible
to do a n:n association on some usecases.

The control flow of frontend would thus be mapped as:

		      [        ] --> [tuner]
	userspace --> [frontend] --> [demod]
		      [	       ] --> [SEC]

Btw, the SEC entity is actually a control entity that controls the
pipelines inside the antena subsystem: satellite switches, satellite
dish tracking system, satellite dishes (actually the LNBf components).

PS.: we don't need to represent the Satellite pipelines at the Kernel, as
the Kernel just exports the harware interface to userspace. It is up
to userspace to setup those pipelines directly.

NET ENTITY
==========

Another type of control entity is the "net" devnode. On DVB, each
card has an Ethernet MAC address associated with it. Via the MAC
address, it is possible to create a network interface, that could be
used, for example, to receive firmware updates. This is very useful on
Cable Set-Top-Boxes, in order to provide encrypted key updates and to
change the device menus. Also, some DTV standards could send MPEG-TS
over IP. So, it could eventually be used for data flow as well.

However, the DVB "net" devnode is actually a control point that
it is used to control the DVB specific settings of the Ethernet-like
part of the hardware, and to enable the Ethernet interface.

After the device is controlled via the "net" devnode, the actual
dataflow happens via a standard Linux network interface, that it
is dynamically created by the net interface. This is done by
associating the IP traffic with an specific Packet ID, and telling
with is the type of Ethernet traffic[1] that is found on such packet
ID (there are currently two ways: MPE and ULE).

[1] http://linuxtv.org/downloads/v4l-dvb-apis/dvb_net.html

So, a DVB net entity can actually create several Network devices,
one for each PID that have IP traffic on it. So, it is actually a
special type of demux that handles the PID's contents as Ethernet
traffic.

So, from a data flow perspective, the net interface can be represented
as:

[tuner] --> [demod]     [     ] --> [pid #100] --> [dvb0_0 network interface]
[tuner] --> [demod] --> [demux] --> [pid #101] --> [dvb0_1 network interface]
[tuner] --> [demod]     [     ] --> [pid #102] --> [dvb0_2 network interface]

The "net" device node is just a special control entity for the demux,
used to setup the filters used for network and to dynamically create
the data flow pipeline and the network virtual device:

# dvbnet -p 100
DVB Network Interface Manager
Copyright (C) 2003, TV Files S.p.A

Status: device dvb0_0 for pid 100 created successfully.

# dvbnet -p 101
DVB Network Interface Manager
Copyright (C) 2003, TV Files S.p.A

Status: device dvb0_1 for pid 101 created successfully.

# dvbnet -p 102
DVB Network Interface Manager
Copyright (C) 2003, TV Files S.p.A

Status: device dvb0_2 for pid 102 created successfully.

# ls -la /sys/devices/virtual/net/|grep dvb
drwxr-xr-x  5 root root 0 Mar  8 08:06 dvb0_0
drwxr-xr-x  5 root root 0 Mar  8 08:06 dvb0_1
drwxr-xr-x  5 root root 0 Mar  8 08:06 dvb0_2

# ip addr|grep dvb -A1

20: dvb0_0: <BROADCAST,MULTICAST,NOARP> mtu 4096 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
21: dvb0_1: <BROADCAST,MULTICAST,NOARP> mtu 4096 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
22: dvb0_2: <BROADCAST,MULTICAST,NOARP> mtu 4096 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
23: dvb0_3: <BROADCAST,MULTICAST,NOARP> mtu 4096 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff

MY PROPOSAL: TO REPRESENT CONTROL ENTITIES AS WELL
===================================================

Based on my analysis of the problem, the best solution is:

1) To map both entities used for device control and for data flow;
2) To add some flags to the entities, to better indicate that to userspace:

MEDIA_ENT_FL_DEVNODE:
- the entity has a devnode associated with it. This should be used
  by any entity that has a single device node directly associated to it.
  This will be used by DMA engines with devnodes, by subdevs, by bridge
  drivers, etc;

MEDIA_ENT_FL_CONTROL_ONLY:
- the entity is not part of the data flow. It represents only a piece
  of hardware control bus/registers. This would be used by entities like
  "frontend", "DVB net", "SEC", "flash", etc.

3) to represent the data control graph via control pads and control
   links.

This is for now a rough idea. As I said, if this proposal gets accepted,
we'll need to go into further details to be sure that it will keep working
with the current userspace. I have some ideas already, but let's first
agree on the approach.

Regards,
Mauro
