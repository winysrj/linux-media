Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:60053 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3HBGjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 02:39:14 -0400
Received: by mail-la0-f44.google.com with SMTP id fo12so181136lab.17
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 23:39:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGvmd20MJ_=69kYahkeTySVbhc2GgiUNwCDFXuDWgeGAfQ@mail.gmail.com>
References: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org>
 <5151790.EBRlE0cTxf@flatron> <CAF6AEGvmd20MJ_=69kYahkeTySVbhc2GgiUNwCDFXuDWgeGAfQ@mail.gmail.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Fri, 2 Aug 2013 12:08:52 +0530
Message-ID: <CAD025yRZBDh6ssSUbY-mo2mo-WqrUS3R56bD-QrBvaBbWX_HMQ@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Add check for IOMMU while passing physically
 continous memory flag
To: Rob Clark <robdclark@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, "kgene.kim" <kgene.kim@samsung.com>,
	InKi Dae <inki.dae@samsung.com>,
	"arun.kk" <arun.kk@samsung.com>,
	Patch Tracking <patches@linaro.org>,
	linaro-kernel@lists.linaro.org, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 2 August 2013 06:03, Rob Clark <robdclark@gmail.com> wrote:
> On Thu, Aug 1, 2013 at 7:20 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Vikas,
>>
>> On Thursday 01 of August 2013 16:49:32 Vikas Sajjan wrote:
>>> While trying to get boot-logo up on exynos5420 SMDK which has eDP panel
>>> connected with resolution 2560x1600, following error occured even with
>>> IOMMU enabled:
>>> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate
>>> buffer. [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0
>>>
>>> This patch fixes the issue by adding a check for IOMMU.
>>>
>>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>>> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
>>> ---
>>>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>>> b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c index 8e60bd6..2a86666
>>> 100644
>>> --- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>>> @@ -16,6 +16,7 @@
>>>  #include <drm/drm_crtc.h>
>>>  #include <drm/drm_fb_helper.h>
>>>  #include <drm/drm_crtc_helper.h>
>>> +#include <drm/exynos_drm.h>
>>>
>>>  #include "exynos_drm_drv.h"
>>>  #include "exynos_drm_fb.h"
>>> @@ -143,6 +144,7 @@ static int exynos_drm_fbdev_create(struct
>>> drm_fb_helper *helper, struct platform_device *pdev = dev->platformdev;
>>>       unsigned long size;
>>>       int ret;
>>> +     unsigned int flag;
>>>
>>>       DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
>>>                       sizes->surface_width, sizes->surface_height,
>>> @@ -166,7 +168,12 @@ static int exynos_drm_fbdev_create(struct
>>> drm_fb_helper *helper, size = mode_cmd.pitches[0] * mode_cmd.height;
>>>
>>>       /* 0 means to allocate physically continuous memory */
>>> -     exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
>>> +     if (!is_drm_iommu_supported(dev))
>>> +             flag = 0;
>>> +     else
>>> +             flag = EXYNOS_BO_NONCONTIG;
>>
>> While noncontig memory might be used for devices that support IOMMU, there
>> should be no problem with using contig memory for them, so this seems more
>> like masking the original problem rather than tracking it down.
>
> it is probably a good idea to not require contig memory when it is not
> needed for performance or functionality (and if it is only
> performance, then fallback gracefully to non-contig).. but yeah, would
> be good to know if this is masking another issue all the same
>

Whats happening with CONTIG flag and with IOMMU,  is

 __iommu_alloc_buffer() ---> dma_alloc_from_contiguous() and in this
function it fails at
this condition check  if (pageno >= cma->count)

So I tried increasing the CONFIG_CMA_SIZE_MBYTES to 24,  this check
succeeds and it works well without my patch.

But what about the case where CONFIG_CMA is disabled , yet i want
bigger memory for a device.
 I think using IOMMU we can achieve this.

 correct me, if i am wrong.


> BR,
> -R
>
>> Could you check why the allocation fails when requesting contiguous
>> memory?
>>
>> Best regards,
>> Tomasz
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks and Regards
 Vikas Sajjan
