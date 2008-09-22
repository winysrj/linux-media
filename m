Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta9.adelphia.net ([68.168.78.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tkrantz@stahurabrenner.com>) id 1KhlSs-0008DT-Pc
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 15:28:35 +0200
Received: from SBGCLTXP1 ([98.24.94.176]) by mta9.adelphia.net
	(InterMail vM.6.01.05.02 201-2131-123-102-20050715) with ESMTP
	id <20080922133648.KSRM7747.mta9.adelphia.net@SBGCLTXP1>
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 09:36:48 -0400
From: "Timothy E. Krantz" <tkrantz@stahurabrenner.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 22 Sep 2008 09:27:57 -0400
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAEH2unQOalpGjvGmwr9GMIQBAAAAAA==@stahurabrenner.com>
MIME-Version: 1.0
Subject: [linux-dvb] CX88 IRQ Loop
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1624395021=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1624395021==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0A7B_01C91C95.7FD3C6A0"

This is a multi-part message in MIME format.

------=_NextPart_000_0A7B_01C91C95.7FD3C6A0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi,
I am getting the following problems as reported in dmesg.
 
Any help would be appreciated.
 
Thanks,
 
Tim
 
Linux video capture interface: v2.00
cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:09.1[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58,autodetecte
d]
cx88[0]: TV tuner type 76, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
tuner' 1-0064: chip found @ 0xc8 (cx88[0])
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[0]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /class/input/input7
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:00:09.2[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]/2: found at 0000:00:09.2, rev: 5, irq: 20, latency: 64, mmio:
0xde000000
cx88[1]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58,autodetecte
d]
cx88[1]: TV tuner type 76, Radio tuner type -1
tuner' 2-0064: chip found @ 0xc8 (cx88[1])
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[1]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /class/input/input8
cx88[1]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:00:0a.2[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/2: found at 0000:00:0a.2, rev: 5, irq: 21, latency: 64, mmio:
0xdb000000
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]/0: found at 0000:00:09.0, rev: 5, irq: 20, latency: 64, mmio:
0xdc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[0]/2: cx2388x based DVB/ATSC card
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx88[1]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[1]/2: cx2388x based DVB/ATSC card
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 19
NVRM: loading NVIDIA UNIX x86 Kernel Module  169.12  Thu Feb 14 17:53:07 PST
200
8
ACPI: PCI Interrupt 0000:00:02.7[C] -> GSI 18 (level, low) -> IRQ 21
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[1])
DVB: registering frontend 1 (Samsung S5H1409 QAM/8VSB Frontend)...
intel8x0_measure_ac97_clock: measured 50819 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:0a.1[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/1: CX88x/1: ALSA support for cx2388x boards
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/0: found at 0000:00:0a.0, rev: 5, irq: 21, latency: 64, mmio:
0xd9000000
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1572856k swap on /dev/mapper/VolGroup01-LogVol02.  Priority:-1
extents:1
across:1572856k
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ndiswrapper version 1.51 loaded (smp=yes, preempt=no)
usb 1-5: reset high speed USB device using ehci_hcd and address 2
ndiswrapper: driver netmw245 (Marvell,11/27/2006,1.0.4.9) loaded
wlan0: ethernet device 00:14:d1:39:73:20 using NDIS driver: netmw245,
version: 0
x1000308, NDIS version: 0x501, vendor: 'NDIS Network Adapter',
1286:2006.F.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK;
AES/CCMP w
ith WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper
ADDRCONF(NETDEV_UP): wlan0: link is not ready
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
wlan0: no IPv6 routers present
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
cx88[0]/1: IRQ loop detected, disabling interrupts
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/1: IRQ loop detected, disabling interrupts
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]: irq mpeg  [0x20040] 6* par_err*
cx88[0]/2-mpeg: general errors: 0x00020000
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]: irq mpeg  [0x60548a50] ts_risci2* 6* 9 11 15 rip_err* ts_err?* 22
29 30
cx88[0]/2-mpeg: general errors: 0x00140000
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]/2-mpeg: clearing mask
cx88[0]/0: irq loop -- clearing mask
cx88[0]: irq mpeg  [0xa0000] par_err* pci_abort*
cx88[0]/2-mpeg: general errors: 0x000a0000
irq 20: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Tainted: P        2.6.24.4-64.fc8 #1
 [<c04612be>] __report_bad_irq+0x36/0x75
 [<f15a3a16>] nv_kern_isr+0xa5/0xb2 [nvidia]
 [<c04614d8>] note_interrupt+0x1db/0x217
 [<c046091f>] handle_IRQ_event+0x23/0x51
 [<c0461c85>] handle_fasteoi_irq+0x86/0xa6
 [<c0461bff>] handle_fasteoi_irq+0x0/0xa6
 [<c0407688>] do_IRQ+0x8c/0xb8
 [<c04334a0>] irq_exit+0x53/0x6b
 [<c0405bbf>] common_interrupt+0x23/0x28
 [<c042a127>] finish_task_switch+0x25/0x8b
 [<c062ae0f>] schedule+0x624/0x663
 [<c0405bbf>] common_interrupt+0x23/0x28
 [<c0403e31>] default_idle+0x0/0x55
 [<c040366f>] cpu_idle+0xc8/0xcd
 [<c07509df>] start_kernel+0x336/0x33e
 [<c07500e0>] unknown_bootoption+0x0/0x195
 =======================
