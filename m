Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39870 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933813AbbDQRcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 13:32:51 -0400
Date: Fri, 17 Apr 2015 13:32:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
cc: linux-pm@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] [media] uvcvideo: Remain runtime-suspended at
 sleeps
In-Reply-To: <1429284290-25153-3-git-send-email-tomeu.vizoso@collabora.com>
Message-ID: <Pine.LNX.4.44L0.1504171331050.1319-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2015, Tomeu Vizoso wrote:

> When the system goes to sleep and afterwards resumes, a significant
> amount of time is spent suspending and resuming devices that were
> already runtime-suspended.
> 
> By setting the power.force_direct_complete flag, the PM core will ignore
> the state of descendant devices and the device will be let in
> runtime-suspend.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 5970dd6..ae75a70 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1945,6 +1945,8 @@ static int uvc_probe(struct usb_interface *intf,
>  			"supported.\n", ret);
>  	}
>  
> +	intf->dev.parent->power.force_direct_complete = true;

This seems wrong.  The uvc driver is bound to intf, not to intf's
parent.  So it would be okay for the driver to set
intf->dev.power.force_direct_complete, but it's wrong to set
intf->dev.parent->power.force_direct_complete.

Alan Stern

