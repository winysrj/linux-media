Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58808 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1GaWH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 18:07:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] uvcvideo: add SetInterface(0) in .reset_resume handler
Date: Sun, 31 Jul 2011 17:38:57 +0200
Cc: linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>, linux-usb@vger.kernel.org,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com> <Pine.LNX.4.44L0.1107151122490.1866-100000@iolanthe.rowland.org> <20110716115100.10f6f764@tom-ThinkPad-T410>
In-Reply-To: <20110716115100.10f6f764@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311738.58462.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ming,

Thanks for the patch. I've queued it for v3.2 with a small modification (the 
usb_set_interface() call has been moved to uvc_video.c).

On Saturday 16 July 2011 05:51:00 Ming Lei wrote:
> As commented in uvc_video_init,
> 
> 	/* Alternate setting 0 should be the default, yet the XBox Live Vision
> 	 * Cam (and possibly other devices) crash or otherwise misbehave if
> 	 * they don't receive a SET_INTERFACE request before any other video
> 	 * control request.
> 	 */
> 
> so it does make sense to add the SetInterface(0) in .reset_resume
> handler so that this kind of devices can work well if they are reseted
> during resume from system or runtime suspend.
> 
> We have found, without the patch, Microdia camera(0c45:6437) can't send
> stream data any longer after it is reseted during resume from
> system suspend.
> 
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/media/video/uvc/uvc_driver.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index b6eae48..41c6d1a 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1959,8 +1959,20 @@ static int __uvc_resume(struct usb_interface *intf,
> int reset) }
> 
>  	list_for_each_entry(stream, &dev->streams, list) {
> -		if (stream->intf == intf)
> +		if (stream->intf == intf) {
> +			/*
> +			 * After usb bus reset, some devices may
> +			 * misbehave if SetInterface(0) is not done, for
> +			 * example, Microdia camera(0c45:6437) will stop
> +			 * sending streaming data. I think XBox Live
> +			 * Vision Cam needs it too, as commented in
> +			 * uvc_video_init.
> +			 */
> +			if (reset)
> +				usb_set_interface(stream->dev->udev,
> +					stream->intfnum, 0);
>  			return uvc_video_resume(stream);
> +		}
>  	}
> 
>  	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "

-- 
Regards,

Laurent Pinchart
