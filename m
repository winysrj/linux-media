Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:56544 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732263AbeGJWT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 18:19:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v8 1/3] uvcvideo: remove a redundant check
Date: Wed, 11 Jul 2018 01:18:49 +0300
Message-ID: <46410758.mhTT498ZdS@avalon>
In-Reply-To: <1525792064-30836-2-git-send-email-guennadi.liakhovetski@intel.com>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <1525792064-30836-2-git-send-email-guennadi.liakhovetski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Tuesday, 8 May 2018 18:07:42 EEST Guennadi Liakhovetski wrote:
> Event subscribers cannot have a NULL file handle. They are only added
> at a single location in the code, and the .fh pointer is used without
> checking there.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I'll proceed to patches 2/3 and 3/3 tomorrow 
(Wednesday).

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index a36b4fb..2a213c8 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1229,9 +1229,9 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
> uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
> 
>  	list_for_each_entry(sev, &mapping->ev_subs, node) {
> -		if (sev->fh && (sev->fh != &handle->vfh ||
> +		if (sev->fh != &handle->vfh ||
>  		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> -		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
> +		    (changes & V4L2_EVENT_CTRL_CH_FLAGS))
>  			v4l2_event_queue_fh(sev->fh, &ev);
>  	}
>  }

-- 
Regards,

Laurent Pinchart
