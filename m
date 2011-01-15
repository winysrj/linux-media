Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39446 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1AOPou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 10:44:50 -0500
Received: by eye27 with SMTP id 27so1957900eye.19
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 07:44:49 -0800 (PST)
Message-ID: <4D31C0A5.40906@mvista.com>
Date: Sat, 15 Jan 2011 18:43:33 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v14 1/2] davinci vpbe: platform specific additions
References: <1295011872-1094-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1295011872-1094-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On 14-01-2011 16:31, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver.

    It does not only that...

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index 22ebc64..f435c7d 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -33,6 +33,8 @@
>   #define DM365_MMCSD0_BASE	     0x01D11000
>   #define DM365_MMCSD1_BASE	     0x01D00000
>
> +void __iomem  *davinci_sysmodbase;
> +

    I think this should be added in a sperate patch.

> @@ -242,10 +242,7 @@ void __init davinci_setup_mmc(int module, struct davinci_mmc_config *config)
>   							SZ_4K - 1;
>   			mmcsd0_resources[2].start = IRQ_DM365_SDIOINT0;
>   		} else if (cpu_is_davinci_dm644x()) {
> -			/* REVISIT: should this be in board-init code? */

    Why you removed that line?

> -			void __iomem *base =
> -				IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
> -
> +			void __iomem *base = DAVINCI_SYSMODULE_VIRT(0);
>   			/* Power-on 3.3V IO cells */
>   			__raw_writel(0, base + DM64XX_VDD3P3V_PWDN);
>   			/*Set up the pull regiter for MMC */
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
> index 2652af1..106bc1b 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -878,6 +878,9 @@ void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata)
>
>   void __init dm355_init(void)
>   {
> +	davinci_sysmodbase = ioremap_nocache(DAVINCI_SYSTEM_MODULE_BASE, 0x800);
> +	if (!davinci_sysmodbase)
> +		return;

    Why not do it in davinci_common_init() instead of repeating for every SoC?

>   	davinci_common_init(&davinci_soc_info_dm355);
>   }
[...]
> diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
> index 5a1b26d..790925f 100644
> --- a/arch/arm/mach-davinci/include/mach/dm644x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm644x.h
> @@ -40,8 +44,14 @@
>   #define DM644X_ASYNC_EMIF_DATA_CE2_BASE 0x06000000
>   #define DM644X_ASYNC_EMIF_DATA_CE3_BASE 0x08000000
>
> +/* VPBE register base addresses */
> +#define DM644X_VPSS_REG_BASE		0x01c73400
> +#define DM644X_VENC_REG_BASE		0x01C72400
> +#define DM644X_OSD_REG_BASE		0x01C72600

    Note that for other devices we don't have '_REG' in such macros. Would 
make sense to delete it here for consistency.

WBR, Sergei
