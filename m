Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFIxr3b002143
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 13:59:53 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFIxfP8026286
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 13:59:42 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1870703wfc.6
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 10:59:41 -0800 (PST)
Message-ID: <208cbae30811151059t13600574p59fc5cd24de069be@mail.gmail.com>
Date: Sat, 15 Nov 2008 21:59:41 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "Brian Phelps" <lm317t@gmail.com>
In-Reply-To: <ea3b75ed0811150951i2864ec9fje4095c2aa7afd5c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811141442i1fc3bf3en5577bbb281b09e4e@mail.gmail.com>
	<ea3b75ed0811150945k320d7c36xc7bf754656a31ce6@mail.gmail.com>
	<ea3b75ed0811150951i2864ec9fje4095c2aa7afd5c7@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l crash dump
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

Hello, Brian

On Sat, Nov 15, 2008 at 8:51 PM, Brian Phelps <lm317t@gmail.com> wrote:
> Both machines do fine if I use maxcpus=1, unfortunately I need the
> other cores for MPEG4 encoding.
>
> On Sat, Nov 15, 2008 at 12:45 PM, Brian Phelps <lm317t@gmail.com> wrote:
>> I have confirmed this problem on two separate machines with identical
>> setups.  Anyone have any suggestions on where to go from here?
>>
>> [ 1047.862386] ------------[ cut here ]------------
>> [ 1047.862386] kernel BUG at mm/rmap.c:669!
>> [ 1047.862386] invalid opcode: 0000 [1] SMP
>> [ 1047.862386] CPU 1
>> [ 1047.862386] Modules linked in: i915 drm ipv6 dm_snapshot dm_mirror
>> dm_log dm_mod coretemp w83627ehf hwmon_vid bttv firmware_class
>> ir_common compat_ioctl32 videodev v4l1_compat i2c_algo_bit v4l2_common
>> videobuf_dma_sg videobuf_core btcx_risc tveeprom video rng_core
>> i2c_i801 snd_pcsp shpchp snd_hda_intel output button i2c_core iTCO_wdt
>> pci_hotplug snd_pcm intel_agp snd_timer snd soundcore snd_page_alloc
>> evdev ext2 mbcache sd_mod usbhid hid ff_memless ata_piix ata_generic
>> libata scsi_mod dock piix floppy ide_pci_generic ide_core ehci_hcd
>> uhci_hcd r8169 thermal processor fan thermal_sys
>> [ 1047.862386] Pid: 2440, comm: monitor Not tainted 2.6.26-1-amd64 #1
>> [ 1047.862386] RIP: 0010:[<ffffffff80287340>]  [<ffffffff80287340>]
>> page_remove_rmap+0xff/0x11b
>> [ 1047.862386] RSP: 0000:ffff810011e07be8  EFLAGS: 00010246
>> [ 1047.862386] RAX: 0000000000000000 RBX: ffffe200007afaf0 RCX: 000000000000b393
>> [ 1047.862386] RDX: 000000000000b393 RSI: 0000000000000046 RDI: 0000000000000286
>> [ 1047.862386] RBP: ffff81001d3caad8 R08: 00000000f7c00000 R09: ffff810011e07600
>> [ 1047.862386] R10: 0000000000000000 R11: 0000000000000010 R12: ffff81001d5d1480
>> [ 1047.862386] R13: 00000000f7c00000 R14: ffffe200007afaf0 R15: ffff810001012b80
>> [ 1047.862386] FS:  0000000000000000(0000) GS:ffff81001e93f9c0(0000)
>> knlGS:0000000000000000
>> [ 1047.862386] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
>> [ 1047.862386] CR2: 00000000f6420000 CR3: 0000000000201000 CR4: 00000000000006e0
>> [ 1047.862386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 1047.862386] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 1047.862386] Process monitor (pid: 2440, threadinfo
>> ffff810011e06000, task ffff81001eda89d0)
>> [ 1047.862386] Stack:  0000000023232323 0000000023232323
>> ffff8100128ae000 ffffffff8027f3a6
>> [ 1047.862386]  000000000017da6c 0000000000000000 ffff810011e07cf8
>> ffffffffffffffff
>> [ 1047.862386]  0000000000000000 ffff81001d3caad8 ffff810011e07d00
>> 00000000003fae22
>> [ 1047.862386] Call Trace:
>> [ 1047.862386]  [<ffffffff8027f3a6>] ? unmap_vmas+0x4c9/0x885
>> [ 1047.862386]  [<ffffffff802837da>] ? exit_mmap+0x7c/0xf0
>> [ 1047.862386]  [<ffffffff80232500>] ? mmput+0x2c/0xa2
>> [ 1047.862386]  [<ffffffff802377c9>] ? do_exit+0x25a/0x6b4
>> [ 1047.862386]  [<ffffffff80237c90>] ? do_group_exit+0x6d/0x9d
>> [ 1047.862386]  [<ffffffff8023ffd6>] ? get_signal_to_deliver+0x302/0x324
>> [ 1047.862386]  [<ffffffff8020b2a6>] ? do_notify_resume+0xaf/0x7fc
>> [ 1047.862386]  [<ffffffff8024aab6>] ? getnstimeofday+0x39/0x98
>> [ 1047.862386]  [<ffffffff80248bba>] ? ktime_get_ts+0x22/0x4b
>> [ 1047.862386]  [<ffffffff80248bef>] ? ktime_get+0xc/0x41
>> [ 1047.862386]  [<ffffffff802484ca>] ? update_rmtp+0x4b/0x5e
>> [ 1047.862386]  [<ffffffff80248a93>] ? hrtimer_nanosleep+0x73/0xbd
>> [ 1047.862386]  [<ffffffff802484dd>] ? hrtimer_wakeup+0x0/0x21
>> [ 1047.862386]  [<ffffffff8020c11c>] ? int_signal+0x12/0x17
>> [ 1047.862386]
>> [ 1047.862386]
>> [ 1047.862386] Code: 80 e8 70 e7 fc ff 48 8b 85 90 00 00 00 48 85 c0
>> 74 19 48 8b 40 20 48 85 c0 74 10 48 8b 70 58 48 c7 c7 ac 36 4b 80 e8
>> 4b e7 fc ff <0f> 0b eb fe 8b 77 18 41 58 5b 5d 83 e6 01 f7 de 83 c6 04
>> e9 a5
>> [ 1047.862386] RIP  [<ffffffff80287340>] page_remove_rmap+0xff/0x11b
>> [ 1047.862386]  RSP <ffff810011e07be8>
>> [ 1047.886575] ---[ end trace fc9ab4668f3a13b5 ]---
>>
>>
>> On Fri, Nov 14, 2008 at 5:42 PM, Brian Phelps <lm317t@gmail.com> wrote:
>>> Thanks ahead of time for looking at this
>>> I have had the hardest time getting v4l2 to be stable on an intel quad
>>> core.  If I pass maxcpus=1 at the kernel boot all seems to be ok.  If
>>> I don't then see the dump below.
>>>
>>> I'm using a 4 chip, 4 input video capture device.  I get all sorts of
>>> crazy errors from time to time and lines that jump around occasionally
>>> in the picture.
>>>
>>> I have also tried kernel 2.6.24
>>>
>>> # uname -r
>>> 2.6.26-1-amd64
>>>
>>>
>>> # cat /proc/cpuinfo
>>> processor       : 0
>>> vendor_id       : GenuineIntel
>>> cpu family      : 6
>>> model           : 15
>>> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>>> stepping        : 11
>>> cpu MHz         : 2399.953
>>> cache size      : 4096 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 0
>>> cpu cores       : 4
>>> apicid          : 0
>>> initial apicid  : 0
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 10
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>>> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
>>> ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
>>> bogomips        : 4803.77
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 36 bits physical, 48 bits virtual
>>> power management:
>>>
>>> processor       : 1
>>> vendor_id       : GenuineIntel
>>> cpu family      : 6
>>> model           : 15
>>> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>>> stepping        : 11
>>> cpu MHz         : 2399.953
>>> cache size      : 4096 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 1
>>> cpu cores       : 4
>>> apicid          : 1
>>> initial apicid  : 1
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 10
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>>> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
>>> ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
>>> bogomips        : 4799.94
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 36 bits physical, 48 bits virtual
>>> power management:
>>>
>>> processor       : 2
>>> vendor_id       : GenuineIntel
>>> cpu family      : 6
>>> model           : 15
>>> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>>> stepping        : 11
>>> cpu MHz         : 2399.953
>>> cache size      : 4096 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 2
>>> cpu cores       : 4
>>> apicid          : 2
>>> initial apicid  : 2
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 10
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>>> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
>>> ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
>>> bogomips        : 4799.98
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 36 bits physical, 48 bits virtual
>>> power management:
>>>
>>> processor       : 3
>>> vendor_id       : GenuineIntel
>>> cpu family      : 6
>>> model           : 15
>>> model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
>>> stepping        : 11
>>> cpu MHz         : 2399.953
>>> cache size      : 4096 KB
>>> physical id     : 0
>>> siblings        : 4
>>> core id         : 3
>>> cpu cores       : 4
>>> apicid          : 3
>>> initial apicid  : 3
>>> fpu             : yes
>>> fpu_exception   : yes
>>> cpuid level     : 10
>>> wp              : yes
>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>>> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
>>> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor
>>> ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
>>> bogomips        : 4799.96
>>> clflush size    : 64
>>> cache_alignment : 64
>>> address sizes   : 36 bits physical, 48 bits virtual
>>> power management:
>>>
>>> # cat /proc/interrupts
>>>           CPU0       CPU1       CPU2       CPU3
>>>  0:         35          0          1          0   IO-APIC-edge      timer
>>>  1:          7          8          6          5   IO-APIC-edge      i8042
>>>  8:          4          3          2          5   IO-APIC-edge      rtc0
>>>  9:          0          0          0          0   IO-APIC-fasteoi   acpi
>>>  14:          0          0          0          0   IO-APIC-edge      ide0
>>>  16:         31         31         30         31   IO-APIC-fasteoi
>>> uhci_hcd:usb4, HDA Intel, i915@pci:0000:00:02.0
>>>  18:          0          0          0          0   IO-APIC-fasteoi
>>> uhci_hcd:usb3
>>>  19:        714        707        714        714   IO-APIC-fasteoi
>>> uhci_hcd:usb2, ata_piix
>>>  20:        561        579        551        584   IO-APIC-fasteoi   bttv0
>>>  21:        576        562        586        551   IO-APIC-fasteoi   bttv1
>>>  22:        570        555        568        575   IO-APIC-fasteoi   bttv2
>>>  23:          2          0          0          1   IO-APIC-fasteoi
>>> uhci_hcd:usb1, ehci_hcd:usb5, bttv3
>>> 1276:        355        376        363        354   PCI-MSI-edge      eth12
>>> NMI:          0          0          0          0   Non-maskable interrupts
>>> LOC:      28894      29424      18721      16437   Local timer interrupts
>>> RES:        361        405        439        318   Rescheduling interrupts
>>> CAL:      52823      82942      30311      82876   function call interrupts
>>> TLB:        292        446        279        468   TLB shootdowns
>>> TRM:          0          0          0          0   Thermal event interrupts
>>> THR:          0          0          0          0   Threshold APIC interrupts
>>> SPU:          0          0          0          0   Spurious interrupts
>>> # lspci -vvv
>>> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
>>> Controller (rev 10)
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Capabilities: [e0] Vendor Specific Information <?>
>>>        Kernel driver in use: agpgart-intel
>>>        Kernel modules: intel-agp
>>>
>>> 00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI
>>> Express Root Port (rev 10) (prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>>        I/O behind bridge: 0000f000-00000fff
>>>        Memory behind bridge: fff00000-000fffff
>>>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [88] Subsystem: Intel Corporation Device 0000
>>>        Capabilities: [80] Power Management version 3
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
>>> Queue=0/0 Enable+
>>>                Address: fee0f00c  Data: 4159
>>>        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>>> <64ns, L1 <1us
>>>                        ExtTag- RBE+ FLReset-
>>>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
>>> Unsupported+
>>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr- TransPend-
>>>                LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s
>>> L1, Latency L0 <1us, L1 <8us
>>>                        ClockPM- Suprise- LLActRep- BwNot-
>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
>>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
>>> HotPlug- Surpise-
>>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
>>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
>>> CmdCplt- HPIrq- LinkChg-
>>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
>>> PresDet- Interlock-
>>>                        Changed: MRL- PresDet- LinkState-
>>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
>>> PMEIntEna- CRSVisible-
>>>                RootCap: CRSVisible-
>>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>        Kernel driver in use: pcieport-driver
>>>        Kernel modules: shpchp
>>>
>>> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
>>> Integrated Graphics Controller (rev 10) (prog-if 00 [VGA controller])
>>>        Subsystem: Intel Corporation 82G33/G31 Express Integrated
>>> Graphics Controller
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin A routed to IRQ 16
>>>        Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=512K]
>>>        Region 1: I/O ports at e140 [size=8]
>>>        Region 2: Memory at c0000000 (32-bit, prefetchable) [size=256M]
>>>        Region 3: Memory at fe900000 (32-bit, non-prefetchable) [size=1M]
>>>        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
>>> Queue=0/0 Enable-
>>>                Address: 00000000  Data: 0000
>>>        Capabilities: [d0] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>
>>> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
>>> Definition Audio Controller (rev 01)
>>>        Subsystem: Intel Corporation Device d608
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Interrupt: pin A routed to IRQ 16
>>>        Region 0: Memory at feb80000 (64-bit, non-prefetchable) [size=16K]
>>>        Capabilities: [50] Power Management version 2
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
>>> Queue=0/0 Enable-
>>>                Address: 0000000000000000  Data: 0000
>>>        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>>> <64ns, L1 <1us
>>>                        ExtTag- RBE- FLReset-
>>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>>> Unsupported-
>>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr+ TransPend-
>>>                LnkCap: Port #0, Speed unknown, Width x0, ASPM
>>> unknown, Latency L0 <64ns, L1 <1us
>>>                        ClockPM- Suprise- LLActRep- BwNot-
>>>                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed unknown, Width x0, TrErr- Train-
>>> SlotClk- DLActive- BWMgmt- ABWMgmt-
>>>        Kernel driver in use: HDA Intel
>>>        Kernel modules: snd-hda-intel
>>>
>>> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
>>> Port 1 (rev 01) (prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>>        I/O behind bridge: 0000f000-00000fff
>>>        Memory behind bridge: fff00000-000fffff
>>>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort+ <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>>> unlimited, L1 unlimited
>>>                        ExtTag- RBE- FLReset-
>>>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
>>> Unsupported+
>>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr+ TransPend-
>>>                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>> Latency L0 <1us, L1 <4us
>>>                        ClockPM- Suprise- LLActRep+ BwNot-
>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train-
>>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
>>> HotPlug+ Surpise+
>>>                        Slot #  1, PowerLimit 10.000000; Interlock- NoCompl-
>>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
>>> CmdCplt- HPIrq- LinkChg-
>>>                        Control: AttnInd Unknown, PwrInd Unknown,
>>> Power- Interlock-
>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
>>> PresDet- Interlock-
>>>                        Changed: MRL- PresDet- LinkState-
>>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
>>> PMEIntEna- CRSVisible-
>>>                RootCap: CRSVisible-
>>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
>>> Queue=0/0 Enable+
>>>                Address: fee0f00c  Data: 4161
>>>        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
>>> Family) PCI Express Port 1
>>>        Capabilities: [a0] Power Management version 2
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: pcieport-driver
>>>        Kernel modules: shpchp
>>>
>>> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
>>> Port 2 (rev 01) (prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>>>        I/O behind bridge: 0000d000-0000dfff
>>>        Memory behind bridge: fea00000-feafffff
>>>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
>>> unlimited, L1 unlimited
>>>                        ExtTag- RBE- FLReset-
>>>                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
>>> Unsupported+
>>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
>>> AuxPwr+ TransPend-
>>>                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>> Latency L0 <256ns, L1 <4us
>>>                        ClockPM- Suprise- LLActRep+ BwNot-
>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>>> SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
>>> HotPlug+ Surpise+
>>>                        Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
>>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
>>> CmdCplt- HPIrq- LinkChg-
>>>                        Control: AttnInd Unknown, PwrInd Unknown,
>>> Power- Interlock-
>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
>>> PresDet+ Interlock-
>>>                        Changed: MRL- PresDet+ LinkState+
>>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
>>> PMEIntEna- CRSVisible-
>>>                RootCap: CRSVisible-
>>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
>>> Queue=0/0 Enable+
>>>                Address: fee0f00c  Data: 4169
>>>        Capabilities: [90] Subsystem: Intel Corporation 82801G (ICH7
>>> Family) PCI Express Port 2
>>>        Capabilities: [a0] Power Management version 2
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: pcieport-driver
>>>        Kernel modules: shpchp
>>>
>>> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
>>> UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin A routed to IRQ 23
>>>        Region 4: I/O ports at e080 [size=32]
>>>        Kernel driver in use: uhci_hcd
>>>        Kernel modules: uhci-hcd
>>>
>>> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
>>> UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin B routed to IRQ 19
>>>        Region 4: I/O ports at e060 [size=32]
>>>        Kernel driver in use: uhci_hcd
>>>        Kernel modules: uhci-hcd
>>>
>>> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
>>> UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin C routed to IRQ 18
>>>        Region 4: I/O ports at e040 [size=32]
>>>        Kernel driver in use: uhci_hcd
>>>        Kernel modules: uhci-hcd
>>>
>>> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
>>> UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin D routed to IRQ 16
>>>        Region 4: I/O ports at e020 [size=32]
>>>        Kernel driver in use: uhci_hcd
>>>        Kernel modules: uhci-hcd
>>>
>>> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
>>> EHCI Controller (rev 01) (prog-if 20 [EHCI])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin A routed to IRQ 23
>>>        Region 0: Memory at feb84000 (32-bit, non-prefetchable) [size=1K]
>>>        Capabilities: [50] Power Management version 2
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>        Kernel driver in use: ehci_hcd
>>>        Kernel modules: ehci-hcd
>>>
>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
>>> (prog-if 01 [Subtractive decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Bus: primary=00, secondary=04, subordinate=05, sec-latency=32
>>>        I/O behind bridge: 0000f000-00000fff
>>>        Memory behind bridge: fff00000-000fffff
>>>        Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
>>>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [50] Subsystem: Gammagraphx, Inc. Device 0000
>>>
>>> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
>>> Interface Bridge (rev 01)
>>>        Subsystem: Intel Corporation DeskTop Board D945GTP
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Capabilities: [e0] Vendor Specific Information <?>
>>>        Kernel modules: intel-rng, iTCO_wdt
>>>
>>> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
>>> Controller (rev 01) (prog-if 8a [Master SecP PriP])
>>>        Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
>>>        Latency: 0
>>>        Interrupt: pin A routed to IRQ 18
>>>        Region 0: I/O ports at 01f0 [size=8]
>>>        Region 1: I/O ports at 03f4 [size=1]
>>>        Region 2: I/O ports at 0170 [size=8]
>>>        Region 3: I/O ports at 0374 [size=1]
>>>        Region 4: I/O ports at e0f0 [size=16]
>>>        Kernel driver in use: PIIX_IDE
>>>        Kernel modules: piix
>>>
>>> 00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
>>> SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
>>>        Subsystem: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA
>>> IDE Controller
>>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0
>>>        Interrupt: pin B routed to IRQ 19
>>>        Region 0: I/O ports at e0e0 [size=8]
>>>        Region 1: I/O ports at e0d0 [size=4]
>>>        Region 2: I/O ports at e0c0 [size=8]
>>>        Region 3: I/O ports at e0b0 [size=4]
>>>        Region 4: I/O ports at e0a0 [size=16]
>>>        Capabilities: [70] Power Management version 2
>>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: ata_piix
>>>        Kernel modules: ata_piix
>>>
>>> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
>>>        Subsystem: Intel Corporation Device d608
>>>        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Interrupt: pin B routed to IRQ 19
>>>        Region 4: I/O ports at e000 [size=32]
>>>        Kernel driver in use: i801_smbus
>>>        Kernel modules: i2c-i801
>>>
>>> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>>> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
>>>        Subsystem: Intel Corporation Device d608
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 0, Cache Line Size: 64 bytes
>>>        Interrupt: pin A routed to IRQ 1276
>>>        Region 0: I/O ports at d000 [size=256]
>>>        Region 2: Memory at fea20000 (64-bit, non-prefetchable) [size=4K]
>>>        Expansion ROM at fea00000 [disabled] [size=128K]
>>>        Capabilities: [40] Power Management version 2
>>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
>>> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Capabilities: [48] Vital Product Data <?>
>>>        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
>>> Queue=0/1 Enable+
>>>                Address: 00000000fee0f00c  Data: 4171
>>>        Capabilities: [60] Express (v1) Endpoint, MSI 00
>>>                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency
>>> L0s <128ns, L1 unlimited
>>>                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
>>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>>> Unsupported-
>>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>>>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
>>> AuxPwr+ TransPend-
>>>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
>>> Latency L0 unlimited, L1 unlimited
>>>                        ClockPM- Suprise- LLActRep- BwNot-
>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
>>> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>        Capabilities: [84] Vendor Specific Information <?>
>>>        Kernel driver in use: r8169
>>>        Kernel modules: r8169
>>>
>>> 04:05.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge
>>> (non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
>>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32, Cache Line Size: 64 bytes
>>>        Bus: primary=04, secondary=05, subordinate=05, sec-latency=32
>>>        I/O behind bridge: 0000f000-00000fff
>>>        Memory behind bridge: fff00000-000fffff
>>>        Prefetchable memory behind bridge: d0000000-d00fffff
>>>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>        Capabilities: [80] Power Management version 2
>>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>>> PME(D0-,D1+,D2+,D3hot+,D3cold+)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>                Bridge: PM- B3+
>>>        Capabilities: [90] CompactPCI hot-swap <?>
>>>        Kernel modules: shpchp
>>>
>>> 05:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>>> Capture (rev 11)
>>>        Subsystem: Device aa00:1460
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (4000ns min, 10000ns max)
>>>        Interrupt: pin A routed to IRQ 20
>>>        Region 0: Memory at d0007000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: bttv
>>>        Kernel modules: bttv
>>>
>>> 05:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>>> Capture (rev 11)
>>>        Subsystem: Device aa00:1460
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (1000ns min, 63750ns max)
>>>        Interrupt: pin A routed to IRQ 4
>>>        Region 0: Memory at d0006000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>
>>> 05:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>>> Capture (rev 11)
>>>        Subsystem: Device aa01:1461
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (4000ns min, 10000ns max)
>>>        Interrupt: pin A routed to IRQ 21
>>>        Region 0: Memory at d0005000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: bttv
>>>        Kernel modules: bttv
>>>
>>> 05:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>>> Capture (rev 11)
>>>        Subsystem: Device aa01:1461
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (1000ns min, 63750ns max)
>>>        Interrupt: pin A routed to IRQ 11
>>>        Region 0: Memory at d0004000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>
>>> 05:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>>> Capture (rev 11)
>>>        Subsystem: Device aa02:1462
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (4000ns min, 10000ns max)
>>>        Interrupt: pin A routed to IRQ 22
>>>        Region 0: Memory at d0003000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: bttv
>>>        Kernel modules: bttv
>>>
>>> 05:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>>> Capture (rev 11)
>>>        Subsystem: Device aa02:1462
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (1000ns min, 63750ns max)
>>>        Interrupt: pin A routed to IRQ 10
>>>        Region 0: Memory at d0002000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>
>>> 05:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video
>>> Capture (rev 11)
>>>        Subsystem: Device aa03:1463
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (4000ns min, 10000ns max)
>>>        Interrupt: pin A routed to IRQ 23
>>>        Region 0: Memory at d0001000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>        Kernel driver in use: bttv
>>>        Kernel modules: bttv
>>>
>>> 05:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio
>>> Capture (rev 11)
>>>        Subsystem: Device aa03:1463
>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>>>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>        Latency: 32 (1000ns min, 63750ns max)
>>>        Interrupt: pin A routed to IRQ 5
>>>        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=4K]
>>>        Capabilities: [44] Vital Product Data <?>
>>>        Capabilities: [4c] Power Management version 2
>>>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>

<snip>

First, if i understand you in right way - you use 2.6.26-1 kernel. Can
you try latest stable kernel  - it's 2.6.27.6 ? And post results here,
anyway. (May be some bugs were fixed since 2.6.26).
And second, i'm not high clever minded, but it seems like problems
with memory management.. May be few locks absent ? Or may be general
smp-processing.. Try latest kernel, please. And more experienced
developers can say more here.

>>> [  372.649055] set status page addr 0x00033000
>>> [  497.758781] set status page addr 0x00033000
>>> [ 1115.633853] Eeek! page_mapcount(page) went negative! (-1)
>>> [ 1115.633853]   page pfn = 18181
>>> [ 1115.633853]   page->flags = 100000000000000
>>> [ 1115.633853]   page->count = 2
>>> [ 1115.633853]   page->mapping = 0000000000000000
>>> [ 1115.638025]   vma->vm_ops = 0xffffffff80504800
>>> [ 1115.638035]   vma->vm_ops->fault = filemap_fault+0x0/0x33d
>>> [ 1115.638042]   vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x47
>>> [ 1115.638070] ------------[ cut here ]------------
>>> [ 1115.638072] kernel BUG at mm/rmap.c:669!
>>> [ 1115.638074] invalid opcode: 0000 [1] SMP

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
