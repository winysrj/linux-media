Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2482 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1ECFQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 01:16:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Tue, 3 May 2011 07:15:59 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <1304390415.2461.126.camel@localhost> <4DBF7642.8000101@redhat.com>
In-Reply-To: <4DBF7642.8000101@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105030715.59423.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, May 03, 2011 05:28:02 Mauro Carvalho Chehab wrote:
> Em 02-05-2011 23:40, Andy Walls escreveu:
> > Hi All,
> > 
> > Ah crud, what a mess.  Where to begin...?
> > 
> > Where have I been:
> > 
> > On 30 March 2011, my 8-year-old son was diagnosed with Necrotizing
> > Fasciitis caused by Invasive Group A Streptococcous - otherwise known as
> > "Flesh-eating bacteria":
> > 
> > http://en.wikipedia.org/wiki/Necrotizing_fasciitis
> > http://www.ncbi.nlm.nih.gov/pubmedhealth/PMH0002415/
> 
> Sorry to hear about that!
> 
> > By the grace of God, my son was diagnosed very early.  He only lost the
> > fascia on his left side and one lymph node - damage essentially
> > unnoticable to anyone, including my son himself.  His recovery progress
> > is excellent and he is now back to his normal life. Yay! \O/
> 
> Good! I hope him to fully recover from the disease. All the best for you
> and your wife. Our hearts are with you.
> 
> > Naturally, Linux driver development disappeared from my mind during the
> > extended hospital stay, multiple surgeries, and post-hospitalization
> > recovery.
> > 
> > As always; yard-work, house-work, work-work, choir practice, kids'
> > sports, kids' after school clubs, and kids' instrument lessons also
> > consume my time.
> > 
> 
> Completely understandable.
> 
> > History of this patch:
> > 
> > 1. Steven wrote the bulk of it 10 months ago:
> > 
> > 	http://www.kernellabs.com/hg/~stoth/cx18-videobuf/
> > 
> > 2. At Steven's request, I took a day and reviewed it on July 10 2010 and
> > provide comments off-list.  (I will provide them in a follow up to Mauro
> > Devin and Hans).
> 
> Thanks! 
> 
> Next time, please answer it publicly, or if the patch author submitted
> it in priv for a good reason, please c/c me on the review, in order to
> warn me that you have some restrictions about a patch.
> 
> > 3. The patch languished as Steven didn't have time to make the fixes and
> > neither did I.
> > 
> > 4. Videobuf2 came along as did good documentation on the deficiencies of
> > videobuf1:
> > 
> > http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-v4l2_summit-videobuf.pdf
> > http://linuxtv.org/downloads/presentations/summit_jun_2010/Videobuf_Helsinki_June2010.pdf
> > http://lwn.net/Articles/415883/
> > 
> > 5. I started independent work to implement videobuf2 for YUV and
> > actually using zero-copy.  My progress is very slow.
> > 
> > http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18-vb2-proto
> > http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39
> > 
> > 6. Simon submits the patches to the list as one big patch.
> > 
> > 7. Off-list I forward the same 5 emails of comments to Simon as I
> > provided in #2 to Steven.
> 
> In this case, as Simon had opened the source code already for the patch,
> the better would be if you had made a public statement about your nack.
> I always review the ML before applying a patch.
> 
> > 8. Simon addresses most of the comments and provides a revised patch
> > off-list asking for review.  I haven't had time to look at it.
> > 
> > 9. Mauro commits the original patch that Simon submitted to the list.
> > 
> > 
> > My thoughts:
> > 
> > 1. I don't want to stop progress, so I did not NACK this patch.  I don't
> > exactly like the patch either, so I didn't ACK it.
> > 
> > 2. At a minimum someone needs to review Simon's revised patch that tried
> > to address my comments.  That patch has to be better than this one.
> > Hans has already noticed a few of the bugs I pointed out to Steven and
> > Simon.
> > 
> > 3. I value that this patch has been tested, but I am guessing the
> > use-case was limited.  The toughest cx18 use-cases involve a lot of
> > concurrency - multiple stream captures (MPEG, VBI, YUV, PCM) on multiple
> > boards (3 or 4).  I had to do a lot of work with the driver to get that
> > concurrency reliable and performing well.  Has this been tested post-BKL
> > removal?  Have screen sizes other than the full-screen size been tested?
> > 
> > 4. I do not like using videobuf(1) for this.  Videobuf(1) is a buggy
> > dead-end IMO.  I will NACK any patch that tries to fix anything due to
> > videobuf(1) related problems introduced into cx18 by this patch.
> > There's no point in throwing too much effort into fixing what would
> > likely be unfixable.
> > 
> > 5. When I am done with my videobuf2 stuff for cx18, I will essentially
> > revert this one and add in my new implementation after sufficient
> > testing.  Though given the amount of time I have for this, maybe the
> > last HVR-1600 will be dead before then.
> > 
> > 
> > Summary:
> > 
> > 1. I'm not going to fix any YUV related problems merging this patch
> > causes.  It's the YUV stream of an MPEG capture card that's more
> > expensive than a simple frame grabber.  (I've only heard of it being
> > used for live play of video games and of course for Simon's
> > application.)
> > 
> > 2. I'd at least like Simon's revised patch to be merged instead, to fix
> > the known deficincies in this one.
> 
> IMO, the proper workflow would be that Simon should send his changes, as
> a diff patch against the current one. We can all review it, based on the
> comments you sent in priv and fix it.

I disagree. The proper workflow in this particular instance is to revert the
patch, have Simon post the revised patch to the list and have it reviewed on
the list.

As Andy noticed, in this particular case the whole procedure was a mess due
to completely understandable reasons. Nobody is to blame, it's just one of
those things that happens.

Reading through the comments Andy made regarding this patch it is clear to
me that there are too many issues with this patch.

Anyway, I stand by my NACK.

> As it seems that that the patch offers a subset of the desired features
> that you're planning with your approach, maybe the better would be to add
> a CONFIG var to enable YUV support, stating that such feature is experimental.
> 
> > 3. If merging this patch, means a change to videobuf2 in the future is
> > not allowed, than I'd prefer to NACK the patch that introduces
> > videobuf(1) into cx18.
> 
> The addition of VB1 first doesn't imply that VB2 would be acked or nacked.
> 
> In any case, the first non-embedded VB2 driver will need a very careful
> review, to be sure that they won't break any userspace applications. 
> On embedded hardware, only a limited set of applications are supported, and they
> are patched and bundled together with the hardware, so there's not much concern
> about userspace apps breakage.
> 
> However, on non-embedded hardware, we should be sure that no regressions to
> existing applications will happen. So, the better would be if the first VB2 
> non-embedded driver to be a full-featured V4L2 board (e. g. saa7134 or bttv, 
> as they support all types of video buffer userspace API's, including overlay
> mode), allowing us to test if VB2 is really following the specs (both the
> "de facto" and "de jure" specs).

I fail to see why we can't implement vb2 in cx18. And vb2 has been tested
extensively already with respect to the spec. vivi is using it, and I'm doing
a lot of testing with that driver.

Note that the current set of drivers behaves different already depending on
whether videobuf is used or not. Drivers like UVC follow the spec, drivers
based on videobuf don't. It's a big freakin' mess.

Regards,

	Hans
 
> After having one full-featured driver ported to VB2, the other driver conversions
> and usages of VB2 will depend mostly on driver maintainer's desire and enough tests.
> 
> Cheers,
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
