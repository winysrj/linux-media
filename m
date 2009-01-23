Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42338 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbZAWSFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 13:05:44 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 13:05:40 -0500
Message-Id: <1232733940.3907.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-01-21 at 23:45 -0500, Devin Heitmueller wrote:
> The attached patch significantly improves tuning lock times for all
> three s5h1409 based devices I have tested with so far.  However,
> because of the large number of devices affected, I would like to
> solicit people with products that use the s5h1409 to test the patch
> and report back any problems before it gets committed.
> 
> To test the patch, check out the latest v4l-dvb and apply the patch:
> 
> hg clone http://linuxtv.org/hg/v4l-dvb
> cd v4l-dvb
> patch -p1 < s5h1409_tuning_speedup.patch
> make
> make install
> make unload
> reboot
> 
> Based on the data collected thus far, this patch should address some
> long-standing issues with long times to reach tuning lock and
> intermittent lock failures.
>
> Comments welcome.

Holy cow! the thing tunes fast now!

One burst error I received seemed much more devasting to mplayer's
decoder than it usually does though.  (I guess fast tuning or relocking
may have it's disadvantages, but decoding errant streams as sanely as
possible is more a software decoder's problem.) 

Propagation conditions here today are much better than in recent days
due to weather changes (it's close to 50 F!).  I'll test tonight around
sunset and later when things get colder, to get more more data points
for what happens when burts errors occur.

But right now, it looks very good. :D

Regards,
Andy

> Thanks,
> 
> Devin


