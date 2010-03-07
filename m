Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0CGIdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 03:33:08 -0500
Received: by pvb32 with SMTP id 32so1148186pvb.19
        for <linux-media@vger.kernel.org>; Sun, 07 Mar 2010 00:33:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com>
References: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com>
Date: Sun, 7 Mar 2010 19:33:06 +1100
Message-ID: <38f022bc1003070033u79959abby65bade561ba4c298@mail.gmail.com>
Subject: Any success with MSI TV Anywhere A/D V1.1?
From: Robin Rainton <robin@rainton.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi List,

Ages ago I wrote about trying to get a MSI TV Anywhere A/D V1.1 to
work (in my MythBackend, but that part isn't important). Doing a quick
search notice this was over 2 years ago! The original thread on the
archives is here:

http://www.mail-archive.com/linux-dvb@linuxtv.org/msg28514.html

Anyhow, at the time I gave up as it just wouldn't play. As some time
has passed and was messing around with hardware decided to pull out
the card and give it another go. It looks promising still, but still
doesn't work :(

Has anyone managed to get this card working in the mean time, or
should I give up for sure this time and bin it? :(

Cheers,

Robin

P.S. Some info to help out... dmesg gives this on boot:

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 255,
mmio: 0xf37ff000
saa7133[0]: subsystem: 1462:8625, board: MSI TV@nywhere A/D v1.1
[card=135,autodetected]
saa7133[0]: board init: gpio is 100
IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: 62 14 25 86 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c-adapter i2c-1: Invalid 7-bit address 0x7a
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda829x 1-004b: setting tuner address to 61
usbcore: registered new interface driver snd-usb-audio
tda829x 1-004b: type set to tda8290+75a
saa7133[0]: dsp access error
saa7133[0]: registered device video1 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock

When one tries to use the device this sort of thing happens:

tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 33 -- invalid
tda1004x: trying to boot from eeprom
tda1004x: found firmware revision 33 -- invalid
tda1004x: waiting for firmware upload...
saa7134 0000:07:00.0: firmware: requesting dvb-fe-tda10046.fw
tda1004x: found firmware revision 33 -- invalid
tda1004x: firmware upload failed
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision ea -- invalid
tda1004x: trying to boot from eeprom
tda1004x: found firmware revision ea -- invalid
tda1004x: waiting for firmware upload...
saa7134 0000:07:00.0: firmware: requesting dvb-fe-tda10046.fw
tda1004x: Error during firmware upload
tda1004x: found firmware revision ea -- invalid
tda1004x: firmware upload failed
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
tda827xa_set_params: could not write to tuner at addr: 0xc2
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
saa7133[0]/dvb: could not access tda8290 I2C gate
tda827xa_set_params: could not write to tuner at addr: 0xc2

Oddly, the version of the firmware it reports seems to change even
though the file does not change.

That said, I have tried two different versions of firmware placed in
'/lib/firmware'. One is 24478 bytes, the other is 24602 bytes. Neither
seem to work. This is very sad :(
