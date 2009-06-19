Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:60757 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZFSEUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 00:20:38 -0400
Received: by pxi27 with SMTP id 27so1516201pxi.33
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 21:20:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245199671.7551.6.camel@pc07.localdom.local>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <1244414375.3823.11.camel@pc07.localdom.local>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
	 <1245199671.7551.6.camel@pc07.localdom.local>
Date: Fri, 19 Jun 2009 13:50:40 +0930
Message-ID: <4d5f8630906182120j6f49cd85sd459c14d05c8b722@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S
From: James Moschou <james.moschou@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>, paul10@planar.id.au,
	braddo@tranceaddict.net, Terry Wu <terrywu2009@gmail.com>,
	Sander Pientka <cumulus0007@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have this card and tried testing the tree at
http://kernellabs.com/hg/~mkrufky/dtv1000s
revision b0f29c0cff4b

No directory was created at /dev/dvb/

'uname -r' gives:
2.6.28-11-generic
which is the Ubuntu 9.04 kernel
(I don't know how to get a vanilla kernel .. sorry)

I'm new at this so I've probably missed something.

Cheers
James Moschou


dmesg:

[    8.760626] Linux video capture interface: v2.00
[    8.866353] saa7130/34: v4l2 driver version 0.2.15 loaded
[    8.866402] saa7134 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.866407] saa7130[0]: found at 0000:05:01.0, rev: 1, irq: 19,
latency: 32, mmio: 0xfb002000
[    8.866412] saa7130[0]: subsystem: 107d:6655, board:
UNKNOWN/GENERIC [card=0,autodetected]
[    8.866446] saa7130[0]: board init: gpio is 22000
[    9.003970] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    9.004018] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.016031] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[    9.016040] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff
ff ff ff ff ff ff ff
[    9.016047] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08
ff 00 8a ff ff ff ff
[    9.016055] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016063] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff
04 ff ff ff ff ff ff
[    9.016070] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016078] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016086] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016093] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016101] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016109] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016116] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016124] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016131] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016139] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016147] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.016233] saa7130[0]: registered device video0 [v4l2]
[    9.016255] saa7130[0]: registered device vbi0
[    9.016295] rt2400pci 0000:05:00.0: PCI INT A -> GSI 20 (level,
low) -> IRQ 20
[    9.023349] phy0: Selected rate control algorithm 'pid'
[    9.035477] saa7134 ALSA driver for DMA sound loaded
[    9.035480] saa7130[0]/alsa: UNKNOWN/GENERIC doesn't support digital audio
[    9.072159] Registered led device: rt2400pci-phy0:radio
[    9.072188] Registered led device: rt2400pci-phy0:quality
[    9.160446] lp0: using parport0 (interrupt-driven).
[    9.215527] Adding 6024332k swap on /dev/sda5.  Priority:-1
extents:1 across:6024332k
[    9.742418] EXT4 FS on sda1, internal journal on sda1:8
[   10.459797] kjournald starting.  Commit interval 5 seconds
[   10.460001] EXT3 FS on sda3, internal journal
[   10.460005] EXT3-fs: mounted filesystem with ordered data mode.
[   10.651876] type=1505 audit(1245383427.708:2):
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
name2="default" pid=2071
[   10.682712] type=1505 audit(1245383427.740:3):
operation="profile_load" name="/sbin/dhclient-script" name2="default"
pid=2075
[   10.682784] type=1505 audit(1245383427.740:4):
operation="profile_load" name="/sbin/dhclient3" name2="default"
pid=2075
[   10.682814] type=1505 audit(1245383427.740:5):
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default"
pid=2075
[   10.682841] type=1505 audit(1245383427.740:6):
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" name2="default"
pid=2075
[   10.769197] type=1505 audit(1245383427.828:7):
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
name2="default" pid=2080
[   10.769316] type=1505 audit(1245383427.828:8):
operation="profile_load" name="/usr/sbin/cupsd" name2="default"
pid=2080
[   10.788943] type=1505 audit(1245383427.848:9):
operation="profile_load" name="/usr/sbin/tcpdump" name2="default"
pid=2084
[   13.193914] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   13.193918] vboxdrv: Successfully done.
[   13.193919] vboxdrv: Found 2 processor cores.
[   13.193986] VBoxDrv: dbg - g_abExecMemory=ffffffffa0cfaaa0
[   13.194000] vboxdrv: fAsync=0 offMin=0x196 offMax=0x842
[   13.194034] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[   13.194036] vboxdrv: Successfully loaded version 2.1.4_OSE
(interface 0x000a0009).
[   13.398592] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0e99940
[   18.940421] r8169: eth0: link down
[   18.940722] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.973408] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.877161] wlan0: authenticate with AP 00:1d:92:15:2a:f1
[   30.878778] wlan0: authenticated
[   30.878781] wlan0: associate with AP 00:1d:92:15:2a:f1
[   30.881169] wlan0: RX AssocResp from 00:1d:92:15:2a:f1 (capab=0x11
status=0 aid=2)
[   30.881172] wlan0: associated
[   30.881994] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   41.552008] wlan0: no IPv6 routers present
