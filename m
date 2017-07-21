Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45715 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753679AbdGUKKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:10:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/4] uvc: don't set driver_version anymore
Date: Fri, 21 Jul 2017 13:10:52 +0300
Message-ID: <1759294.240x1oprEf@avalon>
In-Reply-To: <20170721090234.6501-4-hverkuil@xs4all.nl>
References: <20170721090234.6501-1-hverkuil@xs4all.nl> <20170721090234.6501-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 21 Jul 2017 11:02:33 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is now set by media_device_init.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/usb/uvc/uvc_driver.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 70842c5af05b..4f463bf2b877
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2096,7 +2096,6 @@ static int uvc_probe(struct usb_interface *intf,
>  			sizeof(dev->mdev.serial));
>  	strcpy(dev->mdev.bus_info, udev->devpath);
>  	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> -	dev->mdev.driver_version = LINUX_VERSION_CODE;
>  	media_device_init(&dev->mdev);
> 
>  	dev->vdev.mdev = &dev->mdev;

-- 
Regards,

Laurent Pinchart
