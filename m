Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01JVE2I018674
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 14:31:14 -0500
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01JUv1J011277
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 14:30:57 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: s_mrite@yahoo.com
In-Reply-To: <135963.10009.qm@web45404.mail.sp1.yahoo.com>
References: <135963.10009.qm@web45404.mail.sp1.yahoo.com>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 20:31:29 +0100
Message-Id: <1230838289.7045.34.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: The gspca from the repository is not compile
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Donnerstag, den 01.01.2009, 11:06 -0800 schrieb Alex:
> Hello,
> 
> My system is Fedora 9, the kernel is 2.6.27.9-73.fc9.i686.
> I have the package kernel-devel installed.
> 
> I have obtained the sources fo the gspca using the command "hg clone http://linuxtv.org/hg/~jfrancois/gspca/".
> 
> I run "make menuconfig" without changes and without erros.
> When I run make I got the following error after several seconds of compiling:
> --------------------------------------------------------------------------------------------------------------------
>  CC [M]  /root/Documents/linuxTv/gspca/v4l/bttv-i2c.o
>   CC [M]  /root/Documents/linuxTv/gspca/v4l/bttv-gpio.o
>   CC [M]  /root/Documents/linuxTv/gspca/v4l/bttv-input.o
> In file included from /root/Documents/linuxTv/gspca/v4l/bttvp.h:36,
>                  from /root/Documents/linuxTv/gspca/v4l/bttv-input.c:28:
> include/linux/pci.h:1126: error: expected declaration specifiers or '...' before '(' token
> include/linux/pci.h:1126: error: expected declaration specifiers or '...' before '(' token
> include/linux/pci.h:1126: error: static declaration of 'ioremap_nocache' follows non-static declaration
> include/asm/io_32.h:111: error: previous declaration of 'ioremap_nocache' was here
> include/linux/pci.h: In function 'ioremap_nocache':
> include/linux/pci.h:1127: error: number of arguments doesn't match prototype
> include/asm/io_32.h:111: error: prototype declaration
> include/linux/pci.h:1131: error: 'pdev' undeclared (first use in this function)
> include/linux/pci.h:1131: error: (Each undeclared identifier is reported only once
> include/linux/pci.h:1131: error: for each function it appears in.)
> include/linux/pci.h:1131: error: 'bar' undeclared (first use in this function)
> make[3]: *** [/root/Documents/linuxTv/gspca/v4l/bttv-input.o] Error 1
> make[2]: *** [_module_/root/Documents/linuxTv/gspca/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/2.6.27.9-73.fc9.i686'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/root/Documents/linuxTv/gspca/v4l'
> make: *** [all] Error 2
> --------------------------------------------------------------------------------------------------------------------
> 
> The output of the " hg log -l1" is:
> --------------------------------------------------------------------------------------------------------------------
> changeset:   10167:2b2568c40385
> tag:         tip
> user:        Jean-Francois Moine <moinejf@free.fr>
> date:        Thu Jan 01 17:20:42 2009 +0100
> summary:     gspca - common: Simplify the debug macros.
> --------------------------------------------------------------------------------------------------------------------
> 
> So the sources is up-to-date at the moment of compiling.
> 
> Can somebody suggest the way to compile the sources?
> 
> Best regards,
> Alex.
> 

Hi,

this is only the beginning of a series of recent compile troubles.

We had for a while snapshots of v4l-dvb to allow to come over such times
caused by kernel sync down ported from upstream and maybe should have
them again for such periods.

For now, either checkout a slightly older snapshot or disable
conflicting stuff with "make menuconfig" or fix it.

It starts with bttv-input, goes over cx23885, cx88xx, saa7134-alsa and
several dvb frontends, but gspca is not involved.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
