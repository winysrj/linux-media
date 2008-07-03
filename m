Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63LrNlh014380
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 17:53:23 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63Lr5K6014728
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 17:53:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
	"v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Date: Thu, 3 Jul 2008 23:52:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807032352.54746.hverkuil@xs4all.nl>
Cc: 
Subject: RFC: remove support from v4l-dvb for kernels < 2.6.16
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

RFC: remove support from v4l-dvb for kernels < 2.6.16

After spending some time trying to get v4l-dvb to compile on older 
kernels I discovered that:

- it is OK for kernels >= 2.6.19

- it does not compile at the moment for kernels >= 2.6.16 and < 2.6.19, 
but that this can be fixed.

- that it can be made to compile for kernels >= 2.6.12 and < 2.6.16, 
although quite a few drivers had to be disabled and looking at the type 
of compile warnings emitted the result would likely crash, especially 
the closer one gets to 2.6.12.

- that I no longer can compile against older kernels since gcc-4.1.2 no 
longer accepts some constructions used in those kernel sources.

I propose that we remove the support for kernels < 2.6.16. Kernel 2.6.16 
is the kernel that's being maintained long-term, so that makes it a 
good starting point. I know that I get the occasional question about 
kernel 2v4l/em28xx-audio.c.6.18, so that definitely has to be supported 
by v4l-dvb, and the differences between 2.6.18 and 2.6.16 are minor, so 
extending the support to 2.6.16 is not a problem.

I did a few scans and of the approximately 932 KERNEL_VERSION checks 
only 268 remain if we drop support for anything below 2.6.26. That's a 
major cleanup.

Since it is now simply broken for anything below 2.6.19 I think it is a 
good solution to on the one hand do a major cleanup at the expense of 
making it unlikely that we will ever support kernels below 2.6.16, and 
on the other hand at least start to support 2.6.16 and up.

I can set up a test build to periodically test if v4l-dvb still compiles 
on these older kernels (although currently I can only test on a 32 bit 
Intel platform).

I'm also willing to do the clean up (I've always liked throwing away 
code!).

In the long term we should probably review the minimum kernel 
requirements on a yearly basis and see if we should move it up. 
Especially major changes in the way the kernel handles device structs 
can be a big pain to maintain. That's currently the main reason for the 
breakage of kernels < 2.6.19.

Regards,

	Hans Verkuil

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
