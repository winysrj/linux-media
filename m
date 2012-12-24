Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42624 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2LXMZr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 07:25:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/6] uvcvideo: Set error_idx properly for extended controls API failures
Date: Mon, 24 Dec 2012 13:27:08 +0100
Message-ID: <1542143.Te5j8EM75x@avalon>
In-Reply-To: <1348758980-21683-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348758980-21683-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 September 2012 17:16:15 Laurent Pinchart wrote:
> When one of the requested controls doesn't exist the error_idx field
> must reflect that situation. For G_EXT_CTRLS and S_EXT_CTRLS, error_idx
> must be set to the control count. For TRY_EXT_CTRLS, it must be set to
> the index of the unexisting control.
> 
> This issue was found by the v4l2-compliance tool.

I'm revisiting this patch as it has been reverted in v3.8-rc1.

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c |   17 ++++++++++-------
>  drivers/media/usb/uvc/uvc_v4l2.c |   19 ++++++++++++-------
>  2 files changed, 22 insertions(+), 14 deletions(-)

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..e5817b9 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -591,8 +591,10 @@ static long uvc_v4l2_do_ioctl(struct file *file,

[snip]

> @@ -637,8 +639,9 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) ret = uvc_ctrl_get(chain, ctrl);
>  			if (ret < 0) {
>  				uvc_ctrl_rollback(handle);
> -				ctrls->error_idx = i;
> -				return ret;
> +				ctrls->error_idx = ret == -ENOENT
> +						 ? ctrls->count : i;
> +				return ret == -ENOENT ? -EINVAL : ret;
>  			}
>  		}
>  		ctrls->error_idx = 0;
> @@ -661,8 +664,10 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) ret = uvc_ctrl_set(chain, ctrl);
>  			if (ret < 0) {
>  				uvc_ctrl_rollback(handle);
> -				ctrls->error_idx = i;
> -				return ret;
> +				ctrls->error_idx = (ret == -ENOENT &&
> +						    cmd == VIDIOC_S_EXT_CTRLS)
> +						 ? ctrls->count : i;
> +				return ret == -ENOENT ? -EINVAL : ret;
>  			}
>  		}

I've reread the V4L2 specification, and the least I can say is that the text 
is pretty ambiguous. Let's clarify it.

Is there a reason to differentiate between invalid control IDs and other 
errors as far as error_idx is concerned ? It would be simpler if error_idx was 
set to the index of the first error for get and try operations, regardless of 
the error type. What do you think ?

-- 
Regards,

Laurent Pinchart

