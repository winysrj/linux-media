Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s37.blu0.hotmail.com ([65.55.116.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jdasmith@hotmail.com>) id 1L6PZw-000700-L2
	for linux-dvb@linuxtv.org; Sat, 29 Nov 2008 14:09:46 +0100
Message-ID: <BLU136-W160F8352FCEC393F1A18D5CB070@phx.gbl>
From: Jonathan Smith <jdasmith@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Sat, 29 Nov 2008 13:09:09 +0000
MIME-Version: 1.0
Subject: [linux-dvb] Haupage HVR 3000 trouble
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1741492375=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1741492375==
Content-Type: multipart/alternative;
	boundary="_855bae13-39e1-4104-aa2e-6fa0a02e8f7f_"

--_855bae13-39e1-4104-aa2e-6fa0a02e8f7f_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


I recently bought a HVR 3000 for my Gentoo desktop=2C  running at the time =
kernel 2.6.25. I upgraded to 2.6.26=2C  rebooted=2C and found the card was =
not available. A check of lspci -v at this point listed the 00:0a.0 Multime=
dia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (r=
ev 05) but also an mpeg port=2C aditional audio port=2C and the lirc interf=
ace=2C all which now seem to have vanished. Briefly=2C after downloading th=
e SToth patches last weekend the whole thing sprang into life=2C and at lea=
st the DVB-T worked=2C however on rebooting I find I cannot replace the mod=
ules getting errors like cx88-dvb=2C getting in the first case=20


WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.26-gentoo-r3/ker=
nel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module=2C or=
 unknown parameter (see dmesg)
WARNING: Error inserting videobuf_dvb (/lib/modules/2.6.26-gentoo-r3/kernel=
/drivers/media/video/videobuf-dvb.ko): Unknown symbol in module=2C or unkno=
wn parameter (see dmesg)
WARNING: Error inserting cx88xx (/lib/modules/2.6.26-gentoo-r3/kernel/drive=
rs/media/video/cx88/cx88xx.ko): Unknown symbol in module=2C or unknown para=
meter (see dmesg)
WARNING: Error inserting cx8802 (/lib/modules/2.6.26-gentoo-r3/kernel/drive=
rs/media/video/cx88/cx8802.ko): Unknown symbol in module=2C or unknown para=
meter (see dmesg)
FATAL: Error inserting cx88_dvb (/lib/modules/2.6.26-gentoo-r3/kernel/drive=
rs/media/video/cx88/cx88-dvb.ko): Unknown symbol in module=2C or unknown pa=
rameter (see dmesg)
]

With some gratuitous use of lsmod | grep dvb=2C lsmod | grep v4l and lsmod =
| grep video it's possible to work around this and modprobe cx8800=2C cx88x=
x=2C cx8802=2C cx22702=2C but then I come to cx88-dvb and I get

FATAL: Error inserting cx88_dvb (/lib/modules/2.6.26-gentoo-r3/kernel/drive=
rs/media/video/cx88/cx88-dvb.ko): No such device

My lspci -v is below.

00:00.0 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Subsystem: ASRock Incorporation Device 0351
        Flags: bus master=2C medium devsel=2C latency 32
        Capabilities: [50] Power Management version 2
        Capabilities: [60] HyperTransport: Slave or Primary Interface
        Capabilities: [58] #00 [0000]

00:00.1 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Subsystem: ASRock Incorporation Device 1351
        Flags: bus master=2C medium devsel=2C latency 0

00:00.2 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Subsystem: ASRock Incorporation Device 2351
        Flags: bus master=2C medium devsel=2C latency 0

00:00.3 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Subsystem: ASRock Incorporation Device 3351
        Flags: bus master=2C medium devsel=2C latency 0

00:00.4 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Subsystem: ASRock Incorporation Device 4351
        Flags: bus master=2C medium devsel=2C latency 0

00:00.5 PIC: VIA Technologies=2C Inc. VT3351 I/O APIC Interrupt Controller =
(prog-if 20 [IO(X)-APIC])
        Subsystem: ASRock Incorporation Device 5351
        Flags: bus master=2C fast devsel=2C latency 0

