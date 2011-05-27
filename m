Return-path: <mchehab@pedra>
Received: from nm3.bullet.mail.ac4.yahoo.com ([98.139.52.200]:46393 "HELO
	nm3.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754332Ab1E0MUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:20:46 -0400
Message-ID: <214556.93070.qm@web33205.mail.mud.yahoo.com>
Date: Fri, 27 May 2011 05:20:45 -0700 (PDT)
From: Moacyr Prado <mwprado@yahoo.com>
Subject: Brazilian HDTV device
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, I have a board with empia chipset. The em28xx driver not load, 
because the device ID is not listed on source(cards.c, I guess). 

Following bellow 
have some infos from board:
lsusb:
Bus 001 Device 004: ID 1b80:e755 Afatech

Opening the device, shows this ic:

empia em2888 d351c-195 727-00ag (em28xx)
nxp saa7136e/1/g SI5296.1 22 ZSD08411
NXP TDA 18271??C2 HDC2? (tda18271)
F JAPAN mb86a20s 0937 M01 E1 (mb86a20s)

but... dmesg shows:

[18373.454136] usb 6-1: USB disconnect, address 2
[18376.744074] usb 2-1: new high speed USB device using ehci_hcd and address 9
[18376.860283] usb 2-1: New USB device found, idVendor=1b80, idProduct=e755
[18376.860293] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[18376.860300] usb 2-1: Product: USB 2885 Device
[18376.860306] usb 2-1: SerialNumber: 1


Could The em28xx module (writing some code for me)handle this device?

Thanks,
Moa
