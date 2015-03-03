Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:38039 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbCCNdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 08:33:39 -0500
Received: by ykp9 with SMTP id 9so16604813ykp.5
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2015 05:33:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54F51078.5030507@gmail.com>
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
	<CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
	<CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>
	<CALzAhNViOw8EY=_WzEa7r92HGgDs1J9GvHcgQrun82GYXjNKpw@mail.gmail.com>
	<CALzAhNXv3Czx=2VXpQzdudau4iJXk1cseHN9cBRfgtm=55AjXQ@mail.gmail.com>
	<54F51078.5030507@gmail.com>
Date: Tue, 3 Mar 2015 08:33:38 -0500
Message-ID: <CALzAhNUh6AQhTLsO+hkmuO+jyHMte0d+TCW5Dt6BX2+qL0WZmQ@mail.gmail.com>
Subject: Re: PCTV 800i
From: Steven Toth <stoth@kernellabs.com>
To: Mack Stanley <mcs1937@gmail.com>
Cc: John Klug <ski.brimson@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I have a pair of 800i's with the S5H1409 demodulator, probably from
>> when I did the original 800i support (2008):
>> http://marc.info/?l=linux-dvb&m=120032380226094&w=2
>>
>> I don't have a 800i with a s5h1411, so I can't really help without it.
>>
> Dear John and Steven,
>
> Back in 2012 I twice submitted a patch that got my pctv 800i with an s5h1411 working.  Both times
> either my email or something along the way wrapped lines and spoiled the patch for testing.  I've
> patched several kernels since then, but not any very recently.  I just checked and that machine is running
> Fedora 3.14.4-200.fc20.x86_64.
>
> I've attached what I believe is the patch I made then.  Since then, I've just edited the v4l source
> whenever and built a modified module whenever I upgraded.  I put instructions on fedora forum back
> then: http://forums.fedoraforum.org/showthread.php?t=281161
>
> I hope this helps.

Mack, thanks.

I've seen this patch in the past. Its perfect for end users who only
need to support the newer board, but isn't too helpful
for the kernel as it disables support for the prior board.

What the kernel needs is a single patch that (probably) reads the card
eeprom and deterministically attaches the correct demodulator for the
hardware, so users can mix'n'match old and new cards.

If the eeprom doesn't help then we'll need to figure something else out.

It's on my todo-list at somepoint. I traded a card with John a few
weeks ago so I have everything I need to make it happen, other than
time!

Thanks again,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
