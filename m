Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48157 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaAWLcB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 06:32:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: oliver@neukum.org
Cc: linux-media@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] uvc: simplify redundant check
Date: Thu, 23 Jan 2014 12:32:47 +0100
Message-ID: <4763775.AWFediJpdO@avalon>
In-Reply-To: <1390472905-29586-1-git-send-email-oliver@neukum.org>
References: <1390472905-29586-1-git-send-email-oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Thank you for the patch.

On Thursday 23 January 2014 11:28:24 oliver@neukum.org wrote:
> From: Oliver Neukum <oneukum@suse.de>
> 
> x < constant implies x + unsigned < constant
> That check just obfuscates the code
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree and will send a pull request for v3.15.

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index c3bb250..b6cac17 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -925,7 +925,7 @@ static int uvc_parse_standard_control(struct uvc_device
> *dev, case UVC_VC_HEADER:
>  		n = buflen >= 12 ? buffer[11] : 0;
> 
> -		if (buflen < 12 || buflen < 12 + n) {
> +		if (buflen < 12 + n) {
>  			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
>  				"interface %d HEADER error\n", udev->devnum,
>  				alts->desc.bInterfaceNumber);

-- 
Regards,

Laurent Pinchart

