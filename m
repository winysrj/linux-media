Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54705 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S969056AbdAITnJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 14:43:09 -0500
Message-ID: <1483990983.13625.58.camel@pengutronix.de>
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
Date: Mon, 09 Jan 2017 20:43:03 +0100
In-Reply-To: <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
         <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
         <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
         <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
         <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
         <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Am Freitag, den 30.12.2016, 12:26 -0800 schrieb Steve Longerbeam:
> 
> On 12/30/2016 11:06 AM, Marek Vasut wrote:
> > On 12/29/2016 09:51 PM, Robert Schwebel wrote:
> >> Hi Jean-Michel,
> > Hi,
> >
> >> On Thu, Dec 29, 2016 at 04:08:33PM +0100, Jean-Michel Hautbois wrote:
> >>> What is the status of this work?
> >> Philipp's patches have been reworked with the review feedback from the
> >> last round and a new version will be posted when he is back from
> >> holidays.
> > IMO Philipp's patches are better integrated and well structured, so I'd
> > rather like to see his work in at some point.
> 
> Granted I am biased, but I will state my case. "Better integrated" - my 
> patches
> are also well integrated with the media core infrastructure. Philipp's 
> patches
> in fact require modification to media core, whereas mine require none.
> Some changes are needed of course (more subdev type definitions for
> one).
> 
> As for "well structured", I don't really understand what is meant by that,
> but my driver is also well structured.

I agree that this driver is well structured and well documented. Many of
my earlier concerns regarding the device tree bindings and media
controller interface have been addressed. But there are still a few
design choices that I don't agree with, and some are userspace visible,
which makes me worry about not being able to change them later.

One is the amount and organization of subdevices/media entities visible
to userspace. The SMFCs should not be user controllable subdevices, but
can be implicitly enabled when a CSI is directly linked to a camif.
Also I'm not convinced the 1:1 mapping of IC task to subdevices is the
best choice. It is true that the three tasks can be enabled separately,
but to my understanding, the PRP ENC and PRP VF tasks share a single
input channel. Shouldn't this be a single PRP subdevice with one input
and two (VF, ENC) outputs?
On the other hand, there is currently no way to communicate to userspace
that the IC can't downscale bilinearly, but only to 1/2 or 1/4 of the
input resolution, and then scale up bilinearly for there. So instead of
pretending to be able to downscale to any resolution, it would be better
to split each IC task into two subdevs, one for the
1/2-or-1/4-downscaler, and one for the bilinear upscaler.
Next there is the issue of the custom mem2mem infrastructure inside the
IPU driver. I think this should be ultimately implemented at a higher
level, but I see no way this will ever move out of the IPU driver once
the userspace inferface gets established.

Then there are a few issues that are not userspace visible, so less
pressing. For example modelling the internal subdevs as separate
platform devices with async subdevices seems unnecessarily indirect. Why
not drop the platform devices and create the subdevs directly instead of
asynchronously?
I'll try to give the driver a proper review in the next days.

> Philipp's driver only supports unconverted image capture from the SMFC. 
> In addition
> to that, mine allows for all the hardware links supported by the IPU, 
> including routing
> frames from the CSI directly to the Image converter for scaling up to 
> 4096x4096,

Note that tiled scaling (anything > 1024x1024) currently doesn't produce
correct results due to the fractional reset at the seam. This is not a
property of this driver, but still needs to be fixed in the ipu-v3 core.

> colorspace conversion, rotation, and motion compensated de-interlace. 
> Yes all these
> conversion can be carried out post-capture via a mem2mem device, but 
> conversion
> directly from CSI capture has advantages, including minimized CPU 
> utilization and
> lower AXI bus traffic.

These benefits are limited by the hardware to non-rotated frames <
1024x1024 pixels.

regards
Philipp

