Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3739 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZCJI23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:28:29 -0400
Message-ID: <5974.62.70.2.252.1236673681.squirrel@webmail.xs4all.nl>
Date: Tue, 10 Mar 2009 09:28:01 +0100 (CET)
Subject: Re: [patch review] radio-terratec: remove unused delay.h
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Douglas Schilling Landgraf" <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello, all
>
> I don't know if this patch okay, so it should be tested/reviewed.
> Anyway, compilation process shows no warnings.
>
> ---
> Patch removes linux/delay.h which hadn't been used.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

Looks good.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

>
> --
> diff -r 615fb8f01610 linux/drivers/media/radio/radio-terratec.c
> --- a/linux/drivers/media/radio/radio-terratec.c	Tue Mar 10 02:33:02 2009
> -0300
> +++ b/linux/drivers/media/radio/radio-terratec.c	Tue Mar 10 09:49:36 2009
> +0300
> @@ -27,7 +27,6 @@
>  #include <linux/module.h>	/* Modules 			*/
>  #include <linux/init.h>		/* Initdata			*/
>  #include <linux/ioport.h>	/* request_region		*/
> -#include <linux/delay.h>	/* udelay			*/
>  #include <linux/videodev2.h>	/* kernel radio structs		*/
>  #include <linux/mutex.h>
>  #include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
>
>
> --
> Best regards, Klimov Alexey
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

