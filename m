Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:61992 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZGLLbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 07:31:01 -0400
Received: by fg-out-1718.google.com with SMTP id e21so499089fga.17
        for <linux-media@vger.kernel.org>; Sun, 12 Jul 2009 04:30:59 -0700 (PDT)
Date: Sun, 12 Jul 2009 13:30:57 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Report: Compro Videomate Vista T750F
From: Samuel Rakitnican <semirocket@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1250
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uwycxowt80yj81@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the card=139 (Compro Videomate T750)

DVB: Not working, not implemented
Analog: Not working
Audio In: ? (my T750F has additional connector ?)
Composite In: Working
S-Video In: Working
IR: Works with T300 codes and different keymap (needs to be implemented)
	(http://www.spinics.net/lists/linux-media/msg07705.html)


Analog TV and XCeive:

Although John Newbigins reported that Analog is working in Apr 25 2007  
with a patch. I did not try to implement this patch (by hand) because tree  
changed big from that date, so it seems that this can not be done. At  
least I can't.
(http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017449.html)

With stock Slackware 12.2 it's showing a single channel (although tuner  
does't work) that previously was selected in a windows application and  
restarted.
Thought I had to select in tvtime: Input configuration > Television  
standard > PAL (Default was NTSC). And then Restart with new settings to  
show up that channel. Otherwise it would still remain blue. XCeive is  
recognized at 0xc2

With new v4l-dvb tree channel is not showing up any more no mather what I  
do.
New v4l also recognizes XCeive at 0xc2:
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
xc2028 0-0061: creating new instance
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner


tvtime startup and shuting off:
(Complete dump: http://pastebin.com/f376a8272)
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id  
0000000000000000.
xc2028 1-0061: i2c output error: rc = -5 (should be 64)
xc2028 1-0061: -5 returned from send
xc2028 1-0061: Error -22 while loading base firmware
(and then shutting off tvtime gives a line)
xc2028 1-0061: Error on line 1141: -5



eeproms T750 and T750F (maybe needed for automatic IR keymap selection)

T750
saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 03 01 08 ff 00 89 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff 01 ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7133[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

T750F
saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff 01 c6 ff 05 ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff





