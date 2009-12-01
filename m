Return-path: <linux-media-owner@vger.kernel.org>
Received: from legolas.alcom.aland.fi ([194.112.1.132]:37988 "EHLO
	legolas.alcom.aland.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZLAVeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 16:34:10 -0500
Received: from aragon.alcom.aland.fi (aragon [194.112.0.1])
	by legolas.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id nB1JTOWa006884
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 21:29:24 +0200
Received: from [10.0.0.2] (82-199-168-58.bredband.aland.net [82.199.168.58])
	(authenticated bits=0)
	by aragon.alcom.aland.fi (8.12.11.20060308/8.12.11) with ESMTP id nB1JTMt9020905
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 21:29:22 +0200
Subject: af9015: tuner id:179 not supported, please report!
From: Jan Sundman <jan.sundman@aland.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 21:29:16 +0200
Message-ID: <1259695756.5239.2.camel@desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I just received a usb DVB-T card and have been trying to get it to work
under Ubuntu 9.10, but to no avail. dmesg shows the following when
plugging in the card:

[   35.280024] usb 2-1: new high speed USB device using ehci_hcd and
address 4
[   35.435978] usb 2-1: configuration #1 chosen from 1 choice
[   35.450176] af9015: tuner id:179 not supported, please report!
[   35.452891] Afatech DVB-T 2: Fixing fullspeed to highspeed interval:
10 -> 7
[   35.453097] input: Afatech DVB-T 2
as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input8
[   35.453141] generic-usb 0003:15A4:9016.0005: input,hidraw3: USB HID
v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:13.2-1/input1

lsusb shows:
Bus 002 Device 005: ID 15a4:9016  

and finally lsmod | grep dvb
dvb_usb_af9015         37152  0 
dvb_usb                22892  1 dvb_usb_af9015
dvb_core              109716  1 dvb_usb

While googling for an answer to my troubles I came across
http://ubuntuforums.org/showthread.php?t=606487&page=5 which hints that
the card may use the TDA18218HK tuner chip which does not seem to be
supported currently.

Does anyone have any experience regarding this chip and know what to do
to get it working.

Best regards,

//Jan


