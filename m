Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJQKS-0000iS-8s
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 11:35:33 +0100
Received: by fk-out-0910.google.com with SMTP id f40so4241967fka.1
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 02:35:28 -0800 (PST)
Date: Sun, 4 Jan 2009 11:35:20 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090104103520.GA3551@gmail.com>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090104111429.1f828fc8@bk.ru>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, Jan 04, 2009 at 11:14:29AM +0300, Goga777 wrote:
> > I would suggest not using S2API as it's seems to be broken for our card
> > at this time, =


> why do you think so ? =


Maybe because the three users speaking about this card fails to use it
with recent hg's source. And AFAIK you don't succeed in using vdr-1.7.2
neither with it, no ?

> >I did test steven s2 repo which is better that all other
> > S2API repo =

> =

> have you tested http://mercurial.intuxication.org/hg/s2-liplianin ?

Yes, it was exactly the same result.

> please try =

> =

> http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor synchro=
nized it with current v4l-dvb)

Oops, really bad one :

ovcamchip: v2.27 for Linux 2.6 : OV camera chip I2C driver
Linux video codec intermediate layer: v0.2
usbcore: registered new interface driver ttusb
usbcore: registered new interface driver sms1xxx
usbcore: registered new interface driver ttusb-dec
Linux video capture interface: v2.00
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded succ=
essfully
au0828 driver loaded
usbcore: registered new interface driver au0828
usbcore: registered new interface driver dvb_usb_ttusb2
usbcore: registered new interface driver s2255
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.47pre49
usbcore: registered new interface driver sn9c102
usbcore: registered new interface driver dvb_usb_af9015
usbcore: registered new interface driver dvb_usb_af9005
V4L-Driver for Vision CPiA based cameras v1.2.3
Since in-kernel colorspace conversion is not allowed, it is disabled by def=
ault now. Users should fix the applications in case they don't work without=
 conversion reenabled by setting the 'colorspace_conv' module parameter to 1
gspca: main v2.4.0 registered
usbcore: registered new interface driver dvb_usb_gp8psk
saa7146: register extension 'budget_ci dvb'.
budget_ci dvb 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
saa7146: found saa7146 @ mem ffffc20001096c00 (revision 1, irq 21) (0x13c2,=
0x100f).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-CI PCI)
adapter has MAC addr =3D 00:d0:5c:23:a3:9b
input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00=
:1e.0/0000:04:00.0/input/input7
DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
Marvell M88ALP01 'CAFE' Camera Controller version 2
cafe_ccic unable to set up debugfs
OmniVision ov7670 sensor driver, at your service
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw
saa7146: register extension 'budget dvb'.
usbcore: registered new interface driver dvb_usb_digitv
Zoran MJPEG board driver version 0.9.5
No known MJPEG cards found.
usbcore: registered new interface driver dvb_usb_dtt200u
w9968cf: V4L driver for W996[87]CF JPEG USB Dual Mode Camera Chip 1:1.33-ba=
sic
usbcore: registered new interface driver w9968cf
usbcore: registered new interface driver dvb_usb_gl861
usbcore: registered new interface driver vicam
usbcore: registered new interface driver dvb_usb_vp7045
usbcore: registered new interface driver zr364xx
zr364xx: Zoran 364xx
usbcore: registered new interface driver dvb_usb_dtv5100
usbcore: registered new interface driver opera1
usbcore: registered new interface driver dvb_usb_cxusb
usbcore: registered new interface driver stkwebcam
zc0301: V4L2 driver for ZC0301[P] Image Processor and Control Chip v1:1.10
usbcore: registered new interface driver zc0301
et61x251: V4L2 driver for ET61X[12]51 PC Camera Controllers v1:1.09
usbcore: registered new interface driver et61x251
usbcore: registered new interface driver dvb_usb_vp702x
dib0700: loaded with support for 8 different device-types
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver dvb_usb_m920x
usbcore: registered new interface driver dvb_usb_au6610
usbcore: registered new interface driver cinergyT2
vivi: V4L2 device registered as /dev/video0
Video Technology Magazine Virtual Video Capture Board ver 0.5.0 successfull=
y loaded.
usbcore: registered new interface driver b2c2_flexcop_usb
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
usbcore: registered new interface driver stv680
stv680 [usb_stv680_init:1555] =

STV(i): usb camera driver version v0.25 registering<6>stv680: v0.25:STV0680=
 USB Camera Driver
