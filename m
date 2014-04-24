Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:41392 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXTYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Apr 2014 15:24:21 -0400
Received: by mail-qc0-f176.google.com with SMTP id x13so2140016qcv.21
        for <linux-media@vger.kernel.org>; Thu, 24 Apr 2014 12:24:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140424210930.592ec21c@Mycroft>
References: <535823E6.8020802@dragonslave.de>
	<CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
	<5358279C.5060108@dragonslave.de>
	<20140424082919.66f7eab1@samsung.com>
	<20140424210930.592ec21c@Mycroft>
Date: Thu, 24 Apr 2014 15:24:20 -0400
Message-ID: <CAGoCfiwp1q1nLbStR-htsq=PdLpHPvkhy0CsGO=_1SRX_O-Pdg@mail.gmail.com>
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Daniel Exner <dex@dragonslave.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Yes, I am sure. The tuner-xc2028 module even reports FW Version 2.7.

Yeah, the firmware image itself looks fine.

> What I suspect is, that this piece of hardware simply doesn't work with
> that firmware version.

You've got the right blob (that's the only firmware that has ever run
on the xc3028a chip).  The message you provided which says "Device is
Xceive 34584 version 8.7, firmware version 1.8" is the value read out
of the xc3028 chip after the firmware is loaded.  The value isn't read
out of the firmware blob.

There are really three possibilities here:

1.  The xc3028 is being held in reset.  They've screwed up the GPIOs
in the em28xx driver so many times that I've lost count.  If the chip
is in reset during the firmware load or when reading the version info,
you'll get whatever garbage happened to be in memory when the I2C call
was made.  Alternatively, the xc3028 gets it's reset line probed
between loading the firmware and reading the version (but this is less
likely).

2.  The xc3028 is not in reset, and the firmware load failed.  In this
case, for whatever reason the firmware wasn't loaded properly into the
chip (for example, due to a bug in the I2C code in the em28xx driver)
and the CPU on the 3028 never gets started.  Hence when it goes to
subsequently read the firmware version back out of the chip, the CPU
on the 3028 isn't running so you're getting a garbage value back from
the 3028.

3. The firmware loaded properly, but due to some other condition the
I2C call to read the firmware version never actually made it to the
3028 and you're getting back whatever garbage value happened to be in
the kernel memory that was supposed to be populated with the I2C
response.

The right way to debug this is probably to put a logic analyzer on the
I2C bus and see if the traffic is making it to the xc3028 at all.
Would also monitor the reset line with a scope and make sure it's high
and watch for it being strobed when it shouldn't be.  Of course both
of those debugging techniques require hardware.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
