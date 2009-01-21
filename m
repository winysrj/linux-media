Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:59794 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZAUJvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 04:51:14 -0500
Date: Wed, 21 Jan 2009 01:51:10 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Confusion in usr/include/linux/videodev.h
In-Reply-To: <200901211009.14856.arnd@arndb.de>
Message-ID: <Pine.LNX.4.58.0901210129350.13170@shell2.speakeasy.net>
References: <1232502038.3123.61.camel@localhost.localdomain>
 <Pine.LNX.4.58.0901210048500.13170@shell2.speakeasy.net>
 <3f9a31f40901210059g51d46f56t85364d886b757a6e@mail.gmail.com>
 <200901211009.14856.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Jan 2009, Arnd Bergmann wrote:
> On Wednesday 21 January 2009, Jaswinder Singh Rajput wrote:
> > > diff -r 29c5787efcda linux/include/linux/videodev.h
> > > --- a/linux/include/linux/videodev.h    Thu Jan 15 09:07:03 2009 -0800
> > > +++ b/linux/include/linux/videodev.h    Wed Jan 21 00:51:45 2009 -0800
> > > @@ -15,7 +15,8 @@
> > >  #include <linux/ioctl.h>
> > >  #include <linux/videodev2.h>
> > >
> > > -#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> > > +#if (defined(__KERNEL__) && defined(CONFIG_VIDEO_V4L1_COMPAT)) \
> > > +    || !defined (__KERNEL__)
> > >
> > >  #define VID_TYPE_CAPTURE       1       /* Can capture */
> > >  #define VID_TYPE_TUNER         2       /* Can tune */
> > >
> > > Now CONFIG_VIDEO_V4L1_COMPAT will only be used in the kernel.
> > >
> >
> > No, this will still give warnings.
>
> You could #define another conditional, like this:
>
> #ifndef __KERNEL__
> # define __V4L1_COMPAT_API /* Always provide definitions to user space */
> #else /* __KERNEL__ */
> # ifdef CONFIG_VIDEO_V4L1_COMPAT
> #  define __V4L1_COMPAT_API
> # endif /* CONFIG_VIDEO_V4L1_COMPAT /*
> #endif /* __KERNEL__ */

I see what the real problem is now, the unifdef program isn't smart enough
to realize that it knows the result of !defined(__KERNEL__) || defined(FOO)
and so it keeps those ifdefs in when it should be able to remove them.

This works too:

#ifndef __KERNEL__
# define __V4L1_COMPAT_API /* Always provide definitions to user space */
#elif defined(CONFIG_VIDEO_V4L1_COMPAT) /* __KERNEL__ */
# define __V4L1_COMPAT_API
#endif /* CONFIG_VIDEO_V4L1_COMPAT */
