Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1691 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0ASHv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 02:51:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Tue, 19 Jan 2010 08:53:10 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org>
In-Reply-To: <4B55445A.10300@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001190853.11050.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
> Hi,
> 
> Today, a step to the future was given, in order to help developers to better
> do their work: the addition of -git support at linuxtv.org server.
> 
> This is one idea that is being recurrent along the last years: to start using -git
> as our primary resource for managing the patches at the development[1].
> 
> At the beginning, the usage CVS for of a SCM (Source Code Management) were
> choosen on V4L/DVB. Both of the original V4L and DVB trees were developed with the 
> help of cvs. On that time, upstream Linux kernel used to have another tree (BitKeeper).
> 
> In 2005, both V4L and DVB trees got merged into one cvs repository, and we've
> discussed about what would be the better SCM solution. We've discussed more
> about using svn, hg and git. On that time, both hg and git were new technologies,
> based on the concept of a distributed SCM, where you don't need to go to the
> server every time you're doing a command at the SCM.
> 
> Yet, Mercurial were more stable and used, while -git were giving his first
> steps[2], being used almost only by the Linux Kernel, and several distros didn't use
> to package it. Git objects were stored uncompressed, generating very large
> trees. Also, -git tools were complex to use, and some "porcelain" packages were
> needed, in order to be used by a normal user.
> 
> So, the decision was made to use mercurial. However, as time goes by, -git got much
> more eyes than any other SCM, having all their weakness solved, and being developed
> really fast. Also, it got adopted by several other projects, due to its capability 
> and its number of features.
> 
> Technically speaking, -git is currently the most advanced distributed open-source
> SCM application I know.
> 
> Yet, Mercurial has been doing a very good job maintaining the V4L/DVB trees, and, except
> for a few points, it does the job.
> 
> However, the entire Linux Kernel development happens around -git. Even the ones that
> were adopting other tools (like -alsa, that used to have also Mercurial repositories)
> migrated to -git.
> 
> Despite all technical advantages, the rationale for the migration is quite simple: 
> converting patches between different repositories and SCM tools cause development 
> and merge delays, may cause patch mangling and eats lot of the time for people 
> that are part of the process.
> 
> Also, every time a patch needs to touch on files outside the incomplete tree
> used at the subsystem, an workaround need to be done, in order to avoid troubles 
> and to be able to send the patch upstream.
> 
> So, it is simpler to just use -git.
> 
> Due to all the above reasons, I took some time to add -git support at linuxtv servers.
> Both http and git methods to retrieve trees were enabled.
> 
> The new trees will be available at:
> 	http://linuxtv.org/git/
> 
> The merge tree, where all submitted patches will be merged, before sending upstream is:
> 	http://linuxtv.org/git?p=v4l-dvb.git;a=summary
> 
> This tree is basically a clone of Linus tree, so it runs the latest development kernel.
> It is also (almost) in sync with our -hg tree (needing just a few adjustments).
> 
> The above tree will never be rebased, so it should be safe to use it for development.
> 
> I'll basically merge there all patches I receive. It is OK to submit patches against -hg,
> since I can still run my old conversion stripts to convert them to -git. However, as
> the conversion script is not fast (it takes between 15-30 secs to convert a single patch
> to -git, since it needs to re-generate the entire tree with v4l/scripts/gentree.pl, for
> ever patch), I kindly ask you to prefer submit me patches directly to -git.
> 
> With respect to the -hg tree with the out-of-tree building system, We really want to 
> keep having a way to allow running the drivers with kernels other than the latest -rc 
> one, for both development and testing.
> 
> As you all know, the number of drivers and the average number of merges per day is being
> increasing, among with more complexity on some drivers that also touches arch and other
> files outside drivers/media tree. Due to that, lots of my current time is devoted to keep
> -hg and -git in sync, distracting me from my develoment and maintanership tasks to do it.
> So, I simply don't have more time to keep maintaining both -hg and -git.
> 
> Due to that, I'm delegating the task of keeping -hg in sync with upstream and backporting
> patches to run on older kernels to another person: Douglas has offered his help to keep 
> the tree synchronized with the -git tree, and to add backport support. 
> 
> He already started doing that, fixing some incompatibility troubles between some drivers
> and older kernels.

Mauro, I just wanted to thank you for doing all the hard work in moving to git!

And a big 'thank you' to Douglas as well for taking over hg maintenance!

I do have one proposal: parts of our hg tree are independent of git: v4l2-apps,
possibly some firmware build code (not 100% sure of that), v4l_experimental,
perhaps some documentation stuff. My proposal is that we make a separate hg
or git tree for those. It will make it easier to package by distros and it makes it
easier to maintain v4l2-apps et al as well. It might even simplify Douglas's work
by moving non-essential code out of the compat hg tree.

I'll be updating my daily build scripts to start using git soon (I'll keep using
hg for the older kernels of course).

> In terms of the out-of-tree building system evolution (e. g. the building system concept
> behind the -hg tree), If people think it is worthy enough, maybe later this could also 
> be converted also to -git, but preserving the building system and the backport patches. 
> Another alternative would be to split the building systems and the backport patches, 
> and apply them into the drivers/media files. Alsa subsystem does something like that. 
> It may also be maintained as-is. So, suggestions are welcome about if and how can we improve 
> the out-of-tree building.
> 
> Some details about the -git repositories still need to be defined, and I'll be sending
> the instructions on how to use the repository management tools available at linuxtv site
> to the developers, but the basic infrastructure is already there.
> 
> We also need to do more tests with the -git support, in order to be sure that it will
> work as expected, and that it won't be eating much bandwidth or disk space.
> 
> In particular, for those who want to test the git, please clone first from kernel.org, and
> then add a remote branch pointing to linuxtv.org. This helps to save our bandwidth.
> 
> The instructions on how to do it are in the top of the git page (http://linuxtv.org/git).

Regards,

	Hans

> 
> Thanks!
> Mauro
> 
> ---
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg12676.html
> [2] http://en.wikipedia.org/wiki/Git_(software)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
