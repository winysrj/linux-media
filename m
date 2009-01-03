Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03GUDK7019368
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:30:13 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03GU1GL010741
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:30:01 -0500
Date: Sat, 3 Jan 2009 17:30:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <alpine.LRH.2.00.0901031400260.3513@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0901031714150.3955@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
	<alpine.LRH.2.00.0901031400260.3513@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
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

On Sat, 3 Jan 2009, Mauro Carvalho Chehab wrote:

> On Sat, 3 Jan 2009, Guennadi Liakhovetski wrote:
> 
> > Mauro, I am afraid, what you have done isn't quite right. I'll try to
> > explain again. In a fresh clone of your hg-tree commit 1070 contains a
> > "kernel-sync:" tag, because it went in via ARM tree, and adds the
> > 
> > +
> > +#include "pxa_camera.h"
> > 
> > hunk to pxa_camera.c. Commit 1071 doesn't contain that tag, because I
> > pulled it via my tree, and removes that header and the above #include
> > line. This is also how we want it to be eventually. So, your hg-tree was
> > _correct_, and didn't have to be fixed. Whereas in your git-tree commit
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed
> > is a _corrupted_ version of hg-commit 1071 in your hg-tree - it is missing
> > the removal of the header-include. Now instead of removing it in your
> > git-tree, you re-added that include again...
> 
> At the way your patches were on -hg, they didn't apply upstream. I had to do
> some manual work to make them apply.

Right, I think, this is also a side effect of this "dualistic" development 
model - I prepared my patches to apply to the hg tree, and, as you know, 
back-porting of upstream work from mainline git to hg is not trivial, so, 
the two versions drifted apart by the time you tried to port the patches 
to git, so, merge-conflicts resulted.

> > hunk comes from yet another commit...
> > 
> > Can we pleeeeease somehow consider possibilities to move to a complete
> > kernel-tree development, or at least allow both.
> 
> I _do_ allow both. If you prefer, you may send your patches against my -git
> tree.
> 
> >  Whereas I personally see no good way to have both.
> 
> Agreed. This means more work to me.

Yes, that's why I tried to use hg - to avoid creating extra work for you, 
I'm sure, you have enough of it already. But it seems this way the 
problems are hardly fewer, they are just different...

> > I really don't understand why you think, that
> > v4l users are not intelligent enough to compile complete kernel trees.
> > IMHO it is simpler, than compiling external drivers, but that's subjective
> > of course.
> 
> Several v4l users are linux newbies that just want to have their distro kernel
> working with their hardware. Trying to convince they to have the latest
> unstable -git tree would just make things worse.
> 
> So, for sure we need a tree that allows compiling against old kernels.
> 
> Maybe we can do what -alsa did: they now use -git for development, and create
> daily snapshots with alsa code that can be compiled against older kernels.

This looks like a good idea to me!

> Yet, this means to change the entire upstream and development procedure, and
> to find a way to generate those snaps.
> 
> I think we need to do this, but it is not so easy to make it happen. I intend
> to work on it this year.

I certainly understand this is not easy, and is not done in 1 hour, 
probably, not even in 10 hours. But as you write in your other post, if 
you're already spending _days_ on the hg-git merges, maybe it would be 
good to try to make this happen soon enough? In fact, what is needed for 
this? You already have a git-tree and you already can handle git-based 
patches rom contributors, right? So, you will just drop your hg work 
completely and only handle git. The only work that I can see on this, is 
creating those snapshots and applying the compatibility craft, that we 
currently have in hg to make them compile against older kernels. Am I 
missing something?

And now, Mauro, what do we do with this specific case? Are you going to 
fix it in your hg-/git-trees or are you expecting anything from me / Eric?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
