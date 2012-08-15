Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab2HOTYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 15:24:30 -0400
Message-ID: <502BF757.5000302@redhat.com>
Date: Wed, 15 Aug 2012 16:24:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com> <201208141546.19560.hverkuil@xs4all.nl> <502A6075.6070606@redhat.com> <1834028.kSBHul9iXV@avalon> <502B50AE.5080000@matrix-vision.de>
In-Reply-To: <502B50AE.5080000@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2012 04:33, Michael Jones escreveu:
> On 08/14/2012 05:21 PM, Laurent Pinchart wrote:
>> Hi Mauro,
>>
>> On Tuesday 14 August 2012 11:28:05 Mauro Carvalho Chehab wrote:
>>> Em 14-08-2012 10:46, Hans Verkuil escreveu:
>>> That would work if the others would be doing the same. Unfortunately, other
>>> usual developers don't do that: they send all patches under discussions as
>>> "PATCH", making really hard to track what's ready for maintainer's review
>>> and what isn't. As not-so-frequent contributors (trivial fixes people; users
>>> submitting their bug fix patches; first time contributors) send their patch
>>> as "PATCH". Those patches aren't typically picked by driver maintainers, so
>>> the task of reviewing them is, unfortunately, typically done only by me.
>>>
>>>> So if I post a [PATCH] as opposed to an [RFC PATCH], then that means that
>>>> I believe that the [PATCH] is ready for merging. If I should no longer
>>>> do that, but make a pull request instead, then that needs to be stated
>>>> very explicitly by you. Otherwise things will get very confusing.
>>>
>>> Yes, please post them as [RFC PATCH].
>>>
>>> Maybe the patches that are about to be sent though a pull request could
>>> use something like [RFC FINAL] or [PATCH FINAL], but maybe doing that
>>> would be just overkill.
>>
>> I post patches that I believe to be ready to be merged as "[PATCH]", even if I
>> plan to push them through my tree later. "RFC" usually has a different
>> meaning, I understand it as a work in progress on which comments would be
>> appreciated.
>>
>> As new developers just post patches as "[PATCH]" (probably because that's
>> git's default) we can't really change the meaning of that tag. We could ask
>> developers who maintain their own git tree to use a different tag (something
>> like "[PATCH FOR REVIEW]" for instance), but that won't work well if we need
>> to cross-post to other mailing lists that follow a different standard.
> 
> As one of the "not-so-frequent" contributors, it's obvious to me why we (incorrectly?)
> use just [PATCH] for initial submissions. Partly because it's git's default. 
> Partly because Documentation/SubmittingPatches describes this. The LinuxTV Wiki says
> to [1] ("RFC" is nowhere on this page). There are many parts of protocol here that
> may just be obvious to the regulars, but documentation-by-mailing-list is a frustrating
> and error-prone way to have to glean the guidelines before submission. If this thread
> leads to new agreed-upon guidelines, could someone please update [1] to reflect whatever
>  the consensus is?  It would be appropriate to at least mention 'git send-email' there, too.

Patches for "not-so-frequent" contributors aren't the problem. There are lots of
them, but they usually don't take long time on reviews: almost all are trivial ones,
as there are just a few new driver additions.

On the latter case, it easier to check if someone else already asked the new developer
to fix trivial things (it happens that new contributors are not aware of some things).
If nobody comments, I'll need to review it anyway. So, that's fine.

The big issue happens with drivers that suffer lots of reviews until they go upstream:
there are patches that took almost 20 versions for the developers with that hardware
to agree around a solution. The differences between each version are typically
due to some driver internals, that only the ones with the actual device can review.

The new versions are typically on new email threads. Even if they were at the same
thread, patchwork unfortunately is not able to detect that a new version superseded
the previous patch series.

So, your poor maintainer needs to dig into all those drafts, in order to pick the
right stuff in the middle of them. It is like extracting gold from a coal mine.

On the other hand, it makes perfect sense that those patches should be discussed
at the ML before being ready for pushing.

So, I need help from the ones that work with those stuff, in order to allow me to
fast track what should be just marked as RFC without needing to dig into the
entire patch pile.

Regards,
Mauro
