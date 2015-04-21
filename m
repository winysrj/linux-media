Return-Path: <laurent.pinchart@ideasonboard.com>
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 1/5] media/v4l2-ctrls: volatiles should not generate
 CH_VALUE
Date: Tue, 21 Apr 2015 20:44:34 +0300
Message-id: <1532862.VB4B3JqLyH@avalon>
In-reply-to: <1426858247-25746-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1426858247-25746-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch, and sorry for the late review (so late that the patch 
has already been merged).

On Friday 20 March 2015 14:30:46 Ricardo Ribalda Delgado wrote:
> Volatile controls should not generate CH_VALUE events.

What's the rationale for that ? I would actually expect the value change 
events to be more useful for volatile controls than non-volatile controls. 
Volatile controls can have their value changed by the hardware without 
software intervention, and it makes sense to me to report that to userspace.

> Set has_changed to false to prevent this happening.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> v2: By Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Fix CodeStyle (sorry :S)
>  drivers/media/v4l2-core/v4l2-ctrls.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index 45c5b47..2ebc33e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1609,6 +1609,15 @@ static int cluster_changed(struct v4l2_ctrl *master)
> 
>  		if (ctrl == NULL)
>  			continue;
> +		/*
> +		 * Set has_changed to false to avoid generating
> +		 * the event V4L2_EVENT_CTRL_CH_VALUE
> +		 */
> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +			ctrl->has_changed = false;
> +			continue;
> +		}
> +
>  		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>  			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>  				ctrl->p_cur, ctrl->p_new);

-- 
Regards,

Laurent Pinchart
