Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <a-j@a-j.ru>) id 1QI2V7-0002RL-9B
	for linux-dvb@linuxtv.org; Thu, 05 May 2011 19:38:33 +0200
Received: from smtp1.mtw.ru ([93.95.97.34])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1QI2V6-0007IH-JA; Thu, 05 May 2011 19:38:09 +0200
Received: from 8MYHG4J.512bytes.com (unknown [81.200.112.228])
	(Authenticated sender: aj-a-j)
	by smtp1.mtw.ru (Postfix) with ESMTPA id B520B44BAB6
	for <linux-dvb@linuxtv.org>; Thu,  5 May 2011 21:34:10 +0400 (MSD)
Date: Thu, 5 May 2011 21:38:06 +0400
From: Andrew Junev <a-j@a-j.ru>
Message-ID: <1908281867.20110505213806@a-j.ru>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
Reply-To: linux-media@vger.kernel.org, Andrew Junev <a-j@a-j.ru>
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
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hello All,

  I'm  trying  to set up a TeVii S470 DVB-S2 card for use in my MythTV
  system  running  on  Fedora 13. I already have a couple of TT S-1401
  cards in that machine, and it works fine.

  I  copied   the  firmware for my S470 as described on the Wiki page.
  The  card is detected  and seem to work. I am able to watch existing
  channels, and even found some DVB-S2 transponders.

  But  the  machine  is  very  unstable. After a while, I get a lot of
  errors in my /var/log/messages , like:

May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xb2(error=-5)
May  3 22:35:51 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0x03, value == 0x11)
May  3 22:35:51 localhost kernel: ds3000_tuner_writereg: writereg error(err == -5, reg == 0x42, value == 0x73)
May  3 22:35:51 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0x03, value == 0x11)
May  3 22:35:51 localhost kernel: ds3000_tuner_writereg: writereg error(err == -5, reg == 0x05, value == 0x01)
May  3 22:35:51 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0x03, value == 0x11)
May  3 22:35:51 localhost kernel: ds3000_tuner_writereg: writereg error(err == -5, reg == 0x62, value == 0xf5)

May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)
May  3 22:35:51 localhost kernel: ds3000_readreg: reg=0xd(error=-5)


There   are   a  lot  of  lines  like  these  in the log (tens or even
hundreds  per  second).  And  at some point the machine just freezes -
stops  responding  completely.  It  happens  even  if I'm not watching
anything.

If I take the S470 out, my machine works just fine again.


Some more info from the log - perhaps something could be useful:

May  2 20:39:15 localhost kernel: Linux video capture interface: v2.00
May  2 20:39:15 localhost kernel: cx23885 driver version 0.0.2 loaded
May  2 20:39:15 localhost kernel: cx23885 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
May  2 20:39:15 localhost kernel: LNBx2x attached on addr=8
May  2 20:39:15 localhost kernel: DVB: registering adapter 0 frontend 0 (Philips TDA10086 DVB-S)...
May  2 20:39:15 localhost kernel: budget dvb 0000:06:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
May  2 20:39:15 localhost kernel: CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
May  2 20:39:15 localhost kernel: IRQ 18/: IRQF_DISABLED is not guaranteed on shared IRQs
May  2 20:39:15 localhost kernel: saa7146: found saa7146 @ mem fb3f4800 (revision 1, irq 18) (0x13c2,0x1018).
May  2 20:39:15 localhost kernel: saa7146 (1): dma buffer size 192512
May  2 20:39:15 localhost kernel: DVB: registering new adapter (TT-Budget-S-1401 PCI)
May  2 20:39:15 localhost kernel: adapter has MAC addr = 00:d0:5c:0b:01:2d
May  2 20:39:15 localhost kernel: LNBx2x attached on addr=8
May  2 20:39:15 localhost kernel: DVB: registering adapter 1 frontend 0 (Philips TDA10086 DVB-S)...
May  2 20:39:15 localhost kernel: cx23885_dvb_register() allocating 1 frontend(s)
May  2 20:39:15 localhost kernel: cx23885[0]: cx23885 based dvb card
May  2 20:39:15 localhost kernel: DS3000 chip version: 0.192 attached.
May  2 20:39:15 localhost kernel: DVB: registering new adapter (cx23885[0])
May  2 20:39:15 localhost kernel: DVB: registering adapter 2 frontend 0 (Montage Technology DS3000/TS2020)...
May  2 20:39:15 localhost kernel: cx23885_dev_checkrevision() Hardware revision = 0xb0
May  2 20:39:15 localhost kernel: cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 18, latency: 0, mmio: 0xfe800000
May  2 20:39:15 localhost kernel: IRQ 18/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs


# uname -a
Linux mythbackend 2.6.34.8-68.fc13.i686.PAE #1 SMP Thu Feb 17 14:54:10 UTC 2011 i686 i686 i386 GNU/Linux
#


I searched the Net and found a similar question that was raised some time
ago, but there was not even a discussion on this topic...

If  someone  else  has  the  same  DVB-S  card  -  please  share  your
experience! I'd appreciate any ideas!

-- 
Best regards,
 Andrew                    


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
