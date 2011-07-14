Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53242 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754403Ab1GNPDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 11:03:22 -0400
Date: Thu, 14 Jul 2011 11:03:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVOHqze=HRxhwmfDaDEs9bQ7rsAi9P4WFwn1OY3G4x5hTg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107141055270.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 Jul 2011, Ming Lei wrote:

> Hi,
> 
> On Wed, Jul 13, 2011 at 11:59 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 13 Jul 2011, Ming Lei wrote:
> 
> >> Almost same.
> >
> > Come on.  "Almost same" means they are different.  That difference is
> > clearly the important thing you need to track down.
> 
> I didn't say "entirely same" because we can't trace the packets via usbmon
> during system resume, but we can do it during runtime resume.
> 
> In fact, except for above, the packets captured from interrupt ep and control ep
> are completely same.  Also all functions in uvc (rpm, system)resume path return
> successfully.

All right; this tends to confirm your guess that the BIOS messes up the 
device by resetting it during system resume.

> >>  If I add USB_QUIRK_RESET_RESUME quirk for the device,
> >> the stream data will not be received from the device in runtime pm case,
> >> same with that in system suspend.
> >
> > uvcvideo should be able to reinitialize the device so that it works
> > correctly following a reset.  If the device doesn't work then uvcvideo
> > has a bug in its reset_resume handler.
> 
> This also indicates the usb reset during resume does make the uvc device
> broken.

Resetting the device doesn't actually _break_ it -- if it did then the 
device would _never_ work because the first thing that usbcore does to 
initialize a new device is reset it!

More likely, the reset erases some device setting that uvcvideo 
installed while binding.  Evidently uvcvideo does not re-install the 
setting during reset-resume; this is probably a bug in the driver.

> The below quirk  fixes the issue now.
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 81ce6a8..93c6fa2 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -82,6 +82,9 @@ static const struct usb_device_id usb_quirk_list[] = {
>  	/* Broadcom BCM92035DGROM BT dongle */
>  	{ USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },
> 
> +	/* Microdia uvc camera */
> +	{ USB_DEVICE(0x0c45, 0x6437), .driver_info = USB_QUIRK_RESET_MORPHS },
> +
>  	/* Action Semiconductor flash disk */
>  	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
>  			USB_QUIRK_STRING_FETCH_255 },

It would be better to fix uvcvideo, if you could figure out what it 
needs to do differently.  This quirk is only a workaround, because the 
device doesn't really morph.

Alan Stern

