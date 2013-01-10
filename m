Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42227 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3AJKqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 05:46:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, tom.leiming@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: fix race of open and suspend in error case
Date: Thu, 10 Jan 2013 11:48:23 +0100
Message-ID: <1668668.TJ5Durkkcc@avalon>
In-Reply-To: <1357812295-21174-1-git-send-email-oliver@neukum.org>
References: <1357812295-21174-1-git-send-email-oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Thank you for the patch.

On Thursday 10 January 2013 11:04:55 Oliver Neukum wrote:
> Ming Lei reported:
> IMO, there is a minor fault in the error handling path of
> uvc_status_start() inside uvc_v4l2_open(), and the 'users' count
> should have been decreased before usb_autopm_put_interface().
> In theory, the warning can be triggered when the device is
> opened just between usb_autopm_put_interface() and
> atomic_dec(&stream->dev->users).
> The fix is trivial.
>
> Signed-off-by:Oliver Neukum <oneukum@suse.de>

I've slightly modified the commit message with more details about the warning:

uvcvideo: Fix race of open and suspend in error case

Ming Lei reported:

IMO, there is a minor fault in the error handling path of
uvc_status_start() inside uvc_v4l2_open(), and the 'users' count should
have been decreased before usb_autopm_put_interface(). In theory, a [URB
resubmission] warning can be triggered when the device is opened just
between usb_autopm_put_interface() and atomic_dec(&stream->dev->users).

The fix is trivial.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The patch is in my tree, I'll push it to v3.9.

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index f2ee8c6..74937b7 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -501,8 +501,8 @@ static int uvc_v4l2_open(struct file *file)
>  	if (atomic_inc_return(&stream->dev->users) == 1) {
>  		ret = uvc_status_start(stream->dev);
>  		if (ret < 0) {
> -			usb_autopm_put_interface(stream->dev->intf);
>  			atomic_dec(&stream->dev->users);
> +			usb_autopm_put_interface(stream->dev->intf);
>  			kfree(handle);
>  			return ret;
>  		}

-- 
Regards,

Laurent Pinchart

