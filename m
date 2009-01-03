Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03EVA61023088
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 09:31:10 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03EUtFl030761
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 09:30:56 -0500
From: Andy Walls <awalls@radix.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901031415060.3955@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 09:32:59 -0500
Message-Id: <1230993179.4302.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Sat, 2009-01-03 at 15:04 +0100, Guennadi Liakhovetski wrote:

> Can we pleeeeease somehow consider possibilities to move to a complete 
> kernel-tree development, or at least allow both. Whereas I personally see 
> no good way to have both. I really don't understand why you think, that 
> v4l users are not intelligent enough to compile complete kernel trees. 
> IMHO it is simpler, than compiling external drivers, but that's subjective 
> of course.

I'd just like to interject that my 53.333 kbps download speed on
dial-up, on a good day, makes an initial git clone (or whatever) of 150
MB a painful experience.

Compiling whole kernels: no big deal on a modern machine.

Pulling down big repos over dial-up: like sucking a watermelon through a
straw.


Whatever the solution, please remeber those of us on the fringe of
civilization that Verizon has forsaken: no DSL, no FiOS, EV-DO has data
transfer caps and requires an amplifier and a high gain antenna.  (I'd
rather not have to use "linux development" as the justification for the
cost of cable service in the household budget.)

Regards,
Andy


> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
