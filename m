Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47757 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab2FGO2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 10:28:53 -0400
Received: by pbbrp8 with SMTP id rp8so1148082pbb.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 07:28:53 -0700 (PDT)
Message-ID: <4FD0BA9D.6010704@gmail.com>
Date: Thu, 07 Jun 2012 19:58:45 +0530
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
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <2101386.6sj5B2hAyl@avalon> <4FCF457A.9000201@samsung.com> <3066605.JkMnQZX3Q6@avalon>
In-Reply-To: <3066605.JkMnQZX3Q6@avalon>
Content-Type: multipart/mixed;
 boundary="------------080106050707070506020705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080106050707070506020705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Tomasz,

On 06/07/2012 06:06 AM, Laurent Pinchart wrote:
> Hi Tomasz,
>
> On Wednesday 06 June 2012 13:56:42 Tomasz Stanislawski wrote:
>> On 06/06/2012 10:06 AM, Laurent Pinchart wrote:
>>> On Wednesday 23 May 2012 15:07:27 Tomasz Stanislawski wrote:
>>>> This patch adds the setup of sglist list for MMAP buffers.
>>>> It is needed for buffer exporting via DMABUF mechanism.
>>>>
>>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>> ---
>>>>
>>>>   drivers/media/video/videobuf2-dma-contig.c |   70 +++++++++++++++++++++-
>>>>   1 file changed, 68 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/videobuf2-dma-contig.c
>>>> b/drivers/media/video/videobuf2-dma-contig.c index 52b4f59..ae656be
>>>> 100644
>>>> --- a/drivers/media/video/videobuf2-dma-contig.c
>>>> +++ b/drivers/media/video/videobuf2-dma-contig.c
>
> [snip]
>
>>>> +static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
>>>> +	struct page **pages, unsigned int n_pages)
>>>> +{
>>>> +	unsigned int i;
>>>> +	unsigned long pfn;
>>>> +	struct vm_area_struct vma = {
>>>> +		.vm_flags = VM_IO | VM_PFNMAP,
>>>> +		.vm_mm = current->mm,
>>>> +	};
>>>> +
>>>> +	for (i = 0; i<  n_pages; ++i, kaddr += PAGE_SIZE) {
>>>
>>> The follow_pfn() kerneldoc mentions that it looks up a PFN for a user
>>> address. The only users I've found in the kernel sources pass a user
>>> address. Is it legal to use it for kernel addresses ?
>>
>> It is not completely legal :). As I understand the mm code, the follow_pfn
>> works only for IO/PFN mappings. This is the typical case (every case?) of
>> mappings created by dma_alloc_coherent.
>>
>> In order to make this function work for a kernel pointer, one has to create
>> an artificial VMA that has IO/PFN bits on.
>>
>> This solution is a hack-around for dma_get_pages (aka dma_get_sgtable). This
>> way the dependency on dma_get_pages was broken giving a small hope of
>> merging vb2 exporting.
>>
>> Marek prepared a patchset 'ARM: DMA-mapping: new extensions for buffer
>> sharing' that adds dma buffers with no kernel mappings and dma_get_sgtable
>> function.
>>
>> However this patchset is still in a RFC state.
>
> That's totally understood :-) I'm fine with keeping the hack for now until the
> dma_get_sgtable() gets in a usable/mergeable state, please just mention it in
> the code with something like
>
> /* HACK: This is a temporary workaround until the dma_get_sgtable() function
> becomes available. */
>
>> I have prepared a patch that removes vb2_dc_kaddr_to_pages and substitutes
>> it with dma_get_pages. It will become a part of vb2-exporter patches just
>> after dma_get_sgtable is merged (or at least acked by major maintainers).
>
The above function call (because of follow_pfn) doesn't succeed for all 
the allocated pages. Hence I created a patch(attached) which is based on 
[1] series. One can apply it for using your present patch-set in the 
meantime.

Regards,
Subash
[1] http://www.spinics.net/lists/kernel/msg1343092.html

--------------080106050707070506020705
Content-Type: text/x-patch;
 name="0001-v4l2-vb2-use-dma_get_sgtable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-v4l2-vb2-use-dma_get_sgtable.patch"

>From f9b2eace2eef0038a1830e5e6dd55f3bb6017e1a Mon Sep 17 00:00:00 2001
From: Subash Patel <subash.ramaswamy@linaro.org>
Date: Thu, 7 Jun 2012 19:49:10 +0530
Subject: [PATCH] v4l2: vb2: use dma_get_sgtable

This is patch to remove vb2_dc_kaddr_to_pages() function with dma_get_sgtable()
in the patch set posted by Tomasz. It was observed that the former function
fails to get the pages, as follow_pfn() can fail for remapped kernel va provided
by the dma-mapping sub-system.

As Tomasz mentioned, the later call was temporary patch until dma-mapping author
finalizes the implementation of dma_get_sgtable(). One can use this patch to use
this vb2 patch-set for his/her work in the meantime.

Signed-off-by: Subash Patel <subash.ramaswamy@linaro.org>
---
 drivers/media/video/videobuf2-dma-contig.c |   53 ++-------------------------
 1 files changed, 4 insertions(+), 49 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index e8da7f1..1b9023a 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -143,32 +143,11 @@ static void vb2_dc_put(void *buf_priv)
 	kfree(buf);
 }
 
