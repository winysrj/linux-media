Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59084 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZFSIKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 04:10:43 -0400
Received: by ewy6 with SMTP id 6so2303459ewy.37
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 01:10:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d5f8630906182203h739363aeu85996062f282e106@mail.gmail.com>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <1244414375.3823.11.camel@pc07.localdom.local>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
	 <1245199671.7551.6.camel@pc07.localdom.local>
	 <4d5f8630906182120j6f49cd85sd459c14d05c8b722@mail.gmail.com>
	 <4d5f8630906182203h739363aeu85996062f282e106@mail.gmail.com>
Date: Fri, 19 Jun 2009 16:10:43 +0800
Message-ID: <6ab2c27e0906190110p196f709fp2aefbfc0063f334c@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S
From: Terry Wu <terrywu2009@gmail.com>
To: James Moschou <james.moschou@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>, paul10@planar.id.au,
	braddo@tranceaddict.net, Sander Pientka <cumulus0007@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>>[    9.916022] saa7134 0000:05:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
>>[   10.020209] tda10048_firmware_upload: Upload failed. (file not found?)

The dvb-fe-tda10048-1.0.fw is needed.
You can get it from the following links:
http://tw1965.myweb.hinet.net/Linux/firmware.tar.gz
http://tw1965.myweb.hinet.net/Linux/Firmware.txt
http://tw1965.myweb.hinet.net/

