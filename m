Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:19850 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0BKJCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 04:02:13 -0500
Received: by fg-out-1718.google.com with SMTP id e12so190996fga.1
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2010 01:02:11 -0800 (PST)
Message-ID: <4B73C792.3060907@gmail.com>
Date: Thu, 11 Feb 2010 10:02:10 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: royale@zerezo.com
Subject: zr364xx: Aiptek DV8800 (neo): 08ca:2062: Fails on subsequent zr364xx_open()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Linux 2.6.30+32.x

Great there's a driver but seems to be untested/stub for this device:

usb 1-2: new high speed USB device using ehci_hcd and address 9
usb 1-2: New USB device found, idVendor=08ca, idProduct=2062
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: DV 8800
usb 1-2: Manufacturer: AIPTEK
usb 1-2: configuration #1 chosen from 1 choice
zr364xx probing...
zr364xx 1-2:1.0: Zoran 364xx compatible webcam plugged
zr364xx 1-2:1.0: model 08ca:2062 detected
usb 1-2: 320x240 mode selected
zr364xx dev: ffff88001eb62000, udev ffff88001e84c000 interface ffff88001ea35400
zr364xx num endpoints 3
zr364xx board init: ffff88001eb62000
zr364xx valloc ffff88001eb62028, idx 0, pdata ffffc900039d9000
zr364xx zr364xx_start_readpipe: start pipe IN x81
zr364xx submitting URB ffff88001eafccc0
zr364xx : board initialized
usb 1-2: Zoran 364xx controlling video device 3
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
zr364xx zr364xx_release
zr364xx zr364xx_open
usb 1-2: Failed sending control message, error -110.
usb 1-2: error during open sequence: 6
zr364xx zr364xx_open: -110
usb 1-2: USB disconnect, address 9
zr364xx read_pipe_completion, err shutdown
zr364xx 1-2:1.0: Zoran 364xx webcam unplugged
zr364xx stop read pipe
zr364xx vfree ffffc900039d9000

Same with mode=2 like the cam is configured (VGA+QVGA available in settings).

I'll sniff out the cmd sequences on an old win xp32 installation, no x64/vista/7 drivers found, 
or do You see the failure reason already?

Looks like the device does not like to be fed with the (full) init METHOD2 on every open()...
Since the VIDIOC_QUERYCAP worked it should not be the wrong METHOD.

y
tom

