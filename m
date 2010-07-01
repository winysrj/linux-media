Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:35891 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab0GAOCZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 10:02:25 -0400
Date: Thu, 1 Jul 2010 17:01:59 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv5] mx2_camera: Add soc_camera support for i.MX25/i.MX27
Message-ID: <20100701140159.GI16981@jasper.tkos.co.il>
References: <47538fc4c6ffbc6a4c80ba55ecdd03603e67095c.1277981781.git.baruch@tkos.co.il>
 <20100701122803.GE28535@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100701122803.GE28535@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uwe,

On Thu, Jul 01, 2010 at 02:28:03PM +0200, Uwe Kleine-König wrote:
> On Thu, Jul 01, 2010 at 02:03:19PM +0300, Baruch Siach wrote:
> > This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> > Carvalho de Assis modified the original driver to get it working on more recent
> > kernels. I modified it further to add support for i.MX25. This driver has been
> > tested on i.MX25 and i.MX27 based platforms.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > Changes v4 -> v5
> >     Comments from Uwe Kleine-König:
> > 
> >     Enclose mx27 DMA related stuff in #ifdefs since the dma-mx1-mx2.h is no 
> >     longer accessible to mx25 builds
> > 
> >     s/MX2_VIDEO/VIDEO_MX2_HOSTSUPPORT/
> > 
> > Changes v3 -> v4
> >     Address more comments from Guennadi Liakhovetski, including:
> > 
> >     * Fix the double trigger handling of mx27 eMMA
> > 
> >     * Add a FIXME comment in the code of eMMA overflow handling
> > 
> > Changes v2 -> v3
> >     Address more comments from Guennadi Liakhovetski.
> > 
> >     Applied part of Sashca's patch that I forgot in v2.
> > 
> > Changes v1 -> v2
> >     Addressed the comments of Guennadi Liakhovetski except from the following:
> > 
> >     1. The mclk_get_divisor implementation, since I don't know what this code 
> >        is good for
> > 
> >     2. mx2_videobuf_release should not set pcdev->active on i.MX27, because 
> >        mx27_camera_frame_done needs this pointer
> > 
> >     3. In mx27_camera_emma_buf_init I don't know the meaning of those hard 
> >        coded magic numbers
> > 
> >     Applied i.MX27 fixes from Sascha.
> > 
> >  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
> >  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
> >  drivers/media/video/Kconfig              |   13 +
> >  drivers/media/video/Makefile             |    1 +
> >  drivers/media/video/mx2_camera.c         | 1513 ++++++++++++++++++++++++++++++
> >  5 files changed, 1575 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
> >  create mode 100644 drivers/media/video/mx2_camera.c
> > 
> > diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
> > index c4b40c3..849d891 100644
> > --- a/arch/arm/plat-mxc/include/mach/memory.h
> > +++ b/arch/arm/plat-mxc/include/mach/memory.h
> > @@ -44,12 +44,12 @@
> >   */
> >  #define CONSISTENT_DMA_SIZE SZ_8M
> >  
> > -#elif defined(CONFIG_MX1_VIDEO)
> > +#elif defined(CONFIG_MX1_VIDEO) || defined(CONFIG_VIDEO_MX2_HOSTSUPPORT)
> >  /*
> >   * Increase size of DMA-consistent memory region.
> >   * This is required for i.MX camera driver to capture at least four VGA frames.
> >   */
> >  #define CONSISTENT_DMA_SIZE SZ_4M
> > -#endif /* CONFIG_MX1_VIDEO */
> > +#endif /* CONFIG_MX1_VIDEO || CONFIG_MX2_VIDEO */
> s/CONFIG_MX2_VIDEO/CONFIG_VIDEO_MX2_HOSTSUPPORT/ please

Oops. Will fix.

> >  #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
> > diff --git a/arch/arm/plat-mxc/include/mach/mx2_cam.h b/arch/arm/plat-mxc/include/mach/mx2_cam.h
> > new file mode 100644
> > index 0000000..3c080a3
> > --- /dev/null
> > +++ b/arch/arm/plat-mxc/include/mach/mx2_cam.h
> Do you expect users of this header other than your driver?  If not you
> can fold it into the latter.

This header contains mx2_camera_platform_data. Platform code needs this.

> [...snip...]
> 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index bdbc9d3..27e2acc 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -969,6 +969,19 @@ config VIDEO_OMAP2
> >  	---help---
> >  	  This is a v4l2 driver for the TI OMAP2 camera capture interface
> >  
> > +config VIDEO_MX2_HOSTSUPPORT
> > +        bool
> > +
> > +config VIDEO_MX2
> > +	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
> > +	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
> > +	select VIDEOBUF_DMA_CONTIG
> CONTIG?

This selects the physically contiguous DMA implementation of the videobuf API.  
See drivers/media/video/videobuf-dma-contig.c.

> [...snap...]
> 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > new file mode 100644
> > index 0000000..98c93fa
> > --- /dev/null
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -0,0 +1,1513 @@
> 
> [...snip...]
> 
> > +static int __devexit mx2_camera_remove(struct platform_device *pdev)
> > +{
> > +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> > +	struct mx2_camera_dev *pcdev = container_of(soc_host,
> > +			struct mx2_camera_dev, soc_host);
> > +	struct resource *res;
> > +
> > +	clk_put(pcdev->clk_csi);
> > +#ifdef CONFIG_MACH_MX27
> > +	if (cpu_is_mx27())
> > +		imx_dma_free(pcdev->dma);
> > +#endif /* CONFIG_MACH_MX27 */
> > +	free_irq(pcdev->irq_csi, pcdev);
> > +	if (mx27_camera_emma(pcdev))
> > +		free_irq(pcdev->irq_emma, pcdev);
> > +
> > +	soc_camera_host_unregister(&pcdev->soc_host);
> > +
> > +	iounmap(pcdev->base_csi);
> > +
> > +	if (mx27_camera_emma(pcdev)) {
> > +		clk_disable(pcdev->clk_emma);
> > +		clk_put(pcdev->clk_emma);
> > +		iounmap(pcdev->base_emma);
> > +		res = pcdev->res_emma;
> > +		release_mem_region(res->start, resource_size(res));
> > +	}
> > +
> > +	res = pcdev->res_csi;
> > +	release_mem_region(res->start, resource_size(res));
> > +
> > +	kfree(pcdev);
> > +
> > +	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver mx2_camera_driver = {
> > +	.driver 	= {
> > +		.name	= MX2_CAM_DRV_NAME,
> I'm always unsure if you need
> 
> 		.owner  = THIS_MODULE,
> 
> here.

It shouldn't heart. Will add.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
