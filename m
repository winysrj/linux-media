Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35133 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245Ab3ICUVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 16:21:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 02/19] uvcvideo: Return 0 when setting probe control succeeds.
Date: Tue, 03 Sep 2013 22:21:38 +0200
Message-ID: <1470601.zIbq0UikIW@avalon>
In-Reply-To: <1377829038-4726-3-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-3-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:01 Pawel Osciak wrote:
> Return 0 instead of returning size of the probe control on successful set.

This looks good, but could you update the commit message to explain why ?

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 695f6d9..1198989 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -296,6 +296,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, "%d (exp. %u).\n", probe ? "probe" : "commit",
>  			ret, size);
>  		ret = -EIO;
> +	} else {
> +		ret = 0;
>  	}
> 
>  	kfree(data);
-- 
Regards,

Laurent Pinchart

