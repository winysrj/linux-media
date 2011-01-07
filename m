Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:38454 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751779Ab1AGX45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 18:56:57 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Debug code in HG repositories
Date: Sat, 8 Jan 2011 00:56:40 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl>
In-Reply-To: <201101072206.30323.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101080056.40803@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 07 January 2011 22:06:30 Hans Verkuil wrote:
> On Friday, January 07, 2011 21:13:31 Devin Heitmueller wrote:
> > On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> > > Hi guys,
> > >
> > > are you aware that there is a lot of '#if 0' code in the HG repositories
> > > which is not in GIT?
> > >
> > > When drivers were submitted to the kernel from HG, the '#if 0' stuff was
> > > stripped, unless it was marked as 'keep'...
> > >
> > > This was fine, when development was done with HG.
> > >
> > > As GIT is being used now, that code will be lost, as soon as the HG
> > > repositories have been removed...
> > >
> > > Any opinions how this should be handled?
> > >
> > > CU
> > > Oliver
> > 
> > I complained about this months ago.  The problem is that when we were
> > using HG, the HG repo was a complete superset of what went into Git
> > (including development/debug code).  But now that we use Git, neither
> > is a superset of the other.
> > 
> > If you base your changes on Git, you have to add back in all the
> > portability code (and any "#if 0" you added as the maintainer for
> > development/debugging).  Oh, and regular users cannot test any of your
> > changes because they aren't willing to upgrade their entire kernel.
> > 
> > If you base your changes on Hg, nothing merges cleanly when submitted
> > upstream so your patches get rejected.
> > 
> > Want to know why we are seeing regressions all over the place?
> > Because *NOBODY* is testing the code until after the kernel goes
> > stable (since while many are willing to install a v4l-dvb tree, very
> > few will are willing to upgrade their entire kernel just to test one
> > driver).  We've probably lost about 98% of our user base of testers.
> 
> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
> promote this more. I could add backwards compatibility builds to my daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.
> 
> > Oh, and users have to git clone 500M+ of data, and not everybody in
> > the world has bandwidth fast enough to make that worth their time (it
> > took me several hours last time I did it).
> 
> Currently the media_build tree copies the drivers from a git tree. Which, as
> you say, can be a big problem for non-developers. But all it really needs are
> the media drivers. So perhaps it might be a good idea to make a daily snapshot
> of the drivers and make it available for download on linuxtv.org. That archive
> is only 3.5 MB, so much easier to download.
> 
> > Anyway, I've beaten this horse to death and it's fallen on deaf ears.
> > Merge overhead has reached the point where it's just not worth my
> > time/effort to submit anything upstream anymore.
> 
> The hg tree is dead. Douglas Landgraf tried to maintain it, but it's just too
> much work. Any attempt to work from the hg tree is doomed. The media_build
> seems to be a viable alternative. As a developer you still have to go through
> the painful process of cloning the git repo, but it is a one time thing. Once
> it's cloned then you only have to follow the new commits, which is much, much
> faster.
> 
> And regarding regressions: I'm amazed how few regressions we have considering
> the furious rate of development. The media subsystem is still one of the most
> active subsystems in the kernel and probably will remain so for the forseeable
> future as well.

Regressions can be detected only if you have enough testers!

With the current situation, it is very likely that regressions will not
show up before major linux distributions switch to a new kernel.
Afaics the user base is neglectible at the moment. So you can expect
that regressions will show up months after release of a new kernel.

Anyway, this is off-topic. I was not talking about regressions.

> It would be a shame not to submit patches upstream, that never ends well in
> the long run.
> 
> With respect to '#if 0': for the most part I'd say: good riddance. In my
> many years of experience as a SW engineer I have never seen anyone actually
> turn on '#if 0' code once it's been in the code for more than, say, a year.
> Usually people just leave it there because they are too lazy to remove it,
> or they don't understand what it is for and are too scared to remove it.
> 
> If it is code partially implementing a feature that needs more work, then
> it may sound like a good idea to keep it. However, after it's in the code for
> more than a year, then nobody remembers what the code was about and what still
> had to be done to make it work. And it's hell to figure that out after such a
> long time. Never put such code in the mainline. Keep it in a branch if you
> have to.
> 
> Anyway, if there is some '#if 0' code that you want to preserve in git, then
> you have to make a patch to add it. But you probably will have to have very
> good reasons for adding '#if 0' code to the mainline.

I do not care about some #ifdef'ed printk statements.

There are large pieces of driver code which are currently unused, and
nobody can tell whether they will ever be needed.

On the other hand a developer spent days writing this stuff, and now it
does not exist anymore - without any trace!

The problem is not, that it is missing in the current snapshot, but
that it has never been in the git repository, and there is no way to
recover it.

Afaics, the only way to preserve this kind of code is 'out-of-tree'.
It is a shame... :-(

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
