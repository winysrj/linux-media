Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36783 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbH1Mob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 08:44:31 -0400
Received: by ioej130 with SMTP id j130so9060238ioe.3
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 05:44:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E014E6.5000801@xs4all.nl>
References: <55D730F4.80100@xs4all.nl>
	<CAPybu_2hn8LuKy-n74cpQ1UOFvxgTv8SmXka6PwPY+U1XnZeDg@mail.gmail.com>
	<55D85325.80607@xs4all.nl>
	<CALzAhNVSY=yDWFk1fZnibOuThGW3J_s0sTQNhGGN8z1_U_regw@mail.gmail.com>
	<55D86F3C.6090004@xs4all.nl>
	<CALzAhNWhu-w+3x6S-_0ToAUAzELZSuQqo7q5NmpxXfCdciY0hw@mail.gmail.com>
	<55DDBB73.5010902@xs4all.nl>
	<CALzAhNVxrWOsU72jin4_ygwazX2cnqBaMoPGZ_Kv77xgGx7KmA@mail.gmail.com>
	<55E014E6.5000801@xs4all.nl>
Date: Fri, 28 Aug 2015 08:44:30 -0400
Message-ID: <CALzAhNUMN6BhNZQgGE57-ujoi2O1-baVW_AWFYep7Xd0b4Okrg@mail.gmail.com>
Subject: Re: [PATCH] saa7164: convert to the control framework
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Send me your shipping address _privately_, I talk to Hauppauge about a
>> replacement.
>>
>
> No need, I managed to get it working if I use a PCI-to-PCIe adapter card. Very
> strange, it won't work in the PCIe slot of my motherboard, but using the PCI slot
> and that adapter it works fine.

Excellent.

>
> It's good that it was tested since the menu control creation code was wrong.

Ahh.

>
> One thing that is very confusing to me: I have this board:
>
> [ 1878.280918] CORE saa7164[0]: subsystem: 0070:8900, board: Hauppauge WinTV-HVR2200 [card=5,autodetected]
> [ 1878.280928] saa7164[0]/0: found at 0000:09:00.0, rev: 129, irq: 18, latency: 0, mmio: 0xfb800000
> [ 1878.327399] tveeprom 14-0000: Hauppauge model 89519, rev B2F2, serial# 4029789519
> [ 1878.327405] tveeprom 14-0000: MAC address is 00:0d:fe:31:b5:4f
> [ 1878.327409] tveeprom 14-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)
> [ 1878.327413] tveeprom 14-0000: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [ 1878.327416] tveeprom 14-0000: audio processor is SAA7164 (idx 43)
> [ 1878.327418] tveeprom 14-0000: decoder processor is CX23887A (idx 39)
> [ 1878.327420] tveeprom 14-0000: has radio
> [ 1878.327423] saa7164[0]: Hauppauge eeprom: model=89519
>
> but the default firmware with size 4919072 fails to work (image corrupt), instead
> I need to use the firmware with size 4038864 (v4l-saa7164-1.0.3-3.fw).
>
> For that I have to patch the driver.

Take a look at your board, on the main large PCIe IC, its probably
marked as either a REV2 or a REV3, or a -02 or -03, what do you have?

I suspect you have a rev-02 chip. Not many of them go out into
production. (A few thousand, compared to significantly more -03
chips).

>
> Do you have an overview of which firmware is for which board?

Generally, for a long time, I was recommending that everyone run
NXP7164-2010-03-10.1.fw, this is actually the latest firmware. I've
been told it isn't reliable on the REV2 hardware though.

I'll go back to the windows driver and check how they're making the
firmware load decision. I can bring this logic into the Linux driver
and we can load the most appropriate f/w.

>
> There are a bunch of firmwares here:
>
> http://www.steventoth.net/linux/hvr22xx/firmwares
>
> but there are no instructions or an overview of which should be used.

If the stock -inkernel driver is wrong for the -02 then we should fix
that. It should be fine for the -03 though.

>
> I faintly remember asking you this before, but that's been a long time ago
> and I can't find it in my mail archive.
>
> I'm willing to do some driver cleanup and fix v4l2-compliance issues, but
> I'd really like to fix this firmware issue first.

Noted.

>
> Regards,
>
>         Hans

Best,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
