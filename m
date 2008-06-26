Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5QJmJ5K002446
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 15:48:19 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5QJm6V5004223
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 15:48:07 -0400
Date: Thu, 26 Jun 2008 21:48:04 +0200
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080626194804.GB18818@vidsoft.de>
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806240033.41145.laurent.pinchart@skynet.be>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de
Subject: Driver hangs at DQBUF ioctl
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


Hi all,

this got a somewhat lengthy bugreport. Some words to my environment:

These traces were produced on a Core2Duo (in amd64 mode) with a ASUS P5B board and
vanilla Linux 2.6.25.8. I observed the same behavior on a 32bit QuadCore with a
Logitech 9000 and Linux 2.6.25.6.

This is the trace from my app. As you can see, the main thread (17460) queues the
buffer, starts the grabbing thread right after the STREAMON and queries
brightness, contrast, hue and saturation.
The grabbing thread tries to dequeue a buffer and hangs:

-> Thread=17460 ioctl=c058560f          QBUF
<- Thread=17460 ioctl=c058560f ret=0    QBUF
-> Thread=17460 ioctl=c058560f          QBUF
<- Thread=17460 ioctl=c058560f ret=0    QBUF
-> Thread=17460 ioctl=40045612          STREAMON
<- Thread=17460 ioctl=40045612 ret=0    STREAMON
-> Thread=17460 ioctl=c0445624          QUERYCTRL
-> Thread=17487 ioctl=c0585611          DQBUF
<- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
-> Thread=17460 ioctl=c008561b          G_CTRL
<- Thread=17460 ioctl=c008561b ret=0    G_CTRL
-> Thread=17460 ioctl=c0445624          QUERYCTRL
<- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
-> Thread=17460 ioctl=c008561b          G_CTRL
<- Thread=17460 ioctl=c008561b ret=0    G_CTRL
-> Thread=17460 ioctl=c0445624          QUERYCTRL
<- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
-> Thread=17460 ioctl=c008561b          G_CTRL
<- Thread=17460 ioctl=c008561b ret=0    G_CTRL
-> Thread=17460 ioctl=c0445624          QUERYCTRL
<- Thread=17460 ioctl=c0445624 ret=0    QUERYCTRL
-> Thread=17460 ioctl=c008561b          G_CTRL
<- Thread=17460 ioctl=c008561b ret=0    G_CTRL

Trace from UVC driver:

Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: Queuing buffer 0.
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: Queuing buffer 1.
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_STREAMON, dir=-w (0x40045612)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_DQBUF, dir=rw (0xc0585611)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
Jun 26 20:31:20 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:31:20 Rincewind kernel: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)

A second test after module unloading and replugging of the camera: 
Here the dequeing of the first buffer succeedes, although the MJPEG
decoder complains about garbage. The second dqbuf operation hangs now.

-> Thread=17989 ioctl=15        QBUF
<- Thread=17989 ioctl=15 ret=0  QBUF
-> Thread=17989 ioctl=15        QBUF
<- Thread=17989 ioctl=15 ret=0  QBUF
-> Thread=17989 ioctl=18        STREAMON
<- Thread=17989 ioctl=18 ret=0  STREAMON
-> Thread=18010 ioctl=17        DQBUF
-> Thread=17989 ioctl=36        QUERYCTRL
<- Thread=17989 ioctl=36 ret=0  QUERYCTRL
-> Thread=17989 ioctl=27        G_CTRL
<- Thread=17989 ioctl=27 ret=0  G_CTRL
-> Thread=17989 ioctl=36        QUERYCTRL
<- Thread=17989 ioctl=36 ret=0  QUERYCTRL
-> Thread=17989 ioctl=27        G_CTRL
<- Thread=17989 ioctl=27 ret=0  G_CTRL
-> Thread=17989 ioctl=36        QUERYCTRL
<- Thread=17989 ioctl=36 ret=0  QUERYCTRL
-> Thread=17989 ioctl=27        G_CTRL
<- Thread=17989 ioctl=27 ret=0  G_CTRL
-> Thread=17989 ioctl=36        QUERYCTRL
<- Thread=17989 ioctl=36 ret=0  QUERYCTRL
-> Thread=17989 ioctl=27        G_CTRL
<- Thread=17989 ioctl=27 ret=0  G_CTRL
<- Thread=18010 ioctl=17 ret=0  DQBUF
Calling MJPEG Decoder: 1
MJPEG: target size != image size!
-> Thread=18010 ioctl=15        QBUF
<- Thread=18010 ioctl=15 ret=0  QBUF
-> Thread=18010 ioctl=17        DQBUF

The associated UVC trace:

