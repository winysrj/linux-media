Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:56708 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1EHR7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 13:59:04 -0400
Message-ID: <4DC6D9E2.7020100@linuxtv.org>
Date: Sun, 08 May 2011 19:58:58 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org> <4DC15633.3030300@gmail.com> <4DC166D4.4090408@linuxtv.org> <4DC2B797.3040202@gmail.com> <4DC3E6C7.8040109@linuxtv.org> <4DC66B03.5080709@gmail.com>
In-Reply-To: <4DC66B03.5080709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Martin,

On 05/08/2011 12:05 PM, Martin Vidovic wrote:
> Andreas Oberritter wrote:
>> On 05/05/2011 04:43 PM, Martin Vidovic wrote:
>>>
>>> a) Plug two TerraTec Cinergy T RC MKII and try to distinguish between
>>> them.
>>
>> I don't have any USB or PCI hardware within reach, but if udev is able
>> to create the devices, there should be some way to connect adapters to
>> the bus id through sysfs. I guess that's how it's done with other
>> subsystems, too.
>>
>> If this information is missing from sysfs, would adding it help to solve
>> this problem?
>>
> 
> Binding to bus id is not a problem. However, especially for USB devices,
> it may be useful to have adapter MAC address in sysfs.

a DVB adapter isn't required to have a unique MAC address, but we could
add this attribute to sysfs, if present. I think it would be preferrable
to use information available from the bus, e.g. the USB serial number.
But in cases, where the serial number is unavailable (probably quite
often), the MAC address might be a good fallback. It won't be available
in every case though.

>>> b) Take a Hybrid terrestrial TV tuner. V4L and DVB APIs (may) use shared
>>> resources, how does one find this out?
>>
>> That's a good question and the same question must be asked for video and
>> audio decoders, which can be controlled by V4L, DVB, ALSA etc.
>>
>> How does V4L integrate with ALSA?
>>
> 
> I don't know.
> 
>>> c.1) How does one know which frontend device can be used with which
>>> demux device?
>>
>> I'd say by default (i.e. without DMX_SET_SOURCE, whether implemented or
>> not) frontendX is connected to demuxX on the same adapter. You have
>> probably faced other situations. Can you describe any?
>>
> 
> I thought we were discussing how to connect frontendX to demuxY on
> different adapters, since this would be needed for nGene CI.

Such connections between adapters are impossible, API-wise. Each adapter
is an independent circuit by definition.

>>> c.2) Which CA device can be used with which frontend device?
>>
>> For built-in descramblers, I'd say each caX is always connected to
>> (built into) demuxX.
>>
>> For CI slots, this might be different and on the Dreambox we're using a
>> proprietary API to connect CI slots between frontends and demuxes.
>>
>> Is there any in-tree supported hardware, that has more than one CI slot
>> *and* more than one frontend (usable at the same time)?
>>
> 
> NetUP Dual DVB S2 CI

Nice. Is it possible to assign a CI slot to a frontend by means of
software with this card? Or does it appear as two independent circuits
on one board?

