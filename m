Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:60348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZAUJJi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 04:09:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: Confusion in usr/include/linux/videodev.h
Date: Wed, 21 Jan 2009 10:09:13 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
References: <1232502038.3123.61.camel@localhost.localdomain> <Pine.LNX.4.58.0901210048500.13170@shell2.speakeasy.net> <3f9a31f40901210059g51d46f56t85364d886b757a6e@mail.gmail.com>
In-Reply-To: <3f9a31f40901210059g51d46f56t85364d886b757a6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211009.14856.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 January 2009, Jaswinder Singh Rajput wrote:

> > diff -r 29c5787efcda linux/include/linux/videodev.h
> > --- a/linux/include/linux/videodev.h    Thu Jan 15 09:07:03 2009 -0800
> > +++ b/linux/include/linux/videodev.h    Wed Jan 21 00:51:45 2009 -0800
> > @@ -15,7 +15,8 @@
> >  #include <linux/ioctl.h>
> >  #include <linux/videodev2.h>
> >
> > -#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> > +#if (defined(__KERNEL__) && defined(CONFIG_VIDEO_V4L1_COMPAT)) \
> > +    || !defined (__KERNEL__)
> >
> >  #define VID_TYPE_CAPTURE       1       /* Can capture */
> >  #define VID_TYPE_TUNER         2       /* Can tune */
> >
> > Now CONFIG_VIDEO_V4L1_COMPAT will only be used in the kernel.
> >
> 
> No, this will still give warnings.

You could #define another conditional, like this:

#ifndef __KERNEL__
# define __V4L1_COMPAT_API /* Always provide definitions to user space */
#else /* __KERNEL__ */
# ifdef CONFIG_VIDEO_V4L1_COMPAT
#  define __V4L1_COMPAT_API
# endif /* CONFIG_VIDEO_V4L1_COMPAT /*
#endif /* __KERNEL__ */

	Arnd <><
