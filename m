Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61206 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFST21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 15:28:27 -0400
Received: by ewy6 with SMTP id 6so2846826ewy.37
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 12:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245430287.3985.5.camel@pc07.localdom.local>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <1244414375.3823.11.camel@pc07.localdom.local>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
	 <1245199671.7551.6.camel@pc07.localdom.local>
	 <4d5f8630906182120j6f49cd85sd459c14d05c8b722@mail.gmail.com>
	 <4d5f8630906182203h739363aeu85996062f282e106@mail.gmail.com>
	 <6ab2c27e0906190110p196f709fp2aefbfc0063f334c@mail.gmail.com>
	 <4d5f8630906190242w1af2ad66u79e0f96ccf613afe@mail.gmail.com>
	 <1245430287.3985.5.camel@pc07.localdom.local>
Date: Fri, 19 Jun 2009 15:28:27 -0400
Message-ID: <37219a840906191228t7222e21dyc2c221bb5d9e22bb@mail.gmail.com>
Subject: Re: Leadtek Winfast DTV-1000S
From: Michael Krufky <mkrufky@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: James Moschou <james.moschou@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>, paul10@planar.id.au,
	braddo@tranceaddict.net, Sander Pientka <cumulus0007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 12:51 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
> Hi all,
>
> Am Freitag, den 19.06.2009, 19:12 +0930 schrieb James Moschou:
>> 2009/6/19 Terry Wu <terrywu2009@gmail.com>:
>> > Hi,
>> >
>> >>>[    9.916022] saa7134 0000:05:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
>> >>>[   10.020209] tda10048_firmware_upload: Upload failed. (file not found?)
>> >
>> > The dvb-fe-tda10048-1.0.fw is needed.
>> > You can get it from the following links:
>> > http://tw1965.myweb.hinet.net/Linux/firmware.tar.gz
>> > http://tw1965.myweb.hinet.net/Linux/Firmware.txt
>> > http://tw1965.myweb.hinet.net/
>>
>> Firmware is copied to /lib/firmware
>>
>> Here is the dmesg:
>>
>> [    8.570412] Linux video capture interface: v2.00
>> [    8.617769] cfg80211: World regulatory domain updated:
>> [    8.617772]        (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [    8.617774]        (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    8.617775]        (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [    8.617777]        (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [    8.617778]        (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    8.617780]        (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [    8.680521] saa7130/34: v4l2 driver version 0.2.15 loaded
>> [    8.680571] saa7134 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
>> [    8.680576] saa7130[0]: found at 0000:05:01.0, rev: 1, irq: 19,
>> latency: 32, mmio: 0xfb002000
>> [    8.680581] saa7130[0]: subsystem: 107d:6655, board: Hauppauge
>
> Mike seems to have the subdevice wrong. He used 107d:6555.
>
> That is why the card is not auto detected.
>
> Please try to force card=169 and _not_ card=156.
>
> Cheers,
> Hermann
>
>
>> WinTV-HVR1110r3 DVB-T/Hybrid [card=156,insmod option]
>> [    8.680606] saa7130[0]: board init: gpio is 22009
>> [    8.827183] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
>> low) -> IRQ 22
>> [    8.827229] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [    8.860026] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43
>> 43 a9 1c 55 d2 b2 92
>> [    8.860035] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860043] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08
>> ff 00 8a ff ff ff ff
>> [    8.860051] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860059] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff
>> 04 ff ff ff ff ff ff
>> [    8.860067] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860074] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860082] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860089] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860097] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860105] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860112] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860120] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860127] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860135] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860143] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    8.860152] tveeprom 0-0050: Encountered bad packet header [ff].
>> Corrupt or not a Hauppauge eeprom.
>> [    8.860154] saa7130[0]: warning: unknown hauppauge model #0
>> [    8.860156] saa7130[0]: hauppauge eeprom: model=0
>> [    8.932026] Chip ID is not zero. It is not a TEA5767
>> [    8.932091] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
>> [    8.976009] tda8290: no gate control were provided!
>> [    8.976079] tuner 0-0060: Tuner has no way to set tv freq
>> [    8.976084] tuner 0-0060: Tuner has no way to set tv freq
>> [    8.976170] saa7130[0]: registered device video0 [v4l2]
>> [    8.976214] saa7130[0]: registered device vbi0
>> [    8.976251] saa7130[0]: registered device radio0
>> [    8.976281] rt2400pci 0000:05:00.0: PCI INT A -> GSI 20 (level,
>> low) -> IRQ 20
>> [    8.983389] phy0: Selected rate control algorithm 'pid'
>> [    9.017796] dvb_init() allocating 1 frontend
>> [    9.036163] saa7134 ALSA driver for DMA sound loaded
>> [    9.036165] saa7130[0]/alsa: Hauppauge WinTV-HVR1110r3 DVB-T/Hybrid
>> doesn't support digital audio
>> [    9.068118] Registered led device: rt2400pci-phy0:radio
>> [    9.068149] Registered led device: rt2400pci-phy0:quality
>> [    9.140897] tda18271 0-0060: creating new instance
>> [    9.148509] TDA18271HD/C1 detected @ 0-0060
>> [    9.157831] lp0: using parport0 (interrupt-driven).
>> [    9.215386] Adding 6024332k swap on /dev/sda5.  Priority:-1
>> extents:1 across:6024332k
>> [    9.552013] DVB: registering new adapter (saa7130[0])
>> [    9.552017] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
>> [    9.745332] EXT4 FS on sda1, internal journal on sda1:8
>> [    9.880021] tda10048_firmware_upload: waiting for firmware upload
>> (dvb-fe-tda10048-1.0.fw)...
>> [    9.880026] saa7134 0000:05:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
>> [   10.122198] tda10048_firmware_upload: firmware read 24878 bytes.
>> [   10.122200] tda10048_firmware_upload: firmware uploading
>> [   14.208023] tda10048_firmware_upload: firmware uploaded
>> [   15.543408] kjournald starting.  Commit interval 5 seconds
>> [   15.543414] EXT3-fs warning: maximal mount count reached, running
>> e2fsck is recommended
>> [   15.543631] EXT3 FS on sda3, internal journal
>> [   15.543635] EXT3-fs: mounted filesystem with ordered data mode.
>> [   15.685601] type=1505 audit(1245401016.744:2):
>> operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
>> name2="default" pid=2176
>> [   15.716585] type=1505 audit(1245401016.776:3):
>> operation="profile_load" name="/sbin/dhclient-script" name2="default"
>> pid=2180
>> [   15.716655] type=1505 audit(1245401016.776:4):
>> operation="profile_load" name="/sbin/dhclient3" name2="default"
>> pid=2180
>> [   15.716685] type=1505 audit(1245401016.776:5):
>> operation="profile_load"
>> name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default"
>> pid=2180
>> [   15.716715] type=1505 audit(1245401016.776:6):
>> operation="profile_load"
>> name="/usr/lib/connman/scripts/dhclient-script" name2="default"
>> pid=2180
>> [   15.803103] type=1505 audit(1245401016.860:7):
>> operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
>> name2="default" pid=2185
>> [   15.803222] type=1505 audit(1245401016.860:8):
>> operation="profile_load" name="/usr/sbin/cupsd" name2="default"
>> pid=2185
>> [   15.822910] type=1505 audit(1245401016.880:9):
>> operation="profile_load" name="/usr/sbin/tcpdump" name2="default"
>> pid=2189
>> [   18.218867] vboxdrv: Trying to deactivate the NMI watchdog permanently...
>> [   18.218871] vboxdrv: Successfully done.
>> [   18.218872] vboxdrv: Found 2 processor cores.
>> [   18.219598] VBoxDrv: dbg - g_abExecMemory=ffffffffa0d45aa0
>> [   18.219615] vboxdrv: fAsync=0 offMin=0x18f offMax=0xa87
>> [   18.219649] vboxdrv: TSC mode is 'synchronous', kernel timer mode
>> is 'normal'.
>> [   18.219651] vboxdrv: Successfully loaded version 2.1.4_OSE
>> (interface 0x000a0009).
>> [   18.424201] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0ee4940
>> [   23.941064] r8169: eth0: link down
>> [   23.941353] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [   23.974950] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   35.688600] wlan0: authenticate with AP 00:1d:92:15:2a:f1
>> [   35.694520] wlan0: authenticated
>> [   35.694523] wlan0: associate with AP 00:1d:92:15:2a:f1
>> [   35.712689] wlan0: RX AssocResp from 00:1d:92:15:2a:f1 (capab=0x11
>> status=0 aid=2)
>> [   35.712692] wlan0: associated
>> [   35.713033] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   45.940041] wlan0: no IPv6 routers present
>>
>>
>> I'm having trouble tuning to anything, I think because the pci slot I
>> put the card in is right below the wireless card, and the router is in
>> the same room, and I'm using a portable antenna (which is supposed to
>> amplify the signal though).
>>
>> Doing 'femon -a 0' gives
>> status       | signal dcdc | snr 005b | ber 0000ffff | unc 00000000 |
>> So I guess I need to play around with the setup first
>>
>> Thanks
>> James

I fixed the PCI Subsystem ID typo.  (Thanks for pointing it out, Hermann)

I fixed the missing 3.8 MHz entry from the pll_tab (Thanks for
pointing it out, Terry)

This explains the broken tuning for 7 MHz DVB-T, and should work for
both c1 and c2 flavors of the tuner.

Please test again.

-Mike
