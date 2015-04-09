Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51582 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbbDIPXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 11:23:10 -0400
MIME-Version: 1.0
Message-ID: <trinity-697dde81-bae2-4f42-b8af-ea4e14573136-1428592989284@3capp-gmx-bs54>
From: Amex@gmx.de
To: linux-media@vger.kernel.org
Subject: kconf syntax error when doing make menuconfig
Content-Type: text/plain; charset=UTF-8
Date: Thu, 9 Apr 2015 17:23:09 +0200
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,
 
i'm trying to select only specific modules with menuconfig but get this:
 
ubuntu@***:~/media_build$ sudo make menuconfig
make -C /home/ubuntu/media_build/v4l menuconfig
make[1]: Entering directory `/home/ubuntu/media_build/v4l'
make -C /lib/modules/3.13.0-44-generic/build -f /home/ubuntu/media_build/v4l/Makefile.kernel config-targets=1 mixed-targets=0 dot-config=0 SRCDIR=/lib/modules/3.13.0-44-generic/build v4l-mconf
make[2]: Entering directory `/usr/src/linux-headers-3.13.0-44-generic'
make -f /lib/modules/3.13.0-44-generic/build/scripts/Makefile.build obj=scripts/kconfig hostprogs-y=mconf scripts/kconfig/mconf
HOSTCC scripts/kconfig/lxdialog/checklist.o
HOSTCC scripts/kconfig/lxdialog/inputbox.o
HOSTCC scripts/kconfig/lxdialog/menubox.o
HOSTCC scripts/kconfig/lxdialog/textbox.o
HOSTCC scripts/kconfig/lxdialog/util.o
HOSTCC scripts/kconfig/lxdialog/yesno.o
HOSTCC scripts/kconfig/mconf.o
HOSTCC scripts/kconfig/zconf.tab.o
HOSTLD scripts/kconfig/mconf
make[2]: Leaving directory `/usr/src/linux-headers-3.13.0-44-generic'
/lib/modules/3.13.0-44-generic/build/scripts/kconfig/mconf ./Kconfig
./Kconfig:778: syntax error
./Kconfig:777: unknown option "Say"
./Kconfig:778: unknown option "which"
./Kconfig:779: unknown option "The"
./Kconfig:782: syntax error
./Kconfig:781:warning: multi-line strings not supported
./Kconfig:781: unknown option "If"
make[1]: *** [menuconfig] Error 1
make[1]: Leaving directory `/home/ubuntu/media_build/v4l'
make: *** [menuconfig] Error 2

it happens on Amazon EC2 Ubuntu 14.04 aswell as in my own VirtualBox VM

i also get this with make xconfig. just running ./build, however, works

-TC