2009/6/19 James Moschou <james.moschou@gmail.com>:
> OK after adding 'options saa7134 card=156' to /etc/modprobe.d/modprobe.conf
> it loads correctly, thanks Brad.
>
> dmesg:
>
> [    8.438243] Linux video capture interface: v2.00
> [    8.606434] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    8.606440] nvidia 0000:01:00.0: setting latency timer to 64
> [    8.607114] NVRM: loading NVIDIA UNIX x86_64 Kernel Module
> 185.18.14  Wed May 27 01:23:47 PDT 2009
> [    8.626542] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [    8.659879] iTCO_vendor_support: vendor-support=0
> [    8.666626] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
> [    8.666736] iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0460)
> [    8.666811] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    8.742132] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    8.742181] saa7134 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [    8.742186] saa7130[0]: found at 0000:05:01.0, rev: 1, irq: 19,
> latency: 32, mmio: 0xfb002000
> [    8.742191] saa7130[0]: subsystem: 107d:6655, board: Hauppauge
> WinTV-HVR1110r3 DVB-T/Hybrid [card=156,insmod option]
> [    8.742214] saa7130[0]: board init: gpio is 22000
> [    8.852862] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
> low) -> IRQ 22
> [    8.852908] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    8.916022] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43
> 43 a9 1c 55 d2 b2 92
> [    8.916031] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff
> ff ff ff ff ff ff ff
> [    8.916039] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08
> ff 00 8a ff ff ff ff
> [    8.916046] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916054] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff
> 04 ff ff ff ff ff ff
> [    8.916062] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916069] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916077] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916085] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916092] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916100] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916108] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916115] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916123] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916131] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916138] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff
> [    8.916148] tveeprom 0-0050: Encountered bad packet header [ff].
> Corrupt or not a Hauppauge eeprom.
> [    8.916150] saa7130[0]: warning: unknown hauppauge model #0
> [    8.916151] saa7130[0]: hauppauge eeprom: model=0
> [    8.980528] Chip ID is not zero. It is not a TEA5767
> [    8.980592] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
> [    9.016010] tda8290: no gate control were provided!
> [    9.016080] tuner 0-0060: Tuner has no way to set tv freq
> [    9.016086] tuner 0-0060: Tuner has no way to set tv freq
> [    9.016171] saa7130[0]: registered device video0 [v4l2]
> [    9.016215] saa7130[0]: registered device vbi0
> [    9.016251] saa7130[0]: registered device radio0
> [    9.016387] rt2400pci 0000:05:00.0: PCI INT A -> GSI 20 (level,
> low) -> IRQ 20
> [    9.024385] phy0: Selected rate control algorithm 'pid'
> [    9.028685] saa7134 ALSA driver for DMA sound loaded
> [    9.028688] saa7130[0]/alsa: Hauppauge WinTV-HVR1110r3 DVB-T/Hybrid
> doesn't support digital audio
> [    9.060205] dvb_init() allocating 1 frontend
> [    9.093967] Registered led device: rt2400pci-phy0:radio
> [    9.093980] Registered led device: rt2400pci-phy0:quality
> [    9.150392] lp0: using parport0 (interrupt-driven).
> [    9.174892] tda18271 0-0060: creating new instance
> [    9.184029] TDA18271HD/C1 detected @ 0-0060
> [    9.211513] Adding 6024332k swap on /dev/sda5.  Priority:-1
> extents:1 across:6024332k
> [    9.588014] DVB: registering new adapter (saa7130[0])
> [    9.588018] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
> [    9.739258] EXT4 FS on sda1, internal journal on sda1:8
> [    9.916017] tda10048_firmware_upload: waiting for firmware upload
> (dvb-fe-tda10048-1.0.fw)...
> [    9.916022] saa7134 0000:05:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> [   10.020209] tda10048_firmware_upload: Upload failed. (file not found?)
> [   10.466227] kjournald starting.  Commit interval 5 seconds
> [   10.466428] EXT3 FS on sda3, internal journal
> [   10.466432] EXT3-fs: mounted filesystem with ordered data mode.
> [   10.616663] type=1505 audit(1245387419.676:2):
> operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
> name2="default" pid=2116
> [   10.647644] type=1505 audit(1245387419.704:3):
> operation="profile_load" name="/sbin/dhclient-script" name2="default"
> pid=2120
> [   10.647715] type=1505 audit(1245387419.704:4):
> operation="profile_load" name="/sbin/dhclient3" name2="default"
> pid=2120
> [   10.647747] type=1505 audit(1245387419.704:5):
> operation="profile_load"
> name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default"
> pid=2120
> [   10.647775] type=1505 audit(1245387419.704:6):
> operation="profile_load"
> name="/usr/lib/connman/scripts/dhclient-script" name2="default"
> pid=2120
> [   10.733586] type=1505 audit(1245387419.792:7):
> operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
> name2="default" pid=2125
> [   10.733704] type=1505 audit(1245387419.792:8):
> operation="profile_load" name="/usr/sbin/cupsd" name2="default"
> pid=2125
> [   10.753465] type=1505 audit(1245387419.812:9):
> operation="profile_load" name="/usr/sbin/tcpdump" name2="default"
> pid=2129
> [   13.133547] vboxdrv: Trying to deactivate the NMI watchdog permanently...
> [   13.133550] vboxdrv: Successfully done.
> [   13.133551] vboxdrv: Found 2 processor cores.
> [   13.134200] VBoxDrv: dbg - g_abExecMemory=ffffffffa0d4eaa0
> [   13.134216] vboxdrv: fAsync=0 offMin=0x1c7 offMax=0x18aa
> [   13.134252] vboxdrv: TSC mode is 'synchronous', kernel timer mode
> is 'normal'.
> [   13.134254] vboxdrv: Successfully loaded version 2.1.4_OSE
> (interface 0x000a0009).
> [   13.338753] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0eed940
> [   18.940672] r8169: eth0: link down
> [   18.940962] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   18.968910] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   30.988344] wlan0: authenticate with AP 00:1d:92:15:2a:f1
> [   31.008515] wlan0: authenticated
> [   31.008518] wlan0: associate with AP 00:1d:92:15:2a:f1
> [   31.010596] wlan0: RX AssocResp from 00:1d:92:15:2a:f1 (capab=0x11
> status=0 aid=2)
> [   31.010598] wlan0: associated
> [   31.011417] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   41.560010] wlan0: no IPv6 routers present
>
