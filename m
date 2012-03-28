Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42011 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2C1J0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 05:26:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 06/10] uvcvideo: Refactor uvc_ctrl_get and query
Date: Wed, 28 Mar 2012 11:26:02 +0200
Message-ID: <1729080.0sJlyC7hov@avalon>
In-Reply-To: <1332676610-14953-7-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-7-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 25 March 2012 13:56:46 Hans de Goede wrote:
> This is a preparation patch for adding ctrl event support.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   69
> ++++++++++++++++++++++++------------ 1 file changed, 46 insertions(+), 23
> deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 0efd3b1..4002b5b 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -899,24 +899,14 @@ static int uvc_ctrl_populate_cache(struct
> uvc_video_chain *chain, return 0;
>  }
> 
> -int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
> +static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
> +	struct uvc_control *ctrl,
> +	struct uvc_control_mapping *mapping,
>  	struct v4l2_queryctrl *v4l2_ctrl)
>  {
> -	struct uvc_control *ctrl;
> -	struct uvc_control_mapping *mapping;
>  	struct uvc_menu_info *menu;
>  	unsigned int i;
> -	int ret;
> -
> -	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
> -	if (ret < 0)
> -		return -ERESTARTSYS;
> -

Now that this function doesn't lock a mutex, you can replace the goto done 
statements with return ret (patch 09/10 adds a goto done that will need to be 
replaced as well). With this change,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> -	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
> -	if (ctrl == NULL) {
> -		ret = -EINVAL;
> -		goto done;
> -	}
> +	int ret = 0;
> 
>  	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
>  	v4l2_ctrl->id = mapping->id;
> @@ -985,6 +975,28 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
>  				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
> 
>  done:
> +	return ret;
> +}

-- 
Regards,

Laurent Pinchart

