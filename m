Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59571 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZIIJNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 05:13:16 -0400
Received: by bwz19 with SMTP id 19so280118bwz.37
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 02:13:18 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 16:13:18 +0700
Message-ID: <c62e66e90909090213x135e8521i4e42428e3b02be61@mail.gmail.com>
Subject: ZC0301 webcam not working
From: "test.r test.r" <test.application.r@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

My webcam used to work with the spca5xx driver from mxhaard.free.fr.
It neither work with the gspca driver built into Debian sid, nor with
the upstream version from hg http://linuxtv.org/hg/~jfrancois/gspca/.
However /dev/video0 is created.

Can someone help making it work?

Here is information gathered on Debian sid 2.6.30 kernel using the
uptodate linuxtv upstream version.


Thanks,
Guillaume



lsusb -v
Bus 002 Device 002: ID 0ac8:301b Z-Star Microelectronics Corp. ZC0301 Webcam

Environement:
debian sid + uptodate upstream version from hg
http://linuxtv.org/hg/~jfrancois/gspca/

uname -a
Linux dex 2.6.30-1-686 #1 SMP Sat Aug 15 19:11:58 UTC 2009 i686 GNU/Linux


modprobe gspca_main debug=2000
[ 2741.696129] usb 2-1: new full speed USB device using uhci_hcd and address 2
[ 2741.892219] usb 2-1: New USB device found, idVendor=0ac8, idProduct=301b
[ 2741.892226] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2741.892231] usb 2-1: Product: PC Camera
[ 2741.892235] usb 2-1: Manufacturer: Z-Star Corp.
[ 2741.892385] usb 2-1: configuration #1 chosen from 1 choice
[ 2742.031834] Linux video capture interface: v2.00
[ 2742.072120] gspca: main v2.7.0 registered
[ 2742.075823] gspca: probing 0ac8:301b
[ 2742.203227] zc3xx: probe sensor -> 0004
[ 2742.203232] zc3xx: Find Sensor CS2102
[ 2742.207324] gspca: probe ok
[ 2742.207359] usbcore: registered new interface driver zc3xx
[ 2742.207364] zc3xx: registered
[ 3375.544635] usbcore: deregistering interface driver zc3xx
[ 3375.544753] gspca: disconnect complete
[ 3375.544780] zc3xx: deregistered
[ 3377.010799] gspca: main deregistered
[ 3395.515948] gspca: main v2.7.0 registered
[ 3406.738478] gspca: main deregistered
[ 3411.609437] gspca: main v2.7.0 registered
[ 3417.706804] gspca: main deregistered
[ 3424.648535] gspca: main v2.7.0 registered



modprobe gspca_zc3xx
[ 3489.682812] zc3xx: reg w [0000] = 01
[ 3489.684423] zc3xx: reg w [0010] = 00
[ 3489.685429] zc3xx: reg w [0001] = 01
[ 3489.686445] zc3xx: reg w [0012] = 03
[ 3489.687424] zc3xx: reg w [0012] = 01
[ 3489.717419] zc3xx: i2c w [01] = 00aa (00)
[ 3489.751456] zc3xx: i2c r [01] -> 0000 (00)
[ 3489.751461] zc3xx: reg w [0000] = 01
[ 3489.752433] zc3xx: reg w [0010] = 04
[ 3489.753424] zc3xx: reg w [0001] = 01
[ 3489.754421] zc3xx: reg w [0012] = 03
[ 3489.755427] zc3xx: reg w [0012] = 01
[ 3489.781441] zc3xx: i2c w [01] = 00aa (00)
[ 3489.815457] zc3xx: i2c r [01] -> 0045 (00)
[ 3489.815464] zc3xx: reg w [0010] = 04
[ 3489.817456] zc3xx: reg r [0010] -> 04
[ 3489.817461] zc3xx: reg w [0000] = 01
[ 3489.818449] zc3xx: reg w [0000] = 01
[ 3489.819581] usbcore: registered new interface driver zc3xx
[ 3489.845093] gspca main driver: VIDIOC_QUERYCAP driver=zc3xx,
card=PC Camera, bus=usb-0000:00:1d.0-1, version=0x00020700,
capabilities=0x05000001



output of gspca/v4l2-apps/test/driver-test
driver=zc3xx, card=PC Camera, bus=usb-0000:00:1d.0-1, version=2.7.0,
capabilities=CAPTURE READWRITE STREAMING
enum_stds: Invalid argument
Error! Driver is not reporting supported STD, frames/sec and number of lines!
 Trying to continue anyway...
INPUT: index=0, name=zc3xx, type=2, audioset=0, tuner=0, std=00000000, status=0
FORMAT: index=0, type=1, flags=1, description='JPEG'
	fourcc=JPEG
