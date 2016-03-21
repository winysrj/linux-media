Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55253 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbcCUSYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 14:24:11 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
 <56F038A0.1010004@xs4all.nl>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F03C40.4090909@osg.samsung.com>
Date: Mon, 21 Mar 2016 15:24:00 -0300
MIME-Version: 1.0
In-Reply-To: <56F038A0.1010004@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 03/21/2016 03:08 PM, Hans Verkuil wrote:
> On 03/21/2016 06:50 PM, Mauro Carvalho Chehab wrote:
>> Hi Hans,
>>
>> Em Mon, 21 Mar 2016 17:01:43 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>>> A reasonable solution to simplify converting legacy drivers without creating
>>>> these global ugly pad indices is to add a new video (and probably audio) op
>>>> 'g_pad_of_type(type)' where you ask the subdev entity to return which pad carries
>>>> signals of a certain type.  
>>>
>>> This basically puts a layer between the low-level pads as defined by the entity
>>> and the 'meta-pads' that a generic MC link creator would need to handle legacy
>>> drivers. The nice thing is that this is wholly inside the kernel so we can
>>> modify it at will later without impacting userspace.
>>
>> I prepared a long answer to your email, but I guess we're not at the
>> same page.
>>
>> Let be clear on my view. Please let me know where you disagree:
>>
>> 1) I'm not defending Javier's patchset. I have my restrictions to
>> it too. My understanding is that he sent this as a RFC for feeding
>> our discussions for the media summit.
>>
>> Javier, please correct me if I'm wrong.
>>

That's correct. I wanted to have some patches that were aligned to what
were discussed so far in order to have more examples to contribute in
the media summit discussion (since I won't be there).

The patches are RFC and not meant to upstream since there are too many
open questions. I just hoped that having more examples could help of
them. I was specially interested in the DT bindings using OF graph to
lookup the connectors and the level of detail there.

>> 2) I don't understand what you're calling as "meta-pads". For me, a
>> PAD is a physical set of pins. 
> 
> Poorly worded on my side. I'll elaborate below.
> 
>> 3) IMO, the best is to have just one PAD for a decoder input. That makes
>> everything simple, yet functional.
>>
>> In my view, the input PAD will be linked to several "input connections".
>> So, in the case of tvp5150, it will have:
>>
>> 	- composite 1
>> 	- composite 2
>> 	- s-video
>>
>> 4) On that view, the input PAD is actually a set of pins. In the
>> case of tvp5150, the pins that compose the input PADs are
>> AIP1A and AIP1B.
>>
>> The output PAD is also a set of pins YOUT0 to YOUT7, plus some other
>> pins for sync. Yet, it should, IMHO, have just one output PAD at
>> the MC graph.
> 
> Indeed. So a tvp5150 has three sink pads and one source pad (pixel port).

Why 3 sink pads? Are we going to model each possible connection as a PAD
instead of an entity or are you talking about physical pins? Because if
is the latter, then the tvp5150 has only 2 (Composite1 shares S-Video Y
and Composite2 shares C signal).

> Other similar devices may have different numbers of sink pads (say four
> composite sinks and no S-Video sinks). So the pads the entity creates
> should match what the hardware supports.
> 
> So far, so good.
>

I'm confused. I thought that the latest agreed approach was to model the
actual connection signals and input pins as PADs instead of a simplied
model that just each connection as a sink.
 
> If we want to create code that can more-or-less automatically create a MC
> topology for legacy drivers, then we would like to be able to map a high-level
> description like 'the first S-Video sink pad' into the actual pad. So you'd
> have a 'MAP_PAD_SVID_1' define that, when passed to the g_pad_of_type() op
> would return the actual pad index for the first S-Video sink pad (or an error
> if there isn't one). That's what I meant with 'meta-pad' (and let's just
> forget about that name, poor choice from my side).
>

Can you please provide an example of a media pipeline that user-space should
use with this approach? AFAICT whatever PADs are created when initiliazing
the PADs for an entity, will be exposed to user-space in the media graph.

So I'm not understading how it will be used in practice. I don't mean that
your approach is not correct, is just I'm not getting it :)

> What I think Javier's patch did was to require subdevs that have an S-Video pad
> to use the DEMOD_PAD_C_INPUT + IF_INPUT pad indices for that. That's really
> wrong. The subdev driver decides how many pads there are and which pad is
> assigned to which index. That shouldn't be forced on them from the outside
> because that won't scale.
>

Yes, that was something that Mauro suggested in [0] as a possible approach
but I also was not sure about it and mentioned in the patch comments.

> But you can make an op that asks 'which pad carries this signal?'. That's fine.
>
> I hope this clarifies matters.
> 
> Regards,
> 
> 	Hans
> 

[0]: http://www.spinics.net/lists/linux-media/msg98042.html

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
