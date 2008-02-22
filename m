Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1ME4dbl017794
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 09:04:39 -0500
Received: from mail.connortechnology.com (mail.penultima.org [69.90.217.122])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1ME47Rx005409
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 09:04:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.connortechnology.com (Postfix) with ESMTP id B505B1CC7D4A
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 09:04:06 -0500 (EST)
Received: from mail.connortechnology.com ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o3a+JV6r5I4q for <video4linux-list@redhat.com>;
	Fri, 22 Feb 2008 09:04:02 -0500 (EST)
Received: from lily.connortechnology.com
	(CPE001a704cd3cf-CM000f9fa6074e.cpe.net.cable.rogers.com
	[99.229.210.43])
	by mail.connortechnology.com (Postfix) with ESMTP id 15A361CC7D4B
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 09:04:02 -0500 (EST)
To: video4linux-list@redhat.com
Content-Disposition: inline
From: Isaac Connor <iconnor@penultima.org>
Date: Fri, 22 Feb 2008 09:04:01 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Message-Id: <200802220904.01465.iconnor@penultima.org>
Subject: Unsupported cards
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


Hello all,

I'm trying to build a dvr out of some proprietary capture cards, which appear 
to be relatively standard bt878s.  

One of these cards is the 4 input, 4 capture interfaces kind, and the other I 
believe is a 4 input, 1 capture interface kind.  

So I have /dev/video0-4, and I can get garbled but recognizable video on 1 
through 4, but not 0.  

This is on 2.6.24-8 from ubuntu hardy. 




Here is the relevant lspci

00:0c.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video 
Capture [109e:036e] (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f5e00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f5f00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


02:00.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video 
Capture [109e:036e] (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f9800000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f9900000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-



02:01.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video 
Capture [109e:036e] (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f9e00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:01.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f9f00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:02.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video 
Capture [109e:036e] (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f9a00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-



02:02.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f9b00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:03.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video 
Capture [109e:036e] (rev 11)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f9c00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:03.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f9d00000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


And dmesg
[ 1741.664512] bttv: driver version 0.9.17 loaded
[ 1741.664515] bttv: using 8 buffers with 2080k (520 pages) each for capture
[ 1741.665064] bttv: Bt8xx card found (0).
[ 1741.665072] bttv0: Bt878 (rev 17) at 0000:00:0c.0, irq: 17, latency: 64, 
mmio: 0xf5e00000
[ 1741.665564] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1741.665579] bttv0: gpio: en=00000000, out=00000000 in=00f360ff [init]
[ 1754.178889] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[ 1754.178897] bttv0: tuner type unset
[ 1754.178899] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[ 1760.569877] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[ 1766.964857] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[ 1773.365948] bttv0: registered device video0
[ 1773.366286] bttv0: registered device vbi0
[ 1773.366515] bttv: Bt8xx card found (1).
[ 1773.366530] bttv1: Bt878 (rev 17) at 0000:02:00.0, irq: 18, latency: 64, 
mmio: 0xf9800000
[ 1773.367040] bttv1: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1773.367068] bttv1: gpio: en=00000000, out=00000000 in=008ff000 [init]
[ 1773.391920] bttv1: tuner type unset
[ 1773.391923] bttv1: i2c: checking for MSP34xx @ 0x80... not found
[ 1773.421888] bttv1: i2c: checking for TDA9875 @ 0xb0... not found
[ 1773.422718] bttv1: i2c: checking for TDA7432 @ 0x8a... not found
[ 1773.425285] bttv1: registered device video1
[ 1773.425624] bttv1: registered device vbi1
[ 1773.425851] bttv: Bt8xx card found (2).
[ 1773.425866] bttv2: Bt878 (rev 17) at 0000:02:01.0, irq: 19, latency: 64, 
mmio: 0xf9e00000
[ 1773.426427] bttv2: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1773.426461] bttv2: gpio: en=00000000, out=00000000 in=008ffffd [init]
[ 1773.451243] bttv2: tuner type unset
[ 1773.451246] bttv2: i2c: checking for MSP34xx @ 0x80... not found
[ 1773.498324] bttv2: i2c: checking for TDA9875 @ 0xb0... not found
[ 1773.499163] bttv2: i2c: checking for TDA7432 @ 0x8a... not found
[ 1773.501633] bttv2: registered device video2
[ 1773.501978] bttv2: registered device vbi2
[ 1773.502207] bttv: Bt8xx card found (3).
[ 1773.502222] bttv3: Bt878 (rev 17) at 0000:02:02.0, irq: 16, latency: 64, 
mmio: 0xf9a00000
[ 1773.502745] bttv3: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1773.502772] bttv3: gpio: en=00000000, out=00000000 in=008ffffe [init]
[ 1773.528543] bttv3: tuner type unset
[ 1773.528546] bttv3: i2c: checking for MSP34xx @ 0x80... not found
[ 1773.558097] bttv3: i2c: checking for TDA9875 @ 0xb0... not found
[ 1773.558923] bttv3: i2c: checking for TDA7432 @ 0x8a... not found
[ 1773.561409] bttv3: registered device video3
[ 1773.561744] bttv3: registered device vbi3
[ 1773.561974] bttv: Bt8xx card found (4).
[ 1773.561989] bttv4: Bt878 (rev 17) at 0000:02:03.0, irq: 17, latency: 64, 
mmio: 0xf9c00000
[ 1773.562493] bttv4: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[ 1773.562520] bttv4: gpio: en=00000000, out=00000000 in=008fffff [init]
[ 1773.588377] bttv4: tuner type unset
[ 1773.588381] bttv4: i2c: checking for MSP34xx @ 0x80... not found
[ 1773.616806] bttv4: i2c: checking for TDA9875 @ 0xb0... not found
[ 1773.636770] bttv4: i2c: checking for TDA7432 @ 0x8a... not found
[ 1773.639350] bttv4: registered device video4
[ 1773.639703] bttv4: registered device vbi4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