FMT SET: 640x480, fourcc=JPEG, 640 bytes/line, 115790 bytes/frame,
colorspace=0x00000007
PARM: capability=0, capturemode=0, nan fps ext=0, readbuf=2
g_tuner: Invalid argument
Assuming 62.5 kHz step
62.5 kHz step
s_frequency: Invalid argument
g_tuner: Invalid argument
Assuming 62.5 kHz step
62.5 kHz step
s_frequency: Invalid argument
g_tuner: Invalid argument
Assuming 62.5 kHz step
62.5 kHz step
s_frequency: Invalid argument
Preparing for frames...
REQBUFS: count=2, type=video-cap, memory=mmap
QUERYBUF: 00:00:00.00000000 index=0, type=video-cap, bytesused=0,
flags=0x00000000, field=none, sequence=0, memory=mmap,
offset=0x00000000, length=118784
	TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
QUERYBUF: ERROR: VIDIOC_S_FMT said buffer should have 115790 size, but
received 118784 from QUERYBUF!
QUERYBUF: 00:00:00.00000000 index=1, type=video-cap, bytesused=0,
flags=0x00000000, field=none, sequence=0, memory=mmap,
offset=0x0001d000, length=118784
	TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
QUERYBUF: ERROR: VIDIOC_S_FMT said buffer should have 115790 size, but
received 118784 from QUERYBUF!
Activating 2 queues
QBUF: 00:00:00.00000000 index=0, type=video-cap, bytesused=0,
flags=0x00000002, field=any, sequence=0, memory=mmap,
offset=0x00000000, length=0
	TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
QBUF: 00:00:00.00000000 index=1, type=video-cap, bytesused=0,
flags=0x00000002, field=any, sequence=0, memory=mmap,
offset=0x00000000, length=0
	TIMECODE: 00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Enabling streaming
Waiting for frames...
select timeout




