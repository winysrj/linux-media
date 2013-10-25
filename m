Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47418 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3JYHqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Oct 2013 03:46:19 -0400
Received: by mail-oa0-f43.google.com with SMTP id m1so588537oag.30
        for <linux-media@vger.kernel.org>; Fri, 25 Oct 2013 00:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526A1864.7020800@kripserver.net>
References: <52663659.3040205@gmx.net>
	<526A1864.7020800@kripserver.net>
Date: Fri, 25 Oct 2013 09:46:18 +0200
Message-ID: <CAJbz7-1J2=Fz7sB0Uu2iCEDG-MNiJWJPQgbFN7XQHZsCFohK1A@mail.gmail.com>
Subject: Re: NAS for recording DVB-S2
From: =?ISO-8859-2?Q?Honza_Petrou=B9?= <jpetrous@gmail.com>
To: Jannis <jannis-lists@kripserver.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/10/25 Jannis <jannis-lists@kripserver.net>:
> Hi,
>
> Am 22.10.2013 10:24, schrieb JPT:
>> I want my NAS to record from USB DVB-S2.
>> [...]
>> I should buy either a Tevii S660 or a Terratec Cynergy S2 Stick.
>>
>> I don't want to have another power supply, so I am going to "steal" the
>> power from the nas somehow.
>> The Tevii uses 7,5 V which is odd...
>> I cannot find the voltage the Terratec requires. Does anyone own one?
>
> Yesterday I recommended the Technisat SkyStar USB HD to s.o. else on
> this list. Though I'm not beeing employed by or affiliated with
> Technisat, you might also want to consider it:
> http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD
> The driver is in mainline kernel (no patching' around), should work well
> with ARM (If you want me to test it, I could. There are several
> ARM-boards (armv6j-hf, armv7-hf) floating around here, I just didn't yet
> bother to try).

>From linux perspective, the ARM architecture is very stable. At least
I have never had any problem running anything on linux-arm devices.
For you solution you have to check if USB subsystem on your device
is working stable enough, especially if you are sharing the same
USB bus with other speedy devices (like external hard drive or so).

/Honza