00:00.7 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge
        Flags: bus master=2C medium devsel=2C latency 0

00:01.0 PCI bridge: VIA Technologies=2C Inc. [K8T890 North / VT8237 South] =
PCI Bridge (prog-if 00 [Normal decode])
        Flags: bus master=2C 66MHz=2C medium devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D01=2C subordinate=3D01=2C sec-late=
ncy=3D0
        Capabilities: [70] Power Management version 2

00:02.0 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Contr=
oller (prog-if 00 [Normal decode])
        Flags: bus master=2C fast devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D06=2C subordinate=3D06=2C sec-late=
ncy=3D0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f7fffff=
f
        Capabilities: [40] Express Root Port (Slot+)=2C MSI 00
        Capabilities: [68] Power Management version 2
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:03.0 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Contr=
oller (prog-if 00 [Normal decode])
        Flags: bus master=2C fast devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D05=2C subordinate=3D05=2C sec-late=
ncy=3D0
        Capabilities: [40] Express Root Port (Slot+)=2C MSI 00
        Capabilities: [68] Power Management version 2
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:03.1 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Contr=
oller (prog-if 00 [Normal decode])
        Flags: bus master=2C fast devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D04=2C subordinate=3D04=2C sec-late=
ncy=3D0
        Capabilities: [40] Express Root Port (Slot+)=2C MSI 00
        Capabilities: [68] Power Management version 2
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:03.2 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Contr=
oller (prog-if 00 [Normal decode])
        Flags: bus master=2C fast devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D03=2C subordinate=3D03=2C sec-late=
ncy=3D0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe900000-fe9fffff
        Capabilities: [40] Express Root Port (Slot+)=2C MSI 00
        Capabilities: [68] Power Management version 2
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Kernel driver in use: pcieport-driver

00:03.3 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Contr=
oller (prog-if 00 [Normal decode])
        Flags: bus master=2C fast devsel=2C latency 0
        Bus: primary=3D00=2C secondary=3D02=2C subordinate=3D02=2C sec-late=
ncy=3D0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe800000-fe8fffff
        Capabilities: [40] Express Root Port (Slot+)=2C MSI 00
        Capabilities: [68] Power Management version 2
        Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>
        Capabilities: [180] Root Complex Link <?>
        Kernel driver in use: pcieport-driver

