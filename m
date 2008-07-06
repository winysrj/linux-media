Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6621NTc018079
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 22:01:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m66219Mf022393
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 22:01:09 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 6 Jul 2008 03:58:40 +0200
References: <200807032352.54746.hverkuil@xs4all.nl>
In-Reply-To: <200807032352.54746.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807060358.41861@orion.escape-edv.de>
Cc: v4l <video4linux-list@redhat.com>,
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

Hans Verkuil wrote:
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

Ack, I second that.


CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
