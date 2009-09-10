Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4032 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZIJNur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:50:47 -0400
Message-ID: <1ceb929cb176ac6272ff94a6dcd47b6d.squirrel@webmail.xs4all.nl>
In-Reply-To: <alpine.LRH.1.10.0909101001390.5940@pub3.ifh.de>
References: <200909100913.09065.hverkuil@xs4all.nl>
    <alpine.LRH.1.10.0909101001390.5940@pub3.ifh.de>
Date: Thu, 10 Sep 2009 15:50:45 +0200
Subject: Re: RFCv2: Media controller proposal
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Patrick Boettcher" <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

> Hello Hans,
>
>
> On Thu, 10 Sep 2009, Hans Verkuil wrote:
>> Here is the new Media Controller RFC. It is completely rewritten from
>> the
>> original RFC. This original RFC can be found here:
>>
>> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_media_device
>>
>> This document will be the basis of the discussions during the Plumbers
>> Conference in two weeks time.
>
> I wasn't following this RFC during the past year, though I heard you
> talking about this idea at LPC 2008.

There were no follow-ups for this RFC in the past year. All the work was
concentrated on the new framework (v4l2_device and v4l2_subdev) which was
in any case needed before we could even think of continuing with this RFC.

Now that this is in we can continue with the next phase and actually think
on how it should be implemented.

>
> I will add some things to discussion (see below) I have in my mind
> regarding similar difficulties we face today with some pure-DTV devices.
>
> From a first look, it seems media controller could not only unify v4l and
> DVB device abstraction layers, but also a missing features to DTV devices
> which are not present right now.

Yes, that's the idea. Currently I am concentrating exclusively on v4l
since we really, really need it there asap. But it is a very generic idea
that makes no assumptions on the hardware. It just gives you an abstract
view of the board and a way to access it.

>
>> [..]
>>
>> Topology
>> --------
>>
>> The topology is represented by entities. Each entity has 0 or more
>> inputs and
>> 0 or more outputs. Each input or output can be linked to 0 or more
>> possible
>> outputs or inputs from other entities. This is either mutually exclusive
>> (i.e. an input/output can be connected to only one output/input at a
>> time)
>> or it can be connected to multiple inputs/outputs at the same time.
>>
>> A device node is a special kind of entity with just one input (capture
>> node)
>> or output (video node). It may have both if it does some in-place
>> operation.
>>
>> Each entity has a unique numerical ID (unique for the board). Each input
>> or
>> output has a unique numerical ID as well, but that ID is only unique to
>> the
>> entity. To specify a particular input or output of an entity one would
>> give
>> an <entity ID, input/output ID> tuple.
>>
>> When enumerating over entities you will need to retrieve at least the
>> following information:
>>
>> - type (subdev or device node)
>> - entity ID
>> - entity description (can be quite long)
>> - subtype (what sort of device node or subdev is it?)
>> - capabilities (what can the entity do? Specific to the subtype and more
>> precise than the v4l2_capability struct which only deals with the board
>> capabilities)
>> - addition subtype-specific data (union)
>> - number of inputs and outputs. The input IDs should probably just be a
>> value
>> of 0 - (#inputs - 1) (ditto for output IDs).
>>
>> Another ioctl is needed to obtain the list of possible links that can be
>> made
>> for each input and output.
>>
>> It is good to realize that most applications will just enumerate e.g.
>> capture
>> device nodes. Few applications will do a full scan of the whole
>> topology.
>> Instead they will just specify the unique entity ID and if needed the
>> input/output ID as well. These IDs are declared in the board or
>> sub-device
>> specific header.
>
> Very good this topology-idea!
>
> I can even see this to be continued in user-space in a very smart
> application/library: A software MPEG decoder/rescaler whatever would be
> such an entity for example.

True, but in practice it will be very hard to make such an app for generic
hardware. You can hide some of the hardware-specific code behind a
library, but the whole point of giving access is to optimally utilize all
the hw-specific bits. On the other hand, having a library that tries to do
a 'best effort' job might be quite feasible.

>> A full enumeration will typically only be done by some sort of generic
>> application like v4l2-ctl.
>
> Hmm... I'm seeing this idea covering other stream-oriented devices. Like
> sound-cards (*ouch*).

I may be mistaken, but I don't believe soundcards have this same
complexity are media board.

>
>> [..]
>>
>> Open issues
>> ===========
>>
>> In no particular order:
>>
>> 1) How to tell the application that this board uses an audio loopback
>> cable
>> to the PC's audio input?
>>
>> 2) There can be a lot of device nodes in complicated boards. One
>> suggestion
>> is to only register them when they are linked to an entity (i.e. can be
>> active). Should we do this or not?
>
> Could entities not be completely addressed (configuration ioctls) through
> the mc-node?

