Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2720 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3AKN1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:27:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 3/3] uvcvideo: Set error_idx properly for S_EXT_CTRLS failures
Date: Fri, 11 Jan 2013 14:27:00 +0100
Cc: linux-media@vger.kernel.org
References: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com> <1357910040-27463-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357910040-27463-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111427.00116.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 11 2013 14:14:00 Laurent Pinchart wrote:
> The uvc_set_ctrl() calls don't write to the hardware. A failure at that
> point thus leaves the device in a clean state, with no control modified.
> Set the error_idx field to the count value to reflect that, as per the
> V4L2 specification.
> 
> TRY_EXT_CTRLS is unchanged and the error_idx field must always be set to
> the failed control index in that case.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 5eb8989..68d59b5 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -685,7 +685,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  			ret = uvc_ctrl_set(chain, ctrl);
>  			if (ret < 0) {
>  				uvc_ctrl_rollback(handle);
> -				ctrls->error_idx = i;
> +				ctrls->error_idx = cmd == VIDIOC_S_EXT_CTRLS
> +						 ? ctrls->count : i;
>  				return ret;
>  			}
>  		}
> 
