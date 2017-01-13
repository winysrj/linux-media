Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35411 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751356AbdAMLFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 06:05:31 -0500
Message-ID: <1484305459.2436.70.camel@pengutronix.de>
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
Date: Fri, 13 Jan 2017 12:04:19 +0100
In-Reply-To: <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
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
         <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 12.01.2017, 15:22 -0800 schrieb Steve Longerbeam:
> Hi Philipp, JM,
>
> First, let me say that you both have convinced me that we need a VDIC
> entity. I've implemented that in the branch imx-media-staging-md-vdic.
> At this point it only implements the M/C de-interlacing function, not the
> plane Combiner. So it has only one input and one output pad.

Excellent.

>  I would
> imagine it will need two additional inputs and another output to support
> the Combiner (two pads for each plane to be combined, and a combiner
> output pad).

If I accept for a moment that IDMAC/FSU channel links are described as
media entity links, that would be right, I guess. The input pads would
represent the VDI1/3_SRC_SEL FSU muxes and the IDMAC read channels 25
and 26.

> More below...
[...]
> > I don't suggest to fold it into the CSI.
> > The CSI should have one output pad that that can be connected either to
> > the IC PRP input (CSIx_DATA_DEST=1) or to the IDMAC via SMFC
> > (CSIx_DATA_DEST=2).
> 
> Right, and CSI can connect to VDIC. I don't know if it is documented,
> but to route to VDIC, set CSIx_DATA_DEST=1, as if to IC PRP. Confusing,
> but it's as if the VDIC is somehow part of the IC.

Agreed. I get the feeling that the VDIC FIFOs (especially FIFO1) and the
"FIFO[s] located in the Input Buffer Memory" that are mentioned in the
IC chapter might be partially referring to the same thing, or at least
are somehow tightly interconnected. At least VDIC FIFO1 described in
Figure 37-47 "VDIC Block Diagram" has the direct CSI input into FIFO1,
and it is mentioned that the IDMAC can read back from FIFO1 directly.

[...]
> > Is there even a reason for the user to switch between direct and via
> > memory paths manually, or could this be inferred from other state
> > (formats, active links)?
> 
> a CSI -> VDIC link doesn't convey whether that is a direct link using
> the FSU, or whether it is via SMFC and memory buffers.
> 
> If you'll recall, the VDIC has three motion modes: low, medium, and
> high.
> 
> When VDIC receives directly from CSI, it can only operate in
> high motion mode (it processes a single field F(n-1) sent directly
> from the CSI using the FSU). The reference manual refers to this
> as "real time mode".

In my opinion this is the only mode that should be supported in the
capture driver. But that may be wishful thinking to a certain degree -
see below.

> The low and medium motion modes require processing all three
> fields F(n-1), F(n), and F(n+1). These fields must come from IDMAC
> channels 8, 9, and 10 respectively.
> 
> So in order to support low and medium motion modes, there needs to
> be a pipeline where the VDIC receives F(n-1), F(n), and F(n+1) from
> memory buffers.

In the cases where the VDIC reads all three fields from memory, I'd
prefer that to be implemented as a separate mem2mem device. While useful
on its own, there could be an API to link together the capture and
output of different video4linux devices, and that could get a backend to
implement IDMAC/FSU channel linking where supported.

> How about this: we can do away with SMFC entities by having two
> output pads from the CSI: a "direct" output pad that can link to PRP and
> VDIC, and a "IDMAC via SMFC" output pad that links to the entities that
> require memory buffers (VDIC in low/medium motion mode, camif, and
> PP). Only one of those output pads can be active at a time. I'm not sure if
> that allowed by the media framework, do two source pads imply that the
> entity can activate both of those pads simultaneously, or is allowed that
> only one source pad of two or more can be activated at a time? It's not
> clear to me.
> 
> Let me know if you agree with this proposal.

In my opinion that is better than having the SMFC as a separate entity,
even better would be not to have to describe the memory paths as media
links.

[...]
> >> Here also, I'd prefer to keep distinct PRPENC and PRPVF entities. You
> >> are correct that PRPENC and PRPVF do share an input channel (the CSIs).
> >> But the PRPVF has an additional input channel from the VDIC,
> > Wait, that is a VDIC -> PRP connection, not a VDIC -> PRPVF connection,
> > or am I mistaken?
> 
> The FSU only sends VDIC output to PRPVF, not PRPENC. It's not
> well documented, but see "IPU main flows" section in the manual.
> All listed pipelines that route VDIC to IC go to IC (PRP VF).

Sorry to be a bit pedantic, the FSU does not send output. It just
triggers a DMA read channel (IDMAC or DMAIC) whenever signalled by
another write channel's EOF.

Since the read channel of PRPVF and PRPENC is the same (IC direct, cb7),
I don't yet understand how the VDIC output can be sent to one but not
the other. As you said, the documentation is a bit confusing in this
regard.

> Which suggests that when IC receives from VDIC, PRPENC can
> receive no data and is effectively unusable.
> 
> > The VDIC direct input is enabled with ipu_set_ic_src_mux(vdi=true)
> > (IC_INPUT=1), and that is the same for both PRP->ENC and PRP->VF.
> 
> true, but in fact the FSU only sends to PRP VF.

Ok. Still, I think in that case we can describe the link as VDIC -> PRP
and just prohibit the PRPENC links to be enabled when that is set.

> >> and since my PRPVF entity roles
> >> up the VDIC internally, it is actually receiving from the VDIC channel.
> >> So unless you think we should have a distinct VDIC entity, I would like
> >> to keep this
> >> the way it is.
> > Yes, I think VDIC should be separated out of PRPVF. What do you think
> > about splitting the IC PRP into three parts?
> >
> > PRP could have one input pad connected to either CSI0, CSI1, or VDIC,
> > and two output pads connected to PRPVF and PRPENC, respectively. This
> > would even allow to have the PRP describe the downscale and PRPVF and
> > PRPENC describe the bilinear upscale part of the IC.
> 
> Sure sounds good to me. PRPENC and PRPVF are independent,
> but they cannot process different data streams, they both have to
> work with CSI0 or CSI1, so this makes sense.
> 
> I'll start looking into it.

Thanks!

regards
Philipp

