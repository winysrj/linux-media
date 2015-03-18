Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49121 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965043AbbCRVo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 17:44:29 -0400
Date: Wed, 18 Mar 2015 23:44:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
Message-ID: <20150318214425.GL11954@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <2315546.eR07gyadH5@avalon>
 <55099773.2010809@logicpd.com>
 <2250003.9yO29CjKoc@avalon>
 <5509D6BC.6080006@logicpd.com>
 <5509E6DF.4080900@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5509E6DF.4080900@logicpd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Wed, Mar 18, 2015 at 03:58:07PM -0500, Tim Nordell wrote:
> Laurent -
> 
> On 03/18/15 14:49, Tim Nordell wrote:
> >Digging through to find who is responsible for assigning the virtual
> >addresses, I find that it's buried inside
> >arch/arm/mm/dma-mapping.c:__alloc_iova(...).  This call is called
> >individually for each entry in the scatter-gather table via
> >__map_sg_chunk from iommu_map_sg(...).  If this is supposed to allocate
> >a contiguous virtual memory region, it seems that __iommu_map_sg(...)
> >should be considering the full buffer range rather than parts of the
> >buffer at a time for the virtual allocation, similar to how
> >__iommu_create_mapping(...) works in the same file.
> >
> >- Tim
> >
> 
> I've confirmed that this code is the culprit for allocating a
> non-contiguous space (called via the dma_map_sg_attrs(...) back down
> in the videobuf2-dma-contig).  I've reworked it for testing so that
> it does an __alloc_iova(...) on the entire region rather than a
> chunk at a time, however, I don't think what I have locally is
> completely the right approach for the generic case since I think
> technically a given entry in the scatterlist could end up with the
> end of a page partially used (the per list entry ->offset and such).
> 
> Looks like code (the specific functions in mm/dma-mapping.c) in
> question was last touched in 2012 with a quick git-blame, but I
> don't know how long the OMAP 3 ISP code has been using this common
> code.  I'm guessing it's only been since the virtual memory manager
> internal to the IOMMU code was removed in July of last year.

I don't think omap3isp has been using this very long. A few minor versions
perhaps.

> Do you know if this common code is supposed to guarantee a
> physically contiguous memory region?  The documentation for the
> function doesn't indicate that it should, and it certainly doesn't
> as-is.  It seems like hitting this issue is highly dependent on the
> size of the buffer one is allocating.

I guess there aren't too many drivers that may map large areas of memory
pinned using get_user_pages() to IOMMU. If dma_map_sg() couldn't be used to
allocate virtually contiguous memory, then what could be? This looks like a
bug in __iommu_map_sg() to me.

Cc the iommu list.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
