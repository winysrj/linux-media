Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <gbirchley@blueyonder.co.uk>) id 1W5FCa-0004Gu-8w
	for linux-dvb@linuxtv.org; Mon, 20 Jan 2014 14:47:45 +0100
Received: from mail-ee0-f46.google.com ([74.125.83.46])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1W5FCY-0007ka-8E; Mon, 20 Jan 2014 14:47:44 +0100
Received: by mail-ee0-f46.google.com with SMTP id c13so3360590eek.19
	for <linux-dvb@linuxtv.org>; Mon, 20 Jan 2014 05:47:42 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 20 Jan 2014 13:47:41 +0000
Message-ID: <CACmgMmC5=M_AjnovXcQf+0+oqwuG2sOBngTVBHZWi08w8jqtEQ@mail.gmail.com>
From: birchley giles <gbirchley@blueyonder.co.uk>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TerraTec Cinergy 2400i DVB-T PCIe - unable to tune
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2096801339=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2096801339==
Content-Type: multipart/alternative; boundary=047d7b603b16bddbce04f0672259

--047d7b603b16bddbce04f0672259
Content-Type: text/plain; charset=ISO-8859-1

I've just aquired a TerraTec Cinergy 2400i DVB-T PCIe card and am unable to
get it working under Fedora 19 3.11.7-200.fc19.x86_64. I'd very much like
to hear from anyone who is running the card for advice and also some
indication whether this is my user error or a driver, distro or software
issue.

The card is reported to work under linux: <
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T> and is
detected by lspci.

$lspci -vvvnn

