Return-Path: <sakari.ailus@linux.intel.com>
Message-id: <550C14DA.3080904@linux.intel.com>
Date: Fri, 20 Mar 2015 14:38:50 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/5] media/v4l2-ctrls: volatiles should not generate
 CH_VALUE
References: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
 <1426778486-21807-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1426778486-21807-2-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

Ricardo Ribalda Delgado wrote:
> Volatile controls should not generate CH_VALUE events.
>
> Set has_changed to false to prevent this happening.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/v4l2-ctrls.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 45c5b47..627d4c7 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1609,6 +1609,15 @@ static int cluster_changed(struct v4l2_ctrl *master)
>
>   		if (ctrl == NULL)
>   			continue;
> +                /*
> +                 * Set has_changed to false to avoid generating
> +                 * the event V4L2_EVENT_CTRL_CH_VALUE
> +                 */

Tabs for indentation, please.

> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE){

s/){/) {/

> +                       ctrl->has_changed = false;
> +		       continue;
> +		}
> +
>   		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>   			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>   				ctrl->p_cur, ctrl->p_new);
>


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
