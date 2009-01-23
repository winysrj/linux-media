Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40919 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbZAWRtB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 12:49:01 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 12:48:58 -0500
Message-Id: <1232732938.3907.30.camel@palomino.walls.org>
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

I will test soon, but I do have two comments by inspection.

1. The function s5h1409_softreset() is now called 3 times by
s5h1409_set_frontend(): once at entry, once by
s5h1409_enable_modulation(), and once at exit.  Surely at least one of
these is not needed, no?

2.  You've eliminated the 100 ms "settle delay" after the final
softreset.  Can something from userland turn around and call one of the
s5h1409_ops vectors and muck with registers before things "settle"?
Does it even matter?

I know a hardware reset requires a long-ish assertion time (in fact now
that I see it, I have to fix the cx18 driver hardware reset assertion
delay for this device - the current value isn't right).

Regards,
Andy

> Thanks,
> 
> Devin
> 

