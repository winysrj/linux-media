Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01J6wCG013751
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 14:06:58 -0500
Received: from n69.bullet.mail.sp1.yahoo.com (n69.bullet.mail.sp1.yahoo.com
	[98.136.44.41])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n01J6flQ002820
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 14:06:41 -0500
Date: Thu, 1 Jan 2009 11:06:39 -0800 (PST)
From: Alex <s_mrite@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <135963.10009.qm@web45404.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: The gspca from the repository is not compile
Reply-To: s_mrite@yahoo.com
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

Hello,

My system is Fedora 9, the kernel is 2.6.27.9-73.fc9.i686.
I have the package kernel-devel installed.

I have obtained the sources fo the gspca using the command "hg clone http:/=
/linuxtv.org/hg/~jfrancois/gspca/".

I run "make menuconfig" without changes and without erros.
When I run make I got the following error after several seconds of compilin=
g:
---------------------------------------------------------------------------=
-----------------------------------------
=A0CC [M]=A0 /root/Documents/linuxTv/gspca/v4l/bttv-i2c.o
=A0 CC [M]=A0 /root/Documents/linuxTv/gspca/v4l/bttv-gpio.o
=A0 CC [M]=A0 /root/Documents/linuxTv/gspca/v4l/bttv-input.o
In file included from /root/Documents/linuxTv/gspca/v4l/bttvp.h:36,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from /root/Documents/linux=
Tv/gspca/v4l/bttv-input.c:28:
include/linux/pci.h:1126: error: expected declaration specifiers or '...' b=
efore '(' token
include/linux/pci.h:1126: error: expected declaration specifiers or '...' b=
efore '(' token
include/linux/pci.h:1126: error: static declaration of 'ioremap_nocache' fo=
llows non-static declaration
include/asm/io_32.h:111: error: previous declaration of 'ioremap_nocache' w=
as here
include/linux/pci.h: In function 'ioremap_nocache':
include/linux/pci.h:1127: error: number of arguments doesn't match prototyp=
e
include/asm/io_32.h:111: error: prototype declaration
include/linux/pci.h:1131: error: 'pdev' undeclared (first use in this funct=
ion)
include/linux/pci.h:1131: error: (Each undeclared identifier is reported on=
ly once
include/linux/pci.h:1131: error: for each function it appears in.)
include/linux/pci.h:1131: error: 'bar' undeclared (first use in this functi=
on)
make[3]: *** [/root/Documents/linuxTv/gspca/v4l/bttv-input.o] Error 1
make[2]: *** [_module_/root/Documents/linuxTv/gspca/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.27.9-73.fc9.i686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/Documents/linuxTv/gspca/v4l'
make: *** [all] Error 2
---------------------------------------------------------------------------=
-----------------------------------------

The output of the " hg log -l1" is:
---------------------------------------------------------------------------=
-----------------------------------------
changeset:=A0=A0 10167:2b2568c40385
tag:=A0=A0=A0=A0=A0=A0=A0=A0 tip
user:=A0=A0=A0=A0=A0=A0=A0 Jean-Francois Moine <moinejf@free.fr>
date:=A0=A0=A0=A0=A0=A0=A0 Thu Jan 01 17:20:42 2009 +0100
summary:=A0=A0=A0=A0 gspca - common: Simplify the debug macros.
---------------------------------------------------------------------------=
-----------------------------------------

So the sources is up-to-date at the moment of compiling.

Can somebody suggest the way to compile the sources?

Best regards,
Alex.

=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
