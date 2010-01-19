Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab0ASLzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 06:55:12 -0500
Message-ID: <4B559D9B.1030700@infradead.org>
Date: Tue, 19 Jan 2010 09:55:07 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl> <201001190910.39479.pboettcher@kernellabs.com>
In-Reply-To: <201001190910.39479.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> On Tuesday 19 January 2010 08:53:10 Hans Verkuil wrote:
>> On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
>>> He already started doing that, fixing some incompatibility troubles
>>> between some drivers and older kernels.
>> Mauro, I just wanted to thank you for doing all the hard work in moving to
>>  git!
>>
>> And a big 'thank you' to Douglas as well for taking over hg maintenance!
> 
> A big thank you also from me. 

Wou're welcome.

> I'm strongly in need of a build-only-v4l-dvb build system. Because I'm most of 
> the time using distro-kernels in my productive environments and I'm replacing 
> v4l/dvb drivers with the one from v4l-dvb.

We all need to have some ways to run the new drivers on distro kernels. If not
as a developer, at least as an user. So, I keep believing that the out-of-tree
compilation is fundamental to the success of the subsystem.
> 
> One step into the direction of a solution might be:
> Why not including the v4l-dvb/v4l/Makefile and the related files into that 
> separate repository Hans is describing here and then telling 'make' to make 
> links to ../../v4l-dvb/ instead of ../linux as of today.

This is about what "make kernel-links" do, but in the opposite direction.
It shouldn't be hard do do that, but we need to fix the backports.
In the case of -alsa, they opted to use this strategy for their backported
tree, patching the kernel when building it.

> But I don't know how to solve the ifdef KERNEL_VERSION for having backward 
> compatibility in the source files. Maybe with a patch for each kernel version?

It can be a patch for each kernel version, but this will remove support for some
distro-kernels where the KABI has changed. Another solution is to have a pile
of patches that will be applied as the compilation breaks. This can work, but we
need to find a way to produce those patches.

Maybe the simplest solution is to keep maintaining the -hg and having an auto-generated
tree that will have just the building system and a diff between -git and -hg. If
both are synchronized, the only difference will be the backports.

> BTW: I just made a clone of the git-tree - 365MB *ouff*.

Yes, this is one problem with -git: as it contains the entire kernel struct, and an
history since 2.6.11, it is about 9 times bigger than the -hg tree, where only
the media files are stored.

Yet, git clone has a way to allow removing the history of the kernel, producing a 
small result --depth:

	$ git clone --depth 1 --bare v4l-dvb tmp

This gives about 128M (about 3x -hg). Yet, trees generated with --depth have some
disadvantages.


 Maybe it's worth to 
> mention right now, that one big difference to HG in the way we have used it, is 
> that one developer now can do all the work only with one clone of v4l-dvb and 
> using branches for each development.

Yes. The cost for a new branch is zero. Also, the cost of a new clone is less than
1M, if you use the --shared.

On my daily usage, I use a lot to clone with --shared, and doing my work on independent
directories. The advantage is that you avoid messing your temporary work. You may
even pull or push just one branch into another tree. So, working with git offers
lots of new possibilities to the developers.

Cheers,
Mauro.

> 
> best regards,

