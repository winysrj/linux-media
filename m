Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41071 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283AbcCUSIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 14:08:38 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F038A0.1010004@xs4all.nl>
Date: Mon, 21 Mar 2016 19:08:32 +0100
MIME-Version: 1.0
In-Reply-To: <20160321145034.6fa4e677@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 06:50 PM, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Mon, 21 Mar 2016 17:01:43 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>> A reasonable solution to simplify converting legacy drivers without creating
>>> these global ugly pad indices is to add a new video (and probably audio) op
>>> 'g_pad_of_type(type)' where you ask the subdev entity to return which pad carries
>>> signals of a certain type.  
>>
>> This basically puts a layer between the low-level pads as defined by the entity
>> and the 'meta-pads' that a generic MC link creator would need to handle legacy
>> drivers. The nice thing is that this is wholly inside the kernel so we can
>> modify it at will later without impacting userspace.
> 
> I prepared a long answer to your email, but I guess we're not at the
> same page.
> 
> Let be clear on my view. Please let me know where you disagree:
> 
> 1) I'm not defending Javier's patchset. I have my restrictions to
> it too. My understanding is that he sent this as a RFC for feeding
> our discussions for the media summit.
> 
> Javier, please correct me if I'm wrong.
> 
> 2) I don't understand what you're calling as "meta-pads". For me, a
> PAD is a physical set of pins. 

Poorly worded on my side. I'll elaborate below.

> 3) IMO, the best is to have just one PAD for a decoder input. That makes
> everything simple, yet functional.
> 
> In my view, the input PAD will be linked to several "input connections".
> So, in the case of tvp5150, it will have:
> 
> 	- composite 1
> 	- composite 2
> 	- s-video
> 
> 4) On that view, the input PAD is actually a set of pins. In the
> case of tvp5150, the pins that compose the input PADs are
> AIP1A and AIP1B.
> 
> The output PAD is also a set of pins YOUT0 to YOUT7, plus some other
> pins for sync. Yet, it should, IMHO, have just one output PAD at
> the MC graph.

Indeed. So a tvp5150 has three sink pads and one source pad (pixel port).
Other similar devices may have different numbers of sink pads (say four
composite sinks and no S-Video sinks). So the pads the entity creates
should match what the hardware supports.

So far, so good.

If we want to create code that can more-or-less automatically create a MC
topology for legacy drivers, then we would like to be able to map a high-level
description like 'the first S-Video sink pad' into the actual pad. So you'd
have a 'MAP_PAD_SVID_1' define that, when passed to the g_pad_of_type() op
would return the actual pad index for the first S-Video sink pad (or an error
if there isn't one). That's what I meant with 'meta-pad' (and let's just
forget about that name, poor choice from my side).

What I think Javier's patch did was to require subdevs that have an S-Video pad
to use the DEMOD_PAD_C_INPUT + IF_INPUT pad indices for that. That's really
wrong. The subdev driver decides how many pads there are and which pad is
assigned to which index. That shouldn't be forced on them from the outside
because that won't scale.

But you can make an op that asks 'which pad carries this signal?'. That's fine.

I hope this clarifies matters.

Regards,

	Hans
