Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZH0L6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 07:58:24 -0400
Date: Thu, 27 Aug 2009 08:58:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Compile modules on 64-bit Linux kernel system for 686 Linux
 kernel
Message-ID: <20090827085821.39c925f4@pedra.chehab.org>
In-Reply-To: <1251372537.5593.22.camel@mattotaupa.wohnung.familie-menzel.net>
References: <1251372537.5593.22.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Aug 2009 13:28:57 +0200
Paul Menzel <paulepanter@users.sourceforge.net> escreveu:

> Hi guys,
> 
> ( please CC )
> 
> 
> I am running Debian Sid/unstable with a 32-bit userspace with a 64-bit
> kernel [1]. I want to compile the v4l-dvb modules for a 686 kernel [2]
> on this system.
> 
> I installed the header files for the 686 kernel [3], but running
> 
> $ ARCH=686 make
> make -C /tmp/v4l-dvb/v4l 
> make[1]: Entering directory `/tmp/v4l-dvb/v4l'
> perl
> scripts/make_config_compat.pl /lib/modules/2.6.30-1-amd64/source ./.myconfig ./config-compat.h
> creating symbolic links...
> make -C firmware prep
> make[2]: Entering directory `/tmp/v4l-dvb/v4l/firmware'
> make[2]: Leaving directory `/tmp/v4l-dvb/v4l/firmware'
> make -C firmware
> make[2]: Entering directory `/tmp/v4l-dvb/v4l/firmware'
>   CC  ihex2fw
> Generating vicam/firmware.fw
> Generating dabusb/firmware.fw
> Generating dabusb/bitstream.bin
> Generating ttusb-budget/dspbootcode.bin
> Generating cpia2/stv0672_vp4.bin
> Generating av7110/bootcode.bin
> make[2]: Leaving directory `/tmp/v4l-dvb/v4l/firmware'
> Kernel build directory is /lib/modules/2.6.30-1-amd64/build
> make -C /lib/modules/2.6.30-1-amd64/build SUBDIRS=/tmp/v4l-dvb/v4l
> modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.30-1-amd64'
> […]
> 
> still uses the 64-bit modules in /lib/modules/2.6.30-1-amd64 and the
> files in /usr/src/linux-headers-2.6.30-1-amd64.
> 
> I do not even know if this is the correct way.
> 
> Can someone of you please enlighten me?

This is not the correct way. You'll need to also point where do you expect it to get the headers:
This should do the trick:
	make ARCH=i386 release DIR=<directory_name>
	make ARCH=i386 allmodconfig
	make ARCH=i386
> 
> 
> Thanks,
> 
> Paul
> 
> 
> [1] http://packages.debian.org/de/sid/linux-image-2.6.30-1-amd64
> [2] http://packages.debian.org/de/sid/linux-image-2.6.30-1-686
> [3] http://packages.debian.org/de/sid/linux-headers-2.6.30-1-686




Cheers,
Mauro
