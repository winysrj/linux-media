Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2836 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZIJPAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 11:00:38 -0400
Message-ID: <2830b427fef295eeb166dbd2065392ce.squirrel@webmail.xs4all.nl>
In-Reply-To: <alpine.LRH.1.10.0909101604280.5940@pub3.ifh.de>
References: <200909100913.09065.hverkuil@xs4all.nl>
    <alpine.LRH.1.10.0909101001390.5940@pub3.ifh.de>
    <1ceb929cb176ac6272ff94a6dcd47b6d.squirrel@webmail.xs4all.nl>
    <alpine.LRH.1.10.0909101604280.5940@pub3.ifh.de>
Date: Thu, 10 Sep 2009 17:00:40 +0200
Subject: Re: RFCv2: Media controller proposal
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Patrick Boettcher" <pboettcher@kernellabs.com>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, 10 Sep 2009, Hans Verkuil wrote:
>> Now that this is in we can continue with the next phase and actually
>> think
>> on how it should be implemented.
>
> Sounds logic.
>
>>> Hmm... I'm seeing this idea covering other stream-oriented devices.
>>> Like
>>> sound-cards (*ouch*).
>>
>> I may be mistaken, but I don't believe soundcards have this same
>> complexity are media board.
>
> When I launch alsa-mixer I see 4 input devices where I can select 4
> difference sources. This gives 16 combinations which is enough for me to
> call it 'complex' .
>
>>> Could entities not be completely addressed (configuration ioctls)
>>> through
>>> the mc-node?
>>
>> Not sure what you mean.
>
> Instead of having a device node for each entity, the ioctls for each
> entities are done on the media controller-node address an entity by ID.

I definitely don't want to go there. Use device nodes (video, fb, alsa,
dvb, etc) for streaming the actual media as we always did and use the
media controller for controlling the board. It keeps everything nicely
separate and clean.

>
>>> Only entities who have an output/input with is of type
>>> 'user-space-interface' are actually having a node where the user (in
>>> user-space) can read from/write to?
>>
>> Yes, each device node (i.e. that can be read from or written to) is
>> represented by an entity. That makes sense as well, since there usually
>> is
>> a DMA engine associated with this, which definitely qualifies as
>> something
>> more than 'just' an input or output from some other block. You may even
>> want to control this in someway through the media controller (setting up
>> DMA parameters?).
>>
>> Inputs and outputs are not meant to represent anything complex. They
>> just
>> represent pins or busses.
>
> Or DMA-engines.
>
> When I say bus I meant something which transfer data from a to b, so a bus
> covers DMA engines. Thus a DMA engine or a real bus represents a
> connection of an output and an input.

Not quite: a DMA engine transfers the media to or from memory over some
bus. The crucial bit is 'memory'. Anyway, device nodes is where an
application can finally get hold of the data and you need a way to tell
the app where to find those devices and what properties they have. And
that's what a device node entity does.

>
>> Not really a datastream bus, more the DMA engine (or something similar)
>> associated with a datastream bus. It's really the place where data is
>> passed to/from userspace. I.e. the bus between a sensor and a resizer is
>> not an entity. It's probably what you meant in any case.
>
> Yes.
>
>>> 2) What is today a dvb_frontend could become several entities: I'm
>>> seeing
>>> tuner, demodulator, channel-decoder, amplifiers.
>>
>> In practice every i2c device will be an entity. If the main bridge IC
>> contains integrated tuners, demods, etc., then the driver can divide
>> them
>> up in sub-devices at will.
>>
>> I have actually thought of sub-sub-devices. Some i2c devices can be
>> very,
>> very complex. It's possible to do and we should probably allow for this
>> to
>> happen in the future. Although we shouldn't implement this initially.
>
> Yes, for me i2c-bus-client-device is not necessarily one media_subdevice.

It is currently, but I agree, that's something that we may want to make
more generic in the future.

>
> Even the term i2c is not terminal. Meaning that more and more devices will
> use SPI or SDIO or other busses for communication between components in
> the future. Or at least there will be some.

That's no problem, v4l2_subdev is bus-agnostic.

>
> Also: If we sub-bus is implemented as a subdev other devices are attached
> to that bus can be normal subdevs.
>
> Why is it important to have all devices on one bus? Because of the
> propagation of ioctl? If so, the sub-bus-subdev from above can simply
> forward the ioctls on its bus to it's attached subdevs. No need of
> sub-sub-devs ;) .

Sub-devices are registered with the v4l2_device. And that's really all you
need. In the end it is a design issue how many sub-devices you create.

>
>>> I really, really like this approach as it gives flexibily to user-space
>>> applications which will ultimatetly improve the quality of the
>>> supported
>>> devices, but I think it has to be assisted by a user-space library and
>>> the
>>> access has to be done exclusively by that library. I'm aware that this
>>> library-idea could be a hot discussion point.
>>
>> I do not see how you can make any generic library for this. You can make
>> libraries for each specific board (I'm talking SoCs here mostly) that
>> provide a slightly higher level of abstraction, but making something
>> generic? I don't see how. You could perhaps do something for specific
>> use-cases, though.
>
> Not a 100% generic library, but a library which has some models inside for
> different types of media controllers. Of course the model of a webcam is
> different as the model of a DTV-device.
>
> Maybe model is not the right word, let's call it template. A template
> defines a possible chain of certain types of entities which provide
> a media-stream at their output.

That might work, yes.

>> I would love to see that happen. But then dvb should first migrate to
>> the
>> standard i2c API, and then integrate that into v4l2_subdev (by that time
>> we should probably rename it to media_subdev).
>>
>> Not a trivial job, but it would truly integrate the two parts.
>
> As you state in your initial approach, existing APIs are not broken, so
> it's all about future development.

Yup!

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

