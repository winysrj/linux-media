Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:48315 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0HJMal (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 08:30:41 -0400
Subject: Re: [PATCH v7 1/5] V4L2: Add seek spacing and FM RX class.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <4C614294.7080101@redhat.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <201008091838.13247.hverkuil@xs4all.nl>
	 <1281425501.14489.7.camel@masi.mnp.nokia.com>
	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>
	 <1281441830.14489.27.camel@masi.mnp.nokia.com>
	 <4C614294.7080101@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 15:30:06 +0300
Message-ID: <1281443406.14489.35.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 2010-08-10 at 14:14 +0200, ext Mauro Carvalho Chehab wrote:
> Em 10-08-2010 09:03, Matti J. Aaltonen escreveu:
> > On Tue, 2010-08-10 at 10:04 +0200, ext Hans Verkuil wrote:
> >>> On Mon, 2010-08-09 at 18:38 +0200, ext Hans Verkuil wrote:
> >>>> On Monday 02 August 2010 16:06:39 Matti J. Aaltonen wrote:
> >>>>> Add spacing field to v4l2_hw_freq_seek and also add FM RX class to
> >>>>> control classes.
> >>>>
> >>>> This will no longer apply now that the control framework has been
> >>>> merged.
> >>>>
> >>>> I strongly recommend converting the driver to use that framework. If
> >>>> nothing else, you get support for the g/s/try_ext_ctrls ioctls for free.
> >>>>
> >>>> See the file Documentation/video4linux/v4l2-controls.txt.
> >>>
> >>> I can't find that file.  Should it be in some branch of the development
> >>> tree?
> >>
> >> It's in the new development tree, branch staging/v2.6.36:
> >>
> >> http://git.linuxtv.org/media_tree.git
> >>
> >> This replaced the v4l-dvb.git tree.
> >>
> >> Regards,
> > 
> > This mainly FYI:
> > 
> > I can read the v4l2-controls.txt file through your git web system... but
> > after cloning etc. I can't see it...
> 
> You're probably at the wrong branch. you'll need to do something like:
> 	$ git checkout -b my_working_branch remotes/staging/v2.6.36
> 
> in order to create a new branch based on it.

Referring to a remote branch like that is new to me, also it doesn't
work:

git branch -a
  master
* v2636
  origin/HEAD
  origin/master
  origin/staging/v2.6.35
  origin/staging/v2.6.36
  origin/staging/v2.6.37

git checkout -b my_working_branch remotes/staging/v2.6.36
fatal: git checkout: updating paths is incompatible with switching
branches.
Did you intend to checkout 'remotes/staging/v2.6.36' which can not be
resolved as commit?

more .git/config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = http://linuxtv.org/git/media_tree.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master
[branch "v2636"]
        remote = origin
        merge = refs/heads/staging/v2.6.36


git --version
git version 1.6.1.3


> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


