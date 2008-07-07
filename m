Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67JEYMS024624
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:14:34 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67JEM5B013976
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:14:22 -0400
Message-ID: <48726B32.4070302@free.fr>
Date: Mon, 07 Jul 2008 21:14:58 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200807032352.54746.hverkuil@xs4all.nl>
In-Reply-To: <200807032352.54746.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [linux-dvb] RFC: remove support from v4l-dvb for kernels <
	2.6.16
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

Hans Verkuil a écrit :
> RFC: remove support from v4l-dvb for kernels < 2.6.16
> 
> After spending some time trying to get v4l-dvb to compile on older 
> kernels I discovered that:
> 
> - it is OK for kernels >= 2.6.19
> 
> - it does not compile at the moment for kernels >= 2.6.16 and < 2.6.19, 
> but that this can be fixed.
> 
> - that it can be made to compile for kernels >= 2.6.12 and < 2.6.16, 
> although quite a few drivers had to be disabled and looking at the type 
> of compile warnings emitted the result would likely crash, especially 
> the closer one gets to 2.6.12.
> 
> - that I no longer can compile against older kernels since gcc-4.1.2 no 
> longer accepts some constructions used in those kernel sources.
> 
gcc 3.2 should compile the 2.6.16 kernel.
> I propose that we remove the support for kernels < 2.6.16. Kernel 2.6.16 
> is the kernel that's being maintained long-term, so that makes it a 
> good starting point. I know that I get the occasional question about 
> kernel 2v4l/em28xx-audio.c.6.18, so that definitely has to be supported 
> by v4l-dvb, and the differences between 2.6.18 and 2.6.16 are minor, so 
> extending the support to 2.6.16 is not a problem.
> 
> I did a few scans and of the approximately 932 KERNEL_VERSION checks 
> only 268 remain if we drop support for anything below 2.6.26. That's a 
> major cleanup.
> 
> Since it is now simply broken for anything below 2.6.19 I think it is a 
> good solution to on the one hand do a major cleanup at the expense of 
> making it unlikely that we will ever support kernels below 2.6.16, and 
> on the other hand at least start to support 2.6.16 and up.
> 
> I can set up a test build to periodically test if v4l-dvb still compiles 
> on these older kernels (although currently I can only test on a 32 bit 
> Intel platform).
> 
> I'm also willing to do the clean up (I've always liked throwing away 
> code!).
Less code, less bugs ;)
> 
> In the long term we should probably review the minimum kernel 
> requirements on a yearly basis and see if we should move it up. 
> Especially major changes in the way the kernel handles device structs 
> can be a big pain to maintain. That's currently the main reason for the 
> breakage of kernels < 2.6.19.
> 
> Regards,
> 
> 	Hans Verkuil
> 
Ack.
We should mention every year on the wiki which mercurial revision compiles on which minimal revision of the kernel and minimal gcc version.
Making support for very old kernels and very old gcc versions induces complex conditional code, indeed. And I doubt a linux device cannot be upgraded to 2.6.16 version or higher.
Except those with binary drivers in it but it is another debate.

If we succeed in making some code factorization/simplification perhaps we would be able to lower the minimal revision of the kernel supported, in a long term...

Regards,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
