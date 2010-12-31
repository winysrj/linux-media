Return-path: <mchehab@gaivota>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tingox@gmail.com>) id 1PYmf8-00023N-Qo
	for linux-dvb@linuxtv.org; Fri, 31 Dec 2010 22:37:27 +0100
Received: from mail-vw0-f54.google.com ([209.85.212.54])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PYmf8-0007VA-AS; Fri, 31 Dec 2010 22:37:26 +0100
Received: by vws9 with SMTP id 9so4803066vws.41
	for <linux-dvb@linuxtv.org>; Fri, 31 Dec 2010 13:37:24 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 31 Dec 2010 22:37:22 +0100
Message-ID: <AANLkTimb1K=6vGo3OmckXNwcXiHzW3Oy90NPWStTT08a@mail.gmail.com>
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DVB driver for TerraTec H7 - how do I install them?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <linux-dvb@linuxtv.org>

Ok,
I downloaded drivers for the TerraTec H7 from here: http://linux.terratec.de/
This file to be exact: http://linux.terratec.de/files/TERRATEC_H7_Linux.tar.gz
Which supposedly contains drivers for the H7.

I am running Xubuntu 10.04:
tingo@kg-htpc:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 10.04.1 LTS
Release:	10.04
Codename:	lucid
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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
