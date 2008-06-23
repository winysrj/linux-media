Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cijoml@compare.cz>) id 1KAmJR-0003Ww-Sg
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 15:42:33 +0200
References: <200806231507.23832.hofrichter@freenet.de>
In-Reply-To: <200806231507.23832.hofrichter@freenet.de>
From: "CIJOML" <cijoml@volny.cz>
To: Christian Hofrichter <hofrichter@freenet.de>
Date: Mon, 23 Jun 2008 15:42:25 +0200
Mime-Version: 1.0
Message-Id: <20080623134225.B5C1FB892@nebuchadnezzar.smejdil.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] irq overflow
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Christian, 

please check: 

http://bugzilla.kernel.org/show_bug.cgi?id=7471
http://bugzilla.kernel.org/show_bug.cgi?id=7472
http://bugzilla.kernel.org/show_bug.cgi?id=7473
http://bugzilla.kernel.org/show_bug.cgi?id=8304 

looks like nobody cares about this HW. 

Michal 

Christian Hofrichter writes: 

> I have a problem with my dvb-t satelco easywatch mobile set (pluto2 chipset). 
> When I tune 
> the card to a tv channel and receive the signal I get an irq overflow . The 
> overflow is followed by picture and sound 
> distortions and happens in a interval of exactly 30 seconds. It is a pcmcia 
> card running with kernel 2.6.25 and the pluto2 module. 
> 
> 
> ------------- 
> 
> cat /proc/interrupts
> 0:     138089  local-APIC-edge      timer
>   1:          8   IO-APIC-edge      i8042
>   8:          0   IO-APIC-edge      rtc
>  12:        135   IO-APIC-edge      i8042
>  14:      42402   IO-APIC-edge      ide0
>  15:      49216   IO-APIC-edge      ide1
>  17:      39835   IO-APIC-fasteoi   ATI IXP, ATI IXP Modem, fglrx[0]@PCI:1:5:0
>  19:      66941   IO-APIC-fasteoi   ohci_hcd:usb1, ehci_hcd:usb2,ohci_hcd:usb3
>  20:     489269   IO-APIC-fasteoi   yenta, pluto2
>  21:        649   IO-APIC-fasteoi   acpi, tifm_7xx1, firewire_ohci
>  22:     147830   IO-APIC-fasteoi   b43
>  23:      54524   IO-APIC-fasteoi   eth0
> NMI:          0   Non-maskable interrupts
> LOC:    7128518   Local timer interrupts
> TRM:          0   Thermal event interrupts
> THR:          0   Threshold APIC interrupts
> SPU:          0   Spurious interrupts
> ERR:          0 
> 
>  
> 
> ----------------- 
> 
> dmesg
> pccard: card ejected from slot 0
> pccard: CardBus card inserted into slot 0
> PCI: Enabling device 0000:03:00.0 (0000 -> 0002)
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 20 (level, low) -> IRQ 20
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> DVB: registering new adapter (pluto2)
> pluto2 0000:03:00.0: board revision 2.15
> pluto2 0000:03:00.0: S/N 13320542100301
> pluto2 0000:03:00.0: MAC 00:d0:16:03:bb:9c
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 53MHz sampling clock
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> tda1004x: found firmware revision 20 -- ok
> pluto2 0000:03:00.0: overflow irq (1) 
> 
> 
> ------------------- 
> 
>  
> 
> tzap -c channels.conf XXX
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file 'channels.conf'
> ..
> ..
> ..
> status 00 | signal 9b9b | snr abab | ber 0001fffe | unc 00000000 |
> status 1f | signal 9c9c | snr fcfc | ber 0000011a | unc ffffffff | FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 0000005c | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 9b9b | snr fefe | ber 00000072 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 00000078 | unc 00000000 | FE_HAS_LOCK
> ...
> ... 
> 
> 
> -------------- 
> 
> /var/log/messages 
> 
> tda1004x: setting up plls for 53MHz sampling clock
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> tda1004x: found firmware revision 20 -- ok
> pluto2 0000:03:00.0: overflow irq (1)
> ta1004x: setting up plls for 53MHz sampling clock
> tda1004x: found firmware revision 20 -- ok
> pluto2 0000:03:00.0: overflow irq (1)
> APIC error on CPU0: 40(40)
> pluto2 0000:03:00.0: overflow irq (1)
> pluto2 0000:03:00.0: overflow irq (1) 
> 
>  
> 
> Note the apic error seems unrelated as booting with noapic doesn't change
> anything. 
> 
> 
> ----------------- 
> 
> lspci -vv:
> 00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 64 
> 
> 00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal
> decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 00006000-00006fff
>         Memory behind bridge: d0300000-d03fffff
>         Prefetchable memory behind bridge: 00000000c0000000-00000000c7ffffff
>         Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
>         Capabilities: [44] HyperTransport: MSI Mapping
>         Capabilities: [b0] Subsystem: Hewlett-Packard Company Unknown device
> 308b 
> 
> 00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal
> decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
>         I/O behind bridge: 00004000-00005fff
>         Memory behind bridge: cc000000-cfffffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Express Root Port (Slot+) IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
>                 Device: Latency L0s <64ns, L1 <1us
>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 247
>                 Link: Latency L0s <64ns, L1 <1us
>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x16
>                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
>                 Slot: Number 2, PowerLimit 10.000000
>                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>                 Slot: AttnInd Off, PwrInd Off, Power-
>                 Root: Correctable- Non-Fatal- Fatal- PME-
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000
>         Capabilities: [b0] Subsystem: Hewlett-Packard Company Unknown device
> 308b
>         Capabilities: [b8] HyperTransport: MSI Mapping
>         Capabilities: [100] Advanced Error Reporting 
> 
> 00:05.0 PCI bridge: ATI Technologies Inc Unknown device 5a37 (prog-if 00
> [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=20, subordinate=20, sec-latency=0
>         I/O behind bridge: 00002000-00003fff
>         Memory behind bridge: c8000000-cbffffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>         Capabilities: [50] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Express Root Port (Slot+) IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
>                 Device: Latency L0s <64ns, L1 <1us
>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 247
>                 Link: Latency L0s <64ns, L1 <1us
>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x16
>                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
>                 Slot: Number 3, PowerLimit 6.500000
>                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>                 Slot: AttnInd Off, PwrInd Off, Power-
>                 Root: Correctable- Non-Fatal- Fatal- PME-
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000
>         Capabilities: [b0] Subsystem: Hewlett-Packard Company Unknown device
> 308b
>         Capabilities: [b8] HyperTransport: MSI Mapping
>         Capabilities: [100] Advanced Error Reporting 
> 
> 00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
> (prog-if 10 [OHCI])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 19
>         Region 0: Memory at d0400000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
> (prog-if 10 [OHCI])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 19
>         Region 0: Memory at d0401000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller
> (prog-if 20 [EHCI])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 19
>         Region 0: Memory at d0402000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>                 Bridge: PM- B3+
>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Region 0: I/O ports at 8200 [size=16]
>         Region 1: Memory at d0403000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [b0] HyperTransport: MSI Mapping 
> 
> 00:14.1 IDE interface: ATI Technologies Inc Standard Dual Channel PCI IDE
> Controller ATI (prog-if 8a [Master SecP PriP])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=1]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=1]
>         Region 4: I/O ports at 7010 [size=16]
>         Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0 
> 
> 00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge (prog-if 01
> [Subtractive decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64
>         Bus: primary=00, secondary=02, subordinate=06, sec-latency=64
>         I/O behind bridge: 00001000-00001fff
>         Memory behind bridge: d0000000-d02fffff
>         Prefetchable memory behind bridge: 50000000-53ffffff
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B- 
> 
> 00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 
> Audio
> Controller (rev 02)
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 64 (500ns min), Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 17
>         Region 0: Memory at d0404000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:14.6 Modem: ATI Technologies Inc ATI SB400 - AC'97 Modem Controller (rev 
> 02)
> (prog-if 00 [Generic])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 64 (500ns min), Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 17
>         Region 0: Memory at d0405000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit- 
> Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000 
> 
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> HyperTransport Technology Configuration
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Capabilities: [80] HyperTransport: Host or Secondary Interface
>                 !!! Possibly incomplete decoding
>                 Command: WarmRst+ DblEnd-
>                 Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
> <CRCErr=0
>                 Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>                 Revision ID: 1.02 
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
> Address
> Map
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR- 
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
> Controller
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR- 
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR- 
> 
> 01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M
> 5955 (PCIE) (prog-if 00 [VGA])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B+
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 255 (2000ns min), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at c0000000 (32-bit, prefetchable) [size=128M]
>         Region 1: I/O ports at 6000 [size=256]
>         Region 2: Memory at d0300000 (32-bit, non-prefetchable) [size=64K]
>         [virtual] Expansion ROM at d0320000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
> 
> 02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 Gigabit
> Ethernet (rev 03)
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0 (16000ns min)
>         Interrupt: pin A routed to IRQ 23
>         Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
>         Expansion ROM at <ignored> [disabled]
>         Capabilities: [48] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
>         Capabilities: [50] Vital Product Data
>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ 
> Queue=0/3
> Enable-
>                 Address: ffef3ffffffff7f8  Data: ffff 
> 
> 02:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g]
> 802.11g Wireless LAN Controller (rev 02)
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 64
>         Interrupt: pin A routed to IRQ 22
>         Region 0: Memory at d0010000 (32-bit, non-prefetchable) [size=8K] 
> 
> 02:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 168, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at d0012000 (32-bit, non-prefetchable) [size=4K]
>         Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
>         Memory window 0: 50000000-53fff000 (prefetchable)
>         Memory window 1: 54000000-57fff000
>         I/O window 0: 00001000-000010ff
>         I/O window 1: 00001400-000014ff
>         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
>         16-bit legacy interface ports at 0001 
> 
> 02:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host
> Controller (prog-if 10 [OHCI])
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
>         Interrupt: pin C routed to IRQ 21
>         Region 0: Memory at d0013000 (32-bit, non-prefetchable) [size=2K]
>         Region 1: Memory at d0014000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+ 
> 
> 02:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
> FlashMedia Controller
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin B routed to IRQ 21
>         Region 0: Memory at d0018000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
> 
> 02:04.4 Generic system peripheral [0805]: Texas Instruments PCI6411, PCI6421,
> PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Secure Digital (SD)
> Controller
>         Subsystem: Hewlett-Packard Company MX6125
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 64 bytes
>         Interrupt: pin C routed to IRQ 9
>         Region 0: Memory at d001a000 (32-bit, non-prefetchable) [size=256]
>         Region 1: Memory at d001b000 (32-bit, non-prefetchable) [size=256]
>         Region 2: Memory at d001c000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
> 
> 03:00.0 Multimedia video controller: SCM Microsystems, Inc. Pluto2 DVB-T
> Receiver for PCMCIA [EasyWatch MobilSet]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort-
> <MAbort- >SERR- <PERR-
>         Latency: 64
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at 54000200 (32-bit, non-prefetchable) [size=128]
>         Region 1: Memory at 54000000 (32-bit, non-prefetchable) [size=512]
>         Capabilities: [78] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME- 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
