Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.186]:61913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab0LVPuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 10:50:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH v2] drivers/media/video/v4l2-compat-ioctl32.c: Check the return value of copy_to_user
Date: Wed, 22 Dec 2010 16:50:17 +0100
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <201012212003.11446.arnd@arndb.de> <83948188cda2388c2e22a50119dfb0023fba759a.1292975147.git.tfransosi@gmail.com> <4D1207D9.2050000@linuxtv.org>
In-Reply-To: <4D1207D9.2050000@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221650.17394.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday 22 December 2010 15:14:49 Andreas Oberritter wrote:
> > diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> > index e30e8df..6f2a022 100644
> > --- a/drivers/media/video/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> > @@ -201,14 +201,12 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
> >  
> >       up = compat_alloc_user_space(sizeof(*up));
> 
> I don't know anything about that code, but I assume that "up" should be
> checked for NULL before use and should be freed in case an error occurs
> below.
> 

No, that's fine. compat_alloc_user_space() is very special -- the allocated
memory is on the user stack and automatically gets freed when the kernel
returns to user space.

We treat the resulting pointer like any other user pointer, i.e. we only
ever access it using {get,put}_user and copy_{from,to}_user, which check
that it's pointing to real user memory. A null pointer here would only
mean that the user had an invalid stack pointer before entering the kernel,
but causes no more problems than passing NULL as the ioctl argument.

	Arnd
