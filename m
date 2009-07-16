Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sammi@villingaholt.nu>) id 1MRaZQ-0000bR-76
	for linux-dvb@linuxtv.org; Fri, 17 Jul 2009 01:41:01 +0200
Received: by ewy8 with SMTP id 8so532966ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 16 Jul 2009 16:40:24 -0700 (PDT)
Message-Id: <623C8383-6282-43FC-88C0-13E9F0060445@villingaholt.nu>
From: =?ISO-8859-1?Q?Sam=FAel_J=F3n_Gunnarsson?= <sammi@villingaholt.nu>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Thu, 16 Jul 2009 23:40:20 +0000
Cc: =?ISO-8859-1?Q?Sam=FAel_J=F3n_Gunnarsson?= <sammi@villingaholt.nu>
Subject: [linux-dvb] Gigabyte GT-P8000 dvb-t / analog / fm radio - pci
Reply-To: linux-media@vger.kernel.org
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

Hi all,

I also have this kind of tv tuner card and I have sent a little  
inquiry through gigabyte global support site asking for additional  
details.

I took down the details on my card (REV 3.01) and it was as follows:

IC's on the board seen without my glasses ;-)
NXP
TDA10048HN
Q722GZP		05
2PG07472
http://www.datasheetpro.com/897655_view_TDA10048HN_datasheet.html

NXP
SAA7131E/03/G
CK3827		03
SI1503.1
TSG08012
http://www.datasheetpro.com/1583522_view_SAA7131E_datasheet.html

Here is an output from dmesg on how the saa7134 was detected with out  
parameters:

[   10.786721] saa7130/34: v4l2 driver version 0.2.14 loaded
[   10.786843] saa7134 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) - 
 > IRQ 18
[   10.786915] saa7133[0]: found at 0000:00:0a.0, rev: 209, irq: 18,  
latency: 32, mmio: 0xfa041000
[   10.786994] saa7133[0]: subsystem: 1458:9004, board: UNKNOWN/ 
GENERIC [card=0,autodetected]
[   10.787173] saa7133[0]: board init: gpio is 0
[   10.960016] saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43  
43 a9 1c 55 d2 b2 92
[   10.960846] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff  
ff ff ff ff ff ff ff
[   10.961671] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08  
ff 00 b3 ff ff ff ff
[   10.962496] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.963320] saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5  
15 0e 00 ff ff ff ff
[   10.964239] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.965063] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.965887] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.966711] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.967535] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.968359] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.969184] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.970015] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.970840] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.971663] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.972487] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[   10.973771] saa7133[0]: registered device video0 [v4l2]
[   10.973856] saa7133[0]: registered device vbi0

Here is an output from dmesg on how the saa7134 was detected with  
parameters: modprobe -v saa7134 card=81 i2c_scan=1

[ 3021.884358] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 3021.884408] saa7133[0]: found at 0000:00:0a.0, rev: 209, irq: 18,  
latency: 32, mmio: 0xfa041000
[ 3021.884416] saa7133[0]: subsystem: 1458:9004, board: Philips Tiger  
reference design [card=81,insmod option]
[ 3021.884466] saa7133[0]: board init: gpio is 0
[ 3022.074301] saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43  
43 a9 1c 55 d2 b2 92
[ 3022.074311] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074320] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08  
ff 00 b3 ff ff ff ff
[ 3022.074327] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074335] saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5  
15 0e 00 ff ff ff ff
[ 3022.074342] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074349] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074357] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074364] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074371] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074379] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074386] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074394] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074401] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074408] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.074416] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[ 3022.100102] saa7133[0]: i2c scan: found device @ 0x96  [???]
[ 3022.120042] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[ 3022.260159] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[ 3022.450047] tda829x 1-004b: setting tuner address to 60
[ 3022.534378] tda18271 1-0060: creating new instance
[ 3022.620047] TDA18271HD/C1 detected @ 1-0060
[ 3027.650038] tda829x 1-004b: type set to tda8290+18271
[ 3038.470142] saa7133[0]: registered device video0 [v4l2]
[ 3038.470170] saa7133[0]: registered device vbi0
[ 3038.470202] saa7133[0]: registered device radio0
[ 3038.802228] dvb_init() allocating 1 frontend
[ 3039.120573] tda10046: chip is not answering. Giving up.


As far as I can see the card should be using the TDA10048 instead of  
TDA10046 which is used when modprobing with card=81. The reason that  
i'm stating that is that the card does include the TDA10048HN chip.

Is there any other card options that I should be using or some  
particular source-code i should be looking into modifying ?

Regards,
Sammi

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
