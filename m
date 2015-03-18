Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:37898 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751408AbbCRWny (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 18:43:54 -0400
Message-ID: <5509FF9D.8060106@logicpd.com>
Date: Wed, 18 Mar 2015 17:43:41 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>, <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <2315546.eR07gyadH5@avalon> <55099773.2010809@logicpd.com> <2250003.9yO29CjKoc@avalon> <5509D6BC.6080006@logicpd.com> <5509E6DF.4080900@logicpd.com> <20150318214425.GL11954@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150318214425.GL11954@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/15 16:44, Sakari Ailus wrote:
>
> I don't think omap3isp has been using this very long. A few minor versions
> perhaps.
>
>> Do you know if this common code is supposed to guarantee a
>> physically contiguous memory region?  The documentation for the
>> function doesn't indicate that it should, and it certainly doesn't
>> as-is.  It seems like hitting this issue is highly dependent on the
>> size of the buffer one is allocating.
>
> I guess there aren't too many drivers that may map large areas of memory
> pinned using get_user_pages() to IOMMU. If dma_map_sg() couldn't be used to
> allocate virtually contiguous memory, then what could be? This looks like a
> bug in __iommu_map_sg() to me.
>
> Cc the iommu list.
>

After staring at this for a while, I realized that the mm/dma-mapping.c 
is doing exactly what it's supposed to (and works similarly to how I was 
starting to refactor the outer function) and that the omap3isp driver 
needs to do one further step in initialization.

There is a call dma_set_max_seg_size(...) that defines how the code in 
dma-mapping.c chunks things up.  If it's set larger, the dma-mapping 
routine will allocate larger physically contiguous chunks in the virtual 
memory space.  Any clue where the best place in omap3isp to set this is?

At least it's a short patch to omap3isp to fix this behavior.  I'll be 
sending a patch along shortly.

- Tim

