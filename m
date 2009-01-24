Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:54111 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZAXCuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 21:50:32 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2358910qwe.37
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 18:50:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232760678.3907.77.camel@palomino.walls.org>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
	 <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
	 <1232760678.3907.77.camel@palomino.walls.org>
Date: Fri, 23 Jan 2009 21:50:31 -0500
Message-ID: <412bdbff0901231850p3765873o9d87b0b13dac032f@mail.gmail.com>
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 23, 2009 at 8:31 PM, Andy Walls <awalls@radix.net> wrote:
> For OTA ATSC 8-VSB with an HVR-1600 MCE:
>
> Without the change:
>
> $ ./tune
> Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.416984 seconds.
> Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.389922 seconds.
> Commanding tune to freq 569028615 ... FE_HAS_LOCK in 2.783927 seconds.
> Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.391952 seconds.
> Commanding tune to freq 593028615 ... NO lock after 2.999655 seconds.
> Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.568240 seconds.
> Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.390964 seconds.
> Commanding tune to freq 623028615 ... NO lock after 2.999656 seconds.
> Commanding tune to freq 677028615 ... FE_HAS_LOCK in 2.963289 seconds.
> Commanding tune to freq 695028615 ... NO lock after 2.999618 seconds.
>
> With the change:
>
> $ ./tune
> Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.323542 seconds.
> Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.293956 seconds.
> Commanding tune to freq 569028615 ... FE_HAS_LOCK in 1.292931 seconds.
> Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.292973 seconds.
> Commanding tune to freq 593028615 ... FE_HAS_LOCK in 1.292920 seconds.
> Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.293977 seconds.
> Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.292940 seconds.
> Commanding tune to freq 623028615 ... FE_HAS_LOCK in 1.292949 seconds.
> Commanding tune to freq 677028615 ... FE_HAS_LOCK in 1.293948 seconds.
> Commanding tune to freq 695028615 ... NO lock after 2.999659 seconds.
>
>
> No lock was expected for 695 MHz in either case - it was known negative.
>
> Since I was to lazy to get Kaffeine to work properly, I wrote my own
> test app.  It is inline below so you can see how I measured the time.
>
> Regards,
> Andy

Hello Andy,

This is great.  Your data confirms with that device that you're now
getting a lock 100% of the time in a consistent time period.  I
actually got my hands on my own HVR-1600 tonight, and with the
mxl5005s datasheet I got from Maxlinear last week, I will be looking
at lock performance in general for that tuner.

Thanks again for doing this testing.  Mkrufky has indicated he wants
to do some testing this weekend, and assuming that happens I will
submit a PULL request first thing next week.

Devin


--
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
