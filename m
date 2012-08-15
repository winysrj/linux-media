Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2HOTeZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 15:34:25 -0400
Message-ID: <502BF9B1.2050305@redhat.com>
Date: Wed, 15 Aug 2012 16:34:09 -0300
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
References: <502A4CD1.1020108@redhat.com> <201208141546.19560.hverkuil@xs4all.nl> <502A6075.6070606@redhat.com> <201208151154.04979.hverkuil@xs4all.nl>
In-Reply-To: <201208151154.04979.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2012 06:54, Hans Verkuil escreveu:
> On Tue August 14 2012 16:28:05 Mauro Carvalho Chehab wrote:
>> Em 14-08-2012 10:46, Hans Verkuil escreveu:
>>> On Tue August 14 2012 15:04:17 Mauro Carvalho Chehab wrote:

>> Without tagging them differently, I don't have any way to know what are
>> ready for merge, and what wasn't.
> 
> It's too bad patchwork doesn't support a way where the submitter can kill a
> wrong patch. That would be very useful.

Yes. If patchwork had such support, patch senders could also be marking a patch
as superseded or as RFC.

I don't know enough about patchwork to write such addition into it.

>> Anyway, I'm open to ideas on how to handle it better, especially when it helps
>> to allow handling patches on uniform way, without needing to apply different
>> procedures for each driver maintainer.
> 
> I have no problem with making pull requests when I think a patch series is ready,
> as long as it is made very clear to me that that's the way you work for patches
> from me.
> 
> This is fine for 'regular' patches. But in practice I also have two other kinds
> of patches: the first is the trivial kind: fixing typos, compiler warnings,
> one-liner bug fixes. Basically patches where the review process takes one
> minute tops. I would propose a [PATCH TRIVIAL] category: patchwork would pick
> them up, you go through them quickly once or twice a week and either apply them
> or mark them as RFC or something if you think they aren't as trivial as they
> look.

[PATCH TRIVIAL] is something that makes sense on those cases, and it is pretty
used on other trees.
 
> That way my git tree won't get messy with lots of little branches for what are
> trivial patches, and these patches get processed quickly so they won't clutter
> patchwork.
> 
> The other type of patch are core kernel API changes. Those need a review from
> you as well, and it is frankly very annoying if after a long discussion on the
> mailinglist we come to a solution, make a final pull request for it, and only
> then will you review it and shoot it down... And sometimes that happens just
> before the merge window opens, leaving us with no time to fix things.

True. I try to follow those patches at the ML when time allows me to do it,
and I'm just not so over-bloated with a huge patch backlog. FYI, on the last 2
days, ~60 new patches arriving and are waiting for my review. That's because 
it is not close to the end of a merge window, when the volume of patch goes as
high as the sky.

> I don't mind being shot down, but I'd like to see that happen a bit earlier
> in the process when I haven't invested that much time in it and when I can
> make changes in a timely manner.
> 
> So I proprose a [PATCH API] category for patches enhancing or modifying the
> core API.

OK.

> 
> It's a signal for you that these are relevant for you as subsystem maintainer
> to look at them earlier rather than waiting for the final pull request.
> 
> What do you think?
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

