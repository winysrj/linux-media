Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:64621 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbZIJNCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:02:23 -0400
Date: Thu, 10 Sep 2009 15:01:56 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
In-Reply-To: <200909100913.09065.hverkuil@xs4all.nl>
Message-ID: <alpine.LRH.1.10.0909101001390.5940@pub3.ifh.de>
References: <200909100913.09065.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,


On Thu, 10 Sep 2009, Hans Verkuil wrote:
> Here is the new Media Controller RFC. It is completely rewritten from the
> original RFC. This original RFC can be found here:
>
> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_media_device
>
> This document will be the basis of the discussions during the Plumbers
> Conference in two weeks time.

I wasn't following this RFC during the past year, though I heard you 
talking about this idea at LPC 2008.

I will add some things to discussion (see below) I have in my mind 
regarding similar difficulties we face today with some pure-DTV devices.

>From a first look, it seems media controller could not only unify v4l and 
DVB device abstraction layers, but also a missing features to DTV devices 
which are not present right now.

> [..]
>
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
>
> It is good to realize that most applications will just enumerate e.g. capture
> device nodes. Few applications will do a full scan of the whole topology.
> Instead they will just specify the unique entity ID and if needed the
> input/output ID as well. These IDs are declared in the board or sub-device
> specific header.

Very good this topology-idea!

I can even see this to be continued in user-space in a very smart 
application/library: A software MPEG decoder/rescaler whatever would be 
such an entity for example.

> A full enumeration will typically only be done by some sort of generic
> application like v4l2-ctl.

Hmm... I'm seeing this idea covering other stream-oriented devices. Like 
sound-cards (*ouch*).

> [..]
>
> Open issues
> ===========
>
> In no particular order:
>
> 1) How to tell the application that this board uses an audio loopback cable
> to the PC's audio input?
>
> 2) There can be a lot of device nodes in complicated boards. One suggestion
> is to only register them when they are linked to an entity (i.e. can be
> active). Should we do this or not?

Could entities not be completely addressed (configuration ioctls) through 
the mc-node?

Only entities who have an output/input with is of type 
'user-space-interface' are actually having a node where the user (in 
user-space) can read from/write to?

> 3) Format and bus configuration and enumeration. Sub-devices are connected
> together by a bus. These busses can have different configurations that will
> influence the list of possible formats that can be received or sent from
> device nodes. This was always pretty straightforward, but if you have several
> sub-devices such as scalers and colorspace converters in a pipeline then this
> becomes very complex indeed. This is already a problem with soc-camera, but
> that is only the tip of the iceberg.
>
> How to solve this problem is something that requires a lot more thought.

For me the entities (components) you're describing are having 2 basic 
bus-types: one control bus (which gives register access) and one or more 
data-stream buses.

In your topology I understood that the inputs/outputs are exactly 
representing the data-stream buses.

Depending on the main-type of the media controller a library could give 
some basic-models of how all entities can be connected together. EG:

(I have no clue about webcams, that why I use this as an example :) ):

Webcam: sensor + resize + filtering = picture

WEBCAM model X provides:

2 sensor-types + 3 resizers + 5 filters

one of each of it provides a pictures. By default this first one of each 
is taken.

> [..]

My additional comments for DTV

1) In DTV as of today we can't handle a feature which becomes more and 
more important: diversity. There are boards where you have 2 frontends and 
they can either combined their demodulated data to achieve better 
sensitivity when being tuned to the same frequency or they can deliver two 
MPEG2 transport streams when being tuned to 2 different frequencies. With 
the entity topology this problem would be solved, because we have the 
abstraction of possible inputs.

2) What is today a dvb_frontend could become several entities: I'm seeing 
tuner, demodulator, channel-decoder, amplifiers. IMO, we should not 
hesitate to lower the granularity of entities if possible.

I really, really like this approach as it gives flexibily to user-space 
applications which will ultimatetly improve the quality of the supported 
devices, but I think it has to be assisted by a user-space library and the 
access has to be done exclusively by that library. I'm aware that this 
library-idea could be a hot discussion point.

OTOH, in your approach I see nothing which would block an integration of 
DTV-devices in that media-controller-architecture even if it is not done 
in the first development-period.

regards,
--

Patrick 
http://www.kernellabs.com/
