Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759809Ab2EKN5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 09:57:10 -0400
Message-ID: <4FAD1AB8.5010103@redhat.com>
Date: Fri, 11 May 2012 15:57:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Fix V4L2 button controls that share the same
 UVC control
References: <1336744559-9247-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1336744559-9247-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

looks good, ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 05/11/2012 03:55 PM, Laurent Pinchart wrote:
> The Logitech pan/tilt reset UVC control contains two V4L2 button
> controls to reset pan and tilt. As the UVC control is not marked as
> auto-update, the button bits are set but never reset. A pan reset that
> follows a tilt reset would thus reset both pan and tilt.
>
> Fix this by not caching the control value of write-only controls. All
> standard UVC controls are either readable or auto-update, so this will
> not cause any regression and will not result in extra USB requests.
>
> Reported-by: Hans de Goede<hdegoede@redhat.com>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/uvc/uvc_ctrl.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index 28363b7..3bc119b 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1348,9 +1348,12 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
>
>   		/* Reset the loaded flag for auto-update controls that were
>   		 * marked as loaded in uvc_ctrl_get/uvc_ctrl_set to prevent
> -		 * uvc_ctrl_get from using the cached value.
> +		 * uvc_ctrl_get from using the cached value, and for write-only
> +		 * controls to prevent uvc_ctrl_set from setting bits not
> +		 * explicitly set by the user.
>   		 */
> -		if (ctrl->info.flags&  UVC_CTRL_FLAG_AUTO_UPDATE)
> +		if (ctrl->info.flags&  UVC_CTRL_FLAG_AUTO_UPDATE ||
> +		    !(ctrl->info.flags&  UVC_CTRL_FLAG_GET_CUR))
>   			ctrl->loaded = 0;
>
>   		if (!ctrl->dirty)
