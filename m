Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:40230 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbZBKBUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 20:20:54 -0500
Date: Tue, 10 Feb 2009 17:20:52 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org
Subject: Re: cx8802.ko module not being built with current HG tree
In-Reply-To: <20090210221710.389c264e@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0902101633090.24268@shell2.speakeasy.net>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
 <200902102132.00114.hverkuil@xs4all.nl> <20090210184147.61d4655e@pedra.chehab.org>
 <200902102221.40067.hverkuil@xs4all.nl> <20090210221710.389c264e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009, Mauro Carvalho Chehab wrote:
> > I did some more testing and the bug disappears in kernel 2.6.25. Also, if I
> > just run 'make', then the .config file it produces is fine. I wonder if it
> > isn't a bug in menuconfig itself.
>
> It seems to be a bug at the Kbuild, fixed on Feb, 2008, on this changeset:
> commit 587c90616a5b44e6ccfac38e64d4fecee51d588c (attached).
>
> As explained, after the patch description, the value for the Kconfig var, after
> the patch, uses this formula:
>
>     	(value && dependency) || select

It's odd that the patch is for "fix select in combination with default",
yet there is no select used for CX88_DVB.  I think what you've done with
CX88_MPEG is something that nothing else in has used before, which made use
of the behavior introduced by this patch in a new way.

> And there there's no select, the value of CONFIG_CX88_MPEG is determined by:
> 	('y' && dependency)
>
> The most complex case is when we have CX88 defined as:
> 	CX88 = 'y'
>
> if both CX88_DVB and CX88_BLACKBIRD are defined as 'm' (or one of them is 'n'
> and the other is 'm'), then CX88_MPEG is defined as:
> 	CX88_MPEG = 'm'
>
> If one of CX88_DVB or CX88_BLACKBIRD is defined as 'y'; then we have:
> 	CX88_MPEG = 'y'
>
> If both are 'n', we have:
> 	CX88_MPEG = 'n'
>
> So, it seems that, after commit 587c90616a5b44e6ccfac38e64d4fecee51d588c,
> everything is working as expected. We just need to provide a hack at the
> out-of-tree build system for kernels that don't have this commit applied.

I still think using select is better.  What Roman Zippel was talking about
was the mess with select and the tuner drivers.  I agree that's a mess and
there are better ways to do it without using select.  But the MPEG module
is like a library used by just DVB and BLACKBIRD.  It seems like the ideal
case for using select.
