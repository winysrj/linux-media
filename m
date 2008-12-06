Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xweber.alex@googlemail.com>) id 1L94uA-0001ly-MZ
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 22:41:40 +0100
Received: by fg-out-1718.google.com with SMTP id e21so399486fga.25
	for <linux-dvb@linuxtv.org>; Sat, 06 Dec 2008 13:41:35 -0800 (PST)
Message-ID: <493AF18D.6010400@googlemail.com>
Date: Sat, 06 Dec 2008 22:41:33 +0100
From: Alexander Weber <xweber.alex@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <493AC65E.3010900@googlemail.com>
In-Reply-To: <493AC65E.3010900@googlemail.com>
Subject: Re: [linux-dvb] saa7134 with Avermedia M115S hybrid card
Reply-To: xweber.alex@googlemail.com
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

Hi again,

now i modified the saa7134 as described here:

http://www.spinics.net/lists/linux-dvb/msg27720.html


the output in loading modified saa7134 with card=138:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:08:04.0, rev: 209, irq: 22, latency: 64, mmio: 
0xfc006800
saa7133[0]: subsystem: 1461:e836, board: Avermedia M115 [card=138,insmod 
option]
saa7133[0]: board init: gpio is a400000
saa7133[0]: i2c eeprom 00: 61 14 36 e8 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 00 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 00 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: 0d ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
mt352_read_register: readreg error (reg=127, ret==-5)


Alex

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