handlers:
[<f095f45a>] (cx8801_irq+0x0/0x1a0 [cx88_alsa])
[<f09b8e85>] (cx8802_irq+0x0/0x25d [cx8802])
[<f09de587>] (cx8800_irq+0x0/0x1eb [cx8800])
Disabling IRQ #20

------=_NextPart_000_0A7B_01C91C95.7FD3C6A0
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.6000.16705" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008>Hi,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D513392313-22092008>I am =
getting the=20
following problems as reported in dmesg.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D513392313-22092008>Any =
help would be=20
appreciated.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008>Thanks,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D513392313-22092008>Tim</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Linux video capture interface: =
v2.00<BR>cx2388x=20
alsa driver version 0.0.6 loaded<BR>ACPI: PCI Interrupt 0000:00:09.1[A] =
-&gt;=20
GSI 17 (level, low) -&gt; IRQ 20<BR>cx88[0]: subsystem: 11bd:0051, =
board:=20
Pinnacle PCTV HD 800i [card=3D58,autodetecte<BR>d]<BR>cx88[0]: TV tuner =
type 76,=20
Radio tuner type -1<BR>cx88/2: cx2388x MPEG-TS Driver Manager version =
0.0.6=20
loaded<BR>cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<BR>tuner' =
1-0064:=20
chip found @ 0xc8 (cx88[0])<BR>xc5000: Successfully identified at =
address=20
0x64<BR>xc5000: Firmware has not been loaded previously<BR>xc5000: =
waiting for=20
firmware upload (dvb-fe-xc5000-1.1.fw)...<BR>xc5000: firmware read 12332 =

bytes.<BR>xc5000: firmware upload<BR>cx88[0]: Calling XC5000 =
callback<BR>input:=20
cx88 IR (Pinnacle PCTV HD 800i) as /class/input/input7<BR>cx88[0]/1: =
CX88x/0:=20
ALSA support for cx2388x boards<BR>cx88[0]/2: cx2388x 8802 Driver=20
Manager<BR>ACPI: PCI Interrupt 0000:00:09.2[A] -&gt; GSI 17 (level, low) =
-&gt;=20
IRQ 20<BR>cx88[0]/2: found at 0000:00:09.2, rev: 5, irq: 20, latency: =
64, mmio:=20
0xde000000<BR>cx88[1]: subsystem: 11bd:0051, board: Pinnacle PCTV HD =
800i=20
[card=3D58,autodetecte<BR>d]<BR>cx88[1]: TV tuner type 76, Radio tuner =
type=20
-1</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>tuner' 2-0064: chip found @ 0xc8=20
(cx88[1])<BR>xc5000: Successfully identified at address 0x64<BR>xc5000: =
Firmware=20
has not been loaded previously<BR>xc5000: waiting for firmware upload=20
(dvb-fe-xc5000-1.1.fw)...<BR>xc5000: firmware read 12332 =
bytes.<BR>xc5000:=20
firmware upload<BR>cx88[1]: Calling XC5000 callback<BR>input: cx88 IR =
(Pinnacle=20
PCTV HD 800i) as /class/input/input8<BR>cx88[1]/2: cx2388x 8802 Driver=20
Manager<BR>ACPI: PCI Interrupt 0000:00:0a.2[A] -&gt; GSI 18 (level, low) =
-&gt;=20
IRQ 21<BR>cx88[1]/2: found at 0000:00:0a.2, rev: 5, irq: 21, latency: =
64, mmio:=20
0xdb000000<BR>ACPI: PCI Interrupt 0000:00:09.0[A] -&gt; GSI 17 (level, =
low)=20
-&gt; IRQ 20<BR>cx88[0]/0: found at 0000:00:09.0, rev: 5, irq: 20, =
latency: 64,=20
mmio: 0xdc000000<BR>cx88[0]/0: registered device video0 =
[v4l2]<BR>cx88[0]/0:=20
registered device vbi0<BR>cx88/2: cx2388x dvb driver version 0.0.6=20
loaded<BR>cx88/2: registering cx8802 driver, type: dvb access:=20
shared<BR>cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i=20
[card=3D58]<BR>cx88[0]/2: cx2388x based DVB/ATSC card<BR>xc5000: =
Successfully=20
identified at address 0x64<BR>xc5000: Firmware has been loaded=20
previously<BR>DVB: registering new adapter (cx88[0])<BR>DVB: registering =

frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>cx88[1]/2: subsystem: 11bd:0051, board: =
Pinnacle=20
PCTV HD 800i [card=3D58]<BR>cx88[1]/2: cx2388x based DVB/ATSC =
card<BR>ACPI: PCI=20
Interrupt 0000:01:00.0[A] -&gt; GSI 16 (level, low) -&gt; IRQ =
19<BR>NVRM:=20
loading NVIDIA UNIX x86 Kernel Module&nbsp; 169.12&nbsp; Thu Feb 14 =
17:53:07 PST=20
200<BR>8<BR>ACPI: PCI Interrupt 0000:00:02.7[C] -&gt; GSI 18 (level, =
low) -&gt;=20
IRQ 21<BR>xc5000: Successfully identified at address 0x64<BR>xc5000: =
Firmware=20
has been loaded previously<BR>DVB: registering new adapter =
(cx88[1])<BR>DVB:=20
registering frontend 1 (Samsung S5H1409 QAM/8VSB=20
Frontend)...<BR>intel8x0_measure_ac97_clock: measured 50819 =
usecs<BR>intel8x0:=20
clocking to 48000<BR>ACPI: PCI Interrupt 0000:00:0a.1[A] -&gt; GSI 18 =
(level,=20
low) -&gt; IRQ 21<BR>cx88[1]/1: CX88x/1: ALSA support for cx2388x=20
boards<BR>ACPI: PCI Interrupt 0000:00:0a.0[A] -&gt; GSI 18 (level, low) =
-&gt;=20
IRQ 21<BR>cx88[1]/0: found at 0000:00:0a.0, rev: 5, irq: 21, latency: =
64, mmio:=20
0xd9000000<BR>cx88[1]/0: registered device video1 [v4l2]<BR>cx88[1]/0:=20
registered device vbi1<BR>NET: Registered protocol family 10<BR>lo: =
Disabled=20
Privacy Extensions<BR>agpgart: Found an AGP 3.5 compliant device at=20
0000:00:00.0.<BR>agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x=20
mode<BR>agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x =
mode</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>loop: module loaded<BR>EXT3 FS on dm-0, =
internal=20
journal<BR>kjournald starting.&nbsp; Commit interval 5 seconds<BR>EXT3 =
FS on=20
sda1, internal journal<BR>EXT3-fs: mounted filesystem with ordered data=20
mode.<BR>kjournald starting.&nbsp; Commit interval 5 seconds<BR>EXT3 FS =
on dm-1,=20
internal journal<BR>EXT3-fs: mounted filesystem with ordered data=20
mode.<BR>Adding 1572856k swap on /dev/mapper/VolGroup01-LogVol02.&nbsp;=20
Priority:-1 extents:1<BR>across:1572856k<BR>warning: process `kudzu' =
used the=20
deprecated sysctl system call with 1.23.<BR>RPC: Registered udp =
transport=20
module.<BR>RPC: Registered tcp transport module.<BR>ndiswrapper version =
1.51=20
loaded (smp=3Dyes, preempt=3Dno)<BR>usb 1-5: reset high speed USB device =
using=20
ehci_hcd and address 2<BR>ndiswrapper: driver netmw245=20
(Marvell,11/27/2006,1.0.4.9) loaded<BR>wlan0: ethernet device =
00:14:d1:39:73:20=20
using NDIS driver: netmw245, version: 0<BR>x1000308, NDIS version: =
0x501,=20
vendor: 'NDIS Network Adapter', 1286:2006.F.conf<BR>wlan0: encryption =
modes=20
supported: WEP; TKIP with WPA, WPA2, WPA2PSK; AES/CCMP w<BR>ith WPA, =
WPA2,=20
WPA2PSK<BR>usbcore: registered new interface driver=20
ndiswrapper<BR>ADDRCONF(NETDEV_UP): wlan0: link is not =
ready<BR>&nbsp;CIFS VFS:=20
Error connecting to IPv4 socket. Aborting operation</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;CIFS VFS: cifs_mount failed =
w/return code =3D=20
-113<BR>ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready<BR>&nbsp;CIFS =
VFS:=20
Error connecting to IPv4 socket. Aborting operation<BR>&nbsp;CIFS VFS:=20
cifs_mount failed w/return code =3D -113<BR>wlan0: no IPv6 routers=20
present<BR>&nbsp;CIFS VFS: Error connecting to IPv4 socket. Aborting=20
operation<BR>&nbsp;CIFS VFS: cifs_mount failed w/return code =3D =
-113<BR>agpgart:=20
Found an AGP 3.5 compliant device at 0000:00:00.0.<BR>agpgart: Putting =
AGP V3=20
device at 0000:00:00.0 into 8x mode<BR>agpgart: Putting AGP V3 device at =

0000:01:00.0 into 8x mode<BR>cx88[0]/1: IRQ loop detected, disabling=20
interrupts<BR>cx88[0]/2-mpeg: clearing mask<BR>cx88[0]/0: irq loop -- =
clearing=20
mask<BR>cx88[0]/0: irq loop -- clearing mask<BR>cx88[0]/1: IRQ loop =
detected,=20
disabling interrupts<BR>cx88[0]/2-mpeg: clearing mask<BR>cx88[0]/0: irq =
loop --=20
clearing mask<BR>cx88[0]: irq mpeg&nbsp; [0x20040] 6*=20
par_err*<BR>cx88[0]/2-mpeg: general errors: =
0x00020000<BR>cx88[0]/2-mpeg:=20
clearing mask<BR>cx88[0]/0: irq loop -- clearing mask<BR>cx88[0]/2-mpeg: =

clearing mask<BR>cx88[0]/0: irq loop -- clearing mask</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>cx88[0]/2-mpeg: clearing =
mask<BR>cx88[0]/0: irq=20
loop -- clearing mask<BR>cx88[0]: irq mpeg&nbsp; [0x60548a50] ts_risci2* =
6* 9 11=20
15 rip_err* ts_err?* 22 29 30<BR>cx88[0]/2-mpeg: general errors:=20
0x00140000<BR>cx88[0]/2-mpeg: clearing mask<BR>cx88[0]/0: irq loop -- =
clearing=20
mask<BR>cx88[0]/2-mpeg: clearing mask<BR>cx88[0]/0: irq loop -- clearing =

mask<BR>cx88[0]/2-mpeg: clearing mask<BR>cx88[0]/0: irq loop -- clearing =

mask<BR>cx88[0]: irq mpeg&nbsp; [0xa0000] par_err* =
pci_abort*<BR>cx88[0]/2-mpeg:=20
general errors: 0x000a0000<BR>irq 20: nobody cared (try booting with the =

"irqpoll" option)<BR>Pid: 0, comm: swapper Tainted:=20
P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.24.4-64.fc8=20
#1<BR>&nbsp;[&lt;c04612be&gt;]=20
__report_bad_irq+0x36/0x75<BR>&nbsp;[&lt;f15a3a16&gt;] =
nv_kern_isr+0xa5/0xb2=20
[nvidia]<BR>&nbsp;[&lt;c04614d8&gt;]=20
note_interrupt+0x1db/0x217<BR>&nbsp;[&lt;c046091f&gt;]=20
handle_IRQ_event+0x23/0x51<BR>&nbsp;[&lt;c0461c85&gt;]=20
handle_fasteoi_irq+0x86/0xa6<BR>&nbsp;[&lt;c0461bff&gt;]=20
handle_fasteoi_irq+0x0/0xa6<BR>&nbsp;[&lt;c0407688&gt;]=20
do_IRQ+0x8c/0xb8<BR>&nbsp;[&lt;c04334a0&gt;]=20
irq_exit+0x53/0x6b<BR>&nbsp;[&lt;c0405bbf&gt;]=20
common_interrupt+0x23/0x28</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;[&lt;c042a127&gt;]=20
finish_task_switch+0x25/0x8b<BR>&nbsp;[&lt;c062ae0f&gt;]=20
schedule+0x624/0x663<BR>&nbsp;[&lt;c0405bbf&gt;]=20
common_interrupt+0x23/0x28<BR>&nbsp;[&lt;c0403e31&gt;]=20
default_idle+0x0/0x55<BR>&nbsp;[&lt;c040366f&gt;]=20
cpu_idle+0xc8/0xcd<BR>&nbsp;[&lt;c07509df&gt;]=20
start_kernel+0x336/0x33e<BR>&nbsp;[&lt;c07500e0&gt;]=20
unknown_bootoption+0x0/0x195<BR>&nbsp;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>handlers:<BR>[&lt;f095f45a&gt;]=20
(cx8801_irq+0x0/0x1a0 [cx88_alsa])<BR>[&lt;f09b8e85&gt;] =
(cx8802_irq+0x0/0x25d=20
[cx8802])<BR>[&lt;f09de587&gt;] (cx8800_irq+0x0/0x1eb =
[cx8800])<BR>Disabling IRQ=20
#20</FONT></DIV></BODY></HTML>

------=_NextPart_000_0A7B_01C91C95.7FD3C6A0--




--===============1624395021==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1624395021==--