02:00.0 Multimedia video controller [0400]: Micronas Semiconductor Holding
AG nGene PCI-Express Multimedia Controller [18c3:0720]
        Subsystem: TERRATEC Electronic GmbH Device [153b:1167]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at fbbf0000 (32-bit, non-prefetchable) [size=64K]
        Region 1: Memory at fbbe0000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-
)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency
L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Device Serial Number 00-00-00-07-20-3c-11-00
        Capabilities: [400 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: ngene


$ modinfo ngene
filename:
/lib/modules/3.11.7-200.fc19.x86_64/kernel/drivers/media/pci/ngene/ngene.ko
license:        GPL
author:         Micronas, Ralph Metzler, Manfred Voelkel
description:    nGene
alias:          pci:v000018C3d00000720sv0000153Bsd00001167bc*sc*i*
alias:          pci:v000018C3d00000720sv00001461sd0000062Ebc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000DD20bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000DD10bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000DD00bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000DB02bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000DB01bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000ABC4bc*sc*i*
alias:          pci:v000018C3d00000720sv000018C3sd0000ABC3bc*sc*i*
depends:        dvb-core,i2c-core
intree:         Y
vermagic:       3.11.7-200.fc19.x86_64 SMP mod_unload
signer:         Fedora kernel signing key
sig_key:        81:C0:9E:56:78:F2:46:05:66:AF:2E:DE:38:3D:4B:66:D9:CD:13:F7
sig_hashalgo:   sha256
parm:           one_adapter:Use only one adapter. (int)
parm:           shutdown_workaround:Activate workaround for shutdown
problem with some chipsets. (int)
parm:           debug:Print debugging information. (int)
parm:           adapter_nr:DVB adapter numbers (array of short)


$ dmesg | grep ngene
[    4.401045] ngene: Found Terratec Integra/Cinergy2400i Dual DVB-T
[    4.401613] ngene: Device version 1
[    4.403282] ngene: Loading firmware file ngene_15.fw.
[    4.473560] ngene 0000:02:00.0: DVB: registering adapter 0 frontend 0
(Micronas DRXD DVB-T)...
[    4.509774] ngene 0000:02:00.0: DVB: registering adapter 1 frontend 0
(Micronas DRXD DVB-T)...



dmesg confirms the driver and firmware are loaded. Channel scanning under
mythtv, even with an increased signal timeout and tuning timeout, fails to
find any channels - the signal strength sits at 88% throughout and the
Signal / Noise at 12%. Channel scanning under Kaffeine also fails. The card
tunes and works fine with the Terratec software under Windows 7.


The screen output from mythtv-setup is:

2014-01-19 19:47:04.652938 I  Current MythTV Schema Version (DBSchemaVer):
1317
2014-01-19 19:47:19.317900 W  DiSEqCDevTree: No device tree for cardid 1
2014-01-19 19:47:19.332598 W  DiSEqCDevTree: No device tree for cardid 5
2014-01-19 19:47:19.336151 W  DiSEqCDevTree: No device tree for cardid 8
2014-01-19 19:47:19.339648 W  DiSEqCDevTree: No device tree for cardid 10
2014-01-19 19:50:17.436930 C  MThread prolog was never run!
2014-01-19 19:50:17.438373 I  ChanImport: No new channels to process

running Fuser /dev/dvb/adapter0/frontend0 while the scan is running gives
an output of :3760 - so the card is being utilised.

As the card is the second dual tuner in my myth box, (but occupies devices
/dev/dvb/adapter0  and /dev/dvb/adapter1). I have an already tuned input -
on this count the card won't find a a signal lock if I attach it to working
input.

Any help would be sorely appreciated. Thanks,

Giles

--047d7b603b16bddbce04f0672259
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;ve just aquired a TerraTec Cinergy 2400i DVB-T PCIe =
card and am unable to
get it working under Fedora 19 3.11.7-200.fc19.x86_64. I&#39;d very much li=
ke
to hear from anyone who is running the card for advice and also some indica=
tion whether this is my user error or a driver, distro or software issue.<b=
r>
<br>
The card is reported to work under linux: &lt;<a href=3D"http://linuxtv.org=
/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T" target=3D"_blank">http://linu=
xtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T</a>&gt; and is<br>
detected by lspci.<br>
<br>
$lspci -vvvnn<br>
<br>
02:00.0 Multimedia video controller [0400]: Micronas Semiconductor Holding<=
br>
AG nGene PCI-Express Multimedia Controller [18c3:0720]<br>
=A0 =A0 =A0 =A0 Subsystem: TERRATEC Electronic GmbH Device [153b:1167]<br>
=A0 =A0 =A0 =A0 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=
 ParErr-<br>
Stepping- SERR+ FastB2B- DisINTx-<br>
=A0 =A0 =A0 =A0 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast &gt=
;TAbort-<br>
&lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR- INTx-<br>
=A0 =A0 =A0 =A0 Latency: 0, Cache Line Size: 64 bytes<br>
=A0 =A0 =A0 =A0 Interrupt: pin A routed to IRQ 32<br>
=A0 =A0 =A0 =A0 Region 0: Memory at fbbf0000 (32-bit, non-prefetchable) [si=
ze=3D64K]<br>
=A0 =A0 =A0 =A0 Region 1: Memory at fbbe0000 (64-bit, non-prefetchable) [si=
ze=3D64K]<br>
=A0 =A0 =A0 =A0 Capabilities: [40] Power Management version 2<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0m=
A<br>
PME(D0-,D1-,D2-,D3hot-,D3cold-<div id=3D":on">)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 =
DScale=3D0 PME-<br>
=A0 =A0 =A0 =A0 Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 64bit=
+<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Address: 0000000000000000 =A0Data: 0000<br>
=A0 =A0 =A0 =A0 Capabilities: [58] Express (v1) Endpoint, MSI 00<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCap: MaxPayload 128 bytes, PhantFunc 0, =
Latency L0s<br>
&lt;64ns, L1 &lt;1us<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ExtTag- AttnBtn- AttnInd- P=
wrInd- RBE- FLReset-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevCtl: Report errors: Correctable- Non-Fat=
al- Fatal-<br>
Unsupported-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RlxdOrd- ExtTag- PhantFunc-=
 AuxPwr- NoSnoop+<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MaxPayload 128 bytes, MaxRe=
adReq 512 bytes<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DevSta: CorrErr- UncorrErr+ FatalErr- Unsup=
pReq+ AuxPwr-<br>
TransPend-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkCap: Port #0, Speed 2.5GT/s, Width x1, A=
SPM L0s, Latency<br>
L0 unlimited, L1 unlimited<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClockPM- Surprise- LLActRep=
- BwNot-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkCtl: ASPM Disabled; RCB 64 bytes Disable=
d- Retrain-<br>
CommClk-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ExtSynch- ClockPM- AutWidDi=
s- BWInt- AutBWInt-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Tra=
in- SlotClk+<br>
DLActive- BWMgmt- ABWMgmt-<br>
=A0 =A0 =A0 =A0 Capabilities: [100 v1] Device Serial Number 00-00-00-07-20-=
3c-11-00<br>
=A0 =A0 =A0 =A0 Capabilities: [400 v1] Virtual Channel<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Caps: =A0 LPEVC=3D0 RefClk=3D100ns PATEntry=
Bits=3D1<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Arb: =A0 =A0Fixed- WRR32- WRR64- WRR128-<br=
>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Ctrl: =A0 ArbSelect=3DFixed<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Status: InProgress-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 VC0: =A0 =A0Caps: =A0 PATOffset=3D00 MaxTim=
eSlots=3D1 RejSnoopTrans-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Arb: =A0 =A0Fixed- WRR32- W=
RR64- WRR128- TWRR128-<br>
WRR256-<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Ctrl: =A0 Enable+ ID=3D0 Ar=
bSelect=3DFixed TC/VC=3Dff<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Status: NegoPending- InProg=
ress-<br>
=A0 =A0 =A0 =A0 Kernel driver in use: ngene<br>
<br>
<br>
$ modinfo ngene<br>
filename:<br>
/lib/modules/3.11.7-200.fc19.x86_64/kernel/drivers/media/pci/ngene/ngene.ko=
<br>
license: =A0 =A0 =A0 =A0GPL<br>
author: =A0 =A0 =A0 =A0 Micronas, Ralph Metzler, Manfred Voelkel<br>
description: =A0 =A0nGene<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv0000153Bsd00001167bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv00001461sd0000062Ebc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000DD20bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000DD10bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000DD00bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000DB02bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000DB01bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000ABC4bc*sc*i=
*<br>
alias: =A0 =A0 =A0 =A0 =A0pci:v000018C3d00000720sv000018C3sd0000ABC3bc*sc*i=
*<br>
depends: =A0 =A0 =A0 =A0dvb-core,i2c-core<br>
intree: =A0 =A0 =A0 =A0 Y<br>
vermagic: =A0 =A0 =A0 3.11.7-200.fc19.x86_64 SMP mod_unload<br>
signer: =A0 =A0 =A0 =A0 Fedora kernel signing key<br>
sig_key: =A0 =A0 =A0 =A081:C0:9E:56:78:F2:46:05:66:AF:2E:DE:38:3D:4B:66:D9:=
CD:13:F7<br>
sig_hashalgo: =A0 sha256<br>
parm: =A0 =A0 =A0 =A0 =A0 one_adapter:Use only one adapter. (int)<br>
parm: =A0 =A0 =A0 =A0 =A0 shutdown_workaround:Activate workaround for shutd=
own<br>
problem with some chipsets. (int)<br>
parm: =A0 =A0 =A0 =A0 =A0 debug:Print debugging information. (int)<br>
parm: =A0 =A0 =A0 =A0 =A0 adapter_nr:DVB adapter numbers (array of short)<b=
r>
<br>
<br>
$ dmesg | grep ngene<br>
[ =A0 =A04.401045] ngene: Found Terratec Integra/Cinergy2400i Dual DVB-T<br=
>
[ =A0 =A04.401613] ngene: Device version 1<br>
[ =A0 =A04.403282] ngene: Loading firmware file ngene_15.fw.<br>
[ =A0 =A04.473560] ngene 0000:02:00.0: DVB: registering adapter 0 frontend =
0<br>
(Micronas DRXD DVB-T)...<br>
[ =A0 =A04.509774] ngene 0000:02:00.0: DVB: registering adapter 1 frontend =
0<br>
(Micronas DRXD DVB-T)...<br>
<br>
<br>
<br>
dmesg confirms the driver and firmware are loaded. Channel scanning under=
=A0
mythtv, even with an increased signal timeout and tuning timeout, fails to
find any channels - the signal strength sits at 88% throughout and the
Signal / Noise at 12%. Channel scanning under Kaffeine also fails. The card=
 tunes and works fine with the Terratec software under Windows 7.<br>
<br>
<br>
The screen output from mythtv-setup is:<br>
<br>
2014-01-19 19:47:04.652938 I =A0Current MythTV Schema Version (DBSchemaVer)=
:<br>
1317<br>
2014-01-19 19:47:19.317900 W =A0DiSEqCDevTree: No device tree for cardid 1<=
br>
2014-01-19 19:47:19.332598 W =A0DiSEqCDevTree: No device tree for cardid 5<=
br>
2014-01-19 19:47:19.336151 W =A0DiSEqCDevTree: No device tree for cardid 8<=
br>
2014-01-19 19:47:19.339648 W =A0DiSEqCDevTree: No device tree for cardid 10=
<br>
2014-01-19 19:50:17.436930 C =A0MThread prolog was never run!<br>
2014-01-19 19:50:17.438373 I =A0ChanImport: No new channels to process<br>
<br>
running Fuser /dev/dvb/adapter0/frontend0 while the scan is running gives
an output of :3760 - so the card is being utilised.<br>
<br>
As the card is the second dual tuner in my myth box, (but occupies devices
/dev/dvb/adapter0 =A0and /dev/dvb/adapter1). I have an already tuned input =
- on this count the card won&#39;t find a a signal
lock if I attach it to working input.<br>
<br>
Any help would be sorely appreciated. Thanks,<br>
<br><div style=3D"text-align:left">
Giles</div></div></div>

--047d7b603b16bddbce04f0672259--


--===============2096801339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2096801339==--
