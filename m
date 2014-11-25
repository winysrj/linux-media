Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60503 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbaKYLu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 06:50:29 -0500
Date: Tue, 25 Nov 2014 09:50:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Abel Moyo <abelmoyo.ab@gmail.com>
Cc: jarod@wilsonet.com, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: lirc: lirc_serial: replaced printk with
 pr_debug
Message-ID: <20141125095023.6959c888@recife.lan>
In-Reply-To: <20141121132137.GA23740@gentoodev.infor.com>
References: <20141121132137.GA23740@gentoodev.infor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Nov 2014 14:21:40 +0100
Abel Moyo <abelmoyo.ab@gmail.com> escreveu:

> Replaced printk with pr_debug in dprintk
> 
> Signed-off-by: Abel Moyo <abelmoyo.ab@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_serial.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
> index 181b92b..86c5274 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -116,7 +116,7 @@ static bool txsense;	/* 0 = active high, 1 = active low */
>  #define dprintk(fmt, args...)					\
>  	do {							\
>  		if (debug)					\
> -			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "	\
> +			pr_debug(LIRC_DRIVER_NAME ": "		\
>  			       fmt, ## args);			\
>  	} while (0)
>  

No, this is a bad idea. If dynamic_printk is enabled, in order to
activate the debug messages, it would be required to enable debug
modprobe parameter _and_ to enable each debug msg individually.

We should either use one or the other approach.

Regards,
Mauro
