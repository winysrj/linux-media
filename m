Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51398 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbJZDZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 23:25:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Anton V. Shokurov" <shokurov.anton.v@yandex.ru>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fix reading the current exposure value of UVC
Date: Mon, 26 Oct 2015 05:25:40 +0200
Message-ID: <23322093.WD04LuM9l7@avalon>
In-Reply-To: <1445202086-3689-1-git-send-email-shokurov.anton.v@yandex.ru>
References: <1445202086-3689-1-git-send-email-shokurov.anton.v@yandex.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anton,

Thank you for the patch.

On Sunday 18 October 2015 17:01:26 Anton V. Shokurov wrote:
> V4L2_CID_EXPOSURE_ABSOLUTE property does not return an updated value when
> autoexposure (V4L2_CID_EXPOSURE_AUTO) is turned on. This patch fixes this
> issue by adding the UVC_CTRL_FLAG_AUTO_UPDATE flag.
> 
> Tested on a C920 camera.

This looks good to me and I've successfully tested the patch.

> Signed-off-by: Anton V. Shokurov <shokurov.anton.v@yandex.ru>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree, I'll push it upstream for v4.5 (the merge window for v4.4 
will open in a week only and with the Kernel Summit going on this week pushing 
patches for v4.4 is difficult).

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 3e59b28..c2ee6e3 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -227,7 +227,8 @@ static struct uvc_control_info uvc_ctrls[] = {
>  		.size		= 4,
>  		.flags		= UVC_CTRL_FLAG_SET_CUR
> 
>  				| UVC_CTRL_FLAG_GET_RANGE
> 
> -				| UVC_CTRL_FLAG_RESTORE,
> +				| UVC_CTRL_FLAG_RESTORE
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
>  	},
>  	{
>  		.entity		= UVC_GUID_UVC_CAMERA,

-- 
Regards,

Laurent Pinchart
