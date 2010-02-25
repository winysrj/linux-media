Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64241 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab0BYLZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 06:25:30 -0500
Received: by wya21 with SMTP id 21so1802392wya.19
        for <linux-media@vger.kernel.org>; Thu, 25 Feb 2010 03:25:29 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 12:25:27 +0100
Message-ID: <67dbe4d71002250325l1938097eo60e8f66999d0d8e0@mail.gmail.com>
Subject: Em28xx: vidioc_s_fmt_vid_cap queue busy
From: Denis Barbazza <denis.barbazza@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I've compiled em28xx for openwrt, on an ixp4xx cpu (armeb, Linskys NSLU2).
Kernel is 2.6.32.8, all went ok.

The device is a generic em2860, on my x86 pc it works ok:
Bus 001 Device 002: ID eb1a:2860 eMPIA Technology, Inc.


Modules loaded successfully but when i start a grab (with simple hasciicam)
I obtain an error:
error in ioctl VIDIOCSYNC: : Device or resource busy
(I'll attach the whol output to end of message)

dmesg says:
em28xx #0: vidioc_s_fmt_vid_cap queue busy


then i load videobuf-core, videobuf-vmalloc with debug=1 and em28xx
with core-debug=1 and dmesg says::

vbuf-vmalloc: __videobuf_mmap_free
vbuf-vmalloc: __videobuf_mmap_free
vbuf: reqbufs: bufs=8, size=0x9000 [72 pages total]
vbuf-vmalloc: __videobuf_mmap_free
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef00e0(100+16) & c1ef0154(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef0660(100+16) & c1ef06d4(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef06e0(100+16) & c1ef0754(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef0560(100+16) & c1ef05d4(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef03e0(100+16) & c1ef0454(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef0360(100+16) & c1ef03d4(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef02e0(100+16) & c1ef0354(12)
vbuf-vmalloc: __videobuf_alloc: allocated at c1ef0260(100+16) & c1ef02d4(12)
vbuf: mmap setup: 8 buffers, 36864 bytes each
em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,255)
em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,0)
vbuf: qbuf: mmap requested but buffer addr is zero!
vbuf-vmalloc: __videobuf_mmap_mapper
vbuf-vmalloc: vmalloc is at addr c2bec000 (294912 pages)
vbuf-vmalloc: mmap c1135a00: q=c1d3620c 400cf000-40117000 (9000) pgoff
00000000 buf 0
vbuf: busy: buffer #0 mapped
em28xx #0: vidioc_s_fmt_vid_cap queue busy
vbuf-vmalloc: munmap c1135a00 q=c1d3620c
vbuf-vmalloc: videobuf_vm_close: buf[0] freeing (c2bec000)
vbuf-vmalloc: __videobuf_mmap_free
vbuf-vmalloc: __videobuf_mmap_free



This is output of hasciicam:
------------------------------------------------------------------------
root@OpenWrt:/tmp# hasciicam -d /dev/video0 -m text
HasciiCam 1.0 - (h)ascii 4 the masses! - http://ascii.dyne.org
(c)2000-2006 Denis Roio < jaromil @ dyne.org >
watch out for the (h)ASCII ROOTS

Device detected is /dev/video0
EM2860/SAA711X Reference Design
2 channels detected
max size w[720] h[576] - min size w[48] h[32]
Video capabilities:
VID_TYPE_CAPTURE          can capture to memory
VID_TYPE_TELETEXT         has teletext capability
memory map of 8 frames: 294912 bytes
Offset of frame 0: 0
Offset of frame 1: 36864
Offset of frame 2: 73728
Offset of frame 3: 110592
Offset of frame 4: 147456
Offset of frame 5: 184320
Offset of frame 6: 221184
Offset of frame 7: 258048
error in ioctl VIDIOCMCAPTURE: Invalid argumenterror in ioctl
VIDIOCMCAPTURE: Device or resource busy - (h)ascii size is 80x40
using TEXT mode dumping to file hasciicam.asc

error in ioctl VIDIOCSYNC: : Device or resource busy
error in ioctl VIDIOCSYNC: : Device or resource busy

^Cinterrupt caught, exiting.
cya!
-----------------------------------------------------------------------------------------


Anyone has some idea???
Thank you for help!

-- 
Denis
