Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43126 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3JMKgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 06:36:12 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so2791933eek.18
        for <linux-media@vger.kernel.org>; Sun, 13 Oct 2013 03:36:11 -0700 (PDT)
Message-ID: <525A7797.6000605@gmail.com>
Date: Sun, 13 Oct 2013 12:36:07 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media/i2c: ths8200: fix build failure with gcc 4.5.4
References: <20131013101333.GA25034@n2100.arm.linux.org.uk>
In-Reply-To: <20131013101333.GA25034@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 13/10/2013 12:13, Russell King - ARM Linux ha scritto:
> v3.12-rc fails to build with this error:
> 
> drivers/media/i2c/ths8200.c:49:2: error: unknown field 'bt' specified in initializer
> drivers/media/i2c/ths8200.c:50:3: error: field name not in record or union initializer
> drivers/media/i2c/ths8200.c:50:3: error: (near initialization for 'ths8200_timings_cap.reserved')
> drivers/media/i2c/ths8200.c:51:3: error: field name not in record or union initializer
> drivers/media/i2c/ths8200.c:51:3: error: (near initialization for 'ths8200_timings_cap.reserved')
> ...
> 
> with gcc 4.5.4.  This error was not detected in builds prior to v3.12-rc.
> This patch fixes this.

Hi Russel,
this error is already fixed by this patch:

https://patchwork.linuxtv.org/patch/20002/

that has been already accepted and is queued for kernel 3.12.

Regards,
Gianluca

> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/media/i2c/ths8200.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
> index a58a8f6..5ae2a4f 100644
> --- a/drivers/media/i2c/ths8200.c
> +++ b/drivers/media/i2c/ths8200.c
> @@ -46,13 +46,17 @@ struct ths8200_state {
>  
>  static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
>  	.type = V4L2_DV_BT_656_1120,
> -	.bt = {
> -		.max_width = 1920,
> -		.max_height = 1080,
> -		.min_pixelclock = 25000000,
> -		.max_pixelclock = 148500000,
> -		.standards = V4L2_DV_BT_STD_CEA861,
> -		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
> +	/* Allow gcc 4.5.4 to build this */
> +	.reserved = { },
> +	{
> +		.bt = {
> +			.max_width = 1920,
> +			.max_height = 1080,
> +			.min_pixelclock = 25000000,
> +			.max_pixelclock = 148500000,
> +			.standards = V4L2_DV_BT_STD_CEA861,
> +			.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
> +		},
>  	},
>  };
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

