Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n57LsEpK029062
	for <video4linux-list@redhat.com>; Sun, 7 Jun 2009 17:54:14 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n57Lrwis008556
	for <video4linux-list@redhat.com>; Sun, 7 Jun 2009 17:53:58 -0400
Received: by an-out-0708.google.com with SMTP id b38so1631951ana.36
	for <video4linux-list@redhat.com>; Sun, 07 Jun 2009 14:53:57 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Jun 2009 17:53:57 -0400
Message-ID: <ab1abcde0906071453x40c5c2f8y45c1a9c9ddefbb1d@mail.gmail.com>
From: Russell King <rjkfsm@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Creative Instant GSPCA
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

Hi,

I am trying to use an old Creative Instant Webcam with the gspca module that
ships with the 2.6.29 kernel and almost all I get are problems. It does not
matter if I use my laptop with an ATI video card or my desktop with an
nVidia card. I have tried using the webcam as the only device on the USB
hub. Funny thing is that "mplayer tv:// -tv
driver=v4l2:width=352:height=288:device=/dev/video0" works properly.

On the desktop PC, lsusb gives me:
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 003: ID 041e:4034 Creative Technology, Ltd WebCam Instant
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 005 Device 002: ID 046d:c044 Logitech, Inc. LX3 Optical Mouse
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 008: ID 0951:1607 Kingston Technology Data Traveler 2.0
Bus 001 Device 007: ID 0930:6545 Toshiba Corp. Kingston DataTraveler 2.0
Stick (4GB) / PNY Attache 4GB Stick
Bus 001 Device 006: ID 13b1:0020 Linksys WUSB54GC 802.11g Adapter [ralink
rt73]
Bus 001 Device 005: ID 03f0:1807 Hewlett-Packard
Bus 001 Device 004: ID 1058:1100 Western Digital Technologies, Inc.
Bus 001 Device 003: ID 046d:c215 Logitech, Inc. Extreme 3D Pro
Bus 001 Device 002: ID 0409:0050 NEC Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

v4l-conf gives me:
v4l-conf: using X11 display :0.0
WARNING: v4l-conf is compiled without DGA support.
mode: 1680x1050, depth=24, bpp=32, bpl=6720, base=unknown
/dev/video0 [v4l2]: no overlay support

xawtv with or without the -noxv switch gives me:
This is xawtv-3.95, running on Linux/x86_64 (2.6.29-gentoo-r5)
WARNING: v4l-conf is compiled without DGA support.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to
type FontStruct
no way to get: 384x288 32 bit TrueColor (LE: bgr-)

"streamer -d -c /dev/video0 -b 16 -o test.jpeg" gives me:
checking writer files [multiple image files] ...
  video name=ppm ext=ppm: ext mismatch [need jpeg]
  video name=pgm ext=pgm: ext mismatch [need jpeg]
  video name=jpeg ext=jpeg: OK
files / video: JPEG (JFIF) / audio: none
vid-open: trying: v4l2-old...
vid-open: failed: v4l2-old
vid-open: trying: v4l2...
v4l2: open
v4l2: device info:
  zc3xx 2.4.0 / WebCam Instant  @ 0000:01:06.0
vid-open: ok: v4l2
movie_init_writer start
setformat: JPEG (JFIF) (320x240): failed
setformat: 12 bit YUV 4:2:0 (planar) (320x240): failed
setformat: 16 bit YUV 4:2:2 (planar) (320x240): failed
setformat: 24 bit TrueColor (BE: rgb) (320x240): failed
setformat: 24 bit TrueColor (LE: bgr) (320x240): failed
no way to get: 320x240 JPEG (JFIF)
movie writer initialisation failed
v4l2: close
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
