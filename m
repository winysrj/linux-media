Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03I39ck009608
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 13:03:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03I2tD5010979
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 13:02:55 -0500
Date: Sat, 3 Jan 2009 16:02:45 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901031714150.3955@axis700.grange>
Message-ID: <alpine.LRH.2.00.0901031550530.3513@caramujo.chehab.org>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
	<alpine.LRH.2.00.0901031400260.3513@caramujo.chehab.org>
	<Pine.LNX.4.64.0901031714150.3955@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

On Sat, 3 Jan 2009, Guennadi Liakhovetski wrote:

>> At the way your patches were on -hg, they didn't apply upstream. I had to do
>> some manual work to make them apply.
>
> Right, I think, this is also a side effect of this "dualistic" development
> model - I prepared my patches to apply to the hg tree, and, as you know,
> back-porting of upstream work from mainline git to hg is not trivial, so,
> the two versions drifted apart by the time you tried to port the patches
> to git, so, merge-conflicts resulted.

Yes. You got the point.

>> Agreed. This means more work to me.
>
> Yes, that's why I tried to use hg - to avoid creating extra work for you,
> I'm sure, you have enough of it already. But it seems this way the
> problems are hardly fewer, they are just different...

True. Probably, for day-to-day changes, using -hg is better for my side, 
but when arch changes, it seems that using -git could work better...

>> I think we need to do this, but it is not so easy to make it happen. I intend
>> to work on it this year.
>
> I certainly understand this is not easy, and is not done in 1 hour,
> probably, not even in 10 hours. But as you write in your other post, if
> you're already spending _days_ on the hg-git merges, maybe it would be
> good to try to make this happen soon enough? In fact, what is needed for
> this?

I intend to do this work soon, but I want to finish some pending things 
before start this.

> You already have a git-tree and you already can handle git-based
> patches rom contributors, right? So, you will just drop your hg work
> completely and only handle git.

This will break the development model for all the other guys, so, this is 
not an alternative. I need first provide some way for them to send 
patches.

I can see a few alternatives:

1) provide some space for storing git trees at linuxtv.org. Not sure if 
we have enough space there for all those -git trees. This also envolves 
changing the current scripts for the new model;

2) Just accept patches sent by email. After having patchwork.kernel.org 
working for linux-media, handling patches by email could be almost as easy 
as handling pull requests, after some scripting. The advantage of this 
approach is that it makes easier to review individual patches, but I'm not 
sure if this scales for about 1000 patches per kernel cycle (we are close 
to this rate).

> The only work that I can see on this, is
> creating those snapshots and applying the compatibility craft, that we
> currently have in hg to make them compile against older kernels. Am I
> missing something?

This will require some additional work, since we'll need to find a way to 
convert patches from in-tree to out-of-tree. Probably, the better will be 
to keep using hg or migrating the out-of-tree also to git, in order to 
store the compatibility and building system patches.

-

> And now, Mauro, what do we do with this specific case? Are you going to
> fix it in your hg-/git-trees or are you expecting anything from me / Eric?

Please send me a patch fixing the issue, and I'll send it forward. You can 
write it against -hg or -git, since both trees are syncronized.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
