Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58265 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753169AbdAKMLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 07:11:45 -0500
Message-ID: <1484136644.2934.89.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 11 Jan 2017 13:10:44 +0100
In-Reply-To: <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
         <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
         <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
         <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
         <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
         <1483990983.13625.58.camel@pengutronix.de>
         <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
         <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Am Dienstag, den 10.01.2017, 15:52 -0800 schrieb Steve Longerbeam:
> 
> On 01/09/2017 04:15 PM, Steve Longerbeam wrote:
> > Hi Philipp,
> >
> >
> > On 01/09/2017 11:43 AM, Philipp Zabel wrote:
> >
> >
> > <snip>
> >> One is the amount and organization of subdevices/media entities visible
> >> to userspace. The SMFCs should not be user controllable subdevices, but
> >> can be implicitly enabled when a CSI is directly linked to a camif.
> >
> > I agree the SMFC could be folded into the CSI, but I see at least one
> > issue.

I don't suggest to fold it into the CSI.
The CSI should have one output pad that that can be connected either to
the IC PRP input (CSIx_DATA_DEST=1) or to the IDMAC via SMFC
(CSIx_DATA_DEST=2). The SMFC should be considered part of the link
between CSI and IDMAC.
The IC PRP input pad should be connected to either the CSI0 output pad
(CSI_SEL=0,IC_INPUT=0), the CSI1 output pad (CSI_SEL=1,IC_INPUT=0), or
to the VDIC (IC_INPUT=1).

> > From the dot graph you'll see that the PRPVF entity can receive directly
> > from the CSI, or indirectly via the SMFC.

And that's one reason why I think representing the mem2mem paths as
links in the media controller interface is questionable. The path "via
SMFC" is not really a hardware connection between CSI -> SMFC -> IC PRP,
but two completely separate paths:
CSI -> SMFC -> IDMAC -> mem and mem -> IDMAC -> IC PRP with different
IDMAC read/write channels. The only real connection is that one DMA the
IC DMA transfers are triggered automatically by the frame
synchronisation unit on every CSI frame.
There is no way to convey to the user which links are real connections
and which are just linked DMA write and read channels somewhere else.

Is there even a reason for the user to switch between direct and via
memory paths manually, or could this be inferred from other state
(formats, active links)?

>  If the SMFC entity were folded
> > into the CSI entity, there would have to be a "direct to PRPVF" output 
> > pad
> > and a "indirect via SMFC" output pad and I'm not sure how that info would
> > be conveyed to the user. With a SMFC entity those pipelines are explicit.
>
> In summary here, unless you have strong objection I'd prefer to keep a
> distinct SMFC entity.

I do, I still think you could both describe the hardware better and
reduce unnecessary interface complexity by removing the SMFC entities
and their imagined links to the IC.

> It makes the pipelines more clear to the user, and it
> better models the IPU internals.

I disagree. The IPU has a single SMFC that acts as FIFO to both CSIs in
the CSI -> SMFC -> IDMAC path, not two. The "channel linking" (automatic
DMA triggers between channels in the IDMAC via FSU) has nothing to do
with the SMFC.

> >> Also I'm not convinced the 1:1 mapping of IC task to subdevices is the
> >> best choice. It is true that the three tasks can be enabled separately,
> >> but to my understanding, the PRP ENC and PRP VF tasks share a single
> >> input channel. Shouldn't this be a single PRP subdevice with one input
> >> and two (VF, ENC) outputs?
> >
> > Since the VDIC sends its motion compensated frames to the PRP VF task,
> > I've created the PRPVF entity solely for motion compensated de-interlace
> > support. I don't really see any other use for the PRPVF task except for
> > motion compensated de-interlace.

I suppose simultaneous scaling to two different resolutions without
going through memory could be one interesting use case:

           ,--> VF --> IDMAC -> mem -> to display
CSI -> IC PRP 
           `--> ENC -> IDMAC -> mem -> to VPU

> > So really, the PRPVF entity is a combination of the VDIC and PRPVF 
> > subunits.

I'd prefer to keep them separate, we could then use a deactivated VDIC
-> IC PRP link to mark the VDIC as available to be used for its
combining functionality by another driver.

Also logically, the VDIC subdev would be the right user interface to
switch from interlaced to non-interlaced pad modes, whereas the IC
subdev(s) should just allow changing color space and size between its
inputs and outputs.

> > So looking at link_setup() in imx-csi.c, you'll see that when the CSI 
> > is linked
> > to PRPVF entity, it is actually sending to IPU_CSI_DEST_VDIC.
> >
> > But if we were to create a VDIC entity, I can see how we could then
> > have a single PRP entity. Then if the PRP entity is receiving from the 
> > VDIC,
> > the PRP VF task would be activated.
> >
> > Another advantage of creating a distinct VDIC entity is that frames could
> > potentially be routed directly from the VDIC to camif, for 
> > motion-compensated
> > frame capture only with no scaling/CSC. I think that would be IDMAC 
> > channel
> > 5, we've tried to get that pipeline to work in the past without 
> > success. That's
> > mainly why I decided not to attempt it and instead fold VDIC into 
> > PRPVF entity.

There's also channel 13, but that's described as "Recent field form
CSI", so I think that might be for CSI only mode.

> Here also, I'd prefer to keep distinct PRPENC and PRPVF entities. You 
> are correct that PRPENC and PRPVF do share an input channel (the CSIs).
> But the PRPVF has an additional input channel from the VDIC, 

Wait, that is a VDIC -> PRP connection, not a VDIC -> PRPVF connection,
or am I mistaken?
The VDIC direct input is enabled with ipu_set_ic_src_mux(vdi=true)
(IC_INPUT=1), and that is the same for both PRP->ENC and PRP->VF.

> and since my PRPVF entity roles
> up the VDIC internally, it is actually receiving from the VDIC channel.
> So unless you think we should have a distinct VDIC entity, I would like 
> to keep this
> the way it is.

Yes, I think VDIC should be separated out of PRPVF. What do you think
about splitting the IC PRP into three parts?

PRP could have one input pad connected to either CSI0, CSI1, or VDIC,
and two output pads connected to PRPVF and PRPENC, respectively. This
would even allow to have the PRP describe the downscale and PRPVF and
PRPENC describe the bilinear upscale part of the IC.

regards
Philipp

