Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:60973 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1ARREU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 12:04:20 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 18 Jan 2011 22:33:46 +0530
Subject: RE: [PATCH v16 1/3] davinci vpbe: changes to common files
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930248473BA0@dbde02.ent.ti.com>
References: <1295357947-17646-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1295357947-17646-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manju,

You have got a wrong address for linux-arm-kernel ML.

The right address is: linux-arm-kernel@lists.infradead.org

Also, I think you need to subscribe to this list for your
messages to get posted automatically. Subscription information
is available here: http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

You can check that your patches are actually reaching ARM linux
mailing list by checking the archives here: http://marc.info/?l=linux-arm-kernel

On Tue, Jan 18, 2011 at 19:09:07, Hadli, Manjunath wrote:
> Implemented a common and single mapping for DAVINCI_SYSTEM_MODULE_BASE
> to be used by all davinci platforms.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  arch/arm/mach-davinci/common.c                |    4 +++-
>  arch/arm/mach-davinci/devices.c               |   10 ++++------
>  arch/arm/mach-davinci/include/mach/hardware.h |    5 +++++
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/common.c b/arch/arm/mach-davinci/common.c
> index 1d25573..949e615 100644
> --- a/arch/arm/mach-davinci/common.c
> +++ b/arch/arm/mach-davinci/common.c
> @@ -111,7 +111,9 @@ void __init davinci_common_init(struct davinci_soc_info *soc_info)
>  		if (ret != 0)
>  			goto err;
>  	}
> -
> +	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
> +	if (!davinci_sysmodbase)
> +		goto err;

This is actually not the right place to do this. davinci_common_init()
is called for all 7 supported SoCs. This system module base address
definitely not valid on the two DA8x SoCs. I suspect it is not valid on
TNETV as well. That makes this call unnecessary on 3 of the 7 supported
SoCs. I think the original approach of mapping it for each SoC that needed
it was fine.

>  	return;
>  
>  err:
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index 22ebc64..2bff2d6 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -33,6 +33,8 @@
>  #define DM365_MMCSD0_BASE	     0x01D11000
>  #define DM365_MMCSD1_BASE	     0x01D00000
>  
> +void __iomem  *davinci_sysmodbase;
> +
>  static struct resource i2c_resources[] = {
>  	{
>  		.start		= DAVINCI_I2C_BASE,
> @@ -209,9 +211,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  			davinci_cfg_reg(DM355_SD1_DATA2);
>  			davinci_cfg_reg(DM355_SD1_DATA3);
>  		} else if (cpu_is_davinci_dm365()) {
> -			void __iomem *pupdctl1 =
> -				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE + 0x7c);
> -
> +			void __iomem *pupdctl1 = DAVINCI_SYSMODULE_VIRT(0x7c);
>  			/* Configure pull down control */
>  			__raw_writel((__raw_readl(pupdctl1) & ~0xfc0),
>  					pupdctl1);
> @@ -243,9 +243,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
>  		} else if (cpu_is_davinci_dm644x()) {
>  			/* REVISIT: should this be in board-init code? */
> -			void __iomem *base =
> -				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> -
> +			void __iomem *base = DAVINCI_SYSMODULE_VIRT(0);

Please use DAVINCI_SYSMODULE_VIRT(DM64XX_VDD3P3V_PWDN) instead.

>  			/* Power-on 3.3V IO cells */
>  			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
>  			/*Set up the pull regiter for MMC */
> diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
> index c45ba1f..5a105c4 100644
> --- a/arch/arm/mach-davinci/include/mach/hardware.h
> +++ b/arch/arm/mach-davinci/include/mach/hardware.h
> @@ -24,6 +24,11 @@
>  /* System control register offsets */
>  #define DM64XX_VDD3P3V_PWDN	0x48
>  
> +#ifndef __ASSEMBLER__
> +	extern void __iomem  *davinci_sysmodbase;
> +	#define DAVINCI_SYSMODULE_VIRT(x)       (davinci_sysmodbase+(x))

Indenting the #defines is not required.

Also, this will need to be placed in individual <soc>.h file. The currently
defined DAVINCI_SYSTEM_MODULE_BASE and DM64XX_VDD3P3V_PWDN also violate the
guidance provided in comments just before those defines. They should be
moved to <soc>.h files too.


Thanks,
Sekhar

