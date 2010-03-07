Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <robin@rainton.com>) id 1NoBfq-00018q-It
	for linux-dvb@linuxtv.org; Sun, 07 Mar 2010 09:17:24 +0100
Received: from mail-pw0-f54.google.com ([209.85.160.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NoBfp-0002mr-JZ; Sun, 07 Mar 2010 09:17:18 +0100
Received: by pwj1 with SMTP id 1so3343894pwj.41
	for <linux-dvb@linuxtv.org>; Sun, 07 Mar 2010 00:17:14 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 7 Mar 2010 19:17:14 +1100
Message-ID: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com>
From: Robin Rainton <robin@rainton.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Any success with MSI TV Anywhere A/D V1.1?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
