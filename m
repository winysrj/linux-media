Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7ENWXa2012707
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 19:32:33 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7ENWMeZ025897
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 19:32:22 -0400
Received: by wf-out-1314.google.com with SMTP id 25so627517wfc.6
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 16:32:22 -0700 (PDT)
Message-ID: <443ddfb30808141632l30b6fbefgda1bb2a1f6bbe028@mail.gmail.com>
Date: Fri, 15 Aug 2008 06:32:21 +0700
From: "Nakarin Lamangthong" <lnakarin@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Commell MP-878D first time error
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

Hi,All
I'm newbie for LinuxTV, I have a Capture Mini-pci Card form Commell MP-878D
and install on my Debian Etch.

#dmesg
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:00:0e.0, irq: 10, latency: 16, mmio:
0xefffe000
bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
tveeprom 0-0050: Huh, no eeprom present (err=-121)?
bttv0: tuner type unset
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878_probe: card id=[0x0], Unknown card.
Exiting..
bt878: probe of 0000:00:0e.1 failed with error -22

#lspci -vvnn
00:0e.0 Multimedia video controller [0400]: Brooktree Corporation Bt878
Video Capture [109e:036e] (rev 11)
   Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
   Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
   Latency: 16 (4000ns min, 10000ns max)
   Interrupt: pin A routed to IRQ 10
   Region 0: Memory at efffe000 (32-bit, prefetchable) [size=4K]
   Capabilities: [44] Vital Product Data
   Capabilities: [4c] Power Management version 2
      Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
      Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio
Capture [109e:0878] (rev 11)
   Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
   Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
   Interrupt: pin A routed to IRQ 10
   Region 0: Memory at efffd000 (32-bit, prefetchable) [size=4K]
   Capabilities: [44] Vital Product Data
   Capabilities: [4c] Power Management version 2
      Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
      Status: D0 PME-Enable- DSel=0 DScale=0 PME-

How do i fix this error?

bt878_probe: card id=[0x0], Unknown card.
Exiting..
bt878: probe of 0000:00:0e.1 failed with error -22

Thanks.
Lnakarin
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
