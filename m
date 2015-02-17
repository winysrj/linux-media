Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41709 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbbBQMEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 07:04:09 -0500
Message-ID: <54E32E11.9060004@xs4all.nl>
Date: Tue, 17 Feb 2015 13:03:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

I've thought about this some more and I agree that this should be allowed.

But I have some comments, see below.

On 02/17/15 12:02, Ricardo Ribalda Delgado wrote:
> Volatile controls can change their value outside the v4l-ctrl framework.
> 
> We should ignore the cached written value of the ctrl when evaluating if
> we should run s_ctrl.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> 
> I have a control that tells the user when there has been a external trigger
> overrun. (Trigger while processing old image). This is a volatile control.
> 
> The user writes 0 to the control, to ack the error condition, and clear the
> hardware flag.
> 
> Unfortunately, it only works one time, because the next time the user writes
> a zero to the control cluster_changed returns false.
> 
> I think on volatile controls it is safer to run s_ctrl twice than missing a
> valid s_ctrl.
> 
> I know I am abusing a bit the API for this :P, but I also believe that the
> semantic here is a bit confusing.
> 
>  drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 45c5b47..3d0c7f4 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1605,7 +1605,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
>  
>  	for (i = 0; i < master->ncontrols; i++) {
>  		struct v4l2_ctrl *ctrl = master->cluster[i];
> -		bool ctrl_changed = false;
> +		bool ctrl_changed = ctrl->flags & V4L2_CTRL_FLAG_VOLATILE;

Should be done after the 'ctrl == NULL' check.

>  
>  		if (ctrl == NULL)
>  			continue;
> 

There is one more change that has to be made: setting a volatile control
should never generate a V4L2_EVENT_CTRL_CH_VALUE event since that makes
no sense. The way to prevent that is to ensure that ctrl->has_changed is
always false for volatile controls. The new_to_cur function looks at that
field to decide whether to send an event.

The documentation should also be updated: that of V4L2_CTRL_FLAG_VOLATILE
(in VIDIOC_QUERYCTRL), and of V4L2_EVENT_CTRL_CH_VALUE.

Regards,

	Hans
