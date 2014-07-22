Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:16451 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaGVE1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 00:27:41 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9300MK8J217M80@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jul 2014 00:27:37 -0400 (EDT)
Date: Tue, 22 Jul 2014 01:27:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
Message-id: <20140722012733.1688301f.m.chehab@samsung.com>
In-reply-to: <53CDD0FA.20300@iki.fi>
References: <53C874F8.3020300@iki.fi>
 <20140721205005.28e2e784.m.chehab@samsung.com> <53CDAB73.8050108@iki.fi>
 <20140721215140.35935811.m.chehab@samsung.com> <53CDB8C1.8000203@iki.fi>
 <20140721230956.76886a71.m.chehab@samsung.com> <53CDD0FA.20300@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 05:48:26 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 07/22/2014 05:09 AM, Mauro Carvalho Chehab wrote:
> > Em Tue, 22 Jul 2014 04:05:05 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> On 07/22/2014 03:51 AM, Mauro Carvalho Chehab wrote:
> >>> Em Tue, 22 Jul 2014 03:08:19 +0300
> >>> Antti Palosaari <crope@iki.fi> escreveu:
> >>>
> >>>> So what. Those were mostly WARNING only and all but long lines were some
> >>>> new checks added to checkpatch recently. chekcpatch gets all the time
> >>>> new and new checks, these were added after I have made that driver. I
> >>>> will surely clean those later when I do some new changes to driver and
> >>>> my checkpatch updates.
> >>>
> >>> Antti,
> >>>
> >>> I think you didn't read my comments in the middle of the checkpatch stuff.
> >>> Please read my email again. I'm not requiring you to fix the newer checkpatch
> >>> warning (Missing a blank line after declarations), and not even about the
> >>> 80-cols warning. The thing is that there are two issues there:
> >>>
> >>> 1) you're adding API bits at msi2500 driver, instead of moving them
> >>>      to videodev2.h (or reusing the fourcc types you already added there);
> >>
> >> If you look inside driver code, you will see those defines are not used
> >> - but commented out. It is simply dead definition compiler optimizes
> >> away. It is code I used on my tests, but finally decided to comment out
> >> to leave some time add those later to API. I later moved 2 of those to
> >> API, that is done in same patch serie.
> >>
> >> No issue here.
> >>
> >>> 2) you're handling jiffies wrong inside the driver.
> >>>
> >>> As you may know, adding a driver at staging is easier than at the main
> >>> tree, as we don't care much about checkpatch issues (and not even about
> >>> some more serious issues). However, when moving stuff out of staging,
> >>> we review the entire driver again, to be sure that it is ok.
> >>
> >> That jiffie check is also rather new and didn't exists time drive was
> >> done. Jiffie is used to calculate debug sample rate. There is multiple
> >> times very similar code piece, which could be optimized to one. My plan
> >> merge all those ~5 functions to one and use jiffies using macros as
> >> checkpatch now likes. I don't see meaningful fix it now as you are going
> >> to rewrite that stuff in near future in any case.
> >
> > Ok, I'll apply the remaining patches.
> >
> >> Silencing all those checkpatch things is not very hard job though. If
> >> you merge that stuff to media/master I can do it right away (I am
> >> running older kernel and older checkpatch currently).
> >
> > FYI, I always use the checkpatch available on our tree, no matter what
> > Kernel I'm running. My scripts just call ./scripts/checkpatch.pl.
> 
> I would like to also run/use *always* media/master, but it is not 
> usually possible. Let me list here all the issues which makes it 
> impossible in practice (issues which I see on current development process):
> 
> 1) media/master is far behind Linus kernel master tree. It is usually 
> updated only 2 times per RC cycle, RC1 and around RC5. Even I want test 
> upstream RC, that makes it impossible.

Hmm... you complained before that I was using a too new version of
checkpatch... Now you're complaining about just the opposite...

Anyway, nothing prevents you to pull from both Linus and my tree
at least for your testing purposes.

> 
> 2) RC1 is very often (more than 50%) unusable. It is simply too buggy. 
> For example 3.16 there was GPU related problems at least (and again).
> 
> 3) I send one fix (PULL requested) for brand new Silicon Labs Si2168 
> driver on 2014-06-15. That was just before RC1 was released. It was 
> merged to media/fixes, but not media/master. "Unfortunately" that driver 
> gets very much interest and multiple other developers started hacking 
> with it, adding support for new hw and so. There was huge headache to 
> lead that development because code base was divided to 2 upstream git 
> trees; one in media/fixes and another in media/development. Critical and 
> problematic patch was still only in media/fixes, leaving media/master 
> driver broken. So that forces me to use media/fixes as a base and add 
> new patches top of it. Media/fixes is 3.15 whilst media/master is 3.16. 
> I mentioned that already you and I have got bug reports too, latest one 
> 6 hours ago reporting his PCTV 292e stopped working...
> 
> 
> So could it be possible to address those issues? Like media/master 
> contains all latest upstream patches and is updated/rebased weekly top 
> of Linus main tree?

If you take a look at other big subsystems (x86 tip, arm, network, ...)
most of them are even more fragmented: they use topic branches, e. g.
each "conceptual" patchset goes to its own branch.

One big advantage of topic branches is that maintainers can send
pull requests from each topic directly to Linus, avoiding the risk
that one broken topic would harm the entire patch merging.

I use topic branch on some cases, but v4l2 core changes too often
to allow doing it on a broader scale.

My main concern, as maintainer, is to be sure that the patches will
flow fine during the merge window, so my flow is optimized for this
task.

Also, Linus hates to see lots of merging back from his tree at the
Maintainers trees, because it makes the patch history dirty.
So, what I do is that I merge back from his tree after he pulls
a pull request that I send him, and when such pull request is required
(e. g. a latter patch depends on something changed at fixes).

What I do on the drivers I develop is that I don't always base
on the master branch of my tree. Sometimes, I pull from both
fixes and master, and sometimes I pull from upstream. Whatever
works best for the driver I'm working with.

On my development flow, when I have something ready to be sent is that
I send the patches to the ML from whatever tree I use, then I add
them (or I rebase when possible) on a separate branch, based on my 
master tree (or fixes when this is the case).

That's said, it makes sense to have one branch that merges both
fixes and master, and use such branch for the media_build tree
to be based. I may try to work on that after the merge window,
in order to help people to test our drivers, but sending pull 
requests based on such tree can be complex, as patches from fixes 
could end by being merged twice, and rebasing on a merged tree
won't work properly, as it create newer hashes for the already
existing patches.

> 
> regards
> Antti
> 
