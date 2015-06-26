Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35352 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbbFZLXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 07:23:12 -0400
Message-ID: <558D3615.3050608@xs4all.nl>
Date: Fri, 26 Jun 2015 13:23:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC] Enumeration of Media Interfaces
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduction
============

This RFC is a proposal that will hopefully fix the impasse w.r.t. DVB and MC.
This proposal was the result of a private irc discussion between Laurent and
myself. We were both on opposite sides of the earlier discussions and we decided
to try to come to a solution between just the two of us. Sakari read an earlier
version of this RFC and is OK with it as well, so now it is time to post it
publicly. Hopefully Mauro likes it as well.

This proposal is fairly high-level, and it does not attempt to go into details.
Before doing that we need to know if all parties agree with the basic concept.
Laurent, Sakari and myself are considering to meet in Finland for 2-3 days in
July to hammer out the details.


Proposal
========

There are two types of drivers: the first (true for all non-MC drivers available
today) controls the full pipeline through DVB/V4L/ALSA/etc. interfaces (generally
these interfaces are device nodes). Applications for these drivers do not need to
know which entities there are, knowing the interfaces is enough.

The second type (the current set of MC drivers) exposes the hardware through media
entities, and each entity can be controlled through a single device node:
v4l-subdevX for subdevices, and videoX for DMA engines. Applications for these
drivers will need to know the entities and how they are linked in order to configure
the hardware correctly. The only interfaces they need to know are those that control
each entity.

The first type of driver will be called an 'interface-centric' driver, the second
type will be called an 'entity-centric' driver in this document. Better names are
welcome, but I can't talk about MC and non-MC drivers anymore since we want to use
the MC for all drivers, so we need to come up with another name. So interface vs
entity centric is the best I came up with.

So we want to extend the use of the MC for all driver types, but we ran into a major
difference of opinion of how to represent device nodes (are these media entities or
properties of media entities?) and how to represent which entities a device node
controls (through links, properties, something else?).

This RFC presents a solution that I hope is acceptable to all.


Media Interfaces
================

The key difference of this proposal is that interfaces such as device nodes (but
this can be an e.g. network interface as well) are represented by a new struct:
media_interface. And that the list of interfaces that a media device has
can be obtained by a new ioctl: MEDIA_IOC_G_INTERFACES. The ioctl will get all
interfaces in a single call for efficiency and atomicity.

So an interface is different from an entity, but both are first class citizens in
the media controller.

The kernel implementation will be that the media_entity in struct video_device will
be replaced by a struct media_interface. And any media_interface that is created
will link into a linked list maintained by the media_device struct. As a consequence
of this change there now is no longer a media_entity for DMA engines to use: this
will have to be created in the DMA engine driver itself, just as subdevice drivers
have their own media_entity.

This design is a lot cleaner as well since today the video_device struct used
to represent a v4l-subdevX device node doesn't use the media_entity field, which
is weird and it indicates that there is a problem with the datastructure design.

However, with the introduction of a media_interface struct any video_device struct
will always use the media_interface field.

So device nodes are media interfaces, hardware blocks are media entities. In rare
cases software blocks are allowed as media entities (e.g. the DVB software demux),
but there should be very good reasons for doing so.

This solves the problem of how to represent device nodes: these are no longer entities
(which several developers were strongly opposed to), but neither are they properties
(which the other camp was strongly opposed to). Instead they are now a new object:
the media interface.

The existing DVB/V4L/ etc. applications can use the new ioctl to obtain all interfaces
exposed by the MC and open the device nodes that are relevant to them.

They don't care about entities (some might in the future, but for now this is not
something they need), they just want the interfaces.

On the other hand applications written for MC devices need to enumerate the entities
and entities may have an interface. For both backwards compatibility and as a shortcut
the interface that controls the entity will remain available through the media_entity,
but only if there is a one-to-one mapping between the entity and interface. This is
always the case today.

Both entities and interfaces will likely need properties, and we should use the same
property API for both.


Relationship between Entities and Interfaces
============================================

This leaves the final missing piece: how to tell userspace which interfaces control
which entities? Or, alternatively: which interfaces control an entity?

The best solution in my view is to do both: depending on the type of driver you approach
this from different directions: either you start with entities and want to find the
interfaces (this is for entity-centric drivers), or you start with interfaces and you
want to find the entities they control (interface-centric drivers).

So keep everyone happy and just support both. It's easy to store this information
efficiently in the kernel and to support both approaches. From an application point
of view either approach (entity or interface centric) is equally valid, so the API
should reflect that.

The current proposal is to expose the list of interfaces that control an entity and
the list of entities controlled by an interface as a property of the entity and
interface respectively.

I am not 100% certain about this, as I think that an argument can be made that
extending struct media_links_enum with a 'struct media_ctl_link_desc *ctl_links' is
a valid approach as well, but using properties would be acceptable for me as well.

I personally like the idea of a media_ctl_link_desc (similar to the media_link_desc,
except there is no pad index) since that would allow a future MEDIA_IOC_SETUP_CTL_LINK
ioctl to be added if we ever need to enable/disable control links.

The media_ctl_link_desc struct could look like this:

struct media_ctl_link_desc {
	__u32 entity;
	__u32 interface;
	__u32 flags;	/* media link flags */
};

Since media interfaces will have their own 32-bit ID (just like entities, and I guess
the same counter in media_device could be used for both), both entities and interfaces
can be referred to in properties (or in a struct media_ctl_link_desc) as a unique u32
value.

For the union in media_entity_desc I would propose that we keep dev for backwards
compatibility, and only use it for v4l-subdev and video nodes (DMA engine). New
applications should use properties to find the interfaces. I'm not certain about
this, this is definitely one of the details that need to be hammered out.

We might not need the union anymore anyway, so that would make a lot of space
available in media_entity_desc. We'd have to think about how to use that.

Not discussed here are the details of the property API. That's a separate
discussion.


Summary
=======

I think this proposal makes sense: the media controller enumerates both entities
and interfaces, and entities can export their interfaces and interfaces can export
their entities.

Everybody happy :-)

Regards,

	Hans
