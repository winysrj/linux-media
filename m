Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4196 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2HOJyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 05:54:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
Date: Wed, 15 Aug 2012 11:54:04 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	David =?utf-8?q?H=C3=A4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
References: <502A4CD1.1020108@redhat.com> <201208141546.19560.hverkuil@xs4all.nl> <502A6075.6070606@redhat.com>
In-Reply-To: <502A6075.6070606@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151154.04979.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 16:28:05 Mauro Carvalho Chehab wrote:
> Em 14-08-2012 10:46, Hans Verkuil escreveu:
> > On Tue August 14 2012 15:04:17 Mauro Carvalho Chehab wrote:
> 
> >> A final note: patches from driver maintainers with git trees are generally
> >> just marked as RFC. Well, I still applied several of them, when they're
> >> trivial enough and they're seem to be addressing a real bug - helping
> >> myself to not need to re-review them later.
> > 
> > Does that mean that if you are a maintainer with a git tree such as myself
> > you should make a pull request instead of posting a [PATCH] because otherwise
> > you mark it as an RFC patch?
> 
> Yes, please.

OK. It would help if you notify all maintainers that you handle in such a manner.
And perhaps have a list on the wiki as well.

That way there is no confusion.

> > I often just post simple patches instead of making a pull request, and I
> > always use [RFC PATCH] if I believe the patches need more discussion.
> 
> That would work if the others would be doing the same. Unfortunately, other
> usual developers don't do that: they send all patches under discussions as
> "PATCH", making really hard to track what's ready for maintainer's review 
> and what isn't. As not-so-frequent contributors (trivial fixes people; users
> submitting their bug fix patches; first time contributors) send their patch
> as "PATCH". Those patches aren't typically picked by driver maintainers,
> so the task of reviewing them is, unfortunately, typically done only by
> me.
> 
> > So if I post a [PATCH] as opposed to an [RFC PATCH], then that means that
> > I believe that the [PATCH] is ready for merging. If I should no longer
> > do that, but make a pull request instead, then that needs to be stated
> > very explicitly by you. Otherwise things will get very confusing.
> 
> Yes, please post them as [RFC PATCH].
> 
> Maybe the patches that are about to be sent though a pull request could
> use something like [RFC FINAL] or [PATCH FINAL], but maybe doing that
> would be just overkill.

I think that's overkill.

> >> I really expect people to add more "RFC" on patches. We're having a net
> >> commit rate of about 500-600 patches per merge window, and perhaps 3 or 4
> >> times more patches at the ML that are just part of some discussions and
> >> aren't yet on their final version. It doesn't scale if I need to review
> >> ~3000 patches per merge window, as that would mean reviewing 75 patches per
> >> working day. Unfortunately, linux-media patch reviewing is not my full-time
> >> job. So, please help me marking those under-discussion patches as RFC, in
> >> order to allow me to focus on the 600 ones that will actually be merged.
> > 
> > In fairness: often you get no comments when you post the RFC patch series,
> > but once you post what you consider to be the final version you suddenly do
> > get comments.
> 
> Well, if people don't comment the RFC patches, they should not be complaining
> when it gets merged.
> 
> Thinking about that, by not having a "non-RFC" final patch series may actually
> improve the process at long term, as people will look with another eyes for
> the RFC ones.
> 
> > One example where you apparently marked a [PATCH] as RFC is this one:
> > 
> > http://patchwork.linuxtv.org/patch/13659/
> > 
> > Is this because Sylwester has his own git tree and you were expecting a pull
> > request?
> 
> Yes.
> 
> > In this case it is a simple compiler warning fix which I would really like to
> > see merged since it fixes a fair number of compiler warnings during the
> > daily build.
> 
> See: 
> 	http://patchwork.linuxtv.org/patch/13763/
> 
> This is pretty much the same case of 13659, except that the patch was a
> RFC (not tagged as such), and it was wrong. The correct one is:
> 
> 	http://patchwork.linuxtv.org/patch/13790/
> 
> Without tagging them differently, I don't have any way to know what are
> ready for merge, and what wasn't.

It's too bad patchwork doesn't support a way where the submitter can kill a
wrong patch. That would be very useful.

> Anyway, I'm open to ideas on how to handle it better, especially when it helps
> to allow handling patches on uniform way, without needing to apply different
> procedures for each driver maintainer.

I have no problem with making pull requests when I think a patch series is ready,
as long as it is made very clear to me that that's the way you work for patches
from me.

This is fine for 'regular' patches. But in practice I also have two other kinds
of patches: the first is the trivial kind: fixing typos, compiler warnings,
one-liner bug fixes. Basically patches where the review process takes one
minute tops. I would propose a [PATCH TRIVIAL] category: patchwork would pick
them up, you go through them quickly once or twice a week and either apply them
or mark them as RFC or something if you think they aren't as trivial as they
look.

That way my git tree won't get messy with lots of little branches for what are
trivial patches, and these patches get processed quickly so they won't clutter
patchwork.

The other type of patch are core kernel API changes. Those need a review from
you as well, and it is frankly very annoying if after a long discussion on the
mailinglist we come to a solution, make a final pull request for it, and only
then will you review it and shoot it down... And sometimes that happens just
before the merge window opens, leaving us with no time to fix things.

I don't mind being shot down, but I'd like to see that happen a bit earlier
in the process when I haven't invested that much time in it and when I can
make changes in a timely manner.

So I proprose a [PATCH API] category for patches enhancing or modifying the
core API.

It's a signal for you that these are relevant for you as subsystem maintainer
to look at them earlier rather than waiting for the final pull request.

What do you think?

Regards,

	Hans
