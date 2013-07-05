Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3543 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab3GEJw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jul 2013 05:52:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: Re: cron job: media_tree daily build: WARNINGS
Date: Fri, 5 Jul 2013 11:52:32 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20130704182937.9B56D35E010B@alastor.dyndns.org> <51D67F78.3010702@gtsys.com.hk>
In-Reply-To: <51D67F78.3010702@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051152.32504.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 5 2013 10:10:32 Chris Ruehl wrote:
> Hans,
> 
> I like to work with the linux-git-arm-mx but cannot find any repository. 
> Can you give me a hint?

I'm just cross-compiling the kernel from the media_tree.git repository,
nothing else. You probably want a complete rootfs as well to work with.
Guennadi may know where to find something like that.

But if you indeed just want to cross-compile the kernel, then let me know
and I can give you pointers.

	Hans

> 
> Thanks.
> Chris
> 
> On Friday, July 05, 2013 02:29 AM, Hans Verkuil wrote:
> > This message is generated daily by a cron job that builds media_tree for
> > the kernels and architectures in the list below.
> >
> > Results of the daily build of media_tree:
> >
> > date:		Thu Jul  4 19:00:26 CEST 2013
> > git branch:	test
> > git hash:	1c26190a8d492adadac4711fe5762d46204b18b0
> > gcc version:	i686-linux-gcc (GCC) 4.8.1
> > sparse version:	v0.4.5-rc1
> > host hardware:	x86_64
> > host os:	3.9-7.slh.1-amd64
> >
> > linux-git-arm-at91: OK
> > linux-git-arm-davinci: OK
> > linux-git-arm-exynos: OK
> > linux-git-arm-mx: OK
> > linux-git-arm-omap: OK
> > linux-git-arm-omap1: OK
> > linux-git-arm-pxa: OK
> > linux-git-blackfin: OK
> > linux-git-i686: OK
> > linux-git-m32r: OK
> > linux-git-mips: OK
> > linux-git-powerpc64: OK
> > linux-git-sh: OK
> > linux-git-x86_64: OK
> > linux-2.6.31.14-i686: WARNINGS
> > linux-2.6.32.27-i686: WARNINGS
> > linux-2.6.33.7-i686: WARNINGS
> > linux-2.6.34.7-i686: WARNINGS
> > linux-2.6.35.9-i686: WARNINGS
> > linux-2.6.36.4-i686: WARNINGS
> > linux-2.6.37.6-i686: WARNINGS
> > linux-2.6.38.8-i686: WARNINGS
> > linux-2.6.39.4-i686: WARNINGS
> > linux-3.0.60-i686: OK
> > linux-3.10-i686: OK
> > linux-3.1.10-i686: OK
> > linux-3.2.37-i686: OK
> > linux-3.3.8-i686: OK
> > linux-3.4.27-i686: WARNINGS
> > linux-3.5.7-i686: WARNINGS
> > linux-3.6.11-i686: WARNINGS
> > linux-3.7.4-i686: WARNINGS
> > linux-3.8-i686: WARNINGS
> > linux-3.9.2-i686: WARNINGS
> > linux-2.6.31.14-x86_64: WARNINGS
> > linux-2.6.32.27-x86_64: WARNINGS
> > linux-2.6.33.7-x86_64: WARNINGS
> > linux-2.6.34.7-x86_64: WARNINGS
> > linux-2.6.35.9-x86_64: WARNINGS
> > linux-2.6.36.4-x86_64: WARNINGS
> > linux-2.6.37.6-x86_64: WARNINGS
> > linux-2.6.38.8-x86_64: WARNINGS
> > linux-2.6.39.4-x86_64: WARNINGS
> > linux-3.0.60-x86_64: OK
> > linux-3.10-x86_64: OK
> > linux-3.1.10-x86_64: OK
> > linux-3.2.37-x86_64: OK
> > linux-3.3.8-x86_64: OK
> > linux-3.4.27-x86_64: WARNINGS
> > linux-3.5.7-x86_64: WARNINGS
> > linux-3.6.11-x86_64: WARNINGS
> > linux-3.7.4-x86_64: WARNINGS
> > linux-3.8-x86_64: WARNINGS
> > linux-3.9.2-x86_64: WARNINGS
> > apps: WARNINGS
> > spec-git: OK
> > sparse version:	v0.4.5-rc1
> > sparse: ERRORS
> >
> > Detailed results are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> >
> > Full logs are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2
> >
> > The Media Infrastructure API from this daily build is here:
> >
> > http://www.xs4all.nl/~hverkuil/spec/media.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
