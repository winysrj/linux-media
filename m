Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TI7j4M029175
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 14:07:45 -0400
Received: from rs25s12.datacenter.cha.cantv.net
	(rs25s12.datacenter.cha.cantv.net [200.44.33.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TI7XnG029727
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 14:07:33 -0400
Received: from uqbar.local (dC9D2EDB6.dslam-15-9-46-07-1-01.alf.dsl.cantv.net
	[201.210.237.182])
	by rs25s12.datacenter.cha.cantv.net (8.13.8/8.13.0/3.0) with ESMTP id
	m3TI7R7L019680
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 13:37:27 -0430
Received: from uqbar.local (localhost.localdomain [127.0.0.1])
	by uqbar.local (8.14.2/8.14.2/Debian-3) with ESMTP id m3TI7Vop018129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 13:37:31 -0430
Received: (from emilio@localhost)
	by uqbar.local (8.14.2/8.14.2/Submit) id m3TI7VTm018128
	for video4linux-list@redhat.com; Tue, 29 Apr 2008 13:37:31 -0430
From: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Apr 2008 13:37:30 -0430
Message-Id: <1209492450.16986.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: MCE TV Philips 7135 Cardbus don't work
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

Hello,

I have purchased a "MCE TV Philips 7135 Cardbus" and I'm to set it up.
When I plug it, the module saa7134 is being loaded and dmesg says:

﻿pccard: CardBus card inserted into slot 0
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
PCI: Enabling device 0000:06:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, low) -> IRQ 17
saa7133[0]: found at 0000:06:00.0, rev: 209, irq: 17, latency: 0, mmio:
0x54000000
PCI: Setting latency timer of device 0000:06:00.0 to 64
saa7133[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
[card=0,autodetected]
saa7133[0]: board init: gpio is e2c0c0
saa7133[0]: Huh, no eeprom present (err=-5)?
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0

Since card is not detected, I've typed some little bash script to unload
(rmmod) and load again saa7134 module with modprobe adding "card=n"
parameter with n from 1 to 117 and execute tvtime each time module is
being loaded with different card number (The tuner module I've not
reloaded with different values). Note that a message of no EEPROM
present is issued by saa7134 module! ﻿This is related specifically to
the tuner?

﻿None of these 117 cards works in tv mode, some of these have not
"Television" input facility, others have "Composite1", "Composite2",
"S-Video" and some others have "TV (mono)" but in "Television" mode,
almost in all cases a blue screen is showed.

﻿﻿Here, the television norm is NTSC; I'm using Debian lenny with
2.6.24-amd64 kernel. Cardbus controller according to lspci is:

05:09.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus
Controller

and the output of "lspci -vv" regarding this TV card is:

﻿06:00.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
Video Broadcast Decoder (rev d1)
        Subsystem: Philips Semiconductors Unknown device 0000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at 54000000 (32-bit, non-prefetchable)
[size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Anyone has this card working or has some idea about the correct
combination of card and tuner number?

TIA
Regards.
-- 
Emilio Lazo Zaia <emiliolazozaia@gmail.com>
Facultad de Ciencias, UCV

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
