Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1230 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbZBXUyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 15:54:35 -0500
Received: from oortje-fw.romunt.nl (sdroesen.demon.nl [83.160.1.25])
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id n1OKsR3F028789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 21:54:32 +0100 (CET)
	(envelope-from rudy@grumpydevil.homelinux.org)
Received: from hermes.romunt.nl (hermes.romunt.nl [192.168.1.35])
	by oortje-fw.romunt.nl (8.14.1/8.14.1) with ESMTP id n1OKsRxv027058
	for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 21:54:27 +0100
Received: from [192.168.1.98] (IDENT:506@kheldar.romunt.nl [192.168.1.98])
	by hermes.romunt.nl (8.14.1/8.14.1) with ESMTP id n1OKsOkH008638
	for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 21:54:24 +0100
Message-ID: <49A45E80.6090301@grumpydevil.homelinux.org>
Date: Tue, 24 Feb 2009 21:54:24 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: recording problems with CAM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm having some issues. Bad recordings, and always accompanied with the 
following:

[10968.525453] saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[10975.963186] saa7146 (2) vpeirq: used 55 times >80% of buffer (163372 
bytes now)
[10977.657955] saa7146 (1) vpeirq: used 50 times >80% of buffer (65612 
bytes now)
[11007.664262] saa7146 (1) vpeirq: used 53 times >80% of buffer (61476 
bytes now)
[11027.255507] mythbackend used greatest stack depth: 4632 bytes left
[11031.825410] saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[11031.856008] saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[11046.460153] saa7146 (2) vpeirq: used 15 times >80% of buffer (65424 
bytes now)
[11062.372011] saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[11062.404008] saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[11069.971794] saa7146 (2) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[11076.466498] saa7146 (2) vpeirq: used 13 times >80% of buffer (61476 
bytes now)
[11088.314244] saa7146 (1) vpeirq: used 37 times >80% of buffer (65424 
bytes now)
[11106.473733] saa7146 (2) vpeirq: used 6 times >80% of buffer (65612 
bytes now)
[11118.320611] saa7146 (1) vpeirq: used 4 times >80% of buffer (61476 
bytes now)
[11136.480108] saa7146 (2) vpeirq: used 2 times >80% of buffer (65424 
bytes now)
[11148.327846] saa7146 (1) vpeirq: used 1 times >80% of buffer (65612 
bytes now)
[11166.486493] saa7146 (2) vpeirq: used 3 times >80% of buffer (61476 
bytes now)


System info:

C2D system, with lspci output as follows:

root@repeater:~# lspci
00:00.0 Host bridge: Intel Corporation E7230/3000/3010 Memory Controller 
Hub (rev c0)
00:01.0 PCI bridge: Intel Corporation E7230/3000/3010 PCI Express Root 
Port (rev c0)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI 
Express Port 5 (rev 01)
00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI 
Express Port 6 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC 
Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE 
Controller (rev 01)
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA 
AHCI Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
01:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI 
Express Bridge
01:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI 
Express Bridge
02:0e.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
09:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge 
A (rev 09)
09:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt 
Controller A (rev 09)
0a:01.0 SCSI storage controller: Marvell Technology Group Ltd. 
MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
0d:00.0 Ethernet controller: Intel Corporation 82573E Gigabit Ethernet 
Controller (Copper) (rev 03)
0e:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet 
Controller
0f:00.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics 
Innovation) Volari Z7/Z9/Z9s
0f:02.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
0f:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
0f:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

Currently thinking to disable USB and see whether that helps (based on 
assumption i have interupt problems).

Any ideas are welcome.

Cheers,

Rudy
