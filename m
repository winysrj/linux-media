Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42063 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab1CNONU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 10:13:20 -0400
Received: by wwa36 with SMTP id 36so5700306wwa.1
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 07:13:19 -0700 (PDT)
Message-ID: <4D7E21FF.4050305@mvista.com>
Date: Mon, 14 Mar 2011 17:11:11 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/7] davinci: eliminate use of IO_ADDRESS() on sysmod
References: <1300110947-16229-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1300110947-16229-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Manjunath Hadli wrote:

> Current devices.c file has a number of instances where
> IO_ADDRESS() is used for system module register
> access. Eliminate this in favor of a ioremap()
> based access.

> Consequent to this, a new global pointer davinci_sysmodbase
> has been introduced which gets initialized during
> the initialization of each relevant SoC

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
[...]

> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index d3b2040..66a948d 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
[...]
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
> +			v = readl(pupdctl1);
> +			writel(v & ~0xfc0, pupdctl1);

    Why are you changing from __raw_{readl|writel}() to {readl|writel}()? You 
don't mention it in the change log...

WBR, Sergei

