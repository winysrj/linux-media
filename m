Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50267 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932545AbcCUTbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 15:31:04 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
 <56F038A0.1010004@xs4all.nl> <56F03C40.4090909@osg.samsung.com>
 <56F0461A.1070809@xs4all.nl> <56F04969.6070908@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F04BF3.2000006@xs4all.nl>
Date: Mon, 21 Mar 2016 20:30:59 +0100
MIME-Version: 1.0
In-Reply-To: <56F04969.6070908@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 08:20 PM, Javier Martinez Canillas wrote:
> Hello Hans,
> 
> On 03/21/2016 04:06 PM, Hans Verkuil wrote:
>> On 03/21/2016 07:24 PM, Javier Martinez Canillas wrote:
>>> Hello Hans,
>>>
>>> On 03/21/2016 03:08 PM, Hans Verkuil wrote:
>>>> On 03/21/2016 06:50 PM, Mauro Carvalho Chehab wrote:
>>>>> Hi Hans,
>>>>>
>>>>> Em Mon, 21 Mar 2016 17:01:43 +0100
>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>>
>>>>>>> A reasonable solution to simplify converting legacy drivers without creating
>>>>>>> these global ugly pad indices is to add a new video (and probably audio) op
>>>>>>> 'g_pad_of_type(type)' where you ask the subdev entity to return which pad carries
>>>>>>> signals of a certain type.  
>>>>>>
>>>>>> This basically puts a layer between the low-level pads as defined by the entity
>>>>>> and the 'meta-pads' that a generic MC link creator would need to handle legacy
>>>>>> drivers. The nice thing is that this is wholly inside the kernel so we can
>>>>>> modify it at will later without impacting userspace.
>>>>>
>>>>> I prepared a long answer to your email, but I guess we're not at the
>>>>> same page.
>>>>>
>>>>> Let be clear on my view. Please let me know where you disagree:
>>>>>
>>>>> 1) I'm not defending Javier's patchset. I have my restrictions to
>>>>> it too. My understanding is that he sent this as a RFC for feeding
>>>>> our discussions for the media summit.
>>>>>
>>>>> Javier, please correct me if I'm wrong.
>>>>>
>>>
>>> That's correct. I wanted to have some patches that were aligned to what
>>> were discussed so far in order to have more examples to contribute in
>>> the media summit discussion (since I won't be there).
>>>
>>> The patches are RFC and not meant to upstream since there are too many
>>> open questions. I just hoped that having more examples could help of
>>> them. I was specially interested in the DT bindings using OF graph to
>>> lookup the connectors and the level of detail there.
>>>
>>>>> 2) I don't understand what you're calling as "meta-pads". For me, a
>>>>> PAD is a physical set of pins. 
>>>>
>>>> Poorly worded on my side. I'll elaborate below.
>>>>
>>>>> 3) IMO, the best is to have just one PAD for a decoder input. That makes
>>>>> everything simple, yet functional.
>>>>>
>>>>> In my view, the input PAD will be linked to several "input connections".
>>>>> So, in the case of tvp5150, it will have:
>>>>>
>>>>> 	- composite 1
>>>>> 	- composite 2
>>>>> 	- s-video
>>>>>
>>>>> 4) On that view, the input PAD is actually a set of pins. In the
>>>>> case of tvp5150, the pins that compose the input PADs are
>>>>> AIP1A and AIP1B.
>>>>>
>>>>> The output PAD is also a set of pins YOUT0 to YOUT7, plus some other
>>>>> pins for sync. Yet, it should, IMHO, have just one output PAD at
>>>>> the MC graph.
>>>>
>>>> Indeed. So a tvp5150 has three sink pads and one source pad (pixel port).
>>>
>>> Why 3 sink pads? Are we going to model each possible connection as a PAD
>>> instead of an entity or are you talking about physical pins? Because if
>>> is the latter, then the tvp5150 has only 2 (Composite1 shares S-Video Y
>>> and Composite2 shares C signal).
>>
>> I'd go with Mauro's proposal of a single pad. And I didn't look into detail
>> in the hardware specs of the tvp5150, so that's why I got it wrong.
>>
> 
> Ok.
> 
>>>> Other similar devices may have different numbers of sink pads (say four
>>>> composite sinks and no S-Video sinks). So the pads the entity creates
>>>> should match what the hardware supports.
>>>>
>>>> So far, so good.
>>>>
>>>
>>> I'm confused. I thought that the latest agreed approach was to model the
>>> actual connection signals and input pins as PADs instead of a simplied
>>> model that just each connection as a sink.
>>
>> My opinion is to just use the simple option (one pad) if you can get away
>> with it. I.e. in this case adding more sink pads doesn't add any useful
>> information. In the case of an adv7604 it does provide useful information since
>> you need to program the adv7604 based on how it is hooked up.
>>
> 
> Agreed.
>  
>> BTW, if the tvp5150 needs to know which composite connector is connected
>> to which hardware pin, then you still may need to be explicit w.r.t. the
>> number of pads. I just thought of that.
>>
> 
> The tvp5150 doesn't care about that, as Mauro said is just a mux so you can
> have logic in the .link_setup that does the mux depending on the remote
> entity (that's in fact how I implemented and is currently in mainline).
> 
> Now, the user needs to know which entity is mapped to which input pin.
> All its know from the HW documentation is that for example the left
> RCA connector is AIP1A and the one inf the right is connected to AIP1B.
> 
> So there could be a convention that the composite connected to AIP1A pin
> (the default) is Composite0 and the connected to AIP1B is Composite1.
> 
>>>> If we want to create code that can more-or-less automatically create a MC
>>>> topology for legacy drivers, then we would like to be able to map a high-level
>>>> description like 'the first S-Video sink pad' into the actual pad. So you'd
>>>> have a 'MAP_PAD_SVID_1' define that, when passed to the g_pad_of_type() op
>>>> would return the actual pad index for the first S-Video sink pad (or an error
>>>> if there isn't one). That's what I meant with 'meta-pad' (and let's just
>>>> forget about that name, poor choice from my side).
>>>>
>>>
>>> Can you please provide an example of a media pipeline that user-space should
>>> use with this approach? AFAICT whatever PADs are created when initiliazing
>>> the PADs for an entity, will be exposed to user-space in the media graph.
>>>
>>> So I'm not understading how it will be used in practice. I don't mean that
>>> your approach is not correct, is just I'm not getting it :)
>>
>> Why would userspace need to use the pads? This is for legacy drivers (right?)
>> where the pipeline is fixed anyway.
>>
> 
> I asked because the user needs to setup the links in the media pipeline to
> choose  which input connection will be linked to the tvp5150 decoder. But it
> doesn't matter if we are going with the single sink pad approach since the
> user will always do something like:

Why? The user will use an application that uses ENUM/S/G_INPUT for this. We're
talking legacy drivers ('interface centric drivers' would be a better description)
where we don't even expose the v4l-subdevX device nodes. Explicitly programming
a media pipeline is something you do for complex devices (embedded systems and
the like). Not for simple and generally fixed pipelines. Utterly pointless.

> 
> $ media-ctl -r -l '"Composite0":0->"tvp5150 1-005c":0[1]'
> 
> IOW, there will always choose the only connection source pad and tvp5150 sink.
> 
> There will be two source pads for the tvp5150 though, 1 for video and other
> for VBI. But I guess this is not an issue since that's easier to standardize.

Not all devices have VBI. Some devices may have *only* VBI (although the last
driver of that kind was removed from the kernel a long time ago), there may
be multiple video source pads, and when we add HDMI I can think of a lot more
complex scenarios. So source pads shouldn't have their pad indices imposed on
them by outside 'arrangements'. It is really the wrong approach, regardless of
whether we talk about sink or source pads.

Regards,

	Hans