00:09.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
        Subsystem: Micro-Star International Co.=2C Ltd. Device 6834
        Flags: bus master=2C slow devsel=2C latency 32=2C IRQ 16
        Memory at fe7fc000 (32-bit=2C non-prefetchable) [size=3D8K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: rt2500
        Kernel modules: rt2500=2C rt2500pci

00:0a.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and A=
udio Decoder (rev 05)
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 11
        Memory at fd000000 (32-bit=2C non-prefetchable) [size=3D16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel modules: cx8800

00:0f.0 IDE interface: VIA Technologies=2C Inc. VT8237A SATA 2-Port Control=
ler (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: ASRock Incorporation Device 0591
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 21
        I/O ports at bc00 [size=3D8]
        I/O ports at b880 [size=3D4]
        I/O ports at b800 [size=3D8]
        I/O ports at b480 [size=3D4]
        I/O ports at b400 [size=3D16]
        I/O ports at b000 [size=3D256]
        Capabilities: [c0] Power Management version 2
        Kernel driver in use: sata_via
        Kernel modules: sata_via=2C pata_acpi

00:0f.1 IDE interface: VIA Technologies=2C Inc. VT82C586A/B/VT82C686/A/B/VT=
823x/A/C PIPC Bus Master IDE (rev 07) (prog-if 8a [Master SecP PriP])
        Subsystem: ASRock Incorporation K7VT2/K7VT6 motherboard
        Flags: bus master=2C medium devsel=2C latency 32
        [virtual] Memory at 000001f0 (32-bit=2C non-prefetchable) [disabled=
] [size=3D8]
        [virtual] Memory at 000003f0 (type 3=2C non-prefetchable) [disabled=
] [size=3D1]
        [virtual] Memory at 00000170 (32-bit=2C non-prefetchable) [disabled=
] [size=3D8]
        [virtual] Memory at 00000370 (type 3=2C non-prefetchable) [disabled=
] [size=3D1]
        I/O ports at fc00 [size=3D16]
        Capabilities: [c0] Power Management version 2
        Kernel driver in use: VIA_IDE
        Kernel modules: pata_acpi=2C pata_via

00:10.0 USB Controller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Con=
troller (rev a0) (prog-if 00 [UHCI])
        Subsystem: ASRock Incorporation K7VT6
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 20
        I/O ports at a480 [size=3D32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.1 USB Controller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Con=
troller (rev a0) (prog-if 00 [UHCI])
        Subsystem: ASRock Incorporation K7VT6
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 22
        I/O ports at a800 [size=3D32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.2 USB Controller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Con=
troller (rev a0) (prog-if 00 [UHCI])
        Subsystem: ASRock Incorporation K7VT6
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 21
        I/O ports at a880 [size=3D32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.3 USB Controller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Con=
troller (rev a0) (prog-if 00 [UHCI])
        Subsystem: ASRock Incorporation K7VT6
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 23
        I/O ports at ac00 [size=3D32]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.4 USB Controller: VIA Technologies=2C Inc. USB 2.0 (rev 86) (prog-if =
20 [EHCI])
        Subsystem: ASRock Incorporation K7VT6 motherboard
        Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 21
        Memory at fe7ffc00 (32-bit=2C non-prefetchable) [size=3D256]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:11.0 ISA bridge: VIA Technologies=2C Inc. VT8237A PCI to ISA Bridge
        Subsystem: ASRock Incorporation Device 3337
        Flags: medium devsel
        Capabilities: [c0] Power Management version 2
        Kernel modules: i2c-viapro

00:11.7 Host bridge: VIA Technologies=2C Inc. VT8251 Ultra VLINK Controller
        Subsystem: VIA Technologies=2C Inc. Device 337e
        Flags: bus master=2C medium devsel=2C latency 32
        Capabilities: [58] HyperTransport: Interrupt Discovery and Configur=
ation

00:13.0 Host bridge: VIA Technologies=2C Inc. VT8237A Host Bridge
        Flags: bus master=2C fast devsel=2C latency 0
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed+

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Hyp=
erTransport Technology Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Add=
ress Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Mis=
cellaneous Control
        Flags: fast devsel
        Capabilities: [f0] Secure device <?>
        Kernel driver in use: k8temp
        Kernel modules: k8temp

02:00.0 SATA controller: JMicron Technologies=2C Inc. JMicron 20360/20363 A=
HCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: ASRock Incorporation Device 2363
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 40
        Memory at fe8fe000 (32-bit=2C non-prefetchable) [size=3D8K]
        Expansion ROM at fe8e0000 [disabled] [size=3D64K]
        Capabilities: [68] Power Management version 2
        Capabilities: [50] Express Legacy Endpoint=2C MSI 01
        Kernel driver in use: ahci
        Kernel modules: ahci

02:00.1 IDE interface: JMicron Technologies=2C Inc. JMicron 20360/20363 AHC=
I Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASRock Incorporation Device 2363
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 41
        I/O ports at cc00 [size=3D8]
        I/O ports at c880 [size=3D4]
        I/O ports at c800 [size=3D8]
        I/O ports at c480 [size=3D4]
        I/O ports at c400 [size=3D16]
        Capabilities: [68] Power Management version 2
        Kernel driver in use: pata_jmicron
        Kernel modules: pata_acpi=2C pata_jmicron=2C jmicron

03:00.0 Ethernet controller: Realtek Semiconductor Co.=2C Ltd. RTL8111/8168=
B PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: ASRock Incorporation Device 8168
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 36
        I/O ports at d800 [size=3D256]
        Memory at fe9ff000 (64-bit=2C non-prefetchable) [size=3D4K]
        Expansion ROM at fe9c0000 [disabled] [size=3D128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Vital Product Data <?>
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/1 Enable-
        Capabilities: [60] Express Endpoint=2C MSI 00
        Capabilities: [84] Vendor Specific Information <?>
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [12c] Virtual Channel <?>
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-1a
        Capabilities: [154] Power Budgeting <?>
        Kernel driver in use: r8169
        Kernel modules: r8169

06:00.0 VGA compatible controller: ATI Technologies Inc RV370 [Sapphire X55=
0 Silent] (prog-if 00 [VGA controller])
        Subsystem: Micro-Star International Co.=2C Ltd. Device 3000
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 10
        Memory at f0000000 (32-bit=2C prefetchable) [size=3D128M]
        I/O ports at e000 [size=3D256]
        Memory at feae0000 (32-bit=2C non-prefetchable) [size=3D64K]
        Expansion ROM at feac0000 [disabled] [size=3D128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint=2C MSI 00
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [100] Advanced Error Reporting <?>

06:00.1 Display controller: ATI Technologies Inc RV370 secondary [Sapphire =
X550 Silent]
        Subsystem: Micro-Star International Co.=2C Ltd. Device 3001
        Flags: bus master=2C fast devsel=2C latency 0
        Memory at feaf0000 (32-bit=2C non-prefetchable) [size=3D64K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint=2C MSI 00

80:01.0 Audio device: VIA Technologies=2C Inc. VIA High Definition Audio Co=
ntroller (rev 10)
        Subsystem: ASRock Incorporation Device 0888
        Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 17
        Memory at febfc000 (64-bit=2C non-prefetchable) [size=3D16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-
        Capabilities: [70] Express Root Complex Integrated Endpoint=2C MSI =
00
        Capabilities: [100] Virtual Channel <?>
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

Please note I have an issue with my graphics card which is filling up my dm=
esg=2C so I'm not getting much useful information out of that. Has anyone e=
xperience the missing records in lspci before - should I be looking to retu=
rn the card or are there further diagnostics I can do?

_________________________________________________________________
See the most popular videos on the web=20
http://clk.atdmt.com/GBL/go/115454061/direct/01/=

--_855bae13-39e1-4104-aa2e-6fa0a02e8f7f_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
I recently bought a HVR 3000 for my Gentoo desktop=2C&nbsp=3B running at th=
e time kernel 2.6.25. I upgraded to 2.6.26=2C&nbsp=3B rebooted=2C and found=
 the card was not available. A check of lspci -v at this point listed the 0=
0:0a.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Au=
dio Decoder (rev 05) but also an mpeg port=2C aditional audio port=2C and t=
he lirc interface=2C all which now seem to have vanished. Briefly=2C after =
downloading the SToth patches last weekend the whole thing sprang into life=
=2C and at least the DVB-T worked=2C however on rebooting I find I cannot r=
eplace the modules getting errors like cx88-dvb=2C getting in the first cas=
e <br><br>
WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.26-gentoo-r3/ker=
nel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module=2C or=
 unknown parameter (see dmesg)<br>WARNING: Error inserting videobuf_dvb (/l=
ib/modules/2.6.26-gentoo-r3/kernel/drivers/media/video/videobuf-dvb.ko): Un=
known symbol in module=2C or unknown parameter (see dmesg)<br>WARNING: Erro=
r inserting cx88xx (/lib/modules/2.6.26-gentoo-r3/kernel/drivers/media/vide=
o/cx88/cx88xx.ko): Unknown symbol in module=2C or unknown parameter (see dm=
esg)<br>WARNING: Error inserting cx8802 (/lib/modules/2.6.26-gentoo-r3/kern=
el/drivers/media/video/cx88/cx8802.ko): Unknown symbol in module=2C or unkn=
own parameter (see dmesg)<br>FATAL: Error inserting cx88_dvb (/lib/modules/=
2.6.26-gentoo-r3/kernel/drivers/media/video/cx88/cx88-dvb.ko): Unknown symb=
ol in module=2C or unknown parameter (see dmesg)<br>]<br><br>With some grat=
uitous use of lsmod | grep dvb=2C lsmod | grep v4l and lsmod | grep video i=
t's possible to work around this and modprobe cx8800=2C cx88xx=2C cx8802=2C=
 cx22702=2C but then I come to cx88-dvb and I get<br><br>FATAL: Error inser=
ting cx88_dvb (/lib/modules/2.6.26-gentoo-r3/kernel/drivers/media/video/cx8=
8/cx88-dvb.ko): No such device<br><br>My lspci -v is below.<br><br>00:00.0 =
Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation=
 Device 0351<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Fl=
ags: bus master=2C medium devsel=2C latency 32<br>&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [50] Power Management version=
 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities=
: [60] HyperTransport: Slave or Primary Interface<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [58] #00 [0000]<br><br>00=
:00.1 Host bridge: VIA Technologies=2C Inc. VT3351 Host Bridge<br>&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorpora=
tion Device 1351<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Flags: bus master=2C medium devsel=2C latency 0<br><br>00:00.2 Host bri=
dge: VIA Technologies=2C Inc. VT3351 Host Bridge<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation Device =
2351<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus=
 master=2C medium devsel=2C latency 0<br><br>00:00.3 Host bridge: VIA Techn=
ologies=2C Inc. VT3351 Host Bridge<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation Device 3351<br>&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C mediu=
m devsel=2C latency 0<br><br>00:00.4 Host bridge: VIA Technologies=2C Inc. =
VT3351 Host Bridge<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Subsystem: ASRock Incorporation Device 4351<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C medium devsel=2C late=
ncy 0<br><br>00:00.5 PIC: VIA Technologies=2C Inc. VT3351 I/O APIC Interrup=
t Controller (prog-if 20 [IO(X)-APIC])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation Device 5351<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C f=
ast devsel=2C latency 0<br><br>00:00.7 Host bridge: VIA Technologies=2C Inc=
. VT3351 Host Bridge<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B Flags: bus master=2C medium devsel=2C latency 0<br><br>00:01.0 PCI br=
idge: VIA Technologies=2C Inc. [K8T890 North / VT8237 South] PCI Bridge (pr=
og-if 00 [Normal decode])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Flags: bus master=2C 66MHz=2C medium devsel=2C latency 0<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Bus: primary=3D00=2C =
secondary=3D01=2C subordinate=3D01=2C sec-latency=3D0<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [70] Power Management =
version 2<br><br>00:02.0 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to=
 PCI Bridge Controller (prog-if 00 [Normal decode])<br>&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C fast devsel=2C la=
tency 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Bus: pr=
imary=3D00=2C secondary=3D06=2C subordinate=3D06=2C sec-latency=3D0<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O behind bridge: 000=
0e000-0000efff<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Memory behind bridge: fea00000-feafffff<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B Prefetchable memory behind bridge: 00000000f000000=
0-00000000f7ffffff<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Capabilities: [40] Express Root Port (Slot+)=2C MSI 00<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] Power Manage=
ment version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 E=
nable-<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabili=
ties: [100] Advanced Error Reporting &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [140] Virtual Channel &lt=
=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capa=
bilities: [180] Root Complex Link &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: pcieport-driver<br><=
br>00:03.0 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Co=
ntroller (prog-if 00 [Normal decode])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C fast devsel=2C latency 0<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Bus: primary=3D00=2C =
secondary=3D05=2C subordinate=3D05=2C sec-latency=3D0<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [40] Express Root Port=
 (Slot+)=2C MSI 00<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Capabilities: [68] Power Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [70] Message Signalled In=
terrupts: Mask- 64bit+ Queue=3D0/0 Enable-<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [100] Advanced Error Reporting &l=
t=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Cap=
abilities: [140] Virtual Channel &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [180] Root Complex Link &lt=
=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kern=
el driver in use: pcieport-driver<br><br>00:03.1 PCI bridge: VIA Technologi=
es=2C Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])=
<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus mas=
ter=2C fast devsel=2C latency 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B Bus: primary=3D00=2C secondary=3D04=2C subordinate=3D04=2C=
 sec-latency=3D0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Capabilities: [40] Express Root Port (Slot+)=2C MSI 00<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] Power Manage=
ment version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 E=
nable-<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabili=
ties: [100] Advanced Error Reporting &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [140] Virtual Channel &lt=
=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capa=
bilities: [180] Root Complex Link &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: pcieport-driver<br><=
br>00:03.2 PCI bridge: VIA Technologies=2C Inc. K8T890 PCI to PCI Bridge Co=
ntroller (prog-if 00 [Normal decode])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C fast devsel=2C latency 0<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Bus: primary=3D00=2C =
secondary=3D03=2C subordinate=3D03=2C sec-latency=3D0<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O behind bridge: 0000d000-0000dfff=
<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory behind =
bridge: fe900000-fe9fffff<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Capabilities: [40] Express Root Port (Slot+)=2C MSI 00<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] Powe=
r Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+ Queue=
=3D0/0 Enable-<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Capabilities: [100] Advanced Error Reporting &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [140] Virtual Cha=
nnel &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Kernel driver in use: pcieport-driver<br><br>00:03.3 PCI bridge: VIA Te=
chnologies=2C Inc. K8T890 PCI to PCI Bridge Controller (prog-if 00 [Normal =
decode])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags:=
 bus master=2C fast devsel=2C latency 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B Bus: primary=3D00=2C secondary=3D02=2C subordinate=
=3D02=2C sec-latency=3D0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B I/O behind bridge: 0000c000-0000cfff<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory behind bridge: fe800000-fe8fffff=
<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: =
[40] Express Root Port (Slot+)=2C MSI 00<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] Power Management version 2<b=
r>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [7=
0] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 Enable-<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [100] Adv=
anced Error Reporting &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B Capabilities: [140] Virtual Channel &lt=3B?&gt=3B<br>&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [180]=
 Root Complex Link &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Kernel driver in use: pcieport-driver<br><br>00:09.0 Ne=
twork controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: Micro-Star I=
nternational Co.=2C Ltd. Device 6834<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C slow devsel=2C latency 32=2C IRQ=
 16<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at f=
e7fc000 (32-bit=2C non-prefetchable) [size=3D8K]<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [40] Power Management ver=
sion 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel d=
river in use: rt2500<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B Kernel modules: rt2500=2C rt2500pci<br><br>00:0a.0 Multimedia video c=
ontroller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)<br>&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=
=2C medium devsel=2C latency 32=2C IRQ 11<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at fd000000 (32-bit=2C non-prefetchable)=
 [size=3D16M]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B C=
apabilities: [44] Vital Product Data &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [4c] Power Management ver=
sion 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel m=
odules: cx8800<br><br>00:0f.0 IDE interface: VIA Technologies=2C Inc. VT823=
7A SATA 2-Port Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO]=
)<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: AS=
Rock Incorporation Device 0591<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 21<=
br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at bc=
00 [size=3D8]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I=
/O ports at b880 [size=3D4]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B I/O ports at b800 [size=3D8]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at b480 [size=3D4]<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at b400 [size=3D16]<b=
r>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at b00=
0 [size=3D256]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Capabilities: [c0] Power Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: sata_via<br>&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modules: sata_via=2C =
pata_acpi<br><br>00:0f.1 IDE interface: VIA Technologies=2C Inc. VT82C586A/=
B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07) (prog-if 8a [Master =
SecP PriP])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Sub=
system: ASRock Incorporation K7VT2/K7VT6 motherboard<br>&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C medium devsel=2C=
 latency 32<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B [vi=
rtual] Memory at 000001f0 (32-bit=2C non-prefetchable) [disabled] [size=3D8=
]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B [virtual] Mem=
ory at 000003f0 (type 3=2C non-prefetchable) [disabled] [size=3D1]<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B [virtual] Memory at 000=
00170 (32-bit=2C non-prefetchable) [disabled] [size=3D8]<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B [virtual] Memory at 00000370 (t=
ype 3=2C non-prefetchable) [disabled] [size=3D1]<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at fc00 [size=3D16]<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [c0] Powe=
r Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Kernel driver in use: VIA_IDE<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B Kernel modules: pata_acpi=2C pata_via<br><br>00:10.0=
 USB Controller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Controller=
 (rev a0) (prog-if 00 [UHCI])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B Subsystem: ASRock Incorporation K7VT6<br>&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C medium devsel=2C=
 latency 32=2C IRQ 20<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B I/O ports at a480 [size=3D32]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B Capabilities: [80] Power Management version 2<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: =
