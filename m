Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2LVXlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 18:41:23 -0500
Date: Sat, 22 Dec 2012 21:40:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Message-ID: <20121222214059.66571fcc@redhat.com>
In-Reply-To: <20121222204617.56D2911E00C2@alastor.dyndns.org>
References: <20121222204617.56D2911E00C2@alastor.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Dec 2012 21:46:17 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.
> 
> Results of the daily build of media_tree:
> 
> date:        Sat Dec 22 19:00:28 CET 2012
> git hash:    0dae88392395e228e67436cd08f084d395b39df5
> gcc version:      i686-linux-gcc (GCC) 4.7.1
> host hardware:    x86_64
> host os:          3.4.07-marune
> 
> linux-git-arm-eabi-davinci: ERRORS
> linux-git-arm-eabi-exynos: ERRORS
> linux-git-arm-eabi-omap: ERRORS
> linux-git-i686: OK
> linux-git-m32r: OK
> linux-git-mips: OK
> linux-git-powerpc64: OK
> linux-git-sh: ERRORS
> linux-git-x86_64: OK
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: WARNINGS
> linux-2.6.33-i686: WARNINGS
> linux-2.6.34-i686: WARNINGS
> linux-2.6.35.3-i686: WARNINGS
> linux-2.6.36-i686: WARNINGS
> linux-2.6.37-i686: WARNINGS
> linux-2.6.38.2-i686: WARNINGS
> linux-2.6.39.1-i686: WARNINGS
> linux-3.0-i686: WARNINGS
> linux-3.1-i686: WARNINGS
> linux-3.2.1-i686: WARNINGS
> linux-3.3-i686: WARNINGS
> linux-3.4-i686: WARNINGS
> linux-3.5-i686: WARNINGS
> linux-3.6-i686: WARNINGS
> linux-3.7-i686: ERRORS
> linux-3.8-rc1-i686: ERRORS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35.3-x86_64: WARNINGS
> linux-2.6.36-x86_64: WARNINGS
> linux-2.6.37-x86_64: WARNINGS
> linux-2.6.38.2-x86_64: WARNINGS
> linux-2.6.39.1-x86_64: WARNINGS
> linux-3.0-x86_64: WARNINGS
> linux-3.1-x86_64: WARNINGS
> linux-3.2.1-x86_64: WARNINGS
> linux-3.3-x86_64: WARNINGS
> linux-3.4-x86_64: WARNINGS
> linux-3.5-x86_64: WARNINGS
> linux-3.6-x86_64: WARNINGS
> linux-3.7-x86_64: ERRORS
> linux-3.8-rc1-x86_64: ERRORS
> apps: WARNINGS
> spec-git: OK
> sparse: ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Saturday.log

linux-3.7-x86_64: ERRORS

In file included from include/linux/usb/ch9.h:35:0,
                 from include/linux/usb.h:5,
                 from /home/hans/work/build/media_build/v4l/au0828.h:22,
                 from /home/hans/work/build/media_build/v4l/au0828-i2c.c:28:
include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
In file included from include/linux/usb/ch9.h:35:0,
                 from include/linux/usb.h:5,
                 from /home/hans/work/build/media_build/v4l/au0828.h:22,
                 from /home/hans/work/build/media_build/v4l/au0828-core.c:28:
include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
make[3]: *** [/home/hans/work/build/media_build/v4l/au0828-core.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: *** [/home/hans/work/build/media_build/v4l/au0828-i2c.o] Error 1
In file included from include/linux/usb/ch9.h:35:0,
                 from include/linux/usb.h:5,
                 from /home/hans/work/build/media_build/v4l/au0828.h:22,
                 from /home/hans/work/build/media_build/v4l/au0828-cards.c:22:
include/uapi/linux/usb/ch9.h:597:19: error: expected declaration specifiers or '...' before '(' token
make[3]: *** [/home/hans/work/build/media_build/v4l/au0828-cards.o] Error 1
make[2]: *** [_module_/home/hans/work/build/media_build/v4l] Error 2
make[2]: Leaving directory `/home/hans/work/build/trees/x86_64/linux-3.7'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/hans/work/build/media_build/v4l'
make: *** [all] Error 2
Sat Dec 22 21:41:06 CET 2012

It seems that it is still using an older version of the media-build.git tree.

-- 

Cheers,
Mauro
