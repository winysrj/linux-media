Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62526 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZKQVKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 16:10:41 -0500
Received: by yxe17 with SMTP id 17so444245yxe.33
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 13:10:47 -0800 (PST)
MIME-Version: 1.0
From: Rutger Nijlunsing <rutger.nijlunsing@gmail.com>
Date: Tue, 17 Nov 2009 22:10:27 +0100
Message-ID: <55e8f4c10911171310x3969d848l3e209c175585ace4@mail.gmail.com>
Subject: em28xx not detected: "Please send an email with this log to
	linux-media@vger.kernel.org"
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got a MSI VOX USB2.0 Video grabber (analog TV in, USB framegrabber out)
which is partially detected with Linux 2.6.31-11-generic (Ubuntu version).
The logs suggest that I E-mail the output of the logs to here, so
that's what I do.

The dmesg log says:
[ 6672.753915] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[ 6672.754323] em28xx #0: chip ID is em2820 (or em2710)
[ 6672.844662] em28xx #0: board has no eeprom
[ 6672.856403] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[ 6672.871904] em28xx #0: found i2c device @ 0x42 [???]
[ 6672.878901] em28xx #0: found i2c device @ 0x66 [???]
[ 6672.879273] em28xx #0: found i2c device @ 0x68 [???]
[ 6672.885150] em28xx #0: found i2c device @ 0x86 [tda9887]
[ 6672.896149] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[ 6672.896523] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[ 6672.907900] em28xx #0: Your board has no unique USB ID and thus
need a hint to be detected.
[ 6672.907906] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[ 6672.907908] em28xx #0: Please send an email with this log to:
[ 6672.907911] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[ 6672.907914] em28xx #0: Board eeprom hash is 0x00000000
[ 6672.907916] em28xx #0: Board i2c devicelist hash is 0x742400f0

When adding the 'card=5' option, the log changes to:
[10013.346671] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
[10013.347112] em28xx #0: chip ID is em2820 (or em2710)
[10013.449303] em28xx #0: board has no eeprom
[10013.449985] em28xx #0: Identified as MSI VOX USB 2.0 (card=5)
[10013.848477] saa7115 1-0021: saa7114 found (1f7114d0e000000) @ 0x42
(em28xx #0)
[10016.177760] tuner 1-0043: chip found @ 0x86 (em28xx #0)
[10016.177869] tda9887 1-0043: creating new instance
[10016.177873] tda9887 1-0043: tda988[5/6/7] found
[10016.192029] All bytes are equal. It is not a TEA5767
[10016.192163] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
[10016.193010] tuner-simple 1-0060: creating new instance
[10016.193015] tuner-simple 1-0060: type set to 37 (LG PAL (newer TAPC series))
[10016.240382] em28xx #0: Config register raw data: 0x00
[10016.372077] em28xx #0: v4l2 driver version 0.1.2
[10016.836166] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[10016.848106] usbcore: registered new interface driver em28xx
[10016.848114] em28xx driver loaded

Now xawtv and mplayer do not seem to work:

"xawtv" hangs when changing input.

"mplayer tv://" gives
v4l2: current audio mode is : MONO
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl queue buffer failed: Cannot allocate memory
v4l2: 0 frames successfully processed, 0 frames dropped.

Any ideas?

Rutger.
