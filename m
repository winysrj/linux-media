Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33107 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbZINR5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 13:57:00 -0400
Date: Mon, 14 Sep 2009 14:56:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Peter J. Olson" <peterjolson@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Compile error when I get to snd-go7007.c
Message-ID: <20090914145618.14e08573@pedra.chehab.org>
In-Reply-To: <64a476a80909141031u4e664a2ard4590988bf88de8f@mail.gmail.com>
References: <64a476a80909140736k159fddffle1d6ccbcaa3cecfb@mail.gmail.com>
	<64a476a80909140739h6612ce69u2819335f7ea2c758@mail.gmail.com>
	<64a476a80909140804s34ebd140r7934f46fb2150364@mail.gmail.com>
	<64a476a80909140810j2c23a11fp994c6278ec01829a@mail.gmail.com>
	<64a476a80909140818y7d29fb0w84f247e4de702a30@mail.gmail.com>
	<20090914133229.7dc1b9c4@pedra.chehab.org>
	<64a476a80909141031u4e664a2ard4590988bf88de8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Sep 2009 12:31:28 -0500
"Peter J. Olson" <peterjolson@gmail.com> escreveu:

> Well, I made it a little farther...  I think.  I updated v4l-dvb: "hg
> pull" then updated "hg update"
> 
> I then ran "make allmodconfig"
> 
> This is my output:
> make -C /home/mythbox/Firmware/v4l-dvb/v4l allmodconfig
> make[1]: Entering directory `/home/mythbox/Firmware/v4l-dvb/v4l'
> ./scripts/make_kconfig.pl /lib/modules/2.6.28-15-generic/build
> /lib/modules/2.6.28-15-generic/build 1
> Preparing to compile for kernel version 2.6.28
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
> VIDEO_VPSS_SYSTEM: Requires at least kernel 2.6.31
> VIDEO_VPFE_CAPTURE: Requires at least kernel 2.6.31
> VIDEO_DM6446_CCDC: Requires at least kernel 2.6.31
> VIDEO_DM355_CCDC: Requires at least kernel 2.6.31
> VIDEO_PXA27x: Requires at least kernel 2.6.29
> VIDEO_CX25821: Requires at least kernel 2.6.31
> VIDEO_CX25821_ALSA: Requires at least kernel 2.6.31
> Created default (all yes) .config file
> ./scripts/fix_kconfig.pl
> make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'
> 
> Then I made it here:
> 
>   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-core.o
>   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-sg.o
>   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o
> /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c: In function
> 'videobuf_dma_contig_user_get':
> /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c:164: error:
> implicit declaration of function 'follow_pfn'
> make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o] Error 1
> make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'
> make: *** [all] Error 2
> 
> Its kinda annoying that a year ago this was super easy...
> 
> I dont really want to bump up to 2.6.31 seeing it just came out a few days ago.

Ok, this is the usual backport issues we have every time we need to backport
patches upstream. This should be solved soon, but currently my priority is to
merge the pending patches at the tree. Up to then, you may do a:
	make menuconfig

and select only the drivers you need, or just revert the latest changepatch to
videobuf-dma-config.




Cheers,
Mauro
