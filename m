Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0J0ZleR029283
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 19:35:47 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0J0ZXlC021394
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 19:35:34 -0500
Received: by yw-out-2324.google.com with SMTP id 5so945260ywb.81
	for <video4linux-list@redhat.com>; Sun, 18 Jan 2009 16:35:33 -0800 (PST)
Message-ID: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
Date: Mon, 19 Jan 2009 03:29:29 +0300
From: "Brian Marete" <bgmarete@gmail.com>
To: Video4linux-list <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Problem streaming from gspca_t613 Webcam
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

Hello,

I have a USB camera using the gspca_t613 driver. Its vendor/model ID
is 17a1:0128.

I am using kernel 2.6.28.1

I get a blank screen when I try to access it from skype or aMSN, and
the following MPlayer commands gives a constant stream of "select
timeout" error messages:
mplayer tv:// -tv
device=/dev/video0:driver=v4l2:outfmt=mjpeg:fps=7:width=640:height=480

Loading the gspca module with the option debug=511 gives the following
output in the kernel log from module load to a couple of minutes of
the above MPlayer command:

Jan 19 01:55:28 oqb kernel: [   93.376076] usb 3-2: new full speed USB
device using uhci_hcd and address 3
Jan 19 01:55:28 oqb kernel: [   93.533862] usb 3-2: configuration #1
chosen from 1 choice
Jan 19 01:55:28 oqb kernel: [   93.718772] Linux video capture interface: v2.00
Jan 19 01:55:28 oqb kernel: [   93.749063] gspca: main v2.3.0 registered
Jan 19 01:55:28 oqb kernel: [   93.765137] gspca: probing 17a1:0128
Jan 19 01:55:29 oqb kernel: [   94.288072] t613: Bad sensor reset 01
Jan 19 01:55:29 oqb kernel: [   94.332327] gspca: probe ok
Jan 19 01:55:29 oqb kernel: [   94.332364] usbcore: registered new
interface driver t613
Jan 19 01:55:29 oqb kernel: [   94.332370] t613: registered
Jan 19 02:00:15 oqb kernel: [  380.856105] PPP generic driver version 2.4.2
Jan 19 02:00:16 oqb kernel: [  381.012218] PPP BSD Compression module registered
Jan 19 02:00:16 oqb kernel: [  381.069989] PPP Deflate Compression
module registered
Jan 19 02:43:31 oqb kernel: [ 2976.726362] usbcore: deregistering
interface driver t613
Jan 19 02:43:31 oqb kernel: [ 2976.726569] gspca: disconnect complete
Jan 19 02:43:31 oqb kernel: [ 2976.726602] t613: deregistered
Jan 19 02:43:31 oqb kernel: [ 2976.733546] gspca: main deregistered
Jan 19 02:43:43 oqb kernel: [ 2988.943940] gspca: main v2.3.0 registered
Jan 19 02:44:43 oqb kernel: [ 3048.481789] gspca: probing 17a1:0128
Jan 19 02:44:43 oqb kernel: [ 3049.016093] t613: Bad sensor reset 03
Jan 19 02:44:44 oqb kernel: [ 3049.060935] gspca: probe ok
Jan 19 02:44:44 oqb kernel: [ 3049.060967] usbcore: registered new
interface driver t613
Jan 19 02:44:44 oqb kernel: [ 3049.060974] t613: registered
Jan 19 02:45:44 oqb kernel: [ 3109.096119] usb 3-2: USB disconnect, address 3
Jan 19 02:45:44 oqb kernel: [ 3109.096483] gspca: disconnect complete
Jan 19 02:45:49 oqb kernel: [ 3114.240079] usb 3-2: new full speed USB
device using uhci_hcd and address 4
Jan 19 02:45:49 oqb kernel: [ 3114.403345] usb 3-2: configuration #1
chosen from 1 choice
Jan 19 02:45:49 oqb kernel: [ 3114.410516] gspca: probing 17a1:0128
Jan 19 02:45:49 oqb kernel: [ 3114.944076] t613: Bad sensor reset 01
Jan 19 02:45:49 oqb kernel: [ 3114.989399] gspca: probe ok
Jan 19 02:59:32 oqb kernel: [ 3937.545926] usbcore: deregistering
interface driver t613
Jan 19 02:59:32 oqb kernel: [ 3937.546659] gspca: disconnect complete
Jan 19 02:59:32 oqb kernel: [ 3937.547253] t613: deregistered
Jan 19 02:59:32 oqb kernel: [ 3937.550098] gspca: main deregistered
Jan 19 02:59:44 oqb kernel: [ 3949.153834] gspca: main v2.3.0 registered
Jan 19 02:59:51 oqb kernel: [ 3956.700951] gspca: probing 17a1:0128
Jan 19 02:59:51 oqb kernel: [ 3956.703712] t613: unknown sensor 08 03
Jan 19 02:59:52 oqb kernel: [ 3957.224078] t613: Bad sensor reset 01
Jan 19 02:59:52 oqb kernel: [ 3957.226714] t613: Reg 0x06 = 0x08
Jan 19 02:59:52 oqb kernel: [ 3957.227729] t613: Reg 0x07 = 0x03
Jan 19 02:59:52 oqb kernel: [ 3957.228704] t613: Reg 0x0a = 0x00
Jan 19 02:59:52 oqb kernel: [ 3957.229732] t613: Reg 0x0b = 0x04
Jan 19 02:59:52 oqb kernel: [ 3957.230703] t613: Reg 0x66 = 0x00
Jan 19 02:59:52 oqb kernel: [ 3957.231724] t613: Reg 0x80 = 0x28
Jan 19 02:59:52 oqb kernel: [ 3957.232705] t613: Reg 0x81 = 0x20
Jan 19 02:59:52 oqb kernel: [ 3957.233695] t613: Reg 0x8e = 0x33
Jan 19 02:59:52 oqb kernel: [ 3957.234702] t613: Reg 0x8f = 0x24
Jan 19 02:59:52 oqb kernel: [ 3957.235689] t613: Reg 0xa5 = 0x30
Jan 19 02:59:52 oqb kernel: [ 3957.236698] t613: Reg 0xa6 = 0x6a
Jan 19 02:59:52 oqb kernel: [ 3957.237732] t613: Reg 0xa8 = 0xf0
Jan 19 02:59:52 oqb kernel: [ 3957.238707] t613: Reg 0xbb = 0x85
Jan 19 02:59:52 oqb kernel: [ 3957.239725] t613: Reg 0xbc = 0x48
Jan 19 02:59:52 oqb kernel: [ 3957.240706] t613: Reg 0xc6 = 0x88
Jan 19 02:59:52 oqb kernel: [ 3957.253704] t613: Gamma: 10
Jan 19 02:59:52 oqb kernel: [ 3957.268903] gspca: probe ok
Jan 19 02:59:52 oqb kernel: [ 3957.268939] usbcore: registered new
interface driver t613
Jan 19 02:59:52 oqb kernel: [ 3957.268945] t613: registered
Jan 19 02:59:52 oqb kernel: [ 3957.274034] gspca: hald-probe-vide open
Jan 19 02:59:52 oqb kernel: [ 3957.274041] gspca: open done
Jan 19 02:59:52 oqb kernel: [ 3957.274052] gspca main driver:
VIDIOC_QUERYCAP driver=t613, card= USB2.0 WebCam, bus=0000:00:1d.0,
version=0x00020300, capabilities=0x05000001
Jan 19 02:59:52 oqb kernel: [ 3957.274991] gspca main driver:
VIDIOC_QUERYCAP driver=t613, card= USB2.0 WebCam, bus=0000:00:1d.0,
version=0x00020300, capabilities=0x05000001
Jan 19 02:59:52 oqb kernel: [ 3957.275004] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=t613, type=2, audioset=0, tuner=0,
std=00000000, status=0
Jan 19 02:59:52 oqb kernel: [ 3957.275013] gspca main driver:
VIDIOC_ENUMINPUT error -22
Jan 19 02:59:52 oqb kernel: [ 3957.275020] gspca main driver:
VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=JPEG,
description='JPEG'
Jan 19 02:59:52 oqb kernel: [ 3957.275029] gspca main driver:
VIDIOC_TRY_FMT type=vid-cap
Jan 19 02:59:52 oqb kernel: [ 3957.275036] gspca: try fmt cap JPEG 10000x10000
Jan 19 02:59:52 oqb kernel: [ 3957.275042] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 02:59:52 oqb kernel: [ 3957.275854] gspca: hald-probe-vide close
Jan 19 02:59:52 oqb kernel: [ 3957.275861] gspca: close done
Jan 19 03:01:40 oqb kernel: [ 4065.567827] gspca: mplayer open
Jan 19 03:01:40 oqb kernel: [ 4065.567834] gspca: open done
Jan 19 03:01:40 oqb kernel: [ 4065.567869] gspca main driver:
VIDIOC_QUERYCAP driver=t613, card= USB2.0 WebCam, bus=0000:00:1d.0,
version=0x00020300, capabilities=0x05000001
Jan 19 03:01:40 oqb kernel: [ 4065.567881] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.567890] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.567896] gspca main driver:
VIDIOC_G_STD std=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.567964] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=t613, type=2, audioset=0, tuner=0,
std=00000000, status=0
Jan 19 03:01:40 oqb kernel: [ 4065.567986] gspca main driver:
VIDIOC_ENUMINPUT error -22
Jan 19 03:01:40 oqb kernel: [ 4065.567992] gspca main driver:
VIDIOC_G_INPUT value=0
Jan 19 03:01:40 oqb kernel: [ 4065.568078] gspca main driver:
VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=JPEG,
description='JPEG'
Jan 19 03:01:40 oqb kernel: [ 4065.568132] gspca main driver:
VIDIOC_ENUM_FMT error -22
Jan 19 03:01:40 oqb kernel: [ 4065.568158] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568166] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568172] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568179] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568186] gspca: try fmt cap JPEG 640x480
Jan 19 03:01:40 oqb kernel: [ 4065.568265] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568273] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568279] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568286] gspca main driver:
width=640, height=480, format=MJPG, field=any, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568291] gspca: try fmt cap MJPG 640x480
Jan 19 03:01:40 oqb kernel: [ 4065.568297] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=t613, type=2, audioset=0, tuner=0,
std=00000000, status=0
Jan 19 03:01:40 oqb kernel: [ 4065.568306] gspca main driver:
VIDIOC_S_INPUT value=0
Jan 19 03:01:40 oqb kernel: [ 4065.568363] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568371] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568377] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568383] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568389] gspca: try fmt cap JPEG 640x480
Jan 19 03:01:40 oqb kernel: [ 4065.568394] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568401] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568407] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568414] gspca main driver:
width=640, height=480, format=JPEG, field=any, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568419] gspca: try fmt cap JPEG 640x480
Jan 19 03:01:40 oqb kernel: [ 4065.568449] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568457] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568467] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568474] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568479] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.568486] gspca main driver:
width=640, height=480, format=JPEG, field=none, bytesperline=640
sizeimage=115790, colorspace=7
Jan 19 03:01:40 oqb kernel: [ 4065.568504] gspca: frame alloc frsz: 115790
Jan 19 03:01:40 oqb kernel: [ 4065.568584] gspca: reqbufs st:0 c:2
Jan 19 03:01:40 oqb kernel: [ 4065.568588] gspca main driver:
VIDIOC_REQBUFS count=2, type=vid-cap, memory=mmap
Jan 19 03:01:40 oqb kernel: [ 4065.568597] gspca main driver:
VIDIOC_QUERYBUF 00:00:00.00000000 index=0, type=vid-cap, bytesused=0,
flags=0x00000000, field=1, sequence=0, memory=mmap,
offset/userptr=0x00000000, length=118784
Jan 19 03:01:40 oqb kernel: [ 4065.568610] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0,
userbits=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568621] gspca: mmap start:b6811000
size:118784
Jan 19 03:01:40 oqb kernel: [ 4065.568675] gspca: qbuf 0
Jan 19 03:01:40 oqb kernel: [ 4065.568678] gspca: qbuf q:1 i:0 o:0
Jan 19 03:01:40 oqb kernel: [ 4065.568681] gspca main driver:
VIDIOC_QBUF 00:00:00.00000000 index=0, type=vid-cap, bytesused=0,
flags=0x00000002, field=1, sequence=0, memory=mmap,
offset/userptr=0x00000000, length=118784
Jan 19 03:01:40 oqb kernel: [ 4065.568694] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0,
userbits=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568700] gspca main driver:
VIDIOC_QUERYBUF 00:00:00.00000000 index=1, type=vid-cap, bytesused=0,
flags=0x00000000, field=1, sequence=0, memory=mmap,
offset/userptr=0x0001d000, length=118784
Jan 19 03:01:40 oqb kernel: [ 4065.568712] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0,
userbits=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568719] gspca: mmap start:b67f4000
size:118784
Jan 19 03:01:40 oqb kernel: [ 4065.568749] gspca: qbuf 1
Jan 19 03:01:40 oqb kernel: [ 4065.568752] gspca: qbuf q:0 i:0 o:0
Jan 19 03:01:40 oqb kernel: [ 4065.568755] gspca main driver:
VIDIOC_QBUF 00:00:00.00000000 index=1, type=vid-cap, bytesused=0,
flags=0x00000002, field=1, sequence=0, memory=mmap,
offset/userptr=0x0001d000, length=118784
Jan 19 03:01:40 oqb kernel: [ 4065.568767] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0,
userbits=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568773] gspca main driver:
VIDIOC_S_CTRL id=0x980909, value=0
Jan 19 03:01:40 oqb kernel: [ 4065.568779] gspca main driver:
VIDIOC_S_CTRL error -22
Jan 19 03:01:40 oqb kernel: [ 4065.568823] gspca main driver:
VIDIOC_QUERYCTRL id=0x980900, type=1, name=Brightness, min/max=0/14,
step=1, default=8, flags=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568833] gspca main driver:
VIDIOC_S_CTRL id=0x980900, value=8
Jan 19 03:01:40 oqb kernel: [ 4065.568839] gspca: set ctrl [00980900] = 8
Jan 19 03:01:40 oqb kernel: [ 4065.568844] gspca main driver:
VIDIOC_QUERYCTRL id=0x980903
Jan 19 03:01:40 oqb kernel: [ 4065.568850] gspca main driver:
VIDIOC_QUERYCTRL error -22
Jan 19 03:01:40 oqb kernel: [ 4065.568875] gspca main driver:
VIDIOC_QUERYCTRL id=0x980902, type=1, name=Color, min/max=0/15,
step=1, default=5, flags=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568884] gspca main driver:
VIDIOC_S_CTRL id=0x980902, value=5
Jan 19 03:01:40 oqb kernel: [ 4065.568891] gspca: set ctrl [00980902] = 5
Jan 19 03:01:40 oqb kernel: [ 4065.568895] gspca main driver:
VIDIOC_QUERYCTRL id=0x980901, type=1, name=Contrast, min/max=0/13,
step=1, default=7, flags=0x00000000
Jan 19 03:01:40 oqb kernel: [ 4065.568905] gspca main driver:
VIDIOC_S_CTRL id=0x980901, value=7
Jan 19 03:01:40 oqb kernel: [ 4065.568911] gspca: set ctrl [00980901] = 7
Jan 19 03:01:40 oqb kernel: [ 4065.585867] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Jan 19 03:01:40 oqb kernel: [ 4065.585879] gspca: init transfer alt 3
Jan 19 03:01:40 oqb kernel: [ 4065.585884] gspca: use alt 2 ep 0x81
Jan 19 03:01:40 oqb kernel: [ 4065.592865] gspca: isoc 32 pkts size
1023 = bsize:32736
Jan 19 03:01:40 oqb kernel: [ 4065.645713] gspca: stream on OK JPEG 640x480
Jan 19 03:01:40 oqb kernel: [ 4065.645725] gspca: poll
Jan 19 03:01:40 oqb kernel: [ 4065.687701] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.719718] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.751713] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.783713] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.815708] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.847718] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.879711] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.911710] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.943688] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4065.975722] gspca: isoc irq
Jan 19 03:01:40 oqb kernel: [ 4066.007724] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.039723] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.071715] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.103718] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.135711] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.167722] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.199722] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.231717] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.263719] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.295716] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.327723] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.359725] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.391711] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.423719] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.455727] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.487727] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.519729] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.551727] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.583694] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.615728] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.646808] gspca: poll
Jan 19 03:01:41 oqb kernel: [ 4066.646873] gspca: poll
Jan 19 03:01:41 oqb kernel: [ 4066.647719] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.679705] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.711731] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.743728] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.775735] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.807728] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.839731] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.871727] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.903725] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.935704] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.967693] gspca: isoc irq
Jan 19 03:01:41 oqb kernel: [ 4066.999721] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.031725] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.063739] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.095738] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.127727] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.159738] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.191736] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.223742] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.255743] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.287741] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.319737] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.351742] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.383710] gspca: isoc irq
Jan 19 03:01:42 oqb kernel: [ 4067.415732] gspca: isoc irq


Anyone able to help with this? I am happy to experiment with a
specific part of the gspca_t613.c code, if someone will suggest it.
Also, I can capture the USB traffic in windows if that is thought
useful.

Thanks.


-- 
B. Gitonga Marete
Tel: +254-722-151-590

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
