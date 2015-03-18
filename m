Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47184 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbCRPVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 11:21:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
Date: Wed, 18 Mar 2015 17:21:24 +0200
Message-ID: <2250003.9yO29CjKoc@avalon>
In-Reply-To: <55099773.2010809@logicpd.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <2315546.eR07gyadH5@avalon> <55099773.2010809@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Wednesday 18 March 2015 10:19:15 Tim Nordell wrote:
> Laurent -
> 
> On 03/18/15 09:59, Laurent Pinchart wrote:
> > Hi Tim,
> > The names might be a bit misleading, vb2-dma-contig requires contiguous
> > memory in the device memory space, not in physical memory. The IOMMU,
> > managed through dma_map_sg_attrs, should have mapped the userptr buffer
> > contiguously in the ISP DMA address space. If it hasn't, that's what need
> > to be investigated.
>
> I see now that it's the sg_dma_address(...) call that it's using and I
> was assuming that was the physical memory address for the memory backing
> up the buffer.
> 
> So the vb2_dc_get_contiguous_size(...) should be against the view of
> memory that the IOMMU presents to the OMAP3 ISP?  That is, the DMA
> addresses that the OMAP3 ISP can see?

Correct. sg_dma_address() should contain the DMA virtual address when an IOMMU 
is used.

> I was assuming it was checking the physical memory layout to it without
> looking too closely to the code.  Armed with that knowledge, I'll dig a
> little deeper to see if I can figure out what happened here.

Thank you.

-- 
Regards,

Laurent Pinchart