pwc: Philips webcam module version 10.0.13 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 =
& PCVC830/840.
pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC=
-C10 and MPC-C30,
pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC30=
0 and VCS-UM100.
pwc: Trace options: 0x0001
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver dvb_usb_anysee
SE401 usb camera driver version 0.24 registering
usbcore: registered new interface driver se401
usbcore: registered new interface driver dw2102
usbcore: registered new interface driver ov511
ov511: v1.64 for Linux 2.5:ov511 USB Camera Driver
saa7146: register extension 'budget_patch dvb'.
usbcore: registered new interface driver vc032x
vc032x: registered
usbcore: registered new interface driver pac207
pac207: registered
usbcore: registered new interface driver zc3xx
zc3xx: registered
usbcore: registered new interface driver tv8532
tv8532: registered
usbcore: registered new interface driver em28xx
em28xx driver loaded
saa7146: register extension 'hexium gemini'.
usbcore: registered new interface driver ibmcam
usbcore: registered new interface driver STV06xx
STV06xx: registered
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
usbcore: registered new interface driver dvb_usb_a800
saa7130/34: v4l2 driver version 0.2.14 loaded
usbcore: registered new interface driver pac7311
pac7311: registered
usbcore: registered new interface driver spca500
spca500: registered
usbcore: registered new interface driver ultracam
usbcore: registered new interface driver ov519
ov519: registered
usbcore: registered new interface driver sonixj
sonixj: registered
saa7146: register extension 'budget_av'.
usbcore: registered new interface driver dvb_usb_dibusb_mb
cpia2: V4L-Driver for Vision CPiA2 based cameras v2.0.0
usbcore: registered new interface driver cpia2
saa7146: register extension 'dvb'.
usbcore: registered new interface driver ov534
ov534: registered
cx2388x alsa driver version 0.0.6 loaded
cx88_audio 0000:04:02.1: PCI INT A -> GSI 23 (level, low) -> IRQ 23
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hy=
brid [card=3D68,autodetected], frontend(s): 2
cx88[0]: TV tuner type 63, Radio tuner type -1
wm8775' 8-001b: chip found @ 0x36 (cx88[0])
tuner' 8-0061: chip found @ 0xc2 (cx88[0])
tuner' 8-0063: chip found @ 0xc6 (cx88[0])
tveeprom 8-0050: Hauppauge model 69009, rev B2A0, serial# 1241151
tveeprom 8-0050: MAC address is 00-0D-FE-12-F0-3F
tveeprom 8-0050: tuner model is Philips FMD1216ME (idx 100, type 63)
tveeprom 8-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/=
DVB Digital (eeprom 0xf4)
tveeprom 8-0050: audio processor is CX882 (idx 33)
tveeprom 8-0050: decoder processor is CX882 (idx 25)
tveeprom 8-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=3D69009
tuner-simple 8-0061: creating new instance
tuner-simple 8-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/=
0000:04:02.1/input/input8
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
usbcore: registered new interface driver spca501
spca501: registered
usbcore: registered new interface driver spca506
spca506: registered
usbcore: registered new interface driver usbvision
USBVision USB Video Device Driver for Linux : 0.9.9
usbcore: registered new interface driver dvb_usb_dibusb_mc
usbcore: registered new interface driver finepix
finepix: registered
quickcam_messenger: v0.01:Logitech Quickcam Messenger USB
usbcore: registered new interface driver QCM
usbcore: registered new interface driver mars
mars: registered
usbcore: registered new interface driver conex
conex: registered
usbcore: registered new interface driver spca505
spca505: registered
konicawc: v1.4:Konica Webcam driver
usbcore: registered new interface driver konicawc
USB driver for Vision CPiA based cameras v1.2.3
usbcore: registered new interface driver cpia
vpx3220' 8-0043: chip (8b:8888) found @ 0x86 (cx88[0])
usbcore: registered new interface driver etoms
etoms: registered
usbcore: registered new interface driver dvb_usb_nova_t_usb2
usbcore: registered new interface driver dvb_usb_umt_010
usbcore: registered new interface driver stk014
stk014: registered
usbcore: registered new interface driver spca561
spca561: registered
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:04:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
cx88[0]/0: found at 0000:04:02.0, rev: 5, irq: 23, latency: 64, mmio: 0xdb0=
00000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx8800 0000:04:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
cx88[1]: subsystem: 14f1:0084, board: Geniatech DVB-S [card=3D52,autodetect=
ed], frontend(s): 1
cx88[1]: TV tuner type 4, Radio tuner type -1
cx88[1]/0: found at 0000:04:05.0, rev: 3, irq: 20, latency: 64, mmio: 0xd90=
00000
cx88[1]/0: registered device video2 [v4l2]
cx88[1]/0: registered device vbi1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:04:02.2: PCI INT A -> GSI 23 (level, low) -> =
IRQ 23
cx88[0]/2: found at 0000:04:02.2, rev: 5, irq: 23, latency: 64, mmio: 0xdd0=
00000
cx8802_probe() allocating 2 frontend(s)
cx88[1]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:04:05.2: PCI INT A -> GSI 20 (level, low) -> =
IRQ 20
cx88[1]/2: found at 0000:04:05.2, rev: 3, irq: 20, latency: 64, mmio: 0xda0=
00000
cx8802_probe() allocating 1 frontend(s)
usbcore: registered new interface driver sunplus
sunplus: registered
saa7146: register extension 'hexium HV-PCI6 Orion'.
saa7146: register extension 'Multimedia eXtension Board'.
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/=
Hybrid [card=3D68]
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffffa0abc15a>] vp3054_i2c_probe+0x1a/0x160 [cx88_vp3054_i2c]
PGD 69099067 PUD 69acf067 PMD 0 =

