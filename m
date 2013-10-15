Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58388 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3JOONw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 10:13:52 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Archit Taneja' <archit@ti.com>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <1378462346-10880-1-git-send-email-archit@ti.com>
 <1381328975-18244-1-git-send-email-archit@ti.com> <5257ACD1.9010501@xs4all.nl>
 <525D477F.10606@ti.com> <525D487B.1000903@xs4all.nl>
In-reply-to: <525D487B.1000903@xs4all.nl>
Subject: RE: [PATCH v5 3/4] v4l: ti-vpe: Add VPE mem to mem driver
Date: Tue, 15 Oct 2013 16:13:49 +0200
Message-id: <05c301cec9b0$c598b6f0$50ca24d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Now, I am a bit busy with... USB. I have to admit I have a backlog of
patches to look through and prepare a tree for Mauro.
I wanted to do this on Thursday or Friday. Is it ok? BTW if you see any m2m
patches in patchwork feel free to delegate them to me.

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, October 15, 2013 3:52 PM
> To: Kamil Debski
> Cc: Archit Taneja; linux-media@vger.kernel.org; linux-
> omap@vger.kernel.org; laurent.pinchart@ideasonboard.com
> Subject: Re: [PATCH v5 3/4] v4l: ti-vpe: Add VPE mem to mem driver
> 
> Kamil,
> 
> Can you take this driver as m2m maintainer or should I take it?
> 
> Regards,
> 
> 	Hans
> 
> On 10/15/2013 03:47 PM, Archit Taneja wrote:
> > Hi Hans,
> >
> > On Friday 11 October 2013 01:16 PM, Hans Verkuil wrote:
> >> On 10/09/2013 04:29 PM, Archit Taneja wrote:
> >>> VPE is a block which consists of a single memory to memory path
> >>> which can perform chrominance up/down sampling, de-interlacing,
> >>> scaling, and color space conversion of raster or tiled YUV420
> >>> coplanar, YUV422 coplanar or YUV422 interleaved video formats.
> >>>
> >>> We create a mem2mem driver based primarily on the mem2mem-testdev
> example.
> >>> The de-interlacer, scaler and color space converter are all
> bypassed
> >>> for now to keep the driver simple. Chroma up/down sampler blocks
> are
> >>> implemented, so conversion beteen different YUV formats is possible.
> >>>
> >>> Each mem2mem context allocates a buffer for VPE MMR values which it
> >>> will use when it gets access to the VPE HW via the mem2mem queue,
> it
> >>> also allocates a VPDMA descriptor list to which configuration and
> data descriptors are added.
> >>>
> >>> Based on the information received via v4l2 ioctls for the source
> and
> >>> destination queues, the driver configures the values for the MMRs,
> >>> and stores them in the buffer. There are also some VPDMA parameters
> >>> like frame start and line mode which needs to be configured, these
> >>> are configured by direct register writes via the VPDMA helper
> functions.
> >>>
> >>> The driver's device_run() mem2mem op will add each descriptor based
> >>> on how the source and destination queues are set up for the given
> >>> ctx, once the list is prepared, it's submitted to VPDMA, these
> >>> descriptors when parsed by VPDMA will upload MMR registers, start
> >>> DMA of video buffers on the various input and output clients/ports.
> >>>
> >>> When the list is parsed completely(and the DMAs on all the output
> >>> ports done), an interrupt is generated which we use to notify that
> >>> the source and destination buffers are done.
> >>>
> >>> The rest of the driver is quite similar to other mem2mem drivers,
> we
> >>> use the multiplane v4l2 ioctls as the HW support coplanar formats.
> >>>
> >>> Signed-off-by: Archit Taneja <archit@ti.com>
> >>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >
> > Thanks for the Acks. Is it possible to queue these for 3.13?
> >
> > Archit
> >