uhci_hcd<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel=
 modules: uhci-hcd<br><br>00:10.1 USB Controller: VIA Technologies=2C Inc. =
VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])<br>&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorpora=
tion K7VT6<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flag=
s: bus master=2C medium devsel=2C latency 32=2C IRQ 22<br>&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at a800 [size=3D32]<br>&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [80] P=
ower Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Kernel driver in use: uhci_hcd<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modules: uhci-hcd<br><br>00:10.2 USB Con=
troller: VIA Technologies=2C Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0=
) (prog-if 00 [UHCI])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B Subsystem: ASRock Incorporation K7VT6<br>&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C medium devsel=2C latency=
 32=2C IRQ 21<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I=
/O ports at a880 [size=3D32]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B Capabilities: [80] Power Management version 2<br>&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: uhci_hcd=
<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modules=
: uhci-hcd<br><br>00:10.3 USB Controller: VIA Technologies=2C Inc. VT82xxxx=
x UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])<br>&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation K7V=
T6<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus m=
aster=2C medium devsel=2C latency 32=2C IRQ 23<br>&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at ac00 [size=3D32]<br>&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [80] Power Man=
agement version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Kernel driver in use: uhci_hcd<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Kernel modules: uhci-hcd<br><br>00:10.4 USB Controller:=
 VIA Technologies=2C Inc. USB 2.0 (rev 86) (prog-if 20 [EHCI])<br>&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorpora=
