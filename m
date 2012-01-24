Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52038 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2AXQgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 11:36:54 -0500
Received: by werb13 with SMTP id b13so3101022wer.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 08:36:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC75eEi3a=vjRku3P2K4wx1KFj=JgZhccVgXzUPWuOwVoD0axA@mail.gmail.com>
References: <CAC75eEi3a=vjRku3P2K4wx1KFj=JgZhccVgXzUPWuOwVoD0axA@mail.gmail.com>
Date: Tue, 24 Jan 2012 11:36:53 -0500
Message-ID: <CAC75eEhnMdLiW=6sxd3V9c0_xOHBMz27DbcxG9eKKaeCBnzZvw@mail.gmail.com>
Subject: Compusa VC-211A no video
From: Mike Falciani <mike@falciani.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm having a tough time getting a Compusa "VC-211A" USB video grabber
working under Fedora 16 on a Dell E521.

[root@shellder ~]# uname -a
Linux shellder.falciani.com 3.1.9-1.fc16.i686 #1 SMP Fri Jan 13
17:14:41 UTC 2012 i686 i686 i386 GNU/Linux


Jan 22 15:15:44 shellder kernel: [59072.105044] usb 1-7: new high
speed USB device number 5 using ehci_hcd
Jan 22 15:15:44 shellder kernel: [59072.220074] usb 1-7: New USB
device found, idVendor=eb1a, idProduct=2820
Jan 22 15:15:44 shellder kernel: [59072.220081] usb 1-7: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Jan 22 15:15:44 shellder kernel: [59072.220656] em28xx: New device @
480 Mbps (eb1a:2820, interface 0, class 0)
Jan 22 15:15:44 shellder kernel: [59072.220815] em28xx #0: chip ID is
em2820 (or em2710)
Jan 22 15:15:44 shellder kernel: [59072.290926] em28xx #0: board has no eeprom
Jan 22 15:15:44 shellder kernel: [59072.337170] em28xx #0: found i2c
device @ 0x4a [saa7113h]
Jan 22 15:15:44 shellder kernel: [59072.370919] em28xx #0: Your board
has no unique USB ID.
Jan 22 15:15:44 shellder kernel: [59072.370924] em28xx #0: A hint were
successfully done, based on i2c devicelist hash.
Jan 22 15:15:44 shellder kernel: [59072.370929] em28xx #0: This method
is not 100% failproof.
Jan 22 15:15:44 shellder kernel: [59072.370934] em28xx #0: If the
board were missdetected, please email this log to:
Jan 22 15:15:44 shellder kernel: [59072.370938] em28xx #0:      V4L
Mailing List  <linux-media@vger.kernel.org>
Jan 22 15:15:44 shellder kernel: [59072.370943] em28xx #0: Board
detected as EM2860/SAA711X Reference Design
Jan 22 15:15:44 shellder kernel: [59072.434031] em28xx #0: Identified
as EM2860/SAA711X Reference Design (card=19)
Jan 22 15:15:44 shellder kernel: [59072.434037] em28xx #0: Registering
snapshot button...
Jan 22 15:15:44 shellder kernel: [59072.434165] input: em28xx snapshot
button as /devices/pci0000:00/0000:00:0b.1/usb1/1-7/input/input17
Jan 22 15:15:44 shellder kernel: [59072.701150] saa7115 6-0025:
saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
Jan 22 15:15:45 shellder kernel: [59073.146869] em28xx #0: Config
register raw data: 0x00
Jan 22 15:15:45 shellder kernel: [59073.173739] em28xx #0: v4l2 driver
version 0.1.3
Jan 22 15:15:45 shellder kernel: [59073.427419] em28xx #0: V4L2 video
device registered as video0
Jan 22 15:15:45 shellder mtp-probe: checking bus 1, device 5:
"/sys/devices/pci0000:00/0000:00:0b.1/usb1/1-7"
Jan 22 15:15:45 shellder mtp-probe: bus: 1, device: 5 was not an MTP device

UCView and VLC: No video to be captured

lsusb (at a later date)
Bus 001 Device 005: ID eb1a:2820 eMPIA Technology, Inc.

I've tried:
modprobe -r em28xx
modprobe em28xx card=74
Results: No video UCview


modprobe -r em28xx
modprobe em28xx card=5
Results: No video UCview

modprobe -r em28xx
modprobe em28xx card=1
Results: No video UCview

Any ideas?

I had great hope in the card=74 until I saw that it expected a EM2800
and this seems to be a EM2820.

Also, the device looks a lot like this but is marked differently
http://www.cooldrives.com/usb-video-vcr-camcorder-analog-video-svideo-adapter.html

Any idea on how to select Composite Video input?

Thanks
--
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Mike Falciani
http://nj.falciani.com
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
