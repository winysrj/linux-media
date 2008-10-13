Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DFYkgY007615
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 11:34:46 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DFYZWn016778
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 11:34:35 -0400
Received: by gxk8 with SMTP id 8so2903651gxk.3
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 08:34:35 -0700 (PDT)
Message-ID: <d65c1460810130834w6bb9b1bai22440a31d9581d0d@mail.gmail.com>
Date: Mon, 13 Oct 2008 12:34:34 -0300
From: "Nicolau Werneck" <nwerneck@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: logitech quickcam deluxe not working well
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

Hello. I am not sure this is the place to look for help, but I saw a
few similar problems related, so here it goes.

I have this Logitech camera:

wintermute:/home/nwerneck# lsusb
Bus 002 Device 003: ID 046d:09c1 Logitech, Inc. QuickCam Deluxe for Notebooks

I can see its image successfully with mplayer using mplayer:

wintermute:/home/nwerneck# mplayer tv://
MPlayer 1.0rc2-4.3.1-DFSG-free (C) 2000-2007 MPlayer Team
CPU: Mobile AMD Sempron(tm) Processor 3500+ (Family: 15, Model: 76, Stepping: 2)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
v4l2: ioctl get standard failed: Invalid argument
Selected device: UVC Camera (046d:09c1)
 Capabilites:  video capture  streaming
 supported norms:
 inputs: 0 = Camera 1;
 Current input: 0
 Current format: YUYV
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
v4l2: ioctl enum norm failed: Invalid argument
Error: Cannot set norm!
Selected input hasn't got a tuner!
v4l2: ioctl set mute failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Packed YUY2
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
V:   0.0  19/ 19 ??% ??% ??,?% 0 0




... but, I can't use it with the opencv programs I am making, and with
any other applications, such as xawtv:

wintermute:/home/nwerneck# LANG=C xawtv
This is xawtv-3.95.dfsg.1, running on Linux/x86_64 (2.6.26-1-amd64)
xinerama 0: 1280x800+0+0
X Error of failed request:  XF86DGANoDirectVideoMode
  Major opcode of failed request:  137 (XFree86-DGA)
  Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
  Serial number of failed request:  13
  Current serial number in output stream:  13
v4l-conf had some trouble, trying to continue anyway
ioctl: VIDIOC_QUERYMENU(id=9963800;index=0;name="�";reserved=4138623483):
Invalid argument
Warning: Cannot convert string
"-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
ioctl: VIDIOC_G_STD(std=0xffeed654
[PAL_G,PAL_I,PAL_D1,PAL_N,PAL_Nc,NTSC_M,?,?,SECAM_D,SECAM_G,SECAM_H,SECAM_K1,SECAM_L,?ATSC_8_VSB,ATSC_16_VSB,(null),(null),(null),(null),(null),(null),(null)]):
Invalid argument
Falha de segmentação

(that is a segmentation fault by the way)

It seems I can't even use v4lctl:

wintermute:/home/nwerneck# v4lctl -c /dev/video0 show
ioctl: VIDIOC_QUERYMENU(id=9963800;index=0;name="��;reserved=4154774011):
Invalid argument
ioctl: VIDIOC_G_STD(std=0xf7f632e0ffb69308
[PAL_H,PAL_M,PAL_N,NTSC_M,?,SECAM_D,SECAM_G,SECAM_K,SECAM_K1,?ATSC_8_VSB,ATSC_16_VSB,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)]):
Invalid argument
norm: (null)
input: Camera 1
bright: 127
contrast: 32
color: 32
White Balance Temperature, Auto: on
Gain: 29
Falha de segmentação


Any ideas?

thanks in advance,
   ++nicolau




-- 
Nicolau Werneck <nwerneck@gmail.com>         9F99 25AB E47E 8724 2F71
http://www.lti.pcs.usp.br/~nwerneck                   EA40 DC23 42CE 6B76 B07F
Linux user #460716

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