Jun 26 20:47:23 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCTRL, dir=rw (0xc0445624)
Jun 26 20:47:23 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:47:23 Rincewind kernel: v4l2 ioctl VIDIOC_G_CTRL, dir=rw (0xc008561b)
Jun 26 20:47:23 Rincewind kernel: uvcvideo: Frame complete (EOF found).
Jun 26 20:47:23 Rincewind kernel: uvcvideo: EOF in empty payload.
Jun 26 20:47:23 Rincewind kernel: uvcvideo: Dequeuing buffer 0 (3, 4156 bytes).
Jun 26 20:47:23 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:47:23 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:47:23 Rincewind kernel: uvcvideo: Queuing buffer 0.
Jun 26 20:47:23 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:47:23 Rincewind kernel: v4l2 ioctl VIDIOC_DQBUF, dir=rw (0xc0585611)

The size of the first frame. The first frame is always 4156 bytes long. Even if
the driver does not block.

$ ls -la /tmp/frame-00000@352x288.mjpeg
-rw-r--r-- 1 gjasny gjasny 4156 26. Jun 21:01 /tmp/frame-00000@352x288.mjpeg

$ hexdump /tmp/frame-00000@352x288.mjpeg
0000000 d8ff e0ff 1000 464a 4649 0100 0101 0000
0000010 0000 0000 dbff 4300 0500 0403 0404 0503
0000020 0404 0604 0505 0806 080d 0708 0807 0b0f
0000030 090c 120d 1310 1213 1210 1411 1d17 1418
0000040 1b15 1116 1912 1922 1e1b 201f 2021 1813
0000050 2623 1f23 1d26 2020 ff1f 00db 0143 0605
0000060 0806 0807 080f 0f08 151f 1512 1f1f 1f1f
[...]

