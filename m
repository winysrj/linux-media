Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47211 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0IMUiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 16:38:46 -0400
Received: by eyb6 with SMTP id 6so2892221eyb.19
        for <linux-media@vger.kernel.org>; Mon, 13 Sep 2010 13:38:44 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Need info to understand TeVii S470 cx23885 MSI  problem
Date: Mon, 13 Sep 2010 23:38:28 +0300
Cc: linux-media@vger.kernel.org
References: <1284321417.2394.10.camel@localhost>
In-Reply-To: <1284321417.2394.10.camel@localhost>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EvojMsFS63XJuyo"
Message-Id: <201009132338.28664.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
12 =D1=81=D0=B5=D0=BD=D1=82=D1=8F=D0=B1=D1=80=D1=8F 2010 22:56:57 =D0=B0=D0=
=B2=D1=82=D0=BE=D1=80 Andy Walls =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> Igor,
>=20
> To help understand the problem with the TeVii S470 CX23885 MSI not
> working after module unload and reload, could you provide the output of
>=20
> 	# lspci -d 14f1: -xxxx -vvvv
>=20
> as root before the cx23885 module loads, after the module loads, and
> after the module is removed and reloaded?
>=20
> please also provide the MSI IRQ number listed in dmesg
> (or /var/log/messages) assigned to the card.  Also the IRQ number of the
> unhandled IRQ when the module is reloaded.
>=20
> The linux kernel should be writing the MSI IRQ vector into the PCI
> configuration space of the CX23885.  It looks like when you unload and
> reload the cx23885 module, it is not changing the vector.
>=20
> Regards,
> Andy
Andy,
Error appears only and if you zap actual channel(interrupts actually calls).
=46irst time module loaded and zapped some channel. At this point there is =
no errors.
/proc/interrupts shows some irq's for cx23885.
Then rmmod-insmod and szap again. Voilla! No irq vector.
/proc/interrupts shows zero irq calls for cx23885.
In my case Do_irq complains about irq 153, dmesq says cx23885 uses 45.

My first look not catch anything in lspci.
=46or now I'm using workaround - find register and bit in cx23885 to write =
to disable MSI registers.
In conjunction with particular card, naturally.

Regards
Igor

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="interrupts.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="interrupts.txt"

            CPU0       CPU1       
   0:        127          3   IO-APIC-edge      timer
   1:        849        856   IO-APIC-edge      i8042
   4:          1          1   IO-APIC-edge    
   6:          3          2   IO-APIC-edge      floppy
   7:          0          0   IO-APIC-edge      parport0
   8:          0          1   IO-APIC-edge      rtc0
   9:          0          0   IO-APIC-fasteoi   acpi
  12:       4639       4641   IO-APIC-edge      i8042
  14:          0          0   IO-APIC-edge      ata_piix
  15:          0          0   IO-APIC-edge      ata_piix
  16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
  23:      19871      19882   IO-APIC-fasteoi   ata_piix, ehci_hcd:usb1, uhci_hcd:usb2
  42:        376        379   PCI-MSI-edge      eth0
  43:        688        688   PCI-MSI-edge      i915
  44:        691        669   PCI-MSI-edge      hda_intel
  45:          0          0   PCI-MSI-edge      cx23885[0]
 NMI:          0          0   Non-maskable interrupts
 LOC:     165490     139525   Local timer interrupts
 SPU:          0          0   Spurious interrupts
 PMI:          0          0   Performance monitoring interrupts
 PND:          0          0   Performance pending work
 RES:       1206       1333   Rescheduling interrupts
 CAL:         45         30   Function call interrupts
 TLB:       1509       1445   TLB shootdowns
 TRM:          0          0   Thermal event interrupts
 THR:          0          0   Threshold APIC interrupts
 MCE:          0          0   Machine check exceptions
 MCP:          5          5   Machine check polls
 ERR:          1
 MIS:          0

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.dmesg.after_loaded.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.dmesg.after_loaded.txt"

cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.dmesg.noirqvec.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.dmesg.noirqvec.txt"

IR JVC protocol handler initialized
IR Sony protocol handler initialized
lirc_dev: IR Remote Control driver registered, major 251 
IR LIRC bridge handler initialized
fuse init (API version 7.14)
EXT3-fs (sda8): using internal journal
lp0: using parport0 (interrupt-driven).
lp0: console ready
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda9): using internal journal
EXT3-fs (sda9): mounted filesystem with ordered data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb5): using internal journal
EXT3-fs (sdb5): mounted filesystem with ordered data mode
r8169 0000:01:00.0: eth0: link up
r8169 0000:01:00.0: eth0: link up
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
warning: `named' uses 32-bit capabilities (legacy support in use)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
svc: failed to register lockdv1 RPC service (errno 97).
eth0: no IPv6 routers present
cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: enabling bus mastering
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X
cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: enabling bus mastering
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X
ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
ds3000_firmware_ondemand: Waiting for firmware upload(2)...
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x11)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x11)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: enabling bus mastering
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)
do_IRQ: 1.153 No irq handler for vector (irq -1)
do_IRQ: 1.153 No irq handler for vector (irq -1)
ds3000_writereg: writereg error(err == -6, reg == 0x03, value == 0x12)

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.dmesg.reloaded.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.dmesg.reloaded.txt"

cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
[drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
TeVii S470 MAC= 00:18:BD:5B:12:69
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: enabling bus mastering
cx23885 0000:02:00.0: setting latency timer to 64
cx23885 0000:02:00.0: irq 45 for MSI/MSI-X

--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.first_time_insmod.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.first_time_insmod.txt"

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: Device [d470:9022]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4189
	Kernel driver in use: cx23885
	Kernel modules: cx23885


--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.lspci.not_loaded.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.lspci.not_loaded.txt"

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: Device [d470:9022]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel modules: cx23885


--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.rmmod-insmod-noirqvec.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.rmmod-insmod-noirqvec.txt"

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: Device [d470:9022]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a1
	Kernel driver in use: cx23885
	Kernel modules: cx23885


--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.rmmod-insmod-zap-not-involved.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.rmmod-insmod-zap-not-involved.txt"

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: Device [d470:9022]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4191
	Kernel driver in use: cx23885
	Kernel modules: cx23885


--Boundary-00=_EvojMsFS63XJuyo
Content-Type: text/plain;
  charset="utf-8";
  name="s470.rmmod.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="s470.rmmod.txt"

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: Device [d470:9022]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Product Name: "
		End
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4189
	Kernel modules: cx23885


--Boundary-00=_EvojMsFS63XJuyo--