Oops: 0000 [#1] PREEMPT SMP =

last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/video4li=
nux/video2/index
CPU 0 =

Modules linked in: cx88_dvb(+) tea6415c(+) mxb hexium_orion gspca_sunplus c=
x8802 cx8800 mt9m001 gspca_spca561 gspca_stk014 dvb_usb_umt_010 dvb_usb_nov=
a_t_usb2 tda9875 gspca_etoms vpx3220 cpia_usb vp27smpx konicawc upd64031a g=
spca_spca505 tvaudio bt819 saa7110 gspca_conex gspca_mars quickcam_messenge=
r gspca_finepix cs53l32a dvb_usb_dibusb_mc tvp5150 cx2341x usbvision m52790=
 gspca_spca506 gspca_spca501 ov772x tuner cx88_alsa gspca_ov534 saa7185 dvb=
_ttpci ks0127 cpia2 mt9t031 dvb_usb_dibusb_mb saa7114 tw9910 tvp514x budget=
_av gspca_sonixj gspca_ov519 saa6752hs cs5345 saa5249 soc_camera_platform u=
pd64083 ultracam gspca_spca500 gspca_pac7311 saa7115 saa7134 wm8775 dvb_usb=
_a800 tda9840 bttv gspca_stv06xx tlv320aic23b saa717x ibmcam hexium_gemini =
mt9m111 saa7127 msp3400 saa7111 em28xx gspca_tv8532 bt866 tea6420 gspca_zc3=
xx gspca_pac207 gspca_vc032x saa5246a tda7432 budget_patch ov511 dvb_usb_dw=
2102 stradis se401 dvb_usb_anysee pwc stv680 uvcvideo b2c2_flexcop_usb vivi=
 dvb_usb_cinergyT2 dvb_usb_au6610 dvb_usb_m920x dvb_usb_dib0700 dvb_usb_vp7=
02x et61x251 zc0301 stkwebcam dvb_usb_cxusb dvb_usb_opera dvb_usb_dtv5100 c=
x88xx mantis zr364xx saa7146_vv dvb_usb_vp7045 soc_camera vicam dvb_usb_gl8=
61 w9968cf dvb_usb_dtt200u dvb_usb_digitv budget dvb_usb_pctv452e usbvideo =
ov7670 v4l2_common cafe_ccic budget_ci dvb_usb_gp8psk gspca_main b2c2_flexc=
op_pci cpia dvb_usb_af9005 dvb_usb_af9015 sn9c102 s2255drv dvb_usb_ttusb2 d=
vb_usb_dibusb_common budget_core stv0299 pluto2 au0828 dib7000m dib7000p tc=
m825x dm1105 b2c2_flexcop zr36050 lgdt330x zr36016 videobuf_vmalloc or51132=
 videodev ttusb_dec zr36060 sms1xxx dib3000mc tuner_simple dvb_usb videobuf=
_dma_sg dvb_ttusb_budget ir_kbd_i2c or51211 videobuf_dvb stv0288 stb0899 sp=
887x v4l2_compat_ioctl32 s5h1409 mt2266 tuner_types tda10023 tua6100 mt20xx=
 btcx_risc tda18271 cx22702 videocodec tda10086 tea5767 mt312 s921 dvb_dumm=
y_fe tda8261 qt1010 af9013 cx88_vp3054_i2c tda1004x nxt200x ves1820 bcm3510=
 saa6588 mxl5007t drx397xD sp8870 lnbp22 tda8290 cx24113 l64781 ir_common c=
x24110 tda827x saa7146 ttpci_eeprom stb6100 tda10048 tda826x ttusbdecfe s5h=
1411 lgdt3304 ves1x93 stv0297 dib3000mb tda8083 lnbp21 dibx000_common tda98=
87 isl6421 mt2060 mb86a16 zl10353 tda10021 dvb_usb_af9005_remote cx22700 s5=
h1420 mt352 v4l1_compat dvb_core isl6405 xc5000 cu1216 tea5761 mxl5005s dvb=
_pll au8522 stb6000 v4l2_int_device mt2131 videobuf_core ovcamchip tveeprom=
 lgs8gl5 saa7191 cx24116 cx24123 dib0070 si21xx tuner_xc2028 nxt6000 itd100=
0 i2c_algo_bit ipv6 coretemp w83627ehf w83791d hwmon_vid hwmon nfs lockd su=
nrpc firewire_ohci firewire_core crc_itu_t i2c_i801 ohci1394 ieee1394 snd_h=
da_intel nvidia(P) usb_storage
Pid: 19983, comm: modprobe Tainted: P           2.6.28-gentoo #1
RIP: 0010:[<ffffffffa0abc15a>]  [<ffffffffa0abc15a>] vp3054_i2c_probe+0x1a/=
0x160 [cx88_vp3054_i2c]
RSP: 0018:ffff880056b0bd18  EFLAGS: 00010246
RAX: ffffffffa10f1080 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88007d34b000 R08: 0000000000000000 R09: ffff880069234420
R10: 0000000000000000 R11: 00000000807ca320 R12: ffff880069234420
R13: 0000000000000000 R14: 0000000000c53160 R15: 0000000000c53178
FS:  00007f39b078d6f0(0000) GS:ffffffff80721200(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007f8a9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 19983, threadinfo ffff880056b0a000, task ffff88007a6=
17a60)
Stack:
 0000000000000070 00000000ffffffed ffff88007d34b000 ffff880069234420
 0000000000000000 ffffffffa110a848 0000000000000000 0000000000000000
 ffff88002da867e0 ffff880056b0bd78 0000000000000000 ffff88007a5458c0
Call Trace:
 [<ffffffffa110a848>] ? cx8802_dvb_probe+0x78/0x1e10 [cx88_dvb]
 [<ffffffff802f3019>] ? __sysfs_add_one+0x39/0xb0
 [<ffffffffa10f272f>] ? cx8802_register_driver+0x1cf/0x258 [cx8802]
 [<ffffffffa110c6a0>] ? dvb_init+0x0/0x30 [cx88_dvb]
 [<ffffffff80209042>] ? _stext+0x42/0x1b0
 [<ffffffff802670bc>] ? load_module+0x177c/0x19b0
 [<ffffffff80247c90>] ? msleep+0x0/0x40
 [<ffffffff802673a5>] ? sys_init_module+0xb5/0x1e0
 [<ffffffff8020bbcb>] ? system_call_fastpath+0x16/0x1b
Code: 7e df 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 28 48 89 =
5c 24 08 48 89 6c 24 10 4c 89 64 24 18 4c 89 6c 24 20 31 db <4c> 8b 27 48 8=
9 fd 41 83 bc 24 c0 06 00 00 2a 74 1b 89 d8 48 8b =

RIP  [<ffffffffa0abc15a>] vp3054_i2c_probe+0x1a/0x160 [cx88_vp3054_i2c]
 RSP <ffff880056b0bd18>
CR2: 0000000000000000
---[ end trace 168efbdd3bf40990 ]---
usbcore: registered new interface driver spca508
spca508: registered
usbcore: registered new interface driver sonixb
sonixb: registered
usbcore: registered new interface driver t613
t613: registered
usbcore: registered new interface driver ALi m5602
ALi m5602: registered
usbcore: registered new interface driver pvrusb2
pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
pvrusb2: Debug mask is 31 (0x1f)
Em28xx: Initialized (Em28xx dvb Extension) extension
saa7134 ALSA driver for DMA sound loaded
saa7134 ALSA: no saa7134 cards found
bt878: AUDIO driver version 0.0.0 loaded
ivtv: Start initialization, version 1.4.0
ivtv: End initialization
Em28xx: Initialized (Em28xx Audio Extension) extension
cx18:  Start initialization, version 1.0.4
cx18:  End initialization
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx23885 driver version 0.0.1 loaded
ivtvfb:  no cards found

And then, no more keyboard ??? (Logitech G15 LCD).

> http://hg.kewl.org/dvb2010/ - new dvb scaner =


Thanks, didn't know this one, I'll try :-)

> for me everything is working without any problem with my hvr4000. Also pa=
tched vdr 170 works well with s2api

Then go to vdr-1.7.2, and are you like it seems all three "problematic"
users under x86_64 system like us ?
Using diseqc ?

Thanks.
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
