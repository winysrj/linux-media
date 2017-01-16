Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39555 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750981AbdAPLts (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 06:49:48 -0500
Message-ID: <1484567381.8415.79.camel@pengutronix.de>
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
Date: Mon, 16 Jan 2017 12:49:41 +0100
In-Reply-To: <d1a1d89e-1630-b35b-6d40-a5e255d99c0a@mentor.com>
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
         <1484305536.31475.0.camel@pengutronix.de>
         <d1a1d89e-1630-b35b-6d40-a5e255d99c0a@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sat, 2017-01-14 at 12:26 -0800, Steve Longerbeam wrote:
> 
> On 01/13/2017 03:05 AM, Philipp Zabel wrote:
> > Hi Steve,
> >
> > Am Donnerstag, den 12.01.2017, 15:22 -0800 schrieb Steve Longerbeam:
[...]
> >>   I would
> >> imagine it will need two additional inputs and another output to support
> >> the Combiner (two pads for each plane to be combined, and a combiner
> >> output pad).
> > If I accept for a moment that IDMAC/FSU channel links are described as
> > media entity links, that would be right, I guess.
> 
> Hi Philipp,
> 
> Let me start by asking, why you are averse to the idea that a media
> driver passes video frames from source to sink using memory
> buffers? There is no hard-and-fast rule in the media framework that
> states this should not be done, AFAIK.

To help you understand my perspective, I mostly use v4l2 devices in
GStreamer pipelines. That means, chaining separate mem2mem devices into
a pipeline that passes dma-bufs around is the easy default. I consider
linking mem2mem devices in the kernel (so buffers don't have to be
dequeued/queued into userspace all the time) or even in hardware (the
FSU basically implements hardware fences on a free-running rigid
2-buffer queue between two DMA channels) to be two performance
optimization steps from there.

Step 1 of linking two mem2mem devices using a software buffer queue
could be achieved at the videobuf2 level. That would need a new API to
share DMA buffers between vb2 queues and then switch them into a free
running mode that allows the kernel to pass buffers back and forth
automatically. But that mechanism would not be specific to hardware at
all. It could reuse / extend upon the existing vb2 queue implementation,
and it would be possible to use it with any driver instead of only IPU
internal components. In case of i.MX6 we could link the CODA h.264
encoder input to the PRPENC output, for example.
Also I'm opposed to adding a custom mem2mem framework in the IPU driver
because I don't believe the IPU is the only hardware unit that has
processing paths that need to go through temporary memory copies. Adding
the same functionality for every driver that can do this in a slightly
different way doesn't scale.

Step 2 of providing a fixed double-buffer queue and then using the IPU
FSU to trigger the DMA read channels in hardware instead of from the
write channel EOF interrupt handler is quite a bit more hardware
specific, but even there, it could be that the FSU links are not limited
to the IPU. I'm not sure if this actually works, but according to the
reference manual the (CODA) VPU can be triggered by the write channels
from SMFC and PRPVF and the VDOA can trigger the VDI or PP read channels
on i.MX6.

I do feel a bit bad about arguing against an existing working solution
when I only have a rough idea how I'd like steps 1 and 2 to look like,
but I really think implementing this inside a single driver via media
entity links is not the right way, and I fear once established, we'd
never get rid of it.

> I agree this overlaps with the mem2mem device idea somewhat, but
> IMHO a media device should be allowed to use internal memory
> buffers to pass video frames between pads, if that's what it needs to
> do to implement some functionality.
> 
> Can anyone else listening on this thread, chime in on this topic?

Yes, that would be very welcome.

> >>> Is there even a reason for the user to switch between direct and via
> >>> memory paths manually, or could this be inferred from other state
> >>> (formats, active links)?
> >> a CSI -> VDIC link doesn't convey whether that is a direct link using
> >> the FSU, or whether it is via SMFC and memory buffers.
> >>
> >> If you'll recall, the VDIC has three motion modes: low, medium, and
> >> high.
> >>
> >> When VDIC receives directly from CSI, it can only operate in
> >> high motion mode (it processes a single field F(n-1) sent directly
> >> from the CSI using the FSU). The reference manual refers to this
> >> as "real time mode".
> > In my opinion this is the only mode that should be supported in the
> > capture driver.
> 
> I have to disagree on that.

There isn't even hardware assisted triggering of the VDIC inputs for
deinterlacing in those modes, so there's really no performance benefit
over vb2 queue linking, and that would be a lot more useful.

> >   But that may be wishful thinking to a certain degree -
> > see below.
> >
> >> The low and medium motion modes require processing all three
> >> fields F(n-1), F(n), and F(n+1). These fields must come from IDMAC
> >> channels 8, 9, and 10 respectively.
> >>
> >> So in order to support low and medium motion modes, there needs to
> >> be a pipeline where the VDIC receives F(n-1), F(n), and F(n+1) from
> >> memory buffers.
> > In the cases where the VDIC reads all three fields from memory, I'd
> > prefer that to be implemented as a separate mem2mem device.
>
> I prefer that there be a single VDIC media entity, that makes use of its
> dma read channels in order to support all of its motion compensation
> modes.

The separate mem2mem device will be needed to deinterlace video from
other sources, for example encoded interlaced video streams.

> >   While useful
> > on its own, there could be an API to link together the capture and
> > output of different video4linux devices, and that could get a backend to
> > implement IDMAC/FSU channel linking where supported.
> 
> An interesting idea, but it also sounds a lot like what can already be
> provided by a pipeline in the media framework, by linking an entity
> that is a video source to an entity that is a video sink.

Yes, see my thoughts above. This unnecessarily (at least for the non-FSU
software queue "links") limits the functionality to entities inside a
single media device.

[...]
> >> Which suggests that when IC receives from VDIC, PRPENC can
> >> receive no data and is effectively unusable.
> >>
> >>> The VDIC direct input is enabled with ipu_set_ic_src_mux(vdi=true)
> >>> (IC_INPUT=1), and that is the same for both PRP->ENC and PRP->VF.
> >> true, but in fact the FSU only sends to PRP VF.
> > Ok. Still, I think in that case we can describe the link as VDIC -> PRP
> > and just prohibit the PRPENC links to be enabled when that is set.
> 
> exactly, that is what I've implemented in branch
> imx-media-staging-md-prp.

Ok.

regards
Philipp

