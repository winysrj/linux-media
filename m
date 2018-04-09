Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40278 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbeDIJsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 05:48:09 -0400
Date: Mon, 9 Apr 2018 06:48:01 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH 02/16] media: omap3isp: allow it to build with
 COMPILE_TEST
Message-ID: <20180409064801.335def4f@vento.lan>
In-Reply-To: <CAK8P3a0_AQaYFyUog0sV9hjq6yOzohnCbD9=AK-HGxWt-P_hEA@mail.gmail.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <2233233.yQEdpcOfql@avalon>
        <20180405164444.441033be@vento.lan>
        <4086814.xXeFl5mgbc@avalon>
        <20180407101455.214bf849@vento.lan>
        <CAK8P3a0_AQaYFyUog0sV9hjq6yOzohnCbD9=AK-HGxWt-P_hEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Arnd,

Em Mon, 9 Apr 2018 10:50:13 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> >> > That hardly seems to be an arch-specific iommu solution, but, instead, some
> >> > hack used by only three drivers or some legacy iommu binding.  
> >>
> >> It's more complex than that. There are multiple IOMMU-related APIs on ARM, so
> >> more recent than others, with different feature sets. While I agree that
> >> drivers should move away from arm_iommu_create_mapping(), doing so requires
> >> coordination between the IOMMU driver and the bus master driver (for instance
> >> the omap3isp driver). It's not a trivial matter, but I'd love if someone
> >> submitted patches :-)  
> >
> > If someone steps up to do that, it would be really helpful, but we
> > should not trust that this will happen. OMAP3 is an old hardware,
> > and not many developers are working on improving its support.  
> 
> Considering its age, I still see a lot of changes on the arch/arm side of
> it, so I wouldn't give up the hope yet.

Yeah, someone might still work on such fix.

> > Arnd,
> >
> > What do you think?  
> 
> I think including a foreign architecture header is worse than your
> earlier patch, I'd rather see a local hack in the driver.
> 
> I haven't tried it, but how about something simpler like what
> I have below.

Actually, another #ifdef was needed, before include arch-specifi
header :-)
> 
>       Arnd
> 
> (in case it works and you want to pick it up with a proper
> changelog):
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sounds a reasonable approach. Instead of using CONFIG_ARM, I would,
instead check for CONFIG_ARM_DMA_USE_IOMMU, with is the actual
dependency for such code, as otherwise it could cause some
compilation breakages on ARM with COMPILE_TEST and some randconfig.

An advantage is that it properly annotates the part of the code
that depends on ARM_DMA_USE_IOMMU.

Thanks,
Mauro

From: Arnd Bergmann <arnd@arndb.de>

media: omap3isp: allow it to build with COMPILE_TEST
 
There aren't much things required for it to build with COMPILE_TEST.
It just needs to not compile the code that depends on arm-specific
iommu implementation.

Co-developed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 1ee915b794c0..2757b621091c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -63,12 +63,10 @@ config VIDEO_MUX
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
-	depends on ARCH_OMAP3 || COMPILE_TEST
-	depends on ARM
+	depends on ((ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST)
 	depends on COMMON_CLK
 	depends on HAS_DMA && OF
-	depends on OMAP_IOMMU
-	select ARM_DMA_USE_IOMMU
+	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
 	select MFD_SYSCON
 	select V4L2_FWNODE
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 16c50099cccd..b8c8761a76b6 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -61,7 +61,9 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
 #include <asm/dma-iommu.h>
+#endif
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-fwnode.h>
@@ -1938,12 +1940,15 @@ static int isp_initialize_modules(struct isp_device *isp)
 
 static void isp_detach_iommu(struct isp_device *isp)
 {
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
 	arm_iommu_release_mapping(isp->mapping);
 	isp->mapping = NULL;
+#endif
 }
 
 static int isp_attach_iommu(struct isp_device *isp)
 {
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
 	struct dma_iommu_mapping *mapping;
 	int ret;
 
@@ -1972,6 +1977,9 @@ static int isp_attach_iommu(struct isp_device *isp)
 error:
 	isp_detach_iommu(isp);
 	return ret;
+#else
+	return -ENODEV;
+#endif
 }
 
 /*
