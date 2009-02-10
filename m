Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZBJSsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 13:48:18 -0500
Date: Tue, 10 Feb 2009 16:47:40 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: cx8802.ko module not being built with current HG tree
Message-ID: <20090210164740.36bab2ee@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0902101018260.24268@shell2.speakeasy.net>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
	<617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
	<20090210093753.69b21572@pedra.chehab.org>
	<617be8890902100349r39c49edfr4c3373669d698b72@mail.gmail.com>
	<Pine.LNX.4.58.0902101018260.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 10:25:26 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Tue, 10 Feb 2009, Eduard Huguet wrote:
> >     I don't have yet the buggy config, but the steps I was following
> > when I encounter the problem were the following:
> >         · hg clone http://linuxtv.org/hg/v4l-dvb
> >         · cd v4l-dvb
> >         · make menuconfig
> 
> This is what I did too.  Just use the menuconfig or xconfig targets.  Maybe
> the kernel kconfig behavior has changed?

Hmm... I did a test here with RHEL 2.6.18 kernel:

$ make menuconfig
make -C /home/v4l/master/v4l menuconfig
make[1]: Entrando no diretório `/home/v4l/master/v4l'
/usr/src/kernels/2.6.18-125.el5-x86_64//scripts/kconfig/mconf ./Kconfig
#
# configuration written to .config
#


*** End of Linux kernel configuration.
*** Execute 'make' to build the kernel or try 'make help'.

$ grep CX88 v4l/.config
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_CX88_VP3054=m

So, I got the buggy .config

Another test with 2.6.27:

$ make menuconfig
make -C /home/v4l/master/v4l menuconfig
make[1]: Entrando no diretório `/home/v4l/master/v4l'
./scripts/make_kconfig.pl /usr/src/kernels/v2.6.27.4/ /usr/src/kernels/v2.6.27.4/
Preparing to compile for kernel version 2.6.27
VIDEO_PXA27x: Requires at least kernel 2.6.29
USB_STV06XX: Requires at least kernel 2.6.28
/usr/src/kernels/v2.6.27.4.i5400//scripts/kconfig/mconf ./Kconfig
#
# configuration written to .config
#


*** End of Linux kernel configuration.
*** Execute 'make' to build the kernel or try 'make help'.

make[1]: Saindo do diretório `/home/v4l/master/v4l'
[v4l@pedra master]$ grep CX88 v4l/.config
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m

With 2.6.27, everything is OK.

So, it seems that a fix at some kernel between 2.6.22 and 2.6.27 changed (or
fixed) the Kconfig behaviour.

I suspect that the better fix for this would be to run something like:

cat .config|sed s,'=y','=m'

For kernels older than 2.6.27.

Maybe Hans can give us a hint on what kernel this issue were solved, with his
build environment.


Cheers,
Mauro
