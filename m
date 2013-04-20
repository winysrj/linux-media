Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59620 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091Ab3DTALi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 20:11:38 -0400
Received: by mail-lb0-f182.google.com with SMTP id z13so4235049lbh.13
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 17:11:36 -0700 (PDT)
Message-ID: <5171DD05.6020400@cogentembedded.com>
Date: Sat, 20 Apr 2013 04:10:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: linux-media@vger.kernel.org, matsu@igel.co.jp,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH v2 2/4] ARM: shmobile: r8a7779: add VIN support
References: <201304200232.33731.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304200232.33731.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/20/2013 02:32 AM, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Add VIN clocks and platform devices for R8A7779 SoC; add function to register
> the VIN platform devices.
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: added 'id' parameter check to r8a7779_add_vin_device(), renamed some
> variables.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

> Index: renesas/arch/arm/mach-shmobile/setup-r8a7779.c
> ===================================================================
> --- renesas.orig/arch/arm/mach-shmobile/setup-r8a7779.c
> +++ renesas/arch/arm/mach-shmobile/setup-r8a7779.c
> @@ -559,6 +559,33 @@ static struct resource ether_resources[]
>   	},
>   };
>   
> +#define R8A7779_VIN(idx) \
> +static struct resource vin##idx##_resources[] = {		\
> +	DEFINE_RES_MEM(0xffc50000 + 0x1000 * (idx), 0x1000),	\
> +	DEFINE_RES_IRQ(gic_iid(0x5f + (idx))),			\
> +};								\
> +								\
> +static struct platform_device_info vin##idx##_info = {		\

    Hm, probably should have marked this as '__initdata'... maybe
the resources too.

> +	.parent		= &platform_bus,			\
> +	.name		= "rcar_vin",				\
> +	.id		= idx,					\
> +	.res		= vin##idx##_resources,			\
> +	.num_res	= ARRAY_SIZE(vin##idx##_resources),	\
> +	.dma_mask	= DMA_BIT_MASK(32),			\
> +}
>
