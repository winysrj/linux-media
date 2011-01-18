Return-path: <mchehab@pedra>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51139 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab1ARShI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 13:37:08 -0500
Received: by mail-iy0-f169.google.com with SMTP id 17so6824227iyj.0
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 10:37:07 -0800 (PST)
From: Kevin Hilman <khilman@ti.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v16 1/3] davinci vpbe: changes to common files
References: <1295357947-17646-1-git-send-email-manjunath.hadli@ti.com>
Date: Tue, 18 Jan 2011 10:37:02 -0800
In-Reply-To: <1295357947-17646-1-git-send-email-manjunath.hadli@ti.com>
	(Manjunath Hadli's message of "Tue, 18 Jan 2011 19:09:07 +0530")
Message-ID: <87aaiyxdm9.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manjunath Hadli <manjunath.hadli@ti.com> writes:

> Implemented a common and single mapping for DAVINCI_SYSTEM_MODULE_BASE
> to be used by all davinci platforms.

Please use a more descriptive subject.  This patch hs nothing to do with
VPBE, so  please send it as a standalone patch.

Thanks,

Kevin



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
> +#endif
> +
>  /*
>   * I/O mapping
>   */
