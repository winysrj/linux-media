Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:63615 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaDXV0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Apr 2014 17:26:36 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4K00FQA0WBZE10@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Apr 2014 17:26:35 -0400 (EDT)
Date: Thu, 24 Apr 2014 18:26:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Daniel Exner <dex@dragonslave.de>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
Message-id: <20140424182626.47f5f01e@samsung.com>
In-reply-to: <CAGoCfiwp1q1nLbStR-htsq=PdLpHPvkhy0CsGO=_1SRX_O-Pdg@mail.gmail.com>
References: <535823E6.8020802@dragonslave.de>
 <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
 <5358279C.5060108@dragonslave.de> <20140424082919.66f7eab1@samsung.com>
 <20140424210930.592ec21c@Mycroft>
 <CAGoCfiwp1q1nLbStR-htsq=PdLpHPvkhy0CsGO=_1SRX_O-Pdg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Apr 2014 15:24:20 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > Yes, I am sure. The tuner-xc2028 module even reports FW Version 2.7.
> 
> Yeah, the firmware image itself looks fine.
> 
> > What I suspect is, that this piece of hardware simply doesn't work with
> > that firmware version.
> 
> You've got the right blob (that's the only firmware that has ever run
> on the xc3028a chip).  The message you provided which says "Device is
> Xceive 34584 version 8.7, firmware version 1.8" is the value read out
> of the xc3028 chip after the firmware is loaded.  The value isn't read
> out of the firmware blob.
> 
> There are really three possibilities here:
> 
> 1.  The xc3028 is being held in reset.  They've screwed up the GPIOs
> in the em28xx driver so many times that I've lost count.  If the chip
> is in reset during the firmware load or when reading the version info,
> you'll get whatever garbage happened to be in memory when the I2C call
> was made.  Alternatively, the xc3028 gets it's reset line probed
> between loading the firmware and reading the version (but this is less
> likely).

Hmm... This device entry is too simple for my taste:
	[EM2870_BOARD_TERRATEC_XS] = {
		.name         = "Terratec Cinergy T XS",
		.valid        = EM28XX_BOARD_NOT_VALIDATED,
		.tuner_type   = TUNER_XC2028,
		.tuner_gpio   = default_tuner_gpio,
	},

And we never had a feedback that this works, as it still have a
	.valid        = EM28XX_BOARD_NOT_VALIDATED,
entry on it.

Maybe default_tuner_gpio is not the right one here, or it needs
something like:

		.i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE |
				  EM28XX_I2C_FREQ_100_KHZ,

for it to work.

> 2.  The xc3028 is not in reset, and the firmware load failed.  In this
> case, for whatever reason the firmware wasn't loaded properly into the
> chip (for example, due to a bug in the I2C code in the em28xx driver)
> and the CPU on the 3028 never gets started.  Hence when it goes to
> subsequently read the firmware version back out of the chip, the CPU
> on the 3028 isn't running so you're getting a garbage value back from
> the 3028.

The most likely cause for this would be if the I2C speed is too high.

Not sure if this could also be affected by .xclk configuration.

> 3. The firmware loaded properly, but due to some other condition the
> I2C call to read the firmware version never actually made it to the
> 3028 and you're getting back whatever garbage value happened to be in
> the kernel memory that was supposed to be populated with the I2C
> response.
> 
> The right way to debug this is probably to put a logic analyzer on the
> I2C bus and see if the traffic is making it to the xc3028 at all.
> Would also monitor the reset line with a scope and make sure it's high
> and watch for it being strobed when it shouldn't be.  Of course both
> of those debugging techniques require hardware.

You likely don't need a hardware I2C analyzer, if the device is
not broken.

What can do, instead, is to sniff the traffic at the USB port, and get
the proper GPIO, XCLK and I2C speed settings for this device.

My suggestion is to either run it on a QEMU VM machine, redirecting
the USB device to the VM and sniffing the traffic on Linux, or to
use some USB snoop software.

Take a look at: http://linuxtv.org/wiki/index.php/Bus_snooping/sniffing

We have a script that parses em28xx traffic, converting them into
register writes. All you need to do is to sniff the traffic and check
what GPIO registers are needed to reset the device.

Then, add the corresponding data at em28xx-cards.c.

Regard
-- 

Regards,
Mauro
