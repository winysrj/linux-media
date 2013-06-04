Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51166 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FDKmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 06:42:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51ADC48E.80907@samsung.com>
Date: Tue, 04 Jun 2013 19:42:22 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for	reimporting
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
 <51A879E0.3080106@samsung.com> <20130531152956.GX15743@phenom.ffwll.local>
In-reply-to: <20130531152956.GX15743@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2013년 06월 01일 00:29, Daniel Vetter wrote:
> On Fri, May 31, 2013 at 07:22:24PM +0900, 김승우 wrote:
>> Hello Daniel,
>>
>> Thanks for your comment.
>>
>> On 2013년 05월 31일 18:14, Daniel Vetter wrote:
>>> On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>>>> importer private data in dma-buf attachment can be used by importer to
>>>> reimport same dma-buf.
>>>>
>>>> Seung-Woo Kim (2):
>>>>   dma-buf: add importer private data to attachment
>>>>   drm/prime: find gem object from the reimported dma-buf
>>>
>>> Self-import should already work (at least with the latest refcount
>>> fixes merged). At least the tests to check both re-import on the same
>>> drm fd and on a different all work as expected now.
>>
>> Currently, prime works well for all case including self-importing,
>> importing, and reimporting as you describe. Just, importing dma-buf from
>> other driver twice with different drm_fd, each import create its own gem
>> object even two import is done for same buffer because prime_priv is in
>> struct drm_file. This means mapping to the device is done also twice.
>> IMHO, these duplicated creations and maps are not necessary if drm can
>> find previous import in different prime_priv.
> 
> Well, that's imo a bug with the other driver. If it doesn't export
> something really simple (e.g. contiguous memory which doesn't require any
> mmio resources at all) it should have a cache of exported dma_buf fds so
> that it hands out the same dma_buf every time.

Hm, all existing dma-buf exporter including i915 driver implements its
map_dma_buf callback as allocating scatter-gather table with pages in
its buffer and calling dma_map_sg() with the sgt. With different
drm_fds, importing one dma-buf *twice*, then importer calls
dma_buf_attach() and dma_buf_map_attachment() twice at least in drm
importer because re-importing case can only checked with prime_priv in
drm_file as I described.

> 
> Or it needs to be more clever in it's dma_buf_attachment_map functions and
> lookup up a pre-existing iommu mapping.
> 
> But dealing with this in the importer is just broken.
> 
>>> Second, the dma_buf_attachment is _definitely_ the wrong place to do
>>> this. If you need iommu mapping caching, that should happen at a lower
>>> level (i.e. in the map_attachment callback somewhere of the exporter,
>>> that's what the priv field in the attachment is for). Snatching away
>>> the attachement from some random other import is certainly not the way
>>> to go - attachements are _not_ refcounted!
>>
>> Yes, attachments do not have refcount, so importer should handle and drm
>> case in my patch, importer private data is gem object and it has, of
>> course, refcount.
>>
>> And at current, exporter can not classify map_dma_buf requests of same
>> importer to same buffer with different attachment because dma_buf_attach
>> always makes new attachments. To resolve this exporter should search all
>> different attachment from same importer of dma-buf and it seems more
>> complex than importer private data to me.
>>
>> If I misunderstood something, please let me know.
> 
> Like I've said above, just fix this in the exporter. If an importer sees
> two different dma_bufs it can very well presume that it those two indeed
> point to different backing storage.

Yes, my patch does not break this concept. I just fixed case importing
_one_ dma-buf twice with different drm_fds.

> 
> This will be even more important if we attach fences two dma_bufs. If your
> broken exporter creates multiple dma_bufs each one of them will have their
> own fences attached, leading to a complete disasters. Ok, strictly
> speaking if you keep the same reservation pointer for each dma_buf it'll
> work, but that's just a detail of how you solve this in the exporter.

I can not understand about broken exporter you addressed. I don't mean
exporter makes dma-bufs from one backing storage.
While, my patch prevents not to create drm gem objects from one back
storage by importing one dma-buf with different drm-fds.

I do not believe the fix of importer is the best way, but at this
moment, I have no idea how I can fix the exporter for this issue.

Best Regards,
- Seung-Woo Kim

> 
> Cheers, Daniel
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

