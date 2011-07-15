Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44740 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab1GOCIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 22:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107141055270.1983-100000@iolanthe.rowland.org>
References: <CACVXFVOHqze=HRxhwmfDaDEs9bQ7rsAi9P4WFwn1OY3G4x5hTg@mail.gmail.com>
	<Pine.LNX.4.44L0.1107141055270.1983-100000@iolanthe.rowland.org>
Date: Fri, 15 Jul 2011 10:08:36 +0800
Message-ID: <CACVXFVNMLewOae=77+hTCqNPtR4yKdjrYKLxC7LiH2FN13thMQ@mail.gmail.com>
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

On Thu, Jul 14, 2011 at 11:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> All right; this tends to confirm your guess that the BIOS messes up the
> device by resetting it during system resume.

Yes.  BIOS messes the device first, then usbcore has to reset the device
at the end of resume, so the device behaves badly: ISO transfer oddly

>> This also indicates the usb reset during resume does make the uvc device
>> broken.
>
> Resetting the device doesn't actually _break_ it -- if it did then the
> device would _never_ work because the first thing that usbcore does to
> initialize a new device is reset it!

I means the reset in resume breaks the device, not the reset in enumeration, :-)
(the only extra reset in rpm resume will make the device not work)

>
> More likely, the reset erases some device setting that uvcvideo
> installed while binding.  Evidently uvcvideo does not re-install the
> setting during reset-resume; this is probably a bug in the driver.

Yes, maybe some settings inside device have changed after the
reset signal, I don't know if it is a normal behaviour.

I have tried to add some code in .probe path to .resume path,
but still not make it work. Anyway, it is not easy thing, because we
have not the internal knowledge of uvc device implementation, and
have to try it by guess.

>> The below quirk  fixes the issue now.
>>
>> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
>> index 81ce6a8..93c6fa2 100644
>> --- a/drivers/usb/core/quirks.c
>> +++ b/drivers/usb/core/quirks.c
>> @@ -82,6 +82,9 @@ static const struct usb_device_id usb_quirk_list[] = {
>>       /* Broadcom BCM92035DGROM BT dongle */
>>       { USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },
>>
>> +     /* Microdia uvc camera */
>> +     { USB_DEVICE(0x0c45, 0x6437), .driver_info = USB_QUIRK_RESET_MORPHS },
>> +
>>       /* Action Semiconductor flash disk */
>>       { USB_DEVICE(0x10d6, 0x2200), .driver_info =
>>                       USB_QUIRK_STRING_FETCH_255 },
>
> It would be better to fix uvcvideo, if you could figure out what it
> needs to do differently.  This quirk is only a workaround, because the
> device doesn't really morph.

In fact we can understand the quirk is used to avoid reset in system resume,
which is one of its original purpose too.

I will do some tests to figure out solution in uvc driver, but I am
not sure I can
find it quickly because I debug it remotely and network is very
slowly. If I can't
find out the solution in uvc driver, could you accept the workaround of
USB_QUIRK_RESET_MORPHS first?

thanks,
-- 
Ming Lei
