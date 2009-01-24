Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49750 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZAXD3O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 22:29:14 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0901231850p3765873o9d87b0b13dac032f@mail.gmail.com>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
	 <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
	 <1232760678.3907.77.camel@palomino.walls.org>
	 <412bdbff0901231850p3765873o9d87b0b13dac032f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 22:29:10 -0500
Message-Id: <1232767750.3907.138.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-23 at 21:50 -0500, Devin Heitmueller wrote:
> On Fri, Jan 23, 2009 at 8:31 PM, Andy Walls <awalls@radix.net> wrote:
> > For OTA ATSC 8-VSB with an HVR-1600 MCE:
> >
> > Without the change:
> >
> > $ ./tune
> > Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.416984 seconds.
> > Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.389922 seconds.
> > Commanding tune to freq 569028615 ... FE_HAS_LOCK in 2.783927 seconds.
> > Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.391952 seconds.
> > Commanding tune to freq 593028615 ... NO lock after 2.999655 seconds.
> > Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.568240 seconds.
> > Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.390964 seconds.
> > Commanding tune to freq 623028615 ... NO lock after 2.999656 seconds.
> > Commanding tune to freq 677028615 ... FE_HAS_LOCK in 2.963289 seconds.
> > Commanding tune to freq 695028615 ... NO lock after 2.999618 seconds.
> >
> > With the change:
> >
> > $ ./tune
> > Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.323542 seconds.
> > Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.293956 seconds.
> > Commanding tune to freq 569028615 ... FE_HAS_LOCK in 1.292931 seconds.
> > Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.292973 seconds.
> > Commanding tune to freq 593028615 ... FE_HAS_LOCK in 1.292920 seconds.
> > Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.293977 seconds.
> > Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.292940 seconds.
> > Commanding tune to freq 623028615 ... FE_HAS_LOCK in 1.292949 seconds.
> > Commanding tune to freq 677028615 ... FE_HAS_LOCK in 1.293948 seconds.
> > Commanding tune to freq 695028615 ... NO lock after 2.999659 seconds.
> >
> >
> > No lock was expected for 695 MHz in either case - it was known negative.
> >
> > Since I was to lazy to get Kaffeine to work properly, I wrote my own
> > test app.  It is inline below so you can see how I measured the time.
> >
> > Regards,
> > Andy
> 
> Hello Andy,
> 
> This is great.  Your data confirms with that device that you're now
> getting a lock 100% of the time in a consistent time period.

Yup.

Strangely enough, the measurments for both cases yield very repeatable
results.  The "bad" numbers always come out in about the same relative
times.  I suppose that might change, if I changed the order of which
frequencies were tuned.


>   I
> actually got my hands on my own HVR-1600 tonight, and with the
> mxl5005s datasheet I got from Maxlinear last week, I will be looking
> at lock performance in general for that tuner.

I think you might need to pry the can open for that one.  Looking at the
linux driver code, I get the feeling that external components can be set
up differently for various tracking filter configurations.  Of course,
Steve Toth added the Hauppauge variant tracking filter settings for the
HVR-1600.


> Thanks again for doing this testing.

No problem. 

Let me know if there's something else you need tested.  Now that I've
bothered to write a DVB API v5 test app, I've actually started to read
the DVB API v3 document and the API v5 code.  I understand some of the
linux DVB internal architecture concepts now.  (My day job has also had
me reading the ETSI DVB-S2 standards documentation this past week
anyway.)


>   Mkrufky has indicated he wants
> to do some testing this weekend, and assuming that happens I will
> submit a PULL request first thing next week.
> 
> Devin

Regards,
Andy

