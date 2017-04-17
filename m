Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45826 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdDQMsr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 08:48:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Axtens <dja@axtens.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] uvcvideo: Kill video URBs on disconnect
Date: Mon, 17 Apr 2017 15:49:46 +0300
Message-ID: <9757129.ouSjzrobER@avalon>
In-Reply-To: <20170417085240.12930-2-dja@axtens.net>
References: <20170417085240.12930-1-dja@axtens.net> <20170417085240.12930-2-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thank you for the patch.

On Monday 17 Apr 2017 18:52:40 Daniel Axtens wrote:
> When an in-use webcam is disconnected, I noticed the following
> messages:
> 
>   uvcvideo: Failed to resubmit video URB (-19).
> 
> -19 is -ENODEV, which does make sense given that the device has
> disappeared.
> 
> We could put a case for -ENODEV like we have with -ENOENT, -ECONNRESET
> and -ESHUTDOWN, but the usb_unlink_urb() API documentation says that
> 'The disconnect function should synchronize with a driver's I/O
> routines to insure that all URB-related activity has completed before
> it returns.' So we should make an effort to proactively kill URBs in
> the disconnect path instead.
> 
> Call uvc_enable_video() (specifying 0 to disable) in the disconnect
> path, which kills and frees URBs.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> 
> ---
> 
> Before this patch, yavta -c hangs when a camera is disconnected, but
> with this patch it exits immediately after the camera is
> disconnected. I'm not sure if this is acceptable - Laurent?

I assume that the error message is caused by a race between disconnection and 
URB handling. When the device is disconnected I believe the USB core will 
cancel all in-progress URBs (I'm not very familiar with that part of the USB 
core anymore, so please don't consider this or any further related statement 
as true without double-checking), resulting in the URB completion handler 
being called with an error status. The completion handler should then avoid 
resubmitting the URB. However, if the completion handler is in progress when 
the device is disconnected, it won't notice that the device got disconnected, 
and will try to resubmit the URB.

I'm not sure to see how this patch will fix the problem. If the URB completion 
handler is in progress when the device is being disconnected, won't it call 
usb_submit_urb() regardless of whether you call usb_kill_urb() in the 
disconnect handler, resulting in an error message being printed ?

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 2390592f78e0..647e3d8a1256
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1877,6 +1877,8 @@ static void uvc_unregister_video(struct uvc_device
> *dev) if (!video_is_registered(&stream->vdev))
>  			continue;
> 
> +		uvc_video_enable(stream, 0);
> +
>  		video_unregister_device(&stream->vdev);
> 
>  		uvc_debugfs_cleanup_stream(stream);

-- 
Regards,

Laurent Pinchart
