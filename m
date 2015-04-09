Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34566 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbbDIOTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 10:19:30 -0400
Received: by lbcga7 with SMTP id ga7so42624583lbc.1
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2015 07:19:28 -0700 (PDT)
Message-ID: <1428589165.4446.16.camel@kaffemocca>
Subject: usbtv: no video or sound with linux kernel 3.18.0 and 3.18.11
From: Malin Bruland <malinkh@gmail.com>
To: linux-media@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>
Date: Thu, 09 Apr 2015 16:19:25 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I have the Fushicai USBTV

Os: Ubuntu 14.04.2 lts
kernel: 3.18.11-031811-generic

I have tested with kernel 3.16.0-30 generic: video, but no sound.





In lsusb detetced as:

Bus 003 Device 002: ID 1b71:3002  


Dmesg kernel 3.18.11:

[   72.550720] usb 4-1.2: USB disconnect, device number 3
[   74.026917] usb 4-1.2: new high-speed USB device number 5 using ehci-pci
[   74.122176] usb 4-1.2: config 1 interface 0 altsetting 1 bulk endpoint 0x83 has invalid maxpacket 256
[   74.125288] usb 4-1.2: New USB device found, idVendor=1b71, idProduct=3002
[   74.125292] usb 4-1.2: New USB device strings: Mfr=3, Product=4, SerialNumber=2
[   74.125293] usb 4-1.2: Product: usbtv007
[   74.125294] usb 4-1.2: Manufacturer: fushicai
[   74.125295] usb 4-1.2: SerialNumber: 300000000002
[   74.126288] usbtv 4-1.2:1.0: Fushicai USBTV007 Audio-Video Grabber



With ubuntu 14.04.2 lts kernel 3.16 I get video, but no audio.


When trying to capture with vlc:
malin@kaffemocca:~$ vlc
VLC media player 2.1.6 Rincewind (revision 2.1.6-0-gea01d28)
[0x1037058] main libvlc: Running vlc with the default interface. Use
'cvlc' to use vlc without interface.
[0x7f79b4006a38] filesystem access error: cannot open
file /home/malin/hw:0,0 (No such file or directory)
[0x7f79b80009b8] main input error: open of `file:///home/malin/hw%3A0%
2C0' failed
[0x7f79b4029348] filesystem access error: cannot open
file /home/malin/hw:1,0 (No such file or directory)
[0x7f79b8006578] main input error: open of `file:///home/malin/hw%3A1%
2C0' failed


When trying to capture with mplayer, I get this:

malin@kaffemocca:~$ mplayer tv:// -tv
driver=v4l2:width=720:height=576:device=/dev/video0 -vo xv -fps 65
MPlayer 1.1-4.8 (C) 2000-2012 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: usbtv
 Capabilities:  video capture  read/write  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4
= NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 =
PAL-M; 11 = PAL-60;
 inputs: 0 = Composite; 1 = S-Video;
 Current input: 0
 Current format: YUYV
Selected input hasn't got a tuner!
v4l2: ioctl set mute failed: Inappropriate ioctl for device
v4l2: ioctl query control failed: Inappropriate ioctl for device
v4l2: ioctl query control failed: Inappropriate ioctl for device
v4l2: ioctl query control failed: Inappropriate ioctl for device
v4l2: ioctl query control failed: Inappropriate ioctl for device
==========================================================================
Opening video decoder: [raw] RAW Uncompressed Video
Movie-Aspect is undefined - no prescaling applied.
VO: [xv] 720x576 => 720x576 Packed YUY2 
Selected video codec: [rawyuy2] vfm: raw (RAW YUY2)
==========================================================================
Audio: no sound
FPS forced to be 65.000  (ftime: 0.015).
Starting playback...
V:   0.0   1/  1 ??%MPlayer interrupted by signal 2 in module:
video_read_frame
V:   0.0  22/ 22 ??% ??% ??,?% 0 0 
v4l2: select timeout
v4l2: ioctl set mute failed: Inappropriate ioctl for device
v4l2: 0 frames successfully processed, 1 frames dropped.
 ??% ??,?% 0 0 
v4l2: select timeout
V:   0.0   3/  3 ??% ??% ??,?% 0 0 
v4l2: select timeout
V:   0.0   5/  5 ??% ??% ??,?% 0 0 

Getting just green screen, with no video or audio

.





