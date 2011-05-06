Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:57416 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1EFMRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 08:17:22 -0400
Message-ID: <4DC3E6C7.8040109@linuxtv.org>
Date: Fri, 06 May 2011 14:17:11 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org> <4DC15633.3030300@gmail.com> <4DC166D4.4090408@linuxtv.org> <4DC2B797.3040202@gmail.com>
In-Reply-To: <4DC2B797.3040202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/05/2011 04:43 PM, Martin Vidovic wrote:
> Hi,
> 
> Broadly speaking, I could put issues discussed in this thread into
> following categories:
> 
> - How devices are named;
> - How devices are used;
> - How devices relate to one another;
> - How devices are enumerated;
> - How devices are described;
> 
> Mostly we discuss category 1 and 2 with relation to nGENE CI, but
> sometimes we leap to other categories as well.
> 
> Andreas Oberritter wrote:
>> On 05/04/2011 03:35 PM, Martin Vidovic wrote:
>>>
>>> I think there is currently no useful API to connect devices. Every few
>>> months there comes a new device which deprecates how I enumerate devices
>>> and determine types of FE's.
>>
>> Can you describe the most common problems? What do you mean by
>> connecting?
> 
> What I mean by connecting devices falls into last 3 categories (above).
> I brought this up because I don't believe this is the actual problem we
> need to solve here since it's not nGENE specific.
> 
> Some examples of problems in categories 3-5:
> 
> a) Plug two TerraTec Cinergy T RC MKII and try to distinguish between them.

I don't have any USB or PCI hardware within reach, but if udev is able
to create the devices, there should be some way to connect adapters to
the bus id through sysfs. I guess that's how it's done with other
subsystems, too.

If this information is missing from sysfs, would adding it help to solve
this problem?

> b) Take a Hybrid terrestrial TV tuner. V4L and DVB APIs (may) use shared
> resources, how does one find this out?

That's a good question and the same question must be asked for video and
audio decoders, which can be controlled by V4L, DVB, ALSA etc.

How does V4L integrate with ALSA?

> c.1) How does one know which frontend device can be used with which
> demux device?

I'd say by default (i.e. without DMX_SET_SOURCE, whether implemented or
not) frontendX is connected to demuxX on the same adapter. You have
probably faced other situations. Can you describe any?

> c.2) Which CA device can be used with which frontend device?

For built-in descramblers, I'd say each caX is always connected to
(built into) demuxX.

For CI slots, this might be different and on the Dreambox we're using a
proprietary API to connect CI slots between frontends and demuxes.

Is there any in-tree supported hardware, that has more than one CI slot
*and* more than one frontend (usable at the same time)?

I agree that an API would be nice to query and set up such things, but I
had expected that the need for it was rather low for non-embedded systems.

> d) How does one list all supported delivery systems for a device
> (FE_GET_INFO is not general, and DTV_DELIVERY_SYSTEM can't be used to
> query available delivery systems).

How about this proposal?

http://www.mail-archive.com/linux-media@vger.kernel.org/msg31124.html

> e) the list could be extended...
> 
> These problems are mostly not fatal, they have workarounds. Some of them
> require device/driver specific knowledge.
> 
>>> The most useful way to query devices seems to be using HAL, and I think
>>> this is the correct way in Linux, but DVB-API may be lacking with
>>> providing the necessary information. Maybe this is the direction we
>>> should consider? Device names under /dev seem to be irrelevant nowadays.
>>
>> I think in the long run we should look closely at how V4L2 is solving
>> similar problems.
> 
> The best would be to create independent adapters for each independent CA
> device (ca0/caio0 pair) - they are independent after all (physically and
> in the way they're used).

Physically, it's a general purpose TS I/O interface of the nGene
chipset. It just happens to be connected to a CI slot. On another board,
it might be connected to a modulator or just to some kind of socket.

If the next version gets a connector for two switchable CI modules, then
the physical independence is gone. You'd have two ca nodes but only one
caio node. Or two caio nodes, that can't be used concurrently.

Maybe the next version gets the ability to directly connect the TS input
from the frontend to the TS output to the CI slot to save copying around
the data, by using some kind of pin mux. Not physically independent either.

It just looks physically independent in the one configuration
implemented now.

> What I understand you would like to see, is the ability to do direct
> transfers between independent devices or parts of devices. Is this correct?

Yes, between parts of devices, where the CI input can be fed by both the
TS output of the frontend and from memory (e.g. userspace).

Although it would be nice to have DMA transfers between independent
devices, that's a different topic.

Regards,
Andreas
