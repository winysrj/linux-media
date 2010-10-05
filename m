Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:38133 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0JEQJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 12:09:50 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Tue, 5 Oct 2010 11:09:42 -0500
Subject: RE: [RFC/PATCH v2 4/6] ARM: OMAP3: Update Camera ISP definitions
 for OMAP3630
Message-ID: <A24693684029E5489D1D202277BE894472B4F82D@dlee02.ent.ti.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1286284734-12292-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284734-12292-5-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Tuesday, October 05, 2010 8:19 AM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [RFC/PATCH v2 4/6] ARM: OMAP3: Update Camera ISP definitions for
> OMAP3630
> 
> From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> 
> Add new/changed base address definitions and resources for
> OMAP3630 ISP.
> 
> The OMAP3430 CSI2PHY block is same as the OMAP3630 CSIPHY2
> block. But the later name is chosen as it gives more symmetry
> to the names.

This patch needs to go through linux-omap ML.

Regards,
Sergio

> 
> Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
> ---
>  arch/arm/mach-omap2/devices.c              |   28
> ++++++++++++++++++++++++----
>  arch/arm/plat-omap/include/plat/omap34xx.h |   16 ++++++++++++----
>  2 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 2dbb265..ade8db0 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -106,13 +106,33 @@ static struct resource omap3isp_resources[] = {
>  		.flags		= IORESOURCE_MEM,
>  	},
>  	{
> -		.start		= OMAP3430_ISP_CSI2A_BASE,
> -		.end		= OMAP3430_ISP_CSI2A_END,
> +		.start		= OMAP3430_ISP_CSI2A_REGS1_BASE,
> +		.end		= OMAP3430_ISP_CSI2A_REGS1_END,
>  		.flags		= IORESOURCE_MEM,
>  	},
>  	{
> -		.start		= OMAP3430_ISP_CSI2PHY_BASE,
> -		.end		= OMAP3430_ISP_CSI2PHY_END,
> +		.start		= OMAP3430_ISP_CSIPHY2_BASE,
> +		.end		= OMAP3430_ISP_CSIPHY2_END,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= OMAP3630_ISP_CSI2A_REGS2_BASE,
> +		.end		= OMAP3630_ISP_CSI2A_REGS2_END,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= OMAP3630_ISP_CSI2C_REGS1_BASE,
> +		.end		= OMAP3630_ISP_CSI2C_REGS1_END,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= OMAP3630_ISP_CSIPHY1_BASE,
> +		.end		= OMAP3630_ISP_CSIPHY1_END,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= OMAP3630_ISP_CSI2C_REGS2_BASE,
> +		.end		= OMAP3630_ISP_CSI2C_REGS2_END,
>  		.flags		= IORESOURCE_MEM,
>  	},
>  	{
> diff --git a/arch/arm/plat-omap/include/plat/omap34xx.h b/arch/arm/plat-
> omap/include/plat/omap34xx.h
> index 98fc8b4..b9e8588 100644
> --- a/arch/arm/plat-omap/include/plat/omap34xx.h
> +++ b/arch/arm/plat-omap/include/plat/omap34xx.h
> @@ -56,8 +56,12 @@
>  #define OMAP3430_ISP_RESZ_BASE		(OMAP3430_ISP_BASE + 0x1000)
>  #define OMAP3430_ISP_SBL_BASE		(OMAP3430_ISP_BASE + 0x1200)
>  #define OMAP3430_ISP_MMU_BASE		(OMAP3430_ISP_BASE + 0x1400)
> -#define OMAP3430_ISP_CSI2A_BASE		(OMAP3430_ISP_BASE + 0x1800)
> -#define OMAP3430_ISP_CSI2PHY_BASE	(OMAP3430_ISP_BASE + 0x1970)
> +#define OMAP3430_ISP_CSI2A_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1800)
> +#define OMAP3430_ISP_CSIPHY2_BASE	(OMAP3430_ISP_BASE + 0x1970)
> +#define OMAP3630_ISP_CSI2A_REGS2_BASE	(OMAP3430_ISP_BASE + 0x19C0)
> +#define OMAP3630_ISP_CSI2C_REGS1_BASE	(OMAP3430_ISP_BASE + 0x1C00)
> +#define OMAP3630_ISP_CSIPHY1_BASE	(OMAP3430_ISP_BASE + 0x1D70)
> +#define OMAP3630_ISP_CSI2C_REGS2_BASE	(OMAP3430_ISP_BASE + 0x1DC0)
> 
>  #define OMAP3430_ISP_END		(OMAP3430_ISP_BASE         + 0x06F)
>  #define OMAP3430_ISP_CBUFF_END		(OMAP3430_ISP_CBUFF_BASE   +
> 0x077)
> @@ -69,8 +73,12 @@
>  #define OMAP3430_ISP_RESZ_END		(OMAP3430_ISP_RESZ_BASE    +
> 0x0AB)
>  #define OMAP3430_ISP_SBL_END		(OMAP3430_ISP_SBL_BASE     + 0x0FB)
>  #define OMAP3430_ISP_MMU_END		(OMAP3430_ISP_MMU_BASE     + 0x06F)
> -#define OMAP3430_ISP_CSI2A_END		(OMAP3430_ISP_CSI2A_BASE   +
> 0x16F)
> -#define OMAP3430_ISP_CSI2PHY_END	(OMAP3430_ISP_CSI2PHY_BASE + 0x007)
> +#define OMAP3430_ISP_CSI2A_REGS1_END	(OMAP3430_ISP_CSI2A_REGS1_BASE +
> 0x16F)
> +#define OMAP3430_ISP_CSIPHY2_END	(OMAP3430_ISP_CSIPHY2_BASE + 0x00B)
> +#define OMAP3630_ISP_CSI2A_REGS2_END	(OMAP3630_ISP_CSI2A_REGS2_BASE +
> 0x3F)
> +#define OMAP3630_ISP_CSI2C_REGS1_END	(OMAP3630_ISP_CSI2C_REGS1_BASE +
> 0x16F)
> +#define OMAP3630_ISP_CSIPHY1_END	(OMAP3630_ISP_CSIPHY1_BASE + 0x00B)
> +#define OMAP3630_ISP_CSI2C_REGS2_END	(OMAP3630_ISP_CSI2C_REGS2_BASE +
> 0x3F)
> 
>  #define OMAP34XX_HSUSB_OTG_BASE	(L4_34XX_BASE + 0xAB000)
>  #define OMAP34XX_USBTLL_BASE	(L4_34XX_BASE + 0x62000)
> --
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
