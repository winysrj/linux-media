Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEMgLMX027994
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 17:42:21 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEMg5A9018955
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 17:42:05 -0500
Received: by yx-out-2324.google.com with SMTP id 31so670864yxl.81
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 14:42:05 -0800 (PST)
Message-ID: <ea3b75ed0811141442i1fc3bf3en5577bbb281b09e4e@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:42:04 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: v4l crash dump
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

Thanks ahead of time for looking at this
I have had the hardest time getting v4l2 to be stable on an intel quad
core.  If I pass maxcpus=1 at the kernel boot all seems to be ok.  If
I don't then see the dump below.

I'm using a 4 chip, 4 input video capture device.  I get all sorts of
crazy errors from time to time and lines that jump around occasionally
in the picture.

I have also tried kernel 2.6.24

# uname -r
2.6.26-1-amd64


# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2399.953
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4803.77
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2399.953
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4799.94
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2399.953
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4799.98
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 2399.953
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4799.96
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:         35          0          1          0   IO-APIC-edge      timer
  1:          7          8          6          5   IO-APIC-edge      i8042
  8:          4          3          2          5   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          0          0   IO-APIC-edge      ide0
 16:         31         31         30         31   IO-APIC-fasteoi
uhci_hcd:usb4, HDA Intel, i915@pci:0000:00:02.0
 18:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb3
 19:        714        707        714        714   IO-APIC-fasteoi
uhci_hcd:usb2, ata_piix
 20:        561        579        551        584   IO-APIC-fasteoi   bttv0
 21:        576        562        586        551   IO-APIC-fasteoi   bttv1
 22:        570        555        568        575   IO-APIC-fasteoi   bttv2
 23:          2          0          0          1   IO-APIC-fasteoi
uhci_hcd:usb1, ehci_hcd:usb5, bttv3
1276:        355        376        363        354   PCI-MSI-edge      eth12
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      28894      29424      18721      16437   Local timer interrupts
RES:        361        405        439        318   Rescheduling interrupts
CAL:      52823      82942      30311      82876   function call interrupts
TLB:        292        446        279        468   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
# lspci -vvv
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev 10)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel driver in use: agpgart-intel
        Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
Express Root Port (rev 10) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [88] Subsystem: Intel Corporation Device 0000
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4159
        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s
L1, Latency L0 <1us, L1 <8us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug- Surpise-
                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Off, PwrInd On, Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller (rev 10) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at e140 [size=8]
        Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at fe900000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Intel Corporation Device d608
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at feb80000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM
unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train-
SlotClk- DLActive- BWMgmt- ABWMgmt-
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surpise+
                        Slot #  1, PowerLimit 10.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4161
        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
Family) PCI Express Port 1
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
Unsupported+
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surpise+
                        Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4169
        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
