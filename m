Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59206 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2FKWi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 18:38:58 -0400
Received: by pbbrp8 with SMTP id rp8so6193534pbb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 15:38:57 -0700 (PDT)
Message-ID: <4FD6737E.1040905@gmail.com>
Date: Mon, 11 Jun 2012 15:38:54 -0700
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH 04/12] v4l: vb2-dma-contig: add setup of sglist for MMAP
 buffers
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <4FD0BA9D.6010704@gmail.com> <4FD20CC3.9040901@samsung.com> <2352272.JbolkA93P4@avalon>
In-Reply-To: <2352272.JbolkA93P4@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Tomasz,

On 06/10/2012 11:28 PM, Laurent Pinchart wrote:
> Hi Tomasz,
>
> On Friday 08 June 2012 16:31:31 Tomasz Stanislawski wrote:
>> Hi Laurent and Subash,
>>
>> I confirm the issue found by Subash. The function vb2_dc_kaddr_to_pages does
>> fail for some occasions. The failures are rather strange like 'got 95 of
>> 150 pages'. It took me some time to find the reason of the problem.
>>
>> I found that dma_alloc_coherent for iommu an ARM does use ioremap_page_range
>> to map a buffer to the kernel space. The mapping is done by updating the
>> page-table.
>>
>> The problem is that any process has a different first-level page-table. The
>> ioremap_page_range updates only the table for init process. The PT present
>> in current->mm shares a majority of entries of 1st-level PT at kernel range
>> (above 0xc0000000) but *not all*. That is why vb2_dc_kaddr_to_pages worked
>> for small buffers and occasionally failed for larger buffers.
>>
>> I found two ways to fix this problem.
>> a) use&init_mm instead of current->mm while creating an artificial vma
>> b) access the dma memory by calling
>>     *((volatile int *)kaddr) = 0;
>>     before calling follow_pfn
>>     This way a fault is generated and the PT is
>>     updated by copying entries from init_mm.
>>
>> What do you think about presented solutions?
>
> Just to be sure, this is a hack until dma_get_sgtable is available, and it
> won't make it to mainline, right ?  In that case using init_mm seem easier.
Although I agree adding a hack for timebeing, why not use the 
dma_get_sgtable() RFC itself to solve this in clean way? The hacks 
anyways cannot go into mainline when vb2 patches get merged.

Regards,
Subash
>