tion K7VT6 motherboard<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Flags: bus master=2C medium devsel=2C latency 32=2C IRQ 21<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at fe7ffc00 (32-=
bit=2C non-prefetchable) [size=3D256]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B Capabilities: [80] Power Management version 2<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use:=
 ehci_hcd<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kerne=
l modules: ehci-hcd<br><br>00:11.0 ISA bridge: VIA Technologies=2C Inc. VT8=
237A PCI to ISA Bridge<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Subsystem: ASRock Incorporation Device 3337<br>&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: medium devsel<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [c0] Power Manage=
ment version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Kernel modules: i2c-viapro<br><br>00:11.7 Host bridge: VIA Technologies=2C =
Inc. VT8251 Ultra VLINK Controller<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Subsystem: VIA Technologies=2C Inc. Device 337e<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C m=
edium devsel=2C latency 32<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Capabilities: [58] HyperTransport: Interrupt Discovery and Conf=
iguration<br><br>00:13.0 Host bridge: VIA Technologies=2C Inc. VT8237A Host=
 Bridge<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: =
bus master=2C fast devsel=2C latency 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [60] HyperTransport: MSI Mapping Enab=
le- Fixed+<br><br>00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Ath=
lon64/Opteron] HyperTransport Technology Configuration<br>&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: fast devsel<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [80] HyperTranspo=
rt: Host or Secondary Interface<br><br>00:18.1 Host bridge: Advanced Micro =
Devices [AMD] K8 [Athlon64/Opteron] Address Map<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: fast devsel<br><br>00:18.2 Host bri=
dge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller<br>=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: fast devsel=
<br><br>00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opte=
ron] Miscellaneous Control<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Flags: fast devsel<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B Capabilities: [f0] Secure device &lt=3B?&gt=3B<br>&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: k8tem=
p<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel module=
s: k8temp<br><br>02:00.0 SATA controller: JMicron Technologies=2C Inc. JMic=
ron 20360/20363 AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incor=
poration Device 2363<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 40<br>&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at fe8fe000 (32-bit=
=2C non-prefetchable) [size=3D8K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Expansion ROM at fe8e0000 [disabled] [size=3D64K]<br>&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] P=
ower Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Capabilities: [50] Express Legacy Endpoint=2C MSI 01<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: a=
hci<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modu=
les: ahci<br><br>02:00.1 IDE interface: JMicron Technologies=2C Inc. JMicro=
n 20360/20363 AHCI Controller (rev 02) (prog-if 85 [Master SecO PriO])<br>&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock I=
ncorporation Device 2363<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 41<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at cc00 [siz=
e=3D8]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O port=
s at c880 [size=3D4]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B I/O ports at c800 [size=3D8]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B I/O ports at c480 [size=3D4]<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at c400 [size=3D16]<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [68] Powe=
r Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B Kernel driver in use: pata_jmicron<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modules: pata_acpi=2C pata_jmicron=2C jm=
icron<br><br>03:00.0 Ethernet controller: Realtek Semiconductor Co.=2C Ltd.=
 RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)<br>&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorpor=
