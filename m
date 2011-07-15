Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59121 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177Ab1GOO1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 10:27:22 -0400
Date: Fri, 15 Jul 2011 10:27:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVM=P7dongW660zmcSdapyqYz3Yr0R4DUGbQtQEKUG_tcw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107151023070.1866-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011, Ming Lei wrote:

> Hi,
> 
> On Thu, Jul 14, 2011 at 11:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > More likely, the reset erases some device setting that uvcvideo
> > installed while binding.  Evidently uvcvideo does not re-install the
> > setting during reset-resume; this is probably a bug in the driver.
> 
> Alan, you are right.
> 
> I think I have found the root cause. Given many devices can't
> handle set_interface(0) if the interfaces were already in altsetting 0,
> usb_reset_and_verify_device does not run set_interface(0). So we
> need to do it in .reset_resume handler of uvc driver and it is always
> safe for uvc devices.
> 
> I have tested the below patch, and it can make the uvc device work
> well after rpm resume and system resume(reset resume), both in
> streaming on and off case.
> 
> Alan, Laurent, if you have no objections, I will submit a formal one.
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c
> index b6eae48..4055dfc 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1959,8 +1959,12 @@ static int __uvc_resume(struct usb_interface
> *intf, int reset)
>  	}
> 
>  	list_for_each_entry(stream, &dev->streams, list) {
> -		if (stream->intf == intf)
> +		if (stream->intf == intf) {
> +			if (reset)
> +				usb_set_interface(stream->dev->udev,
> +					stream->intfnum, 0);
>  			return uvc_video_resume(stream);
> +		}
>  	}
> 
>  	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "

This is fine with me.  However, it is strange that the Set-Interface
request is necessary.  After being reset, the device should
automatically be in altsetting 0 for all interfaces.

Alan Stern