-static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
-	struct page **pages, unsigned int n_pages)
-{
-	unsigned int i;
-	unsigned long pfn;
-	struct vm_area_struct vma = {
-		.vm_flags = VM_IO | VM_PFNMAP,
-		.vm_mm = current->mm,
-	};
-
-	for (i = 0; i < n_pages; ++i, kaddr += PAGE_SIZE) {
-		if (follow_pfn(&vma, kaddr, &pfn))
-			break;
-		pages[i] = pfn_to_page(pfn);
-	}
-
-	return i;
-}
-
 static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 {
 	struct device *dev = alloc_ctx;
 	struct vb2_dc_buf *buf;
 	int ret = -ENOMEM;
-	int n_pages;
-	struct page **pages = NULL;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -183,35 +162,14 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 	WARN_ON((unsigned long)buf->vaddr & ~PAGE_MASK);
 	WARN_ON(buf->dma_addr & ~PAGE_MASK);
 
-	n_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	ret = dma_get_sgtable(dev, &buf->sgt_base, buf->vaddr,
+						buf->dma_addr, size, NULL);
 
-	pages = kmalloc(n_pages * sizeof pages[0], GFP_KERNEL);
-	if (!pages) {
-		dev_err(dev, "failed to alloc page table\n");
-		goto fail_dma;
-	}
-
-	ret = vb2_dc_kaddr_to_pages((unsigned long)buf->vaddr, pages, n_pages);
 	if (ret < 0) {
-		dev_err(dev, "failed to get buffer pages from DMA API\n");
-		goto fail_pages;
-	}
-	if (ret != n_pages) {
-		ret = -EFAULT;
-		dev_err(dev, "failed to get all pages from DMA API\n");
-		goto fail_pages;
-	}
-
-	ret = sg_alloc_table_from_pages(&buf->sgt_base,
-		pages, n_pages, 0, size, GFP_KERNEL);
-	if (ret) {
-		dev_err(dev, "failed to prepare sg table\n");
-		goto fail_pages;
+		dev_err(dev, "failed to get the SGT for the allocated pages\n");
+		goto fail_dma;
 	}
 
-	/* pages are no longer needed */
-	kfree(pages);
-
 	buf->dev = dev;
 	buf->size = size;
 
@@ -223,9 +181,6 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size)
 
 	return buf;
 
-fail_pages:
-	kfree(pages);
-
 fail_dma:
 	dma_free_coherent(dev, size, buf->vaddr, buf->dma_addr);
 
-- 
1.7.5.4


--------------080106050707070506020705--
