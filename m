Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3418 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3AKNVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:21:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/3] uvcvideo: Return -EACCES when trying to access a read/write-only control
Date: Fri, 11 Jan 2013 14:21:40 +0100
Cc: linux-media@vger.kernel.org
References: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com> <1357910040-27463-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357910040-27463-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111421.40294.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 11 2013 14:13:58 Laurent Pinchart wrote:
> Commit ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media]
> uvcvideo: Set error_idx properly for extended controls API failures")
> also reverted commit 30ecb936cbcd83e3735625ac63e1b4466546f5fe
> ("uvcvideo: Return -EACCES when trying to access a read/write-only
> control") by mistake. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 2bb7613..d5baab1 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1431,8 +1431,10 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  	int ret;
>  
>  	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
> -	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) == 0)
> +	if (ctrl == NULL)
>  		return -EINVAL;
> +	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
> +		return -EACCES;
>  
>  	/* Clamp out of range values. */
>  	switch (mapping->v4l2_type) {
> 
