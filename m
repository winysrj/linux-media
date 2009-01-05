Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n05K04g8024184
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 15:00:04 -0500
Received: from bay0-omc1-s5.bay0.hotmail.com (bay0-omc1-s5.bay0.hotmail.com
	[65.54.246.77])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n05JxpvH022965
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 14:59:51 -0500
Message-ID: <BAY122-W42C8A061031D93B5A8DEAFB0E10@phx.gbl>
From: Timo Malk <tmalk@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Mon, 5 Jan 2009 21:59:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Compile error /root/v4l-dvb/v4l/bttvp.h:36 /linux/pci.h, Fedora 10,
 (Leadtec DTV Dongle Gold)
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








Hello=2C

Could someone help me out with this.

I am doing this on Fedora 10 with the help of following guide:

http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dongle_Gold

1) hg clone http://linuxtv.org/hg/v4l-dvb
2) cd v4l-dvb/
3) make

And the compile output:
....
  CC [M]  /root/v4l-dvb/v4l/bttv-vbi.o
  CC [M]  /root/v4l-dvb/v4l/bttv-i2c.o
  CC [M]  /root/v4l-dvb/v4l/bttv-gpio.o
  CC [M]  /root/v4l-dvb/v4l/bttv-input.o
In file included from /root/v4l-dvb/v4l/bttvp.h:36=2C
                 from /root/v4l-dvb/v4l/bttv-input.c:28:
include/linux/pci.h:1126: error: expected declaration specifiers or '...' b=
efore '(' token
include/linux/pci.h:1126: error: expected declaration specifiers or '...' b=
efore '(' token
include/linux/pci.h:1126: error: static declaration of 'ioremap_nocache' fo=
llows non-static declaration
include/asm/io_64.h:176: error: previous declaration of 'ioremap_nocache' w=
as here
include/linux/pci.h: In function 'ioremap_nocache':
include/linux/pci.h:1127: error: number of arguments doesn't match prototyp=
e
include/asm/io_64.h:176: error: prototype declaration
include/linux/pci.h:1131: error: 'pdev' undeclared (first use in this funct=
ion)
include/linux/pci.h:1131: error: (Each undeclared identifier is reported on=
ly once
include/linux/pci.h:1131: error: for each function it appears in.)
include/linux/pci.h:1131: error: 'bar' undeclared (first use in this functi=
on)
make[3]: *** [/root/v4l-dvb/v4l/bttv-input.o] Error 1
make[2]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.27.9-159.fc10.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2

It seems that part of the=20
http://linuxtv.org/pipermail/linux-dvb/2009-January/031198.html
is included in current fedora 10 since I can find the fix in make_config_co=
mpat.pl.

I could not find the second part in /usr/src/kernels/2.6.27.9-159.fc10.x86_=
64/include/linux/netdevice.h=20

It is pain to find out-of-the-box-supported hw for linux (in my case Fedora=
 10).

Yours
Timo




_________________________________________________________________
N=E4yt=E4 heille oikea tie! Lis=E4=E4 juhlakutsuihisi kartat ja ajo-ohjeet =
.=20
http://www.microsoft.com/windows/windowslive/events.aspx=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
