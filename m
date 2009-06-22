Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:57567 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFVKvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 06:51:03 -0400
Received: by pxi40 with SMTP id 40so59381pxi.33
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 03:51:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840906191228t7222e21dyc2c221bb5d9e22bb@mail.gmail.com>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <1244414375.3823.11.camel@pc07.localdom.local>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
	 <1245199671.7551.6.camel@pc07.localdom.local>
	 <4d5f8630906182120j6f49cd85sd459c14d05c8b722@mail.gmail.com>
	 <4d5f8630906182203h739363aeu85996062f282e106@mail.gmail.com>
	 <6ab2c27e0906190110p196f709fp2aefbfc0063f334c@mail.gmail.com>
	 <4d5f8630906190242w1af2ad66u79e0f96ccf613afe@mail.gmail.com>
	 <1245430287.3985.5.camel@pc07.localdom.local>
	 <37219a840906191228t7222e21dyc2c221bb5d9e22bb@mail.gmail.com>
Date: Mon, 22 Jun 2009 20:21:04 +0930
Message-ID: <4d5f8630906220351w7c6e233fg8aea5d72f51466e9@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S
From: James Moschou <james.moschou@gmail.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>, paul10@planar.id.au,
	braddo@tranceaddict.net, Sander Pientka <cumulus0007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using dtv1000s tree revision 21a03349f7f9 and a blank modprobe.conf

I can tune to channels but never all of them in the single run of w_scan.
Every time I run w_scan it's different channels that say 'filter timeout'.

Thanks

dmesg:

[    8.616658] Linux video capture interface: v2.00
[    8.617868] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.617983] iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0460)
[    8.618051] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.640551] cfg80211: Calling CRDA to update world regulatory domain
[    8.672107] usb-storage: device scan complete
[    8.672472] scsi 6:0:0:0: Direct-Access     HDS72251 2VLAT20
       PQ: 0 ANSI: 0
[    8.673583] sd 6:0:0:0: [sdb] 241254720 512-byte hardware sectors:
(123 GB/115 GiB)
[    8.674583] sd 6:0:0:0: [sdb] Write Protect is off
[    8.674585] sd 6:0:0:0: [sdb] Mode Sense: 33 00 00 00
[    8.674587] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.675207] sd 6:0:0:0: [sdb] 241254720 512-byte hardware sectors:
(123 GB/115 GiB)
[    8.676206] sd 6:0:0:0: [sdb] Write Protect is off
[    8.676208] sd 6:0:0:0: [sdb] Mode Sense: 33 00 00 00
[    8.676209] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.676212]  sdb: sdb1
[    8.686155] sd 6:0:0:0: [sdb] Attached SCSI disk
[    8.686249] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    8.692894] cfg80211: World regulatory domain updated:
[    8.692897] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    8.692899] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.692901] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.692902] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.692904] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.692905] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.751513] saa7130/34: v4l2 driver version 0.2.15 loaded
[    8.751560] saa7134 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.751566] saa7130[0]: found at 0000:05:01.0, rev: 1, irq: 19,
latency: 32, mmio: 0xfb002000
[    8.751570] saa7130[0]: subsystem: 107d:6655, board: Leadtek
Winfast DTV1000S [card=169,autodetected]
[    8.751596] saa7130[0]: board init: gpio is 320f0
[    8.894105] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    8.894152] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.900531] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[    8.900540] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff
ff ff ff ff ff ff ff
[    8.900548] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08
ff 00 8a ff ff ff ff
[    8.900556] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900564] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff
04 ff ff ff ff ff ff
[    8.900571] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900579] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900587] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900594] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900602] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900610] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900617] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900625] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900633] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900640] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.900648] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    8.960522] Chip ID is not zero. It is not a TEA5767
[    8.960585] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
[    9.000528] tda8290: no gate control were provided!
[    9.000677] saa7130[0]: registered device video0 [v4l2]
[    9.000699] saa7130[0]: registered device vbi0
[    9.000770] rt2400pci 0000:05:00.0: PCI INT A -> GSI 20 (level,
low) -> IRQ 20
[    9.007810] phy0: Selected rate control algorithm 'pid'
[    9.016421] saa7134 ALSA driver for DMA sound loaded
[    9.016423] saa7130[0]/alsa: Leadtek Winfast DTV1000S doesn't
support digital audio
[    9.049880] dvb_init() allocating 1 frontend
[    9.126582] Registered led device: rt2400pci-phy0:radio
[    9.126595] Registered led device: rt2400pci-phy0:quality
[    9.188392] tda18271 0-0060: creating new instance
[    9.197061] TDA18271HD/C1 detected @ 0-0060
[    9.224779] lp0: using parport0 (interrupt-driven).
[    9.281001] Adding 6024332k swap on /dev/sda5.  Priority:-1
extents:1 across:6024332k
[    9.600014] DVB: registering new adapter (saa7130[0])
[    9.600018] DVB: registering adapter 0 frontend 1 (NXP TDA10048HN DVB-T)...
[    9.808965] EXT4 FS on sda1, internal journal on sda1:8
[    9.928529] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[    9.928533] saa7134 0000:05:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   10.189256] tda10048_firmware_upload: firmware read 24878 bytes.
[   10.189258] tda10048_firmware_upload: firmware uploading
[   10.590423] kjournald starting.  Commit interval 5 seconds
[   10.590638] EXT3 FS on sda3, internal journal
[   10.590641] EXT3-fs: mounted filesystem with ordered data mode.
[   10.910083] type=1505 audit(1245666255.972:2):
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
name2="default" pid=2149
[   10.950358] type=1505 audit(1245666256.012:3):
operation="profile_load" name="/sbin/dhclient-script" name2="default"
pid=2153
[   10.950431] type=1505 audit(1245666256.012:4):
operation="profile_load" name="/sbin/dhclient3" name2="default"
pid=2153
[   10.950460] type=1505 audit(1245666256.012:5):
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default"
pid=2153
[   10.950487] type=1505 audit(1245666256.012:6):
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" name2="default"
pid=2153
[   11.037810] type=1505 audit(1245666256.100:7):
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
name2="default" pid=2158
[   11.037928] type=1505 audit(1245666256.100:8):
operation="profile_load" name="/usr/sbin/cupsd" name2="default"
pid=2158
[   11.069004] type=1505 audit(1245666256.132:9):
operation="profile_load" name="/usr/sbin/tcpdump" name2="default"
pid=2162
[   14.152988] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   14.152991] vboxdrv: Successfully done.
[   14.152992] vboxdrv: Found 2 processor cores.
[   14.153045] VBoxDrv: dbg - g_abExecMemory=ffffffffa0d6baa0
[   14.153057] vboxdrv: fAsync=0 offMin=0x1c7 offMax=0x114f
[   14.153090] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[   14.153091] vboxdrv: Successfully loaded version 2.1.4_OSE
(interface 0x000a0009).
[   14.296027] tda10048_firmware_upload: firmware uploaded
[   14.358264] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0f0a940
[   19.936638] r8169: eth0: link down
[   19.936927] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.969400] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.688671] wlan0: authenticate with AP 00:1d:92:15:2a:f1
[   31.690188] wlan0: authenticated
[   31.690191] wlan0: associate with AP 00:1d:92:15:2a:f1
[   31.692578] wlan0: RX AssocResp from 00:1d:92:15:2a:f1 (capab=0x11
status=0 aid=2)
[   31.692581] wlan0: associated
[   31.693322] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   42.220025] wlan0: no IPv6 routers present
