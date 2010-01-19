Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55563 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab0ASIKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 03:10:45 -0500
Received: by ewy19 with SMTP id 19so1432430ewy.21
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 00:10:43 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Tue, 19 Jan 2010 09:10:39 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org> <201001190853.11050.hverkuil@xs4all.nl>
In-Reply-To: <201001190853.11050.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001190910.39479.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 January 2010 08:53:10 Hans Verkuil wrote:
> On Tuesday 19 January 2010 06:34:18 Mauro Carvalho Chehab wrote:
> >
> > He already started doing that, fixing some incompatibility troubles
> > between some drivers and older kernels.
> 
> Mauro, I just wanted to thank you for doing all the hard work in moving to
>  git!
> 
> And a big 'thank you' to Douglas as well for taking over hg maintenance!

A big thank you also from me. 

This is really outstanding work you're doing there and it's highly 
appreciated.


> I do have one proposal: parts of our hg tree are independent of git:
>  v4l2-apps, possibly some firmware build code (not 100% sure of that),
>  v4l_experimental, perhaps some documentation stuff. My proposal is that we
>  make a separate hg or git tree for those. It will make it easier to
>  package by distros and it makes it easier to maintain v4l2-apps et al as
>  well. It might even simplify Douglas's work by moving non-essential code
>  out of the compat hg tree.
> 
> > In terms of the out-of-tree building system evolution (e. g. the building
> > system concept behind the -hg tree), If people think it is worthy enough,
> > maybe later this could also be converted also to -git, but preserving the
> > building system and the backport patches. Another alternative would be to
> > split the building systems and the backport patches, and apply them into
> > the drivers/media files.

I'm strongly in need of a build-only-v4l-dvb build system. Because I'm most of 
the time using distro-kernels in my productive environments and I'm replacing 
v4l/dvb drivers with the one from v4l-dvb.

One step into the direction of a solution might be:
Why not including the v4l-dvb/v4l/Makefile and the related files into that 
separate repository Hans is describing here and then telling 'make' to make 
links to ../../v4l-dvb/ instead of ../linux as of today.

But I don't know how to solve the ifdef KERNEL_VERSION for having backward 
compatibility in the source files. Maybe with a patch for each kernel version?

BTW: I just made a clone of the git-tree - 365MB *ouff*. Maybe it's worth to 
mention right now, that one big difference to HG in the way we have used it, is 
that one developer now can do all the work only with one clone of v4l-dvb and 
using branches for each development.

best regards,
-- 
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
