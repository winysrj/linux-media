Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4035 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab0KUVSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 16:18:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/5] uvcvideo: Lock controls mutex when querying menus
Date: Sun, 21 Nov 2010 22:18:41 +0100
Cc: linux-media@vger.kernel.org
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290371573-14907-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011212218.41564.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Just one comment:

On Sunday, November 21, 2010 21:32:49 Laurent Pinchart wrote:
> uvc_find_control() must be called with the controls mutex locked. Fix
> uvc_query_v4l2_menu() accordingly.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   48 +++++++++++++++++++++++++++++++++++-
>  drivers/media/video/uvc/uvc_v4l2.c |   36 +--------------------------
>  drivers/media/video/uvc/uvcvideo.h |    4 +-
>  3 files changed, 50 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index f169f77..59f8a9a 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -785,7 +785,7 @@ static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
>  	}
>  }
>  
> -struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
> +static struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
>  	__u32 v4l2_id, struct uvc_control_mapping **mapping)
>  {
>  	struct uvc_control *ctrl = NULL;
> @@ -944,6 +944,52 @@ done:
>  	return ret;
>  }
>  
> +/*
> + * Mapping V4L2 controls to UVC controls can be straighforward if done well.
> + * Most of the UVC controls exist in V4L2, and can be mapped directly. Some
> + * must be grouped (for instance the Red Balance, Blue Balance and Do White
> + * Balance V4L2 controls use the White Balance Component UVC control) or
> + * otherwise translated. The approach we take here is to use a translation
> + * table for the controls that can be mapped directly, and handle the others
> + * manually.
> + */
> +int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
> +	struct v4l2_querymenu *query_menu)
> +{
> +	struct uvc_menu_info *menu_info;
> +	struct uvc_control_mapping *mapping;
> +	struct uvc_control *ctrl;
> +	u32 index = query_menu->index;
> +	u32 id = query_menu->id;
> +	int ret;
> +
> +	memset(query_menu, 0, sizeof(*query_menu));
> +	query_menu->id = id;
> +	query_menu->index = index;
> +
> +	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
> +	if (ret < 0)
> +		return -ERESTARTSYS;

Just return 'ret' here (which is -EINTR).

> +
> +	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
> +	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	if (query_menu->index >= mapping->menu_count) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	menu_info = &mapping->menu_info[query_menu->index];
> +	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
> +
> +done:
> +	mutex_unlock(&chain->ctrl_mutex);
> +	return ret;
> +}
> +

<snip>

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
