Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd6222.kasserver.com ([85.13.131.10]:58339 "EHLO
	dd6222.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0FSJ1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 05:27:48 -0400
Message-ID: <4C1C8D8F.6040702@coronamundi.de>
Date: Sat, 19 Jun 2010 11:27:43 +0200
From: Silamael <Silamael@coronamundi.de>
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: linux-media@vger.kernel.org
Subject: Re: PROBLEM: 2.6.34-rc7 kernel panics "BUG: unable to handle kernel
 	NULL pointer dereference at (null)" while channel scan runnin
References: <4C14F922.1020802@coronamundi.de> <AANLkTinpwSQlGWtlz8cTCCQyzfWN6qiqLcsJczs87WTZ@mail.gmail.com>
In-Reply-To: <AANLkTinpwSQlGWtlz8cTCCQyzfWN6qiqLcsJczs87WTZ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2010 04:30 PM, David Ellingsworth wrote:
> Matthias,
> 
> While I don't doubt there's probably a bug in this driver, you haven't
> provided nearly enough information to correct it. Please resubmit with
> the full backtrace provided by the kernel at the time of the crash.
> Without this information, it's hard to gauge the exact cause of the
> error and thus no one will attempt to fix it.
> 
> Regards,
> 
> David Ellingsworth

Hello David,

No problem. At the meanwhile i also tried another card of the same type
to ensure it's not a somehow broken hardware. Nothing changed.
I'm not sure but could it be some problem concerned to interrupt sharing
or something like this? Or some problem of this MSI boards (MSI
IM-945GSE Mini-ITX motherboard) BIOS?

So, here is the info from my original bug report:

Kernel trace:
---------------------------------------------------------------
[  773.280361] IP: [<f825a7ba>] saa7146_buffer_next+0x5e/0x1ed [saa7146_vv]
[  773.280361] *pde = 00000000
[  773.280361] Oops: 0000 [#1] SMP
[  773.280361] last sysfs file: /sys/module/nfsd/initstate
[  773.280361] Modules linked in: nfsd exportfs nfs lockd nfs_acl
auth_rpcgss sunrpc f71882fg coretemp loop lnbp21 stv0299 dvb_ttpci
snd_hda_codec_realtek dvb_core saa7146_vv videodev v4l1_compat
snd_hda_intel saa7146 snd_hda_codec videobuf_dma_sg snd_hwdep
videobuf_core snd_pcm i2c_i801 ttpci_eeprom psmouse snd_timer intel_agp
evdev pcspkr snd i2c_core serio_raw agpgart video processor rng_core
soundcore button output snd_page_alloc usb_storage uhci_hcd ehci_hcd
thermal sd_mod crc_t10dif thermal_sys usbcore nls_base e1000e [last
unloaded: scsi_wait_scan]
[  773.280361]
[  773.280361] Pid: 0, comm: swapper Not tainted 2.6.34-rc7 #7
A9830IMS/A9830IMS
[  773.280361] EIP: 0060:[<f825a7ba>] EFLAGS: 00010246 CPU: 0
[  773.280361] EIP is at saa7146_buffer_next+0x5e/0x1ed [saa7146_vv]
[  773.280361] EAX: f68b3008 EBX: f733d900 ECX: 00000001 EDX: 00000002
[  773.280361] ESI: ffffffd4 EDI: f68b3000 EBP: 00000000 ESP: c135fefc
[  773.280361]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  773.280361] Process swapper (pid: 0, ti=c135e000 task=c138cb60
task.ti=c135e000)
[  773.280361] Stack:
[  773.280361]  f68b3000 f733d900 c13640bc 0000000a f825e5f6 f733d900
fff7fbf7 f825a759
[  773.280361] <0> f733d900 ffffffff f812bdfc fff7fbf7 f6a1e240 00000000
c106793a 00000000
[  773.280361] <0> 00000000 c1364080 0000000a c13640bc c135ff80 c1069072
0000000a 0000000a
[  773.280361] Call Trace:
[  773.280361]  [<f825e5f6>] ? vbi_irq_done+0x99/0x9f [saa7146_vv]
[  773.280361]  [<f825a759>] ? vv_callback+0x10f/0x112 [saa7146_vv]
[  773.280361]  [<f812bdfc>] ? interrupt_hw+0x9f/0x1a8 [saa7146]
[  773.280361]  [<c106793a>] ? handle_IRQ_event+0x49/0xe7
[  773.280361]  [<c1069072>] ? handle_level_irq+0x55/0x9e
[  773.280361]  [<c10044cb>] ? handle_irq+0x17/0x1c
[  773.280361]  [<c1003da9>] ? do_IRQ+0x38/0x8e
[  773.280361]  [<c1002d30>] ? common_interrupt+0x30/0x38
[  773.280361]  [<c10086e6>] ? mwait_idle+0x59/0x5e
[  773.280361]  [<c1001ae7>] ? cpu_idle+0x91/0xaa
[  773.280361]  [<c13b9881>] ? start_kernel+0x31c/0x321
[  773.280361] Code: 50 fc 25 f8 e8 9d 0e 01 c9 83 c4 1c 8b 43 44 89 c2
c1 fa 08 38 c2 75 04 0f 0b eb fe 8b 77 08 8d 47 08 39 c6 74 6b 83 ee 2c
31 ed <8b> 4e 2c 8b 56 30 89 51 04 89 0a c7 46 2c 00 01 10 00 c7 46 30
[  773.280361] EIP: [<f825a7ba>] saa7146_buffer_next+0x5e/0x1ed
[saa7146_vv] SS:ESP 0068:c135fefc
[  773.280361] CR2: 0000000000000000
[  773.985900] ---[ end trace ec43c18100749f7e ]---
[  773.999765] Kernel panic - not syncing: Fatal exception in interrupt
[  774.018832] Pid: 0, comm: swapper Tainted: G      D    2.6.34-rc7 #7
[  774.037908] Call Trace:
[  774.045272]  [<c126b5c4>] ? panic+0x37/0xa8
[  774.057844]  [<c10050e0>] ? oops_end+0x88/0x93
[  774.071195]  [<c1019bfd>] ? no_context+0x10d/0x116
[  774.085581]  [<c1019f62>] ? do_page_fault+0x0/0x242
[  774.100232]  [<c1019d04>] ? bad_area_nosemaphore+0xa/0xc
[  774.116194]  [<c126d6c3>] ? error_code+0x73/0x78
[  774.130077]  [<f825a7ba>] ? saa7146_buffer_next+0x5e/0x1ed [saa7146_vv]
[  774.149941]  [<f825e5f6>] ? vbi_irq_done+0x99/0x9f [saa7146_vv]
[  774.167718]  [<f825a759>] ? vv_callback+0x10f/0x112 [saa7146_vv]
[  774.185762]  [<f812bdfc>] ? interrupt_hw+0x9f/0x1a8 [saa7146]
[  774.203023]  [<c106793a>] ? handle_IRQ_event+0x49/0xe7
[  774.218459]  [<c1069072>] ? handle_level_irq+0x55/0x9e
[  774.233890]  [<c10044cb>] ? handle_irq+0x17/0x1c
[  774.247758]  [<c1003da9>] ? do_IRQ+0x38/0x8e
[  774.260590]  [<c1002d30>] ? common_interrupt+0x30/0x38
[  774.276023]  [<c10086e6>] ? mwait_idle+0x59/0x5e
[  774.289890]  [<c1001ae7>] ? cpu_idle+0x91/0xaa
[  774.303243]  [<c13b9881>] ? start_kernel+0x31c/0x321

Environment:
--------------------------------------------------------------------
scripts/ver_linux output:
Linux filmdose 2.6.34-rc7 #7 SMP Fri May 21 18:06:19 CEST 2010 i686
GNU/Linux

Gnu C                  4.4.4
Gnu make               3.81
binutils               2.20.1
util-linux             scripts/ver_linux: 23: fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Kbd                    1.15.1
Sh-utils               8.5
Modules Loaded         nfsd exportfs nfs lockd nfs_acl auth_rpcgss
sunrpc f71882fg coretemp loop lnbp21 stv0299 dvb_ttpci
snd_hda_codec_realtek dvb_core saa7146_vv videodev v4l1_compat
snd_hda_intel saa7146 snd_hda_codec snd_hwdep videobuf_dma_sg snd_pcm
videobuf_core ttpci_eeprom snd_timer i2c_i801 pcspkr evdev video
intel_agp snd psmouse soundcore i2c_core output snd_page_alloc button
serio_raw rng_core processor agpgart usb_storage uhci_hcd thermal
ehci_hcd sd_mod crc_t10dif usbcore nls_base thermal_sys e1000e

CPU informations:
-----------------------------------------------------------------
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Genuine Intel(R) CPU N270   @ 1.60GHz
stepping        : 2
cpu MHz         : 1596.317
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3
xtpr pdcm movbe lahf_lm
bogomips        : 3192.63
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 32 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Genuine Intel(R) CPU N270   @ 1.60GHz
stepping        : 2
cpu MHz         : 1596.317
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc
arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3
xtpr pdcm movbe lahf_lm
bogomips        : 3192.13
clflush size    : 64
cache_alignment : 64
address sizes   : 32 bits physical, 32 bits virtual
power management:

Module information:
-----------------------------------------------------------------------
nfsd 188955 13 - Live 0xf87ce000
exportfs 2550 1 nfsd, Live 0xf8790000
nfs 194761 0 - Live 0xf874c000
lockd 48817 2 nfsd,nfs, Live 0xf86f0000
nfs_acl 1671 2 nfsd,nfs, Live 0xf86d4000
auth_rpcgss 24619 2 nfsd,nfs, Live 0xf86c2000
sunrpc 132131 14 nfsd,nfs,lockd,nfs_acl,auth_rpcgss, Live 0xf8682000
f71882fg 18654 0 - Live 0xf8639000
coretemp 3283 0 - Live 0xf8629000
loop 9848 0 - Live 0xf861b000
lnbp21 1348 1 - Live 0xf82b6000
stv0299 6637 1 - Live 0xf8315000
dvb_ttpci 68625 0 - Live 0xf84c4000
snd_hda_codec_realtek 172736 1 - Live 0xf83c2000
dvb_core 61699 2 stv0299,dvb_ttpci, Live 0xf82bb000
saa7146_vv 30718 1 dvb_ttpci, Live 0xf826c000
videodev 26662 1 saa7146_vv, Live 0xf820d000
v4l1_compat 10358 1 videodev, Live 0xf8208000
snd_hda_intel 16133 0 - Live 0xf81a5000
saa7146 9696 2 dvb_ttpci,saa7146_vv, Live 0xf816e000
snd_hda_codec 54024 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xf8195000
snd_hwdep 4042 1 snd_hda_codec, Live 0xf8136000
videobuf_dma_sg 6973 1 saa7146_vv, Live 0xf8129000
snd_pcm 46364 2 snd_hda_intel,snd_hda_codec, Live 0xf80f9000
videobuf_core 10360 2 saa7146_vv,videobuf_dma_sg, Live 0xf80a1000
ttpci_eeprom 1216 1 dvb_ttpci, Live 0xf809b000
snd_timer 12329 1 snd_pcm, Live 0xf8085000
i2c_i801 5832 0 - Live 0xf8056000
pcspkr 1207 0 - Live 0xf8050000
evdev 5595 4 - Live 0xf803f000
video 14925 0 - Live 0xf832d000
intel_agp 20203 1 - Live 0xf8318000
snd 33636 6
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xf82f8000
psmouse 38263 0 - Live 0xf82d2000
soundcore 3526 1 snd, Live 0xf82b8000
i2c_core 12496 6
lnbp21,stv0299,dvb_ttpci,videodev,ttpci_eeprom,i2c_i801, Live 0xf8295000
output 1200 1 video, Live 0xf8285000
snd_page_alloc 4841 2 snd_hda_intel,snd_pcm, Live 0xf827a000
button 3618 0 - Live 0xf8269000
serio_raw 2894 0 - Live 0xf825e000
rng_core 2354 0 - Live 0xf8253000
processor 24543 0 - Live 0xf8233000
agpgart 19471 1 intel_agp, Live 0xf8217000
usb_storage 29843 0 - Live 0xf81f8000
uhci_hcd 15554 0 - Live 0xf81aa000
thermal 9502 0 - Live 0xf8189000
ehci_hcd 26533 0 - Live 0xf8174000
sd_mod 26147 5 - Live 0xf814e000
crc_t10dif 1012 1 sd_mod, Live 0xf813a000
usbcore 98217 4 usb_storage,uhci_hcd,ehci_hcd, Live 0xf810f000
nls_base 4521 1 usbcore, Live 0xf80ae000
thermal_sys 9436 3 video,processor,thermal, Live 0xf8017000
e1000e 97329 0 - Live 0xf8059000

Drivers and hardware information:
---------------------------------------------------------------
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:1f.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : ata_piix
  02f8-02ff : serial
  0376-0376 : 0000:00:1f.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1
    03f6-03f6 : ata_piix
  03f8-03ff : serial
  0400-041f : 0000:00:1f.3
    0400-041f : i801_smbus
  0480-04bf : 0000:00:1f.0
    0480-04bf : pnp 00:09
  04d0-04d1 : pnp 00:09
  0800-087f : 0000:00:1f.0
    0800-087f : pnp 00:09
      0800-0803 : ACPI PM1a_EVT_BLK
      0804-0805 : ACPI PM1a_CNT_BLK
      0808-080b : ACPI PM_TMR
      0810-0815 : ACPI CPU throttle
      0820-0820 : ACPI PM2_CNT_BLK
      0828-082f : ACPI GPE0_BLK
  0a00-0a07 : f71882fg
  0a60-0a6f : pnp 00:08
  0ae0-0aef : pnp 00:07
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  bc00-bc0f : 0000:00:1f.2
    bc00-bc0f : ata_piix
  bc80-bc83 : 0000:00:1f.2
    bc80-bc83 : ata_piix
  c000-c007 : 0000:00:1f.2
    c000-c007 : ata_piix
  c080-c083 : 0000:00:1f.2
    c080-c083 : ata_piix
  c400-c407 : 0000:00:1f.2
    c400-c407 : ata_piix
  c480-c49f : 0000:00:1d.3
    c480-c49f : uhci_hcd
  c800-c81f : 0000:00:1d.2
    c800-c81f : uhci_hcd
  c880-c89f : 0000:00:1d.1
    c880-c89f : uhci_hcd
  cc00-cc1f : 0000:00:1d.0
    cc00-cc1f : uhci_hcd
  cc80-cc87 : 0000:00:02.0
  d000-dfff : PCI Bus 0000:01
    dc80-dc9f : 0000:01:00.0
  e000-efff : PCI Bus 0000:02
    ec80-ec9f : 0000:02:00.0
  ffa0-ffaf : 0000:00:1f.1
    ffa0-ffaf : ata_piix

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000dffff : PCI Bus 0000:00
  000d0000-000d0fff : Adapter ROM
  000d1000-000d1fff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7f7bffff : System RAM
  01000000-0126e304 : Kernel code
  0126e305-013b8c27 : Kernel data
  01415000-014c1fc3 : Kernel bss
7f7c0000-7f7cdfff : ACPI Tables
7f7ce000-7f7fffff : ACPI Non-volatile Storage
7f800000-dfffffff : PCI Bus 0000:00
  7f800000-7f9fffff : PCI Bus 0000:01
  7fa00000-7fbfffff : PCI Bus 0000:02
  d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
  e0000000-e3ffffff : pnp 00:0b
e4000000-fed8ffff : PCI Bus 0000:00
  fe780000-fe7fffff : 0000:00:02.1
  fe837800-fe837bff : 0000:00:1f.2
  fe837c00-fe837fff : 0000:00:1d.7
    fe837c00-fe837fff : ehci_hcd
  fe838000-fe83bfff : 0000:00:1b.0
    fe838000-fe83bfff : ICH HD audio
  fe840000-fe87ffff : 0000:00:02.0
  fe880000-fe8fffff : 0000:00:02.0
  fe900000-fe9fffff : PCI Bus 0000:01
    fe9dc000-fe9dffff : 0000:01:00.0
      fe9dc000-fe9dffff : e1000e
    fe9e0000-fe9fffff : 0000:01:00.0
      fe9e0000-fe9fffff : e1000e
  fea00000-feafffff : PCI Bus 0000:02
    feadc000-feadffff : 0000:02:00.0
      feadc000-feadffff : e1000e
    feae0000-feafffff : 0000:02:00.0
      feae0000-feafffff : e1000e
  feb00000-febfffff : PCI Bus 0000:03
    febffc00-febffdff : 0000:03:00.0
      febffc00-febffdff : saa7146
  fec00000-fec003ff : IOAPIC 0
  fed13000-fed19fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:09
  fed20000-fed3ffff : pnp 00:09
  fed40000-fed8ffff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0a
fff80000-ffffffff : reserved

PCI information:
--------------------------------------------------------------------
00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory
Controller Hub (rev 03)
        Subsystem: Intel Corporation Mobile 945GME Express Memory
Controller Hub
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: <access denied>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME
Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA
controller])
        Subsystem: Intel Corporation Mobile 945GME Express Integrated
