Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57269 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854AbbBDNuy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 08:50:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Florian Echtler <floe@butterbrot.org>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
Date: Wed, 04 Feb 2015 15:51:39 +0200
Message-ID: <6748039.PVCT6ajhMk@avalon>
In-Reply-To: <54D204F2.3040006@xs4all.nl>
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <10701805.dDfTQCs2MO@avalon> <54D204F2.3040006@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 04 February 2015 12:39:30 Hans Verkuil wrote:
> On 02/04/15 12:34, Laurent Pinchart wrote:
> > On Wednesday 04 February 2015 11:56:58 Florian Echtler wrote:
> >> On 04.02.2015 11:22, Hans Verkuil wrote:
> >>> On 02/04/15 11:08, Florian Echtler wrote:
> >>>> On 04.02.2015 09:08, Hans Verkuil wrote:
> >>>>> You can also make a version with vmalloc and I'll merge that, and then
> >>>>> you can look more into the DMA issues. That way the driver is merged,
> >>>>> even if it is perhaps not yet optimal, and you can address that part
> >>>>> later.
> >>>> 
> >>>> OK, that sounds sensible, I will try that route. When using
> >>>> videobuf2-vmalloc, what do I pass back for alloc_ctxs in queue_setup?
> >>> 
> >>> vmalloc doesn't need those, so you can just drop any alloc_ctx related
> >>> code.
> >> 
> >> That's what I assumed, however, I'm running into the same problem as
> >> with dma-sg when I switch to vmalloc...?
> > 
> > I don't expect vmalloc to work, as you can't DMA to vmalloc memory
> > directly without any IOMMU in the general case (the allocated memory being
> > physically fragmented).
> > 
> > dma-sg should work though, but you won't be able to use usb_bulk_msg().
> > You need to create the URBs manually, set their sg and num_sgs fields and
> > submit them.
> 
> So it works for other usb media drivers because they allocate memory
> using kmalloc (and presumably the usb core can DMA to that), and then memcpy
> it to the vmalloc-ed buffers?

Correct. In the uvcvideo case that's unavoidable as headers need to be removed 
from the packets.

> Anyway Florian, based on Laurent's explanation I think trying to make
> dma-sg work seems to be the best solution. And I've learned something
> new :-)

-- 
Regards,

Laurent Pinchart

