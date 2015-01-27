Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:40684 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbA0N2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 08:28:32 -0500
Received: by mail-yh0-f52.google.com with SMTP id f10so6015220yha.11
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 05:28:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
	<CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
	<CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>
Date: Tue, 27 Jan 2015 08:28:31 -0500
Message-ID: <CALzAhNViOw8EY=_WzEa7r92HGgDs1J9GvHcgQrun82GYXjNKpw@mail.gmail.com>
Subject: Re: PCTV 800i
From: Steven Toth <stoth@kernellabs.com>
To: John Klug <ski.brimson@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 27, 2015 at 12:25 AM, John Klug <ski.brimson@gmail.com> wrote:
> I moved it to a dual boot system, and it works in windows, and the
> same error in Linux.
>
> The chips are marked:
> Conexant     CX23880
> Samsung     S5H1411
> Cirrus           CS5340CZZ
> Atmel           ATMLH138
>
> three out of four are a different part number than the Wiki.
>
> It is Board T1213044 stamped on back
> PCTV 800i Rev 1.1
> Shield over tuner says "pctv systems"
>
> There are 5 APL1117 on both sides of the board.
>
> Since the tuner is probably under the shield I don't know a
> non-destructive method to get the part number.
>
>>From: Steven Toth <stoth@kernellabs.com>
>>Date: Mon, Jan 26, 2015 at 6:44 AM
>>Subject: Re: PCTV 800i
>>To: John Klug <ski.brimson@gmail.com>
>>Cc: Linux-Media <linux-media@vger.kernel.org>
>
>
>>On Mon, Jan 26, 2015 at 12:50 AM, John Klug <ski.brimson@gmail.com> wrote:
>>> I have a new PCTV card with CX23880 (not CX23883 as shown in the picture):
>>>
>>> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)
>>>
>>> The description is out of date with respect to my recent card.
>>>
>>> It did not work in 3.12.20, 3.17.7, and I finally downloaded the
>>> latest GIT of media_build to no avail (I have a 2nd card that is CX18,
>>> which is interspersed in the output).
>
>>The error messages suggest one or more of the components on the board,
>>or their I2C addresses have changed, or that your hardware is bad.
>
>>Other than the Conexant PCI bridge, do the other components listed in
>>the wiki page match the components on your physical device?
>>

John replied off list:

"http://linux-media.vger.kernel.narkive.com/kAviSkda/chipset-change-for-cx88-board-pinnacle-pctv-hd-800i

Wonder if any code was ever integrated?"

It looks like basics of a patch was developed to support the card but
it was incompatible with the existing cards and nobody took the time
to understand how to differentiate between the older 800i and the
newer 800i. So, the problem fell on the floor.

I'll look through my card library. If I have an old _AND_ new rev then
I'll find an hour and see if I can find an acceptable solution.

Summary: PCTV released a new 800i (quite a while ago) changing the
demodulator, which is why the existing driver doesn't work.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
