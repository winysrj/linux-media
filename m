Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.23]:47635 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753093Ab0L1Lbv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 06:31:51 -0500
Content-Type: text/plain; charset="utf-8"
Date: Tue, 28 Dec 2010 12:31:48 +0100
From: ConiKost@gmx.de
Message-ID: <20101228113148.283060@gmx.net>
MIME-Version: 1.0
Subject: Unable to load xc3028L-v36.fw [Hauppauge WinTV 1400]
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi guys,
I am trying to get working my Hauppauge WinTV 1400 expresscard. Actually, i've got using the 2.6.36-gentoo-r5 kernel (gentoo-sources).

First, I've enabled all necessary module (cx23885).
After inserting the card, i get this messages:

pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
pci 0000:05:00.0: reg 10: [mem 0x00000000-0x001fffff 64bit]
pci 0000:05:00.0: supports D1 D2
pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf01fffff 64bit]
pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf01fffff 64bit] (PCI address [0xf0000000-0xf01fffff]
pcieport 0000:00:1c.3: PCI bridge to [bus 05-0c]
pcieport 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pcieport 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
pcieport 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
pcieport 0000:00:1c.3: setting latency timer to 64
pci 0000:05:00.0: no hotplug settings from platform
cx23885 0000:05:00.0: enabling device (0000 -> 0002)
cx23885 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
CORE cx23885[1]: subsystem: 0070:8010, board: Hauppauge WinTV-HVR1400 [card=9,autodetected]
tveeprom 8-0050: Hauppauge model 80019, rev B2F1, serial# 3757209
tveeprom 8-0050: MAC address is 00:0d:fe:39:54:99
tveeprom 8-0050: tuner model is Xceive XC3028L (idx 151, type 4)
tveeprom 8-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
tveeprom 8-0050: audio processor is CX23885 (idx 39)
tveeprom 8-0050: decoder processor is CX23885 (idx 33)
tveeprom 8-0050: has radio
cx23885[1]: hauppauge eeprom: model=80019
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[1]: cx23885 based dvb card
xc2028 9-0064: creating new instance
xc2028 9-0064: type set to XCeive xc2028/xc3028 tuner
DVB: registering new adapter (cx23885[1])
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[1]/0: found at 0000:05:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xf0000000
cx23885 0000:05:00.0: setting latency timer to 64
cx23885 0000:05:00.0: irq 48 for MSI/MSI-X

So, as you can see, the card is found and the driver is loaded. So, when I now try to start the tuning, it will fail. For example, I try to scan for the dvb-t channels:

dvbscan /usr/share/dvb/dvb-t/de-Niedersachsen

This command will fail, it says tuning failed.

DMESG says now:
xc2028 9-0064: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware
xc2028 9-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 9-0064: i2c output error: rc = -6 (should be 64)
xc2028 9-0064: -6 returned from send
xc2028 9-0064: Error -22 while loading base firmware

The firmware could be loaded. Any ideas, how this could be fixed?
-- 
Gruß
ConiKost

