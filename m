Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59090 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDTRcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 13:32:31 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [patch review] uvc_driver: fix compile warning
Date: Mon, 20 Apr 2009 19:25:00 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1240171389.12537.3.camel@tux.localhost>
In-Reply-To: <1240171389.12537.3.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904201925.00656.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On Sunday 19 April 2009 22:03:09 Alexey Klimov wrote:
> Hello, all
> I saw warnings in v4l-dvb daily build.
> May this patch be helpful?

I can't reproduce the problem with gcc 4.3.2.

Hans, what's the policy for fixing gcc-related issues ? Should the code use 
uninitialized_var() to make every gcc version happy, or can ignore the 
warnings when a newer gcc version fixes the problem 

> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> --
> diff -r cda79523a93c linux/drivers/media/video/uvc/uvc_driver.c
> --- a/linux/drivers/media/video/uvc/uvc_driver.c	Thu Apr 16 18:30:38 2009
> +0200 +++ b/linux/drivers/media/video/uvc/uvc_driver.c	Sun Apr 19 23:58:02
> 2009 +0400 @@ -1726,7 +1726,7 @@
>  static int __uvc_resume(struct usb_interface *intf, int reset)
>  {
>  	struct uvc_device *dev = usb_get_intfdata(intf);
> -	int ret;
> +	int ret = 0;
>
>  	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
>  		intf->cur_altsetting->desc.bInterfaceNumber);

Laurent Pinchart

