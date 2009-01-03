Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03FKARl002095
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 10:20:10 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03FJt4I017295
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 10:19:56 -0500
Date: Sat, 3 Jan 2009 16:20:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1230993179.4302.11.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.64.0901031611350.3955@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
	<1230993179.4302.11.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 3 Jan 2009, Andy Walls wrote:

> On Sat, 2009-01-03 at 15:04 +0100, Guennadi Liakhovetski wrote:
> 
> > Can we pleeeeease somehow consider possibilities to move to a complete 
> > kernel-tree development, or at least allow both. Whereas I personally see 
> > no good way to have both. I really don't understand why you think, that 
> > v4l users are not intelligent enough to compile complete kernel trees. 
> > IMHO it is simpler, than compiling external drivers, but that's subjective 
> > of course.
> 
> I'd just like to interject that my 53.333 kbps download speed on
> dial-up, on a good day, makes an initial git clone (or whatever) of 150
> MB a painful experience.

I think, I can understand you quite well, I only moved to DSL about 3 
years ago, and the first DSL that I had was WLAN to some hot-spot with 
varying quality and availability... But - you don't have to clone kernels 
_often_. As you say, you only have to do this once. And I would make a 
"shallow" clone - you don't need the whole kernel history since the 
introduction of git. And yes, I think, it will make up those 150MB you're 
referring above. And then, after the initial clone you just pull updates, 
which is much less, as you certainly know. So, yes, the initial clone 
would be painful for you, sorry... Is it at least a flat-rate?

> Compiling whole kernels: no big deal on a modern machine.

I'm sure also here not everyone will agree. I also only upgraded from my 
Duron 900MHz less than a year ago.

> Pulling down big repos over dial-up: like sucking a watermelon through a
> straw.
> 
> 
> Whatever the solution, please remeber those of us on the fringe of
> civilization that Verizon has forsaken: no DSL, no FiOS, EV-DO has data
> transfer caps and requires an amplifier and a high gain antenna.  (I'd
> rather not have to use "linux development" as the justification for the
> cost of cable service in the household budget.)

Yes, there are pro and contra.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
