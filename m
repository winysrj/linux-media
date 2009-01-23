Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:7357 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZAWTbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 14:31:05 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2273243qwe.37
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 11:31:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232732938.3907.30.camel@palomino.walls.org>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232732938.3907.30.camel@palomino.walls.org>
Date: Fri, 23 Jan 2009 14:31:01 -0500
Message-ID: <412bdbff0901231131g3ba5f5ceh96cbb428af4659ce@mail.gmail.com>
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 23, 2009 at 12:48 PM, Andy Walls <awalls@radix.net> wrote:
> I will test soon, but I do have two comments by inspection.
>
> 1. The function s5h1409_softreset() is now called 3 times by
> s5h1409_set_frontend(): once at entry, once by
> s5h1409_enable_modulation(), and once at exit.  Surely at least one of
> these is not needed, no?
>
> 2.  You've eliminated the 100 ms "settle delay" after the final
> softreset.  Can something from userland turn around and call one of the
> s5h1409_ops vectors and muck with registers before things "settle"?
> Does it even matter?
>
> I know a hardware reset requires a long-ish assertion time (in fact now
> that I see it, I have to fix the cx18 driver hardware reset assertion
> delay for this device - the current value isn't right).
>
> Regards,
> Andy

Just to be clear, the term "softreset" is somewhat a misnomer.  It is
*not* a software equivalent of a hardware reset.  It does not reset
any of the configuration registers.  It only resets the internal
status data that is used to determine lock status.

The 100ms settle delay should not be needed at all.  If there is a
concern about something in userland mucking with the registers, that
is something that would have to be addressed through locking.  As far
as I know, there is no known issue associated with querying the status
registers as soon as the status counters are reset.

It is possible that the softreset() before the tune may not be
necessary, but at this point my intent was to focus on the minimal
change that achieves the desired effect, and the additional
softreset() should not cause any performance or reliability impact.
Also, the change I made is consistent with the change I made for the
s5h1411 back in October (for which there have been no problems
reported).

Yes, traditionally a hardware reset needs to be asserted for a
specific period of time (varies by device).  That does not apply here
though since the chip itself is not being reset.

There is additional room for optimization, but this fix alone provides
a significant performance benefit and is low impact, so I wanted to
get it merged independent of any other fixes.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
