Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab2HNO22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 10:28:28 -0400
Message-ID: <502A6075.6070606@redhat.com>
Date: Tue, 14 Aug 2012 11:28:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com> <201208141546.19560.hverkuil@xs4all.nl>
In-Reply-To: <201208141546.19560.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2012 10:46, Hans Verkuil escreveu:
> On Tue August 14 2012 15:04:17 Mauro Carvalho Chehab wrote:

>> A final note: patches from driver maintainers with git trees are generally
>> just marked as RFC. Well, I still applied several of them, when they're
>> trivial enough and they're seem to be addressing a real bug - helping
>> myself to not need to re-review them later.
> 
> Does that mean that if you are a maintainer with a git tree such as myself
> you should make a pull request instead of posting a [PATCH] because otherwise
> you mark it as an RFC patch?

Yes, please.

> I often just post simple patches instead of making a pull request, and I
> always use [RFC PATCH] if I believe the patches need more discussion.

That would work if the others would be doing the same. Unfortunately, other
usual developers don't do that: they send all patches under discussions as
"PATCH", making really hard to track what's ready for maintainer's review 
and what isn't. As not-so-frequent contributors (trivial fixes people; users
submitting their bug fix patches; first time contributors) send their patch
as "PATCH". Those patches aren't typically picked by driver maintainers,
so the task of reviewing them is, unfortunately, typically done only by
me.

> So if I post a [PATCH] as opposed to an [RFC PATCH], then that means that
> I believe that the [PATCH] is ready for merging. If I should no longer
> do that, but make a pull request instead, then that needs to be stated
> very explicitly by you. Otherwise things will get very confusing.

Yes, please post them as [RFC PATCH].

Maybe the patches that are about to be sent though a pull request could
use something like [RFC FINAL] or [PATCH FINAL], but maybe doing that
would be just overkill.
 
>> I really expect people to add more "RFC" on patches. We're having a net
>> commit rate of about 500-600 patches per merge window, and perhaps 3 or 4
>> times more patches at the ML that are just part of some discussions and
>> aren't yet on their final version. It doesn't scale if I need to review
>> ~3000 patches per merge window, as that would mean reviewing 75 patches per
>> working day. Unfortunately, linux-media patch reviewing is not my full-time
>> job. So, please help me marking those under-discussion patches as RFC, in
>> order to allow me to focus on the 600 ones that will actually be merged.
> 
> In fairness: often you get no comments when you post the RFC patch series,
> but once you post what you consider to be the final version you suddenly do
> get comments.

Well, if people don't comment the RFC patches, they should not be complaining
when it gets merged.

Thinking about that, by not having a "non-RFC" final patch series may actually
improve the process at long term, as people will look with another eyes for
the RFC ones.

> One example where you apparently marked a [PATCH] as RFC is this one:
> 
> http://patchwork.linuxtv.org/patch/13659/
> 
> Is this because Sylwester has his own git tree and you were expecting a pull
> request?

Yes.

> In this case it is a simple compiler warning fix which I would really like to
> see merged since it fixes a fair number of compiler warnings during the
> daily build.

See: 
	http://patchwork.linuxtv.org/patch/13763/

This is pretty much the same case of 13659, except that the patch was a
RFC (not tagged as such), and it was wrong. The correct one is:

	http://patchwork.linuxtv.org/patch/13790/

Without tagging them differently, I don't have any way to know what are
ready for merge, and what wasn't.

Anyway, I'm open to ideas on how to handle it better, especially when it helps
to allow handling patches on uniform way, without needing to apply different
procedures for each driver maintainer.

Regards,
Mauro
 
