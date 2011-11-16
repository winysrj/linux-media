Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1KPEMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 23:12:06 -0500
Received: by bke11 with SMTP id 11so47729bke.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 20:12:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Nov 2011 23:12:02 -0500
Message-ID: <CAEwxPWa-0_XCD8d=CCvoswCPn4RzK12GaVzH3QFpA2Y3FL1NzA@mail.gmail.com>
Subject: IR disappearing while ATSC decoder in use
From: Kyle Strickland <kyle@kyle.strickland.name>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I'm messing around trying to get my Kworld PC150-U ATSC hybrid tuner
card (17de:a134) to work, and I think I'm almost done.  I've been able
to get all of the functionality to work on its own: remote control,
FM, NTSC, composite input, and ATSC, but for some reason, whenever I
use the ATSC decoder, the remote control stops working.

Here's what I know about the card so far:

Analog Decoder chip: SAA7134HL
Tuner: TDA8290+TDA18271
ATSC/ClearQAM Decoder: Samsung S5H1411, TS using parallel input, chip
enabled by setting GPIO18 high
Remote control: I2C with GPIO8 going low signalling a key press,
similar to MSI TV@nywhere Plus, but with different GPIO pin used for
signalling.
Previous thread about this card found here:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/25680/

Looking at the pictures on newegg, the card looks to be the same as
the MSI Digi@nywhere A/D Plus, except with a green mask instead of
red, a different symbol on the remote control media button, and it
doesn't include batteries for the remote :)  The EEPROM contents are
even the same except for the subdevice id at the beginning.

So, whenever I run VLC to watch DTV, button presses stop showing up
with the GPIO, and if I force it to poll I2C rather than checking
GPIO8, I get a read error of either BUSY or ST_ERR or NO_DEVICE.  For
that matter, I get a lot of BUSY and ST_ERR, but not NO_DEVICE, with
the S5H1411 in general, and hacked together a retry loop for reading
and writing registers to get past it.  I would suspect just funkiness
on the I2C bus, but GPIO8 rarely registers the key press when watching
DTV.  When it does register the key press, I am able to read the key
code over I2C.

I'm completely new to working with tuner cards (just since I bought
this one a month ago), so I was wondering if any of you out there have
had a similar experience with other cards and might have some advice.
I'd appreciate any help I can get.

I'll be happy to provide code, but I am not running the latest kernel
yet.  I'm just making the modifications to the ubuntu source, to see
whether I could get the thing to work before I go all in building and
running the kernel from source control

Distribution: Ubuntu 11.10
uname -a: Linux home 3.0.0-12-generic #20 SMP Tue Nov 1 00:33:52 EDT
2011 x86_64 x86_64 x86_64 GNU/Linux
Modifications made to s5h1411.ko, saa7134.ko, saa7134-alsa.ko,
saa7134-dvb.ko, tda8290.ko, tda18271.ko and new module
rc_kworld_pc150u.ko.

Thanks,
Kyle Strickland
