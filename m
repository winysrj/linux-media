Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58849 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbbD3GTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 02:19:15 -0400
Message-ID: <5541C954.707@xs4all.nl>
Date: Thu, 30 Apr 2015 08:19:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 25/27] usbvision: fix bad indentation
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com> <059321071ca9d62dab15cff63d1a6ffc68701fc1.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <059321071ca9d62dab15cff63d1a6ffc68701fc1.1430348725.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2015 01:06 AM, Mauro Carvalho Chehab wrote:
> drivers/media/usb/usbvision/usbvision-core.c:2395 usbvision_init_isoc() warn: inconsistent indenting
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
> index 44b0c28d69b6..7c04ef697fb6 100644
> --- a/drivers/media/usb/usbvision/usbvision-core.c
> +++ b/drivers/media/usb/usbvision/usbvision-core.c
> @@ -2390,8 +2390,8 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
>  
>  	/* Submit all URBs */
>  	for (buf_idx = 0; buf_idx < USBVISION_NUMSBUF; buf_idx++) {
> -			err_code = usb_submit_urb(usbvision->sbuf[buf_idx].urb,
> -						 GFP_KERNEL);
> +		err_code = usb_submit_urb(usbvision->sbuf[buf_idx].urb,
> +					 GFP_KERNEL);
>  		if (err_code) {
>  			dev_err(&usbvision->dev->dev,
>  				"%s: usb_submit_urb(%d) failed: error %d\n",
> 

