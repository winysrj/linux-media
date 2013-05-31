Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39176 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3EaKWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:22:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51A879E0.3080106@samsung.com>
Date: Fri, 31 May 2013 19:22:24 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for reimporting
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
In-reply-to: <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel,

Thanks for your comment.

On 2013년 05월 31일 18:14, Daniel Vetter wrote:
> On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>> importer private data in dma-buf attachment can be used by importer to
>> reimport same dma-buf.
>>
>> Seung-Woo Kim (2):
>>   dma-buf: add importer private data to attachment
>>   drm/prime: find gem object from the reimported dma-buf
> 
> Self-import should already work (at least with the latest refcount
> fixes merged). At least the tests to check both re-import on the same
> drm fd and on a different all work as expected now.

Currently, prime works well for all case including self-importing,
importing, and reimporting as you describe. Just, importing dma-buf from
other driver twice with different drm_fd, each import create its own gem
object even two import is done for same buffer because prime_priv is in
struct drm_file. This means mapping to the device is done also twice.
IMHO, these duplicated creations and maps are not necessary if drm can
find previous import in different prime_priv.

> 
> Second, the dma_buf_attachment is _definitely_ the wrong place to do
> this. If you need iommu mapping caching, that should happen at a lower
> level (i.e. in the map_attachment callback somewhere of the exporter,
> that's what the priv field in the attachment is for). Snatching away
> the attachement from some random other import is certainly not the way
> to go - attachements are _not_ refcounted!

Yes, attachments do not have refcount, so importer should handle and drm
case in my patch, importer private data is gem object and it has, of
course, refcount.

And at current, exporter can not classify map_dma_buf requests of same
importer to same buffer with different attachment because dma_buf_attach
always makes new attachments. To resolve this exporter should search all
different attachment from same importer of dma-buf and it seems more
complex than importer private data to me.

If I misunderstood something, please let me know.

Best Regards,
- Seung-Woo Kim

> -Daniel
> 
>>
>>  drivers/base/dma-buf.c                     |   31 ++++++++++++++++++++++++++++
>>  drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++----
>>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
>>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
>>  drivers/gpu/drm/udl/udl_gem.c              |    1 +
>>  include/linux/dma-buf.h                    |    4 +++
>>  6 files changed, 52 insertions(+), 5 deletions(-)
>>
>> --
>> 1.7.4.1
>>
> 
> 
> 
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

