Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36513 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbDDMc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2015 08:32:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-pm@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] [media] uvcvideo: Enable runtime PM of descendant devices
Date: Sat, 04 Apr 2015 15:33:20 +0300
Message-ID: <2185959.thXfDS86Vr@avalon>
In-Reply-To: <1428065887-16017-5-git-send-email-tomeu.vizoso@collabora.com>
References: <1428065887-16017-1-git-send-email-tomeu.vizoso@collabora.com> <1428065887-16017-5-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomeu,

Thank you for the patch.

Could you please CC me on the whole series for v3 ?

On Friday 03 April 2015 14:57:53 Tomeu Vizoso wrote:
> So UVC devices can remain runtime-suspended when the system goes into a
> sleep state, they and all of their descendant devices need to have
> runtime PM enable.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index cf27006..687e5fb 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1855,6 +1855,15 @@ static int uvc_register_chains(struct uvc_device
> *dev) return 0;
>  }
> 
> +static int uvc_pm_runtime_enable(struct device *dev, void *data)
> +{
> +	pm_runtime_enable(dev);
> +
> +	device_for_each_child(dev, NULL, uvc_pm_runtime_enable);

How many recursion levels do we typically have with uvcvideo ?

> +
> +	return 0;
> +}

The function isn't UVC-specific, how about renaming it to 
pm_runtime_enable_recursive() (or something similar) and moving it to the 
runtime PM core ?

> +
>  /* ------------------------------------------------------------------------
> * USB probe, disconnect, suspend and resume
>   */
> @@ -1959,6 +1968,8 @@ static int uvc_probe(struct usb_interface *intf,
>  			"supported.\n", ret);
>  	}
> 
> +	device_for_each_child(&dev->intf->dev, NULL, uvc_pm_runtime_enable);

You could just call uvc_pm_runtime_enable(&dev->intf->dev, NULL) here.

> +
>  	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
>  	usb_enable_autosuspend(udev);
>  	return 0;

-- 
Regards,

Laurent Pinchart

