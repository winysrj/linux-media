Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33383 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1AQTls (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 14:41:48 -0500
Received: by eye27 with SMTP id 27so2852815eye.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 11:41:47 -0800 (PST)
Message-ID: <4D349B25.8070606@mvista.com>
Date: Mon, 17 Jan 2011 22:40:21 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v15 1/3] davinci vpbe: platform specific additions
References: <1295273627-14630-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1295273627-14630-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver, initializes the platform variables and implements
> platform functions including setting video clocks.

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..45a89a8 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
[...]
> @@ -781,25 +915,38 @@ void __init dm644x_init(void)
>  	davinci_common_init(&davinci_soc_info_dm644x);
>  }
>  
> +static struct platform_device *dm644x_video_devices[] __initdata = {
> +	&dm644x_vpss_device,
> +	&dm644x_ccdc_dev,
> +	&vpfe_capture_dev,
> +	&dm644x_osd_dev,
> +	&dm644x_venc_dev,
> +	&dm644x_vpbe_dev,
> +	&vpbe_v4l2_display,
> +};
> +
> +static int __init dm644x_init_video(void)
> +{
> +	/* Add ccdc clock aliases */
> +	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> +	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
> +	vpss_clkctl_reg = DAVINCI_SYSMODULE_VIRT(0x44);

    Patch 3 should clearly precede this one, as it defines 
DAVINCI_SYSMODULE_VIRT()...

WBR, Sergei
