Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:43227 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3BRUxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Feb 2013 15:53:35 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so5774854lab.23
        for <linux-media@vger.kernel.org>; Mon, 18 Feb 2013 12:53:33 -0800 (PST)
Message-ID: <512294CA.3050401@gmail.com>
Date: Mon, 18 Feb 2013 21:53:30 +0100
From: Mr Goldcove <goldcove@gmail.com>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Wrongly identified easycap em28xx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Easy Cap DC-60++"
Wrongly identified as card 19 "EM2860/SAA711X Reference Design",
resulting in no audio.
Works perfectly when using card 64 "Easy Cap Capture DC-60"

**Interim solution**
load module (before inserting the EasyCap. I'm having trouble if the
module is loaded/unloaded with different cards...)
modprobe em28xx card=64
  or
add "options em28xx card=64" to /etc/modprobe.d/local.conf

**hw info**
Bus 002 Device 005: ID eb1a:2861 eMPIA Technology, Inc.

Chips:
Empia EM2860 P7JY8-011 201023-01AG
NXP SAA7113H
RMC ALC653 89G06K1 G909A

**logs**
[ 5567.367883] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0,
class 0)
[ 5567.367985] em28xx #0: chip ID is em2860
[ 5567.380645] IR MCE Keyboard/mouse protocol handler initialized
[ 5567.384202] lirc_dev: IR Remote Control driver registered, major 249
[ 5567.385468] IR LIRC bridge handler initialized
[ 5567.460386] em28xx #0: board has no eeprom
[ 5567.534612] em28xx #0: found i2c device @ 0x4a [saa7113h]
[ 5567.568303] em28xx #0: Your board has no unique USB ID.
[ 5567.568308] em28xx #0: A hint were successfully done, based on i2c
devicelist hash.
[ 5567.568312] em28xx #0: This method is not 100% failproof.
[ 5567.568314] em28xx #0: If the board were missdetected, please email
this log to:
[ 5567.568317] em28xx #0:     V4L Mailing List 
<linux-media@vger.kernel.org>
[ 5567.568321] em28xx #0: Board detected as EM2860/SAA711X Reference Design
[ 5567.647433] em28xx #0: Identified as EM2860/SAA711X Reference Design
(card=19)
[ 5567.647438] em28xx #0: Registering snapshot button...
[ 5567.647531] input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/input/input11
[ 5568.019310] saa7115 15-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[ 5568.789385] em28xx #0: Config register raw data: 0x10
[ 5568.813055] em28xx #0: AC97 vendor ID = 0x414c4761
[ 5568.825074] em28xx #0: AC97 features = 0x0000
[ 5568.825078] em28xx #0: Unknown AC97 audio processor detected!
[ 5569.284137] em28xx #0: v4l2 driver version 0.1.3
[ 5570.305831] em28xx #0: V4L2 video device registered as video1
[ 5570.305835] em28xx #0: V4L2 VBI device registered as vbi0
[ 5570.305862] em28xx audio device (eb1a:2861): interface 1, class 1
[ 5570.305877] em28xx audio device (eb1a:2861): interface 2, class 1
[ 5570.305906] usbcore: registered new interface driver em28xx
[ 5570.305909] em28xx driver loaded
[ 5570.392917] usbcore: registered new interface driver snd-usb-audio
[ 7903.785365] em28xx #0: vidioc_s_fmt_vid_cap queue busy
