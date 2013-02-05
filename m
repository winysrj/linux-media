Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab3BEXXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 18:23:19 -0500
Date: Tue, 5 Feb 2013 21:23:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Petter Selasky <hselasky@c2i.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Correctly set data for USB request in case of a
 previous failure.
Message-ID: <20130205212308.2158a854@redhat.com>
In-Reply-To: <201301141606.20156.hselasky@c2i.net>
References: <201301141355.52394.hselasky@c2i.net>
	<201301141606.20156.hselasky@c2i.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Jan 2013 16:06:20 +0100
Hans Petter Selasky <hselasky@c2i.net> escreveu:

> Improved patch follows:

It would be even more improved if you send it to the right ML ;)

I suspect that your original intention were to send it to
linux-input ML, instead of linux-media :)

Regards,
Mauro

> 
> --HPS
> 
> From a88d72d2108f92f004a3f050a708d9b7f661f924 Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 14 Jan 2013 13:53:21 +0100
> Subject: [PATCH] Correctly initialize data for USB request.
> 
> Found-by: Jan Beich
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/input/tablet/wacom.h     | 1 +
>  drivers/input/tablet/wacom_sys.c | 8 +++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
> index b79d451..d6fad87 100644
> --- a/drivers/input/tablet/wacom.h
> +++ b/drivers/input/tablet/wacom.h
> @@ -89,6 +89,7 @@
>  #include <linux/init.h>
>  #include <linux/usb/input.h>
>  #include <linux/power_supply.h>
> +#include <linux/string.h>
>  #include <asm/unaligned.h>
>  
>  /*
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index f92d34f..23bc71e 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -553,10 +553,12 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
>  	if (!rep_data)
>  		return error;
>  
> -	rep_data[0] = report_id;
> -	rep_data[1] = mode;
> -
>  	do {
> +		memset(rep_data, 0, length);
> +
> +		rep_data[0] = report_id;
> +		rep_data[1] = mode;
> +
>  		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
>  		                         report_id, rep_data, length, 1);
>  		if (error >= 0)


-- 

Cheers,
Mauro
