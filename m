Return-path: <mchehab@gaivota>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54275 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0LaVpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 16:45:12 -0500
Received: by vws16 with SMTP id 16so4908910vws.19
        for <linux-media@vger.kernel.org>; Fri, 31 Dec 2010 13:45:11 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 31 Dec 2010 22:45:09 +0100
Message-ID: <AANLkTi=_LHucekW21KeGt3yWMNYHntQ5nVvHUO2EVHAO@mail.gmail.com>
Subject: DVB driver for TerraTec H7 - how do I install them?
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Ok,
I downloaded drivers for the TerraTec H7 from here: http://linux.terratec.de/
This file to be exact: http://linux.terratec.de/files/TERRATEC_H7_Linux.tar.gz
Which supposedly contains drivers for the H7.

I am running Xubuntu 10.04:
tingo@kg-htpc:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 10.04.1 LTS
Release:        10.04
Codename:       lucid
tingo@kg-htpc:~$ uname -a
Linux kg-htpc 2.6.32-27-generic #49-Ubuntu SMP Wed Dec 1 23:52:12 UTC
2010 i686 GNU/Linux

I followed this guide[1] to get and install a new v4l-dvb, which worked fine.
Then I did 'make distclean' and copied the files from the
TERRATEC_H7_Linux.tar.gz file to where I thought they should be, and
tried recompiling the v4l-dvb tree.
That didn't work, the compilation aborted:
 CC [M]  /home/tingo/work/v4l-dvb/v4l/au6610.o
 CC [M]  /home/tingo/work/v4l-dvb/v4l/az6007.o
In file included from /home/tingo/work/v4l-dvb/v4l/az6007.c:11:
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h: In function 'tuner_MT2063_Open':
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h:62: error:
'DVBFE_TUNER_OPEN' undeclared (first use in this function)
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h:62: error: (Each undeclared
identifier is reported only once
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h:62: error: for each function
it appears in.)
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h: In function
'tuner_MT2063_SoftwareShutdown':
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h:83: error:
'DVBFE_TUNER_SOFTWARE_SHUTDOWN' undeclared (first use in this
function)
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h: In function
'tuner_MT2063_ClearPowerMaskBits':
/home/tingo/work/v4l-dvb/v4l/mt2063_cfg.h:104: error:
'DVBFE_TUNER_CLEAR_POWER_MASKBITS' undeclared (first use in this
function)
/home/tingo/work/v4l-dvb/v4l/az6007.c: At top level:
/home/tingo/work/v4l-dvb/v4l/az6007.c:157: warning: excess elements in
struct initializer
/home/tingo/work/v4l-dvb/v4l/az6007.c:157: warning: (near
initialization for 'az6007_rc_keys[0]')
/home/tingo/work/v4l-dvb/v4l/az6007.c:158: warning: excess elements in
struct initializer
/home/tingo/work/v4l-dvb/v4l/az6007.c:158: warning: (near
initialization for 'az6007_rc_keys[1]')
/home/tingo/work/v4l-dvb/v4l/az6007.c:535: error:
'USB_PID_AZUREWAVE_6007' undeclared here (not in a function)
/home/tingo/work/v4l-dvb/v4l/az6007.c:536: error:
'USB_PID_TERRATEC_H7' undeclared here (not in a function)
make[3]: *** [/home/tingo/work/v4l-dvb/v4l/az6007.o] Error 1
make[2]: *** [_module_/home/tingo/work/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-27-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/tingo/work/v4l-dvb/v4l'
make: *** [all] Error 2

So obviously I'm doing something wrong.
How do I install those drivers for the TerraTec H7?

Oh, and best wishes for the new year to everyone!

References:
1) http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
--
Regards,
Torfinn Ingolfsen
Norway
