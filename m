Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57793 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2FHObi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 10:31:38 -0400
Received: from eusync1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5A006ERZ1J8XA0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Jun 2012 15:32:07 +0100 (BST)
Received: from [106.116.48.223] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M5A00HBLZ0M2N00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Jun 2012 15:31:35 +0100 (BST)
Message-id: <4FD20CC3.9040901@samsung.com>
Date: Fri, 08 Jun 2012 16:31:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Subash Patel <subashrp@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH 04/12] v4l: vb2-dma-contig: add setup of sglist for MMAP
 buffers
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
 <2101386.6sj5B2hAyl@avalon> <4FCF457A.9000201@samsung.com>
 <3066605.JkMnQZX3Q6@avalon> <4FD0BA9D.6010704@gmail.com>
In-reply-to: <4FD0BA9D.6010704@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Subash,

I confirm the issue found by Subash. The function
vb2_dc_kaddr_to_pages does fail for some occasions.
The failures are rather strange like 'got 95 of
150 pages'. It took me some time to find the reason
of the problem.

I found that dma_alloc_coherent for iommu an ARM does
use ioremap_page_range to map a buffer to the kernel
space. The mapping is done by updating the page-table.

The problem is that any process has a different first-level
page-table. The ioremap_page_range updates only the table
for init process. The PT present in current->mm shares
a majority of entries of 1st-level PT at kernel range
(above 0xc0000000) but *not all*. That is why
vb2_dc_kaddr_to_pages worked for small buffers and
occasionally failed for larger buffers.

I found two ways to fix this problem.
a) use &init_mm instead of current->mm while
   creating an artificial vma
b) access the dma memory by calling
   *((volatile int *)kaddr) = 0;
   before calling follow_pfn
   This way a fault is generated and the PT is
   updated by copying entries from init_mm.

What do you think about presented solutions?

Regards,
Tomasz Stanislawski



On 06/07/2012 04:28 PM, Subash Patel wrote:
> Hello Tomasz,
> 
> On 06/07/2012 06:06 AM, Laurent Pinchart wrote:
>> Hi Tomasz,
>>
>> On Wednesday 06 June 2012 13:56:42 Tomasz Stanislawski wrote:
>>> On 06/06/2012 10:06 AM, Laurent Pinchart wrote:
>>>> On Wednesday 23 May 2012 15:07:27 Tomasz Stanislawski wrote:
>>>>> This patch adds the setup of sglist list for MMAP buffers.
>>>>> It is needed for buffer exporting via DMABUF mechanism.
>>>>>
>>>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>> ---
>>>>>
>>>>>   drivers/media/video/videobuf2-dma-contig.c |   70 +++++++++++++++++++++-
>>>>>   1 file changed, 68 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/video/videobuf2-dma-contig.c
>>>>> b/drivers/media/video/videobuf2-dma-contig.c index 52b4f59..ae656be
>>>>> 100644
>>>>> --- a/drivers/media/video/videobuf2-dma-contig.c
>>>>> +++ b/drivers/media/video/videobuf2-dma-contig.c
>>
>> [snip]
>>
>>>>> +static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
>>>>> +    struct page **pages, unsigned int n_pages)
>>>>> +{
>>>>> +    unsigned int i;
>>>>> +    unsigned long pfn;
>>>>> +    struct vm_area_struct vma = {
>>>>> +        .vm_flags = VM_IO | VM_PFNMAP,
>>>>> +        .vm_mm = current->mm,
>>>>> +    };
>>>>> +
>>>>> +    for (i = 0; i<  n_pages; ++i, kaddr += PAGE_SIZE) {
>>>>
>>>> The follow_pfn() kerneldoc mentions that it looks up a PFN for a user
>>>> address. The only users I've found in the kernel sources pass a user
>>>> address. Is it legal to use it for kernel addresses ?
>>>
>>> It is not completely legal :). As I understand the mm code, the follow_pfn
>>> works only for IO/PFN mappings. This is the typical case (every case?) of
>>> mappings created by dma_alloc_coherent.
>>>
>>> In order to make this function work for a kernel pointer, one has to create
>>> an artificial VMA that has IO/PFN bits on.
>>>
>>> This solution is a hack-around for dma_get_pages (aka dma_get_sgtable). This
>>> way the dependency on dma_get_pages was broken giving a small hope of
>>> merging vb2 exporting.
>>>
>>> Marek prepared a patchset 'ARM: DMA-mapping: new extensions for buffer
>>> sharing' that adds dma buffers with no kernel mappings and dma_get_sgtable
>>> function.
>>>
>>> However this patchset is still in a RFC state.
>>
>> That's totally understood :-) I'm fine with keeping the hack for now until the
>> dma_get_sgtable() gets in a usable/mergeable state, please just mention it in
>> the code with something like
>>
>> /* HACK: This is a temporary workaround until the dma_get_sgtable() function
>> becomes available. */
>>
>>> I have prepared a patch that removes vb2_dc_kaddr_to_pages and substitutes
>>> it with dma_get_pages. It will become a part of vb2-exporter patches just
>>> after dma_get_sgtable is merged (or at least acked by major maintainers).
>>
> The above function call (because of follow_pfn) doesn't succeed for all the allocated pages. Hence I created a patch(attached)
> which is based on [1] series. One can apply it for using your present patch-set in the meantime.
> 
> Regards,
> Subash
> [1] http://www.spinics.net/lists/kernel/msg1343092.html

