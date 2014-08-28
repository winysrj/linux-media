Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52303 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaH1L16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 07:27:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_uvc fix transition to video_ioctl2
Date: Thu, 28 Aug 2014 13:28:48 +0200
Message-ID: <3446993.TiqE0KXHj7@avalon>
In-Reply-To: <1409152598-21046-1-git-send-email-andrzej.p@samsung.com>
References: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com> <1409152598-21046-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for the patch.

On Wednesday 27 August 2014 17:16:38 Andrzej Pietrasiewicz wrote:
> UVC video node is a TX device from the point of view of the gadget,
> so we cannot rely on the video struct being filled with zeros, because
> VFL_DIR_TX is actually 1.
> 
> Suggested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>  drivers/usb/gadget/function/f_uvc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/gadget/function/f_uvc.c
> b/drivers/usb/gadget/function/f_uvc.c index 5209105..95dc1c6 100644
> --- a/drivers/usb/gadget/function/f_uvc.c
> +++ b/drivers/usb/gadget/function/f_uvc.c
> @@ -411,6 +411,7 @@ uvc_register_video(struct uvc_device *uvc)
>  	video->fops = &uvc_v4l2_fops;
>  	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
>  	video->release = video_device_release;
> +	video->vfl_dir = VFL_DIR_TX;

Do you have any objection against squashing this patch into "usb: gadget: 
f_uvc: Move to video_ioctl2" ?

>  	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
> 
>  	uvc->vdev = video;

-- 
Regards,

Laurent Pinchart