Graphics Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fe880000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at cc80 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at fe840000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
943/940GML Express Integrated Graphics Controller (rev 03)
        Subsystem: Intel Corporation Device 27ae
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at fe780000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition
Audio Controller (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at fe838000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
1 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe900000-fe9fffff
        Prefetchable memory behind bridge: 000000007f800000-000000007f9fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port
2 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 000000007fa00000-000000007fbfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation N10/ICH7 Family USB UHCI
Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation N10/ICH7 Family USB UHCI Controller #1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at cc00 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at c880 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at c800 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI
Controller #4 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at c480 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI
Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fe837c00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
(prog-if 01 [Subtractive decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: feb00000-febfffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
        Subsystem: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation 82801G (ICH7 Family) IDE Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA
IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE
Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at c400 [size=8]
        Region 1: I/O ports at c080 [size=4]
        Region 2: I/O ports at c000 [size=8]
        Region 3: I/O ports at bc80 [size=4]
        Region 4: I/O ports at bc00 [size=16]
        Region 5: Memory at fe837800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>
        Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 02)
        Subsystem: Intel Corporation N10/ICH 7 Family SMBus Controller
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 0400 [size=32]
        Kernel driver in use: i801_smbus

01:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
        Subsystem: Micro-Star International Co., Ltd. Device 9830
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe9e0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at dc80 [size=32]
        Region 3: Memory at fe9dc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: e1000e

02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
        Subsystem: Micro-Star International Co., Ltd. Device 9830
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at feae0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at ec80 [size=32]
        Region 3: Memory at feadc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: e1000e

03:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Technotrend/Hauppauge
DVB card rev2.3
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: dvb

Greetings, Matthias
