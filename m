Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47386 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbeHGBL0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 21:11:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: fix spelling mistake: "entites" -> "entities"
Date: Tue, 07 Aug 2018 02:00:51 +0300
Message-ID: <8293370.T3EEA9t51a@avalon>
In-Reply-To: <20170703093151.11285-1-colin.king@canonical.com>
References: <20170703093151.11285-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

Thank you for the patch.

On Monday, 3 July 2017 12:31:51 EEST Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in uvc_printk message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 70842c5af05b..9901025c4605
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1995,7 +1995,7 @@ static int uvc_register_chains(struct uvc_device *dev)
> #ifdef CONFIG_MEDIA_CONTROLLER
>  		ret = uvc_mc_register_entities(chain);
>  		if (ret < 0) {
> -			uvc_printk(KERN_INFO, "Failed to register entites "
> +			uvc_printk(KERN_INFO, "Failed to register entities "
>  				"(%d).\n", ret);
>  		}

While at it, let's remove the string wrapping, and the unneeded curly braces.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with that change.

>  #endif


-- 
Regards,

Laurent Pinchart
