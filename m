Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47801 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbbA0FZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 00:25:35 -0500
Received: by mail-lb0-f179.google.com with SMTP id 10so11210327lbg.10
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 21:25:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
	<CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
Date: Mon, 26 Jan 2015 23:25:34 -0600
Message-ID: <CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>
Subject: Fwd: PCTV 800i
From: John Klug <ski.brimson@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I moved it to a dual boot system, and it works in windows, and the
same error in Linux.

The chips are marked:
Conexant     CX23880
Samsung     S5H1411
Cirrus           CS5340CZZ
Atmel           ATMLH138

three out of four are a different part number than the Wiki.

It is Board T1213044 stamped on back
PCTV 800i Rev 1.1
Shield over tuner says "pctv systems"

There are 5 APL1117 on both sides of the board.

Since the tuner is probably under the shield I don't know a
non-destructive method to get the part number.

>From: Steven Toth <stoth@kernellabs.com>
>Date: Mon, Jan 26, 2015 at 6:44 AM
>Subject: Re: PCTV 800i
>To: John Klug <ski.brimson@gmail.com>
>Cc: Linux-Media <linux-media@vger.kernel.org>


>On Mon, Jan 26, 2015 at 12:50 AM, John Klug <ski.brimson@gmail.com> wrote:
>> I have a new PCTV card with CX23880 (not CX23883 as shown in the picture):
>>
>> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)
>>
>> The description is out of date with respect to my recent card.
>>
>> It did not work in 3.12.20, 3.17.7, and I finally downloaded the
>> latest GIT of media_build to no avail (I have a 2nd card that is CX18,
>> which is interspersed in the output).

>The error messages suggest one or more of the components on the board,
>or their I2C addresses have changed, or that your hardware is bad.

>Other than the Conexant PCI bridge, do the other components listed in
>the wiki page match the components on your physical device?
>
>--
>Steven Toth - Kernel Labs
>http://www.kernellabs.com
