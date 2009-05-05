Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wow.synacor.com ([64.8.70.55]:47000 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZEEA0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 20:26:34 -0400
Received: from aqui.slotcar.prv ([172.16.1.3])
	by sordid.slotcar.chicago.il.us with esmtp (Exim 4.67)
	(envelope-from <johnr@wowway.com>)
	id 1M18NC-0007i8-SV
	for linux-media@vger.kernel.org; Mon, 04 May 2009 19:19:02 -0500
Message-ID: <49FF85F1.5080600@wowway.com>
Date: Mon, 04 May 2009 19:18:57 -0500
From: "John R." <johnr@wowway.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge 950Q Analog (Composite Input) Problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Actually, I am trying to use the analog composite input (not cable 
television) working.  Is this part of analog support?  Or is that for 
analog cable only?

When I hook a video source up to the composite RCA jack and "mplayer 
/dev/video" it presents the following:

MPlayer dev-SVN-r26753-4.1.2 (C) 2000-2008 MPlayer Team
CPU: Intel(R) Pentium(R) M processor 1.20GHz (Family: 6, Model: 13, 
Stepping: 8)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled for x86 CPU with extensions: MMX MMX2 SSE SSE2

Playing /dev/video.

It just sits there.  Typing "cat /dev/video" does not produce any output.

Linux aqui 2.6.29.2.  I am running hvr950q-analog-1bbabf78f9ef 
(downloaded a couple days ago).

 From log output everything seems good:

May  4 18:52:19 aqui usb 1-1: new high speed USB device using ehci_hcd 
and address 5
May  4 18:52:19 aqui usb 1-1: configuration #1 chosen from 1 choice
May  4 18:52:20 aqui Linux video capture interface: v2.00
May  4 18:52:20 aqui au0828 driver loaded
May  4 18:52:20 aqui au0828: i2c bus registered
May  4 18:52:20 aqui tveeprom 1-0050: Hauppauge model 72001, rev B3F0, 
serial# 6134581
May  4 18:52:20 aqui tveeprom 1-0050: MAC address is 00-0D-FE-5D-9B-35
May  4 18:52:20 aqui tveeprom 1-0050: tuner model is Xceive XC5000 (idx 
150, type 76)
May  4 18:52:20 aqui tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB 
Digital (eeprom 0x88)
May  4 18:52:20 aqui tveeprom 1-0050: audio processor is AU8522 (idx 44)
May  4 18:52:20 aqui tveeprom 1-0050: decoder processor is AU8522 (idx 42)
May  4 18:52:20 aqui tveeprom 1-0050: has no radio, has IR receiver, has 
no IR transmitter
May  4 18:52:20 aqui hauppauge_eeprom: hauppauge eeprom: model=72001
May  4 18:52:20 aqui au8522 1-0047: creating new instance
May  4 18:52:20 aqui au8522_decoder creating new instance...
May  4 18:52:20 aqui tuner 1-0061: chip found @ 0xc2 (au0828)
May  4 18:52:20 aqui xc5000 1-0061: creating new instance
May  4 18:52:20 aqui xc5000: Successfully identified at address 0x61
May  4 18:52:20 aqui xc5000: Firmware has not been loaded previously
May  4 18:52:20 aqui xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.1.fw)...
May  4 18:52:20 aqui i2c-adapter i2c-1: firmware: requesting 
dvb-fe-xc5000-1.1.fw
May  4 18:52:20 aqui xc5000: firmware read 12332 bytes.
May  4 18:52:20 aqui xc5000: firmware upload
May  4 18:52:31 aqui au8522 1-0047: attaching existing instance
May  4 18:52:31 aqui xc5000 1-0061: attaching existing instance
May  4 18:52:31 aqui xc5000: Successfully identified at address 0x61
May  4 18:52:31 aqui xc5000: Firmware has been loaded previously
May  4 18:52:31 aqui DVB: registering new adapter (au0828)
May  4 18:52:31 aqui DVB: registering adapter 0 frontend 0 (Auvitek 
AU8522 QAM/8VSB Frontend)...
May  4 18:52:31 aqui Registered device AU0828 [Hauppauge HVR950Q]
May  4 18:52:31 aqui usbcore: registered new interface driver au0828

Thanks,

John
