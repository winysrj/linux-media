Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:51984 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab3EFUQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 May 2013 16:16:59 -0400
Message-ID: <51880FB9.7000006@earthlink.net>
Date: Mon, 06 May 2013 15:16:57 -0500
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Driver for KWorld UB435Q Version 3 (ATSC) USB id: 1b80:e34c
References: <51841517.4030504@earthlink.net> <CAGoCfiy5qWrqH1ptGc4LKvbN1w-TtsV+ogCr7qWX6zn9L=MaSQ@mail.gmail.com>
In-Reply-To: <CAGoCfiy5qWrqH1ptGc4LKvbN1w-TtsV+ogCr7qWX6zn9L=MaSQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2013 04:29 PM, Devin Heitmueller wrote:
> The lgdt3305 is probably on the second i2c bus -- typical for em2874
> based devices. The tuner is probably gated behind the 3305. It's also
> likely that the 3305 is being held in reset by default. You'll
> probably need to tweak a GPIO to take it out of reset before it will
> answer i2c. 
Thanks, I found it on the second i2c bus. I tweaked the GPIO to get is
going. It attached OK.
> One is probably the eeprom.
Right!  It is the eeprom at 0x50 on bus 0.  After I figured out how to
access bus 1, it reports:
[39839.472893] em2874 #0: found i2c device @ 0xc0 on bus 1 [tuner (analog)]
This I assume is the tda18272.

The next challenge is a driver for the tuner tda18272.  There is a
driver for tda18271.  The 10 page product data sheet block diagrams are
different for the tda18271 and tda18272.

I tried to attach the tda18272 as a tda18271 and got:

[39839.510613] tda18271 10-0060: creating new instance
[39839.510615]435 em2874 #0 at em28xx_i2c_xfer: write nonstop addr=c0
len=1: 00
[39839.510992] em2874 #0 at em28xx_i2c_xfer: read stop addr=c0 len=16:
c7 60 11 52 00 02 0c 00 20 80 00 00 c9 0f 3f 35
[39839.512636] Unknown device (199) detected @ 10-0060, device not
supported.
[39839.512640] tda18271_attach: [10-0060|M] error -22 on line 1285
[39839.512642] tda18271 10-0060: destroying instance

There are a few references to 18272 in usb/dvb-usb-v2/rtl28xxu.c  - All
I could see is code to detect the tda18272. I don't understand this code
yet.

If they are similar enough maybe 18271 driver could be modified to
handle the 18272.

Can anyone send me register specs for the tda18272 and tda18271 so I can
figure out how they could be merged. Better yet, maybe someone has
already done this.

Thank you,
Wilson Michaels
