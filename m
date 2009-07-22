Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:53595 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZGVOs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 10:48:27 -0400
Received: by yxe35 with SMTP id 35so381996yxe.33
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 07:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A66E59E.9040502@powercraft.nl>
References: <4A6666CC.7020008@eyemagnet.com>
	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	 <4A66E59E.9040502@powercraft.nl>
Date: Wed, 22 Jul 2009 10:48:26 -0400
Message-ID: <829197380907220748kab85c63g6ebbaad07084c255@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-media@vger.kernel.org >> \"linux-media@vger.kernel.org\""
	<linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 22, 2009 at 6:10 AM, Jelle de Jong<jelledejong@powercraft.nl> wrote:
> So I felt like doing  a field test, with my dvb-t test system.
>
> Bus 001 Device 008: ID 2040:6502 Hauppauge WinTV HVR-900
> Bus 001 Device 007: ID 2304:0226 Pinnacle Systems, Inc. [hex] PCTV 330e
> Bus 001 Device 005: ID 0b05:173f ASUSTek Computer, Inc.
> Bus 001 Device 003: ID 2304:0236 Pinnacle Systems, Inc. [hex]
> Bus 001 Device 002: ID 15a4:9016
>
> I have now three devices with dvb-t channels running with different
> channels and audio on an atom based cpu without problems.
>
> two:
> dvb-usb-dib0700
>
> and one:
> dvb-usb-af9015
>
> the dvb-usb-af9015 takes way more cpu interrupts because of the usb
> block size.
>
> prove:
> http://imagebin.ca/img/xM9Q7_A.jpg
>
> I will be demonstrating this at har2009 (see demonstration village)
>
> Devin could you login onto the dvb-t test system and see if you can get
> those em28xx device running with your new code?
>
> I will probably make an other test system with some more cpu power to
> see if even more usb devices are possible, or I may use my nice powerful
> multiseat quad core system for it.

Hello Jelle,

Please understand that your experiment isn't really an appropriate
test.  The original user was referring to analog capture mode, in
which the uncompressed video is coming across the USB bus.  Analog
mode uses about 200Mbps while digital mode uses only 10-20Mbps.  If
you had tried capturing analog video with those devices you would have
seen similar results to what Steve described.

I haven't forgotten about your test environment, and I look forward to
getting the HVR-900 R2 and PCTV 330e working.  I have been sick in bed
for the last two days and have done no LinuxTV related work.  I look
forward to getting back to it this week.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
