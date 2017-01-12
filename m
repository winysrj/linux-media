Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:61951 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdALXXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 18:23:11 -0500
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
 <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
 <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
 <1483990983.13625.58.camel@pengutronix.de>
 <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
 <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
 <1484136644.2934.89.camel@pengutronix.de>
CC: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
Date: Thu, 12 Jan 2017 15:22:16 -0800
MIME-Version: 1.0
In-Reply-To: <1484136644.2934.89.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, JM,


First, let me say that you both have convinced me that we need a VDIC
entity. I've implemented that in the branch imx-media-staging-md-vdic.
At this point it only implements the M/C de-interlacing function, not the
plane Combiner. So it has only one input and one output pad. I would
imagine it will need two additional inputs and another output to support
the Combiner (two pads for each plane to be combined, and a combiner
output pad).

More below...

On 01/11/2017 04:10 AM, Philipp Zabel wrote:
> Hi Steve,
>
> Am Dienstag, den 10.01.2017, 15:52 -0800 schrieb Steve Longerbeam:
>> On 01/09/2017 04:15 PM, Steve Longerbeam wrote:
>>> Hi Philipp,
>>>
>>>
>>> On 01/09/2017 11:43 AM, Philipp Zabel wrote:
>>>
>>>
>>> <snip>
>>>> One is the amount and organization of subdevices/media entities visible
>>>> to userspace. The SMFCs should not be user controllable subdevices, but
>>>> can be implicitly enabled when a CSI is directly linked to a camif.
>>> I agree the SMFC could be folded into the CSI, but I see at least one
>>> issue.
> I don't suggest to fold it into the CSI.
> The CSI should have one output pad that that can be connected either to
> the IC PRP input (CSIx_DATA_DEST=1) or to the IDMAC via SMFC
> (CSIx_DATA_DEST=2).

Right, and CSI can connect to VDIC. I don't know if it is documented,
but to route to VDIC, set CSIx_DATA_DEST=1, as if to IC PRP. Confusing,
but it's as if the VDIC is somehow part of the IC.

>   The SMFC should be considered part of the link
> between CSI and IDMAC.

sure, I can agree with that.

> The IC PRP input pad should be connected to either the CSI0 output pad
> (CSI_SEL=0,IC_INPUT=0), the CSI1 output pad (CSI_SEL=1,IC_INPUT=0), or
> to the VDIC (IC_INPUT=1).

correct.

>
>>>  From the dot graph you'll see that the PRPVF entity can receive directly
>>> from the CSI, or indirectly via the SMFC.
> And that's one reason why I think representing the mem2mem paths as
> links in the media controller interface is questionable. The path "via
> SMFC" is not really a hardware connection between CSI -> SMFC -> IC PRP,
> but two completely separate paths:
> CSI -> SMFC -> IDMAC -> mem and mem -> IDMAC -> IC PRP with different
> IDMAC read/write channels. The only real connection is that one DMA the
> IC DMA transfers are triggered automatically by the frame
> synchronisation unit on every CSI frame.
> There is no way to convey to the user which links are real connections
> and which are just linked DMA write and read channels somewhere else.
>
> Is there even a reason for the user to switch between direct and via
> memory paths manually, or could this be inferred from other state
> (formats, active links)?

a CSI -> VDIC link doesn't convey whether that is a direct link using
the FSU, or whether it is via SMFC and memory buffers.

If you'll recall, the VDIC has three motion modes: low, medium, and
high.

When VDIC receives directly from CSI, it can only operate in
high motion mode (it processes a single field F(n-1) sent directly
from the CSI using the FSU). The reference manual refers to this
as "real time mode".

The low and medium motion modes require processing all three
fields F(n-1), F(n), and F(n+1). These fields must come from IDMAC
channels 8, 9, and 10 respectively.

So in order to support low and medium motion modes, there needs to
be a pipeline where the VDIC receives F(n-1), F(n), and F(n+1) from
memory buffers.

How about this: we can do away with SMFC entities by having two
output pads from the CSI: a "direct" output pad that can link to PRP and
VDIC, and a "IDMAC via SMFC" output pad that links to the entities that
require memory buffers (VDIC in low/medium motion mode, camif, and
PP). Only one of those output pads can be active at a time. I'm not sure if
that allowed by the media framework, do two source pads imply that the
entity can activate both of those pads simultaneously, or is allowed that
only one source pad of two or more can be activated at a time? It's not
clear to me.

Let me know if you agree with this proposal.

> <snip>
>>>> Also I'm not convinced the 1:1 mapping of IC task to subdevices is the
>>>> best choice. It is true that the three tasks can be enabled separately,
>>>> but to my understanding, the PRP ENC and PRP VF tasks share a single
>>>> input channel. Shouldn't this be a single PRP subdevice with one input
>>>> and two (VF, ENC) outputs?
>>> Since the VDIC sends its motion compensated frames to the PRP VF task,
>>> I've created the PRPVF entity solely for motion compensated de-interlace
>>> support. I don't really see any other use for the PRPVF task except for
>>> motion compensated de-interlace.
> I suppose simultaneous scaling to two different resolutions without
> going through memory could be one interesting use case:
>
>             ,--> VF --> IDMAC -> mem -> to display
> CSI -> IC PRP
>             `--> ENC -> IDMAC -> mem -> to VPU

Yes, that is one possibility.

>>> So really, the PRPVF entity is a combination of the VDIC and PRPVF
>>> subunits.
> I'd prefer to keep them separate, we could then use a deactivated VDIC
> -> IC PRP link to mark the VDIC as available to be used for its
> combining functionality by another driver.
>
> Also logically, the VDIC subdev would be the right user interface to
> switch from interlaced to non-interlaced pad modes, whereas the IC
> subdev(s) should just allow changing color space and size between its
> inputs and outputs.

right, that has been implemented in branch imx-media-staging-md-vdic.

> <snip>
>> Here also, I'd prefer to keep distinct PRPENC and PRPVF entities. You
>> are correct that PRPENC and PRPVF do share an input channel (the CSIs).
>> But the PRPVF has an additional input channel from the VDIC,
> Wait, that is a VDIC -> PRP connection, not a VDIC -> PRPVF connection,
> or am I mistaken?

The FSU only sends VDIC output to PRPVF, not PRPENC. It's not
well documented, but see "IPU main flows" section in the manual.
All listed pipelines that route VDIC to IC go to IC (PRP VF).

Which suggests that when IC receives from VDIC, PRPENC can
receive no data and is effectively unusable.

> The VDIC direct input is enabled with ipu_set_ic_src_mux(vdi=true)
> (IC_INPUT=1), and that is the same for both PRP->ENC and PRP->VF.

true, but in fact the FSU only sends to PRP VF.

>> and since my PRPVF entity roles
>> up the VDIC internally, it is actually receiving from the VDIC channel.
>> So unless you think we should have a distinct VDIC entity, I would like
>> to keep this
>> the way it is.
> Yes, I think VDIC should be separated out of PRPVF. What do you think
> about splitting the IC PRP into three parts?
>
> PRP could have one input pad connected to either CSI0, CSI1, or VDIC,
> and two output pads connected to PRPVF and PRPENC, respectively. This
> would even allow to have the PRP describe the downscale and PRPVF and
> PRPENC describe the bilinear upscale part of the IC.

Sure sounds good to me. PRPENC and PRPVF are independent,
but they cannot process different data streams, they both have to
work with CSI0 or CSI1, so this makes sense.

I'll start looking into it.

Steve

