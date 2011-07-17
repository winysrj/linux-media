Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1GQIUm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 04:20:42 -0400
Message-ID: <4E229B52.9040403@redhat.com>
Date: Sun, 17 Jul 2011 05:20:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pupthai <pupthai@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx detection
References: <4E2334A4.7000408@gmail.com>
In-Reply-To: <4E2334A4.7000408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-07-2011 16:14, Pupthai escreveu:
> is em2820 detected as em2860
> 
>>lsusb
> 
> Bus 001 Device 004: ID eb1a:2820 eMPIA Technology, Inc.
> 
>>dmesg | grep em28xx
> 
> usbcore: registered new interface driver em28xx
> em28xx driver loaded
> em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
> em28xx #0: chip ID is em2820 (or em2710)
> em28xx #0: board has no eeprom
> em28xx #0: found i2c device @ 0x4a [saa7113h]
> em28xx #0: Your board has no unique USB ID.
> em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> em28xx #0: This method is not 100% failproof.
> em28xx #0: If the board were missdetected, please email this log to:
> em28xx #0:      V4L Mailing List <linux-media@vger.kernel.org>
> em28xx #0: Board detected as EM2860/SAA711X Reference Design
> em28xx #0: Identified as EM2860/SAA711X Reference Design (card=19)
> em28xx #0: Registering snapshot button...
> input: em28xx snapshot button as /devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input1
> em28xx #0: Config register raw data: 0x00
> em28xx #0: v4l2 driver version 0.1.2
> em28xx #0: V4L2 video device registered as video0
> 
> Nothing works with this device anymore and it used to work with application <motion> and <vlc>  still works fine in windows apps
> and windows vlc sees a em2820

Your device doesn't have an eeprom. So, there's no reliable way to identify
what board you have. Kernel can try to hint, but there will always be cases
where two different boards will match such hint. On such cases (like yours),
you'll need to modprobe em28xx with card= parameter.

If your device used to be supported by the in-kernel em28xx driver, all you
need is to add something like:
	options em28xx card=20

(well, replacing 20 by the correct card number from Documentation/video4linux/CARDLIST.em28xx)

If otherwise your board is not listed there, then you'll need to discover what are
the correct setups for it and send us a patch adding a new card number with your
configs.

Mauro
