Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mail@aitorpazos.es>) id 1KceAa-0001Bo-Cq
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 12:40:34 +0200
From: Aitor <mail@aitorpazos.es>
To: linux-dvb@linuxtv.org
Date: Mon, 08 Sep 2008 12:39:36 +0200
Message-Id: <1220870377.16920.22.camel@Apidell>
Mime-Version: 1.0
Subject: [linux-dvb] Problem's making a PCMCIA DVB Card to work
Reply-To: mail@aitorpazos.es
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

Hello,
I have a PCMCIA DVB card with DVB-T, analog TV, FM Radio, S-Video and
Composite inputs. It was packed with a Targa Pc and the only brand or
model reference that is printed on it is "LR502 NTA".

This is what dmesg prints about card's model:
saa7133[0]: subsystem: 5168:0502, LifeView/Typhoon/Genius FlyDVB-T Duo
Cardbus [card=60,autodetected]

I've tried several firmwares, but I haven't been able to make it work. I
have the original windows driver (just in case they are useful in some
way).


I've attached two insert/extract cycles. During the first one the
firmware didn't load correctly (TDA10046LifeView)

If someone could help I would appreciate it very much. At least, to be
able to watch Composite input.

Thank you,
	Aitor

This is the complete dmesg:

Sep  8 10:10:02 Apidell kernel: [ 9724.228063] pccard: CardBus card
inserted into slot 0
Sep  8 10:10:03 Apidell kernel: [ 9725.667669] Linux video capture
interface: v2.00
Sep  8 10:10:03 Apidell kernel: [ 9725.786181] saa7130/34: v4l2 driver
version 0.2.14 loaded
Sep  8 10:10:03 Apidell kernel: [ 9725.787412] saa7134 0000:03:00.0:
enabling device (0000 -> 0002)
Sep  8 10:10:03 Apidell kernel: [ 9725.787433] saa7134 0000:03:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
Sep  8 10:10:03 Apidell kernel: [ 9725.787445] saa7133[0]: found at
0000:03:00.0, rev: 240, irq: 19, latency: 0, mmio: 0x54400000
Sep  8 10:10:03 Apidell kernel: [ 9725.787467] saa7133[0]: subsystem:
5168:0502, board: LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus
[card=60,autodetected]
Sep  8 10:10:03 Apidell kernel: [ 9725.787492] saa7133[0]: board init:
gpio is 210000
Sep  8 10:10:03 Apidell kernel: [ 9725.940056] saa7133[0]: i2c eeprom
00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep  8 10:10:03 Apidell kernel: [ 9725.940079] saa7133[0]: i2c eeprom
10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940099] saa7133[0]: i2c eeprom
20: 01 40 01 03 03 01 01 03 08 ff 01 e4 ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940117] saa7133[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940136] saa7133[0]: i2c eeprom
40: ff 24 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940158] saa7133[0]: i2c eeprom
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940176] saa7133[0]: i2c eeprom
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940195] saa7133[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940215] saa7133[0]: i2c eeprom
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940234] saa7133[0]: i2c eeprom
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940252] saa7133[0]: i2c eeprom
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940271] saa7133[0]: i2c eeprom
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940290] saa7133[0]: i2c eeprom
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940308] saa7133[0]: i2c eeprom
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940327] saa7133[0]: i2c eeprom
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9725.940346] saa7133[0]: i2c eeprom
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:03 Apidell kernel: [ 9726.112242] tuner' 0-004b: chip found
@ 0x96 (saa7133[0])
Sep  8 10:10:03 Apidell kernel: [ 9726.192062] tda829x 0-004b: setting
tuner address to 61
Sep  8 10:10:03 Apidell kernel: [ 9726.320111] tda829x 0-004b: type set
to tda8290+75
Sep  8 10:10:08 Apidell kernel: [ 9730.572751] saa7133[0]: registered
device video0 [v4l2]
Sep  8 10:10:08 Apidell kernel: [ 9730.573418] saa7133[0]: registered
device vbi0
Sep  8 10:10:08 Apidell kernel: [ 9730.574903] saa7133[0]: registered
device radio0
Sep  8 10:10:08 Apidell kernel: [ 9730.764262] saa7134 ALSA driver for
DMA sound loaded
Sep  8 10:10:08 Apidell kernel: [ 9730.764344] saa7133[0]/alsa:
saa7133[0] at 0x54400000 irq 19 registered as card -2
Sep  8 10:10:08 Apidell kernel: [ 9730.865206] DVB: registering new
adapter (saa7133[0])
Sep  8 10:10:08 Apidell kernel: [ 9730.865780] DVB: registering frontend
0 (Philips TDA10046H DVB-T)...
Sep  8 10:10:08 Apidell kernel: [ 9730.939763] tda1004x: setting up plls
for 48MHz sampling clock
Sep  8 10:10:08 Apidell kernel: [ 9731.173069] tda1004x: found firmware
revision ff -- invalid
Sep  8 10:10:08 Apidell kernel: [ 9731.173083] tda1004x: trying to boot
from eeprom
Sep  8 10:10:09 Apidell kernel: [ 9731.484475] tda1004x: found firmware
revision ff -- invalid
Sep  8 10:10:09 Apidell kernel: [ 9731.484489] tda1004x: waiting for
firmware upload...
Sep  8 10:10:09 Apidell kernel: [ 9731.484501] firmware: requesting
dvb-fe-tda10046.fw
Sep  8 10:10:09 Apidell kernel: [ 9731.576064] tda1004x: found firmware
revision 0 -- invalid
Sep  8 10:10:09 Apidell kernel: [ 9731.576074] tda1004x: firmware upload
failed
Sep  8 10:10:09 Apidell kernel: [ 9731.612218] tda827x_probe_version:
could not read from tuner at addr: 0xc0
Sep  8 10:10:10 Apidell pulseaudio[6614]: alsa-util.c: Device hw:1
doesn't support 44100 Hz, changed to 48000 Hz.
Sep  8 10:10:10 Apidell pulseaudio[6614]: alsa-util.c: Cannot find
fallback mixer control "Mic".
Sep  8 10:10:23 Apidell kernel: [ 9746.138987] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139005] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139041] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139049] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139076] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139083] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139111] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139118] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139145] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139152] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139179] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139186] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139213] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139220] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139249] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139257] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139283] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139291] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139317] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139325] saa7133[0]: dsp access
error
Sep  8 10:10:23 Apidell kernel: [ 9746.139387] saa7133[0]/irq: looping
-- clearing PE (parity error!) enable bit
Sep  8 10:10:23 Apidell kernel: [ 9746.139447] pccard: card ejected from
slot 0
Sep  8 10:10:27 Apidell kernel: [ 9749.920094] pccard: CardBus card
inserted into slot 0
Sep  8 10:10:27 Apidell kernel: [ 9749.920490] saa7134 0000:03:00.0:
enabling device (0000 -> 0002)
Sep  8 10:10:27 Apidell kernel: [ 9749.920507] saa7134 0000:03:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
Sep  8 10:10:27 Apidell kernel: [ 9749.920522] saa7133[0]: found at
0000:03:00.0, rev: 240, irq: 19, latency: 0, mmio: 0x54400000
Sep  8 10:10:27 Apidell kernel: [ 9749.920550] saa7133[0]: subsystem:
5168:0502, board: LifeView/Typhoon/Genius FlyDVB-T Duo Cardbus
[card=60,autodetected]
Sep  8 10:10:27 Apidell kernel: [ 9749.920580] saa7133[0]: board init:
gpio is 210000
Sep  8 10:10:27 Apidell kernel: [ 9750.064142] tuner' 0-004b: chip found
@ 0x96 (saa7133[0])
Sep  8 10:10:27 Apidell kernel: [ 9750.116058] saa7133[0]: i2c eeprom
00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep  8 10:10:27 Apidell kernel: [ 9750.116081] saa7133[0]: i2c eeprom
10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116101] saa7133[0]: i2c eeprom
20: 01 40 01 03 03 01 01 03 08 ff 01 e4 ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116119] saa7133[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116138] saa7133[0]: i2c eeprom
40: ff 24 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116157] saa7133[0]: i2c eeprom
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116175] saa7133[0]: i2c eeprom
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116194] saa7133[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116213] saa7133[0]: i2c eeprom
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116232] saa7133[0]: i2c eeprom
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116250] saa7133[0]: i2c eeprom
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116270] saa7133[0]: i2c eeprom
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116289] saa7133[0]: i2c eeprom
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116308] saa7133[0]: i2c eeprom
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116329] saa7133[0]: i2c eeprom
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.116348] saa7133[0]: i2c eeprom
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep  8 10:10:27 Apidell kernel: [ 9750.216088] tda829x 0-004b: setting
tuner address to 61
Sep  8 10:10:27 Apidell kernel: [ 9750.280083] tda829x 0-004b: type set
to tda8290+75
Sep  8 10:10:32 Apidell kernel: [ 9754.947139] saa7133[0]: registered
device video0 [v4l2]
Sep  8 10:10:32 Apidell kernel: [ 9754.947984] saa7133[0]: registered
device vbi0
Sep  8 10:10:32 Apidell kernel: [ 9754.948466] saa7133[0]: registered
device radio0
Sep  8 10:10:32 Apidell kernel: [ 9754.957857] DVB: registering new
adapter (saa7133[0])
Sep  8 10:10:32 Apidell kernel: [ 9754.959424] DVB: registering frontend
0 (Philips TDA10046H DVB-T)...
Sep  8 10:10:32 Apidell kernel: [ 9755.033064] tda1004x: setting up plls
for 48MHz sampling clock
Sep  8 10:10:34 Apidell kernel: [ 9757.320094] tda1004x: found firmware
revision 0 -- invalid
Sep  8 10:10:34 Apidell kernel: [ 9757.320109] tda1004x: trying to boot
from eeprom
Sep  8 10:10:37 Apidell kernel: [ 9759.692070] tda1004x: found firmware
revision 0 -- invalid
Sep  8 10:10:37 Apidell kernel: [ 9759.692084] tda1004x: waiting for
firmware upload...
Sep  8 10:10:37 Apidell kernel: [ 9759.692093] firmware: requesting
dvb-fe-tda10046.fw
Sep  8 10:10:49 Apidell kernel: [ 9772.404085] tda1004x: found firmware
revision 29 -- ok
Sep  8 10:10:50 Apidell kernel: [ 9772.692241] tda827x_probe_version:
could not read from tuner at addr: 0xc0
Sep  8 10:10:50 Apidell kernel: [ 9772.692991] saa7133[0]/alsa:
saa7133[0] at 0x54400000 irq 19 registered as card -2
Sep  8 10:10:50 Apidell pulseaudio[6614]: alsa-util.c: Device hw:1
doesn't support 44100 Hz, changed to 48000 Hz.
Sep  8 10:10:50 Apidell pulseaudio[6614]: alsa-util.c: Cannot find
fallback mixer control "Mic".


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
