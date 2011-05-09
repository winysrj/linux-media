Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:58811 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1EILou (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 07:44:50 -0400
Message-ID: <4DC7D3AD.5000504@linuxtv.org>
Date: Mon, 09 May 2011 13:44:45 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org> <4DC15633.3030300@gmail.com> <4DC166D4.4090408@linuxtv.org> <4DC2B797.3040202@gmail.com> <4DC3E6C7.8040109@linuxtv.org> <4DC66B03.5080709@gmail.com> <4DC6D9E2.7020100@linuxtv.org> <4DC72D83.1000001@gmail.com>
In-Reply-To: <4DC72D83.1000001@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/09/2011 01:55 AM, Martin Vidovic wrote:
> Hi Andreas,
> 
> Andreas Oberritter wrote:
>> Hello Martin,
>>
>>>
>>> Binding to bus id is not a problem. However, especially for USB devices,
>>> it may be useful to have adapter MAC address in sysfs.
>>
>> a DVB adapter isn't required to have a unique MAC address, but we could
>> add this attribute to sysfs, if present. I think it would be preferrable
>> to use information available from the bus, e.g. the USB serial number.
>> But in cases, where the serial number is unavailable (probably quite
>> often), the MAC address might be a good fallback. It won't be available
>> in every case though.
>>
> 
> I'm aware MAC is not required. I used the TerraTec example because the
> USB serial numbers are the same for both devices (maybe only in my case).
> 
>>>>> c.1) How does one know which frontend device can be used with which
>>>>> demux device?
>>>>
>>>> I'd say by default (i.e. without DMX_SET_SOURCE, whether implemented or
>>>> not) frontendX is connected to demuxX on the same adapter. You have
>>>> probably faced other situations. Can you describe any?
>>>>
>>>
>>> I thought we were discussing how to connect frontendX to demuxY on
>>> different adapters, since this would be needed for nGene CI.
>>
>> Such connections between adapters are impossible, API-wise. Each adapter
>> is an independent circuit by definition.
>>
> 
> I'm using a different definition of DVB adapter:
> 
> DVB adapter is a collection of related DVB device nodes which can be
> used independently from (without side effects for) other DVB device
> nodes in the system.

I'd agree if you'd modify your definition to read "which can *only* be
used independently from [...] other DVB devices nodes [...]".

frontendX and demuxY of different adapters simply can't be both
independent from each other and connected to each other at the same time.

>>> NetUP Dual DVB S2 CI
>>
>> Nice. Is it possible to assign a CI slot to a frontend by means of
>> software with this card? Or does it appear as two independent circuits
>> on one board?
>>
> 
> The latter.
> 
>>>> If the next version gets a connector for two switchable CI modules,
>>>> then
>>>> the physical independence is gone. You'd have two ca nodes but only one
>>>> caio node. Or two caio nodes, that can't be used concurrently.
>>>>
>>>
>>> What is a switchable CI module?
>>
>> Sorry, I meant two normal CI modules and the ability to switch between
>> them, i.e. to only use one of them at a time.
>>
> 
> It looks like an odd HW design, but it can make sense for certain use
> cases. I think this would call for some different API extension, because
> there's effectively only one CI bus, but the SW would need to be able
> to bind a certain physical CI bus to this logical bus.
> 
>>>> Maybe the next version gets the ability to directly connect the TS
>>>> input
>>>> from the frontend to the TS output to the CI slot to save copying
>>>> around
>>>> the data, by using some kind of pin mux. Not physically independent
>>>> either.
>>>>
>>>
>>> When this feature would be in action, opening caioX could return EBUSY
>>> and vice versa. This sounds similar to V4L <-> DVB interaction for
>>> hybrid
>>> devices. API can't change the fact a resource is shared.
>>
>> Indeed. However, what I was trying to explain with this example was,
>> that such a shared resource isn't physically independent and thus has to
>> appear under the same adapter number as the other parts of the circuit
>> it resides on.
>>
> 
> How about this device: TeVii S480
> 
> This board integrates a USB controller and two TeVii S660 devices on
> a single PCIe card. Why would a driver be required to handle this
> situation any differently than having two actual S660's attached to a
> USB controller sitting on PCI?

I think my statement was mistakable. By independent circuits I was
covering only the data reception path. Of course, multiple circuits may
share the same board and thus be connected to each other somehow, e.g.
sharing a PCIe bridge. Still they appear to be independent to the user,
because the components used in the individual paths can not be shared
(reordered or interconnected by software).

