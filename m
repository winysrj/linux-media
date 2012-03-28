Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42006 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2C1JZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 05:25:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 08/10] uvcvideo: Add support for control events
Date: Wed, 28 Mar 2012 11:25:42 +0200
Message-ID: <28979159.CzXl5SMJNn@avalon>
In-Reply-To: <1332676610-14953-9-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-9-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 25 March 2012 13:56:48 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

After addressing the two small comments below,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/uvc/uvc_ctrl.c |  119 ++++++++++++++++++++++++++++++++-
>  drivers/media/video/uvc/uvc_v4l2.c |   42 ++++++++++---
>  drivers/media/video/uvc/uvcvideo.h |   18 ++++--
>  3 files changed, 165 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index fc979c6..742496f 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c

[snip]

> +static void uvc_ctrl_send_events(struct uvc_fh *handle,
> +	struct v4l2_ext_control *xctrls, int xctrls_count)
> +{
> +	struct uvc_control_mapping *mapping;
> +	struct uvc_control *ctrl;
> +	int i;

Could you please make i an unsigned int ?

> +
> +	for (i = 0; i < xctrls_count; ++i) {
> +		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
> +		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> +				    V4L2_EVENT_CTRL_CH_VALUE);
> +	}
> +}
> +

[snip]

> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 67f88d8..649a0bb 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h

[snip]

> @@ -655,14 +661,16 @@ extern void uvc_ctrl_cleanup_device(struct uvc_device
> *dev); extern int uvc_ctrl_resume_device(struct uvc_device *dev);
> 
>  extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
> -extern int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback);
> -static inline int uvc_ctrl_commit(struct uvc_video_chain *chain)
> +extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
> +			struct v4l2_ext_control *xctrls, int xctrls_count);

You can make the struct v4l2_ext_control *xctrls argument const.

> +static inline int uvc_ctrl_commit(struct uvc_fh *handle,
> +			struct v4l2_ext_control *xctrls, int xctrls_count)
>  {
> -	return __uvc_ctrl_commit(chain, 0);
> +	return __uvc_ctrl_commit(handle, 0, xctrls, xctrls_count);
>  }
> -static inline int uvc_ctrl_rollback(struct uvc_video_chain *chain)
> +static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
>  {
> -	return __uvc_ctrl_commit(chain, 1);
> +	return __uvc_ctrl_commit(handle, 1, NULL, 0);
>  }
> 
>  extern int uvc_ctrl_get(struct uvc_video_chain *chain,

-- 
Regards,

Laurent Pinchart

