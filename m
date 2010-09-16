Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:47781 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab0IPWpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] uvc: Enable USB autosuspend by default on uvcvideo
Date: Fri, 17 Sep 2010 00:45:47 +0200
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
References: <1284660004-28158-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1284660004-28158-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009170045.47789.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matthew,

Thanks for the patch.

On Thursday 16 September 2010 20:00:04 Matthew Garrett wrote:
> We've been doing this for a while in Fedora without any complaints.

I'll trust you on that. If users start complaining I'll tell them who to blame 
;-)

> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(although, if you need to resubmit the patch for any reason, I'd rather like 
the usb_enable_autosuspend call to be before the uvc_trace call).

> ---
>  drivers/media/video/uvc/uvc_driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 8bdd940..28ed5b4 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1814,6 +1814,7 @@ static int uvc_probe(struct usb_interface *intf,
>  	}
> 
>  	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
> +	usb_enable_autosuspend(udev);
>  	return 0;
> 
>  error:

-- 
Regards,

Laurent Pinchart
