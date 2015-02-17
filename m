Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43199 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbBQUu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 15:50:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 4/6] uvc gadget: switch to unlocked_ioctl.
Date: Tue, 17 Feb 2015 22:51:23 +0200
Message-ID: <1662021.9djB0xorDl@avalon>
In-Reply-To: <1424162649-17249-5-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl> <1424162649-17249-5-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 17 February 2015 09:44:07 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Instead of .ioctl use unlocked_ioctl. This allows us to finally remove
> the old .ioctl op.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/usb/gadget/function/uvc_v4l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c
> b/drivers/usb/gadget/function/uvc_v4l2.c index 0bd6965..5a84e51 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -357,7 +357,7 @@ struct v4l2_file_operations uvc_v4l2_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= uvc_v4l2_open,
>  	.release	= uvc_v4l2_release,
> -	.ioctl		= video_ioctl2,
> +	.unlocked_ioctl	= video_ioctl2,
>  	.mmap		= uvc_v4l2_mmap,
>  	.poll		= uvc_v4l2_poll,
>  #ifndef CONFIG_MMU

-- 
Regards,

Laurent Pinchart

