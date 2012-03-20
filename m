Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab2CTACa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 20:02:30 -0400
Message-ID: <4F67C90F.3030000@redhat.com>
Date: Mon, 19 Mar 2012 21:02:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linuxtv@stefanringel.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/22] mt2063: trivial change
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-02-2012 19:47, linuxtv@stefanringel.de escreveu:
> From: Stefan Ringel <linuxtv@stefanringel.de>
> 
> Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
> ---
>  drivers/media/common/tuners/mt2063.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
> index 0ed9091..872e9c0 100644
> --- a/drivers/media/common/tuners/mt2063.c
> +++ b/drivers/media/common/tuners/mt2063.c
> @@ -1,12 +1,13 @@
>  /*
> - * Driver for mt2063 Micronas tuner
> + * Driver for microtune mt2063 tuner
>   *
>   * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
> + * Copyright (c) 2012 Stefan Ringel <linuxtv@stefanringel.de>
>   *
>   * This driver came from a driver originally written by:
> - *		Henry Wang <Henry.wang@AzureWave.com>
> + *             Henry Wang <Henry.wang@AzureWave.com>
>   * Made publicly available by Terratec, at:
> - *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
> + *     http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
>   * The original driver's license is GPL, as declared with MODULE_LICENSE()
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -29,13 +30,14 @@
>  
>  static unsigned int debug;
>  module_param(debug, int, 0644);
> -MODULE_PARM_DESC(debug, "Set Verbosity level");
> +MODULE_PARM_DESC(debug, "Set debug level");
>  
> -#define dprintk(level, fmt, arg...) do {				\
> -if (debug >= level)							\
> -	printk(KERN_DEBUG "mt2063 %s: " fmt, __func__, ## arg);	\
> -} while (0)
>  
> +/* debug level
> + * 0 don't debug
> + * 1 called functions without i2c comunications
> + * 2 additional calculating, result etc.
> + * 3 maximum debug information

A */ is missing here.

>  
>  /* positive error codes used internally */
>  
> @@ -60,6 +62,10 @@ if (debug >= level)							\
>   *  check against this version number to make sure that
>   *  it matches the version that the tuner driver knows about.
>   */
> +#define dprintk(level, fmt, arg...) do {			\
> +if (debug >= level)						\
> +	printk(KERN_DEBUG "mt2063 %s: " fmt, __func__, ##arg);	\
> +} while (0)
>  
>  /* DECT Frequency Avoidance */
>  #define MT2063_DECT_AVOID_US_FREQS      0x00000001
> @@ -2305,3 +2311,4 @@ EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
>  MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
>  MODULE_DESCRIPTION("MT2063 Silicon tuner");
>  MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.2");

