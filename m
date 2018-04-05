Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54554 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbeDETov (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 15:44:51 -0400
Date: Thu, 5 Apr 2018 16:44:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH 02/16] media: omap3isp: allow it to build with
 COMPILE_TEST
Message-ID: <20180405164444.441033be@vento.lan>
In-Reply-To: <2233233.yQEdpcOfql@avalon>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <f618981fec34acc5eee211b34a0018752634af9c.1522949748.git.mchehab@s-opensource.com>
        <2233233.yQEdpcOfql@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 05 Apr 2018 21:30:27 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Thursday, 5 April 2018 20:54:02 EEST Mauro Carvalho Chehab wrote:
> > There aren't much things required for it to build with COMPILE_TEST.
> > It just needs to provide stub for an arm-dependent include.
> > 
> > Let's replicate the same solution used by ipmmu-vmsa, in order
> > to allow building omap3 with COMPILE_TEST.
> > 
> > The actual logic here came from this driver:
> > 
> >    drivers/iommu/ipmmu-vmsa.c
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/platform/Kconfig        | 8 ++++----
> >  drivers/media/platform/omap3isp/isp.c | 7 +++++++
> >  2 files changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index c7a1cf8a1b01..03c9dfeb7781 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -62,12 +62,12 @@ config VIDEO_MUX
> > 
> >  config VIDEO_OMAP3
> >  	tristate "OMAP 3 Camera support"
> > -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> > +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> >  	depends on HAS_DMA && OF
> > -	depends on OMAP_IOMMU
> > -	select ARM_DMA_USE_IOMMU
> > +	depends on ((ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST)
> > +	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
> >  	select VIDEOBUF2_DMA_CONTIG
> > -	select MFD_SYSCON
> > +	select MFD_SYSCON if ARCH_OMAP3
> >  	select V4L2_FWNODE
> >  	---help---
> >  	  Driver for an OMAP 3 camera controller.
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 8eb000e3d8fd..2a11a709aa4f
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -61,7 +61,14 @@
> >  #include <linux/sched.h>
> >  #include <linux/vmalloc.h>
> > 
> > +#if defined(CONFIG_ARM) && !defined(CONFIG_IOMMU_DMA)
> >  #include <asm/dma-iommu.h>
> > +#else
> > +#define arm_iommu_create_mapping(...)	NULL
> > +#define arm_iommu_attach_device(...)	-ENODEV
> > +#define arm_iommu_release_mapping(...)	do {} while (0)
> > +#define arm_iommu_detach_device(...)	do {} while (0)
> > +#endif  
> 
> I don't think it's the job of a driver to define those stubs, sorry. Otherwise 
> where do you stop ? If you have half of the code that is architecture-
> dependent, would you stub it ? And what if the stubs you define here generate 
> warnings in static analyzers ?

I agree that we should avoid doing that as a general case, but see
below.

> If you want to make drivers compile for all architectures, the APIs they use 
> must be defined in linux/, not in asm/. They can be stubbed there when not 
> implemented in a particular architecture, but not in the driver.

In this specific case, the same approach taken here is already needed
by the Renesas VMSA-compatible IPMMU driver, with, btw, is inside 
drivers/iommu:

	drivers/iommu/ipmmu-vmsa.c

Also, this API is used only by 3 drivers [1]:

	drivers/iommu/ipmmu-vmsa.c
	drivers/iommu/mtk_iommu_v1.c
	drivers/media/platform/omap3isp/isp.c

[1] as blamed by 
	git grep -l arm_iommu_create_mapping

That hardly seems to be an arch-specific iommu solution, but, instead, some
hack used by only three drivers or some legacy iommu binding.

The omap3isp is, btw, the only driver outside drivers/iommu that needs it.

So, it sounds that other driver uses some other approach, but hardly
it would be worth to change this driver to use something else.

So, better to stick with the same solution the Renesas driver used.

Thanks,
Mauro
