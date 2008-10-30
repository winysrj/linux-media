Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9UBppKw024043
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 07:51:51 -0400
Received: from sa-ex-tn.Skyangel.com (skyangel.com [208.45.247.98] (may be
	forged))
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9UBpgoP017845
	for <video4linux-list@redhat.com>; Thu, 30 Oct 2008 07:51:42 -0400
From: Sherrod Munday <sherrod.munday@SkyAngel.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
In-Reply-To: <49075401.3070403@mibroadcastservices.nl>
References: <49075401.3070403@mibroadcastservices.nl>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Oct 2008 07:51:38 -0400
Message-Id: <1225367498.26870.11.camel@smunday.skyangel.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: Osprey 530
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

On Tue, 2008-10-28 at 19:03 +0100, Wiebe Hageman wrote:
> Hello,
> 
> Has anybody experience with the Osprey 530 (or 500 serie at all) ? I 
> like to use the SDI input. The manufacture said that it is supported 
> from kernel 2.6.x
> But a lot of forums are complaining about only capturing blue screens.
> 
> Or can somebody tell about other capture boards with SDI.

We have a bunch of 530's (well over 100) for encoding a bunch of video
content into an IPTV system -- but unfortunately, the encoding computers
all run Windows.

I spent some time trying to make a 530 work in Linux - with the results
you describe above.  

I would love for the SDI input to work in Linux - but since I'm using
openSuSE the default kernel on the OS is customized.  I previously
pulled down a "supported" kernel from kernel.org and installed it, but
even after doing that I was still unable to see the BTTV stuff work
properly.

When I inquired of them previously, here was their response:

﻿On Wed, 2007-10-03 at 14:25 -0500, Bobby Wrenn at ViewCast Support
wrote:
> For Linux questions we need to defer to the Linux developers
> linuxtv.org. Because you are using custom kernels you cannot expect
> out of the box support to work. You will need to make changes every
> time you compile a new kernel. The folks at linuxtv.org know what they
> are doing and how to configure the kernel. VeiwCast is not involved in
> the development or implementation of Linux drivers. So our support of
> this platform is necessarliy limited. Please direct Linux questions to
> linuxtv.org.

In other words, I got the typical manufacturer's brush-off of "go to the
community for support with the community software - we aren't interested
enough to really get involved."


To date, I have not heard of anyone successfully running the Osprey 530
in Linux with normal ability to capture composite, S-Video, and SDI
inputs.

Similarly, I have not heard of any other SDI capture card working in
Linux, but due to the quantity of Osprey 530 cards we have I'd much
rather see this card work.

Good luck.

-- 

Sherrod Munday
Senior VP, Engineering
Sky Angel U.S., LLC
<sherrod.munday@skyangel.com>
(423) 303-7026 (W)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