Not sure what you mean.

> Only entities who have an output/input with is of type
> 'user-space-interface' are actually having a node where the user (in
> user-space) can read from/write to?

Yes, each device node (i.e. that can be read from or written to) is
represented by an entity. That makes sense as well, since there usually is
a DMA engine associated with this, which definitely qualifies as something
more than 'just' an input or output from some other block. You may even
want to control this in someway through the media controller (setting up
DMA parameters?).

Inputs and outputs are not meant to represent anything complex. They just
represent pins or busses.

>
>> 3) Format and bus configuration and enumeration. Sub-devices are
>> connected
>> together by a bus. These busses can have different configurations that
>> will
>> influence the list of possible formats that can be received or sent from
>> device nodes. This was always pretty straightforward, but if you have
>> several
>> sub-devices such as scalers and colorspace converters in a pipeline then
>> this
>> becomes very complex indeed. This is already a problem with soc-camera,
>> but
>> that is only the tip of the iceberg.
>>
>> How to solve this problem is something that requires a lot more thought.
>
> For me the entities (components) you're describing are having 2 basic
> bus-types: one control bus (which gives register access) and one or more
> data-stream buses.

Not really a datastream bus, more the DMA engine (or something similar)
associated with a datastream bus. It's really the place where data is
passed to/from userspace. I.e. the bus between a sensor and a resizer is
not an entity. It's probably what you meant in any case.

> In your topology I understood that the inputs/outputs are exactly
> representing the data-stream buses.
>
> Depending on the main-type of the media controller a library could give
> some basic-models of how all entities can be connected together. EG:
>
> (I have no clue about webcams, that why I use this as an example :) ):
>
> Webcam: sensor + resize + filtering = picture
>
> WEBCAM model X provides:
>
> 2 sensor-types + 3 resizers + 5 filters
>
> one of each of it provides a pictures. By default this first one of each
> is taken.

My current idea is that the driver will setup an initial default
configuration that would do something reasonable. In this example it would
setup only one sensor as source, one resizer and the relevant filters. So
you have one default path through the system and a library can just follow
that path.

>
>> [..]
>
> My additional comments for DTV
>
> 1) In DTV as of today we can't handle a feature which becomes more and
> more important: diversity. There are boards where you have 2 frontends and
> they can either combined their demodulated data to achieve better
> sensitivity when being tuned to the same frequency or they can deliver two
> MPEG2 transport streams when being tuned to 2 different frequencies. With
> the entity topology this problem would be solved, because we have the
> abstraction of possible inputs.

Exactly.

> 2) What is today a dvb_frontend could become several entities: I'm seeing
> tuner, demodulator, channel-decoder, amplifiers.

In practice every i2c device will be an entity. If the main bridge IC
contains integrated tuners, demods, etc., then the driver can divide them
up in sub-devices at will.

> IMO, we should not
> hesitate to lower the granularity of entities if possible.

I have actually thought of sub-sub-devices. Some i2c devices can be very,
very complex. It's possible to do and we should probably allow for this to
happen in the future. Although we shouldn't implement this initially.

>
> I really, really like this approach as it gives flexibily to user-space
> applications which will ultimatetly improve the quality of the supported
> devices, but I think it has to be assisted by a user-space library and the
> access has to be done exclusively by that library. I'm aware that this
> library-idea could be a hot discussion point.

I do not see how you can make any generic library for this. You can make
libraries for each specific board (I'm talking SoCs here mostly) that
provide a slightly higher level of abstraction, but making something
generic? I don't see how. You could perhaps do something for specific
use-cases, though.

> OTOH, in your approach I see nothing which would block an integration of
> DTV-devices in that media-controller-architecture even if it is not done
> in the first development-period.

I would love to see that happen. But then dvb should first migrate to the
standard i2c API, and then integrate that into v4l2_subdev (by that time
we should probably rename it to media_subdev).

Not a trivial job, but it would truly integrate the two parts.

Thanks for your review!

        Hans

>
> regards,
> --
>
> Patrick
> http://www.kernellabs.com/
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

