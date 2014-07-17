Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:24142 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaGQVna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 17:43:30 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8V00L21LOGCL30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Jul 2014 17:43:28 -0400 (EDT)
Date: Thu, 17 Jul 2014 18:43:24 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.17] A bunch of
Message-id: <20140717184324.31e1e20d.m.chehab@samsung.com>
In-reply-to: <53C784C4.2020904@xs4all.nl>
References: <53C784C4.2020904@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Jul 2014 10:09:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> These are all little fixes for issues I found while working on the vivi
> replacement +  some docbook fixes.
> 
> Usually all for fairly obscure corner cases, but that's what you write a
> test driver for, after all.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:
> 
>   [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git core-fixes
> 
> for you to fetch changes up to 2eb86fa0840ac281cc5ca0a63f1339fa00245c7d:
> 
>   v4l2-ioctl.c: check vfl_type in ENUM_FMT. (2014-07-14 14:55:47 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (12):
>       DocBook media: fix wrong spacing
>       DocBook media: add missing dqevent src_change field.
>       DocBook media: fix incorrect header reference
>       v4l2-ioctl: call g_selection before calling cropcap
>       v4l2-ioctl: clips, clipcount and bitmap should not be zeroed.

This one causes compilation breakages:

drivers/media/v4l2-core/v4l2-ioctl.c: In function 'v4l_enum_fmt':
drivers/media/v4l2-core/v4l2-ioctl.c:1115:30: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   struct v4l2_clip *clips = p->fmt.win.clips;
                              ^
drivers/media/v4l2-core/v4l2-ioctl.c:1116:20: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   u32 clipcount = p->fmt.win.clipcount;
                    ^
drivers/media/v4l2-core/v4l2-ioctl.c:1117:19: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   void *bitmap = p->fmt.win.bitmap;
                   ^
In file included from ./arch/x86/include/asm/string.h:2:0,
                 from include/linux/string.h:17,
                 from ./arch/x86/include/asm/page_32.h:34,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from include/linux/thread_info.h:54,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/media/v4l2-core/v4l2-ioctl.c:15:
drivers/media/v4l2-core/v4l2-ioctl.c:1119:12: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   memset(&p->fmt, 0, sizeof(p->fmt));
            ^
./arch/x86/include/asm/string_32.h:325:46: note: in definition of macro 'memset'
 #define memset(s, c, count) __builtin_memset(s, c, count)
                                              ^
drivers/media/v4l2-core/v4l2-ioctl.c:1119:30: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   memset(&p->fmt, 0, sizeof(p->fmt));
                              ^
./arch/x86/include/asm/string_32.h:325:52: note: in definition of macro 'memset'
 #define memset(s, c, count) __builtin_memset(s, c, count)
                                                    ^
drivers/media/v4l2-core/v4l2-ioctl.c:1120:4: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   p->fmt.win.clips = clips;
    ^
drivers/media/v4l2-core/v4l2-ioctl.c:1121:4: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   p->fmt.win.clipcount = clipcount;
    ^
drivers/media/v4l2-core/v4l2-ioctl.c:1122:4: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   p->fmt.win.bitmap = bitmap;
    ^
In file included from ./arch/x86/include/asm/string.h:2:0,
                 from include/linux/string.h:17,
                 from ./arch/x86/include/asm/page_32.h:34,
                 from ./arch/x86/include/asm/page.h:13,
                 from ./arch/x86/include/asm/thread_info.h:11,
                 from include/linux/thread_info.h:54,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/media/v4l2-core/v4l2-ioctl.c:15:
drivers/media/v4l2-core/v4l2-ioctl.c:1126:12: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   memset(&p->fmt, 0, sizeof(p->fmt));
            ^
./arch/x86/include/asm/string_32.h:325:46: note: in definition of macro 'memset'
 #define memset(s, c, count) __builtin_memset(s, c, count)
                                              ^
drivers/media/v4l2-core/v4l2-ioctl.c:1126:30: error: 'struct v4l2_fmtdesc' has no member named 'fmt'
   memset(&p->fmt, 0, sizeof(p->fmt));
                              ^
./arch/x86/include/asm/string_32.h:325:52: note: in definition of macro 'memset'
 #define memset(s, c, count) __builtin_memset(s, c, count)
                                                    ^
make[2]: *** [drivers/media/v4l2-core/v4l2-ioctl.o] Error 1
make[1]: *** [drivers/media/v4l2-core] Error 2
make: *** [_module_drivers/media] Error 2

Dropped it and applied the remaining patches.

Regards,
Mauro
