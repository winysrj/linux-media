Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DLDhd9013007
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:13:43 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DLDTGU030634
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 17:13:29 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Roman <muzungu@gmx.net>
In-Reply-To: <48F3AA76.6030003@gmx.net>
References: <48F3AA76.6030003@gmx.net>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 23:06:43 +0200
Message-Id: <1223932003.6540.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: ASUSTeK P7131 Analog remote control does not work due to init
	sequence?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Montag, den 13.10.2008, 22:07 +0200 schrieb Roman:
> Hi  everyone
> 
> I am running a SUSE 11 and resently bought me a AsusTek My Cinema P7131
> Analog TV tuner card. The system (and so Yast) recognizes the card as a
> TV FM-7135 due to the Manufacturer ID codes. I have no clue why they did
> not give it a unique ID instead of sharing it with the FM-7135.
> 
> So I downloaded the lastest stable v4l archive and found that the card
> had been added to the saa7134 driver, deciding it to be a AsusTek My
> Cinema P7131 Analog according to the eeprom content. Since the archive
> did not compile on my machine, I started patching the changes into my
> source files (Kernel SUSE11/linux-2.6.25.16-0.1) manually.
> 
> Now what I found was that the saa7134_input_init1 takes place before
> reading the eeprom and re-adjusting the device from FM-7135 to P7131 Analog.
> What I did then, was:
> - set the has_remote field again, just after when it is decided that the
> FM-7135 is rather a P7131 Analog due to the eeprom.
> - I moved the saa7134_input_init1 from the init1 section to the init2
> section
> 
> For my card it now seems to work, but I have no clue what consequences
> this could have on others and if this is a proper solution. If the
> eeprom data is needed to recognize a card, may be all the init stuff
> should be done after that?
> 
> The numbers below where typed by remote conrtol, so I guess it is
> working with my patches:
> 
> earth:/usr/src/linux # 1234567890
> bash: 1234567890: command not found
> 
> 
> I: Bus=0001 Vendor=1043 Product=4845 Version=0001
> N: Name="saa7134 IR (ASUSTeK P7131 Analo"
> P: Phys=pci-0000:03:00.0/ir0
> S: Sysfs=/devices/pci0000:00/0000:00:10.0/0000:03:00.0/input/input6
> U: Uniq=
> H: Handlers=kbd event5
> B: EV=100003
> B: KEY=108c0322 2104000 0 0 0 0 10000 4180 801 9f16c0 0 0 10000ffc
> 
> What would you suggest is a proper solution?
> 
> I attached the manually patched and the original SUSE file plus a diff
> of the saa7134 directory and  /var/log/messages prints of some of my
> tests (with the additions of me)
> 
> Just another suggestion which will not help in my case:
> Why not taking the "has_remote" indicator in the saa7134_boards[] array
> of structs instead of switch-casing in int saa7134_board_init1(struct
> saa7134_dev *dev)? I would see this as some kind of device property,
> hence nothing dynamic. No critics, just an idea.
> 
> I would appreciate responses to what the driver developer see as a good
> solution and if you see the this little flaw in the driver the same way 
> I do.
> 
> Greets
> 
> Roman
> 
> PS: I can provide the code and a diff.
> 
> 
> Oct 11 13:34:08 earth kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> Oct 11 13:34:08 earth kernel: saa7133[0]: found at 0000:03:00.0, rev:
> 209, irq: 18, latency: 64, mmio: 0xfebff800
> Oct 11 13:34:08 earth kernel: saa7133[0]: subsystem: 1043:4845, board:
> ASUS TV-FM 7135 [card=53,autodetected]
> Oct 11 13:34:08 earth kernel: saa7133[0]: board init: gpio is 240000
> Oct 11 13:34:08 earth kernel: saa7133[0]/ir: saa7134_input_init1
> Oct 11 13:34:08 earth kernel: saa7133[0]/ir: saa7134_input_init1
> dev->has_remote=0
> Oct 11 13:34:09 earth kernel: tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> Oct 11 13:34:09 earth kernel: tda8290 2-004b: setting tuner address to 61
> Oct 11 13:34:09 earth kernel: tda8290 2-004b: type set to tda8290+75a
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 00: 43 10 45 48 54
> 20 1c 00 43 43 a9 1c 55 d2 b2 92
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff
> 20 ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 20: 01 40 01 02 03
> 01 01 03 08 ff 00 88 ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 40: ff 22 00 c2 96
> ff 02 30 15 ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:34:10 earth kernel: saa7133[0]: P7131 analog only, using entry
> of ASUSTeK P7131 Analog
> Oct 11 13:34:13 earth kernel: saa7133[0]: registered device video0 [v4l2]
> Oct 11 13:34:13 earth kernel: saa7133[0]: registered device vbi0
> Oct 11 13:34:13 earth kernel: saa7133[0]: registered device radio0
> Oct 11 13:34:56 earth dhcpcd[2661]: eth1: renewing lease of 192.168.1.2
> 
> Oct 11 13:40:13 earth kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> Oct 11 13:40:13 earth kernel: saa7133[0]: found at 0000:03:00.0, rev:
> 209, irq: 18, latency: 64, mmio: 0xfebff800
> Oct 11 13:40:13 earth kernel: saa7133[0]: subsystem: 1043:4845, board:
> ASUS TV-FM 7135 [card=53,autodetected]
> Oct 11 13:40:13 earth kernel: saa7133[0]: board init: gpio is 240000
> Oct 11 13:40:13 earth kernel: saa7133[0]/ir: saa7134_input_init1
> Oct 11 13:40:13 earth kernel: saa7133[0]/ir: saa7134_input_init1
> dev->has_remote=0
> Oct 11 13:40:13 earth kernel: tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> Oct 11 13:40:13 earth kernel: tda8290 2-004b: setting tuner address to 61
> Oct 11 13:40:13 earth kernel: tda8290 2-004b: type set to tda8290+75a
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 00: 43 10 45 48 54
> 20 1c 00 43 43 a9 1c 55 d2 b2 92
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff
> 20 ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 20: 01 40 01 02 03
> 01 01 03 08 ff 00 88 ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 40: ff 22 00 c2 96
> ff 02 30 15 ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 13:40:15 earth kernel: saa7133[0]: P7131 analog only, using entry
> of ASUSTeK P7131 Analog
> Oct 11 13:40:15 earth kernel: saa7134_board_init2: dev->has_remote=1.
> Oct 11 13:40:17 earth kernel: saa7133[0]: registered device video0 [v4l2]
> Oct 11 13:40:17 earth kernel: saa7133[0]: registered device vbi0
> Oct 11 13:40:17 earth kernel: saa7133[0]: registered device radio0
> Oct 11 13:42:40 earth kernel: type=1503 audit(1223725360.081:53):
> operation="inode_permission" requested_mask="::r" denied_mask="::r"
> fsuid=74 name="/var/lib/ntp/proc/3524/net/if_inet6" pid=3524
> profile="/usr/sbin/ntpd"
> Oct 11 13:45:01 earth /usr/sbin/cron[22497]: (roman) CMD
> (/etc/rke/mdstat/mdck.sh /etc/rke/mdstat/mdstat_ok.log)
> 
> Oct 11 14:13:00 earth kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
> Oct 11 14:13:00 earth kernel: saa7133[0]: found at 0000:03:00.0, rev:
> 209, irq: 18, latency: 64, mmio: 0xfebff800
> Oct 11 14:13:00 earth kernel: saa7133[0]: subsystem: 1043:4845, board:
> ASUS TV-FM 7135 [card=53,autodetected]
> Oct 11 14:13:00 earth kernel: saa7133[0]: board init: gpio is 240000
> Oct 11 14:13:00 earth kernel: saa7134_hwinit1:733: removed call to
> saa7134_input_init1(dev) here!
> Oct 11 14:13:00 earth kernel: tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> Oct 11 14:13:00 earth kernel: tda8290 2-004b: setting tuner address to 61
> Oct 11 14:13:01 earth kernel: tda8290 2-004b: type set to tda8290+75a
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 00: 43 10 45 48 54
> 20 1c 00 43 43 a9 1c 55 d2 b2 92
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff
> 20 ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 20: 01 40 01 02 03
> 01 01 03 08 ff 00 88 ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 30: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 40: ff 22 00 c2 96
> ff 02 30 15 ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 50: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 60: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 70: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 80: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom 90: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom a0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom b0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom c0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom d0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom e0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: i2c eeprom f0: ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff
> Oct 11 14:13:02 earth kernel: saa7133[0]: P7131 analog only, using entry
> of ASUSTeK P7131 Analog
> Oct 11 14:13:02 earth kernel: saa7134_board_init2:5367: dev->has_remote=1.
> Oct 11 14:13:02 earth kernel: saa7134_hwinit2:776: added call to
> saa7134_input_init1(dev) here!
> Oct 11 14:13:02 earth kernel: saa7133[0]/ir: saa7134_input_init1
> Oct 11 14:13:02 earth kernel: saa7133[0]/ir: saa7134_input_init1:402:
> SAA7134_BOARD_ASUSTeK_P7131_ANALOG
> Oct 11 14:13:02 earth kernel: input: saa7134 IR (ASUSTeK P7131 Analo as
> /devices/pci0000:00/0000:00:10.0/0000:03:00.0/input/input6
> Oct 11 14:13:04 earth kernel: saa7133[0]: registered device video0 [v4l2]
> Oct 11 14:13:04 earth kernel: saa7133[0]: registered device vbi0
> Oct 11 14:13:04 earth kernel: saa7133[0]: registered device radio0
> 

card=number, sorry forgot it, should work in all cases including the
remote for free.

Minimum report level is 2.6.26.1 stable.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
