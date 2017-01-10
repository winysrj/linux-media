Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:47323 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755842AbdAJAPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 19:15:20 -0500
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
 <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
 <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
 <1483990983.13625.58.camel@pengutronix.de>
CC: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
Date: Mon, 9 Jan 2017 16:15:11 -0800
MIME-Version: 1.0
In-Reply-To: <1483990983.13625.58.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 01/09/2017 11:43 AM, Philipp Zabel wrote:
> Hi Steve,
>
> Am Freitag, den 30.12.2016, 12:26 -0800 schrieb Steve Longerbeam:
>> On 12/30/2016 11:06 AM, Marek Vasut wrote:
>>> On 12/29/2016 09:51 PM, Robert Schwebel wrote:
>>>> Hi Jean-Michel,
>>> Hi,
>>>
>>>> On Thu, Dec 29, 2016 at 04:08:33PM +0100, Jean-Michel Hautbois wrote:
>>>>> What is the status of this work?
>>>> Philipp's patches have been reworked with the review feedback from the
>>>> last round and a new version will be posted when he is back from
>>>> holidays.
>>> IMO Philipp's patches are better integrated and well structured, so I'd
>>> rather like to see his work in at some point.
>> Granted I am biased, but I will state my case. "Better integrated" - my
>> patches
>> are also well integrated with the media core infrastructure. Philipp's
>> patches
>> in fact require modification to media core, whereas mine require none.
>> Some changes are needed of course (more subdev type definitions for
>> one).
>>
>> As for "well structured", I don't really understand what is meant by that,
>> but my driver is also well structured.
> I agree that this driver is well structured and well documented. Many of
> my earlier concerns regarding the device tree bindings and media
> controller interface have been addressed.

Thanks! Your input is crucial, so I really appreciate it.

>   But there are still a few
> design choices that I don't agree with, and some are userspace visible,
> which makes me worry about not being able to change them later.

Ok.

> One is the amount and organization of subdevices/media entities visible
> to userspace. The SMFCs should not be user controllable subdevices, but
> can be implicitly enabled when a CSI is directly linked to a camif.

I agree the SMFC could be folded into the CSI, but I see at least one
issue.

 From the dot graph you'll see that the PRPVF entity can receive directly
from the CSI, or indirectly via the SMFC. If the SMFC entity were folded
into the CSI entity, there would have to be a "direct to PRPVF" output pad
and a "indirect via SMFC" output pad and I'm not sure how that info would
be conveyed to the user. With a SMFC entity those pipelines are explicit.

> Also I'm not convinced the 1:1 mapping of IC task to subdevices is the
> best choice. It is true that the three tasks can be enabled separately,
> but to my understanding, the PRP ENC and PRP VF tasks share a single
> input channel. Shouldn't this be a single PRP subdevice with one input
> and two (VF, ENC) outputs?

Since the VDIC sends its motion compensated frames to the PRP VF task,
I've created the PRPVF entity solely for motion compensated de-interlace
support. I don't really see any other use for the PRPVF task except for
motion compensated de-interlace.

So really, the PRPVF entity is a combination of the VDIC and PRPVF subunits.

So looking at link_setup() in imx-csi.c, you'll see that when the CSI is 
linked
to PRPVF entity, it is actually sending to IPU_CSI_DEST_VDIC.

But if we were to create a VDIC entity, I can see how we could then
have a single PRP entity. Then if the PRP entity is receiving from the VDIC,
the PRP VF task would be activated.

Another advantage of creating a distinct VDIC entity is that frames could
potentially be routed directly from the VDIC to camif, for 
motion-compensated
frame capture only with no scaling/CSC. I think that would be IDMAC channel
5, we've tried to get that pipeline to work in the past without success. 
That's
mainly why I decided not to attempt it and instead fold VDIC into PRPVF 
entity.


> On the other hand, there is currently no way to communicate to userspace
> that the IC can't downscale bilinearly, but only to 1/2 or 1/4 of the
> input resolution, and then scale up bilinearly for there. So instead of
> pretending to be able to downscale to any resolution, it would be better
> to split each IC task into two subdevs, one for the
> 1/2-or-1/4-downscaler, and one for the bilinear upscaler.

Hmm, good point, but couldn't we just document that fact?



> Next there is the issue of the custom mem2mem infrastructure inside the
> IPU driver. I think this should be ultimately implemented at a higher
> level,

if we were to move it up, into what subsystem would it go? I guess
v4l2, but then we lose the possibility of other subsystems making use
of it, such as drm.

>   but I see no way this will ever move out of the IPU driver once
> the userspace inferface gets established.

it would be more difficult at that point, true.

> Then there are a few issues that are not userspace visible, so less
> pressing. For example modelling the internal subdevs as separate
> platform devices with async subdevices seems unnecessarily indirect. Why
> not drop the platform devices and create the subdevs directly instead of
> asynchronously?

This came out of a previous implementation where the IPU internal
subunits and their links were represented as an OF graph (the patches
I floated by you that you didn't like :) I've been meaning to ask you why
you don't like to expose the IPU internals via OF graph, I have my theories
why, but I digress). In that implementation the internal subdevs had to be
registered asynchronously with device node match.

I thought about going back to registering the IPU internal subdevs
directly, but I actually like doing it this way, it provides a satisfying
symmetry that all the subdevs are registered in the same way
asynchronously, the only difference being the external subdevs are
registered with device node match, and the internal subdevs with
device name match.


> I'll try to give the driver a proper review in the next days.

Ok thanks.

>> Philipp's driver only supports unconverted image capture from the SMFC.
>> In addition
>> to that, mine allows for all the hardware links supported by the IPU,
>> including routing
>> frames from the CSI directly to the Image converter for scaling up to
>> 4096x4096,
> Note that tiled scaling (anything > 1024x1024) currently doesn't produce
> correct results due to the fractional reset at the seam. This is not a
> property of this driver, but still needs to be fixed in the ipu-v3 core.

right, understood.

>> colorspace conversion, rotation, and motion compensated de-interlace.
>> Yes all these
>> conversion can be carried out post-capture via a mem2mem device, but
>> conversion
>> directly from CSI capture has advantages, including minimized CPU
>> utilization and
>> lower AXI bus traffic.
> These benefits are limited by the hardware to non-rotated frames <
> 1024x1024 pixels.

right. But I can see many use-cases out there, where people need
scaling and/or colorspace conversion in video capture, but don't
need output > 1024x1024.

Steve

