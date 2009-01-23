Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:58331 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZAWTgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 14:36:25 -0500
Received: by qyk4 with SMTP id 4so5425147qyk.13
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 11:36:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232733940.3907.37.camel@palomino.walls.org>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
Date: Fri, 23 Jan 2009 14:36:23 -0500
Message-ID: <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 23, 2009 at 1:05 PM, Andy Walls <awalls@radix.net> wrote:
> Holy cow! the thing tunes fast now!
>
> One burst error I received seemed much more devasting to mplayer's
> decoder than it usually does though.  (I guess fast tuning or relocking
> may have it's disadvantages, but decoding errant streams as sanely as
> possible is more a software decoder's problem.)
>
> Propagation conditions here today are much better than in recent days
> due to weather changes (it's close to 50 F!).  I'll test tonight around
> sunset and later when things get colder, to get more more data points
> for what happens when burts errors occur.
>
> But right now, it looks very good. :D
>
> Regards,
> Andy

Glad to hear that it is working well for you.

Could you please clarify what you mean by "burst error"?

For my record keeping, could you please confirm which hardware you are
doing the testing with?  This is important since there could be an
issue with your demod/tuner combination.

It would be good if you could provide some actual data regarding
before and after the patch.  Typically I run Kaffeine from the command
line, which prints out the tuning time to stdout.  For example, here
are the times Robert saw when he tested my patch:

Before the change:
Tuning delay: 2661 ms
Tuning delay: 474 ms
Tuning delay: 472 ms
Tuning lock fail after 5000ms
Tuning delay: 2000 ms
Tuning delay: 2685 ms
Tuning delay: 475 ms

After the change:
Tuning delay: 594 ms
Tuning delay: 570 ms
Tuning delay: 574 ms
Tuning delay: 671 ms
Tuning delay: 570 ms
Tuning delay: 673 ms

If you could provide something comparable, it would be useful.

Thank you for taking the time to test.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