dmesg after end of gspca/v4l2-apps/test/driver-test
[ 3545.074386] gspca main driver: VIDIOC_QUERYCAP driver=zc3xx,
card=PC Camera, bus=usb-0000:00:1d.0-1, version=0x00020700,
capabilities=0x05000001
[ 3545.074717] gspca main driver: VIDIOC_ENUMINPUT index=0,
name=zc3xx, type=2, audioset=0, tuner=0, std=00000000, status=0
[ 3545.074743] gspca main driver: VIDIOC_ENUMINPUT error -22
[ 3545.074751] gspca main driver: VIDIOC_S_INPUT value=0
[ 3545.074757] gspca main driver: VIDIOC_G_INPUT value=0
[ 3545.074765] gspca main driver: VIDIOC_ENUM_FMT index=0, type=1,
flags=1, pixelformat=JPEG, description='JPEG'
[ 3545.074786] gspca main driver: VIDIOC_ENUM_FMT error -22
[ 3545.074794] gspca main driver: VIDIOC_S_FMT type=vid-cap
[ 3545.074802] gspca main driver: width=640, height=480, format=JPEG,
field=any, bytesperline=0 sizeimage=0, colorspace=0
[ 3545.074820] gspca main driver: VIDIOC_G_PARM type=1
[ 3545.074852] gspca main driver: VIDIOC_G_TUNER error -22
[ 3545.074902] gspca main driver: VIDIOC_G_FREQUENCY error -22
[ 3545.074939] gspca main driver: VIDIOC_G_TUNER error -22
[ 3545.074984] gspca main driver: VIDIOC_S_FREQUENCY error -22
[ 3545.075018] gspca main driver: VIDIOC_G_TUNER error -22
[ 3545.075060] gspca main driver: VIDIOC_S_FREQUENCY error -22
[ 3546.075310] gspca main driver: VIDIOC_REQBUFS count=2,
type=vid-cap, memory=mmap
[ 3546.075358] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=0, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=118784
[ 3546.075374] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3546.075477] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x0001d000, length=118784
[ 3546.075494] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3546.075574] gspca: qbuf 0
[ 3546.075578] gspca: qbuf q:1 i:0 o:0
[ 3546.075581] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=0, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[ 3546.075596] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3546.075625] gspca: qbuf 1
[ 3546.075629] gspca: qbuf q:0 i:0 o:0
[ 3546.075632] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[ 3546.075646] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3546.075685] gspca main driver: VIDIOC_STREAMON type=vid-cap
[ 3546.078933] zc3xx: reg r [0008] -> 11
[ 3546.079432] zc3xx: reg r [0008] -> 11
[ 3546.079436] zc3xx: reg w [0000] = 01
[ 3546.080252] zc3xx: reg w [0002] = 00
[ 3546.081224] zc3xx: reg w [0010] = 00
[ 3546.082221] zc3xx: reg w [0001] = 01
[ 3546.083245] zc3xx: reg w [0080] = 20
[ 3546.084239] zc3xx: reg w [0081] = 21
[ 3546.085238] zc3xx: reg w [0083] = 30
[ 3546.086237] zc3xx: reg w [0084] = 31
[ 3546.087236] zc3xx: reg w [0085] = 32
[ 3546.088239] zc3xx: reg w [0086] = 23
[ 3546.089237] zc3xx: reg w [0087] = 24
[ 3546.090235] zc3xx: reg w [0088] = 25
[ 3546.091244] zc3xx: reg w [008b] = b3
[ 3546.092238] zc3xx: reg w [0008] = 03
[ 3546.093251] zc3xx: reg w [0012] = 03
[ 3546.094271] zc3xx: reg w [0012] = 01
[ 3546.095271] zc3xx: reg w [0003] = 02
[ 3546.096236] zc3xx: reg w [0004] = 80
[ 3546.097245] zc3xx: reg w [0005] = 01
[ 3546.098246] zc3xx: reg w [0006] = e0
[ 3546.099247] zc3xx: reg w [0098] = 00
[ 3546.100262] zc3xx: reg w [009a] = 00
[ 3546.101247] zc3xx: reg w [011a] = 00
[ 3546.102238] zc3xx: reg w [011c] = 00
[ 3546.129274] zc3xx: i2c w [02] = 0008 (00)
[ 3546.153280] zc3xx: i2c w [03] = 0000 (00)
[ 3546.177284] zc3xx: i2c w [11] = 0001 (00)
[ 3546.201284] zc3xx: i2c w [12] = 0087 (00)
[ 3546.225285] zc3xx: i2c w [13] = 0001 (00)
[ 3546.249284] zc3xx: i2c w [14] = 00e7 (00)
[ 3546.273260] zc3xx: i2c w [20] = 0000 (00)
[ 3546.297288] zc3xx: i2c w [22] = 0000 (00)
[ 3546.321286] zc3xx: i2c w [0b] = 0004 (00)
[ 3546.345288] zc3xx: i2c w [30] = 0030 (00)
[ 3546.369288] zc3xx: i2c w [31] = 0030 (00)
[ 3546.393293] zc3xx: i2c w [32] = 0030 (00)
[ 3546.393298] zc3xx: reg w [0101] = 77
[ 3546.394282] zc3xx: reg w [0019] = 00
[ 3546.395283] zc3xx: reg w [0012] = 05
[ 3546.396270] zc3xx: reg w [0100] = 0d
[ 3546.397257] zc3xx: reg w [0189] = 06
[ 3546.398254] zc3xx: reg w [01c5] = 03
[ 3546.399254] zc3xx: reg w [01cb] = 13
[ 3546.400249] zc3xx: reg w [01ae] = 15
[ 3546.401282] zc3xx: reg w [0250] = 08
[ 3546.402282] zc3xx: reg w [0301] = 08
[ 3546.403281] zc3xx: reg w [018d] = 68
[ 3546.404264] zc3xx: reg w [01ad] = 00
[ 3546.406255] zc3xx: reg r [0002] -> 00
[ 3546.407255] zc3xx: reg r [0008] -> 03
[ 3546.407259] zc3xx: reg w [0008] = 03
[ 3546.408251] zc3xx: reg w [01c6] = 08
[ 3546.410282] zc3xx: reg r [01c8] -> 05
[ 3546.411283] zc3xx: reg r [01c9] -> 07
[ 3546.412264] zc3xx: reg r [01ca] -> 0f
[ 3546.412269] zc3xx: reg w [01cb] = 0f
[ 3546.413284] zc3xx: reg w [0120] = 24
[ 3546.414282] zc3xx: reg w [0121] = 44
[ 3546.415282] zc3xx: reg w [0122] = 64
[ 3546.416246] zc3xx: reg w [0123] = 84
[ 3546.417258] zc3xx: reg w [0124] = 9d
[ 3546.418256] zc3xx: reg w [0125] = b2
[ 3546.419258] zc3xx: reg w [0126] = c4
[ 3546.420250] zc3xx: reg w [0127] = d3
[ 3546.421284] zc3xx: reg w [0128] = e0
[ 3546.422283] zc3xx: reg w [0129] = eb
[ 3546.423282] zc3xx: reg w [012a] = f4
[ 3546.424264] zc3xx: reg w [012b] = fb
[ 3546.425257] zc3xx: reg w [012c] = ff
[ 3546.426256] zc3xx: reg w [012d] = ff
[ 3546.427256] zc3xx: reg w [012e] = ff
[ 3546.428250] zc3xx: reg w [012f] = ff
[ 3546.429284] zc3xx: reg w [0130] = 18
[ 3546.430283] zc3xx: reg w [0131] = 20
[ 3546.431284] zc3xx: reg w [0132] = 20
[ 3546.432265] zc3xx: reg w [0133] = 1c
[ 3546.433256] zc3xx: reg w [0134] = 16
[ 3546.434256] zc3xx: reg w [0135] = 13
[ 3546.435255] zc3xx: reg w [0136] = 10
[ 3546.436249] zc3xx: reg w [0137] = 0e
[ 3546.437284] zc3xx: reg w [0138] = 0b
[ 3546.438283] zc3xx: reg w [0139] = 09
[ 3546.439284] zc3xx: reg w [013a] = 07
[ 3546.440264] zc3xx: reg w [013b] = 06
[ 3546.441258] zc3xx: reg w [013c] = 00
[ 3546.442259] zc3xx: reg w [013d] = 00
[ 3546.443255] zc3xx: reg w [013e] = 00
[ 3546.444250] zc3xx: reg w [013f] = 01
[ 3546.445285] zc3xx: reg w [010a] = 58
[ 3546.446283] zc3xx: reg w [010b] = f4
[ 3546.447282] zc3xx: reg w [010c] = f4
[ 3546.448264] zc3xx: reg w [010d] = f4
[ 3546.449258] zc3xx: reg w [010e] = 58
[ 3546.450256] zc3xx: reg w [010f] = f4
[ 3546.451255] zc3xx: reg w [0110] = f4
[ 3546.452252] zc3xx: reg w [0111] = f4
[ 3546.453284] zc3xx: reg w [0112] = 58
[ 3546.455284] zc3xx: reg r [0180] -> 00
[ 3546.455289] zc3xx: reg w [0180] = 00
[ 3546.456266] zc3xx: reg w [0019] = 00
[ 3546.481274] zc3xx: i2c w [23] = 0000 (00)
[ 3546.505293] zc3xx: i2c w [24] = 00aa (00)
[ 3546.529296] zc3xx: i2c w [25] = 00e6 (00)
[ 3546.553294] zc3xx: i2c w [21] = 003f (00)
[ 3546.553299] zc3xx: reg w [0190] = 01
[ 3546.554289] zc3xx: reg w [0191] = 55
[ 3546.555286] zc3xx: reg w [0192] = cc
[ 3546.556274] zc3xx: reg w [0195] = 00
[ 3546.557262] zc3xx: reg w [0196] = 18
[ 3546.558260] zc3xx: reg w [0197] = 6a
[ 3546.559260] zc3xx: reg w [018c] = 10
[ 3546.560256] zc3xx: reg w [018f] = 20
[ 3546.561289] zc3xx: reg w [01a9] = 10
[ 3546.562287] zc3xx: reg w [01aa] = 24
[ 3546.563286] zc3xx: reg w [001d] = 3f
[ 3546.564267] zc3xx: reg w [001e] = a5
[ 3546.565262] zc3xx: reg w [001f] = f0
[ 3546.566261] zc3xx: reg w [0020] = ff
[ 3546.567259] zc3xx: reg w [0180] = 40
[ 3546.569288] zc3xx: reg r [0180] -> 40
[ 3546.569293] zc3xx: reg w [0180] = 42
[ 3546.570289] zc3xx: reg w [0116] = 40
[ 3546.571287] zc3xx: reg w [0117] = 40
[ 3546.572270] zc3xx: reg w [0118] = 40
[ 3546.573263] zc3xx: reg w [011d] = 80
[ 3546.574260] zc3xx: reg w [018d] = 80
[ 3546.575261] zc3xx: reg w [01c6] = 08
[ 3546.577286] zc3xx: reg r [01c8] -> 05
[ 3546.578288] zc3xx: reg r [01c9] -> 07
[ 3546.579288] zc3xx: reg r [01ca] -> 0f
[ 3546.579292] zc3xx: reg w [01cb] = 0f
[ 3546.580269] zc3xx: reg w [0008] = 01
[ 3546.581262] zc3xx: reg w [0007] = 30
[ 3546.582264] zc3xx: reg w [0018] = ff
[ 3546.583264] zc3xx: reg w [0019] = 00
[ 3546.609295] zc3xx: i2c w [0f] = 0093 (00)
[ 3546.633295] zc3xx: i2c w [03] = 0005 (00)
[ 3546.657300] zc3xx: i2c w [04] = 00a1 (00)
[ 3546.681298] zc3xx: i2c w [10] = 0005 (00)
[ 3546.705301] zc3xx: i2c w [11] = 00a1 (00)
[ 3546.729301] zc3xx: i2c w [1b] = 0000 (00)
[ 3546.753302] zc3xx: i2c w [1c] = 0005 (00)
[ 3546.777303] zc3xx: i2c w [1d] = 00a1 (00)
[ 3546.777308] zc3xx: reg w [0190] = 00
[ 3546.778276] zc3xx: reg w [0191] = 3f
[ 3546.779276] zc3xx: reg w [0192] = f7
[ 3546.780269] zc3xx: reg w [0195] = 00
[ 3546.781268] zc3xx: reg w [0196] = 00
[ 3546.782269] zc3xx: reg w [0197] = 83
[ 3546.783273] zc3xx: reg w [018c] = 10
[ 3546.784280] zc3xx: reg w [018f] = 20
[ 3546.785268] zc3xx: reg w [01a9] = 10
[ 3546.786267] zc3xx: reg w [01aa] = 24
[ 3546.787269] zc3xx: reg w [001d] = 93
[ 3546.788267] zc3xx: reg w [001e] = b0
[ 3546.789269] zc3xx: reg w [001f] = d0
[ 3546.790268] zc3xx: reg w [0180] = 42
[ 3546.791342] gspca: poll
[ 3546.791346] gspca: poll
[ 3548.793470] gspca: poll
[ 3548.798663] zc3xx: reg w [0000] = 01




