Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab1IWU2N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 16:28:13 -0400
Message-ID: <4E7CEBD9.70707@redhat.com>
Date: Fri, 23 Sep 2011 17:28:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  4/17]DVB:Siano drivers -  Add support in new Siano SDIO
 devices.
References: <1316514663.5199.82.camel@Doron-Ubuntu>
In-Reply-To: <1316514663.5199.82.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-09-2011 07:31, Doron Cohen escreveu:
> Hi, 
> This patch adds support in newer devices.
> 
> Thanks,
> Doron Cohen
> 
> ------------------
> 
>>From 7714e418af56ae73d760cfa39b9e7b99d4dc3aa2 Mon Sep 17 00:00:00 2001
> From: Doron Cohen <doronc@siano-ms.com>
> Date: Thu, 15 Sep 2011 14:40:03 +0300
> Subject: [PATCH 07/21] Add support to new siano DSIO devices.
> 
> ---
>  drivers/media/dvb/siano/sms-cards.h |   10 ++++++++++
>  drivers/media/dvb/siano/smssdio.c   |   13 +++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/siano/sms-cards.h
> b/drivers/media/dvb/siano/sms-cards.h
> index d8cdf75..1c2159b 100644
> --- a/drivers/media/dvb/siano/sms-cards.h
> +++ b/drivers/media/dvb/siano/sms-cards.h
> @@ -22,7 +22,9 @@
>  
>  #include <linux/usb.h>
>  #include "smscoreapi.h"
> +#ifdef SMS_RC_SUPPORT_SUBSYS
>  #include "smsir.h"
> +#endif

Don't mix it on this patch. I would have applied the rest of the patch,
if it was not because of this.

>  
>  #define SMS_BOARD_UNKNOWN 0
>  #define SMS1XXX_BOARD_SIANO_STELLAR 1
> @@ -37,6 +39,14 @@
>  #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
>  #define SMS1XXX_BOARD_SIANO_NICE	11
>  #define SMS1XXX_BOARD_SIANO_VENICE	12
> +#define SMS1XXX_BOARD_SIANO_STELLAR_ROM 13
> +#define SMS1XXX_BOARD_ZTE_DVB_DATA_CARD	14
> +#define SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD 15
> +#define SMS1XXX_BOARD_SIANO_MING	16
> +#define SMS1XXX_BOARD_SIANO_PELE	17
> +#define SMS1XXX_BOARD_SIANO_RIO		18
> +#define SMS1XXX_BOARD_SIANO_DENVER_1530	19
> +#define SMS1XXX_BOARD_SIANO_DENVER_2160 20
>  
>  struct sms_board_gpio_cfg {
>  	int lna_vhf_exist;
> diff --git a/drivers/media/dvb/siano/smssdio.c
> b/drivers/media/dvb/siano/smssdio.c
> index e57d38b..e5705c3 100644
> --- a/drivers/media/dvb/siano/smssdio.c
> +++ b/drivers/media/dvb/siano/smssdio.c
> @@ -3,8 +3,7 @@
>   *
>   *  Copyright 2008 Pierre Ossman
>   *
> - * Based on code by Siano Mobile Silicon, Inc.,
> - * Copyright (C) 2006-2008, Uri Shkolnik
> + * Copyright (C) 2006-20011, Siano Mobile Silicon (Doron Cohen)
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -60,6 +59,16 @@ static const struct sdio_device_id smssdio_ids[]
> __devinitconst = {
>  	 .driver_data = SMS1XXX_BOARD_SIANO_VEGA},
>  	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_VENICE),
>  	 .driver_data = SMS1XXX_BOARD_SIANO_VEGA},
> +	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x302),
> +	 .driver_data = SMS1XXX_BOARD_SIANO_MING},
> +	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x500),
> +	 .driver_data = SMS1XXX_BOARD_SIANO_PELE},
> +	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x600),
> +	 .driver_data = SMS1XXX_BOARD_SIANO_RIO},
> +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x700),
> +	 .driver_data = SMS1XXX_BOARD_SIANO_DENVER_2160},
> +	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x800),
> +	 .driver_data = SMS1XXX_BOARD_SIANO_DENVER_1530},
>  	{ /* end: all zeroes */ },
>  };
>  

