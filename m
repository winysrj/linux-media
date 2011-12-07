Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37914 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1LGKVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:21:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James <angweiyang@gmail.com>
Subject: Re: Media Controller (v4l2 & core) & MT9V032 Device Driver
Date: Wed, 7 Dec 2011 11:21:39 +0100
Cc: linux-media@vger.kernel.org
References: <CAOy7-nPYe=QDE1HgeDSth6Co34Bz+8wwNbzONNb88zsRDPajWA@mail.gmail.com> <CAOy7-nNyfiHkhm37hXCGJPZzxpcR-HrUFkScB0wy0HJyZFFmzA@mail.gmail.com> <CAOy7-nN9WeDC47W83YmNSo_UF92RNc7Uto2P9EuGXJ1mYu9hBg@mail.gmail.com>
In-Reply-To: <CAOy7-nN9WeDC47W83YmNSo_UF92RNc7Uto2P9EuGXJ1mYu9hBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112071121.39412.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Wednesday 07 December 2011 09:00:18 James wrote:
> > On Friday 02 December 2011 05:14:36 James wrote:
> > > On Thu, Dec 1, 2011 at 7:10 AM, Laurent Pinchart wrote:
> > > > On Tuesday 29 November 2011 03:07:28 James wrote:
> > > > > On Mon, Nov 28, 2011 at 7:15 PM, Laurent Pinchart wrote:
> > > > > > Regarding why mplayer fails, I'm not too sure. Your pipeline is
> > > > > > configured for YUYV, have you tried replacing outfmt=uyvy with
> > > > > > outfmt=yuyv on the mplayer command line ?
> > > > > 
> > > > > AFAIK mplayer only has outfmt=uyvy and even with the pipeline
> > > > > configured to UYVY, the result is the same; "0 frame processed".
> > > > > 
> > > > > Any suggestion is most welcome to me. (^^)
> > > > 
> > > > I wrote a patch that fixes the 2 warnings you get. It might help with
> > > > mplayer, could you please try it ?
> > > > 
> > > > 
> > > > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3i
> > > > sp- omap3isp-next
> > > 
> > > How can I merge the patches in your branch omap3isp-omap3isp-next to
> > > Steve's tree locally?
> > > 
> > > 1) I've cloned Steve's repo locally.
> > > 
> > > 2) use "git remote add pinchart git://linuxtv.org/pinchartl/media.git"
> > > to
> > > the tree.
> > > 
> > > 3) checked out the "omap3isp-omap3isp-next" branch
> > > 
> > > 4) make a new branch that tracks Steve's "omap-3.0-pm".
> > > "git checkout -b myomap-3.0-pm -t origin/omap-3.0-pm"
> > > 
> > > 5) Merge your "omap3isp-omap3isp-next" branch.
> > > "git pull . omap3isp-omap3isp-next"
> > > 
> > > after this command, I saw lots of files being removed and several merge
> > > conflicts.
> > > I tried git mergetool to call up kdiff3 to manually resolve but some
> > > are way out of ability/level of understanding since I don't know which
> > > holds the latest patches integrated into the respective files.
> > > 
> > > The confusing parts is when your branch deleted lots of files. even
> > > drivers/net/smsc911x.c which is the driver for the ethernet chip!?!
> > > 
> > > (^^)" very confusing.. hahahaha....
> > 
> > That's because the two branches include lots of different changes. My
> > branch is based on Mauro's official branch for patches targeted at the
> > next kernel version, which is in turn based on mainline (between v3.1 and
> > v3.2-rc1) and includes many patches for drivers/media/*. Steve's branch is
> > also based on mainline, but on v3.0 instead of v3.1, and includes other
> > patches.
> 
> Thanks for clarifying the starting point of your tree.
> Which branch at Mauro's tree is your "omap3isp-omap3isp-next" sitting on?

My -next branches are based on the latest staging/for_v3.* branch. I rebase 
them from time to time, so they might lag slightly.

> > If you merge my branch onto Steve's tree, you will get the whole v3.1,
> > which likely conflicts. Doing it the other way around isn't much better.
> > The easiest way to use the OMAP3 ISP patches on top of Steve's tree is
> > likely to hand-pick them. You can get a list of patches with git log, and
> > use git cherry-pick to pick them manually.
> 
> With this layout, my understanding is that the 'proper' path for Steve's
> branch to get updated with all media patches is only when the mainline
> merged Mauro's branch and Steve pull them into his or rebase against it.
> Right?

Then you will get all patches automatically, but you will have to wait some 
time for them (v3.3 will be released in roughly 2 months). If you want to test 
the patches sooner, you can either merge Steve's branch onto omap3isp-
omap3isp-next (but you might have to fix some conflicts manually), or use one 
of the two branches and cherry-pick the patches you want from the other 
branch. That's more work, but you'll get the result now.

> I saw Steve's repo staging a new "omap-v3.2".
> http://www.sakoman.com/cgi-bin/gitweb.cgi?p=linux-omap-2.6.git;a=shortlog;h
> =refs/heads/omap-3.2
> 
> Wonder till what stage has Mauro's branch been merged into mainline.

A staging/for_v3.* branch is merged into mainline in the v3.*-rc1 version. 
staging/for_v3.3 is thus waiting for the v3.3 merge window to open.

> Is there a way to determine a common baseline/point between both trees so
> that I can hand-pick them into Steve's v3.2?

git-merge-base.

> My understanding of git workflow is still at 'infant' stage. (^^)" and the
> difficulty is learning how to 'pull, merge & resolves conflicts' from
> different trees/branches. (^^)

I understand your pain. I've been there, and the learning curve was steep. But 
don't despair, once you understand the tool, it's extremely powerful.

For this particular case you have another option. You can use Steve's tree and 
compile the V4L-DVB subsystem from my tree on top of that. Get a clone of 
media_build.git from git.linuxtv.org, and look for instructions in the 
linuxtv.org wiki. In a nutshell, media_build is a set of scripts and patches 
that let you compile the V4L-DVB subsystem from one git tree to run on another 
git tree. There can be compile errors from time to time when using bleeding 
edge kernels for either of the trees, but media_build then gets updated pretty 
fast.

> Since I'm using Overo, I relies mainly on Steve's repo but I do know that
> TI has a linux-omap tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git which
> is fairly updated & tracks the mainline closely.

You could try using mainline directly. It works pretty well on Overo.

-- 
Regards,

Laurent Pinchart
