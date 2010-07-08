Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63676 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab0GHB4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 21:56:12 -0400
Received: by iwn7 with SMTP id 7so350883iwn.19
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 18:56:11 -0700 (PDT)
Message-ID: <4C353039.4030202@gmail.com>
Date: Wed, 07 Jul 2010 21:56:09 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently purchased ($20 special deal from newegg; the price has gone 
back up) the following USB stick that captures composite video and 
S-video (no TV tuner):

KWORLD DVD Maker USB 2.0 (VS-USB2800)

It seemed likely to be supported by the em28xx driver, and I'm pleased 
to report that, in fact, it is!

I actually thought for a while that it might not be supported, because 
it wasn't obvious that I needed to set the appropriate V4L settings, 
which weren't defaulted to the ones I need (NTSC, composite video 
input), or even which program I should start testing with. So it looks 
like I should make sure that the documentation on linuxtv.org gets improved.

My first successful test occurred with MPlayer:

mplayer tv:// -tv device=/dev/video1:input=1:normid=0

(my webcam is /dev/video0, so the USB stick gets /dev/video1)

I'm wondering about firmware, though, because I notice that the Windows 
drivers include a firmware file (merlinFW.rom, 16382 bytes, md5sum 
647d818c6fc82f385ebfbbd4fb2def6d), and the video looks slightly cleaner 
in Windows-- this might be accomplished with a software filter, but I 
thought it might be possible that it's being done by firmware.

Does the em28xx driver load a firmware?

Also, any firmware that gets loaded only persists until the device is 
unplugged, right? And so my prior successful test on Windows has nothing 
to do with my later success on Linux... just want to be sure about that. 
I also tried testing with Windows in Virtualbox, but had no luck-- does 
anyone know if this should be possible? (I can provide more info about 
my virtualbox testing if anyone's interested.)

Finally, lsusb output:

Bus 002 Device 004: ID eb1a:2860 eMPIA Technology, Inc.
(let me know if you want the verbose output)

And dmesg output:

usb 2-1.2: new high speed USB device using ehci_hcd and address 4
usb 2-1.2: configuration #1 chosen from 1 choice
em28xx: New device @ 480 Mbps (eb1a:2860, interface 0, class 0)
em28xx #0: chip ID is em2860
em28xx #0: board has no eeprom
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
em28xx #0: Board detected as EM2860/SAA711X Reference Design
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/input/input10
saa7115 8-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: Config register raw data: 0x00
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as /dev/video1
em28xx #0: V4L2 VBI device registered as /dev/vbi0
usbcore: registered new interface driver em28xx
em28xx driver loaded

I guess the part about the snapshot button means that I can use the push 
button on the USB stick to trigger stuff if I want (yay!), but I have no 
idea how to make that actually happen.

I'll be happy to provide more info if needed. I really appreciate the 
great work that's been done on the V4L drivers!

Ivan
