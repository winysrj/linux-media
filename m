Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab2JSJkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 05:40:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
Date: Fri, 19 Oct 2012 11:40:54 +0200
Message-ID: <2071397.IU49JkAq1T@avalon>
In-Reply-To: <20121018202842.11834.14375.stgit@muffinssi.local>
References: <20121018202707.11834.1438.stgit@muffinssi.local> <20121018202842.11834.14375.stgit@muffinssi.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

Thanks for the patch.

On Thursday 18 October 2012 13:28:42 Tony Lindgren wrote:
> Looks like the iommu framework does not have generic functions
> exported for all the needs yet. The hardware specific functions
> are defined in files like intel-iommu.h and amd-iommu.h. Follow
> the same standard for omap-iommu.h.
> 
> This is needed because we are removing plat and mach includes
> for ARM common zImage support. Further work should continue
> in the iommu framework context as only pure platform data will
> be communicated from arch/arm/*omap*/* code to the iommu
> framework.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Ido Yariv <ido@wizery.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Omar Ramirez Luna <omar.luna@linaro.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/iommu2.c               |    1
>  arch/arm/plat-omap/include/plat/iommu.h    |   10 +--
>  arch/arm/plat-omap/include/plat/iovmm.h    |   89 -------------------------
>  drivers/iommu/omap-iommu-debug.c           |    2 -
>  drivers/iommu/omap-iommu.c                 |    1
>  drivers/iommu/omap-iovmm.c                 |   46 ++++++++++++++
>  drivers/media/platform/omap3isp/isp.c      |    1
>  drivers/media/platform/omap3isp/isp.h      |    2 -
>  drivers/media/platform/omap3isp/ispccdc.c  |    1
>  drivers/media/platform/omap3isp/ispstat.c  |    1
>  drivers/media/platform/omap3isp/ispvideo.c |    2 -
>  include/linux/omap-iommu.h                 |   47 +++++++++++++++
>  12 files changed, 101 insertions(+), 102 deletions(-)
>  delete mode 100644 arch/arm/plat-omap/include/plat/iovmm.h
>  create mode 100644 include/linux/omap-iommu.h
> 
> diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
> index eefc379..77cbf2f 100644
> --- a/arch/arm/mach-omap2/iommu2.c
> +++ b/arch/arm/mach-omap2/iommu2.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/stringify.h>
> +#include <linux/omap-iommu.h>

Nitpicking, please keep the headers sorted alphabetically, here and in all 
locations below (especially the OMAP3 ISP driver).

(OK, there's already one misplaced #include, but let's not make it worse :-))

>  #include <plat/iommu.h>
> 
> diff --git a/arch/arm/plat-omap/include/plat/iommu.h
> b/arch/arm/plat-omap/include/plat/iommu.h index 7e8c7b6..a4b71b1 100644
> --- a/arch/arm/plat-omap/include/plat/iommu.h
> +++ b/arch/arm/plat-omap/include/plat/iommu.h
> @@ -216,13 +216,10 @@ static inline struct omap_iommu
> *dev_to_omap_iommu(struct device *dev) #define MMU_RAM_PADDR_SHIFT	12
>  #define MMU_RAM_PADDR_MASK \
>  	((~0UL >> MMU_RAM_PADDR_SHIFT) << MMU_RAM_PADDR_SHIFT)
> -#define MMU_RAM_ENDIAN_SHIFT	9
> +
>  #define MMU_RAM_ENDIAN_MASK	(1 << MMU_RAM_ENDIAN_SHIFT)
> -#define MMU_RAM_ENDIAN_BIG	(1 << MMU_RAM_ENDIAN_SHIFT)
> -#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
> -#define MMU_RAM_ELSZ_SHIFT	7
>  #define MMU_RAM_ELSZ_MASK	(3 << MMU_RAM_ELSZ_SHIFT)
> -#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
> +
>  #define MMU_RAM_ELSZ_16		(1 << MMU_RAM_ELSZ_SHIFT)
>  #define MMU_RAM_ELSZ_32		(2 << MMU_RAM_ELSZ_SHIFT)
>  #define MMU_RAM_ELSZ_NONE	(3 << MMU_RAM_ELSZ_SHIFT)

