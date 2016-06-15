Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34524 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161005AbcFOMOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 08:14:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so3542441wmz.1
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2016 05:14:49 -0700 (PDT)
Subject: Re: [PATCH] v4l2-ctrl.h: fix comments
To: Hans Verkuil <hansverk@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
References: <57612985.902@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <509823ac-4d3b-fd20-08fd-764130db261f@gmail.com>
Date: Wed, 15 Jun 2016 13:14:46 +0100
MIME-Version: 1.0
In-Reply-To: <57612985.902@cisco.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/06/16 11:10, Hans Verkuil wrote:
> The comments for the unlocked v4l2_ctrl_s_ctrl* functions were wrong (copy
> and pasted from the locked variants). Fix this, since it is confusing.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 0bc9b35..e9e87e023 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -759,9 +759,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
>    * @ctrl:	The control.
>    * @val:	The new value.
>    *
> - * This set the control's new value safely by going through the control
> - * framework. This function will lock the control's handler, so it cannot be
> - * used from within the &v4l2_ctrl_ops functions.
> + * This sets the control's new value safely by going through the control
> + * framework. This function assumes the control's handler is already locked,
> + * allowing it to be used from within the &v4l2_ctrl_ops functions.
>    *
>    * This function is for integer type controls only.
>    */
> @@ -771,7 +771,7 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
>    * @ctrl:	The control.
>    * @val:	The new value.
>    *
> - * This set the control's new value safely by going through the control
> + * This sets the control's new value safely by going through the control
>    * framework. This function will lock the control's handler, so it cannot be
>    * used from within the &v4l2_ctrl_ops functions.
>    *
> @@ -807,9 +807,9 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
>    * @ctrl:	The control.
>    * @val:	The new value.
>    *
> - * This set the control's new value safely by going through the control
> - * framework. This function will lock the control's handler, so it cannot be
> - * used from within the &v4l2_ctrl_ops functions.
> + * This sets the control's new value safely by going through the control
> + * framework. This function assumes the control's handler is already locked,
> + * allowing it to be used from within the &v4l2_ctrl_ops functions.
>    *
>    * This function is for 64-bit integer type controls only.
>    */
> @@ -821,9 +821,9 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
>    * @ctrl:	The control.
>    * @val:	The new value.
>    *
> - * This set the control's new value safely by going through the control
> - * framework. This function will lock the control's handler, so it cannot be
> - * used from within the &v4l2_ctrl_ops functions.
> + * This sets the control's new value safely by going through the control
> + * framework. This function does not lock the control's handler, allowing it to
> + * be used from within the &v4l2_ctrl_ops functions.
>    *
>    * This function is for 64-bit integer type controls only.
>    */
I think this comment is above v4l2_ctrl_s_ctrl_int64, without the 
underscores. Doesn't this fn take the lock, or have I missed a patch 
that removes that?

> @@ -843,9 +843,9 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
>    * @ctrl:	The control.
>    * @s:		The new string.
>    *
> - * This set the control's new string safely by going through the control
> - * framework. This function will lock the control's handler, so it cannot be
> - * used from within the &v4l2_ctrl_ops functions.
> + * This sets the control's new string safely by going through the control
> + * framework. This function assumes the control's handler is already locked,
> + * allowing it to be used from within the &v4l2_ctrl_ops functions.
>    *
>    * This function is for string type controls only.
>    */
> @@ -857,7 +857,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
>    * @ctrl:	The control.
>    * @s:		The new string.
>    *
> - * This set the control's new string safely by going through the control
> + * This sets the control's new string safely by going through the control
>    * framework. This function will lock the control's handler, so it cannot be
>    * used from within the &v4l2_ctrl_ops functions.
>    *
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Regards,
Ian
