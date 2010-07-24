Return-path: <linux-media-owner@vger.kernel.org>
Received: from hamlet.nurpoint.com ([212.239.26.6]:50961 "EHLO
	hamlet.nurpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0GYADW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 20:03:22 -0400
Received: from localhost ([127.0.0.1] helo=www.hawai.it)
	by hamlet.nurpoint.com with esmtpa (Exim 4.69)
	(envelope-from <s.danzi@hawai.it>)
	id 1Ocnp2-0003Na-J9
	for linux-media@vger.kernel.org; Sun, 25 Jul 2010 01:08:00 +0200
MIME-Version: 1.0
Date: Sun, 25 Jul 2010 01:08:00 +0200
From: <s.danzi@hawai.it>
To: <linux-media@vger.kernel.org>
Subject: saa7134 and SKY7104 CCTV Card
Message-ID: <4f65f749cf5027b7f77d908df49bcc1c@hawai.it>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!!
I'm trying to use SKY7104 CCTV (4 channel video capture card).
Kernel autoload module saa7134 but flag it as unknown,register two
video devices but it seems not work.
Someone could help me to patch saa7134 driver?

windows drivere are availabe here:
http://www.cn-dvr.com/products/enproducts78.html#1

Card has 4 bnc video inputs, 1 rca video output, 10 GPIO.
All signatures on chips was removed....

One chip is near vido output and I think it is video buffer.
Another chip is near saa7134 and I think it an i2c eeprom.
A quartz of 24.576Mhz is connected to saa7134.

There are a DIP chip (It could be a microchip pic) with a
11.0592 quartz connected to saa7134 and to a relais with two
outputs marked as "RESET". It could be something like a wachdog
to connect to motherboard reset switch.

I can check exactly where is connected each saa7134 pin.

lspci -v
00:01.0 Multimedia controller: Philips Semiconductors SAA7130 Video
Broadcast Decoder (rev 01)
	Subsystem: Philips Semiconductors Device 0000
	Flags: bus master, medium devsel, latency 64, IRQ 16
	Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: saa7134
	Kernel modules: saa7134

lspci -vn
00:01.0 0480: 1131:7130 (rev 01)
	Subsystem: 1131:0000
	Flags: bus master, medium devsel, latency 64, IRQ 16
	Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1
	Kernel driver in use: saa7134
	Kernel modules: saa7134


dmesg
[75996.656618] saa7130/34: v4l2 driver version 0.2.15 loaded
[75996.656840] saa7130[0]: found at 0000:00:01.0, rev: 1, irq: 16,
latency: 64, mmio: 0xfebffc00
[75996.656857] saa7134: <rant>
[75996.656860] saa7134:  Congratulations!  Your TV card vendor saved a few
[75996.656864] saa7134:  cents for a eeprom, thus your pci board has no
[75996.656867] saa7134:  subsystem ID and I can't identify it
automatically
[75996.656869] saa7134: </rant>
 .....supported card list.....
[75996.658556] saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
[card=0,autodetected]
[75996.658719] saa7130[0]: board init: gpio is c0f00fc
[75996.658731] IRQ 16/saa7130[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[75996.764635] saa7130[0]: Huh, no eeprom present (err=-5)?
[75996.764646] i2c i2c-1: Invalid 7-bit address 0x7a
[75996.767086] saa7130[0]: registered device video0 [v4l2]
[75996.769042] saa7130[0]: registered device vbi0

 