I plan to push cleanup patches for the staging tidspbridge driver that get rid 
of the local register definitions and use plat/iommu.h instead. That's 
obviously an interim solution as in the long run the driver should use the 
IOMMU API, but in the meantime it's a step in the right direction. Would it 
then make sense to move all those definitions to include/linux/omap-iommu.h, 
not just the ones used by the OMAP3 ISP driver ?

> @@ -269,9 +266,6 @@ extern int omap_iommu_set_isr(const char *name,
>  				    void *priv),
>  			 void *isr_priv);
> 
> -extern void omap_iommu_save_ctx(struct device *dev);
> -extern void omap_iommu_restore_ctx(struct device *dev);
> -
>  extern int omap_install_iommu_arch(const struct iommu_functions *ops);
>  extern void omap_uninstall_iommu_arch(const struct iommu_functions *ops);
> 
> diff --git a/arch/arm/plat-omap/include/plat/iovmm.h
> b/arch/arm/plat-omap/include/plat/iovmm.h deleted file mode 100644
> index 498e57c..0000000
> --- a/arch/arm/plat-omap/include/plat/iovmm.h
> +++ /dev/null
> @@ -1,89 +0,0 @@
> -/*
> - * omap iommu: simple virtual address space management
> - *
> - * Copyright (C) 2008-2009 Nokia Corporation
> - *
> - * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __IOMMU_MMAP_H
> -#define __IOMMU_MMAP_H
> -
> -#include <linux/iommu.h>
> -
> -struct iovm_struct {
> -	struct omap_iommu	*iommu;	/* iommu object which this belongs to */
> -	u32			da_start; /* area definition */
> -	u32			da_end;
> -	u32			flags; /* IOVMF_: see below */
> -	struct list_head	list; /* linked in ascending order */
> -	const struct sg_table	*sgt; /* keep 'page' <-> 'da' mapping */
> -	void			*va; /* mpu side mapped address */
> -};
> -
> -/*
> - * IOVMF_FLAGS: attribute for iommu virtual memory area(iovma)
> - *
> - * lower 16 bit is used for h/w and upper 16 bit is for s/w.
> - */
> -#define IOVMF_SW_SHIFT		16
> -
> -/*
> - * iovma: h/w flags derived from cam and ram attribute
> - */
> -#define IOVMF_CAM_MASK		(~((1 << 10) - 1))
> -#define IOVMF_RAM_MASK		(~IOVMF_CAM_MASK)
> -
> -#define IOVMF_PGSZ_MASK		(3 << 0)
> -#define IOVMF_PGSZ_1M		MMU_CAM_PGSZ_1M
> -#define IOVMF_PGSZ_64K		MMU_CAM_PGSZ_64K
> -#define IOVMF_PGSZ_4K		MMU_CAM_PGSZ_4K
> -#define IOVMF_PGSZ_16M		MMU_CAM_PGSZ_16M
> -
> -#define IOVMF_ENDIAN_MASK	(1 << 9)
> -#define IOVMF_ENDIAN_BIG	MMU_RAM_ENDIAN_BIG
> -#define IOVMF_ENDIAN_LITTLE	MMU_RAM_ENDIAN_LITTLE
> -
> -#define IOVMF_ELSZ_MASK		(3 << 7)
> -#define IOVMF_ELSZ_8		MMU_RAM_ELSZ_8
> -#define IOVMF_ELSZ_16		MMU_RAM_ELSZ_16
> -#define IOVMF_ELSZ_32		MMU_RAM_ELSZ_32
> -#define IOVMF_ELSZ_NONE		MMU_RAM_ELSZ_NONE
> -
> -#define IOVMF_MIXED_MASK	(1 << 6)
> -#define IOVMF_MIXED		MMU_RAM_MIXED
> -
> -/*
> - * iovma: s/w flags, used for mapping and umapping internally.
> - */
> -#define IOVMF_MMIO		(1 << IOVMF_SW_SHIFT)
> -#define IOVMF_ALLOC		(2 << IOVMF_SW_SHIFT)
> -#define IOVMF_ALLOC_MASK	(3 << IOVMF_SW_SHIFT)
> -
> -/* "superpages" is supported just with physically linear pages */
> -#define IOVMF_DISCONT		(1 << (2 + IOVMF_SW_SHIFT))
> -#define IOVMF_LINEAR		(2 << (2 + IOVMF_SW_SHIFT))
> -#define IOVMF_LINEAR_MASK	(3 << (2 + IOVMF_SW_SHIFT))
> -
> -#define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
> -
> -
> -extern struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da);
> -extern u32
> -omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
> -			const struct sg_table *sgt, u32 flags);
> -extern struct sg_table *omap_iommu_vunmap(struct iommu_domain *domain,
> -				struct device *dev, u32 da);
> -extern u32
> -omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev,
> -				u32 da, size_t bytes, u32 flags);
> -extern void
> -omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
> -				const u32 da);
> -extern void *omap_da_to_va(struct device *dev, u32 da);
> -
> -#endif /* __IOMMU_MMAP_H */
> diff --git a/drivers/iommu/omap-iommu-debug.c
> b/drivers/iommu/omap-iommu-debug.c index 0cac372..cf4a0b5 100644
> --- a/drivers/iommu/omap-iommu-debug.c
> +++ b/drivers/iommu/omap-iommu-debug.c
> @@ -18,9 +18,9 @@
>  #include <linux/uaccess.h>
>  #include <linux/platform_device.h>
>  #include <linux/debugfs.h>
> +#include <linux/omap-iommu.h>
> 
>  #include <plat/iommu.h>
> -#include <plat/iovmm.h>
> 
>  #include "omap-iopgtable.h"
> 
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index f2bbfb0..eadcfde 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -19,6 +19,7 @@
>  #include <linux/clk.h>
>  #include <linux/platform_device.h>
>  #include <linux/iommu.h>
> +#include <linux/omap-iommu.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> 
> diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
> index b332392..9852101 100644
> --- a/drivers/iommu/omap-iovmm.c
> +++ b/drivers/iommu/omap-iovmm.c
> @@ -17,15 +17,59 @@
>  #include <linux/device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/iommu.h>
> +#include <linux/omap-iommu.h>
> 
>  #include <asm/cacheflush.h>
>  #include <asm/mach/map.h>
> 
>  #include <plat/iommu.h>
> -#include <plat/iovmm.h>
> 
>  #include "omap-iopgtable.h"
> 
> +/*
> + * IOVMF_FLAGS: attribute for iommu virtual memory area(iovma)
> + *
> + * lower 16 bit is used for h/w and upper 16 bit is for s/w.
> + */
> +#define IOVMF_SW_SHIFT		16
> +
> +/*
> + * iovma: h/w flags derived from cam and ram attribute
> + */
> +#define IOVMF_CAM_MASK		(~((1 << 10) - 1))
> +#define IOVMF_RAM_MASK		(~IOVMF_CAM_MASK)
> +
> +#define IOVMF_PGSZ_MASK		(3 << 0)
> +#define IOVMF_PGSZ_1M		MMU_CAM_PGSZ_1M
> +#define IOVMF_PGSZ_64K		MMU_CAM_PGSZ_64K
> +#define IOVMF_PGSZ_4K		MMU_CAM_PGSZ_4K
> +#define IOVMF_PGSZ_16M		MMU_CAM_PGSZ_16M
> +
> +#define IOVMF_ENDIAN_MASK	(1 << 9)
> +#define IOVMF_ENDIAN_BIG	MMU_RAM_ENDIAN_BIG
> +
> +#define IOVMF_ELSZ_MASK		(3 << 7)
> +#define IOVMF_ELSZ_16		MMU_RAM_ELSZ_16
> +#define IOVMF_ELSZ_32		MMU_RAM_ELSZ_32
> +#define IOVMF_ELSZ_NONE		MMU_RAM_ELSZ_NONE
> +
> +#define IOVMF_MIXED_MASK	(1 << 6)
> +#define IOVMF_MIXED		MMU_RAM_MIXED
> +
> +/*
> + * iovma: s/w flags, used for mapping and umapping internally.
> + */
> +#define IOVMF_MMIO		(1 << IOVMF_SW_SHIFT)
> +#define IOVMF_ALLOC		(2 << IOVMF_SW_SHIFT)
> +#define IOVMF_ALLOC_MASK	(3 << IOVMF_SW_SHIFT)
> +
> +/* "superpages" is supported just with physically linear pages */
> +#define IOVMF_DISCONT		(1 << (2 + IOVMF_SW_SHIFT))
> +#define IOVMF_LINEAR		(2 << (2 + IOVMF_SW_SHIFT))
> +#define IOVMF_LINEAR_MASK	(3 << (2 + IOVMF_SW_SHIFT))
> +
> +#define IOVMF_DA_FIXED		(1 << (4 + IOVMF_SW_SHIFT))
> +
>  static struct kmem_cache *iovm_area_cachep;
> 
>  /* return the offset of the first scatterlist entry in a sg table */
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 99640d8..d72bd38 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -66,6 +66,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/vmalloc.h>
> +#include <linux/omap-iommu.h>
> 
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h index 8be7487..50be8c2 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -34,8 +34,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/wait.h>
>  #include <linux/iommu.h>
> -#include <plat/iommu.h>
> -#include <plat/iovmm.h>
> 
>  #include "ispstat.h"
>  #include "ispccdc.h"
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index 60181ab..b2d4976 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -32,6 +32,7 @@
>  #include <linux/mm.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/omap-iommu.h>
>  #include <media/v4l2-event.h>
> 
>  #include "isp.h"
> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> b/drivers/media/platform/omap3isp/ispstat.c index d7ac76b..e135774 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -28,6 +28,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/omap-iommu.h>
> 
>  #include "isp.h"
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index a0b737fe..2853bef 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -32,10 +32,10 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/omap-iommu.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-ioctl.h>
>  #include <plat/iommu.h>
> -#include <plat/iovmm.h>
>  #include <plat/omap-pm.h>
> 
>  #include "ispvideo.h"
> diff --git a/include/linux/omap-iommu.h b/include/linux/omap-iommu.h
> new file mode 100644
> index 0000000..bd12665
> --- /dev/null
> +++ b/include/linux/omap-iommu.h
> @@ -0,0 +1,47 @@
> +/*
> + * omap iommu: simple virtual address space management
> + *
> + * Copyright (C) 2008-2009 Nokia Corporation
> + *
> + * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

Missing #ifndef #define ... #endif

> +
> +struct iovm_struct {
> +	struct omap_iommu	*iommu;	/* iommu object which this belongs to */
> +	u32			da_start; /* area definition */
> +	u32			da_end;
> +	u32			flags; /* IOVMF_: see below */
> +	struct list_head	list; /* linked in ascending order */
> +	const struct sg_table	*sgt; /* keep 'page' <-> 'da' mapping */
> +	void			*va; /* mpu side mapped address */
> +};
> +
> +#define MMU_RAM_ENDIAN_SHIFT	9
> +#define MMU_RAM_ENDIAN_LITTLE	(0 << MMU_RAM_ENDIAN_SHIFT)
> +#define MMU_RAM_ELSZ_8		(0 << MMU_RAM_ELSZ_SHIFT)
> +#define IOVMF_ENDIAN_LITTLE	MMU_RAM_ENDIAN_LITTLE
> +#define MMU_RAM_ELSZ_SHIFT	7
> +#define IOVMF_ELSZ_8		MMU_RAM_ELSZ_8

