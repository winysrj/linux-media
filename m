Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:33055 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964937AbbCRTt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 15:49:27 -0400
Message-ID: <5509D6BC.6080006@logicpd.com>
Date: Wed, 18 Mar 2015 14:49:16 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <2315546.eR07gyadH5@avalon> <55099773.2010809@logicpd.com> <2250003.9yO29CjKoc@avalon>
In-Reply-To: <2250003.9yO29CjKoc@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent -

On 03/18/15 10:21, Laurent Pinchart wrote:
> Correct. sg_dma_address() should contain the DMA virtual address when 
> an IOMMU is used.
>> I was assuming it was checking the physical memory layout to it without
>> looking too closely to the code.  Armed with that knowledge, I'll dig a
>> little deeper to see if I can figure out what happened here.
I added a bit of code to where it was printing out the error code to 
print out the mapping as vb2_dc_get_contiguous_size(...) sees it.  I get 
back the following:

[  200.031249] sgt[0].addr = 0x400a0000 - 0x400affff
[  200.031280] sgt[1].addr = 0x400b0000 - 0x400bffff
[  200.031311] sgt[2].addr = 0x400c0000 - 0x400cffff
[  200.031341] sgt[3].addr = 0x400d0000 - 0x400dffff
[  200.031372] sgt[4].addr = 0x400e0000 - 0x400effff
[  200.031402] sgt[5].addr = 0x400f0000 - 0x400fffff
[  200.031433] sgt[6].addr = 0x40100000 - 0x4010ffff
[  200.031463] sgt[7].addr = 0x40110000 - 0x4011ffff
[  200.031494] sgt[8].addr = 0x40120000 - 0x4012ffff
[  200.031524] sgt[9].addr = 0x40098000 - 0x4009dfff
[  200.031524] contiguous mapping is too small 589824/614400

Notice that the last section is completely off the wall compared to the 
rest?

Digging through to find who is responsible for assigning the virtual 
addresses, I find that it's buried inside 
arch/arm/mm/dma-mapping.c:__alloc_iova(...).  This call is called 
individually for each entry in the scatter-gather table via 
__map_sg_chunk from iommu_map_sg(...).  If this is supposed to allocate 
a contiguous virtual memory region, it seems that __iommu_map_sg(...) 
should be considering the full buffer range rather than parts of the 
buffer at a time for the virtual allocation, similar to how 
__iommu_create_mapping(...) works in the same file.

- Tim

