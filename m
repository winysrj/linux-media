Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44415 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1GQHQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 03:16:31 -0400
Received: by iyb12 with SMTP id 12so2272145iyb.19
        for <linux-media@vger.kernel.org>; Sun, 17 Jul 2011 00:16:30 -0700 (PDT)
Message-ID: <4E2334A4.7000408@gmail.com>
Date: Sun, 17 Jul 2011 14:14:44 -0500
From: Pupthai <pupthai@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx detection
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

is em2820 detected as em2860

 >lsusb

Bus 001 Device 004: ID eb1a:2820 eMPIA Technology, Inc.

 >dmesg | grep em28xx

usbcore: registered new interface driver em28xx
em28xx driver loaded
em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
em28xx #0: chip ID is em2820 (or em2710)
em28xx #0: board has no eeprom
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0:      V4L Mailing List <linux-media@vger.kernel.org>
em28xx #0: Board detected as EM2860/SAA711X Reference Design
em28xx #0: Identified as EM2860/SAA711X Reference Design (card=19)
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input1
em28xx #0: Config register raw data: 0x00
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video0

Nothing works with this device anymore and it used to work with 
application <motion> and <vlc>  still works fine in windows apps
and windows vlc sees a em2820

Thank you
