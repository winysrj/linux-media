Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53910 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZF2Vnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 17:43:35 -0400
Received: by bwz9 with SMTP id 9so3544299bwz.37
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2009 14:43:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 22:43:36 +0100
Message-ID: <9057c8440906291443y5fb2cbb7ke72a988737169ca4@mail.gmail.com>
Subject: Compro Videomate S350 - new version?
From: Richard Smith <theras@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I bought a Compro Videomate S350 DVB-S card a few weeks ago as it was
cheap and looked like it might work with Linux using Jan Louw's
patches.  However, my S350 seems to be slightly different - it uses a
SAA7135 chip so isn't correctly identified.  Changing the PCI Vendor
ID to 0x7133 in the S350 patch fixed this, but unfortunately this is
the same PCI Vendor / Device / subvendor / subdevice as the Compro
Videomate T750 - an entirely different, DVB-T board.  I'm not sure how
these should be told apart - maybe using eeprom content?
Anyway, once this was updated the card still didn't work.  I realised
there was no voltage on the RF input to power the LNB, so by trial and
error found a GPIO bit that appears to turn LNB voltage on and off.
Instead of 0x8000 used in Jan's patch, use 0xC000 for GPIO setup.
With this change the card appears to work, at least receiving DVB-S.
I haven't tested the IR remote control or analogue inputs.
I hope this info is of some use to somebody, and that it's considered
if the S350 support gets added to v4l-dvb tree.  I'm not sure if my
card is rare, or a sign of things to come.

Here is the kernel log after modifying the driver:

saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 5, latency: 64,
mmio: 0xfaafe800
saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate S350/300
[card=169,autodetected]
saa7133[0]: board init: gpio is 843f00
saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: 00 00 00 01 40 2a ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...

Regards,

Richard Smith.
