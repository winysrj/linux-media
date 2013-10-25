Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59646 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab3JYJ5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 05:57:15 -0400
Received: from [192.168.0.22] ([79.215.137.247]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0ML7NR-1VZvFw0SR7-000Jat for
 <linux-media@vger.kernel.org>; Fri, 25 Oct 2013 11:57:13 +0200
Message-ID: <526A4090.6020008@gmx.net>
Date: Fri, 25 Oct 2013 11:57:36 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: =?windows-1252?Q?Honza_Petrou=9A?= <jpetrous@gmail.com>
CC: Jannis <jannis-lists@kripserver.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: NAS for recording DVB-S2
References: <52663659.3040205@gmx.net> <526A1864.7020800@kripserver.net> <CAJbz7-1J2=Fz7sB0Uu2iCEDG-MNiJWJPQgbFN7XQHZsCFohK1A@mail.gmail.com>
In-Reply-To: <CAJbz7-1J2=Fz7sB0Uu2iCEDG-MNiJWJPQgbFN7XQHZsCFohK1A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 25.10.2013 09:46, schrieb Honza Petrouš:
> 2013/10/25 Jannis <jannis-lists@kripserver.net>:
>> Hi,
>>
>> Am 22.10.2013 10:24, schrieb JPT:
>>> I want my NAS to record from USB DVB-S2.
>>> [...]
>>> I should buy either a Tevii S660 or a Terratec Cynergy S2 Stick.
>>>
>>> I don't want to have another power supply, so I am going to "steal" the
>>> power from the nas somehow.
>>> The Tevii uses 7,5 V which is odd...
>>> I cannot find the voltage the Terratec requires. Does anyone own one?
>>
>> Yesterday I recommended the Technisat SkyStar USB HD to s.o. else on
>> this list. Though I'm not beeing employed by or affiliated with
>> Technisat, you might also want to consider it:
>> http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
>> The driver is in mainline kernel (no patching' around), should work well
>> with ARM (If you want me to test it, I could. There are several
>> ARM-boards (armv6j-hf, armv7-hf) floating around here, I just didn't yet
>> bother to try).

Thanks, I will give it a try.
This device wasn't listed at my favorite price comparison agent, only
the successor "TechniSat SkyStar USB 2 HD CI" (which doesn't work with
linux) at nearly double price.

I think I will trust both your statements that it's likeley to work, so
it's not necessary to test. Thanks. :)

>> The power-supply reads 12V, 1.5A for one device. As you didn't state at
>> what voltage your NAS runs at, it might just fit or be too high (the 12
>> Volts) for your application. I have a slightly larger NAS (more a less a
>> full blown PC with low-enery components) and I power two of the
>> technisat's off the PC's power supply's 12V rail.

12 V should be fine. Any device powering hard-drives should offer 12 V
somewhere.

> From linux perspective, the ARM architecture is very stable. At least
> I have never had any problem running anything on linux-arm devices.
> For you solution you have to check if USB subsystem on your device
> is working stable enough, especially if you are sharing the same
> USB bus with other speedy devices (like external hard drive or so).

great, thanks!
I won't have any other devices attached that generate a lot of traffic.
I believe USB 2.0 and USB 3.0 busses are separate, so it would be a good
solution to use one for DVB and the other for anything else in case
problems occur.
Currently there doesn't exist a kernel for the NAS yet, so I cannot test.

regars,

Jan