>>>
>>> The best would be to create independent adapters for each independent CA
>>> device (ca0/caio0 pair) - they are independent after all (physically and
>>> in the way they're used).
>>
>> Physically, it's a general purpose TS I/O interface of the nGene
>> chipset. It just happens to be connected to a CI slot. On another board,
>> it might be connected to a modulator or just to some kind of socket.
>>
> 
> I agree, but I look at it like at any other general purpose interface
> (e.g. USB, PCI).
> 
> Maybe nGene is not a good case for such analysis, but there is other
> hardware which would hit this problem again.
> 
> I'm aware of two such examples:
> 
> 1) Hauppauge WinTV-CI (USB attached CI - I think Issa mentioned this one
> already);
> 2) DigitalDevices Octopus (PCI bridge with 4 general purpose ports - Ralph
> mentioned this one and I'm using these cards myself);
> 
>> If the next version gets a connector for two switchable CI modules, then
>> the physical independence is gone. You'd have two ca nodes but only one
>> caio node. Or two caio nodes, that can't be used concurrently.
>>
> 
> What is a switchable CI module?

Sorry, I meant two normal CI modules and the ability to switch between
them, i.e. to only use one of them at a time.

>> Maybe the next version gets the ability to directly connect the TS input
>> from the frontend to the TS output to the CI slot to save copying around
>> the data, by using some kind of pin mux. Not physically independent
>> either.
>>
> 
> When this feature would be in action, opening caioX could return EBUSY
> and vice versa. This sounds similar to V4L <-> DVB interaction for hybrid
> devices. API can't change the fact a resource is shared.

Indeed. However, what I was trying to explain with this example was,
that such a shared resource isn't physically independent and thus has to
appear under the same adapter number as the other parts of the circuit
it resides on.

>> It just looks physically independent in the one configuration
>> implemented now.
>>
> 
> I don't believe it's an accident how nGene cards interface with CI. To
> me it rather looks like a very good feature.
> 
> Imagine a use case like this:
> 
> There's a machine with:
> - DigitalDevices CineS2

(adapter0)

> - CI-Module attached to CineS2;

(adapter0/{ca0,caio0})

> - TechniSat SkyStar2 (has no CI);

(adapter1)

> A user wants to stream two DVB-S2 transponders using CineS2. They are
> both clear, so CI-Module is not needed.
> 
> At the same time, the user wants to stream one DVB-S transponder but it is
> scrambled. Since CI-Module attached to CineS2 is not in use, it can be
> made to work with SkyStar2 using a few lines of code in user space.

You're right, absolutely. This can of course still be done if ca0 and
caio0 reside on adapter0, even if adapter0 also contains frontends,
demuxes and stuff.

>>> What I understand you would like to see, is the ability to do direct
>>> transfers between independent devices or parts of devices. Is this
>>> correct?
>>
>> Yes, between parts of devices, where the CI input can be fed by both the
>> TS output of the frontend and from memory (e.g. userspace).
>>
> 
> I don't know Demux API so well to be able to tell for sure, but it looks
> like it could be used (with a few extensions) instead of caioX.
> 
> One benefit of using Demux API would probably be the ability to have PID
> filtering (in software or hardware), I think you've mentioned this already.
> It is also similar to the way on-board decoder can be used on full-featured
> cards.
> 
> This way both cases (nGene and your configurable design) could be covered.

I think so, too.

> On the other hand, using Demux API for nGene looks like an overkill, and
> switching of TS route in your case could be done in some other way.
> Specific HW design related problems seem to be common to both approaches.
> 
> Nevertheless, Demux API approach looks cleaner. But on the other hand, it
> hides the fact that CI can be used in this particular way (sysfs could
> help).

In most applications you'll want the PID filtering at the CI's output
anyway, so you can use the decrypted stream the same way you'd use it
without the CI. In other words, every physical TS input of the chipset
(in this case: nGene) should get its own demux interface, e.g. demux0
and demux1 for the frontends, demux2 for the CI.

Whatever we'll agree on, we should define an interface to query the
possible inputs and outputs of a demux, be it by means of sysfs or
ioctls. This would also be useful to find out which demux can be used
with DMX_OUT_DECODER for full-featured cards.

We can add DMX_OUT_CI, DMX_IN_CI, DMX_SOURCE_CI{0,1,2,3...} to the enums
in dmx.h. Ideally, in addition to that, I'd prefer dividing descramblers
and CIs into ca and ci device nodes, as proposed some days ago.

I think an ioctl to enable bypassing the PID filter when writing to the
CI would help to decrease the amount of overkill.

> I imagine there would still be a difference between the two cases:
> 
> - nGene (CineS2 with CI-Module)
> 
> Device nodes would be:
> 
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/demux0
> /dev/dvb/adapter0/dvr0
> 
> /dev/dvb/adapter1/frontend0
> /dev/dvb/adapter1/demux0
> /dev/dvb/adapter1/dvr0
> 
> /dev/dvb/adapter2/ca0
> /dev/dvb/adapter2/demux0
> /dev/dvb/adapter2/dvr0

IMO, this should be:

/dev/dvb/adapter0/ca0 (or better: ci0)
/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/demux1
/dev/dvb/adapter0/demux2
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/dvr1
/dev/dvb/adapter0/dvr2
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/frontend1

(assuming 3 TS inputs)

> - Configurable Design (dual card similar to NetUP)
> 
> Device nodes would be:
> 
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/demux0
> /dev/dvb/adapter0/dvr0
> /dev/dvb/adapter0/ca0
> 
> /dev/dvb/adapter1/frontend0
> /dev/dvb/adapter1/demux0
> /dev/dvb/adapter1/dvr0
> /dev/dvb/adapter1/ca0

and

/dev/dvb/adapter0/ca0 (or better: ci0)
/dev/dvb/adapter0/ca1 (or better: ci1)
/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/demux1
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/dvr1
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/frontend1

(assuming 2 TS inputs and a way to map a CI to a frontend)

or your suggestion for NetUP, assuming fixed relations between CI slots
and frontends.

> What do you say about this difference?

Different capabilities result in different nodes. I don't see anything
special about it.

Regards,
Andreas
