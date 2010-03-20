Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <olejl77@gmail.com>) id 1Nt26h-00051H-VU
	for linux-dvb@linuxtv.org; Sat, 20 Mar 2010 18:05:06 +0100
Received: from mail-fx0-f219.google.com ([209.85.220.219])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nt26h-00060C-8o; Sat, 20 Mar 2010 18:05:03 +0100
Received: by fxm19 with SMTP id 19so1482797fxm.1
	for <linux-dvb@linuxtv.org>; Sat, 20 Mar 2010 10:05:02 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Mar 2010 20:05:01 +0300
Message-ID: <19619f3b1003201005m6493681at20130b37022b9a00@mail.gmail.com>
From: OJ <olejl77@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with decrypting dvb-s channels
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

I have a Technotrend S-1500 DVB card:
04:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Device 1017
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_ci dvb
	Kernel modules: budget-ci

$ dmesg | grep dvb
[   17.596948] saa7146: register extension 'budget_ci dvb'.
[   17.673434] budget_ci dvb 0000:04:01.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[   17.742536] input: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/input/input7
[   17.851584] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[   26.880221] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[  769.995583] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 2017.120157] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 2034.781417] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[265057.101369] dvb_ca adapter 0: DVB CAM detected and initialised successfully


I have tried several players. MythTV, MPlayer, Kaffeine. All of them
shows unencrypted channels OK, but will not play any of the encrypted
channels.

This was working fine a couple of months back with the same HW. My
MythTV frontend was broken so I did not use the system. When I tried
again now it is not working as described above.

I have tried to boot an older kernel, and the same problem exists. As
I see it it is probably a HW problem, but what do you think is my
faulty HW? I would prefer not to buy all new (DVB-S card, CI, and
CAM).

Is it possible somehow to find out what is the faulty unit?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
