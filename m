Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4792 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVKix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 05:38:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: cron job: media_tree daily build: ERRORS
Date: Sat, 22 Dec 2012 11:38:44 +0100
Cc: linux-media@vger.kernel.org
References: <20121221204707.04F1D11E00C2@alastor.dyndns.org> <20121221192714.5e31fd99@redhat.com>
In-Reply-To: <20121221192714.5e31fd99@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212221138.44104.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri December 21 2012 22:27:14 Mauro Carvalho Chehab wrote:
> Em Fri, 21 Dec 2012 21:47:06 +0100 (CET)
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
> > This message is generated daily by a cron job that builds media_tree for
> > the kernels and architectures in the list below.
> > 
> > Results of the daily build of media_tree:
> > 
> > date:        Fri Dec 21 19:00:24 CET 2012
> > git hash:    49cc629df16f2a15917800a8579bd9c25c41b634
> > gcc version:      i686-linux-gcc (GCC) 4.7.1
> > host hardware:    x86_64
> > host os:          3.4.07-marune
> > 
> > linux-git-arm-eabi-davinci: WARNINGS
> > linux-git-arm-eabi-exynos: OK
> > linux-git-arm-eabi-omap: WARNINGS
> > linux-git-i686: WARNINGS
> > linux-git-m32r: OK
> > linux-git-mips: WARNINGS
> > linux-git-powerpc64: OK
> > linux-git-sh: OK
> > linux-git-x86_64: WARNINGS
> > linux-2.6.31.12-i686: WARNINGS
> > linux-2.6.32.6-i686: WARNINGS
> > linux-2.6.33-i686: WARNINGS
> > linux-2.6.34-i686: WARNINGS
> > linux-2.6.35.3-i686: WARNINGS
> > linux-2.6.36-i686: WARNINGS
> > linux-2.6.37-i686: WARNINGS
> > linux-2.6.38.2-i686: WARNINGS
> > linux-2.6.39.1-i686: WARNINGS
> > linux-3.0-i686: WARNINGS
> > linux-3.1-i686: WARNINGS
> > linux-3.2.1-i686: WARNINGS
> > linux-3.3-i686: WARNINGS
> > linux-3.4-i686: WARNINGS
> > linux-3.5-i686: WARNINGS
> > linux-3.6-i686: WARNINGS
> > linux-3.7-i686: ERRORS
> > linux-2.6.31.12-x86_64: WARNINGS
> > linux-2.6.32.6-x86_64: WARNINGS
> > linux-2.6.33-x86_64: WARNINGS
> > linux-2.6.34-x86_64: WARNINGS
> > linux-2.6.35.3-x86_64: WARNINGS
> > linux-2.6.36-x86_64: WARNINGS
> > linux-2.6.37-x86_64: WARNINGS
> > linux-2.6.38.2-x86_64: WARNINGS
> > linux-2.6.39.1-x86_64: WARNINGS
> > linux-3.0-x86_64: WARNINGS
> > linux-3.1-x86_64: WARNINGS
> > linux-3.2.1-x86_64: WARNINGS
> > linux-3.3-x86_64: WARNINGS
> > linux-3.4-x86_64: WARNINGS
> > linux-3.5-x86_64: WARNINGS
> > linux-3.6-x86_64: WARNINGS
> > linux-3.7-x86_64: ERRORS
> > apps: WARNINGS
> > spec-git: WARNINGS
> > sparse: ERRORS
> > 
> > Detailed results are available here:
> > 
> > http://www.xs4all.nl/~hverkuil/logs/Friday.log
> 
> That can't be right!
> 
> Patch for it was applied earlier today:
> 	linux-3.6-x86_64: WARNINGS
> 
> 	/home/hans/work/build/media_build/v4l/tm6000-video.c: In function '__check_keep_urb':
> 	/home/hans/work/build/media_build/v4l/tm6000-video.c:1926:1: warning: return from incompatible pointer type [enabled by default]
> 
> Are you using the yesterday's tarball? If so, understandable.
> 
> But this one:
> 	linux-3.7-x86_64: ERRORS
> 
> 	In file included from include/linux/usb/ch9.h:35:0,
> 	                 from include/linux/usb.h:5,
> 	                 from /home/hans/work/build/media_build/v4l/au0828.h:22,
> 	                 from /home/hans/work/build/media_build/v4l/au0828-i2c.c:28:
> 	include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
> 	In file included from include/linux/usb/ch9.h:35:0,
> 	                 from include/linux/usb.h:5,
> 	                 from /home/hans/work/build/media_build/v4l/au0828.h:22,
> 	                 from /home/hans/work/build/media_build/v4l/au0828-core.c:28:
> 	include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
> 	In file included from include/linux/usb/ch9.h:35:0,
>                 	 from include/linux/usb.h:5,
>         	         from /home/hans/work/build/media_build/v4l/au0828.h:22,
>                 	 from /home/hans/work/build/media_build/v4l/au0828-cards.c:22:
> 	include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
> 
> Is really really weird, as a fix for it was merged 27 hours ago:
> 	http://git.linuxtv.org/media_build.git/commit/5a86bdd242d2489ad253c29df05663c8eda9eb9c
> 
> Could you please check what's going wrong?

The daily build was still using the for_v3.8 branch. I've switched to the new
branch so it should be good next time the build is run.

Regards,

	Hans
