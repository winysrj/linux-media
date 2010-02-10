Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0BJWSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 17:18:34 -0500
Message-ID: <4B7330B2.4050308@redhat.com>
Date: Wed, 10 Feb 2010 20:18:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Want to help in MSI TV VOX USB 2.0
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com> 	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com> 	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com> 	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com> 	<4B731A10.9000108@redhat.com> <829197381002101255x2af2776ftd1c7a7d32584946@mail.gmail.com> <f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com>
In-Reply-To: <f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carlos Jenkins wrote:
> 2010/2/10 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> On Wed, Feb 10, 2010 at 3:41 PM, Mauro Carvalho Chehab
>> Does the device even have a tuner?  I had assumed all the em2862
> It's a em2820 to be exact.
> 
>> reference designs just did s-video and composite capture.
> 
> This device has S-Video, Composite and TVTuner.
> This is the device:
> http://www.msi.com/uploads/Image/product_img/other/multimedia/vox_view.jpg
> 
>> This one is a bit different than the others though, since it has a tvp5150 as
>> opposed to a saa7113.
> 
> It has a saa7114H, I'm sure, I opened it and looked at the chips :P
> 
> Thank again for your help.

>From your previous post:

[  695.358240] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[  695.358989] em28xx #0: chip ID is em2820 (or em2710)
[  695.461103] em28xx #0: board has no eeprom
[  695.462226] em28xx #0: Identified as MSI VOX USB 2.0 (card=5)
[  695.830239] saa7115 5-0021: saa7114 found (1f7114d0e000000) @ 0x42 (em28xx #0)

saa7114 were properly detected.

[  698.043727] All bytes are equal. It is not a TEA5767
[  698.043977] tuner 5-0060: chip found @ 0xc0 (em28xx #0)
[  698.076232] tuner-simple 5-0060: creating new instance
[  698.076241] tuner-simple 5-0060: type set to 37 (LG PAL (newer TAPC series))

The tuner is for sure a simple tuner, but LG PAL is not right, as you're on an NTSC
area. The tuner driver is smart enough to use the NTSC IF frequencies, but you
may have problems with channels 6, 7, 13 and 14, as they are in the frequency
switch range for the 3 segments of the tuner. Also, if the tuner is wrong, the
segment switch may not work. Still, you would be able to see something.

Please open your device and try to identify the tuner model. The tuner is the thin
can where the antenna connector arrive.

[  698.097987] em28xx #0: Config register raw data: 0x00
[  698.228070] em28xx #0: v4l2 driver version 0.1.2
[  698.624160] em28xx #0: V4L2 video device registered as video0
[  698.624210] usbcore: registered new interface driver em28xx
[  698.624217] em28xx driver loaded

The rest of the message seems ok to me.

At the board entry for your card (at em28xx-cards.c), you may try to remove the
.max_range line from your board entry:

...
        [EM2820_BOARD_MSI_VOX_USB_2] = {
...
                .max_range_640_480 = 1,
...

I suspect that limiting the max resolution to 640x480 is only needed for em2800
devices.

This doesn't explain why it is not working, but i remember that tvtime doesn't
like to work with certain resolutions.

You should really test it with mplayer and send us the results.

-- 

Cheers,
Mauro
