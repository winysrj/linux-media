Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50356 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1AGNZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:25:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 3/5] v4l2-ctrls: v4l2_ctrl_handler_setup must set has_new to 1
Date: Fri, 7 Jan 2011 14:25:41 +0100
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl> <98ff8980e72e4493d7b7e26c4054d818916a9720.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <98ff8980e72e4493d7b7e26c4054d818916a9720.1294402580.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071425.41690.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Friday 07 January 2011 13:47:33 Hans Verkuil wrote:
> Drivers can use the has_new field to determine if a new value was specified
> for a control. The v4l2_ctrl_handler_setup() must always set this to 1
> since the setup has to force a full update of all controls.

According to include/media/v4l2-ctrls.h, has_new is a "Internal flag: set when 
there is a valid new value". Drivers should then not use it.

If you want to use the flag in a driver, the comment should be changed and its 
usage should be documented in Documentation/video4linux/v4l2-controls.txt.

> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/v4l2-ctrls.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 8f81efc..64f56bb 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1280,8 +1280,10 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler
> *hdl) if (ctrl->done)
>  			continue;
> 
> -		for (i = 0; i < master->ncontrols; i++)
> +		for (i = 0; i < master->ncontrols; i++) {
>  			cur_to_new(master->cluster[i]);
> +			master->cluster[i]->has_new = 1;
> +		}
> 
>  		/* Skip button controls and read-only controls. */
>  		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||

-- 
Regards,

Laurent Pinchart
