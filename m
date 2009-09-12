Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3902 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZILPMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 11:12:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Media controller: sysfs vs ioctl
Date: Sat, 12 Sep 2009 17:12:35 +0200
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
References: <200909120021.48353.hverkuil@xs4all.nl> <829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com> <20090912114535.19f9716f@caramujo.chehab.org>
In-Reply-To: <20090912114535.19f9716f@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909121712.35718.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 12 September 2009 16:45:35 Mauro Carvalho Chehab wrote:
> Em Sat, 12 Sep 2009 09:41:58 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> 
> > I respectfully disagree.
> 
> Are you suggesting that we should not submit any patches upstream during this
> merge window in order to discuss this? Sorry, but this is not right with all 
> the developers that did their homework and submitted changes for 2.6.32.
> 
> >  The original version of this RFC has been
> > pending for almost a year now. 
> 
> It was not pending since then. As there were all the framework changes needed,
> we've agreed on doing the V4L framework changes, that were finally merged at 2.6.30[1],
> that were required, before proceeding with further discussions.
> 
> > Hans has written a prototype
> > implementation.  We should strive to get this locked down by the LPC
> > conference.
> 
> Why? Nothing stops discussing it there and better prepare a proposal, but,
> considering all the noise we had after the DVB S2API last year, I don't think
> we should ever repeat using a conference, where only some of us will be there
> to approve a proposal. It is the right forum for discussing and better formulate
> the issues, in order to prepare a proposal, but the decisions should happen at
> the ML.

In that particular case you would have had a lot of noise no matter what you
did :-)

The final decisions will indeed be taken here, but the conference is an
excellent place to talk face-to-face and to see how well the current proposal
will fit actual media hardware.

I don't have complete access or knowledge of all the current and upcoming
media boards, but there are several TI and Nokia engineers present who can
help with that. Also interesting is to see how and if the framework can be
extended to dvb.

> Hans took a year to prepare RFCv2, and we all know that he was hardly
> working on implementing what was discussed during the first RFC proposal during
> all those timeframe. This shows that this is a complex matter.

Not entirely true, I worked on the necessary building blocks for such a media
controller in the past year. There is a reason why it only took me 400-odd
lines to get the basic mc support in...

> > I think we all know that you are busy, but this conversation needs to
> > continue even if you personally do not have the cycles to give it your
> > full attention.
> 
> It is not only me that has pending tasks, but other developers are also focused
> on merging their things. For example, Mkrufky already pointed that he is
> waiting for the merge of the first part of his series, since he needs to send a
> complementary set of patches. I'm sure that there are other developers that
> are still finishing some working for the merge or that may need to solve the
> usual troubles that happens when some patches went upstream via other trees,
> needing to be backported and tested.
> 
> > There is finally some real momentum behind this initiative, and the
> > lack of this functionality is crippling usability for many, many
> > users.  "Hi I a new user to tvtime.  I can see analog tv with tvtime,
> > but how do I make audio work?"
> > 
> > Let's finally put this issue to rest.
> 
> Yes, let's do it for 2.6.33, but it this discussion started too late for 2.6.32.

I don't think anyone advocated getting anything merged for 2.6.32. Certainly
not me. I'm not even sure whether 2.6.33 is feasible: before we merge anything
I'd really like to see it implemented in e.g. omap3, uvcvideo and ivtv at the
least. The proof of the pudding is in the eating, and since this is meant to
cover a wide range of media boards we should have some idea if theory and
practice actually match.

Personally I think that the fact that I got an initial version implemented so
quickly is very promising.

I'm currently trying to get ivtv media-controller-aware. It's probably the
most complex driver when it comes to topology that I have access to, so that
would be a good test case.

> 
> Cheers,
> Mauro
> 
> [1] FYI, we had several regression fixes on 2.6.31 due to that - and there are
> still some unsolved regressions related to them - basically i2c gate and radio
> breakages yet requiring fixes. Some are documented at Kernel regression list
> and at bugzilla, others were just reported at ML. As I said a countless number
> of times, we need to focus fixing the regressions caused by those API changes
> before doing another series of changes at API. So, if people are with spare
> time, I suggest a task force to fix the remaining regressions mostly on saa7134.

Can someone keep a list of regressions and post that to the list every week or
so? You mention those regressions, but I've no idea what they are. I've seen
two regressions caused by the subdev changes: one related to the link order in
the kernel, one in bttv. I fixed both promptly.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
