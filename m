Return-path: <linux-media-owner@vger.kernel.org>
Received: from web25601.mail.ukl.yahoo.com ([217.12.10.160]:28186 "HELO
	web25601.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757307AbZKFLuY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2009 06:50:24 -0500
Message-ID: <30249.44363.qm@web25601.mail.ukl.yahoo.com>
Date: Fri, 6 Nov 2009 11:50:28 +0000 (GMT)
From: Romont Sylvain <psgman24@yahoo.fr>
Subject: Error in dvbdev.c
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I tried to use the latest v4l-dvb for making working my tuner but I can't
compile it, I have an error in dvbdev.c, how can I fix it?

make
make -C /home/romont/dvb-mtvhd/v4l-dvb/v4l
make[1]: entrant dans le répertoire « /home/romont/dvb-mtvhd/v4l-dvb/v4l »
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/home/romont/dvb-mtvhd/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/home/romont/dvb-mtvhd/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/home/romont/dvb-mtvhd/v4l-dvb/v4l/firmware'
make[2]: Nothing to be done for `default'.
make[2]: Leaving directory `/home/romont/dvb-mtvhd/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.31.5-desktop-1mnb/build
make -C /lib/modules/2.6.31.5-desktop-1mnb/build SUBDIRS=/home/romont/dvb-mtvhd/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.31.5-desktop-1mnb'
  CC [M]  /home/romont/dvb-mtvhd/v4l-dvb/v4l/dvbdev.o
/home/romont/dvb-mtvhd/v4l-dvb/v4l/dvbdev.c: In function 'init_dvbdev':
/home/romont/dvb-mtvhd/v4l-dvb/v4l/dvbdev.c:520: error: 'struct class' has no member named 'nodename'
make[3]: *** [/home/romont/dvb-mtvhd/v4l-dvb/v4l/dvbdev.o] Error 1
make[2]: *** [_module_/home/romont/dvb-mtvhd/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.31.5-desktop-1mnb'
make[1]: *** [default] Erreur 2
make[1]: quittant le répertoire « /home/romont/dvb-mtvhd/v4l-dvb/v4l »
make: *** [all] Erreur 2

Thank you for your help!


      
