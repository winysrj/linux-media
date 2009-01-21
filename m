Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:34705 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbZAUIyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 03:54:09 -0500
Date: Wed, 21 Jan 2009 00:54:07 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Confusion in usr/include/linux/videodev.h
In-Reply-To: <3f9a31f40901202044n73a100faj96a6f3d3973bcc25@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0901210048500.13170@shell2.speakeasy.net>
References: <1232502038.3123.61.camel@localhost.localdomain>
 <20090120235048.4f7200f9@caramujo.chehab.org>
 <3f9a31f40901202044n73a100faj96a6f3d3973bcc25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Jan 2009, Jaswinder Singh Rajput wrote:
> On Wed, Jan 21, 2009 at 7:20 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Wed, 21 Jan 2009 07:10:38 +0530
> > Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> >> usr/include/linux/videodev.h is giving 2 warnings in 'make headers_check':
> >>  usr/include/linux/videodev.h:19: leaks CONFIG_VIDEO to userspace where it is not valid
> >>  usr/include/linux/videodev.h:314: leaks CONFIG_VIDEO to userspace where it is not valid
> >>
> >> Whole file is covered with #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> >>
> >> It means this file is only valid for kernel mode if CONFIG_VIDEO_V4L1_COMPAT is defined but in user mode it is always valid.
> >
> > V4L1 is the old deprecated userspace API for video devices. It is still
> > required by some userspace applications. So, on userspace, it should be
> > included. Also, this allows that one userspace app to be compatible with both
> > V4L2 API (the current one) and the legacy V4L1 one.
> >
> > It should be noticed that are still a few drivers using the legacy API yet to
> > be converted.
> >
>
> If you have no objections then I will make a patchset which do followings:
> 1. Remove  #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined
> (__KERNEL__) from include/linux/videodev.h
> 2. cover all #include <linux/videodev.h> with #ifdef
> CONFIG_VIDEO_V4L1_COMPAT in kernel
>
> By this way, we can satisfy both kernel space and userspace issue and
> also get rid of above warnings.
>
> If you have better suggestion then let me know.

That sounds like it will add a mess of #if's.  How about this?

diff -r 29c5787efcda linux/include/linux/videodev.h
--- a/linux/include/linux/videodev.h    Thu Jan 15 09:07:03 2009 -0800
+++ b/linux/include/linux/videodev.h    Wed Jan 21 00:51:45 2009 -0800
@@ -15,7 +15,8 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>

-#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
+#if (defined(__KERNEL__) && defined(CONFIG_VIDEO_V4L1_COMPAT)) \
+    || !defined (__KERNEL__)

 #define VID_TYPE_CAPTURE       1       /* Can capture */
 #define VID_TYPE_TUNER         2       /* Can tune */

Now CONFIG_VIDEO_V4L1_COMPAT will only be used in the kernel.