Shouldn't this header be split in include/linux/omap-iommu.h and 
include/linux/omap-iovmm.h ? I would also move all the hardware IOVMF flags to 
include/linux/omap-iovmm.h, not just the two currently used by the OMAP3 ISP 
driver. The software flags can be kept in drivers/iommu/omap-iovmm.c.

> +struct iommu_domain;
> +
> +extern struct iovm_struct *omap_find_iovm_area(struct device *dev, u32 da);
> +extern u32
> +omap_iommu_vmap(struct iommu_domain *domain, struct device *dev, u32 da,
> +			const struct sg_table *sgt, u32 flags);
> +extern struct sg_table *omap_iommu_vunmap(struct iommu_domain *domain,
> +				struct device *dev, u32 da);
> +extern u32
> +omap_iommu_vmalloc(struct iommu_domain *domain, struct device *dev,
> +				u32 da, size_t bytes, u32 flags);
> +extern void
> +omap_iommu_vfree(struct iommu_domain *domain, struct device *dev,
> +				const u32 da);
> +extern void *omap_da_to_va(struct device *dev, u32 da);
> +
> +extern void omap_iommu_save_ctx(struct device *dev);
> +extern void omap_iommu_restore_ctx(struct device *dev);

Do we really need to prefix functions with 'extern' ?

-- 
Regards,

Laurent Pinchart

