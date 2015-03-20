Return-Path: <laurent.pinchart@ideasonboard.com>
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] media/v4l2-ctrls: Add execute flags to write_only
 controls
Date: Fri, 20 Mar 2015 16:16:34 +0200
Message-id: <109760717.s0Nhh47aeC@avalon>
In-reply-to: <1426778486-21807-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
 <1426778486-21807-4-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Thursday 19 March 2015 16:21:24 Ricardo Ribalda Delgado wrote:
> Any control that sets FLAG_WRITE_ONLY should OR it with FLAG_ACTION.

Do you mean FLAG_EXECUTE_ON_WRITE ?

> So we can  keep the current meaning of WRITE_ONLY.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index 627d4c7..da0ffd3 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -991,7 +991,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_AUTO_FOCUS_START:
>  	case V4L2_CID_AUTO_FOCUS_STOP:
>  		*type = V4L2_CTRL_TYPE_BUTTON;
> -		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
> +		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
> +			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
>  		*min = *max = *step = *def = 0;
>  		break;
>  	case V4L2_CID_POWER_LINE_FREQUENCY:
> @@ -1172,7 +1173,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_FOCUS_RELATIVE:
>  	case V4L2_CID_IRIS_RELATIVE:
>  	case V4L2_CID_ZOOM_RELATIVE:
> -		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
> +		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
> +			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
>  		break;
>  	case V4L2_CID_FLASH_STROBE_STATUS:
>  	case V4L2_CID_AUTO_FOCUS_STATUS:
> @@ -1983,7 +1985,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> v4l2_ctrl_handler *hdl,
> 
>  	sz_extra = 0;
>  	if (type == V4L2_CTRL_TYPE_BUTTON)
> -		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
> +		flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
> +			V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
>  	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
>  		flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  	else if (type == V4L2_CTRL_TYPE_INTEGER64 ||

-- 
Regards,

Laurent Pinchart
