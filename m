Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60982 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752418Ab0EPPEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 11:04:38 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: av7110 and budget_av are broken!
Date: Sun, 16 May 2010 17:01:34 +0200
Cc: linux-media@vger.kernel.org,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl> <201005160622.00278@orion.escape-edv.de> <4BEFEBAE.8020600@infradead.org>
In-Reply-To: <4BEFEBAE.8020600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005161701.36084@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 16 May 2010 14:57:18 Mauro Carvalho Chehab wrote:
> Oliver Endriss wrote:
> > On Sunday 16 May 2010 03:53:48 hermann pitton wrote:
> >> Hi, Douglas and Oliver,
> >>
> >> just as a small comment.
> >>
> >> I have not been on latest rc1 and such rcs close to a release for some
> >> time.
> >>
> >> But I was for a long time and v4l-dvb can't be a substitute for such.
> > 
> > Sorry, I do not want to cope with experimental kernels and their bugs on
> > my systems. I need a stable and reliable platform, so that I can
> > concentrate on 'my' bugs.
> > 
> > Usually I update the kernel every 3..4 releases (which causes enough
> > trouble due to changed features, interfaces etc).
> 
> I used to do it, but, in fact updating every release and following stable
> worked better for me, since there are less changes at the features, making
> easier to compile a new kernel that won't break anything.
> 
> Anyway, it is up to you to use whatever works better for you.

Well, the problem is bug hunting: If you have changes both in the kernel
and in the driver, it is harder to identify the problem...

> >> Despite of getting more users for testing, on _that_ front does not
> >> happen such much currently, keeping v4l-dvb is mostly a service for
> >> developers this time.
> >>
> >> So, contributing on the backports and helping Douglas with such is
> >> really welcome.
> > 
> > I confess that I do not know much about the tree handling procedures of
> > the kernel. Imho it sounds crazy to have separate 'fixes' and
> > 'development' trees.
> 
> I'll change the procedures for 2.6.35. I'll basically opt for having
> topic branches (for example, having a "ngene" branch), where all ngene patches
> will be applied, updating "master" only after having those patches in kernel.

How do you handle patches for shared components (frontend drivers,
dvb-core etc)? With topic branches, you have to apply those to every
topic branch which depends on them.

> I'll likely create a stable branch, with the latest kernel, plus all patches
> (like v2.6.34-v4l-dvb), to help people that want to develop using git.
> 
> The big problem when handling patches upstream is caused by rebasing a patch,
> and the higher number of patches in a tree, the higher is the probability that
> a rebase will needed to avoid breaking compilation on a bisect.
> 
> To give you an example, one big series of patches moved slab.h into each 
> driver that uses malloc. If a new driver or c file that needs this include
> on our series were added, to avoid breaking bisect, we need to go to the patch
> that introduced this code, and add the include there. All patches after this
> one needs to be rebased, when submitting upstream.

I would rather break bisect than doing that. In this example one could
simply disable the new driver in menuconfig to avoid the problem.

> So, let's say that the original patch has 05a43 has, and the new patch has
> a0342 (fictional numbers).
> 
> So, in the development branches, this patch is known as 05a43, where, on
> upstream, this patch will be known as a0342.
> 
> If I rebase the development tree, all developers using git would need to rebase
> their trees. If I don't rebase, after merging from upstream, this patch will
> appear 2 times at the master branch history: as 05a43 and as a0342. To be worse,
> on the next time I need to send patches upstream, this patch will appear again
> on my pile of patches to be submitted, and I'll need to manually drop it.
> Due to 2.6.33 merge, this problem is already present on our master branch. So,
> I'll need to drop a big pile of patches on my next upstream pull request.
> At each new kernel release, things would become worse.

Hm. Imho tree handling is getting way too complicated. ;-(

> With topic branches, things will hopefully become easier, as people can base their
> trees on a topic branch. Also, we may have some topic branches based on a stable
> release, and others based on upstream, but it will require me to maintain separate
> development branches with all merging patches per kernel release.

See above. I doubt that it will make things really easier.

> > A developer's tree (no matter whether HG or GIT) must also include the
> > fixes, otherwise it is unusable. You cannot wait until applied fixes
> > flow back from the kernel.
> > 
> > Btw, the v4ldvb HG repositories contain tons of disabled code (marked
> > '#if 0'), which was stripped for submission to the kernel.
> > Even if we would switch to GIT completely, we need a separate GIT
> > repository which would hold the original code.
> 
> This is due to a policy we had at -hg time: not pollute upstream with
> dead code garbage. Maybe we may have a topic branch with all those dead code, 
> but I think that, before adding those code on kernel, we need to review what 
> will be added there: there are _lots_ of such #if 0 code that is there for 
> years and were never touched (in a matter of fact, this is the typical
> case). It seems valuable to do a cleanup first, at -hg, removing the ones that
> are there for ages and that nobody is interested on working it, and just
> drop at -hg. It will still be there forever, at -hg history, but the source
> files will be cleaner without those useless code.

I agree that dead code should be identified and removed, but debug stuff
must be preserved. After 2 years nobody remembers that this stuff did
ever exist. So the history will not be checked...

Furthermore, if HG will be dropped some time in the future, history and
corresponding code might be lost.

> In the specific case of ngene, where stoth and devin are working to enable most
> of those dead code, I'll seek for an approach that will add those #if 0 code
> before applying the patches that will fix that code, in order to have a better
> history at -git, when they submit their next pull request.

ngene is a very new driver. New features and cards are still being added.
So it is handy to have the '#if 0's in the development tree.
When the driver has settled, the code should be cleaned-up.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
