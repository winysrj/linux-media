Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1LIKNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 05:13:37 -0500
Date: Fri, 9 Dec 2011 11:13:32 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, r.schwebel@pengutronix.de
Subject: Re: [PATCH v3 1/2] MX2: Add platform definitions for eMMa-PrP device.
Message-ID: <20111209101332.GE27267@pengutronix.de>
References: <1322061227-6631-1-git-send-email-javier.martin@vista-silicon.com>
 <1322061227-6631-2-git-send-email-javier.martin@vista-silicon.com>
 <4EE0B478.8080205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE0B478.8080205@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 08, 2011 at 10:58:32AM -0200, Mauro Carvalho Chehab wrote:
> On 23-11-2011 13:13, Javier Martin wrote:
> >eMMa-PrP device included in Freescale i.MX2 chips can also
> >be used separately to process memory buffers.
> 
> This patch is just the arch glue to the driver, so it should be applied via the
> media tree, and likely as patch 2, in order to avoid breaking git bisect.
> 
> Yet, I'd like to have the mach-imx maintainer's ack on this.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> 
> Regards,
> Mauro.
> 
> >
> >Changes since v2:
> >- Define imx_add_mx2_emmaprp function which also registers device,
> >not only alloc.
> >- Change definition of emma_clk.
> >- Minor fixes.
> >
> >Signed-off-by: Javier Martin<javier.martin@vista-silicon.com>
> >---
> >  arch/arm/mach-imx/clock-imx27.c                 |    2 +-
> >  arch/arm/mach-imx/devices-imx27.h               |    2 ++
> >  arch/arm/plat-mxc/devices/platform-mx2-camera.c |   18 ++++++++++++++++++
> >  arch/arm/plat-mxc/include/mach/devices-common.h |    2 ++
> >  4 files changed, 23 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/arm/mach-imx/clock-imx27.c b/arch/arm/mach-imx/clock-imx27.c
> >index 88fe00a..dc2d7a5 100644
> >--- a/arch/arm/mach-imx/clock-imx27.c
> >+++ b/arch/arm/mach-imx/clock-imx27.c
> >@@ -661,7 +661,7 @@ static struct clk_lookup lookups[] = {
> >  	_REGISTER_CLOCK(NULL, "dma", dma_clk)
> >  	_REGISTER_CLOCK(NULL, "rtic", rtic_clk)
> >  	_REGISTER_CLOCK(NULL, "brom", brom_clk)
> >-	_REGISTER_CLOCK(NULL, "emma", emma_clk)
> >+	_REGISTER_CLOCK("m2m-emmaprp.0", NULL, emma_clk)
> >  	_REGISTER_CLOCK(NULL, "slcdc", slcdc_clk)
> >  	_REGISTER_CLOCK("imx27-fec.0", NULL, fec_clk)
> >  	_REGISTER_CLOCK(NULL, "emi", emi_clk)
> >diff --git a/arch/arm/mach-imx/devices-imx27.h b/arch/arm/mach-imx/devices-imx27.h
> >index 2f727d7..28537a5 100644
> >--- a/arch/arm/mach-imx/devices-imx27.h
> >+++ b/arch/arm/mach-imx/devices-imx27.h
> >@@ -50,6 +50,8 @@ extern const struct imx_imx_uart_1irq_data imx27_imx_uart_data[];
> >  extern const struct imx_mx2_camera_data imx27_mx2_camera_data;
> >  #define imx27_add_mx2_camera(pdata)	\
> >  	imx_add_mx2_camera(&imx27_mx2_camera_data, pdata)
> >+#define imx27_add_mx2_emmaprp(pdata)	\
> >+	imx_add_mx2_emmaprp(&imx27_mx2_camera_data)
> >
> >  extern const struct imx_mxc_ehci_data imx27_mxc_ehci_otg_data;
> >  #define imx27_add_mxc_ehci_otg(pdata)	\
> >diff --git a/arch/arm/plat-mxc/devices/platform-mx2-camera.c b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> >index b3f4828..11eace9 100644
> >--- a/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> >+++ b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
> >@@ -62,3 +62,21 @@ struct platform_device *__init imx_add_mx2_camera(
> >  			res, data->iobaseemmaprp ? 4 : 2,
> >  			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
> >  }
> >+
> >+struct platform_device *__init imx_add_mx2_emmaprp(
> >+		const struct imx_mx2_camera_data *data)
> >+{
> >+	struct resource res[] = {
> >+		{
> >+			.start = data->iobaseemmaprp,
> >+			.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
> >+			.flags = IORESOURCE_MEM,
> >+		}, {
> >+			.start = data->irqemmaprp,
> >+			.end = data->irqemmaprp,
> >+			.flags = IORESOURCE_IRQ,
> >+		},
> >+	};
> >+	return imx_add_platform_device_dmamask("m2m-emmaprp", 0,
> >+			res, 2, NULL, 0, DMA_BIT_MASK(32));
> >+}
> >diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
> >index def9ba5..1b2258d 100644
> >--- a/arch/arm/plat-mxc/include/mach/devices-common.h
> >+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
> >@@ -223,6 +223,8 @@ struct imx_mx2_camera_data {
> >  struct platform_device *__init imx_add_mx2_camera(
> >  		const struct imx_mx2_camera_data *data,
> >  		const struct mx2_camera_platform_data *pdata);
> >+struct platform_device *__init imx_add_mx2_emmaprp(
> >+		const struct imx_mx2_camera_data *data);
> >
> >  #include<mach/mxc_ehci.h>
> >  struct imx_mxc_ehci_data {
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
