Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45420 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbeDGL5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 07:57:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH 02/16] media: omap3isp: allow it to build with COMPILE_TEST
Date: Sat, 07 Apr 2018 14:56:59 +0300
Message-ID: <4086814.xXeFl5mgbc@avalon>
In-Reply-To: <20180405164444.441033be@vento.lan>
References: <cover.1522949748.git.mchehab@s-opensource.com> <2233233.yQEdpcOfql@avalon> <20180405164444.441033be@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 5 April 2018 22:44:44 EEST Mauro Carvalho Chehab wrote:
> Em Thu, 05 Apr 2018 21:30:27 +0300 Laurent Pinchart escreveu:
> > On Thursday, 5 April 2018 20:54:02 EEST Mauro Carvalho Chehab wrote:
> > > There aren't much things required for it to build with COMPILE_TEST.
> > > It just needs to provide stub for an arm-dependent include.
> > > 
> > > Let's replicate the same solution used by ipmmu-vmsa, in order
> > > to allow building omap3 with COMPILE_TEST.
> > > 
> > > The actual logic here came from this driver:
> > >    drivers/iommu/ipmmu-vmsa.c
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > ---
> > > 
> > >  drivers/media/platform/Kconfig        | 8 ++++----
> > >  drivers/media/platform/omap3isp/isp.c | 7 +++++++
> > >  2 files changed, 11 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/Kconfig
> > > b/drivers/media/platform/Kconfig index c7a1cf8a1b01..03c9dfeb7781
> > > 100644
> > > --- a/drivers/media/platform/Kconfig
> > > +++ b/drivers/media/platform/Kconfig
> > > @@ -62,12 +62,12 @@ config VIDEO_MUX
> > > 
> > >  config VIDEO_OMAP3
> > >  	tristate "OMAP 3 Camera support"
> > > -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> > > +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> > >  	depends on HAS_DMA && OF
> > > -	depends on OMAP_IOMMU
> > > -	select ARM_DMA_USE_IOMMU
> > > +	depends on ((ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST)
> > > +	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
> > >  	select VIDEOBUF2_DMA_CONTIG
> > > -	select MFD_SYSCON
> > > +	select MFD_SYSCON if ARCH_OMAP3
> > >  	select V4L2_FWNODE
> > >  	---help---
> > >  	  Driver for an OMAP 3 camera controller.
> > > diff --git a/drivers/media/platform/omap3isp/isp.c
> > > b/drivers/media/platform/omap3isp/isp.c index 8eb000e3d8fd..2a11a709aa4f
> > > 100644
> > > --- a/drivers/media/platform/omap3isp/isp.c
> > > +++ b/drivers/media/platform/omap3isp/isp.c
> > > @@ -61,7 +61,14 @@
> > >  #include <linux/sched.h>
> > >  #include <linux/vmalloc.h>
> > > 
> > > +#if defined(CONFIG_ARM) && !defined(CONFIG_IOMMU_DMA)
> > >  #include <asm/dma-iommu.h>
> > > +#else
> > > +#define arm_iommu_create_mapping(...)	NULL
> > > +#define arm_iommu_attach_device(...)	-ENODEV
> > > +#define arm_iommu_release_mapping(...)	do {} while (0)
> > > +#define arm_iommu_detach_device(...)	do {} while (0)
> > > +#endif
> > 
> > I don't think it's the job of a driver to define those stubs, sorry.
> > Otherwise where do you stop ? If you have half of the code that is
> > architecture- dependent, would you stub it ? And what if the stubs you
> > define here generate warnings in static analyzers ?
> 
> I agree that we should avoid doing that as a general case, but see
> below.
> 
> > If you want to make drivers compile for all architectures, the APIs they
> > use must be defined in linux/, not in asm/. They can be stubbed there
> > when not implemented in a particular architecture, but not in the driver.
> 
> In this specific case, the same approach taken here is already needed
> by the Renesas VMSA-compatible IPMMU driver, with, btw, is inside
> drivers/iommu:
> 
> 	drivers/iommu/ipmmu-vmsa.c

The reason there is different, the driver is shared by ARM32 and ARM64 
platforms. Furthermore, there's an effort (or at least there was) to move away 
from those APIs in the driver, but I think it has stalled.

> Also, this API is used only by 3 drivers [1]:
> 
> 	drivers/iommu/ipmmu-vmsa.c
> 	drivers/iommu/mtk_iommu_v1.c
> 	drivers/media/platform/omap3isp/isp.c
> 
> [1] as blamed by
> 	git grep -l arm_iommu_create_mapping

The exynos driver also uses it.

> That hardly seems to be an arch-specific iommu solution, but, instead, some
> hack used by only three drivers or some legacy iommu binding.

It's more complex than that. There are multiple IOMMU-related APIs on ARM, so 
more recent than others, with different feature sets. While I agree that 
drivers should move away from arm_iommu_create_mapping(), doing so requires 
coordination between the IOMMU driver and the bus master driver (for instance 
the omap3isp driver). It's not a trivial matter, but I'd love if someone 
submitted patches :-)

> The omap3isp is, btw, the only driver outside drivers/iommu that needs it.
> 
> So, it sounds that other driver uses some other approach, but hardly
> it would be worth to change this driver to use something else.
> 
> So, better to stick with the same solution the Renesas driver used.

I'm not responsible for that solution and I didn't think it was a good one at 
the time it was introduced, but in any case it is not meant at all to support 
COMPILE_TEST. I still don't think the omap3isp driver should declare stubs for 
these functions for the purpose of supporting compile-testing on x86.

-- 
Regards,

Laurent Pinchart
