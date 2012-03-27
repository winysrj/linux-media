Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40185 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2C0PsE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 11:48:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 05/10] uvcvideo: Fix a "ignoring return value of =?UTF-8?B?4oCYX19jbGVhcl91c2Vy4oCZIg==?= warning
Date: Tue, 27 Mar 2012 17:48:01 +0200
Message-ID: <2553055.XH042LfJfh@avalon>
In-Reply-To: <1332676610-14953-6-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-6-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 25 March 2012 13:56:45 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/uvc/uvc_v4l2.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index ff2cddd..8db90ef 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1097,7 +1097,8 @@ static int uvc_v4l2_put_xu_mapping(const struct
> uvc_xu_control_mapping *kp, __put_user(kp->menu_count, &up->menu_count))
>  		return -EFAULT;
> 
> -	__clear_user(up->reserved, sizeof(up->reserved));
> +	if (__clear_user(up->reserved, sizeof(up->reserved)))
> +		return -EFAULT;
> 
>  	if (kp->menu_count == 0)
>  		return 0;

-- 
Regards,

Laurent Pinchart

