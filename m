Return-path: <mchehab@localhost>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41802 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1GKKw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 06:52:56 -0400
Message-ID: <4E1AD5BD.5010004@ru.mvista.com>
Date: Mon, 11 Jul 2011 14:51:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
References: <20110711174811.3c383595@tom-ThinkPad-T410>
In-Reply-To: <20110711174811.3c383595@tom-ThinkPad-T410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hello.

On 11-07-2011 13:48, Ming Lei wrote:

>  From 989d894a2af7ceadf2574f455d9e68779f4ae674 Mon Sep 17 00:00:00 2001
> From: Ming Lei<ming.lei@canonical.com>
> Date: Mon, 11 Jul 2011 17:04:31 +0800
> Subject: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera

    Please omit this header when sending patches.

> We found this type(0c45:6437) of Microdia camera does not
> work(no stream packets sent out from camera any longer) after
> resume from sleep, but unbind/bind driver will work again.

> So introduce the quirk of UVC_QUIRK_FIX_SUSPEND_RESUME to
> fix the problem for this type of Microdia camera.

    You didn't sign off.

> ---
>   drivers/media/video/uvc/uvc_driver.c |  146 +++++++++++++++++++---------------
>   drivers/media/video/uvc/uvcvideo.h   |    1 +
>   2 files changed, 84 insertions(+), 63 deletions(-)

> diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
> index b6eae48..2b356c3 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1787,6 +1787,68 @@ static int uvc_register_chains(struct uvc_device *dev)
[...]
> @@ -1888,6 +1950,18 @@ static int uvc_probe(struct usb_interface *intf,
>   			"supported.\n", ret);
>   	}
>
> +	/* For some buggy cameras, they will not work after wakeup, so
> +	 * do unbind in .usb_suspend and do rebind in .usb_resume to
> +	 * make it work again.
> +	 * */

    The preferred style is:

/*
  * bla
  * bla
  */

WBR, Sergei
