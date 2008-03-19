Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ihaywood@iinet.net.au>) id 1Jbuv2-0000V8-NM
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 10:49:17 +0100
From: Ian Haywood <ihaywood@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Wed, 19 Mar 2008 20:50:40 +1100
References: <47E060EB.5040207@t-online.de>
In-Reply-To: <47E060EB.5040207@t-online.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803192050.40863.ihaywood@iinet.net.au>
Subject: Re: [linux-dvb] [RFC] TDA8290 / TDA827X with LNA: testers wanted
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

On Wednesday 19 March 2008 11:40:11 Hartmut Hackmann wrote:

> KWORLD DVBT 210
I have a Tevion/KWorld 220RF. This seems to include the chips
you are referring to. Anyway, with your latest code on kernel 2.6.24.3:

[   66.794518] saa7133[0]: found at 0000:00:0a.0, rev: 208, irq: 19, latency: 32, mmio: 0xe60080
00
[   66.794592] saa7133[0]: subsystem: 10d4:0201, board: UNKNOWN/GENERIC [card=0,autodetected]
[   66.794667] saa7133[0]: board init: gpio is 100
[   66.974166] saa7133[0]: i2c eeprom 00: 12 14 00 10 06 83 fa ff f7 58 1a 8d e0 00 00 51
[   66.974899] saa7133[0]: i2c eeprom 10: d1 d4 b8 13 04 96 bc 8c c0 27 10 50 36 e7 d1 00
[   66.975627] saa7133[0]: i2c eeprom 20: 01 50 20 23 00 20 d1 7c 37 08 02 5b 2b 58 1b 5b
[   66.976356] saa7133[0]: i2c eeprom 30: e0 85 ff ff ff 87 ff 00 01 5e 00 20 00 01 00 71
[   66.977084] saa7133[0]: i2c eeprom 40: d1 8c b2 50 46 23 01 20 cb 50 10 20 d1 d4 b8 15
[   66.977812] saa7133[0]: i2c eeprom 50: 06 83 fa ff f7 58 1a 8d e0 00 00 41 81 02 78 d4
[   66.978548] saa7133[0]: i2c eeprom 60: b8 12 03 96 bc 79 ab cc 7f 50 26 87 c0 ff 00 87
[   66.979276] saa7133[0]: i2c eeprom 70: b8 9f c4 9f fc 8d c0 7f ff 50 46 5e 00 7f ff 20
[   66.980004] saa7133[0]: i2c eeprom 80: ab 50 a0 9f c4 9f fc 8d c0 80 00 50 44 5e 00 80
[   66.980731] saa7133[0]: i2c eeprom 90: 00 20 ab 50 10 3c ab d4 b8 15 04 83 fa ff fc 58
[   66.982020] saa7133[0]: i2c eeprom a0: 1a 8d e0 00 02 51 82 71 78 cc 05 52 56 5e 1a 3e
[   66.982750] saa7133[0]: i2c eeprom b0: 7f 86 b9 83 e8 f0 00 8c c0 7c fe 50 d3 d4 b8 13
[   66.983478] saa7133[0]: i2c eeprom c0: 04 77 60 96 bc 8c c0 01 f4 50 16 5b 20 d4 b8 12
[   66.984206] saa7133[0]: i2c eeprom d0: 00 c2 fd 80 bb 51 30 71 78 cc 05 50 d6 5e 1a 7d
[   66.984932] saa7133[0]: i2c eeprom e0: 00 86 b9 5e 1b fa 00 83 e8 f0 00 83 e9 f0 00 8c
[   66.985660] saa7133[0]: i2c eeprom f0: b9 50 76 50 10 20 ab d4 b8 12 00 c0 02 d4 bc 12
[   67.074658] saa7133[0]: registered device video0 [v4l2]
[   67.076845] saa7133[0]: registered device vbi0

The tda8290 module doesn't seem to get loaded at all (with stock kernel
code it does, but doesn't tune as I reported earlier)

Ian


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
