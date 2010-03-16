Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:51915 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab0CPWQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 18:16:06 -0400
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
From: hermann pitton <hermann-pitton@arcor.de>
To: Alex Kasayev <alexkasayev@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B94CF9B.3060000@gmail.com>
References: <4B94CF9B.3060000@gmail.com>
Content-Type: text/plain
Date: Tue, 16 Mar 2010 23:12:43 +0100
Message-Id: <1268777563.5120.57.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Am Montag, den 08.03.2010, 12:21 +0200 schrieb Alex Kasayev:
> Team,
> 
> I would to inform you about my experience with Kworld
> DVB-T 210SE under Linux. It partially works only when I reboot
> computer from Win to Linux. If I power-on and boot Linux first -
> it not working at all and rebooting into win does not help - it not
> working under Win
> also until I power-off and load Win first. I Googled a lot and found
> that  there are
> exactly same problems with DVB-T cards from different vendors which using
> the TDA10046 demodulator (example is recent post from Robin Raiton for
> MSI TV - I got exactly same messages).
> I tried with card=81 and card=114. I have played with different modprobe
> options and found that probably cause of error
> is incorrect TDA10046 initialization - see  logs below (first is for
> power-on Linux boot and second is for reboot from Win).
> Please help me guys to get this card working. I am able to apply
> patches, re-build kernel and test changes.
> 
> Now some info:
> 
> Operating system: OpenSUSE 11.2 kernel 2.6.31.12
> Card: Kworld DVB-T 210SE
> Chips on the card: SAA7131E/03/G, 8275AC1, HC4052, KS007, TDA10046A,
> ATMLH806.
> Crystals: 32.1 MHz, 20 MHz, 16MHz
> 
> Logs and win driver's .inf attached.
> 
> Thanks,
> Alex.
> 

unfortunately the problem with these cards is known, but no good
solution for now.

Best description is from Hartmut and starts here.

http://www.spinics.net/lists/linux-dvb/msg26683.html

Your card was also never fully tested and validated and thus is not yet
in the driver, even it has it's own PCI subdevice ID.

>From your .inf we can see also a configuration difference.

Kworld DVBT 210 17de:7250

[3xHybridK.AddReg]
HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x21,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC2,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x96,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x10,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data5",0x00010001,0x03,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x32,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x15,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x06,0x00,0x00,0x00               
HKR, "I2C Devices", "Number of I2C Devices",0x00010001,1

Kworld DVBT 210SE 17de:7253

[3xHybridQ.AddReg]
HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x21,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC2,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x96,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x10,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data5",0x00010001,0x03,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x32,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x15,0x00,0x00,0x00               
HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x50,0x00,0x00,0x00               
HKR, "I2C Devices", "Number of I2C Devices",0x00010001,1

"Data8" differs and I don't know its meaning right now. In your eeprom
is that byte even 0x56 and not 0x50. Maybe it plays some role.
On triple cards we have the address of the DVB-S demod there.

Else, if a previously fully working card is broken, we can find the
patch causing it using mercurial bisect procedures. Does not take very
long.

Around November 2008 have at least been reports with normal log for a
missing firmware file in /lib/firmware and one guy
had DVB-t working in the UK, with some quality limitations, maybe caused
by frequency offsets they use there.

Try to check again. if there is really no second 8pin eeprom close to
the tda10046 for its firmware. Put firmware in /lib/firmware.
Disable early starting apps like myth backend.

If i2c to the tuner is already lost, only a cold boot will help for a
next try.

Eventually disable its initialization for analog mode in
saa7134-cards.c. Comment the card in that case statement.

Good Luck,

Hermann




> ---------------------------------------------------------------
> 
> Robbin's mail follows (I'm constantly get exactly the same messages) :
> 
> Hi List,
> 
> Ages ago I wrote about trying to get a MSI TV Anywhere A/D V1.1 to
> work (in my MythBackend, but that part isn't important). Doing a quick
> search notice this was over 2 years ago! The original thread on the
> archives is here:
> 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg28514.html
> 
> Anyhow, at the time I gave up as it just wouldn't play. As some time
> has passed and was messing around with hardware decided to pull out
> the card and give it another go. It looks promising still, but still
> doesn't work :(
> 
> Has anyone managed to get this card working in the mean time, or
> should I give up for sure this time and bin it? :(
> 
> Cheers,
> 
> Robin
> 
> P.S. Some info to help out... dmesg gives this on boot:
> 
> saa7130/34: v4l2 driver version 0.2.15 loaded
> saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 255,
> mmio: 0xf37ff000
> saa7133[0]: subsystem: 1462:8625, board: MSI TV@nywhere A/D v1.1
> [card=135,autodetected]
> saa7133[0]: board init: gpio is 100
> IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]: i2c eeprom 00: 62 14 25 86 ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> i2c-adapter i2c-1: Invalid 7-bit address 0x7a
> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> tda829x 1-004b: setting tuner address to 61
> usbcore: registered new interface driver snd-usb-audio
> tda829x 1-004b: type set to tda8290+75a
> saa7133[0]: dsp access error
> saa7133[0]: registered device video1 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> 
> When one tries to use the device this sort of thing happens:
> 
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 20 -- ok
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 20 -- ok
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 33 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: found firmware revision 33 -- invalid
> tda1004x: waiting for firmware upload...
> saa7134 0000:07:00.0: firmware: requesting dvb-fe-tda10046.fw
> tda1004x: found firmware revision 33 -- invalid
> tda1004x: firmware upload failed
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision ea -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: found firmware revision ea -- invalid
> tda1004x: waiting for firmware upload...
> saa7134 0000:07:00.0: firmware: requesting dvb-fe-tda10046.fw
> tda1004x: Error during firmware upload
> tda1004x: found firmware revision ea -- invalid
> tda1004x: firmware upload failed
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> tda827xa_set_params: could not write to tuner at addr: 0xc2
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> saa7133[0]/dvb: could not access tda8290 I2C gate
> tda827xa_set_params: could not write to tuner at addr: 0xc2
> 
> 
> 
> 
> 
> 
> 
> 