>>>> It just looks physically independent in the one configuration
>>>> implemented now.
>>>>
>>>
>>> I don't believe it's an accident how nGene cards interface with CI. To
>>> me it rather looks like a very good feature.
>>>
>>> Imagine a use case like this:
>>>
>>> There's a machine with:
>>> - DigitalDevices CineS2
>>
>> (adapter0)
>>
>>> - CI-Module attached to CineS2;
>>
>> (adapter0/{ca0,caio0})
>>
>>> - TechniSat SkyStar2 (has no CI);
>>
>> (adapter1)
>>
>>> A user wants to stream two DVB-S2 transponders using CineS2. They are
>>> both clear, so CI-Module is not needed.
>>>
>>> At the same time, the user wants to stream one DVB-S transponder but
>>> it is
>>> scrambled. Since CI-Module attached to CineS2 is not in use, it can be
>>> made to work with SkyStar2 using a few lines of code in user space.
>>
>> You're right, absolutely. This can of course still be done if ca0 and
>> caio0 reside on adapter0, even if adapter0 also contains frontends,
>> demuxes and stuff.
>>
> 
> I agree, but I don't use udev for DVB/V4L, so on my systems they will
> not reside on the same logical adapter.

The way devices are named in userspace (by udev or anything else) on
your system doesn't matter at all. Upon device registration,
dvb_register_device gets called with an adapter passed as a parameter.
This creates the logical association between device node and adapter
we're discussing. The default scheme used by udev just happens to
display this association 1:1.

>>> I don't know Demux API so well to be able to tell for sure, but it looks
>>> like it could be used (with a few extensions) instead of caioX.
>>>
>>> One benefit of using Demux API would probably be the ability to have PID
>>> filtering (in software or hardware), I think you've mentioned this
>>> already.
>>> It is also similar to the way on-board decoder can be used on
>>> full-featured
>>> cards.
>>>
>>> This way both cases (nGene and your configurable design) could be
>>> covered.
>>
>> I think so, too.
>>
>>> On the other hand, using Demux API for nGene looks like an overkill, and
>>> switching of TS route in your case could be done in some other way.
>>> Specific HW design related problems seem to be common to both
>>> approaches.
>>>
>>> Nevertheless, Demux API approach looks cleaner. But on the other
>>> hand, it
>>> hides the fact that CI can be used in this particular way (sysfs could
>>> help).
>>
>> In most applications you'll want the PID filtering at the CI's output
>> anyway, so you can use the decrypted stream the same way you'd use it
>> without the CI. In other words, every physical TS input of the chipset
>> (in this case: nGene) should get its own demux interface, e.g. demux0
>> and demux1 for the frontends, demux2 for the CI.
>>
> 
> PID filtering on CI's output makes sense. However, I'm not sure if it
> really presents a significant benefit for most applications.

Otherwise, the application needs to implement a PID filter by itself.

> I'm also not sure every TS port needs a demux device. DVB API
> documentation says a demux should allow multiple sessions and it should
> be possible to configure the same demux device to use different inputs
> &| outputs (the enums) for individual sessions.

Is this really documented somewhere that way? I'm asking, because it
won't work. Think about the dvr device, for example. You really need a
dvr device for each concurrent TS input, but dvr devices are implicitly
bound to demux devices with the same number. I'm not a big fan of the
dvr device, but it's already there and used by many applications.

>> Whatever we'll agree on, we should define an interface to query the
>> possible inputs and outputs of a demux, be it by means of sysfs or
>> ioctls. This would also be useful to find out which demux can be used
>> with DMX_OUT_DECODER for full-featured cards.
>>
> 
> My view of sysfs vs. ioctl: I think both should provide equivalent
> infrastructure for querying device capabilities. Sometimes it is
> necessary to know what kind of device I'm dealing with at the time
> of device node creation or later at device enumeration.
> 
> How do you know which device is S2, T, C (or something else) without
> resorting to ioctl's?

Exporting some data to userspace through sysfs would be nice, indeed.
Having to open a frontend node, and thus causing a lengthy firmware
upload for many of the newer demods, sucks if you just want to find out
the supported delivery system(s).

>> We can add DMX_OUT_CI, DMX_IN_CI, DMX_SOURCE_CI{0,1,2,3...} to the enums
>> in dmx.h. Ideally, in addition to that, I'd prefer dividing descramblers
>> and CIs into ca and ci device nodes, as proposed some days ago.
>>
> 
> I've had a few thoughts before and after writing the last email.
> 
> One is: It looks to me like ASI cards would require a similar interface,
> and this makes enums somewhat unattractive (maybe only at first sight).
> 
> The other: DVR device looks sort of tailored for the on-board decoder.
> So, it may make more sense if we add CAIO to Demux API. Both dvrX and
> caioX would be configured using ioctl's on demux0.

demuxX instead of demux0. Writing to dvr just feeds a TS to the demux.
It may be used with a decoder, but doesn't necessarily have to.

We can influence the behaviour of the dvr device (or of the demux
device) by adding an ioctl to disable the TS parser.

