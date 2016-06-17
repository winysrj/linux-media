Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45240
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcFQKMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 06:12:19 -0400
Date: Fri, 17 Jun 2016 07:12:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv16 10/13] cec: adv7842: add cec support
Message-ID: <20160617071212.2d9ae124@recife.lan>
In-Reply-To: <5763AF87.2030700@xs4all.nl>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
	<1461937948-22936-11-git-send-email-hverkuil@xs4all.nl>
	<20160616182228.1bd755d5@recife.lan>
	<5763AF87.2030700@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Jun 2016 10:06:31 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/16/2016 11:22 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 29 Apr 2016 15:52:25 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add CEC support to the adv7842 driver.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>  
> > 
> > Won't review patches 10-13, as the same reviews I made for patch 9
> > very likely applies.
> > 
> > As this series is causing non-staging drivers to be dependent of a
> > staging driver, I'll wait for the next version that should be
> > solving this issue.
> > 
> > For the new 9-13 patches, please be sure that checkpatch will be
> > happy. For the staging stuff, the checkpatch issues can be solved
> > later, as I'll re-check against checkpatch when it moves from staging
> > to mainstream.  
> 
> I have to make changes anyway so I'll make a new pull request later
> today fixing all the comments and replacing unsigned with unsigned int
> (which is a majority of all the checkpatch warnings).

Ok.

> Did I mention yet how much I hate this new checkpatch warning? In almost all
> cases I agree with the checkpatch rules, but this one is just stupid IMHO.

This is the commit that added such rule:

commit a1ce18e4f941d2039aa3bdeee17db968919eac2f
Author: Joe Perches <joe@perches.com>
Date:   Tue Mar 15 14:58:03 2016 -0700

    checkpatch: warn on bare unsigned or signed declarations without int
    
    Kernel style prefers "unsigned int <foo>" over "unsigned <foo>" and
    "signed int <foo>" over "signed <foo>".
    
    Emit a warning for these simple signed/unsigned <foo> declarations.  Fix
    it too if desired.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

So, the people to blame are mentioned on it. I was actually
expecting to see any rationale for that decision, but the log
is useless on that sense. Maybe there are some discussions at
LKML explaining that.

At least on the patch thread, no mention why it was done:
	https://www.spinics.net/lists/kernel/msg2205100.html

That's said, it sounds that the checkpatch autofix rule should 
do the changes for you, according with the comments.

There is a patch to sparc that does this:

git ls-files arch/sparc | \
  xargs ./scripts/checkpatch.pl -f --fix-inplace --types=unspecified_int

I guess I'll just run that on our subsystem, and we're done with
that, removing the risc of having to merge hundreds of stupid
checkpatch fixup stuff for the existing code, and distracting
ourselves from patches that really matters.

> 
> Oh well, I'll make the change. Perhaps it will grow on me over time.
> 
> Regards,
> 
> 	Hans



Thanks,
Mauro
