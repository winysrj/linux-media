Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:54291 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbbA0Nst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 08:48:49 -0500
Received: by mail-yh0-f53.google.com with SMTP id v1so6082050yhn.12
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2015 05:48:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNViOw8EY=_WzEa7r92HGgDs1J9GvHcgQrun82GYXjNKpw@mail.gmail.com>
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>
	<CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>
	<CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>
	<CALzAhNViOw8EY=_WzEa7r92HGgDs1J9GvHcgQrun82GYXjNKpw@mail.gmail.com>
Date: Tue, 27 Jan 2015 08:48:48 -0500
Message-ID: <CALzAhNXv3Czx=2VXpQzdudau4iJXk1cseHN9cBRfgtm=55AjXQ@mail.gmail.com>
Subject: Re: PCTV 800i
From: Steven Toth <stoth@kernellabs.com>
To: John Klug <ski.brimson@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> John replied off list:
>
> "http://linux-media.vger.kernel.narkive.com/kAviSkda/chipset-change-for-cx88-board-pinnacle-pctv-hd-800i
>
> Wonder if any code was ever integrated?"
>
> It looks like basics of a patch was developed to support the card but
> it was incompatible with the existing cards and nobody took the time
> to understand how to differentiate between the older 800i and the
> newer 800i. So, the problem fell on the floor.
>
> I'll look through my card library. If I have an old _AND_ new rev then
> I'll find an hour and see if I can find an acceptable solution.
>
> Summary: PCTV released a new 800i (quite a while ago) changing the
> demodulator, which is why the existing driver doesn't work.

I have a pair of 800i's with the S5H1409 demodulator, probably from
when I did the original 800i support (2008):
http://marc.info/?l=linux-dvb&m=120032380226094&w=2

I don't have a 800i with a s5h1411, so I can't really help without it.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
