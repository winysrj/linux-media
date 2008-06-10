Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from olammi.iki.fi ([217.112.242.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <olammi@olammi.iki.fi>) id 1K60dT-0007eJ-W9
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 11:59:28 +0200
Date: Tue, 10 Jun 2008 12:59:21 +0300 (EEST)
From: Olli Lammi <olammi@olammi.iki.fi>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0806101259050.6742@zil.olammi.iki.fi>
MIME-Version: 1.0
Subject: [linux-dvb] High load with Terratec Cinergy 1200 DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

Hello!
------

I recently moved to area where only DVB-T is available and changed my
DVB-C-cards to two Terratec Cinergy 1200 DVB-T cards. However adding
one card lifted the load of my server to approx 0.8 and adding the
second card to approx 1.6. No processes are consuming the processor time so I 
think the high load is due to dvb driver or kernel.

Is this a known problem and is there a workaround available?. I tried to search 
the net for answers but found none.

Some info about the problem:

The distribution: Fedora Core 6
The kernel:       2.6.22.14-72.fc6

   % uname -a
   Linux zil 2.6.22.14-72.fc6 #1 SMP Wed Nov 21 15:12:59 EST 2007 i686 i686 i386 
GNU/Linux
   %

The card firmware:

   % ls -la /lib/firmware/dvb*
   -rw-r--r-- 1 root root 24478 May 22 23:07 /lib/firmware/dvb-fe-tda10046.fw
   %

   Jun 10 04:01:21 zil kernel: tda1004x: setting up plls for 53MHz sampling 
clock
   Jun 10 04:01:21 zil kernel: tda1004x: found firmware revision 20 -- ok


Boot log about the cards:

Linux video capture interface: v2.00
saa7146: register extension 'budget_av'.
saa7146: found saa7146 @ mem e0986000 (revision 1, irq 22) (0x153b,0x1157).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
adapter failed MAC signature check
encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-0: MAC addr = 00:0a:ac:01:ea:a8
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
budget-av: ci interface initialised.
saa7146: found saa7146 @ mem e4bb0000 (revision 1, irq 23) (0x153b,0x1157).
saa7146 (1): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
adapter failed MAC signature check
encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-1: MAC addr = 00:0a:ac:01:ea:c4
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
budget-av: ci interface initialised.


I run oprofile on the server approximately idle and with the 1.6 load average 
with the following results. Seems that the most time is spent in the dvb_core 
kernel module:

CPU: P4 / Xeon, speed 2732.57 MHz (estimated)
Counted GLOBAL_POWER_EVENTS events (time during which processor is not stopped)
with a unit mask of 0x01 (mandatory) count 100000
GLOBAL_POWER_E...|
   samples|      %|
------------------
       684 21.2687 dvb_core
       646 20.0871 libc-2.5.so
       554 17.2264 vdr
         GLOBAL_POWER_E...|
           samples|      %|
         ------------------
               490 88.4477 vdr
                64 11.5523 anon (tgid:2235 range:0x287000-0x288000)
       364 11.3184 saa7146
       223  6.9341 bash
         GLOBAL_POWER_E...|
           samples|      %|
         ------------------
               217 97.3094 bash
                 6  2.6906 anon (tgid:27354 range:0x2f4000-0x2f5000)
       114  3.5448 ext3
        91  2.8296 oprofiled
         GLOBAL_POWER_E...|


Yours and any help appreciated

Olli Lammi
Pirkkala, Finland

--------------------------------------------------------------------------
Olli Lammi                    olammi@iki.fi               +358 40 580 7666
--------------------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
