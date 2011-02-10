Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45596 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab1BJBZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 20:25:28 -0500
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Andy Walls <awalls@md.metrocast.net>
To: Dave Johansen <davejohansen@gmail.com>
Cc: v4l-dvb Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTinsb1x8zQz5+r39s1Y6pq2UuFdD5bF419c3RAps@mail.gmail.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	 <20110206232800.GA83692@io.frii.com>
	 <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
	 <6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
	 <AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
	 <1297122870.2355.21.camel@localhost> <20110208152525.GA47904@io.frii.com>
	 <AANLkTinD2JVkxzMQt+LWXQ78UBKoSzYXkWG1hJ6d9T5s@mail.gmail.com>
	 <AANLkTinsb1x8zQz5+r39s1Y6pq2UuFdD5bF419c3RAps@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 20:25:32 -0500
Message-ID: <1297301132.2428.149.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-08 at 22:41 -0700, Dave Johansen wrote:
> On Tue, Feb 8, 2011 at 9:51 AM, Dave Johansen <davejohansen@gmail.com> wrote:
> > On Tue, Feb 8, 2011 at 8:25 AM, Mark Zimmerman <markzimm@frii.com> wrote:
> >> On Mon, Feb 07, 2011 at 06:54:30PM -0500, Andy Walls wrote:
> >>>
> >>> You perhaps could
> >>>
> >>> A. provide the smallest window of known good vs known bad kernel
> >>> versions.  Maybe someone with time and hardware can 'git bisect' the
> >>> issue down to the problem commit.  (I'm guessing this problem might be
> >>> specific to a particular 64 bit platform IOMMU type, given the bad
> >>> dma_ops pointer.)
> >>>
> >>
> >> FYI: I am on the process of doing a git bisect (10 kernels to go) to
> >> track down this problem:
> >>
> >> http://www.mail-archive.com/linux-media@vger.kernel.org/msg25342.html
> >>
> >> Which may or may not be related to the problem in this thread.
> >>
> >
> > I'm using Mythbuntu 10.10 x64, which I believe uses 2.6.35 but I will
> > check tonight, so if the issue you're tracking down really is related
> > to 2.6.36, then I imagine that my problem wouldn't be caused by what
> > you're looking into. Plus, every time I've looked at dmesg the
> > firmware has loaded properly, so I'm guessing I'm on 2.6.35 and being
> > affected by a different issue.
> >
> > Thanks for the heads up,
> > Dave
> >
> 
> So I don't know how useful this is, but I tried Mythbuntu 10.10 x86
> and it works like a charm. So the issue appears to be isolated to the
> x64 build. 

You validated my guess. :)


> If there's anything I can do to help figure out what the
> cause of this issue is in the x64 build, then please let me know and
> I'll do my best to help out.

So this increases the likelyhood that this is a kernel problem
introduced outside of the drivers/media directory.

To find it, someone needs to clone out the kernel with git; start a git
bisect using the lastest known good and earliest known bad kernel
versions; and build, install, and test kernels until the problem is
found, as outlined here:

http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
http://manpages.ubuntu.com/manpages/maverick/man1/git-bisect.1.html



The "build, install and test kernels" step is the pain.  Let's say it
takes a 2 core AMD64 machine about 17 minutes to build a minimal kernel.
The number of kernels that need to be tested will be roughly log2(Number
of commits between known good and bad kernels).  So 30,000 commits will
require roughly 15 kernel builds to narrow the problem.  If it takes 20
minutes per iteration, that's 5 hours to find the problem.

That someone also needs 64 bit hardware and a board supported by the
cx23885 driver that also exhibits the problem.  I have an HVR-1850 and a
64-bit machine, but I haven't tested it yet.  I do not have 5 hours
free.  Sorry.

Regards,
Andy

> Thanks for all the help,
> Dave


