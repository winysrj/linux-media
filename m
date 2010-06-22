Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:21975 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FVVwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 17:52:54 -0400
Received: by ey-out-2122.google.com with SMTP id 25so471465eya.19
        for <linux-media@vger.kernel.org>; Tue, 22 Jun 2010 14:52:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
Date: Tue, 22 Jun 2010 17:52:52 -0400
Message-ID: <AANLkTinfZ8M_NlcQFwqRQFfLmMVKKIA3aC3o8v5u7YEF@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thorsten Hirsch <t.hirsch@web.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 22, 2010 at 5:25 PM, Thorsten Hirsch <t.hirsch@web.de> wrote:
> Hi,
>
> as far as I know there's been some trouble in the past regarding
> Markus Rechberger's em28xx driver (em28xx-new) and the official
> development line, resulting in the current situation:
>
> - M. Rechberger isn't developing his driver anymore
> - kernel driver doesn't support em28xx/xc3028 based usb sticks
> (cinergy usb t xs)
>
> Can I help to solve the situation?
>
> So far I opened a bug report on launchpad
> (https://bugs.launchpad.net/ubuntu/+source/linux/+bug/460636)
> describing the situation with both drivers. I also tried to update M.
> Rechberger's driver making it work in more recent kernels. This worked
> for a short while, but then my usb stick lost its official (terratec
> branded) usb id and I couldn't manage to make it work again since. The
> current situation for my patched version of M. Rechberger's driver is,
> that everything seems to work fine except for locking channels / some
> tuning stuff ...well, I don't know exactly, I just see that kaffeine
> detects the device and can scan for channels. While the 2 signal bars
> (snr/quality) are pretty active and even the green tuning led (in
> kaffeine) is very often active, there is just no channel entering the
> list.
>
> Regarding the official em28xx driver my usb stick is far away from
> working. It stops as soon as when the firmware is being loaded:
>
> [  576.009547] xc2028 5-0060: Incorrect readback of firmware version
>
> I already wrote an email to Mauro Carvalho Chehab (the author of the
> em28xx driver) and he told me that my firmware file must be corrupted.
> That's xc3028-v27.fw. My version is from Ubuntu's nonfree firmware
> package. But it's the same file as when I follow Mauro's description
> of how to extract the firmware from the Windows driver
> (extract_xc3028.pl). So it looks as if the Cinergy USB T XS needs a
> different xc3028-v27.fw file.
>
> What about the firmware in M. Rechberger's driver? Well, it doesn't
> depend on an external firmware file, because the firmware is included
> in xc3028/xc3028_firmwares.h, which has the following copyright note:
> (c) 2006, Xceive Corporation. Looks like the official one, so I guess
> it should work. And since my device was already working with that
> firmware a while ago when Markus was still developing his driver I
> guess I should focus on the following question:
>
> => How can I extract the firmware from Xceive's official
> xc3028/xc3028_firmwares.h and making it work with the em28xx driver
> (vanilla kernel)?

I hate to say that "you're totally on the wrong track", except that's
almost certainly the case.

You've got the right firmware already (and there isn't a 'different
v.27').  That error occurs if the driver is unable to read back the
version from the chip after loading the firmware.  It's most likely
the board profile isn't setup properly to bring the chip out of reset.

The firmware is separated out because the Linux kernel process does
permit firmware embedding.  It *must* be provided as a separate blob.
Also, Xceive hasn't granted permission to redistribute the xc3028
firmware, which is why it usually has to be extracted from the Windows
driver (unlike the xc4000 and xc5000 where they have explicitly
granted redistribution rights).

Regarding the statement that the "kernel driver doesn't support
em28xx/xc3028 based usb sticks", this is simply incorrect.  The
current kernel supports a variety of devices that have a combination
of the em28xx and xc3028.  A board profile needs to be added for the
device in question (I have the board but haven't had a chance to do
the necessary work).

Exactly what is the USB ID of the board you have (there are a variety
different versions of the board with that name).  I probably have the
board already, but I want to be sure.

In the end, it's probably something like 12 lines of code need to be
added to the current driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
