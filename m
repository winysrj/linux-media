Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3611 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934035Ab0J2QGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 12:06:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
Date: Fri, 29 Oct 2010 18:05:32 +0200
Cc: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
References: <201010271905.o9RJ504u021145@smtp-vbr1.xs4all.nl> <4CC9BA90.2080805@hoogenraad.net> <4CC9C67C.8040102@redhat.com>
In-Reply-To: <4CC9C67C.8040102@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010291805.32363.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, October 28, 2010 20:52:44 Mauro Carvalho Chehab wrote:
> Hi Jan,
> 
> Em 28-10-2010 16:01, Jan Hoogenraad escreveu:
> > Douglas:
> > 
> > First of all thank you for the support you have done so far.
> > 
> > Hans:
> > 
> > Is it possible to build the tar from
> > http://git.linuxtv.org/mchehab/new_build.git
> > automatically each night, just like the way the hg archive was built ?
> > I don't have sufficient processing power to run that.

I haven't had time to look into new_build.git. It is on my todo list. I hope
to have some time next week.

> > Mauro:
> > 
> > I'm willing to give the mercurial conversion a shot.
> > I do not know a lot about v4l, but tend to be able to resolve this kind of release-type issues.
> > 
> > The way it seems to me is that first new_build.git should compile for all releases that the hg archive supported.
> 
> We still lack a maintainer for the new_build ;) I think we need to have someone
> with time looking on it, before flooding the ML's with breakage reports.
> I did the initial work: the tree is compiling, and I did a basic test with a few
> drivers on v2.6.32, but, unfortunately, I won't have time to maintain it.
> So, someone needs to head it. A few already talked to me about maintaining it
> it in priv, but didn't manifest yet publicly, because they're still analysing it.
> Also, so far, I received only one patch not made by me.
> 
> Currently, the new_build tree covers kernel versions from .32 to .36, but, if nobody 
> handles it, the backport patches will break with the time. Probably, some API will
> change on .37, requiring a new backport patch. In the meantime, someone may change 
> one of the backported lines, breaking those patches.
> 
> The good news is that there are just a few backport patches to maintain:
> 8 patches were enough for 2.6.32 (plus the v4l/compat.h logic).
> 
> It is up to the one that takes the maintainership to decide what will be the minimum
> supported version. 
> 
> IMHO, 2.6.32 is a good choice, as it has a long-maintained stable version and almost all 
> major distros are using it as basis for their newest version (and anyone 'crazy' enough 
> to use an experimental, pre -rc version, is likely using a brand new distribution ;) ).

I agree. I will kill the mercurial builds this weekend. After I have looked at new_build
I'll see if I can set up an automated build for it (or at least do some prototyping).
I'm not going to spend a lot of time on it as long as there is no maintainer. But
once a maintainer is announced, then I will finish the work on the daily build so
that it gets included every day.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
