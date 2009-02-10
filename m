Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4471 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbZBJUcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 15:32:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: cx8802.ko module not being built with current HG tree
Date: Tue, 10 Feb 2009 21:31:59 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com> <Pine.LNX.4.58.0902101018260.24268@shell2.speakeasy.net> <20090210164740.36bab2ee@pedra.chehab.org>
In-Reply-To: <20090210164740.36bab2ee@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ARekJR2bUcu5VEW"
Message-Id: <200902102132.00114.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_ARekJR2bUcu5VEW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 10 February 2009 19:47:40 Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 10:25:26 -0800 (PST)
>
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > On Tue, 10 Feb 2009, Eduard Huguet wrote:
> > >     I don't have yet the buggy config, but the steps I was following
> > > when I encounter the problem were the following:
> > >         =B7 hg clone http://linuxtv.org/hg/v4l-dvb
> > >         =B7 cd v4l-dvb
> > >         =B7 make menuconfig
> >
> > This is what I did too.  Just use the menuconfig or xconfig targets.=20
> > Maybe the kernel kconfig behavior has changed?
>
> Hmm... I did a test here with RHEL 2.6.18 kernel:
>
> $ make menuconfig
> make -C /home/v4l/master/v4l menuconfig
> make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
> /usr/src/kernels/2.6.18-125.el5-x86_64//scripts/kconfig/mconf ./Kconfig
> #
> # configuration written to .config
> #
>
>
> *** End of Linux kernel configuration.
> *** Execute 'make' to build the kernel or try 'make help'.
>
> $ grep CX88 v4l/.config
> CONFIG_VIDEO_CX88=3Dm
> CONFIG_VIDEO_CX88_ALSA=3Dm
> CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
> CONFIG_VIDEO_CX88_DVB=3Dm
> CONFIG_VIDEO_CX88_MPEG=3Dy
> CONFIG_VIDEO_CX88_VP3054=3Dm
>
> So, I got the buggy .config
>
> Another test with 2.6.27:
>
> $ make menuconfig
> make -C /home/v4l/master/v4l menuconfig
> make[1]: Entrando no diret=F3rio `/home/v4l/master/v4l'
> ./scripts/make_kconfig.pl /usr/src/kernels/v2.6.27.4/
> /usr/src/kernels/v2.6.27.4/ Preparing to compile for kernel version
> 2.6.27
> VIDEO_PXA27x: Requires at least kernel 2.6.29
> USB_STV06XX: Requires at least kernel 2.6.28
> /usr/src/kernels/v2.6.27.4.i5400//scripts/kconfig/mconf ./Kconfig
> #
> # configuration written to .config
> #
>
>
> *** End of Linux kernel configuration.
> *** Execute 'make' to build the kernel or try 'make help'.
>
> make[1]: Saindo do diret=F3rio `/home/v4l/master/v4l'
> [v4l@pedra master]$ grep CX88 v4l/.config
> CONFIG_VIDEO_CX88=3Dm
> CONFIG_VIDEO_CX88_ALSA=3Dm
> CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
> CONFIG_VIDEO_CX88_DVB=3Dm
> CONFIG_VIDEO_CX88_MPEG=3Dm
> CONFIG_VIDEO_CX88_VP3054=3Dm
>
> With 2.6.27, everything is OK.
>
> So, it seems that a fix at some kernel between 2.6.22 and 2.6.27 changed
> (or fixed) the Kconfig behaviour.
>
> I suspect that the better fix for this would be to run something like:
>
> cat .config|sed s,'=3Dy','=3Dm'
>
> For kernels older than 2.6.27.
>
> Maybe Hans can give us a hint on what kernel this issue were solved, with
> his build environment.

2.6.21 is wrong, 2.6.22 is right. Cause: dependency on VIDEOBUF_DMA_SG,=20
which has a dependency on CONFIG_HAS_DMA, which was apparently introduced=20
in 2.6.22 and didn't exist in 2.6.21.

This is fixed by the attached diff.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

BTW, all the scripts I use to setup and run the build environment are=20
available here: http://www.xs4all.nl/%7Ehverkuil/logs/scripts.tar.bz2

Regards,

	Hans

=2D-=20
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_ARekJR2bUcu5VEW
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="dma.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dma.diff"

diff -r 9cb19f080660 v4l/scripts/make_kconfig.pl
--- a/v4l/scripts/make_kconfig.pl	Tue Feb 10 05:26:05 2009 -0200
+++ b/v4l/scripts/make_kconfig.pl	Tue Feb 10 21:28:50 2009 +0100
@@ -537,6 +537,11 @@
     $kernopts{HAS_IOMEM} = 2;
 }
 
+# Kernel < 2.6.22 is missing the HAS_DMA option
+if (!defined $kernopts{HAS_DMA} && cmp_ver($kernver, '2.6.22') < 0) {
+    $kernopts{HAS_DMA} = 2;
+}
+
 # Kernel < 2.6.23 is missing the VIRT_TO_BUS option
 if (!defined $kernopts{VIRT_TO_BUS} && cmp_ver($kernver, '2.6.23') < 0) {
 	# VIRT_TO_BUS -> !PPC64

--Boundary-00=_ARekJR2bUcu5VEW--
