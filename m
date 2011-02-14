Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx11.extmail.prod.ext.phx2.redhat.com
	[10.5.110.16])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1E1XUAM005146
	for <video4linux-list@redhat.com>; Sun, 13 Feb 2011 20:33:30 -0500
Received: from smtpdeliver.argentina.com (smtpdeliver.argentina.com
	[200.41.60.83])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1E1XLld018363
	for <video4linux-list@redhat.com>; Sun, 13 Feb 2011 20:33:21 -0500
Date: Sun, 13 Feb 2011 22:26:24 -0300
To: robert@robertrampy.com
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?= <alfredodelaiti@argentina.com>
Subject: Re: RE: MyGica X8507 analog sound
Message-ID: <dc2003cd19dffc7df248fc81970a5e8f@smtp-x1.argentina.com>
MIME-Version: 1.0
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi robert

You can see the features here:

http://www.linuxtv.org/wiki/index.php/Geniatech/MyGica_X8507_PCI-Express_Hy=
brid_Card

the card is pci-e, the tuner is Xceive_XC5000

Thanks in advance

______________________________________________
dmesg:

[=A0=A0=A0 8.789925] cx23885 driver version 0.0.2 loaded
[=A0=A0=A0 8.796121] cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low)=
 -> IRQ 19
[=A0=A0=A0 8.796297] CORE cx23885[0]: subsystem: 14f1:8502, board: Mygica X=
8506 DMB-TH [card=3D22,insmod option]
[=A0=A0=A0 9.781961] cx25840 4-0044: cx23885 A/V decoder found @ 0x88 (cx23=
885[0])
[=A0=A0=A0 9.790239] cx25840 4-0044: firmware: requesting v4l-cx23885-avcor=
e-01.fw
[=A0=A0 10.419165] cx25840 4-0044: loaded v4l-cx23885-avcore-01.fw firmware=
 (16382 bytes)
[=A0=A0 10.528011] tuner 3-0061: chip found @ 0xc2 (cx23885[0])
[=A0=A0 10.609111] xc5000 3-0061: creating new instance
[=A0=A0 10.609810] xc5000: Successfully identified at address 0x61
[=A0=A0 10.609812] xc5000: Firmware has not been loaded previously
[=A0=A0 10.609874] cx23885[0]/0: registered device video1 [v4l2]
[=A0=A0 10.615355] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.1=
14.fw)...
[=A0=A0 10.615358] cx23885 0000:02:00.0: firmware: requesting dvb-fe-xc5000=
-1.6.114.fw
[=A0=A0 10.616861] xc5000: firmware read 12401 bytes.
[=A0=A0 10.616863] xc5000: firmware uploading...
[=A0=A0 12.001015] xc5000: firmware upload complete...
[=A0=A0 12.653056] cx23885_dvb_register() allocating 1 frontend(s)
[=A0=A0 12.653060] cx23885[0]: cx23885 based dvb card
[=A0=A0 12.706639] xc5000 3-0061: attaching existing instance
[=A0=A0 12.707367] xc5000: Successfully identified at address 0x61
[=A0=A0 12.707369] xc5000: Firmware has been loaded previously
[=A0=A0 12.707373] DVB: registering new adapter (cx23885[0])
[=A0=A0 12.707377] DVB: registering adapter 0 frontend 0 (Legend Silicon LG=
S8913/LGS8GXX DMB-TH)...
[=A0=A0 12.707647] cx23885_dev_checkrevision() Hardware revision =3D 0xb0
[=A0=A0 12.707656] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, la=
tency: 0, mmio: 0xfd600000
[=A0=A0 12.707664] cx23885 0000:02:00.0: setting latency timer to 64
[=A0=A0 12.707669] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on sh=
ared IRQs

_________________________________________________________


lspci -vvvnnn


02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 =
PCI Video and Audio Decoder [14f1:8852] (rev 02)
=A0=A0=A0=A0=A0=A0=A0 Subsystem: Conexant Systems, Inc. Device [14f1:8502]
=A0=A0=A0=A0=A0=A0=A0 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGA=
Snoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
=A0=A0=A0=A0=A0=A0=A0 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfa=
st >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
=A0=A0=A0=A0=A0=A0=A0 Latency: 0, Cache Line Size: 4 bytes
=A0=A0=A0=A0=A0=A0=A0 Interrupt: pin A routed to IRQ 19
=A0=A0=A0=A0=A0=A0=A0 Region 0: Memory at fd600000 (64-bit, non-prefetchabl=
e) [size=3D2M]
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [40] Express (v1) Endpoint, MSI 00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DevCap: MaxPayload 128 bytes,=
 PhantFunc 0, Latency L0s <64ns, L1 <1us
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ExtTa=
g- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DevCtl: Report errors: Correc=
table- Non-Fatal- Fatal- Unsupported-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RlxdO=
rd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MaxPa=
yload 128 bytes, MaxReadReq 512 bytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DevSta: CorrErr- UncorrErr+ F=
atalErr- UnsuppReq+ AuxPwr- TransPend-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LnkCap: Port #0, Speed 2.5GT/=
s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <4us
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Clock=
PM- Surprise- LLActRep- BwNot-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LnkCtl: ASPM Disabled; RCB 64=
 bytes Disabled- Retrain- CommClk+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ExtSy=
nch- ClockPM- AutWidDis- BWInt- AutBWInt-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 LnkSta: Speed 2.5GT/s, Width =
x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [80] Power Management version 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Flags: PMEClk- DSI+ D1+ D2+ A=
uxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Status: D0 NoSoftRst- PME-Ena=
ble- DSel=3D0 DScale=3D0 PME-
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [90] Vital Product Data
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Product Name: "
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 End
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable-=
 64bit+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Address: 0000000000000000=A0 =
Data: 0000
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [100 v1] Advanced Error Reporting
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UESta:=A0 DLP- SDES- TLP- FCP=
- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UEMsk:=A0 DLP- SDES- TLP- FCP=
- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UESvrt: DLP+ SDES- TLP- FCP+ =
CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CESta:=A0 RxErr- BadTLP- BadD=
LLP- Rollover- Timeout- NonFatalErr-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CEMsk:=A0 RxErr- BadTLP- BadD=
LLP- Rollover- Timeout- NonFatalErr-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 AERCap: First Error Pointer: =
14, GenCap- CGenEn- ChkCap- ChkEn-
=A0=A0=A0=A0=A0=A0=A0 Capabilities: [200 v1] Virtual Channel
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Caps:=A0=A0 LPEVC=3D0 RefClk=
=3D100ns PATEntryBits=3D1
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Arb:=A0=A0=A0 Fixed+ WRR32+ W=
RR64+ WRR128-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ctrl:=A0=A0 ArbSelect=3DWRR64
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Status: InProgress-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Port Arbitration Table [240] =
<?>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VC0:=A0=A0=A0 Caps:=A0=A0 PAT=
Offset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Arb:=
=A0=A0=A0 Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ctrl:=
=A0=A0 Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3Dff
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Statu=
s: NegoPending- InProgress-
=A0=A0=A0=A0=A0=A0=A0 Kernel driver in use: cx23885




----- Mensaje original -----
Fecha:    Sat, 12 Feb 2011 15:56:41 -0700
De:       robert@robertrampy.com
Para:     "Alfredo_Jes=FAs_Delaiti" <alfredodelaiti@argentina.com>
Asunto:   RE: MyGica X8507 analog sound
 =

send me your dmesg.=A0 Also is your cards pci-e.=A0 Do you know what type o=
f tuner is in that card?




=A0 send me a lspci -vvvnnn




thanks
Bob





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
