Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZILOqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:46:04 -0400
Date: Sat, 12 Sep 2009 11:45:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
Message-ID: <20090912114535.19f9716f@caramujo.chehab.org>
In-Reply-To: <829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com>
References: <200909120021.48353.hverkuil@xs4all.nl>
	<20090912103111.7afffb2d@caramujo.chehab.org>
	<829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Sep 2009 09:41:58 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> I respectfully disagree.

Are you suggesting that we should not submit any patches upstream during this
merge window in order to discuss this? Sorry, but this is not right with all 
the developers that did their homework and submitted changes for 2.6.32.

>  The original version of this RFC has been
> pending for almost a year now. 

It was not pending since then. As there were all the framework changes needed,
we've agreed on doing the V4L framework changes, that were finally merged at 2.6.30[1],
that were required, before proceeding with further discussions.

> Hans has written a prototype
> implementation.  We should strive to get this locked down by the LPC
> conference.

Why? Nothing stops discussing it there and better prepare a proposal, but,
considering all the noise we had after the DVB S2API last year, I don't think
we should ever repeat using a conference, where only some of us will be there
to approve a proposal. It is the right forum for discussing and better formulate
the issues, in order to prepare a proposal, but the decisions should happen at
the ML.

Hans took a year to prepare RFCv2, and we all know that he was hardly
working on implementing what was discussed during the first RFC proposal during
all those timeframe. This shows that this is a complex matter.

> I think we all know that you are busy, but this conversation needs to
> continue even if you personally do not have the cycles to give it your
> full attention.

It is not only me that has pending tasks, but other developers are also focused
on merging their things. For example, Mkrufky already pointed that he is
waiting for the merge of the first part of his series, since he needs to send a
complementary set of patches. I'm sure that there are other developers that
are still finishing some working for the merge or that may need to solve the
usual troubles that happens when some patches went upstream via other trees,
needing to be backported and tested.

> There is finally some real momentum behind this initiative, and the
> lack of this functionality is crippling usability for many, many
> users.  "Hi I a new user to tvtime.  I can see analog tv with tvtime,
> but how do I make audio work?"
> 
> Let's finally put this issue to rest.

Yes, let's do it for 2.6.33, but it this discussion started too late for 2.6.32.

Cheers,
Mauro

[1] FYI, we had several regression fixes on 2.6.31 due to that - and there are
still some unsolved regressions related to them - basically i2c gate and radio
breakages yet requiring fixes. Some are documented at Kernel regression list
and at bugzilla, others were just reported at ML. As I said a countless number
of times, we need to focus fixing the regressions caused by those API changes
before doing another series of changes at API. So, if people are with spare
time, I suggest a task force to fix the remaining regressions mostly on saa7134.
