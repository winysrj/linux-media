Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57007 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1GNJQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 05:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107131154390.2156-100000@iolanthe.rowland.org>
References: <CACVXFVPJvuzKZetupzBf+GhwZKV10EHjpNUwTz98sweH3xkd4w@mail.gmail.com>
	<Pine.LNX.4.44L0.1107131154390.2156-100000@iolanthe.rowland.org>
Date: Thu, 14 Jul 2011 17:16:30 +0800
Message-ID: <CACVXFVOHqze=HRxhwmfDaDEs9bQ7rsAi9P4WFwn1OY3G4x5hTg@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Jul 13, 2011 at 11:59 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 13 Jul 2011, Ming Lei wrote:

>> Almost same.
>
> Come on.  "Almost same" means they are different.  That difference is
> clearly the important thing you need to track down.

I didn't say "entirely same" because we can't trace the packets via usbmon
during system resume, but we can do it during runtime resume.

In fact, except for above, the packets captured from interrupt ep and control ep
are completely same.  Also all functions in uvc (rpm, system)resume path return
successfully.

>
>>  If I add USB_QUIRK_RESET_RESUME quirk for the device,
>> the stream data will not be received from the device in runtime pm case,
>> same with that in system suspend.
>
> uvcvideo should be able to reinitialize the device so that it works
> correctly following a reset.  If the device doesn't work then uvcvideo
> has a bug in its reset_resume handler.

This also indicates the usb reset during resume does make the uvc device
broken.

>> Maybe buggy BIOS makes root hub send reset signal to the device during
>> system suspend time, not sure...
>
> That's entirely possible.

The below quirk  fixes the issue now.

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 81ce6a8..93c6fa2 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -82,6 +82,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Broadcom BCM92035DGROM BT dongle */
 	{ USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },

+	/* Microdia uvc camera */
+	{ USB_DEVICE(0x0c45, 0x6437), .driver_info = USB_QUIRK_RESET_MORPHS },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


thanks,
-- 
Ming Lei
