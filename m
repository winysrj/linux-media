Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-yw0-f174.google.com ([209.85.211.174])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <david.whyte@gmail.com>) id 1MlCZp-0008Ud-Ro
	for linux-dvb@linuxtv.org; Wed, 09 Sep 2009 04:06:30 +0200
Received: by ywh4 with SMTP id 4so915425ywh.1
	for <linux-dvb@linuxtv.org>; Tue, 08 Sep 2009 19:05:55 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 12:05:55 +1000
Message-ID: <5df807700909081905hee100f3ia5dfed3604015a7f@mail.gmail.com>
From: David Whyte <david.whyte@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] saa7134 tuner doesn't work after warm-reboot
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
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

My brothers mythTV setup currently consists of one MBE with 2x DVB-T
tuners in.

Both tuners are from identical Medion PCs and report the following
from dmesg when booted...

mythtv-user@mythBE1:~$ dmesg | grep -i dvb
[   62.626167] saa7134[0] Board has DVB-T
[   63.405856] saa7134[1] Board has DVB-T
[   63.933725] DVB: registering new adapter (saa7134[0])
[   63.933729] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   66.281192] DVB: registering new adapter (saa7134[1])
[   66.281197] DVB: registering frontend 1 (Philips TDA10046H DVB-T)...

My brother lives in an area that suffers very short power-outages if
there is a storm or whatever and I have noticed that after such an
event, he loses the ability to record TV from both tuners and
generally only one will work.  I am never sure if it is always the
same tuner that as busted since I don't know which is dvb0 or dvb1 at
any point in time.

To correct this, I remote into the server and issue a 'halt', get him
to unplug it from the wall then press the power button on the front of
the machine, re-plug it into the wall and boot up the server.  Then
both tuners are working fine.

I understand the best way around this might be a UPS, but I don't have
the ability to get one at the moment, though it will be his next
purchase.

In the meantime I was wandering if anyone had any suggestions for
getting around this problem.  For my tuners that used to suffer a
similar problem (but which are different tuners) I had to add some
lines to rc.local to remove the dvb modules and then re-insert them
and this seemed to work.  There are a number of similar posts in the
archives like this.  I have tried this for the saa7134 modules but to
no avail.

The following output is for reference:
mythtv-user@mythBE1:~$ lsmod | grep -i saa
saa7134_dvb            21516  0
videobuf_dvb            7812  1 saa7134_dvb
dvb_core               80636  2 saa7134_dvb,videobuf_dvb
saa7134               143828  1 saa7134_dvb
videodev               35072  2 saa7134,tuner
compat_ioctl32          2304  1 saa7134
v4l2_common            12672  2 saa7134,tuner
videobuf_dma_sg        14980  2 saa7134_dvb,saa7134
videobuf_core          19716  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             11152  1 saa7134
ir_common              40580  2 saa7134,ir_kbd_i2c
tveeprom               13444  1 saa7134
i2c_core               24832  12
saa7134_dvb,saa7134,tda1004x,tuner_simple,tda9887,tda8290,tuner,v4l2_common,ir_kbd_i2c,tveeprom,i2c_i810,i2c_algo_bit
mythtv-user@mythBE1:~$

mythtv-user@mythBE1:~$ cat /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

/sbin/rmmod saa7134_dvb saa7134 videobuf_dvb dvb_core

/sbin/modprobe saa7134_dvb

exit 0
mythtv-user@mythBE1:~$

The machine is a Pentium 4 running Ubuntu Hardy:
mythtv-user@mythBE1:~$ uname -r
2.6.24-24-generic
mythtv-user@mythBE1:~$

mythtv-user@mythBE1:~$ modinfo saa7134_dvb
filename:       /lib/modules/2.6.24-24-generic/updates/dkms/saa7134-dvb.ko
license:        GPL
author:         Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
srcversion:     C8C85F1BA098BDF283F1975
depends:        saa7134,dvb-core,videobuf-dvb,videobuf-dma-sg,i2c-core
vermagic:       2.6.24-24-generic SMP mod_unload 586
parm:           antenna_pwr:enable antenna power (Pinnacle 300i) (int)
parm:           use_frontend:for cards with multiple frontends (0:
terrestrial, 1: satellite) (int)
parm:           debug:Turn on/off module debugging (default:off). (int)
parm:           adapter_nr:DVB adapter numbers (array of short)
mythtv-user@mythBE1:~$

Similar bug in launchpad, but no saa7134_also module is loaded for these cards.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349537

Any help is greatly appreciated.

Regards,
Whytey

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
