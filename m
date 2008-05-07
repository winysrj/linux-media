Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m472llE8008201
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 22:47:47 -0400
Received: from blu139-omc2-s8.blu139.hotmail.com
	(blu139-omc2-s8.blu139.hotmail.com [65.55.175.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m472lUek026470
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 22:47:30 -0400
Message-ID: <BLU130-W13EE4F5E6F0E8FF5CC1BDEC3D10@phx.gbl>
From: Bryan Larmore <bryanlarmore@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Tue, 6 May 2008 22:47:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: xawtv hangs after upgrade
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


I have two Bt878 capture cards that have worked through RH9 to Ubuntu
Feisty Fawn and Gutsy Gibbon.  They always autodetected flawlessly and
just "worked".  I never tried to use the tuner or used sound because I
have cameras attached to run Motion.

Cards are ProVideo PV143 and Prolink Pixelview

I upgraded to ubuntu hardy heron and now nothing v4l related seems to work.

If I run anything from the command line like  xawtv or xawtv -hwscan  or v4=
l-info the window just hangs.

Complete dmesg output is here:

http://pastebin.com/m2f447118

[   54.640247] bttv: driver version 0.9.16 loaded
[   54.640253] bttv: using 8 buffers with 2080k (520 pages) each for captur=
e
[   54.640335] bttv: Bt8xx card found (0).
[   54.640372] ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 18 (level, low) -=
> IRQ 22
[   54.640389] bttv0: Bt878 (rev 17) at 0000:00:0f.0, irq: 22, latency: 32,=
 mmio: 0xee000000
[   54.640403] bttv0: detected: Provideo PV143A [card=3D105], PCI subsystem=
 ID is aa00:1430
[   54.640407] bttv0: using: ProVideo PV143 [card=3D105,autodetected]
[   54.640442] bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffff [in=
it]
[   54.640951] bttv0: using tuner=3D-1
[   54.640955] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   54.641765] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   54.642574] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   54.643434] bttv0: registered device video0
[   54.643469] bttv0: registered device vbi0
[   54.643489] bttv0: PLL: 28636363 =3D> 35468950 .. ok
[   54.674722] bttv: Bt8xx card found (1).
[   54.674753] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 19 (level, low) -=
> IRQ 19
[   54.674769] bttv1: Bt878 (rev 17) at 0000:00:10.0, irq: 19, latency: 32,=
 mmio: 0xed000000
[   54.674799] bttv1: detected: Prolink Pixelview PV-BT [card=3D72], PCI su=
bsystem ID is 1554:4011
[   54.674804] bttv1: using: Prolink Pixelview PV-BT878P+9B (PlayTV Pro rev=
.9B FM+NICAM) [card=3D72,autodetected]
[   54.674835] bttv1: gpio: en=3D00000000, out=3D00000000 in=3D006fc0ff [in=
it]
[   54.675396] bttv1: using tuner=3D5
[   54.675401] bttv1: i2c: checking for TDA7432 @ 0x8a... not found
[   54.695124] parport: PnPBIOS parport detected.
[   54.695183] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRI=
STATE,COMPAT,ECP,DMA]
[   54.713867] input: ImExPS/2 Generic Explorer Mouse as /class/input/input=
3
[   54.753601] bttv1: i2c: checking for TDA9887 @ 0x86... not found
[   54.793179] tuner 2-0061: chip found @ 0xc2 (bt878 #1 [sw])
[   54.793220] tuner 2-0061: type set to 5 (Philips PAL_BG (FI1216 and comp=
atibles))
[   54.793224] tuner 2-0061: type set to 5 (Philips PAL_BG (FI1216 and comp=
atibles))
[   54.794219] tuner 2-0063: chip found @ 0xc6 (bt878 #1 [sw])
[   54.804244] bttv1: registered device video1
[   54.804280] bttv1: registered device vbi1
[   54.804315] bttv1: registered device radio0
[   54.804338] bttv1: PLL: 28636363 =3D> 35468950 .. ok
[   54.835540] input: bttv IR (card=3D72) as /class/input/input4
[   54.937052] bt878: AUDIO driver version 0.0.0 loaded
[   54.937111] bt878: Bt878 AUDIO function found (0).
[   54.937137] ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 18 (level, low) -=
> IRQ 22
[   54.937147] bt878_probe: card id=3D[0x1430aa00], Unknown card.
[   54.937148] Exiting..
[   54.937154] ACPI: PCI interrupt for device 0000:00:0f.1 disabled
[   54.937160] bt878: probe of 0000:00:0f.1 failed with error -22
[   54.937168] bt878: Bt878 AUDIO function found (0).
[   54.937185] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 19 (level, low) -=
> IRQ 19
[   54.937192] bt878_probe: card id=3D[0x40111554], Unknown card.
[   54.937194] Exiting..
[   54.937199] ACPI: PCI interrupt for device 0000:00:10.1 disabled
[   54.937203] bt878: probe of 0000:00:10.1 failed with error -22


xawtv -v 2 output

This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.24-16-generic)
visual: id=3D0x22 class=3D4 (TrueColor), depth=3D24
visual: id=3D0x23 class=3D4 (TrueColor), depth=3D24
visual: id=3D0x24 class=3D4 (TrueColor), depth=3D24
visual: id=3D0x25 class=3D4 (TrueColor), depth=3D24
visual: id=3D0x3e class=3D4 (TrueColor), depth=3D32
x11: color depth: 24 bits, 3 bytes - pixmap: 4 bytes
x11: color masks: red=3D0x00ff0000 green=3D0x0000ff00 blue=3D0x000000ff
x11: server byte order: little endian
x11: client byte order: little endian
check if the X-Server is local ... * ok (unix socket)
main: dga extention...
DGA version 2.0
main: xinerama extention...
xinerama 0: 1280x1024+0+0
main: xvideo extention [video]...
Xvideo: 0 adaptors available.
Xvideo: no usable video port found
main: xvideo extention [image]...
main: init main window...
main: install signal handlers...
main thread [pid=3D6867]
main: open grabber device...
x11: 1280x1024, 32 bit/pixel, 5120 byte/scanline, DGA
v4l-conf: using X11 display :0.0
dga: version 2.0
mode: 1280x1024, depth=3D24, bpp=3D32, bpl=3D5120, base=3D0xf0000000
_________________________________________________________________
Make Windows Vista more reliable and secure with Windows Vista Service Pack=
 1.
http://www.windowsvista.com/SP1?WT.mc_id=3Dhotmailvistasp1banner=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
