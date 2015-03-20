Return-Path: <hverkuil@xs4all.nl>
Message-id: <550C24A6.2010100@xs4all.nl>
Date: Fri, 20 Mar 2015 14:46:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
References: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
 <1426778486-21807-5-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1426778486-21807-5-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

One comment:

On 03/19/2015 04:21 PM, Ricardo Ribalda Delgado wrote:
> Any control with V4L2_CTRL_FLAG_EXECUTE_ON_WRITE set should return
> changed == true in cluster_changed.
> 
> This forces the value to be passed to the driver even if it has not
> changed.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index da0ffd3..8f96478 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1611,6 +1611,10 @@ static int cluster_changed(struct v4l2_ctrl *master)
>  
>  		if (ctrl == NULL)
>  			continue;
> +
> +		if (ctrl->flags & V4L2_CTRL_FLAG_EXECUTE_ON_WRITE)
> +			changed = true;

I think this should be:

			changed = ctrl_changed = true;

This marks the cluster as changed (correct), and the control as changed
as well (that means a CH_VALUE event will be sent). The next volatile
check will put ctrl_changed back to false if it was volatile, otherwise
the for loop will just be skipped.

Right now writing to a non-button non-volatile control with EXECUTE_ON_WRITE
set and if you write the same value to it (so ctrl->type_ops->equal() returns
0) won't send the CH_VALUE event.

Very much a corner case, but still, it's easily solved.

	Hans

> +
>                  /*
>                   * Set has_changed to false to avoid generating
>                   * the event V4L2_EVENT_CTRL_CH_VALUE
> 
