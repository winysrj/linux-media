Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63826 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZJJVmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2009 17:42:52 -0400
Received: by fxm27 with SMTP id 27so7492351fxm.17
        for <linux-media@vger.kernel.org>; Sat, 10 Oct 2009 14:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300720110@web.de>
References: <1300720110@web.de>
Date: Sat, 10 Oct 2009 17:42:12 -0400
Message-ID: <829197380910101442y118fee00pa883f8deaf9bfde5@mail.gmail.com>
Subject: Re: em28xx: new board id [0ccd:10a2]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Andr=E9_Richter?= <ScorpWare@web.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 10, 2009 at 12:25 PM, André Richter <ScorpWare@web.de> wrote:
> Hi,
>
> I've made tests with my TerraTec board:
>
> Model: TerraTec H5
> Vendor/Product id: [0ccd:10a2].
>
> Tests made:
>     The original em28xx module does not work
>     (unknown device).
>     Tests made with own em2884 module (code reused
>     from em28xx module - kernel 2.6.30): output
>     attached as file.
>
>     Registration works up to i2c eeprom check, but
>     all eeprom data are 0xff.
>
>     I could not found the right communication in
>     the UsbSnoop.log files (1st 50k lines attached).
>
>     All this features do not work:
>     - Analog TV / FM Radio
>     - DVB-T / DVB-C
>     - Composite / S-Video
>
> Tested-by: André Richter <scorpware@web.de>
>
> Informations from TerraTec:
>     USB: Empia em2884
>     Decoder: Micronas DRX-K
>     Tuner: NXP TDA 18271
>
> Informations from others:
>     Micronas chips --> now from Trident Micro
>     DVB Decoder: DRX-39xxKxx (3926KA1 ?)
>     Composite:   AVF-4910BA1 ?
>     EEPROM:      ACE 24C32 ?
>     Chipset:     APB 7202A ?
>
> I want to help to develop the em28xx module support
> for my device, but I need more understanding of snoop
> file syntax (were I can find the reg address, ...).
> Also, I have no idea to use the tda18271 module for
> em28xx. Please write me, how I can help you.
> You can write me in german or english.
>
> Regards
> André

Hello André,

The em2884 isn't really the issue here - I can have it working in a
matter of hours if needed.  The problem with this device is the drx-k,
for which there is no driver, and no developer willing to invest the
50-60 hours that would probably be required to reverse engineer it and
write a driver.

Regarding the eeprom - the current code doesn't work because it's a
16-bit eeprom.  Like the em2874, the eeprom parsing code should be
skipped entirely, since you can end up corrupting the eeprom.

I would suggest you return the device and buy something that is supported.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
