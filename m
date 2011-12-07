Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62736 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1LGIAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 03:00:20 -0500
Received: by wgbdr13 with SMTP id dr13so819190wgb.1
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 00:00:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOy7-nNyfiHkhm37hXCGJPZzxpcR-HrUFkScB0wy0HJyZFFmzA@mail.gmail.com>
References: <CAOy7-nPYe=QDE1HgeDSth6Co34Bz+8wwNbzONNb88zsRDPajWA@mail.gmail.com>
	<201112010010.47269.laurent.pinchart@ideasonboard.com>
	<CAOy7-nPSi8TLOxHw0kDay=f3=Pc_R6cXjurP33BPUXtyzqOAOA@mail.gmail.com>
	<201112061755.08575.laurent.pinchart@ideasonboard.com>
	<CAOy7-nNyfiHkhm37hXCGJPZzxpcR-HrUFkScB0wy0HJyZFFmzA@mail.gmail.com>
Date: Wed, 7 Dec 2011 16:00:18 +0800
Message-ID: <CAOy7-nN9WeDC47W83YmNSo_UF92RNc7Uto2P9EuGXJ1mYu9hBg@mail.gmail.com>
Subject: Re: Media Controller (v4l2 & core) & MT9V032 Device Driver
From: James <angweiyang@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Re-sent as mailing list rejected the original HTML email.)

Hi Laurent,

> On Friday 02 December 2011 05:14:36 James wrote:
> > On Thu, Dec 1, 2011 at 7:10 AM, Laurent Pinchart wrote:
> > > On Tuesday 29 November 2011 03:07:28 James wrote:
> > > > On Mon, Nov 28, 2011 at 7:15 PM, Laurent Pinchart wrote:
> > > > > Regarding why mplayer fails, I'm not too sure. Your pipeline is
> > > > > configured for YUYV, have you tried replacing outfmt=uyvy with
> > > > > outfmt=yuyv on the mplayer command line ?
> > > >
> > > > AFAIK mplayer only has outfmt=uyvy and even with the pipeline
> > > > configured to UYVY, the result is the same; "0 frame processed".
> > > >
> > > > Any suggestion is most welcome to me. (^^)
> > >
> > > I wrote a patch that fixes the 2 warnings you get. It might help with
> > > mplayer, could you please try it ?
> > >
> > >
> > > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > > omap3isp-next
> >
> > How can I merge the patches in your branch omap3isp-omap3isp-next to
> > Steve's tree locally?
> >
> > 1) I've cloned Steve's repo locally.
> >
> > 2) use "git remote add pinchart git://linuxtv.org/pinchartl/media.git"
> > to
> > the tree.
> >
> > 3) checked out the "omap3isp-omap3isp-next" branch
> >
> > 4) make a new branch that tracks Steve's "omap-3.0-pm".
> > "git checkout -b myomap-3.0-pm -t origin/omap-3.0-pm"
> >
> > 5) Merge your "omap3isp-omap3isp-next" branch.
> > "git pull . omap3isp-omap3isp-next"
> >
> > after this command, I saw lots of files being removed and several merge
> > conflicts.
> > I tried git mergetool to call up kdiff3 to manually resolve but some are
> > way out of ability/level of understanding since I don't know which holds
> > the latest patches integrated into the respective files.
> >
> > The confusing parts is when your branch deleted lots of files. even
> > drivers/net/smsc911x.c which is the driver for the ethernet chip!?!
> >
> > (^^)" very confusing.. hahahaha....
>
> That's because the two branches include lots of different changes. My
> branch
> is based on Mauro's official branch for patches targeted at the next
> kernel
> version, which is in turn based on mainline (between v3.1 and v3.2-rc1)
> and
> includes many patches for drivers/media/*. Steve's branch is also based on
> mainline, but on v3.0 instead of v3.1, and includes other patches.

Thanks for clarifying the starting point of your tree.
Which branch at Mauro's tree is your "omap3isp-omap3isp-next" sitting on?

> If you merge my branch onto Steve's tree, you will get the whole v3.1,
> which
> likely conflicts. Doing it the other way around isn't much better. The
> easiest
> way to use the OMAP3 ISP patches on top of Steve's tree is likely to
> hand-pick
> them. You can get a list of patches with git log, and use git cherry-pick
> to
> pick them manually.


With this layout, my understanding is that the 'proper' path for Steve's
branch to get updated with all media patches is only when the mainline
merged Mauro's branch and Steve pull them into his or rebase against it.
Right?

I saw Steve's repo staging a new "omap-v3.2".
http://www.sakoman.com/cgi-bin/gitweb.cgi?p=linux-omap-2.6.git;a=shortlog;h=refs/heads/omap-3.2

Wonder till what stage has Mauro's branch been merged into mainline. Is
there a way to determine a common baseline/point between both trees so that
I can hand-pick them into Steve's v3.2?

My understanding of git workflow is still at 'infant' stage. (^^)" and the
difficulty is learning how to 'pull, merge & resolves conflicts' from
different trees/branches. (^^)

Since I'm using Overo, I relies mainly on Steve's repo but I do know that TI
has a linux-omap tree at
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git which is
fairly updated & tracks the mainline closely.

Pardon my silly questions.

Regards,
James.
