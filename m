Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:27329 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933831AbbBQLSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 06:18:20 -0500
Message-ID: <54E32358.8010303@cisco.com>
Date: Tue, 17 Feb 2015 12:17:44 +0100
From: Hans Verkuil <hansverk@cisco.com>
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

Does the application just read the control to check whether the trigger happened?
Or is the control perhaps changed by an interrupt handler?

> The user writes 0 to the control, to ack the error condition, and clear the
> hardware flag.

Would it be an idea to automatically ack the error condition when reading the
control?

Or, alternatively, have a separate button control to clear the condition.

> 
> Unfortunately, it only works one time, because the next time the user writes
> a zero to the control cluster_changed returns false.
> 
> I think on volatile controls it is safer to run s_ctrl twice than missing a
> valid s_ctrl.
> 
> I know I am abusing a bit the API for this :P, but I also believe that the
> semantic here is a bit confusing.

The reason for that is that I have yet to see a convincing argument for
allowing s_ctrl for a volatile control.

Regards,

	Hans

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
>  
>  		if (ctrl == NULL)
>  			continue;
> 
