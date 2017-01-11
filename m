Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59091 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753322AbdAKMLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 07:11:45 -0500
Message-ID: <1484136676.2934.90.camel@pengutronix.de>
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
Date: Wed, 11 Jan 2017 13:11:16 +0100
In-Reply-To: <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
         <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
         <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
         <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
         <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
         <1483990983.13625.58.camel@pengutronix.de>
         <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 09.01.2017, 16:15 -0800 schrieb Steve Longerbeam:
[...]
> Since the VDIC sends its motion compensated frames to the PRP VF task,
> I've created the PRPVF entity solely for motion compensated de-interlace
> support. I don't really see any other use for the PRPVF task except for
> motion compensated de-interlace.
> 
> So really, the PRPVF entity is a combination of the VDIC and PRPVF subunits.
> 
> So looking at link_setup() in imx-csi.c, you'll see that when the CSI is 
> linked
> to PRPVF entity, it is actually sending to IPU_CSI_DEST_VDIC.
> 
> But if we were to create a VDIC entity, I can see how we could then
> have a single PRP entity. Then if the PRP entity is receiving from the VDIC,
> the PRP VF task would be activated.
> 
> Another advantage of creating a distinct VDIC entity is that frames could
> potentially be routed directly from the VDIC to camif, for 
> motion-compensated
> frame capture only with no scaling/CSC. I think that would be IDMAC channel
> 5, we've tried to get that pipeline to work in the past without success. 
> That's
> mainly why I decided not to attempt it and instead fold VDIC into PRPVF 
> entity.
> 
> 
> > On the other hand, there is currently no way to communicate to userspace
> > that the IC can't downscale bilinearly, but only to 1/2 or 1/4 of the
> > input resolution, and then scale up bilinearly for there. So instead of
> > pretending to be able to downscale to any resolution, it would be better
> > to split each IC task into two subdevs, one for the
> > 1/2-or-1/4-downscaler, and one for the bilinear upscaler.
> 
> Hmm, good point, but couldn't we just document that fact?
> 
> 
> 
> > Next there is the issue of the custom mem2mem infrastructure inside the
> > IPU driver. I think this should be ultimately implemented at a higher
> > level,
> 
> if we were to move it up, into what subsystem would it go? I guess
> v4l2, but then we lose the possibility of other subsystems making use
> of it, such as drm.
> 
> >   but I see no way this will ever move out of the IPU driver once
> > the userspace inferface gets established.
> 
> it would be more difficult at that point, true.
> 
> > Then there are a few issues that are not userspace visible, so less
> > pressing. For example modelling the internal subdevs as separate
> > platform devices with async subdevices seems unnecessarily indirect. Why
> > not drop the platform devices and create the subdevs directly instead of
> > asynchronously?
> 
> This came out of a previous implementation where the IPU internal
> subunits and their links were represented as an OF graph (the patches
> I floated by you that you didn't like :) I've been meaning to ask you why
> you don't like to expose the IPU internals via OF graph, I have my theories
> why, but I digress). In that implementation the internal subdevs had to be
> registered asynchronously with device node match.
> 
> I thought about going back to registering the IPU internal subdevs
> directly, but I actually like doing it this way, it provides a satisfying
> symmetry that all the subdevs are registered in the same way
> asynchronously, the only difference being the external subdevs are
> registered with device node match, and the internal subdevs with
> device name match.
> 
> 
> > I'll try to give the driver a proper review in the next days.
> 
> Ok thanks.
> 
> >> Philipp's driver only supports unconverted image capture from the SMFC.
> >> In addition
> >> to that, mine allows for all the hardware links supported by the IPU,
> >> including routing
> >> frames from the CSI directly to the Image converter for scaling up to
> >> 4096x4096,
> > Note that tiled scaling (anything > 1024x1024) currently doesn't produce
> > correct results due to the fractional reset at the seam. This is not a
> > property of this driver, but still needs to be fixed in the ipu-v3 core.
> 
> right, understood.
> 
> >> colorspace conversion, rotation, and motion compensated de-interlace.
> >> Yes all these
> >> conversion can be carried out post-capture via a mem2mem device, but
> >> conversion
> >> directly from CSI capture has advantages, including minimized CPU
> >> utilization and
> >> lower AXI bus traffic.
> > These benefits are limited by the hardware to non-rotated frames <
> > 1024x1024 pixels.
> 
> right. But I can see many use-cases out there, where people need
> scaling and/or colorspace conversion in video capture, but don't
> need output > 1024x1024.
> 
> Steve
> 
> 


