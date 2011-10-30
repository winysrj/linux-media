Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3279 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab1J3KQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 06:16:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/6] v4l2-ctrl: Send change events to all fh for auto cluster slave controls
Date: Sun, 30 Oct 2011 11:16:39 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110301116.39787.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is also part of a pull request from me (and so has my Signed-off-by already):

http://www.mail-archive.com/linux-media@vger.kernel.org/msg38018.html

Regards,

	Hans

On Thursday, October 27, 2011 13:17:58 Hans de Goede wrote:
> Otherwise the fh changing the master control won't get the inactive state
> change event for the slave controls.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index fc8666a..69e24f4 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -945,6 +945,7 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
>  			if (ctrl->cluster[0]->has_volatiles)
>  				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>  		}
> +		fh = NULL;
>  	}
>  	if (changed || update_inactive) {
>  		/* If a control was changed that was not one of the controls
> 
