Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35207 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbaD1T0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 15:26:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	pullip.cho@samsung.com
Subject: Re: [PATCH] [media] s5p-mfc: Add IOMMU support
Date: Mon, 28 Apr 2014 20:10:01 +0200
Message-ID: <2254307.lxG3Pzerbn@avalon>
In-Reply-To: <CALt3h79VnDH17s51FQQUK7O_to7pA1-KU0HW8JY2WAqOP4rBRA@mail.gmail.com>
References: <1398164568-6048-1-git-send-email-arun.kk@samsung.com> <2748799.75z4m0MVI7@avalon> <CALt3h79VnDH17s51FQQUK7O_to7pA1-KU0HW8JY2WAqOP4rBRA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On Tuesday 22 April 2014 17:52:08 Arun Kumar K wrote:
> On Tue, Apr 22, 2014 at 5:23 PM, Laurent Pinchart wrote:
> > On Tuesday 22 April 2014 16:32:48 Arun Kumar K wrote:
> >> The patch adds IOMMU support for MFC driver.
> > 
> > I've been working on an IOMMU driver lately, which led me to think about
> > how drivers should be interfaced with IOMMUs. Runtime IOMMU handling is
> > performed by the DMA mapping API, but in many cases (including Exynos
> > platforms) the arm_iommu_create_mapping() and arm_iommu_attach_device()
> > functions still need to be called explicitly by drivers, which doesn't
> > seem a very good idea to me. Ideally IOMMU usage should be completely
> > transparent for bus master drivers, without requiring any driver
> > modification to use the IOMMU.
> > 
> > What would you think about improving the Exynos IOMMU driver to create the
> > mapping and attach the device instead of having to modify all bus master
> > drivers ? See the ipmmu_add_device() function in
> > http://www.spinics.net/lists/linux-sh/msg30488.html for a possible
> > implementation.
> 
> Yes that would be a better solution. But as far as I know, exynos platforms
> has few more complications where multiple IOMMUs are present for single IP.
> The exynos iommu work is still under progress and KyonHo Cho will have some
> inputs / comments on this. This seems to me a valid usecase which can be
> considered for exynos iommu also.

Thank you. Just to be clear, I don't see a reason to delay this patch until 
the Exynos IOMMU driver gets support for creating mappings and attaching 
devices, but it would be nice to see that happen as a cleanup in the not too 
distant future.

> >> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> >> ---
> >> This patch is tested on IOMMU support series [1] posted
> >> by KyonHo Cho.
> >> [1] https://lkml.org/lkml/2014/3/14/9
> >> ---
> >> 
> >>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   33
> >>  +++++++++++++++++++++++++++
> >>  1 file changed, 33 insertions(+)
> >> 
> >> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> >> b/drivers/media/platform/s5p-mfc/s5p_mfc.c index 89356ae..1f248ba 100644
> >> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> >> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> >> @@ -32,11 +32,18 @@
> >> 
> >>  #include "s5p_mfc_opr.h"
> >>  #include "s5p_mfc_cmd.h"
> >>  #include "s5p_mfc_pm.h"
> >> 
> >> +#ifdef CONFIG_EXYNOS_IOMMU
> >> +#include <asm/dma-iommu.h>
> >> +#endif
> >> 
> >>  #define S5P_MFC_NAME         "s5p-mfc"
> >>  #define S5P_MFC_DEC_NAME     "s5p-mfc-dec"
> >>  #define S5P_MFC_ENC_NAME     "s5p-mfc-enc"
> >> 
> >> +#ifdef CONFIG_EXYNOS_IOMMU
> >> +static struct dma_iommu_mapping *mapping;
> >> +#endif
> >> +
> >> 
> >>  int debug;
> >>  module_param(debug, int, S_IRUGO | S_IWUSR);
> >>  MODULE_PARM_DESC(debug, "Debug level - higher value produces more
> >>  verbose
> >> 
> >> messages"); @@ -1013,6 +1020,23 @@ static void *mfc_get_drv_data(struct
> >> platform_device *pdev);
> >> 
> >>  static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
> >>  {
> >> 
> >> +#ifdef CONFIG_EXYNOS_IOMMU
> >> +     struct device *mdev = &dev->plat_dev->dev;
> >> +
> >> +     mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
> >> +                     SZ_256M);
> >> +     if (mapping == NULL) {
> >> +             mfc_err("IOMMU mapping failed\n");
> >> +             return -EFAULT;
> >> +     }
> >> +     mdev->dma_parms = devm_kzalloc(&dev->plat_dev->dev,
> >> +                     sizeof(*mdev->dma_parms), GFP_KERNEL);
> >> +     dma_set_max_seg_size(mdev, 0xffffffffu);
> >> +     arm_iommu_attach_device(mdev, mapping);
> >> +
> >> +     dev->mem_dev_l = dev->mem_dev_r = mdev;
> >> +     return 0;
> >> +#else
> >> 
> >>       unsigned int mem_info[2] = { };
> >>       
> >>       dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
> >> 
> >> @@ -1049,6 +1073,7 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev
> >> *dev) return -ENOMEM;
> >> 
> >>       }
> >>       return 0;
> >> 
> >> +#endif
> >> 
> >>  }
> >>  
> >>  /* MFC probe function */
> >> 
> >> @@ -1228,6 +1253,10 @@ err_mem_init_ctx_1:
> >>       vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
> >>  
> >>  err_res:
> >>       s5p_mfc_final_pm(dev);
> >> 
> >> +#ifdef CONFIG_EXYNOS_IOMMU
> >> +     if (mapping)
> >> +             arm_iommu_release_mapping(mapping);
> >> +#endif
> >> 
> >>       pr_debug("%s-- with error\n", __func__);
> >>       return ret;
> >> 
> >> @@ -1256,6 +1285,10 @@ static int s5p_mfc_remove(struct platform_device
> >> *pdev) put_device(dev->mem_dev_r);
> >> 
> >>       }
> >> 
> >> +#ifdef CONFIG_EXYNOS_IOMMU
> >> +     if (mapping)
> >> +             arm_iommu_release_mapping(mapping);
> >> +#endif
> >> 
> >>       s5p_mfc_final_pm(dev);
> >>       return 0;
> >>  
> >>  }

-- 
Regards,

Laurent Pinchart

