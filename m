Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab2J2Oxg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 10:53:36 -0400
Date: Mon, 29 Oct 2012 12:53:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/2] Fix a few more warnings
Message-ID: <20121029125320.04b403dc@redhat.com>
In-Reply-To: <508E8EB3.9050808@samsung.com>
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
	<508E6644.4040104@samsung.com>
	<20121029093251.1bb2acfa@redhat.com>
	<508E8EB3.9050808@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 15:12:03 +0100
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 10/29/2012 12:32 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 29 Oct 2012 12:19:32 +0100
> > Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> > 
> >> On 10/29/2012 11:21 AM, Mauro Carvalho Chehab wrote:
> >>> Hans Verkuil yesterday's build still got two warnings at the
> >>> generic drivers:
> >>>         http://hverkuil.home.xs4all.nl/logs/Sunday.log
> >>>
> >>> They didn't appear at i386 build probably because of some
> >>> optimization done there.
> >>>
> >>> Anyway, fixing them are trivial, so let's do it.
> >>>
> >>> After applying those patches, the only drivers left producing
> >>> warnings are the following platform drivers:
> >>>
> >>> drivers/media/platform/davinci/dm355_ccdc.c
> >>> drivers/media/platform/davinci/dm644x_ccdc.c
> >>> drivers/media/platform/davinci/vpbe_osd.c
> >>> drivers/media/platform/omap3isp/ispccdc.c
> >>> drivers/media/platform/omap3isp/isph3a_aewb.c
> >>> drivers/media/platform/omap3isp/isph3a_af.c
> >>> drivers/media/platform/omap3isp/isphist.c
> >>> drivers/media/platform/omap3isp/ispqueue.c
> >>> drivers/media/platform/omap3isp/ispvideo.c
> >>> drivers/media/platform/omap/omap_vout.c
> >>> drivers/media/platform/s5p-fimc/fimc-capture.c
> >>> drivers/media/platform/s5p-fimc/fimc-lite.c
> >>
> >> For these two files I've sent already a pull request [1], which
> >> includes a fixup patch
> >> s5p-fimc: Don't ignore return value of vb2_queue_init()
> >>
> >> BTW, shouldn't things like these be taken care when someone does
> >> a change at the core code ? 
> > 
> > Sure. I remember I saw one patch with s5p on that series[1].
> > Can't remember anymore if it were acked and merged directly, if
> > it was opted to send it via your tree (or maybe that patch was just
> > incomplete, and got unnoticed on that time).
> 
> I think this was one of the first patches from Ezequiel, when he wanted
> to change the vb2_queue_init() function signature so it returns void (as
> there were only BUG_ON()s used inside it). But what we need now at drivers
> is the opposite, i.e. to keep checking the return value and to add where
> such checks are missing. Thus patch [1] is not applicable, since BUG_ONs
> were replaced with WARN_ON and __must_check annotation was added to the
> vb2_queue_init() function declaration.

Ah, ok.

> > [1] https://patchwork.kernel.org/patch/1372871/
> > 
> > It is not easy to enforce those kind of things for platform drivers,
> > as there's not yet a single .config file that could be used to test
> > all arm drivers. Hans automatic builds might be useful, if there weren't
> 
> The ARM arch consolidation efforts are ongoing, for 1.5 year now IIRC
> and there are good results. Still it looks like there is one year or so 
> needed to be able to build one single image usable on all ARM sub-archs.
> I think the progress is good and it all looks very promising, perhaps 
> mostly thanks to the Linaro initiative.

Yeah, when all platform drivers we have can be compiled here, I'll eventually
add it on my test logic. The thing is that changing from one arch to the other
will require doing a make clean, with can be a little painful.
> 
> > any warns at the -git tree build at the tested archs, but there are
> > so many warnings that I think I never saw any such report saying that
> > there's no warning.
> > 
> > Btw, are there anyone really consistently using his reports to fix things?
> 
> Yes, I'm often looking at those logs. I find them useful, especially that 
> it nearly doesn't happen I build some drivers on architectures other than 
> ARM. So it's good to have those build logs.
> 
> Some projects, e.g. [2], use build/test systems that allow to track status
> after each commit. Not sure if something like this is feasible for whole
> media subsystem.
> 
> [2] https://chromium-build.appspot.com/p/chromium/console

The idea is good. The evil is on details. For example, I prefer to not mix
any build setup like that with the main linuxtv site, due to machine's
reliability.

Even running it locally would also likely require two machines, as the multi-arch
compilation will take some time, and several GB of diskspace, as each arch will
need a local working copy of the git tree.

Asynchronous compilation of the kernel, while patches are being added has
some issues: if the build fails, patches need to be reverted, as we don't
want to break git bisect. That would mean that we would need a temporary
"untested" tree, and some logic there that will cherry-pick patches to the
"tested" one when compilation succeeds, or stop and warn maintainer if a
patch breaks. The maintainer will then need to rebase the "untested" tree
which can, in tune, cause troubles at the testing daemon.

Anyway, implementing it would require some time and resources 
that I don't currently have. If anyone could do it, that could be
a nice project.

Regards,
Mauro
