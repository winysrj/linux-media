Return-Path: <hverkuil@xs4all.nl>
Message-id: <557A9A97.8020103@xs4all.nl>
Date: Fri, 12 Jun 2015 10:38:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media/v4l2-ctrls: Code cleanout validate_new()
References: <1433943509-8782-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1433943509-8782-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

On 06/10/2015 03:38 PM, Ricardo Ribalda Delgado wrote:
> We can simplify the code removing the if().
> 
> v4l2_ctr_new sets ctrls->elems to 1 when !ctrl->is_ptr.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index e3a3468002e6..b6b7dcc1b77d 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1678,21 +1678,6 @@ static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
>  	unsigned idx;
>  	int err = 0;
>  
> -	if (!ctrl->is_ptr) {
> -		switch (ctrl->type) {
> -		case V4L2_CTRL_TYPE_INTEGER:
> -		case V4L2_CTRL_TYPE_INTEGER_MENU:
> -		case V4L2_CTRL_TYPE_MENU:
> -		case V4L2_CTRL_TYPE_BITMASK:
> -		case V4L2_CTRL_TYPE_BOOLEAN:
> -		case V4L2_CTRL_TYPE_BUTTON:
> -		case V4L2_CTRL_TYPE_CTRL_CLASS:
> -		case V4L2_CTRL_TYPE_INTEGER64:
> -			return ctrl->type_ops->validate(ctrl, 0, p_new);
> -		default:
> -			break;
> -		}
> -	}
>  	for (idx = 0; !err && idx < ctrl->elems; idx++)
>  		err = ctrl->type_ops->validate(ctrl, idx, p_new);
>  	return err;
> 
