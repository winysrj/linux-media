Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33373 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363Ab3HBKLG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 06:11:06 -0400
Received: by mail-la0-f48.google.com with SMTP id hi8so299859lab.7
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 03:11:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNBPxBxR-4PXbhOdX0V1inMkauE-xZ+0kwnfVTgqpCEVg@mail.gmail.com>
References: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org>
 <5151790.EBRlE0cTxf@flatron> <CAF6AEGvmd20MJ_=69kYahkeTySVbhc2GgiUNwCDFXuDWgeGAfQ@mail.gmail.com>
 <CAD025yRZBDh6ssSUbY-mo2mo-WqrUS3R56bD-QrBvaBbWX_HMQ@mail.gmail.com> <CAAQKjZNBPxBxR-4PXbhOdX0V1inMkauE-xZ+0kwnfVTgqpCEVg@mail.gmail.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Fri, 2 Aug 2013 15:40:44 +0530
Message-ID: <CAD025yR9Xd0G81WdLDxKyu-RVZPPJAUOKZ+0b5oKUxYOe7q_pQ@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Add check for IOMMU while passing physically
 continous memory flag
To: Inki Dae <inki.dae@samsung.com>
Cc: Rob Clark <robdclark@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, "kgene.kim" <kgene.kim@samsung.com>,
	"arun.kk" <arun.kk@samsung.com>,
	Patch Tracking <patches@linaro.org>,
	linaro-kernel@lists.linaro.org, sunil joshi <joshi@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Inki Dae,

