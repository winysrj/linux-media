Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ml@punkrockworld.it>) id 1K912a-0006XB-2t
	for linux-dvb@linuxtv.org; Wed, 18 Jun 2008 19:01:53 +0200
Received: from [192.168.0.12] (37.244.170.61) by aa012msr.fastwebnet.it
	(8.0.013.5) id 483219C103CD8182 for linux-dvb@linuxtv.org;
	Wed, 18 Jun 2008 19:01:12 +0200
Message-ID: <48593F57.7090809@punkrockworld.it>
Date: Wed, 18 Jun 2008 19:01:11 +0200
From: Francesco <ml@punkrockworld.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48565075.6040400@iinet.net.au>	<200806161343.16372.eggert@hugsaser.is>	<4856FE3D.6040400@t-online.de>
	<4857CF64.8080201@punkrockworld.it> <48582245.2020407@t-online.de>
In-Reply-To: <48582245.2020407@t-online.de>
Subject: Re: [linux-dvb] unstable tda1004x firmware loading
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

Hartmut Hackmann ha scritto:
 > Hi, Francesco
 >
 > Francesco schrieb:
 >>> Looks like there currently are many people having problems. Allow
 >>>  me to give some background info:
 >>>
 >>> Something that is not in the datasheet: The tda10046
 >>> automatically tries to load the firmware from an eeprom at the
 >>> second I2C port. This does *not* need to be triggered by the
 >>> driver. The timeout seems to be very long. In the past, this
 >>> happened: If the driver tries to access the tuner while the
 >>> download is not finished, there is a collision on the I2C bus.
 >>> This can corrupt both, the firmware and the tuner initialization.
 >>>  In the case of the tda8275a, the result can be that it turns off
 >>>  its 16MHz reference output which is used for the tda10046 as
 >>> well. This blocks the i2c bus and the only way to recover is a
 >>> complete power cycle. This is why i made the driver try to get
 >>> the firmware as soon as possible. Otherwise it is not possible to
 >>>  access the tuner - at least on some boards.
 >>>
 >>> Few days ago, a user reported that the firmware download seems to
 >>>  be retriggered in some cases. This might occur if something
 >>> opens the dvb device while the download is not finished. If it is
 >>>  the case, we need to lock the download. Another dangerous thing
 >>> is the address mapping of the firmware eeprom: it is controlled
 >>> by a GPIO pin. If this pin changes while the download is running,
 >>>  we are lost.
 >>>
 >>> Best regards Hartmut
 >>
 >> I've found a little workaround (not a solution, but...) for this
 >> problem for my Asus7131H...
 >>
 >> Simply adding "saa7134-dvb" to /etc/modules, make a successful
 >> firmware loading on boot. (My system is an Ubuntu 7.10)
 >>
 >>
 > Could you post the relevant sections of the kernel log for both
 > cases, successful and unsuccessful firmware load? Please extract the
 >  entire board initialization. Also: do you run a client / server
 > based application (with early start of the server)?
 >
 > Hartmut
 >
 >


These are extract of boot log for "saa" and "tda" text... later I'll send
all system logs in both cases.


Relevant row for "tda" part seems is:
"[   54.297295] tda1004x: setting up plls for 48MHz sampling clock"
the second one, wich prevent on my opinion, to load firmware correctly.



tda / before:
[   35.412245] tda829x 0-004b: setting tuner address to 61
[   35.492199] tda829x 0-004b: type set to tda8290+75a
[   39.621806] tda1004x: setting up plls for 48MHz sampling clock
[   41.912490] tda1004x: found firmware revision 0 -- invalid
[   41.912495] tda1004x: trying to boot from eeprom
[   44.283116] tda1004x: found firmware revision 0 -- invalid
[   44.283122] tda1004x: waiting for firmware upload...
[   54.297295] tda1004x: setting up plls for 48MHz sampling clock
[   56.583964] tda1004x: found firmware revision 0 -- invalid
[   56.583968] tda1004x: trying to boot from eeprom
[   58.950592] tda1004x: found firmware revision 0 -- invalid
[   58.950597] tda1004x: waiting for firmware upload...
[   71.443661] tda1004x: found firmware revision 0 -- invalid
[   71.443665] tda1004x: firmware upload failed
[   73.543492] tda1004x: found firmware revision 80 -- invalid
[   73.543496] tda1004x: firmware upload failed

tda / after:
[   35.101428] tda829x 0-004b: setting tuner address to 61
[   35.185381] tda829x 0-004b: type set to tda8290+75a
[   39.295055] tda1004x: setting up plls for 48MHz sampling clock
[   41.581753] tda1004x: found firmware revision 0 -- invalid
[   41.581756] tda1004x: trying to boot from eeprom
[   43.948412] tda1004x: found firmware revision 0 -- invalid
[   43.948415] tda1004x: waiting for firmware upload...
[   56.405359] tda1004x: found firmware revision 20 -- ok
[   71.360886] tda1004x: setting up plls for 48MHz sampling clock
[   71.664713] tda1004x: found firmware revision 20 -- ok



saa / before:
[   34.948753] saa7130/34: v4l2 driver version 0.2.14 loaded
[   34.973691] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfdef800
[   34.973701] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
[   34.973707] saa7133[0]: board init: gpio is 0
[   34.973808] input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input5
[   35.124417] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   35.124426] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   35.124433] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
[   35.124440] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124448] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
[   35.124455] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124462] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124469] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124476] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124483] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124490] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124498] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124505] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124512] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124519] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.124526] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.324335] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   39.346316] saa7133[0]: registered device video0 [v4l2]
[   39.346442] saa7133[0]: registered device vbi0
[   39.346568] saa7133[0]: registered device radio0
[   39.424512] saa7134 ALSA driver for DMA sound loaded
[   39.425969] saa7133[0]/alsa: saa7133[0] at 0xcfdef800 irq 17 registered as card -2
[   39.549898] DVB: registering new adapter (saa7133[0])


saa / after:
[   34.525512] saa7130/34: v4l2 driver version 0.2.14 loaded
[   34.734591] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfdef800
[   34.734598] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
[   34.734608] saa7133[0]: board init: gpio is 0
[   34.734694] input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input5
[   34.885561] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   34.885575] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   34.885587] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
[   34.885599] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885611] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
[   34.885622] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885634] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885646] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885658] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885669] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885681] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885693] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885706] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885713] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885720] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   34.885727] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   35.013516] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   39.043450] saa7133[0]: registered device video0 [v4l2]
[   39.043466] saa7133[0]: registered device vbi0
[   39.043482] saa7133[0]: registered device radio0
[   39.043525] saa7133[0]: dsp access error
[   39.043526] saa7133[0]: dsp access error
[   39.117617] saa7134 ALSA driver for DMA sound loaded
[   39.117641] saa7133[0]/alsa: saa7133[0] at 0xcfdef800 irq 17 registered as card -2
[   39.215137] DVB: registering new adapter (saa7133[0])



Francesco Ferrario
- Chimera project -
- www.chimeratv.it -



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
