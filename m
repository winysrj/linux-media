Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2LULKn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 06:10:43 -0500
Message-ID: <50D4442E.5070902@redhat.com>
Date: Fri, 21 Dec 2012 12:12:46 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@redhat.com, patches@linaro.org
Subject: Re: [PATCH 1/1] gspca: Use module_usb_driver macro
References: <1355302692-28475-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1355302692-28475-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/12/2012 09:58 AM, Sachin Kamat wrote:
> module_usb_driver eliminates a lot of boilerplate by replacing
> module_init() and module_exit() calls.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks I've added this patch to my tree, and it will be included
in my fixes pull-req for 3.8 to Mauro later today.

Regards,

Hans

> ---
> Compile tested with linux-next
> ---
>   drivers/media/usb/gspca/jl2005bcd.c |   18 +-----------------
>   1 files changed, 1 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
> index 62ba80d..fdaeeb1 100644
> --- a/drivers/media/usb/gspca/jl2005bcd.c
> +++ b/drivers/media/usb/gspca/jl2005bcd.c
> @@ -536,20 +536,4 @@ static struct usb_driver sd_driver = {
>   #endif
>   };
>
> -/* -- module insert / remove -- */
> -static int __init sd_mod_init(void)
> -{
> -	int ret;
> -
> -	ret = usb_register(&sd_driver);
> -	if (ret < 0)
> -		return ret;
> -	return 0;
> -}
> -static void __exit sd_mod_exit(void)
> -{
> -	usb_deregister(&sd_driver);
> -}
> -
> -module_init(sd_mod_init);
> -module_exit(sd_mod_exit);
> +module_usb_driver(sd_driver);
>