On 2 August 2013 12:58, Inki Dae <inki.dae@samsung.com> wrote:
>
>
> 2013/8/2 Vikas Sajjan <vikas.sajjan@linaro.org>
>>
>> Hi Rob,
>>
>> On 2 August 2013 06:03, Rob Clark <robdclark@gmail.com> wrote:
>> > On Thu, Aug 1, 2013 at 7:20 PM, Tomasz Figa <tomasz.figa@gmail.com>
>> > wrote:
>> >> Hi Vikas,
>> >>
>> >> On Thursday 01 of August 2013 16:49:32 Vikas Sajjan wrote:
>> >>> While trying to get boot-logo up on exynos5420 SMDK which has eDP
>> >>> panel
>> >>> connected with resolution 2560x1600, following error occured even with
>> >>> IOMMU enabled:
>> >>> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate
>> >>> buffer. [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0
>> >>>
>> >>> This patch fixes the issue by adding a check for IOMMU.
>> >>>
>> >>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> >>> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
>> >>> ---
>> >>>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    9 ++++++++-
>> >>>  1 file changed, 8 insertions(+), 1 deletion(-)
>> >>>
>> >>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>> >>> b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c index 8e60bd6..2a86666
>> >>> 100644
>> >>> --- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>> >>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
>> >>> @@ -16,6 +16,7 @@
>> >>>  #include <drm/drm_crtc.h>
>> >>>  #include <drm/drm_fb_helper.h>
>> >>>  #include <drm/drm_crtc_helper.h>
>> >>> +#include <drm/exynos_drm.h>
>> >>>
>> >>>  #include "exynos_drm_drv.h"
>> >>>  #include "exynos_drm_fb.h"
>> >>> @@ -143,6 +144,7 @@ static int exynos_drm_fbdev_create(struct
>> >>> drm_fb_helper *helper, struct platform_device *pdev =
>> >>> dev->platformdev;
>> >>>       unsigned long size;
>> >>>       int ret;
>> >>> +     unsigned int flag;
>> >>>
>> >>>       DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
>> >>>                       sizes->surface_width, sizes->surface_height,
>> >>> @@ -166,7 +168,12 @@ static int exynos_drm_fbdev_create(struct
>> >>> drm_fb_helper *helper, size = mode_cmd.pitches[0] * mode_cmd.height;
>> >>>
>> >>>       /* 0 means to allocate physically continuous memory */
>> >>> -     exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
>> >>> +     if (!is_drm_iommu_supported(dev))
>> >>> +             flag = 0;
>> >>> +     else
>> >>> +             flag = EXYNOS_BO_NONCONTIG;
>> >>
>> >> While noncontig memory might be used for devices that support IOMMU,
>> >> there
>> >> should be no problem with using contig memory for them, so this seems
>> >> more
>> >> like masking the original problem rather than tracking it down.
>> >
>> > it is probably a good idea to not require contig memory when it is not
>> > needed for performance or functionality (and if it is only
>> > performance, then fallback gracefully to non-contig).. but yeah, would
>> > be good to know if this is masking another issue all the same
>> >
>>
>> Whats happening with CONTIG flag and with IOMMU,  is
>>
>>  __iommu_alloc_buffer() ---> dma_alloc_from_contiguous() and in this
>> function it fails at
>> this condition check  if (pageno >= cma->count)
>>
>> So I tried increasing the CONFIG_CMA_SIZE_MBYTES to 24,  this check
>> succeeds and it works well without my patch.
>>
>> But what about the case where CONFIG_CMA is disabled , yet i want
>> bigger memory for a device.
>>  I think using IOMMU we can achieve this.
>>
>>  correct me, if i am wrong.
>>
>
> I'm on summer vacation so I'm afraid that I cannot test and look into it but
> I guess you guy didn't declare CMA region for Exynos drm. And in this case,
> the size of CMA declared region is 16MB as default. That is why works well
> after increasing default size, CONFIG_CMA_SIZE_MBYTES, to 24MB. And I
> mentioned long time ago, we are required to use physically contiguous memory
> in case that bootloader uses physically contiguous memory for its own
> framebuffer, and kernel wants to share the bootloader's framebuffer region
> to resolve flickering issue while booted; that is required for product. And
> one question, is there any reason that you guy should use non-contiguous
> memory for framebuffer with iommu?
>

yeah, we could not allocate CMA region for FIMD, because the function
dma_declare_contiguous() needs "dev" as the first argument and we have
access to "dev" node only if it is NON-DT way of probing like the way
it is done in arch/arm/mach-davinci/devices-da8xx.c
But now, since the probing is through DT way, there is NO way ( Let me
know if something is newly added ) to call dma_declare_contiguous()
and reserve CMA region .

we don't have any specific requirement for NON_CONTIG or CONTIG
memory, but only requirement was to allocate a bigger memory like (
2560 * 1600 * 4 ) for FB.

But as Rob suggested, we should have fall-back case if CONTIG memory
allocation fails, as below

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index df43fa9..15de626 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -144,7 +144,6 @@ static int exynos_drm_fbdev_create(struct
drm_fb_helper *helper,
        struct platform_device *pdev = dev->platformdev;
        unsigned long size;
        int ret;

        DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
                        sizes->surface_width, sizes->surface_height,
@@ -167,16 +166,14 @@ static int exynos_drm_fbdev_create(struct
drm_fb_helper *helper,

        size = mode_cmd.pitches[0] * mode_cmd.height;

-       /* 0 means to allocate physically continuous memory */
-       exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
+       exynos_gem_obj = exynos_drm_gem_create(dev, EXYNOS_BO_CONTIG, size);
        if (IS_ERR(exynos_gem_obj)) {
-               ret = PTR_ERR(exynos_gem_obj);
-               goto err_release_framebuffer;
+               if(is_drm_iommu_supported(dev))
+                       exynos_gem_obj = exynos_drm_gem_create(dev,
EXYNOS_BO_NONCONTIG, size);
+               if (IS_ERR(exynos_gem_obj)) {
+                       ret = PTR_ERR(exynos_gem_obj);
+                       goto err_release_framebuffer;
+               }
+               dev_warn("\n exynos_gem_obj for FB is allocated with
non physically continuous       +               memory \n");
        }



> Thanks,
> Inki Dae
>
>>
>>
>> > BR,
>> > -R
>> >
>> >> Could you check why the allocation fails when requesting contiguous
>> >> memory?
>> >>
>> >> Best regards,
>> >> Tomasz
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Thanks and Regards
>>  Vikas Sajjan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Thanks and Regards
 Vikas Sajjan
