Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42249 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1CVMYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:24:46 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 22 Mar 2011 17:54:24 +0530
Subject: RE: [PATCH v17 08/13] davinci: eliminate use of IO_ADDRESS() on
 sysmod
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47D7B5@dbde02.ent.ti.com>
References: <1300197523-4574-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1300197523-4574-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 15, 2011 at 19:28:43, Hadli, Manjunath wrote:
> Current devices.c file has a number of instances where
> IO_ADDRESS() is used for system module register
> access. Eliminate this in favor of a ioremap()
> based access.
> 
> Consequent to this, a new global pointer davinci_sysmodbase
> has been introduced which gets initialized during
> the initialization of each relevant SoC.
> 
> In this patch davinci_sysmodbase is used by davinci_setup_mmc
> but the later patches in the series use the same in different
> places using DAVINCI_SYSMODULE_VIRT.This patch lays the
> foundation for that.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  arch/arm/mach-davinci/devices.c               |   23 ++++++++++++++---------
>  arch/arm/mach-davinci/dm355.c                 |    1 +
>  arch/arm/mach-davinci/dm365.c                 |    1 +
>  arch/arm/mach-davinci/dm644x.c                |    1 +
>  arch/arm/mach-davinci/dm646x.c                |    1 +
>  arch/arm/mach-davinci/include/mach/hardware.h |    6 ++++++
>  6 files changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index d3b2040..b7ef950 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -33,6 +33,14 @@
>  #define DM365_MMCSD0_BASE	     0x01D11000
>  #define DM365_MMCSD1_BASE	     0x01D00000
>  
> +void __iomem  *davinci_sysmodbase;
> +
> +void davinci_map_sysmod(void)
> +{
> +	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
> +	WARN_ON(!davinci_sysmodbase);
> +}
> +
>  static struct resource i2c_resources[] = {
>  	{
>  		.start		= DAVINCI_I2C_BASE,
> @@ -210,12 +218,12 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  			davinci_cfg_reg(DM355_SD1_DATA2);
>  			davinci_cfg_reg(DM355_SD1_DATA3);
>  		} else if (cpu_is_davinci_dm365()) {
> -			void __iomem *pupdctl1 =
> -				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE + 0x7c);
> -
>  			/* Configure pull down control */
> -			__raw_writel((__raw_readl(pupdctl1) & ~0xfc0),
> -					pupdctl1);
> +			void __iomem *pupdctl1 = DAVINCI_SYSMODULE_VIRT(0x7c);
> +			unsigned v;
> +
> +			v = __raw_readl(pupdctl1);
> +			__raw_writel(v & ~0xfc0, pupdctl1);

You fixed this as Sergei requested...

>  
>  			mmcsd1_resources[0].start = DM365_MMCSD1_BASE;
>  			mmcsd1_resources[0].end = DM365_MMCSD1_BASE +
> @@ -244,11 +252,8 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>  			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
>  		} else if (cpu_is_davinci_dm644x()) {
>  			/* REVISIT: should this be in board-init code? */
> -			void __iomem *base =
> -				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> -
>  			/* Power-on 3.3V IO cells */
> -			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
> +			writel(0, DAVINCI_SYSMODULE_VIRT(DM64XX_VDD3P3V_PWDN));

.. but forgot to fix this. There is nothing wrong with
using writel, but it doesn't fit into what the subject
of this patch is.

Thanks,
Sekhar

