Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0VNU3dV013348
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 18:30:03 -0500
Received: from ws6-3.us4.outblaze.com (ws6-3.us4.outblaze.com [205.158.62.199])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0VNTkAP023876
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 18:29:46 -0500
Message-ID: <4984DEE6.90005@bigpond.net.au>
Date: Sun, 01 Feb 2009 10:29:42 +1100
From: Trevor Campbell <tca42186@bigpond.net.au>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Kiaser Baas Video to DVD maker - No Sound
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

I have a Kiaser Baas Video to DVD maker which with help and a patch from 
Devin Heitmueller and MArcus Rechberger I hav got working fine but there 
is no sound captured.

I have been able to install a copy of Win XP  and the siupplied drivers 
and so verify the device actually works correctly.

I tested with both tvtime and mplayer and they both displayed video 
well, using
both the composite and s-video inputs.

I am using pulse audio , but tried tvtime using padsp.  but no joy.

More Info:
When the device is plugged in it shows as a USB audio device.  I am not 
sure if
this should be the case or not.  Gnome sound recorder doesn't seem to 
see any
input and sort of locks up if I try to record using this device.

lsmod output
# lsmod | grep em28
em28xx                377792  1
videodev               35840  2 em28xx
v4l1_compat            18052  2 em28xx,videodev
i2c_core               24212  4 em28xx,saa7115,v4l2_common,i2c_i801
usbcore               137584  9
em28xx,snd_usb_audio,snd_usb_lib,usbhid,btusb,uhci_hcd,ohci_hcd,ehci_hcd


Output from mplayer:
$ mplayer tv://
MPlayer 1.0-1.rc2.18.1mdv2009.0-4.3.2 (C) 2000-2007 MPlayer Team
CPU: Genuine Intel(R) CPU           T2400  @ 1.83GHz (Family: 6, Model: 14,
Stepping: 8)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote 
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come  ;-)
Selected device: Pinnacle Dazzle DVC 90
 Capabilites:  video capture  audio  read/write  streaming
 supported norms: 0 = PAL-BG; 1 = SECAM L; 2 = NTSC M;
 inputs: 0 = Composite1; 1 = S-Video;
 Current input: 0
 Current format: YUYV
tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
Selected input hasn't got a tuner!
v4l2: ioctl set Brightness 128 failed: Numerical result out of range
v4l2: ioctl set Hue 0 failed: Invalid argument
v4l2: ioctl set Saturation 64 failed: Numerical result out of range
v4l2: ioctl set Contrast 64 failed: Numerical result out of range
xscreensaver_disable: Could not find XScreenSaver window.
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
VDec: vo config request - 640 x 480 (preferred colorspace: Packed YUY2)
VDec: using Packed YUY2 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 640x480 => 640x480 Packed YUY2  [zoom]
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
Starting playback...
v4l2: 817 frames successfully processed, 3 frames dropped.

Exiting... (Quit)

Here is the dmesg output.

usb 1-3: new high speed USB device using ehci_hcd and address 5
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=1b80, idProduct=e302
usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-3: Product: USB 2861 Device
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (1b80:e302): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
saa7115' 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
attach_inform: saa7113 detected.
em28xx #0: V4L2 device registered as /dev/video0
em28xx #0: Found Pinnacle Dazzle DVC 90
audio device (1b80:e302): interface 1, class 1
usbcore: registered new interface driver em28xx
usbcore: registered new interface driver snd-usb-audio

Thanks
Trevor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