ation Device 8168<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Flags: bus master=2C fast devsel=2C latency 0=2C IRQ 36<br>&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at d800 [size=3D256]=
<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at fe9f=
f000 (64-bit=2C non-prefetchable) [size=3D4K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Expansion ROM at fe9c0000 [disabled] [size=
=3D128K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabi=
lities: [40] Power Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [48] Vital Product Data &lt=3B?&gt=
=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilitie=
s: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/1 Enable-<br>&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [60] =
Express Endpoint=2C MSI 00<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Capabilities: [84] Vendor Specific Information &lt=3B?&gt=3B<br=
>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [10=
0] Advanced Error Reporting &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [12c] Virtual Channel &lt=3B?&gt=
=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilitie=
s: [148] Device Serial Number 68-81-ec-10-00-00-00-1a<br>&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [154] Power Budgeting =
&lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B K=
ernel driver in use: r8169<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Kernel modules: r8169<br><br>06:00.0 VGA compatible controller:=
 ATI Technologies Inc RV370 [Sapphire X550 Silent] (prog-if 00 [VGA control=
ler])<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem=
: Micro-Star International Co.=2C Ltd. Device 3000<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=2C fast devsel=2C lat=
ency 0=2C IRQ 10<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Memory at f0000000 (32-bit=2C prefetchable) [size=3D128M]<br>&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B I/O ports at e000 [size=3D25=
6]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at fe=
ae0000 (32-bit=2C non-prefetchable) [size=3D64K]<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Expansion ROM at feac0000 [disabled] [s=
ize=3D128K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Cap=
abilities: [50] Power Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [58] Express Endpoint=2C MSI 00<b=
r>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [8=
0] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/0 Enable-<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [100] Adv=
anced Error Reporting &lt=3B?&gt=3B<br><br>06:00.1 Display controller: ATI =
Technologies Inc RV370 secondary [Sapphire X550 Silent]<br>&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: Micro-Star Internationa=
l Co.=2C Ltd. Device 3001<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Flags: bus master=2C fast devsel=2C latency 0<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Memory at feaf0000 (32-bit=2C n=
on-prefetchable) [size=3D64K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B Capabilities: [50] Power Management version 2<br>&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [58] Express En=
dpoint=2C MSI 00<br><br>80:01.0 Audio device: VIA Technologies=2C Inc. VIA =
High Definition Audio Controller (rev 10)<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Subsystem: ASRock Incorporation Device 0888<br>=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Flags: bus master=
=2C fast devsel=2C latency 0=2C IRQ 17<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B Memory at febfc000 (64-bit=2C non-prefetchable) [si=
ze=3D16K]<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Capab=
ilities: [50] Power Management version 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Capabilities: [60] Message Signalled Interrupts=
: Mask- 64bit+ Queue=3D0/0 Enable-<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Capabilities: [70] Express Root Complex Integrated Endp=
oint=2C MSI 00<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Capabilities: [100] Virtual Channel &lt=3B?&gt=3B<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel driver in use: HDA Intel<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Kernel modules: snd-hd=
a-intel<br><br>Please note I have an issue with my graphics card which is f=
illing up my dmesg=2C so I'm not getting much useful information out of tha=
t. Has anyone experience the missing records in lspci before - should I be =
looking to return the card or are there further diagnostics I can do?<br><b=
r /><hr />Read amazing stories to your kids on Messenger <a href=3D'http://=
clk.atdmt.com/UKM/go/117588488/direct/01/' target=3D'_new'>Try it Now!</a><=
/body>
</html>=

--_855bae13-39e1-4104-aa2e-6fa0a02e8f7f_--


--===============1741492375==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1741492375==--