dmesg after gspca/v4l2-apps/test/v4l2grab
[ 3765.023888] gspca main driver: VIDIOC_DQBUF error -11
[ 3765.023890] gspca: dqbuf



dmesg after mplayer tv://
[ 3861.886517] gspca main driver: VIDIOC_QUERYCAP driver=zc3xx,
card=PC Camera, bus=usb-0000:00:1d.0-1, version=0x00020700,
capabilities=0x05000001
[ 3861.886533] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.886543] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.886551] gspca main driver: VIDIOC_G_STD error -22
[ 3861.886558] gspca main driver: VIDIOC_G_PARM type=1
[ 3861.886636] gspca main driver: VIDIOC_ENUMINPUT index=0,
name=zc3xx, type=2, audioset=0, tuner=0, std=00000000, status=0
[ 3861.886667] gspca main driver: VIDIOC_ENUMINPUT error -22
[ 3861.886674] gspca main driver: VIDIOC_G_INPUT value=0
[ 3861.886693] gspca main driver: VIDIOC_ENUM_FMT index=0, type=1,
flags=1, pixelformat=JPEG, description='JPEG'
[ 3861.896503] gspca main driver: VIDIOC_ENUM_FMT error -22
[ 3861.896541] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.896551] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896558] gspca main driver: VIDIOC_S_FMT type=vid-cap
[ 3861.896566] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896587] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.896595] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896602] gspca main driver: VIDIOC_S_FMT type=vid-cap
[ 3861.896610] gspca main driver: width=640, height=480, format=YV12,
field=any, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896618] gspca main driver: VIDIOC_ENUMINPUT index=0,
name=zc3xx, type=2, audioset=0, tuner=0, std=00000000, status=0
[ 3861.896629] gspca main driver: VIDIOC_S_INPUT value=0
[ 3861.896700] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.896709] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896728] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.896737] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896743] gspca main driver: VIDIOC_G_FMT type=vid-cap
[ 3861.896751] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[ 3861.896840] gspca main driver: VIDIOC_REQBUFS count=2,
type=vid-cap, memory=mmap
[ 3861.896850] gspca main driver: VIDIOC_QUERYBUF 00:57:38.00156121
index=0, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=118784
[ 3861.896866] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3861.896952] gspca: qbuf 0
[ 3861.896955] gspca: qbuf q:1 i:0 o:0
[ 3861.896959] gspca main driver: VIDIOC_QBUF 00:57:38.00156121
index=0, type=vid-cap, bytesused=0, flags=0x00000002, field=1,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=118784
[ 3861.896974] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3861.896980] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x0001d000, length=118784
[ 3861.896995] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3861.897030] gspca: qbuf 1
[ 3861.897033] gspca: qbuf q:0 i:0 o:0
[ 3861.897036] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000002, field=1,
sequence=0, memory=mmap, offset/userptr=0x0001d000, length=118784
[ 3861.897051] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[ 3861.897057] gspca main driver: VIDIOC_S_CTRL id=0x980909, value=0
[ 3861.897064] gspca main driver: VIDIOC_S_CTRL error -22
[ 3861.897096] gspca main driver: VIDIOC_QUERYCTRL id=0x980900,
type=1, name=Brightness, min/max=0/255, step=1, default=128,
flags=0x00000000
[ 3861.897107] gspca main driver: VIDIOC_S_CTRL id=0x980900, value=128
[ 3861.897116] gspca main driver: VIDIOC_QUERYCTRL id=0x980903
[ 3861.897121] gspca main driver: VIDIOC_QUERYCTRL error -22
[ 3861.897142] gspca main driver: VIDIOC_QUERYCTRL id=0x980902
[ 3861.897147] gspca main driver: VIDIOC_QUERYCTRL error -22
[ 3861.897168] gspca main driver: VIDIOC_QUERYCTRL id=0x980901,
type=1, name=Contrast, min/max=0/256, step=1, default=128,
flags=0x00000000
[ 3861.897179] gspca main driver: VIDIOC_S_CTRL id=0x980901, value=128
[ 3862.365882] gspca main driver: VIDIOC_STREAMON type=vid-cap
[ 3862.368836] zc3xx: reg r [0008] -> 11
[ 3862.371222] zc3xx: reg r [0008] -> 11
[ 3862.371227] zc3xx: reg w [0000] = 01
[ 3862.372259] zc3xx: reg w [0002] = 00
[ 3862.372700] zc3xx: reg w [0010] = 00
[ 3862.373500] zc3xx: reg w [0001] = 01
[ 3862.374498] zc3xx: reg w [0080] = 20
[ 3862.375502] zc3xx: reg w [0081] = 21
[ 3862.376622] zc3xx: reg w [0083] = 30
[ 3862.377498] zc3xx: reg w [0084] = 31
[ 3862.378496] zc3xx: reg w [0085] = 32
[ 3862.379489] zc3xx: reg w [0086] = 23
[ 3862.380501] zc3xx: reg w [0087] = 24
[ 3862.381496] zc3xx: reg w [0088] = 25
[ 3862.382494] zc3xx: reg w [008b] = b3
[ 3862.383499] zc3xx: reg w [0008] = 03
[ 3862.384575] zc3xx: reg w [0012] = 03
[ 3862.385497] zc3xx: reg w [0012] = 01
[ 3862.386496] zc3xx: reg w [0003] = 02
[ 3862.387522] zc3xx: reg w [0004] = 80
[ 3862.388548] zc3xx: reg w [0005] = 01
[ 3862.389498] zc3xx: reg w [0006] = e0
[ 3862.390495] zc3xx: reg w [0098] = 00
[ 3862.391496] zc3xx: reg w [009a] = 00
[ 3862.392549] zc3xx: reg w [011a] = 00
[ 3862.393495] zc3xx: reg w [011c] = 00
[ 3862.417534] zc3xx: i2c w [02] = 0008 (00)
[ 3862.441534] zc3xx: i2c w [03] = 0000 (00)
[ 3862.465534] zc3xx: i2c w [11] = 0001 (00)
[ 3862.489535] zc3xx: i2c w [12] = 0087 (00)
[ 3862.513534] zc3xx: i2c w [13] = 0001 (00)
[ 3862.537515] zc3xx: i2c w [14] = 00e7 (00)
[ 3862.563102] zc3xx: i2c w [20] = 0000 (00)
[ 3862.585517] zc3xx: i2c w [22] = 0000 (00)
[ 3862.609503] zc3xx: i2c w [0b] = 0004 (00)
[ 3862.633519] zc3xx: i2c w [30] = 0030 (00)
[ 3862.657520] zc3xx: i2c w [31] = 0030 (00)
[ 3862.681546] zc3xx: i2c w [32] = 0030 (00)
[ 3862.681552] zc3xx: reg w [0101] = 77
[ 3862.682534] zc3xx: reg w [0019] = 00
[ 3862.683513] zc3xx: reg w [0012] = 05
[ 3862.684483] zc3xx: reg w [0100] = 0d
[ 3862.685514] zc3xx: reg w [0189] = 06
[ 3862.686507] zc3xx: reg w [01c5] = 03
[ 3862.687514] zc3xx: reg w [01cb] = 13
[ 3862.688611] zc3xx: reg w [01ae] = 15
[ 3862.689508] zc3xx: reg w [0250] = 08
[ 3862.690504] zc3xx: reg w [0301] = 08
[ 3862.691499] zc3xx: reg w [018d] = 68
[ 3862.692588] zc3xx: reg w [01ad] = 00
[ 3862.694505] zc3xx: reg r [0002] -> 00
[ 3862.695507] zc3xx: reg r [0008] -> 03
[ 3862.695510] zc3xx: reg w [0008] = 03
[ 3862.696553] zc3xx: reg w [01c6] = 08
[ 3862.698497] zc3xx: reg r [01c8] -> 05
[ 3862.699498] zc3xx: reg r [01c9] -> 07
[ 3862.700501] zc3xx: reg r [01ca] -> 0f
[ 3862.700505] zc3xx: reg w [01cb] = 0f
[ 3862.701514] zc3xx: reg w [0120] = 24
[ 3862.702500] zc3xx: reg w [0121] = 44
[ 3862.703499] zc3xx: reg w [0122] = 64
[ 3862.704498] zc3xx: reg w [0123] = 84
[ 3862.705499] zc3xx: reg w [0124] = 9d
[ 3862.706500] zc3xx: reg w [0125] = b2
[ 3862.708303] zc3xx: reg w [0126] = c4
[ 3862.708506] zc3xx: reg w [0127] = d3
[ 3862.709514] zc3xx: reg w [0128] = e0
[ 3862.710537] zc3xx: reg w [0129] = eb
[ 3862.711539] zc3xx: reg w [012a] = f4
[ 3862.712620] zc3xx: reg w [012b] = fb
[ 3862.713498] zc3xx: reg w [012c] = ff
[ 3862.714504] zc3xx: reg w [012d] = ff
[ 3862.715507] zc3xx: reg w [012e] = ff
[ 3862.716508] zc3xx: reg w [012f] = ff
[ 3862.717506] zc3xx: reg w [0130] = 18
[ 3862.718505] zc3xx: reg w [0131] = 20
[ 3862.719506] zc3xx: reg w [0132] = 20
[ 3862.720557] zc3xx: reg w [0133] = 1c
[ 3862.721506] zc3xx: reg w [0134] = 16
[ 3862.722507] zc3xx: reg w [0135] = 13
[ 3862.723533] zc3xx: reg w [0136] = 10
[ 3862.724535] zc3xx: reg w [0137] = 0e
[ 3862.725508] zc3xx: reg w [0138] = 0b
[ 3862.726511] zc3xx: reg w [0139] = 09
[ 3862.727499] zc3xx: reg w [013a] = 07
[ 3862.728505] zc3xx: reg w [013b] = 06
[ 3862.729500] zc3xx: reg w [013c] = 00
[ 3862.730499] zc3xx: reg w [013d] = 00
[ 3862.731499] zc3xx: reg w [013e] = 00
[ 3862.732502] zc3xx: reg w [013f] = 01
[ 3862.733499] zc3xx: reg w [010a] = 58
[ 3862.734501] zc3xx: reg w [010b] = f4
[ 3862.735498] zc3xx: reg w [010c] = f4
[ 3862.736502] zc3xx: reg w [010d] = f4
[ 3862.737500] zc3xx: reg w [010e] = 58
[ 3862.738508] zc3xx: reg w [010f] = f4
[ 3862.739511] zc3xx: reg w [0110] = f4
[ 3862.740600] zc3xx: reg w [0111] = f4
[ 3862.741511] zc3xx: reg w [0112] = 58
[ 3862.743501] zc3xx: reg r [0180] -> 00
[ 3862.743505] zc3xx: reg w [0180] = 00
[ 3862.744507] zc3xx: reg w [0019] = 00
[ 3862.769526] zc3xx: i2c w [23] = 0000 (00)
[ 3862.793512] zc3xx: i2c w [24] = 00aa (00)
[ 3862.817513] zc3xx: i2c w [25] = 00e6 (00)
[ 3862.841520] zc3xx: i2c w [21] = 003f (00)
[ 3862.841526] zc3xx: reg w [0190] = 01
[ 3862.842517] zc3xx: reg w [0191] = 55
[ 3862.843541] zc3xx: reg w [0192] = cc
[ 3862.844555] zc3xx: reg w [0195] = 00
[ 3862.845516] zc3xx: reg w [0196] = 18
[ 3862.846504] zc3xx: reg w [0197] = 6a
[ 3862.847503] zc3xx: reg w [018c] = 10
[ 3862.848505] zc3xx: reg w [018f] = 20
[ 3862.849505] zc3xx: reg w [01a9] = 10
[ 3862.850502] zc3xx: reg w [01aa] = 24
[ 3862.851503] zc3xx: reg w [001d] = 3f
[ 3862.852508] zc3xx: reg w [001e] = a5
[ 3862.853502] zc3xx: reg w [001f] = f0
[ 3862.854502] zc3xx: reg w [0020] = ff
[ 3862.855502] zc3xx: reg w [0180] = 40
[ 3862.857522] zc3xx: reg r [0180] -> 40
[ 3862.857526] zc3xx: reg w [0180] = 42
[ 3862.858517] zc3xx: reg w [0116] = 40
[ 3862.859543] zc3xx: reg w [0117] = 40
[ 3862.860567] zc3xx: reg w [0118] = 40
[ 3862.861506] zc3xx: reg w [011d] = 80
[ 3862.862504] zc3xx: reg w [018d] = 80
[ 3862.863511] zc3xx: reg w [01c6] = 08
[ 3862.865517] zc3xx: reg r [01c8] -> 05
[ 3862.866510] zc3xx: reg r [01c9] -> 07
[ 3862.867511] zc3xx: reg r [01ca] -> 0f
[ 3862.867515] zc3xx: reg w [01cb] = 0f
[ 3862.868534] zc3xx: reg w [0008] = 01
[ 3862.869515] zc3xx: reg w [0007] = 30
[ 3862.870511] zc3xx: reg w [0018] = ff
[ 3862.871511] zc3xx: reg w [0019] = 00
[ 3862.897549] zc3xx: i2c w [0f] = 0093 (00)
[ 3862.921506] zc3xx: i2c w [03] = 0005 (00)
[ 3862.945499] zc3xx: i2c w [04] = 00a1 (00)
[ 3862.969494] zc3xx: i2c w [10] = 0005 (00)
[ 3862.993524] zc3xx: i2c w [11] = 00a1 (00)
[ 3863.017525] zc3xx: i2c w [1b] = 0000 (00)
[ 3863.041555] zc3xx: i2c w [1c] = 0005 (00)
[ 3863.065553] zc3xx: i2c w [1d] = 00a1 (00)
[ 3863.065559] zc3xx: reg w [0190] = 00
[ 3863.066548] zc3xx: reg w [0191] = 3f
[ 3863.067545] zc3xx: reg w [0192] = f7
[ 3863.068541] zc3xx: reg w [0195] = 00
[ 3863.069522] zc3xx: reg w [0196] = 00
[ 3863.070519] zc3xx: reg w [0197] = 83
[ 3863.071517] zc3xx: reg w [018c] = 10
[ 3863.072522] zc3xx: reg w [018f] = 20
[ 3863.073519] zc3xx: reg w [01a9] = 10
[ 3863.074517] zc3xx: reg w [01aa] = 24
[ 3863.075517] zc3xx: reg w [001d] = 93
[ 3863.076525] zc3xx: reg w [001e] = b0
[ 3863.077518] zc3xx: reg w [001f] = d0
[ 3863.078518] zc3xx: reg w [0180] = 42
[ 3863.079653] gspca: poll
[ 3863.079658] gspca: poll
[ 3864.080780] gspca: poll
[ 3864.080837] gspca: poll
[ 3865.081966] gspca: poll
[ 3865.082023] gspca: poll
[ 3866.083033] gspca: poll
[ 3866.083055] gspca: poll
[ 3867.084184] gspca: poll
[ 3867.084243] gspca: poll
[ 3868.085369] gspca: poll
[ 3868.085428] gspca: poll
[ 3869.086560] gspca: poll
[ 3869.086619] gspca: poll
[ 3870.087731] gspca: poll
[ 3870.087789] gspca: poll
[ 3871.088918] gspca: poll
[ 3871.088975] gspca: poll
[ 3872.090064] gspca: poll
[ 3872.090103] gspca: poll
[ 3873.091232] gspca: poll
[ 3873.091288] gspca: poll
[ 3874.092418] gspca: poll
[ 3874.092477] gspca: poll
[ 3875.093584] gspca: poll
[ 3875.093623] gspca: poll
[ 3876.094752] gspca: poll
[ 3876.094810] gspca: poll
[ 3877.095940] gspca: poll
[ 3877.095997] gspca: poll
[ 3878.096013] gspca: poll
[ 3878.096046] gspca: poll
[ 3879.097177] gspca: poll
[ 3879.097234] gspca: poll
[ 3880.098362] gspca: poll
[ 3880.098422] gspca: poll
[ 3881.099547] gspca: poll
[ 3881.099604] gspca: poll
[ 3882.100732] gspca: poll
[ 3882.100791] gspca: poll
[ 3883.101922] gspca: poll
[ 3883.101979] gspca: poll
[ 3884.102980] gspca: poll
[ 3884.103003] gspca: poll
[ 3885.104136] gspca: poll
[ 3885.104195] gspca: poll
[ 3886.105268] gspca: poll
[ 3886.105327] gspca: poll
[ 3887.106401] gspca: poll
[ 3887.106459] gspca: poll
[ 3888.107589] gspca: poll
[ 3888.107649] gspca: poll
[ 3889.108778] gspca: poll
[ 3889.108837] gspca: poll
[ 3890.109843] gspca: poll
[ 3890.109958] gspca main driver: VIDIOC_STREAMOFF type=vid-cap
[ 3890.116530] zc3xx: reg w [0000] = 01
[ 3890.117415] gspca: dqbuf
[ 3890.117418] gspca main driver: VIDIOC_DQBUF error -22
[ 3890.117466] gspca main driver: VIDIOC_S_CTRL id=0x980909, value=1
[ 3890.117471] gspca main driver: VIDIOC_S_CTRL error -22
