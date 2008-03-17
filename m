Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2HK3DgL012275
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 16:03:13 -0400
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2HK2RdQ024750
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 16:02:28 -0400
Message-ID: <47DECFDE.80202@tmr.com>
Date: Mon, 17 Mar 2008 16:09:02 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <47DC4331.7040100@rogers.com>	<1205622683.4814.13.camel@pc08.localdom.local>	<47DC6303.2040802@rogers.com>	<47DC9B27.50601@tmr.com>
	<47DD5D0D.9020600@rogers.com> <47DDF01C.7080207@tmr.com>
In-Reply-To: <47DDF01C.7080207@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: CityK <cityk@rogers.com>
Subject: Re: ATI "HDTV Wonder" audio
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

Bill Davidsen wrote:
>
> I don't see any such thing. I doubt attachments are allowed, but I'll 
> just put "lspci -n" at the end of this post.
Well, that post just vanished, let me try again.

lspci -n

00:00.0 0600: 8086:2570 (rev 02)
00:01.0 0604: 8086:2571 (rev 02)
00:1d.0 0c03: 8086:24d2 (rev 02)
00:1d.1 0c03: 8086:24d4 (rev 02)
00:1d.2 0c03: 8086:24d7 (rev 02)
00:1d.3 0c03: 8086:24de (rev 02)
00:1d.7 0c03: 8086:24dd (rev 02)
00:1e.0 0604: 8086:244e (rev c2)
00:1f.0 0601: 8086:24d0 (rev 02)
00:1f.1 0101: 8086:24db (rev 02)
00:1f.3 0c05: 8086:24d3 (rev 02)
00:1f.5 0401: 8086:24d5 (rev 02)
01:00.0 0300: 1002:5159
02:03.0 0c00: 1106:3044 (rev 46)
02:04.0 0104: 1106:3164 (rev 06)
02:05.0 0200: 10b7:1700 (rev 12)
02:09.0 0180: 105a:4d69 (rev 02)
02:0c.0 0400: 14f1:8800 (rev 05)
02:0c.1 0480: 14f1:8801 (rev 05)
02:0c.2 0480: 14f1:8802 (rev 05)


lspci



00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
Controller/Host-Hub Interface (rev 02)
00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller 
(rev 02)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
Controller (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER 
(ICH5/ICH5R) AC'97 Audio Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY 
[Radeon 7000/VE]
02:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host 
Controller (rev 46)
02:04.0 RAID bus controller: VIA Technologies, Inc. VT6410 ATA133 RAID 
controller (rev 06)
02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T 
[Marvell] (rev 12)
02:09.0 Mass storage controller: Promise Technology, Inc. 20269 (rev 02)
02:0c.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video 
and Audio Decoder (rev 05)
02:0c.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [Audio Port] (rev 05)
02:0c.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [MPEG Port] (rev 05)

lspci -vv (video only)

02:0c.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: ATI Technologies Inc HDTV Wonder
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f4000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx8800
        Kernel modules: cx8800

02:0c.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: ATI Technologies Inc Unknown device a101
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

02:0c.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: ATI Technologies Inc Unknown device a101
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802


Hope this gets through!

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
