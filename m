Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2G6cC5P021749
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 02:38:12 -0400
Received: from cabrera.red.sld.cu (cabrera.red.sld.cu [201.220.222.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2G6basu027222
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 02:37:38 -0400
From: Maykel Moya <moya-lists@infomed.sld.cu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080314105458.2dd2a284@gaivota>
References: <1205282139.17131.28.camel@gloria.red.sld.cu>
	<20080312180944.3a7e8447@gaivota>
	<1205359734.47d85476111af@webmail.sld.cu>
	<20080313102628.7507d02b@gaivota>
	<1205468182.3027.3.camel@gloria.red.sld.cu>
	<20080314105458.2dd2a284@gaivota>
Content-Type: multipart/mixed; boundary="=-swdM2b9qRcrPwH1g/b2x"
Date: Sun, 16 Mar 2008 02:37:17 -0400
Message-Id: <1205649437.2771.13.camel@gloria.red.sld.cu>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: Problems setting up a TM5600 based device
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


--=-swdM2b9qRcrPwH1g/b2x
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


El vie, 14-03-2008 a las 10:54 -0300, Mauro Carvalho Chehab escribi=C3=B3:

> > This firmware did load correctly but the computer locked up when
> > accessing the device. I tried with tvtime and xawtv.
>=20
> Those apps don't work well with tm6000, since they want to force the driv=
er to
> work on non-supported resolutions.
>=20
> Try mplayer:
>=20
> mplayer -tv driver=3Dv4l2 tv://

I did run mplayer. First time it didn't launch the video output window
and I had to interrupt it manually with Ctrl + C. After that I did run
it again, this time it launched the video window and freezes the
machine.

Find attached some files:
- modprobe-tm6000-debug=3D3.dmesg (dmesg output after inserting the
module)
- mplayer-1st.out (the output of mplayer first time I run it)
- dmesg-after-mplayer-1st.out (dmesg output after running mplayer for
first time)
- v4l-info.output (the output of v4l-info for my device)

These are the last lines of output for the second mplayer run, I copied
the to a paper:
--
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set mute faild: Invalid argument
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 720x576 (preferred colorspace: Packed UYVY)
VDec: using Packed UYVY as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied
VO: [xv] 720x576 =3D> 720x576 Packed UYVY
--

> There are also other options for you to select channel/channel table/vide=
o
> standard. Yet, the better, IMO, is to use qv4l2. This tool is available a=
t
> v4l2-apps/util dir, at the tree.

qv4l2 don't compile

--
CC decode_tm6000.o
In file included from decode_tm6000.c:19:
../lib/v4l2_driver.h:26: error: expected specifier-qualifier-list before
=E2=80=98size_t=E2=80=99
decode_tm6000.c: In function =E2=80=98recebe_buffer=E2=80=99:
decode_tm6000.c:133: error: =E2=80=98struct v4l2_t_buf=E2=80=99 has no memb=
er named
=E2=80=98length=E2=80=99
decode_tm6000.c:135: error: =E2=80=98struct v4l2_t_buf=E2=80=99 has no memb=
er named
=E2=80=98length=E2=80=99
decode_tm6000.c:136: error: =E2=80=98struct v4l2_t_buf=E2=80=99 has no memb=
er named
=E2=80=98length=E2=80=99
make[1]: *** [decode_tm6000.o] Error 1
make[1]: se sale del directorio
`/home/moya/src/tm6010-upstream/v4l2-apps/util'
make: *** [all] Error 2
--

Regards,
maykel


--=-swdM2b9qRcrPwH1g/b2x
Content-Disposition: attachment; filename=dmesg-after-mplayer-1st.output
Content-Type: text/plain; name=dmesg-after-mplayer-1st.output; charset=utf-8
Content-Transfer-Encoding: 7bit

tm6000: open called (minor=0)
xc2028 1-0061: Device is Xceive 48 version 0.0, firmware version 3.0
xc2028 1-0061: Returned an incorrect version. However, read is not reliable enough. Ignoring it.
Original value=96
tm6000: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600)
tm6000: driver=tm6000, card=Trident TVMaster TM5600/6000, bus=, version=0x00000001, capabilities=0x05010001
tm6000: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0cc5604)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_G_STD, dir=r- (0x80085617)
tm6000: value=00001000
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=0, id=255, name=PAL, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=1, id=256, name=PAL-M, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=2, id=512, name=PAL-N, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=3, id=1024, name=PAL-Nc, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=4, id=2048, name=PAL-60, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=5, id=4096, name=NTSC-M, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_G_TUNER, dir=rw (0xc054561d)
tm6000: index=0, name=Television, type=2, capability=2, rangelow=0, rangehigh=-1, signal=1, afc=0, rxsubchans=0, audmode=0
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=0, id=255, name=PAL, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=1, id=256, name=PAL-M, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=2, id=512, name=PAL-N, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=3, id=1024, name=PAL-Nc, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=4, id=2048, name=PAL-60, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=5, id=4096, name=NTSC-M, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=6, id=8192, name=NTSC-M-JP, fps=1001/30000, framelines=525
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=7, id=16711680, name=SECAM, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc04c561a)
tm6000: index=0, name=Television, type=1, audioset=0, tuner=0, std=00ff3fff, status=0
tm6000: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc04c561a)
tm6000: index=1, name=Composite, type=2, audioset=0, tuner=0, std=00ff3fff, status=0
tm6000: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc04c561a)
tm6000: index=2, name=S-Video, type=2, audioset=0, tuner=0, std=00ff3fff, status=0
tm6000: err:
tm6000: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc04c561a)
tm6000: v4l2 ioctl VIDIOC_G_INPUT, dir=r- (0x80045626)
tm6000: value=0
tm6000: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
tm6000: index=0, type=1, flags=0, pixelformat=YUYV, description='4:2:2, packed, YVY2'
tm6000: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
tm6000: index=1, type=1, flags=0, pixelformat=UYVY, description='4:2:2, packed, UYVY'
tm6000: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
tm6000: index=2, type=1, flags=0, pixelformat=TM60, description='A/V + VBI mux packet'
tm6000: err:
tm6000: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
tm6000: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0cc5604)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: type=video-cap
tm6000: width=640, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0cc5604)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YV12, field=any, bytesperline=1440 sizeimage=691200, colorspace=0
(229073) tm6000 #0 vidioc_try_fmt_cap :Fourcc format (0x32315659) invalid.
tm6000: err:
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0cc5604)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YU12, field=any, bytesperline=1440 sizeimage=691200, colorspace=0
(229073) tm6000 #0 vidioc_try_fmt_cap :Fourcc format (0x32315559) invalid.
tm6000: err:
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: v4l2 ioctl VIDIOC_G_FMT, dir=rw (0xc0cc5604)
tm6000: type=video-cap
tm6000: width=720, height=480, format=YUYV, field=interlaced, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0cc5605)
tm6000: type=video-cap
tm6000: width=720, height=480, format=UYVY, field=any, bytesperline=1440 sizeimage=691200, colorspace=0
tm6000: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc04c561a)
tm6000: index=0, name=Television, type=1, audioset=0, tuner=0, std=00ff3fff, status=0
tm6000: v4l2 ioctl VIDIOC_S_INPUT, dir=rw (0xc0045627)
tm6000: value=0
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=0, id=255, name=PAL, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_ENUMSTD, dir=rw (0xc0405619)
tm6000: index=0, id=255, name=PAL, fps=1/25, framelines=625
tm6000: v4l2 ioctl VIDIOC_S_STD, dir=-w (0x40085618)
tm6000: value=000000ff
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
MTS (4), id 00000000000000ff:
xc2028 1-0061: Loading firmware for type=MTS (4), id 00000003000000e0.
xc2028 1-0061: Device is Xceive 0 version 0.0, firmware version 0.0
xc2028 1-0061: Returned an incorrect version. However, read is not reliable enough. Ignoring it.

--=-swdM2b9qRcrPwH1g/b2x
Content-Disposition: attachment; filename="modprobe-tm6000-debug=3.dmesg"
Content-Type: text/plain; name="modprobe-tm6000-debug=3.dmesg"; charset=utf-8
Content-Transfer-Encoding: 7bit

Linux video capture interface: v2.00
tm6000 v4l2 driver version 0.0.1 loaded
tm6000: alt 0, interface 0, class 255
tm6000: alt 0, interface 0, class 255
tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
tm6000: alt 1, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: alt 2, interface 0, class 255
tm6000: New video device @ 480 Mbps (6000:0001, ifnum 0)
tm6000: Found 10Moons UT 821
Error -32 while retrieving board version
tm6000 #0: i2c eeprom 00: 00 99 5b 49 ff ff ff ff ff ff ff ff ff ff ff ff  ..[I............
tm6000 #0: i2c eeprom 10: ff ff ff ff 31 30 4d 4f 4f 4e 53 35 36 30 30 ff  ....10MOONS5600.
tm6000 #0: i2c eeprom 20: 45 5b ff ff ff ff ff ff ff ff ff ff ff ff ff ff  E[..............
tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  ................
Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
Hack: enabling device at addr 0xc2
tuner' 0-0061: chip found @ 0xc2 (tm6000 #0)
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 0-0061: xc2028/3028 firmware name not set!
Setting firmware parameters for xc2028
xc2028 0-0061: Loading 19 firmware images from tm6000-xc3028.fw, type: xc2028 firmware, ver 2.0
xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.
xc2028 0-0061: Device is Xceive 0 version 0.0, firmware version 0.0
xc2028 0-0061: Returned an incorrect version. However, read is not reliable enough. Ignoring it.
xc2028 0-0061: Device is Xceive 100 version 0.0, firmware version 6.4
xc2028 0-0061: Returned an incorrect version. However, read is not reliable enough. Ignoring it.
usbcore: registered new interface driver tm6000

--=-swdM2b9qRcrPwH1g/b2x
Content-Disposition: attachment; filename=mplayer-1st.output
Content-Type: text/plain; name=mplayer-1st.output; charset=utf-8
Content-Transfer-Encoding: 7bit

moya@gloria:~$ mplayer -geometry 1000:800 -vo xv -tv driver=v4l2 tv://
MPlayer dev-SVN-rUNKNOWN-4.2.3 (C) 2000-2007 MPlayer Team
CPU: Intel(R) Pentium(R) 4 CPU 2.60GHz (Family: 15, Model: 2, Stepping: 9)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Trident TVMaster TM5600/6000
 Tuner cap:
 Tuner rxs: MONO
 Capabilites:  video capture  tuner  read/write  streaming
 supported norms: 0 = PAL; 1 = PAL-M; 2 = PAL-N; 3 = PAL-Nc; 4 = PAL-60; 5 = NTSC-M; 6 = NTSC-M-JP; 7 = SECAM;
 inputs: 0 = Television; 1 = Composite; 2 = S-Video;
 Current input: 0
 Current format: YUYV
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument


MPlayer interrupted by signal 2 in module: demux_open

--=-swdM2b9qRcrPwH1g/b2x
Content-Disposition: attachment; filename=v4l-info.output
Content-Type: text/plain; name=v4l-info.output; charset=utf-8
Content-Transfer-Encoding: 7bit


### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "tm6000"
	card                    : "Trident TVMaster TM5600/6000"
	bus_info                : ""
	version                 : 0.0.1
	capabilities            : 0x5010001 [VIDEO_CAPTURE,TUNER,READWRITE,STREAMING]

standards
    VIDIOC_ENUMSTD(0)
	index                   : 0
	id                      : 0xff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
	name                    : "PAL"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(1)
	index                   : 1
	id                      : 0x100 [PAL_M]
	name                    : "PAL-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(2)
	index                   : 2
	id                      : 0x200 [PAL_N]
	name                    : "PAL-N"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(3)
	index                   : 3
	id                      : 0x400 [PAL_Nc]
	name                    : "PAL-Nc"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(4)
	index                   : 4
	id                      : 0x800 [PAL_60]
	name                    : "PAL-60"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(5)
	index                   : 5
	id                      : 0x1000 [NTSC_M]
	name                    : "NTSC-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(6)
	index                   : 6
	id                      : 0x2000 [NTSC_M_JP]
	name                    : "NTSC-M-JP"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(7)
	index                   : 7
	id                      : 0xff0000 [SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	name                    : "SECAM"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "Television"
	type                    : TUNER
	audioset                : 0
	tuner                   : 0
	std                     : 0xff3fff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(1)
	index                   : 1
	name                    : "Composite"
	type                    : CAMERA
	audioset                : 0
	tuner                   : 0
	std                     : 0xff3fff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(2)
	index                   : 2
	name                    : "S-Video"
	type                    : CAMERA
	audioset                : 0
	tuner                   : 0
	std                     : 0xff3fff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []

tuners
    VIDIOC_G_TUNER(0)
	index                   : 0
	name                    : "Television"
	type                    : ANALOG_TV
	capability              : 0x2 [NORM]
	rangelow                : 0
	rangehigh               : 4294967295
	rxsubchans              : 0x1 [MONO]
	audmode                 : MONO
	signal                  : 0
	afc                     : 0

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
	index                   : 0
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, packed, YVY2"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
	index                   : 1
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, packed, UYVY"
	pixelformat             : 0x59565955 [UYVY]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
	index                   : 2
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "A/V + VBI mux packet"
	pixelformat             : 0x30364d54 [TM60]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 720
	fmt.pix.height          : 480
	fmt.pix.pixelformat     : 0x56595559 [YUYV]
	fmt.pix.field           : INTERLACED
	fmt.pix.bytesperline    : 1440
	fmt.pix.sizeimage       : 691200
	fmt.pix.colorspace      : unknown
	fmt.pix.priv            : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 54
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
	id                      : 9963777
	type                    : INTEGER
	name                    : "Contrast"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 119
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
	id                      : 9963778
	type                    : INTEGER
	name                    : "Saturation"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 112
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : -128
	maximum                 : 127
	step                    : 1
	default_value           : 0
	flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
	name                    : "Trident TVMaster TM5600/6000"
	type                    : 0x3 [CAPTURE,TUNER]
	channels                : 3
	audios                  : 0
	maxwidth                : 720
	maxheight               : 480
	minwidth                : 48
	minheight               : 32

channels
    VIDIOCGCHAN(0)
	channel                 : 0
	name                    : "Television"
	tuners                  : 1
	flags                   : 0x1 [TUNER]
	type                    : TV
	norm                    : 1
    VIDIOCGCHAN(1)
	channel                 : 1
	name                    : "Composite"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 1
    VIDIOCGCHAN(2)
	channel                 : 2
	name                    : "S-Video"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 1

tuner
    VIDIOCGTUNER
	tuner                   : 0
	name                    : "Television"
	rangelow                : 0
	rangehigh               : 4294967295
	flags                   : 0x7 [PAL,NTSC,SECAM]
	mode                    : NTSC
	signal                  : 0

audio

picture
    VIDIOCGPICT
	brightness              : 41664
	hue                     : 9024
	colour                  : 33410
	contrast                : 33410
	whiteness               : 0
	depth                   : 16
	palette                 : YUYV

buffer

window
    VIDIOCGWIN
	x                       : 0
	y                       : 0
	width                   : 720
	height                  : 480
	chromakey               : 0
	flags                   : 0


--=-swdM2b9qRcrPwH1g/b2x
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-swdM2b9qRcrPwH1g/b2x--
