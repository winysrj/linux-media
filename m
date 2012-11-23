Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1475 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2KWM4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:56:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 6/6] uvcvideo: Add VIDIOC_[GS]_PRIORITY support
Date: Fri, 23 Nov 2012 13:56:37 +0100
Cc: linux-media@vger.kernel.org
References: <201211161507.42201.hverkuil@xs4all.nl> <1353673925-10050-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353673925-10050-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211231356.37989.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

You were right about your remark about setting USE_FH_PRIO: you do need to do
that here.

Thanks for reposting with more context, now I can see where the prio checks are
added :-)

I have just one small remark:

On Fri November 23 2012 13:32:05 Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c |    3 ++
>  drivers/media/usb/uvc/uvc_v4l2.c   |   45 ++++++++++++++++++++++++++++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |    1 +
>  3 files changed, 49 insertions(+), 0 deletions(-)
> 
> Resent with larger contexts to make review easier.
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index ae24f7d..22f14d2 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -651,10 +668,14 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		ret = uvc_ctrl_rollback(handle);
>  		break;
>  	}
>  
>  	case VIDIOC_S_EXT_CTRLS:
> +		ret = v4l2_prio_check(vdev->prio, handle->vfh.prio);
> +		if (ret < 0)
> +			return ret;

Please add a /* fall through */ comment here.

> +
>  	case VIDIOC_TRY_EXT_CTRLS:
>  	{
>  		struct v4l2_ext_controls *ctrls = arg;
>  		struct v4l2_ext_control *ctrl = ctrls->controls;
>  		unsigned int i;

After making that change you can add my Acked-by:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