Family) PCI Express Port 2
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at e080 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at e060 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at e040 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at e020 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at feb84000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=05, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Gammagraphx, Inc. Device 0000

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
        Subsystem: Intel Corporation DeskTop Board D945GTP
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information <?>
        Kernel modules: intel-rng, iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at e0f0 [size=16]
        Kernel driver in use: PIIX_IDE
        Kernel modules: piix

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA
IDE Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at e0e0 [size=8]
        Region 1: I/O ports at e0d0 [size=4]
        Region 2: I/O ports at e0c0 [size=8]
        Region 3: I/O ports at e0b0 [size=4]
        Region 4: I/O ports at e0a0 [size=16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: ata_piix
        Kernel modules: ata_piix

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
        Subsystem: Intel Corporation Device d608
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at e000 [size=32]
        Kernel driver in use: i801_smbus
        Kernel modules: i2c-i801

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Intel Corporation Device d608
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 1276
        Region 0: I/O ports at d000 [size=256]
        Region 2: Memory at fea20000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fea00000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data <?>
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
                Address: 00000000fee0f00c  Data: 4171
        Capabilities: [60] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency
L0s <128ns, L1 unlimited
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
AuxPwr+ TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [84] Vendor Specific Information <?>
        Kernel driver in use: r8169
        Kernel modules: r8169

04:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
(non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Bus: primary=04, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: d0000000-d00fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Capabilities: [90] CompactPCI hot-swap <?>
        Kernel modules: shpchp

05:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Subsystem: Device aa00:1460
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at d0007000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv

05:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
        Subsystem: Device aa00:1460
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 4
        Region 0: Memory at d0006000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Subsystem: Device aa01:1461
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at d0005000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv

05:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
        Subsystem: Device aa01:1461
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d0004000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Subsystem: Device aa02:1462
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at d0003000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv

05:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
        Subsystem: Device aa02:1462
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0002000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
        Subsystem: Device aa03:1463
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at d0001000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: bttv
        Kernel modules: bttv

05:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
        Subsystem: Device aa03:1463
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-



[    6.381613] Error: Driver 'pcspkr' is already registered, aborting...
[    6.395033] Linux video capture interface: v2.00
[    6.439131] bttv: driver version 0.9.17 loaded
[    6.439131] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    6.439131] bttv: Bt8xx card found (0).
[    6.439131] ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 20 (level,
low) -> IRQ 20
[    6.439131] bttv0: Bt878 (rev 17) at 0000:05:08.0, irq: 20,
latency: 32, mmio: 0xd0007000
[    6.439131] bttv0: detected: Provideo PV150A-1 [card=98], PCI
subsystem ID is aa00:1460
[    6.439131] bttv0: using: ProVideo PV150 [card=98,autodetected]
[    6.439131] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    6.439131] bttv0: tuner absent
[    6.439131] bttv0: registered device video0
[    6.439131] bttv0: registered device vbi0
[    6.439131] bttv0: PLL: 28636363 => 35468950 .. ok
[    6.473508] bttv: Bt8xx card found (1).
[    6.473575] ACPI: PCI Interrupt 0000:05:09.0[A] -> GSI 21 (level,
low) -> IRQ 21
[    6.473671] bttv1: Bt878 (rev 17) at 0000:05:09.0, irq: 21,
latency: 32, mmio: 0xd0005000
[    6.473775] bttv1: detected: Provideo PV150A-2 [card=98], PCI
subsystem ID is aa01:1461
[    6.473838] bttv1: using: ProVideo PV150 [card=98,autodetected]
[    6.473908] bttv1: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    6.473955] bttv1: tuner absent
[    6.474019] bttv1: registered device video1
[    6.474074] bttv1: registered device vbi1
[    6.474133] bttv1: PLL: 28636363 => 35468950 .. ok
[    6.507332] bttv: Bt8xx card found (2).
[    6.507396] ACPI: PCI Interrupt 0000:05:0a.0[A] -> GSI 22 (level,
low) -> IRQ 22
[    6.507492] bttv2: Bt878 (rev 17) at 0000:05:0a.0, irq: 22,
latency: 32, mmio: 0xd0003000
[    6.507592] bttv2: detected: Provideo PV150A-3 [card=98], PCI
subsystem ID is aa02:1462
[    6.507655] bttv2: using: ProVideo PV150 [card=98,autodetected]
[    6.507723] bttv2: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    6.507754] bttv2: tuner absent
[    6.507813] bttv2: registered device video2
[    6.507869] bttv2: registered device vbi2
[    6.507929] bttv2: PLL: 28636363 => 35468950 .. ok
[    6.538455] bttv: Bt8xx card found (3).
[    6.538516] ACPI: PCI Interrupt 0000:05:0b.0[A] -> GSI 23 (level,
low) -> IRQ 23
[    6.538611] bttv3: Bt878 (rev 17) at 0000:05:0b.0, irq: 23,
latency: 32, mmio: 0xd0001000
[    6.538712] bttv3: detected: Provideo PV150A-4 [card=98], PCI
subsystem ID is aa03:1463
[    6.538775] bttv3: using: ProVideo PV150 [card=98,autodetected]
[    6.538840] bttv3: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    6.538868] bttv3: tuner absent
[    6.538932] bttv3: registered device video3
[    6.538998] bttv3: registered device vbi3
[    6.539057] bttv3: PLL: 28636363 => 35468950 .. ok
[    7.223585] device-mapper: uevent: version 1.0.3
[    7.225288] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18)
initialised: dm-devel@redhat.com
[    7.701224] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended
[    8.102832] r8169: eth12: link up
[    8.102832] r8169: eth12: link up
[    8.631951] NET: Registered protocol family 10
[    8.631951] lo: Disabled Privacy Extensions
[   23.362216] eth12: no IPv6 routers present
[  149.357150] [drm] Initialized drm 1.1.0 20060810
[  149.360629] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
low) -> IRQ 16
[  149.360629] PCI: Setting latency timer of device 0000:00:02.0 to 64
[  149.360629] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  149.861955] set status page addr 0x00033000
[  172.981283] bttv1: PLL can sleep, using XTAL (28636363).
[  172.983834] bttv3: PLL can sleep, using XTAL (28636363).
[  172.986075] bttv0: PLL can sleep, using XTAL (28636363).
[  172.987869] bttv2: PLL can sleep, using XTAL (28636363).
[  179.076510] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  179.268632] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  179.435909] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  179.623871] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  179.817848] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  179.997406] bttv3: OCERR @ 1d0f4014,bits: HSYNC FDSR OCERR*
[  180.189643] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  180.374682] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  180.600824] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  180.799802] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  181.050771] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  181.262668] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  181.537543] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  181.700124] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  181.935864] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  182.164326] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  182.335303] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  182.545946] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  182.745264] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  182.915819] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  183.140187] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  183.288740] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  183.484794] bttv3: OCERR @ 1d0f4014,bits: HSYNC FDSR OCERR*
[  183.749446] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  183.997371] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  184.219831] bttv3: OCERR @ 1d0f4014,bits: HSYNC FDSR OCERR*
[  184.445697] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  185.583530] set status page addr 0x00033000
[  339.753937] set status page addr 0x00033000
[  368.855336] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  369.044538] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  369.225607] bttv3: OCERR @ 1d0f4014,bits: HSYNC FDSR OCERR*
[  369.463264] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  369.657251] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  369.805304] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.011221] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.186970] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.411518] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.591293] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.799313] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  370.987124] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  371.168187] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  371.402702] bttv3: OCERR @ 1d0f4014,bits: HSYNC FDSR OCERR*
[  371.589717] bttv3: OCERR @ 1d0f4000,bits: HSYNC FDSR OCERR*
[  372.649055] set status page addr 0x00033000
[  497.758781] set status page addr 0x00033000
[ 1115.633853] Eeek! page_mapcount(page) went negative! (-1)
[ 1115.633853]   page pfn = 18181
[ 1115.633853]   page->flags = 100000000000000
[ 1115.633853]   page->count = 2
[ 1115.633853]   page->mapping = 0000000000000000
[ 1115.638025]   vma->vm_ops = 0xffffffff80504800
[ 1115.638035]   vma->vm_ops->fault = filemap_fault+0x0/0x33d
[ 1115.638042]   vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x47
[ 1115.638070] ------------[ cut here ]------------
[ 1115.638072] kernel BUG at mm/rmap.c:669!
[ 1115.638074] invalid opcode: 0000 [1] SMP
[ 1115.638077] CPU 3
[ 1115.638080] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
dm_log dm_mod bttv firmware_class ir_common compat_ioctl32 videodev
v4l1_compat i2c_algo_bit v4l2_common videobuf_dma_sg videobuf_core
btcx_risc tveeprom rng_core i2c_i801 i2c_core shpchp pci_hotplug
iTCO_wdt snd_pcsp video output snd_hda_intel snd_pcm snd_timer snd
soundcore snd_page_alloc button intel_agp evdev ext2 mbcache sd_mod
usbhid hid ff_memless ata_piix ata_generic piix libata scsi_mod dock
ide_pci_generic ide_core ehci_hcd uhci_hcd r8169 thermal processor fan
thermal_sys
[ 1115.638113] Pid: 2437, comm: monitor Not tainted 2.6.26-1-amd64 #1
[ 1115.638115] RIP: 0010:[<ffffffff80287340>]  [<ffffffff80287340>]
page_remove_rmap+0xff/0x11b
[ 1115.638123] RSP: 0000:ffff8100165fbbe8  EFLAGS: 00010292
[ 1115.638125] RAX: 000000000000004a RBX: ffffe20000545438 RCX: 000000000000aea0
[ 1115.638127] RDX: 000000000000aea0 RSI: 0000000000000046 RDI: 0000000000000286
[ 1115.638129] RBP: ffff81001ec45298 R08: 00000000f7e00000 R09: ffff8100165fb600
[ 1115.638131] R10: 0000000000000000 R11: 0000000000000010 R12: ffff81001cdec080
[ 1115.638132] R13: 00000000f7e00000 R14: ffffe20000545438 R15: ffff810001026b80
[ 1115.638135] FS:  0000000000000000(0000) GS:ffff81001e9d79c0(0000)
knlGS:0000000000000000
[ 1115.638137] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 1115.638138] CR2: 00000000f629e000 CR3: 0000000000201000 CR4: 00000000000006e0
[ 1115.638141] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1115.638143] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1115.638145] Process monitor (pid: 2437, threadinfo
ffff8100165fa000, task ffff81001eb0b220)
[ 1115.638147] Stack:  0000000018181819 0000000018181819
ffff810015d02000 ffffffff8027f3a6
[ 1115.638151]  0000000000000246 0000000000000000 ffff8100165fbcf8
ffffffffffffffff
[ 1115.638154]  0000000000000000 ffff81001ec45298 ffff8100165fbd00
00000000001bfb93
[ 1115.638158] Call Trace:
[ 1115.638163]  [<ffffffff8027f3a6>] ? unmap_vmas+0x4c9/0x885
[ 1115.638171]  [<ffffffff802837da>] ? exit_mmap+0x7c/0xf0
[ 1115.638180]  [<ffffffff80232500>] ? mmput+0x2c/0xa2
[ 1115.638185]  [<ffffffff802377c9>] ? do_exit+0x25a/0x6b4
[ 1115.638189]  [<ffffffff80237c90>] ? do_group_exit+0x6d/0x9d
[ 1115.638194]  [<ffffffff8023ffd6>] ? get_signal_to_deliver+0x302/0x324
[ 1115.638199]  [<ffffffff8020b2a6>] ? do_notify_resume+0xaf/0x7fc
[ 1115.639205]  [<ffffffff80246021>] ? autoremove_wake_function+0x0/0x2e
[ 1115.639211]  [<ffffffff8022f012>] ? hrtick_set+0x88/0xf7
[ 1115.639217]  [<ffffffff8020c11c>] ? int_signal+0x12/0x17
[ 1115.639223]
[ 1115.639223]
[ 1115.639224] Code: 80 e8 70 e7 fc ff 48 8b 85 90 00 00 00 48 85 c0
74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7 ac 36 4b 80 e8
4b e7 fc ff <0f> 0b eb fe 8b 77 18 41 58 5b 5d 83 e6 01 f7 de 83 c6 04
e9 a5
[ 1115.639249] RIP  [<ffffffff80287340>] page_remove_rmap+0xff/0x11b
[ 1115.639252]  RSP <ffff8100165fbbe8>
[ 1115.639255] ---[ end trace 2f9f1d2c3181af10 ]---
[ 1115.639257] Fixing recursive fault but reboot is needed!

-- 
Brian Phelps
Got e- ?
http://electronjunkie.wordpress.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
