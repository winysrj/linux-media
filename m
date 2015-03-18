Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:35189 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964930AbbCRU6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 16:58:20 -0400
Message-ID: <5509E6DF.4080900@logicpd.com>
Date: Wed, 18 Mar 2015 15:58:07 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <2315546.eR07gyadH5@avalon> <55099773.2010809@logicpd.com> <2250003.9yO29CjKoc@avalon> <5509D6BC.6080006@logicpd.com>
In-Reply-To: <5509D6BC.6080006@logicpd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent -

On 03/18/15 14:49, Tim Nordell wrote:
> Digging through to find who is responsible for assigning the virtual
> addresses, I find that it's buried inside
> arch/arm/mm/dma-mapping.c:__alloc_iova(...).  This call is called
> individually for each entry in the scatter-gather table via
> __map_sg_chunk from iommu_map_sg(...).  If this is supposed to allocate
> a contiguous virtual memory region, it seems that __iommu_map_sg(...)
> should be considering the full buffer range rather than parts of the
> buffer at a time for the virtual allocation, similar to how
> __iommu_create_mapping(...) works in the same file.
>
> - Tim
>

I've confirmed that this code is the culprit for allocating a 
non-contiguous space (called via the dma_map_sg_attrs(...) back down in 
the videobuf2-dma-contig).  I've reworked it for testing so that it does 
an __alloc_iova(...) on the entire region rather than a chunk at a time, 
however, I don't think what I have locally is completely the right 
approach for the generic case since I think technically a given entry in 
the scatterlist could end up with the end of a page partially used (the 
per list entry ->offset and such).

Looks like code (the specific functions in mm/dma-mapping.c) in question 
was last touched in 2012 with a quick git-blame, but I don't know how 
long the OMAP 3 ISP code has been using this common code.  I'm guessing 
it's only been since the virtual memory manager internal to the IOMMU 
code was removed in July of last year.

Do you know if this common code is supposed to guarantee a physically 
contiguous memory region?  The documentation for the function doesn't 
indicate that it should, and it certainly doesn't as-is.  It seems like 
hitting this issue is highly dependent on the size of the buffer one is 
allocating.

- Tim

