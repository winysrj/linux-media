Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40967 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0LWRuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 12:50:50 -0500
Received: by ewy5 with SMTP id 5so3183249ewy.19
        for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010 09:50:49 -0800 (PST)
Message-ID: <4D138BAA.3060500@mvista.com>
Date: Thu, 23 Dec 2010 20:49:30 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v10 5/8] davinci vpbe: platform specific additions
References: <1293115392-21131-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1293115392-21131-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver

> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index 9a2376b..eb87867 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -370,6 +370,7 @@ static struct platform_device dm644x_mdio_device = {
>   *	soc	description	mux  mode   mode  mux	 dbg
>   *				reg  offset mask  mode
>   */
> +

    Stray newline?

[...]
> +static struct resource dm644x_venc_resources[] = {
> +	/* venc registers io space */
> +	{
> +		.start  = 0x01C72400,
> +		.end    = 0x01C72400 + 0x17f,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +};
> +
[...]
> +static struct resource dm644x_v4l2_disp_resources[] = {
> +	{
> +		.start  = IRQ_VENCINT,
> +		.end    = IRQ_VENCINT,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	{
> +		.start  = 0x01C724B8,
> +		.end    = 0x01C724B8 + 0x3,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +};

    Still intersects with dm644x_venc_resources[]. Is it intended?

>  static int __init dm644x_init_devices(void)
>  {
>  	if (!cpu_is_davinci_dm644x())
>  		return 0;
>  
> -	/* Add ccdc clock aliases */
> -	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> -	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
>  	platform_device_register(&dm644x_edma_device);
> -

    Should've left this newline alone...

WBR, Sergei

