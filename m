Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0GZRel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 13:34:41 -0400
Received: by pwi5 with SMTP id 5so162035pwi.19
        for <linux-media@vger.kernel.org>; Mon, 26 Jul 2010 10:34:41 -0700 (PDT)
Date: Mon, 26 Jul 2010 10:34:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] IR/imon: remove incorrect calls to input_free_device
Message-ID: <20100726173428.GA14609@core.coreip.homeip.net>
References: <20100726141352.GA28182@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726141352.GA28182@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 26, 2010 at 10:13:52AM -0400, Jarod Wilson wrote:
> Per Dmitry Torokhov (in a completely unrelated thread on linux-input),
> following input_unregister_device with an input_free_device is
> forbidden, the former is sufficient alone.
> 
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Random notes about irmon:

imon_init_idev():
	memcpy(&ir->dev, ictx->dev, sizeof(struct device));

This is... scary.  Devices are refcounted and if you copy them around
all hell may break loose. On an unrelated note you do not need memcpy to
copy a structire, *it->dev = *ictx->dev will do.

imon_init_idev(), imon_init_touch(): - consizer returning proper error
codes via ERR_PTR() and check wit IS_ERR().

> ---
>  drivers/media/IR/imon.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
> index 0195dd5..08dff8c 100644
> --- a/drivers/media/IR/imon.c
> +++ b/drivers/media/IR/imon.c
> @@ -1944,7 +1944,6 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
>  
>  urb_submit_failed:
>  	ir_input_unregister(ictx->idev);
> -	input_free_device(ictx->idev);
>  idev_setup_failed:
>  find_endpoint_failed:
>  	mutex_unlock(&ictx->lock);
> @@ -2014,10 +2013,8 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
>  	return ictx;
>  
>  urb_submit_failed:
> -	if (ictx->touch) {
> +	if (ictx->touch)
>  		input_unregister_device(ictx->touch);
> -		input_free_device(ictx->touch);
> -	}
>  touch_setup_failed:
>  find_endpoint_failed:
>  	mutex_unlock(&ictx->lock);

Thanks.

-- 
Dmitry
