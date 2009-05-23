Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:37421 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZEWS0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 14:26:07 -0400
Received: by bwz22 with SMTP id 22so2248120bwz.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 11:26:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905231957.45456.jarhuba2@poczta.onet.pl>
References: <200905230810.39344.jarhuba2@poczta.onet.pl>
	 <200905231301.53827.jarhuba2@poczta.onet.pl>
	 <1a297b360905230457u7aee8795k4e5b59bd5a49f90b@mail.gmail.com>
	 <200905231957.45456.jarhuba2@poczta.onet.pl>
Date: Sat, 23 May 2009 22:26:06 +0400
Message-ID: <1a297b360905231126g5053b828i3049fc810d94ba85@mail.gmail.com>
Subject: Re: Question about driver for Mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: jarhuba2@poczta.onet.pl
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/5/23 Jaros³aw Huba <jarhuba2@poczta.onet.pl>
>
> > Just clone the tree on to your machine
> > hg clone http://jusst.de/hg/mantis-v4l
> >
> > Clean stal remnants if any.
> > make distclean
> >
> > Build the tree
> > make
> >
>
> I got this error:
> jarek@jarek-desktop:~/mantis-v4l$ make
> make -C /home/jarek/mantis-v4l/v4l
> make[1]: Wej¶cie do katalogu `/home/jarek/mantis-v4l/v4l'
> No version yet, using 2.6.30-6-generic
> make[1]: Opuszczenie katalogu `/home/jarek/mantis-v4l/v4l'
> make[1]: Wej¶cie do katalogu `/home/jarek/mantis-v4l/v4l'
> scripts/make_makefile.pl
> Updating/Creating .config
> Preparing to compile for kernel version 2.6.30
>
> ***WARNING:*** You do not have the full kernel sources installed.
> This does not prevent you from building the v4l-dvb tree if you have the
> kernel headers, but the full kernel source may be required in order to use
> make menuconfig / xconfig / qconfig.
>
> If you are experiencing problems building the v4l-dvb tree, please try
> building against a vanilla kernel before reporting a bug.
>
> Vanilla kernels are available at http://kernel.org.
> On most distros, this will compile a newly downloaded kernel:
>
> cp /boot/config-`uname -r` <your kernel dir>/.config
> cd <your kernel dir>
> make all modules_install install
>
> Please see your distro's web site for instructions to build a new kernel.
>
> Created default (all yes) .config file
> ./scripts/make_myconfig.pl
> make[1]: Opuszczenie katalogu `/home/jarek/mantis-v4l/v4l'
> make[1]: Wej¶cie do katalogu `/home/jarek/mantis-v4l/v4l'
> perl scripts/make_config_compat.pl /lib/modules/2.6.30-6-generic/build
> ./.myconfig ./config-compat.h
> creating symbolic links...
> ln -sf . oss
> Kernel build directory is /lib/modules/2.6.30-6-generic/build
> make -C /lib/modules/2.6.30-6-generic/build SUBDIRS=/home/jarek/mantis-v4l/v4l
> modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.30-6-generic'
>  CC [M]  /home/jarek/mantis-v4l/v4l/tuner-xc2028.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tuner-simple.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tuner-types.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/mt20xx.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tda8290.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tea5767.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tea5761.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tda9887.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/tda827x.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/au0828-core.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/au0828-i2c.o
>  CC [M]  /home/jarek/mantis-v4l/v4l/au0828-cards.o
> In file included from /home/jarek/mantis-v4l/v4l/dmxdev.h:33,
>                 from /home/jarek/mantis-v4l/v4l/au0828.h:29,
>                 from /home/jarek/mantis-v4l/v4l/au0828-cards.c:22:
> /home/jarek/mantis-v4l/v4l/compat.h:396: error: redefinition of
> 'usb_endpoint_type'
> include/linux/usb/ch9.h:376: note: previous definition of 'usb_endpoint_type'
> was here

Quick fix, do a make menuconfig: navigate through the menus, disable
au0828 support and try again.

Regards,
Manu
