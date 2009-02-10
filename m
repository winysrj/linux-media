Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2675 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZBJVVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 16:21:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: cx8802.ko module not being built with current HG tree
Date: Tue, 10 Feb 2009 22:21:39 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com> <200902102132.00114.hverkuil@xs4all.nl> <20090210184147.61d4655e@pedra.chehab.org>
In-Reply-To: <20090210184147.61d4655e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902102221.40067.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 February 2009 21:41:47 Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 21:31:59 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tuesday 10 February 2009 19:47:40 Mauro Carvalho Chehab wrote:
> > > On Tue, 10 Feb 2009 10:25:26 -0800 (PST)
> > >
> > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > > On Tue, 10 Feb 2009, Eduard Huguet wrote:
> > > > >     I don't have yet the buggy config, but the steps I was
> > > > > following when I encounter the problem were the following:
> > > > >         · hg clone http://linuxtv.org/hg/v4l-dvb
> > > > >         · cd v4l-dvb
> > > > >         · make menuconfig
> > > >
> > > > This is what I did too.  Just use the menuconfig or xconfig
> > > > targets. Maybe the kernel kconfig behavior has changed?
> > >
> > > Hmm... I did a test here with RHEL 2.6.18 kernel:
> > >
> > > $ make menuconfig
> > > make -C /home/v4l/master/v4l menuconfig
> > > make[1]: Entrando no diretório `/home/v4l/master/v4l'
> > > /usr/src/kernels/2.6.18-125.el5-x86_64//scripts/kconfig/mconf
> > > ./Kconfig #
> > > # configuration written to .config
> > > #
> > >
> > >
> > > *** End of Linux kernel configuration.
> > > *** Execute 'make' to build the kernel or try 'make help'.
> > >
> > > $ grep CX88 v4l/.config
> > > CONFIG_VIDEO_CX88=m
> > > CONFIG_VIDEO_CX88_ALSA=m
> > > CONFIG_VIDEO_CX88_BLACKBIRD=m
> > > CONFIG_VIDEO_CX88_DVB=m
> > > CONFIG_VIDEO_CX88_MPEG=y
> > > CONFIG_VIDEO_CX88_VP3054=m
> > >
> > > So, I got the buggy .config
> > >
> > > Another test with 2.6.27:
> > >
> > > $ make menuconfig
> > > make -C /home/v4l/master/v4l menuconfig
> > > make[1]: Entrando no diretório `/home/v4l/master/v4l'
> > > ./scripts/make_kconfig.pl /usr/src/kernels/v2.6.27.4/
> > > /usr/src/kernels/v2.6.27.4/ Preparing to compile for kernel version
> > > 2.6.27
> > > VIDEO_PXA27x: Requires at least kernel 2.6.29
> > > USB_STV06XX: Requires at least kernel 2.6.28
> > > /usr/src/kernels/v2.6.27.4.i5400//scripts/kconfig/mconf ./Kconfig
> > > #
> > > # configuration written to .config
> > > #
> > >
> > >
> > > *** End of Linux kernel configuration.
> > > *** Execute 'make' to build the kernel or try 'make help'.
> > >
> > > make[1]: Saindo do diretório `/home/v4l/master/v4l'
> > > [v4l@pedra master]$ grep CX88 v4l/.config
> > > CONFIG_VIDEO_CX88=m
> > > CONFIG_VIDEO_CX88_ALSA=m
> > > CONFIG_VIDEO_CX88_BLACKBIRD=m
> > > CONFIG_VIDEO_CX88_DVB=m
> > > CONFIG_VIDEO_CX88_MPEG=m
> > > CONFIG_VIDEO_CX88_VP3054=m
> > >
> > > With 2.6.27, everything is OK.
> > >
> > > So, it seems that a fix at some kernel between 2.6.22 and 2.6.27
> > > changed (or fixed) the Kconfig behaviour.
> > >
> > > I suspect that the better fix for this would be to run something
> > > like:
> > >
> > > cat .config|sed s,'=y','=m'
> > >
> > > For kernels older than 2.6.27.
> > >
> > > Maybe Hans can give us a hint on what kernel this issue were solved,
> > > with his build environment.
> >
> > 2.6.21 is wrong, 2.6.22 is right. Cause: dependency on VIDEOBUF_DMA_SG,
> > which has a dependency on CONFIG_HAS_DMA, which was apparently
> > introduced in 2.6.22 and didn't exist in 2.6.21.
> >
> > This is fixed by the attached diff.
>
> No, it didn't fix. I'm still getting this issue with 2.6.18.
>
> Btw, on RHEL5 2.6.18 kernel, HAS_DMA does exist:
>
> $ grep CONFIG_HAS_DMA /usr/src/kernels/2.6.18-125.el5-x86_64/.config
> CONFIG_HAS_DMA=y

Oops, this fixes a different bug. It is still a bug fix, though, since it 
prevents CX88 from being build at all on any vanilla kernels < 2.6.22. Can 
you apply it?

> Also, the original reporter were for an Ubuntu kernel 2.6.22.

I did some more testing and the bug disappears in kernel 2.6.25. Also, if I 
just run 'make', then the .config file it produces is fine. I wonder if it 
isn't a bug in menuconfig itself.

Regards,

	Hans

>
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> >
> > BTW, all the scripts I use to setup and run the build environment are
> > available here: http://www.xs4all.nl/%7Ehverkuil/logs/scripts.tar.bz2
> >
> > Regards,
> >
> > 	Hans
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