> Rough examples:
> 
> Assume:
> 
> typedef enum
> {
>     DMX_OUT_DECODER,
>     DMX_OUT_CI,
>     DMX_OUT_TAP,
>     DMX_OUT_TS_TAP
> } dmx_output_t;
> 
> typedef enum
> {
>     DMX_IN_FRONTEND,
>     DMX_IN_CI,
>     DMX_IN_DVR,
>     DMX_IN_CAIO
> } dmx_input_t;
> 
> Then:
> 
> - Equivalent of status quo (secX/caioX):
> 
>     1. open demux0 and set:
> 
>     dmx_pes_filter_params {
>         pid: 0x2000,
>         input: DMX_IN_FRONTEND,
>         output: DMX_OUT_TAP,
>         pes_type: DMX_PES_OTHER,
>         flags: DMX_IMMEDIATE_START
>     }
> 
>     2. open demux0 and set:
> 
>     dmx_pes_filter_params {
>         pid: 0x2000,
>         input: DMX_IN_CAIO,
>         output: DMX_OUT_CI,
>         pes_type: DMX_PES_OTHER,
>         flags: DMX_IMMEDIATE_START
>     }

You're using DMX_IN_CAIO to pass raw data (in this case an unfiltered
TS) to any output (in this case to a CI). This invalidates the reason to
call it "caio" in the first place.

>     3. open demux0 and set:
> 
>     dmx_pes_filter_params {
>         pid: 0x2000,
>         input: DMX_IN_CI,
>         output: DMX_OUT_TAP, // or DMX_OUT_TS_TAP
>         pes_type: DMX_PES_OTHER,
>         flags: DMX_IMMEDIATE_START
>     }
> 
> - HW/SW (in-kernel) TS passing:
> 
>     1. open demux0 and set:
> 
>     dmx_pes_filter_params {
>         pid: 0x2000,
>         input: DMX_IN_FRONTEND,
>         output: DMX_OUT_CI,
>         pes_type: DMX_PES_OTHER,
>         flags: DMX_IMMEDIATE_START
>     }
> 
>     2. open demux0 and set:
> 
>     dmx_pes_filter_params {
>         pid: 0x2000,
>         input: DMX_IN_CI,
>         output: DMX_OUT_TAP, // or DMX_OUT_TS_TAP
>         pes_type: DMX_PES_OTHER,
>         flags: DMX_IMMEDIATE_START
>     }
> 
>> I think an ioctl to enable bypassing the PID filter when writing to the
>> CI would help to decrease the amount of overkill.
>>
> 
> By overkill I meant that Demux API has features which may not be
> needed in the nGene case, and that implementing CAIO with Demux API
> may be more difficult than what we have now (SEC). Use may also be
> more complicated.
>
>>> I imagine there would still be a difference between the two cases:
>>>
>>> - nGene (CineS2 with CI-Module)
>>
>> IMO, this should be:
>>
>> /dev/dvb/adapter0/ca0 (or better: ci0)
>> /dev/dvb/adapter0/demux0
>> /dev/dvb/adapter0/demux1
>> /dev/dvb/adapter0/demux2
>> /dev/dvb/adapter0/dvr0
>> /dev/dvb/adapter0/dvr1
>> /dev/dvb/adapter0/dvr2
>> /dev/dvb/adapter0/frontend0
>> /dev/dvb/adapter0/frontend1
>>
>> (assuming 3 TS inputs)
> 
> Another version:
> 
> /dev/dvb/adapter0/ca0
> /dev/dvb/adapter0/demux0
> /dev/dvb/adapter0/caio0
> /dev/dvb/adapter0/dvr0
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/frontend1
> 
> One could use 3 TS inputs this way too.

But then you can record only one TS at a time through dvr.

Regards,
Andreas

>>> - Configurable Design (dual card similar to NetUP)
>>
>> and
>>
>> /dev/dvb/adapter0/ca0 (or better: ci0)
>> /dev/dvb/adapter0/ca1 (or better: ci1)
>> /dev/dvb/adapter0/demux0
>> /dev/dvb/adapter0/demux1
>> /dev/dvb/adapter0/dvr0
>> /dev/dvb/adapter0/dvr1
>> /dev/dvb/adapter0/frontend0
>> /dev/dvb/adapter0/frontend1
>>
>> (assuming 2 TS inputs and a way to map a CI to a frontend)
>>
>> or your suggestion for NetUP, assuming fixed relations between CI slots
>> and frontends.
>>
> 
> Fixed relations indeed. Alternatively:
> 
> /dev/dvb/adapter0/ca0
> /dev/dvb/adapter0/ca1
> /dev/dvb/adapter0/demux0
> /dev/dvb/adapter0/dvr0
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/frontend1
> 
>>> What do you say about this difference?
>>
>> Different capabilities result in different nodes. I don't see anything
>> special about it.
>>
>> Regards,
>> Andreas
> 
> Best regards,
> Martin
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

