Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46817 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3HBHXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 03:23:11 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, "kgene.kim" <kgene.kim@samsung.com>,
	InKi Dae <inki.dae@samsung.com>,
	"arun.kk" <arun.kk@samsung.com>,
	Patch Tracking <patches@linaro.org>,
	linaro-kernel@lists.linaro.org, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] drm/exynos: Add check for IOMMU while passing physically continous memory flag
Date: Fri, 02 Aug 2013 09:23:05 +0200
Message-ID: <1599818.BCOnEvhrJr@flatron>
In-Reply-To: <CAD025yRZBDh6ssSUbY-mo2mo-WqrUS3R56bD-QrBvaBbWX_HMQ@mail.gmail.com>
References: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org> <CAF6AEGvmd20MJ_=69kYahkeTySVbhc2GgiUNwCDFXuDWgeGAfQ@mail.gmail.com> <CAD025yRZBDh6ssSUbY-mo2mo-WqrUS3R56bD-QrBvaBbWX_HMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

On Friday 02 of August 2013 12:08:52 Vikas Sajjan wrote:
> Hi Rob,
> 
> On 2 August 2013 06:03, Rob Clark <robdclark@gmail.com> wrote:
> > On Thu, Aug 1, 2013 at 7:20 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> >> Hi Vikas,
> >> 
> >> On Thursday 01 of August 2013 16:49:32 Vikas Sajjan wrote:
> >>> While trying to get boot-logo up on exynos5420 SMDK which has eDP
> >>> panel
> >>> connected with resolution 2560x1600, following error occured even
> >>> with
> >>> IOMMU enabled:
> >>> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate
> >>> buffer. [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor
> >>> 0
> >>> 
> >>> This patch fixes the issue by adding a check for IOMMU.
> >>> 
> >>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> >>> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
> >>> ---
> >>> 
> >>>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    9 ++++++++-
> >>>  1 file changed, 8 insertions(+), 1 deletion(-)
[snip]
> >>> @@ -166,7 +168,12 @@ static int exynos_drm_fbdev_create(struct
> >>> drm_fb_helper *helper, size = mode_cmd.pitches[0] * mode_cmd.height;
> >>> 
> >>>       /* 0 means to allocate physically continuous memory */
> >>> 
> >>> -     exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
> >>> +     if (!is_drm_iommu_supported(dev))
> >>> +             flag = 0;
> >>> +     else
> >>> +             flag = EXYNOS_BO_NONCONTIG;
> >> 
> >> While noncontig memory might be used for devices that support IOMMU,
> >> there should be no problem with using contig memory for them, so
> >> this seems more like masking the original problem rather than
> >> tracking it down.> 
> > it is probably a good idea to not require contig memory when it is not
> > needed for performance or functionality (and if it is only
> > performance, then fallback gracefully to non-contig).. but yeah, would
> > be good to know if this is masking another issue all the same
> 
> Whats happening with CONTIG flag and with IOMMU,  is
> 
>  __iommu_alloc_buffer() ---> dma_alloc_from_contiguous() and in this
> function it fails at
> this condition check  if (pageno >= cma->count)
> 
> So I tried increasing the CONFIG_CMA_SIZE_MBYTES to 24,  this check
> succeeds and it works well without my patch.
> 
> But what about the case where CONFIG_CMA is disabled , yet i want
> bigger memory for a device.
>  I think using IOMMU we can achieve this.
>
>  correct me, if i am wrong.

This is probably fine. I'm not sure about performance aspects of using 
noncontig memory as framebuffer, though. This needs to be checked and if 
there is some performance penalty, I would make noncontig allocation a 
fallback case, if contig fails, as Rob has suggested.

Also I think you should adjust the commit message to say that non-
contiguous memory can be used when IOMMU is supported, so there is no need 
to force contiguous allocations, since this is not a bug fix, but rather a 
feature this patch is adding.

Best regards,
Tomasz
 
> > BR,
> > -R
> > 
> >> Could you check why the allocation fails when requesting contiguous
> >> memory?
> >> 
> >> Best regards,
> >> Tomasz
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-media" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
