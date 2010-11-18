Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <frank-info@gmx.de>) id 1PIyzt-0006Oe-Vg
	for linux-dvb@linuxtv.org; Thu, 18 Nov 2010 08:33:34 +0100
Received: from mailout-de.gmx.net ([213.165.64.22] helo=mail.gmx.net)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with smtp
	for <linux-dvb@linuxtv.org>
	id 1PIyzt-0006xV-8C; Thu, 18 Nov 2010 08:33:33 +0100
From: Frank Wohlfahrt <frank-info@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 18 Nov 2010 08:33:32 +0100
References: <mailman.0.1290063176.21965.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.0.1290063176.21965.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201011180833.32137.frank-info@gmx.de>
Subject: [linux-dvb] cx23885 crashes with TeVii S470
Reply-To: linux-media@vger.kernel.org, frank-info@gmx.de
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

I have a  TeVii S470 installed on the only PCIe slot of my MSI H55M-ED55.

The driver crashes about 50% already immediately after booting, but also some 
time afterwards, working properly until then.

[  190.764711] ds3000_firmware_ondemand: Waiting for firmware upload 
(dvb-fe-ds3000.fw)...
[  190.764722] cx23885 0000:02:00.0: firmware: requesting dvb-fe-ds3000.fw
[  190.767173] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[  193.151417] cx23885[0]: mpeg risc op code error
[  193.151427] cx23885[0]: TS1 B - dma channel status dump
[  193.151434] cx23885[0]:   cmds: init risc lo   : 0x2390e000
[  193.151440] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  193.151446] cx23885[0]:   cmds: cdt base       : 0x00010580
[  193.151451] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  193.151456] cx23885[0]:   cmds: iq base        : 0x00010400
[  193.151462] cx23885[0]:   cmds: iq size        : 0x00000010
[  193.151468] cx23885[0]:   cmds: risc pc lo     : 0x2390e1cc
[  193.151473] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  193.151478] cx23885[0]:   cmds: iq wr ptr      : 0x00004103
...

The related source module is (I think): cx23885-core.c

Only yesterday I had the error during shutdown (preventing the system to 
switch off):

[ 5021.188012] cx23885 0000:02:00.0: PCI INT A disabled
[ 5021.211443] saa7146: unregister extension 'dvb'.
[ 5021.243256] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 5021.243262] IP: [<ef9824ce>] v4l2_device_unregister+0x1e/0x50 [videodev]
[ 5021.243272] *pde = 76190067 
[ 5021.243274] Oops: 0000 [#1] SMP 
[ 5021.243277] last sysfs 
file: /sys/devices/pci0000:00/0000:00:1c.3/0000:02:00.0/firmware/0000:02:00.0/loading

I don't know if this failure has something to do with the problem above.

The software I use is Ubuntu Lucid (Kernel 2.6.32-25-generic) coming with the 
VDR distribution yavdr 0.3.

The firmware for the card is from packet "linux-firmware-yavdr" Version: 
1.1-3yavdr1 
-rw-r--r--  1 root root    8192 2010-07-18 21:54 dvb-fe-ds3000.fw

I get the same problems using the original kernel module from 2.6.32 or the 
DKMS modules from v4l-dvb-dkms (0~20101018.15139) or s2-liplianin-dkms 
(0~20101016.14629).

I think I have a hardware problem and I just have to know wether it can be 
fixed with maybe BIOS settings or if I have to get a different DVB-S2 card. 
What is the reason for a "mpeg risc op code error" ?

Thanks in advance !!

TeVii S470:
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video 
and Audio Decoder (rev 02)

Rest of the system:
Intel Core i3 530,+ Hauppauge Nexus-s 2.2 (PCI slot)

cx23885               117401  6 
cx2341x                12404  1 cx23885
v4l2_common            16390  2 cx23885,cx2341x
videodev               36345  3 saa7146_vv,cx23885,v4l2_common
v4l1_compat            13251  1 videodev
videobuf_dma_sg        10782  2 saa7146_vv,cx23885
videobuf_dvb            5096  1 cx23885

Frank Wohlfahrt

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
