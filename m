Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:54184 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZFZScE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:32:04 -0400
Received: by ewy6 with SMTP id 6so3639971ewy.37
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 11:32:06 -0700 (PDT)
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>
Subject: Re: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video: Platform and board specific setup
References: <1241789157-23350-1-git-send-email-chaithrika@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 26 Jun 2009 11:32:02 -0700
In-Reply-To: <1241789157-23350-1-git-send-email-chaithrika@ti.com> (Chaithrika U. S.'s message of "Fri\,  8 May 2009 09\:25\:57 -0400")
Message-ID: <87ljneeti5.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chaithrika U S <chaithrika@ti.com> writes:

> Platform specific display device setup for DM646x EVM
>
> Add platform device and resource structures. Also define a platform specific
> clock setup function that can be accessed by the driver to configure the clock
> and CPLD.
>
> This patch is dependent on a patch submitted earlier, which adds
> Pin Mux and clock definitions for Video on DM646x.
>
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> Applies to Davinci GIT tree

Needs an update to apply to current linus or davinci git.

Other comments below...

[...]

>  static __init void davinci_dm646x_evm_irq_init(void)
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
> index 3cd09c1..94e17a3 100644
> --- a/arch/arm/mach-davinci/dm646x.c
> +++ b/arch/arm/mach-davinci/dm646x.c

[...]

> +static u64 vpif_dma_mask = DMA_32BIT_MASK;

This usage is deprecated, it should be DMA_BIT_MASK(32) as all the
other uses in mach-davinci/*

[...]

> index 7afc613..9c3666c 100644
> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> @@ -12,6 +12,7 @@
>  #define __ASM_ARCH_DM646X_H
>  
>  #include <linux/platform_device.h>
> +#include <linux/i2c.h>

This part needs a refresh against current trees, but also please drop
this include, I don't see any users of i2c stuff in this file.

Kevin