One maybe interesting observation: If I reload the module after a
deadlock and let the camera plugged in, the following trace is produced:
A now started luvcview blocks during dqbuf, too (See next trace).
The only way to get a working camera again is to replug the camera.

Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Brightness to control 00000000-0000-0000-0000-000000000101/2.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Contrast to control 00000000-0000-0000-0000-000000000101/3.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Hue to control 00000000-0000-0000-0000-000000000101/6.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Saturation to control 00000000-0000-0000-0000-000000000101/7.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Sharpness to control 00000000-0000-0000-0000-000000000101/8.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Gamma to control 00000000-0000-0000-0000-000000000101/9.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Backlight Compensation to control 00000000-0000-0000-0000-000000000101/1.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Gain to control 00000000-0000-0000-0000-000000000101/4.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Power Line Frequency to control 00000000-0000-0000-0000-000000000101/5.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Hue, Auto to control 00000000-0000-0000-0000-000000000101/16.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Exposure, Auto to control 00000000-0000-0000-0000-000000000001/2.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Exposure, Auto Priority to control 00000000-0000-0000-0000-000000000001/3.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Exposure (Absolute) to control 00000000-0000-0000-0000-000000000001/4.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping White Balance Temperature, Auto to control 00000000-0000-0000-0000-000000000101/11.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping White Balance Temperature to control 00000000-0000-0000-0000-000000000101/10.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping White Balance Component, Auto to control 00000000-0000-0000-0000-000000000101/13.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping White Balance Blue Component to control 00000000-0000-0000-0000-000000000101/12.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping White Balance Red Component to control 00000000-0000-0000-0000-000000000101/12.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Focus (absolute) to control 00000000-0000-0000-0000-000000000001/6.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Adding mapping Focus, Auto to control 00000000-0000-0000-0000-000000000001/8.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Probing known UVC device 1.1 (045e:00f8)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Found format MJPEG.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 352x288 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 1600x1200 (7.5 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 1280x1024 (7.5 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 1024x768 (7.5 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 800x600 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 640x480 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 320x240 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 176x144 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: - 160x120 (30.0 fps)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Found a Status endpoint (addr 83).
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Found UVC 1.00 device Microsoft¿ LifeCam NX-6000 (045e:00f8)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/2 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/3 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/6 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/7 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/8 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/9 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/1 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/5 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/11 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Added control 00000000-0000-0000-0000-000000000101/10 to device 1.1 entity 5
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Scanning UVC chain: OT 3 <- PU 5 <- SU 4 <- IT 1
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Found a valid video chain (1 -> 3).
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
Jun 26 20:55:57 Rincewind kernel: input: Microsoft¿ LifeCam NX-6000 as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.1/2-1.1:1.0/input/input11
Jun 26 20:55:57 Rincewind kernel: uvcvideo: uvc_v4l2_open
Jun 26 20:55:57 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:55:57 Rincewind kernel: v4l1 ioctl VIDIOCGCAP, dir=r- (0x803c7601)
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600)
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_ENUMINPUT, dir=rw (0xc050561a)
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_ENUM_FMT, dir=rw (0xc0405602)
Jun 26 20:55:57 Rincewind kernel: v4l2 ioctl VIDIOC_TRY_FMT, dir=rw (0xc0d05640)
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Trying format 0x47504a4d (MJPG): 10000x10000.
Jun 26 20:55:57 Rincewind kernel: uvcvideo: Using default frame interval 133333.3 us (7.5 fps).
Jun 26 20:55:57 Rincewind kernel: uvcvideo: uvc_v4l2_release
Jun 26 20:55:58 Rincewind kernel: uvcvideo: UVC device initialized.
Jun 26 20:55:58 Rincewind kernel: usbcore: registered new interface driver uvcvideo
Jun 26 20:55:58 Rincewind kernel: USB Video Class driver (SVN r217)

luvcview:
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_open
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYCAP, dir=r- (0x80685600)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_S_FMT, dir=rw (0xc0d05605)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Trying format 0x47504a4d (MJPG): 320x240.
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_S_PARM, dir=rw (0xc0cc5616)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Setting frame interval to 1/15 (666666).
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_REQBUFS, dir=rw (0xc0145608)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw (0xc0585609)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_mmap
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw (0xc0585609)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_mmap
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw (0xc0585609)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_mmap
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QUERYBUF, dir=rw (0xc0585609)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_mmap
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Queuing buffer 0.
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Queuing buffer 1.
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Queuing buffer 2.
Jun 26 20:57:15 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:15 Rincewind kernel: v4l2 ioctl VIDIOC_QBUF, dir=rw (0xc058560f)
Jun 26 20:57:15 Rincewind kernel: uvcvideo: Queuing buffer 3.
Jun 26 20:57:16 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:16 Rincewind kernel: v4l2 ioctl VIDIOC_STREAMON, dir=-w (0x40045612)
Jun 26 20:57:16 Rincewind kernel: uvcvideo: uvc_v4l2_ioctl
Jun 26 20:57:16 Rincewind kernel: v4l2 ioctl VIDIOC_DQBUF, dir=rw (0xc0585611)

You might find the lsusb of the camera helpful:

Bus 002 Device 007: ID 045e:00f8 Microsoft Corp. LifeCam NX-6000.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x045e Microsoft Corp.
  idProduct          0x00f8 LifeCam NX-6000.
  bcdDevice            1.00
  iManufacturer           1 
  iProduct                2 Microsoft® LifeCam NX-6000
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          555
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               2 Microsoft® LifeCam NX-6000
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              2 Microsoft® LifeCam NX-6000
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           57
        dwClockFrequency       30.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                17
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  2
        bmControls           0x00000a00
          Zoom (Absolute)
          PanTilt (Absolute)
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               5
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      4 (SELECTOR_UNIT)
        bUnitID                 4
        bNrInPins               1
        baSource( 0)            1
        iSelector               0 
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 5
        bSourceID               4
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000557f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          White Balance Temperature
          Backlight Compensation
          Power Line Frequency
          White Balance Temperature, Auto
          Digital Multiplier
        iProcessing             0 
        bmVideoStandards     0x68
          SECAM - 625/50
          PAL - 525/60
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              16
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                        1
        wTotalLength                      295
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       3
        bStillCaptureMethod                 0
        bTriggerSupport                     0
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                9
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 48660480
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1600
        wHeight                          1200
        dwMinBitRate                230400000
        dwMaxBitRate                230400000
        dwMaxVideoFrameBufferSize     3840000
        dwDefaultFrameInterval        1333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                          1024
        dwMinBitRate                157286400
        dwMaxBitRate                157286400
        dwMaxVideoFrameBufferSize     2621440
        dwDefaultFrameInterval        1333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1024
        wHeight                           768
        dwMinBitRate                 94371840
        dwMaxBitRate                 94371840
        dwMaxVideoFrameBufferSize     1572864
        dwDefaultFrameInterval        1333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            800
        wHeight                           600
        dwMinBitRate                230400000
        dwMaxBitRate                230400000
        dwMaxVideoFrameBufferSize      960000
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                147456000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         7
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 36864000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         8
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                 12165120
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  9216000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13fc  3x 1020 bytes
        bInterval               1
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       1 Control Device
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           41
        bInCollection           1
        baInterfaceNr( 0)       3
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Microphone
        bAssocTerminal          0
        bNrChannels             1
        wChannelConfig     0x0000
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               3
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 3
        bSourceID               1
        bControlSize            2
        bmaControls( 0)      0x00
        bmaControls( 0)      0x00
        bmaControls( 1)      0x43
        bmaControls( 1)      0x00
          Mute
          Volume
          Automatic Gain
        iFeature                0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           2
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                35
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         24
        bSamFreqType            9 Discrete
        tSamFreq[ 0]        48000
        tSamFreq[ 1]        44100
        tSamFreq[ 2]        32000
        tSamFreq[ 3]        24000
        tSamFreq[ 4]        22050
        tSamFreq[ 5]        16000
        tSamFreq[ 6]        12000
        tSamFreq[ 7]        11025
        tSamFreq[ 8]         8000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0080  1x 128 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0         8
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Every time the driver is loaded, the driver prints the following line:
uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).

Would it be possible to suppress this query by a camera specific quirk?

Where in the driver should I add what traces?

Is it possible to let a dqbuf ioctl have a time out?


Cheers,
Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
