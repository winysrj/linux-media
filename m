Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42421 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2AEPw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 10:52:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 01/17] v4l: Introduce integer menu controls
Date: Thu, 5 Jan 2012 16:53:15 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201051653.16144.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:27:53 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Create a new control type called V4L2_CTRL_TYPE_INTEGER_MENU. Integer menu
> controls are just like menu controls but the menu items are 64-bit integers
> rather than strings.

[snip]

> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 0f415da..083bb79 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c

> @@ -1775,16 +1797,22 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl,
> struct v4l2_querymenu *qm)
> 
>  	qm->reserved = 0;
>  	/* Sanity checks */

You should return -EINVAL here if the control is not of a menu type. It was 
done implictly before by the ctrl->qmenu == NULL check, but that's now 
conditioned to the control type being V4L2_CTRL_TYPE_MENU.

> -	if (ctrl->qmenu == NULL ||
> +	if ((ctrl->type == V4L2_CTRL_TYPE_MENU && ctrl->qmenu == NULL) ||
> +	    (ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU
> +	     && ctrl->qmenu_int == NULL) ||
>  	    i < ctrl->minimum || i > ctrl->maximum)
>  		return -EINVAL;
>  	/* Use mask to see if this menu item should be skipped */
>  	if (ctrl->menu_skip_mask & (1 << i))
>  		return -EINVAL;
>  	/* Empty menu items should also be skipped */
> -	if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
> -		return -EINVAL;
> -	strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
> +	if (ctrl->type == V4L2_CTRL_TYPE_MENU) {
> +		if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
> +			return -EINVAL;
> +		strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
> +	} else if (ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU) {

And you can then replace the else if by an else.

> +		qm->value = ctrl->qmenu_int[i];
> +	}
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_querymenu);

-- 
Regards,

Laurent Pinchart
