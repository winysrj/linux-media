Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3020 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3C1Ldq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 07:33:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] uvcvideo: Return -EINVAL when setting a menu control to an invalid value
Date: Thu, 28 Mar 2013 12:33:40 +0100
Cc: linux-media@vger.kernel.org
References: <1364469056-31298-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1364469056-31298-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281233.40692.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu March 28 2013 12:10:56 Laurent Pinchart wrote:
> -ERANGE is the right error code when the value is outside of the menu
> range, but -EINVAL must be reported for invalid values inside the range.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 61e28de..a2f4501 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1487,7 +1487,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  			step = mapping->get(mapping, UVC_GET_RES,
>  					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
>  			if (!(step & value))
> -				return -ERANGE;
> +				return -EINVAL;
>  		}
>  
>  		break;
> 
