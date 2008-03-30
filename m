Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2UGRwS7002955
	for <video4linux-list@redhat.com>; Sun, 30 Mar 2008 12:27:58 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2UGRh8x027266
	for <video4linux-list@redhat.com>; Sun, 30 Mar 2008 12:27:44 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Petteri Jokinen <pjokinen@gmail.com>
In-Reply-To: <47E3CBC2.2060706@kotinet.com>
References: <47E3CBC2.2060706@kotinet.com>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 18:27:25 +0200
Message-Id: <1206894445.3520.9.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Strange Asus MyCinema P7131 Hybrid remote behaviour
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Petteri,

Am Freitag, den 21.03.2008, 16:52 +0200 schrieb Petteri Jokinen:
> Hi
> I am having troubles with Asus MyCinema P7131 Hybrid's remote control 
> PC-39. P7131 is correctly detected and all required modules are loaded, 
> but when using PC-39, my computer recognizes it's key presses very 
> unreliably. Remote control works well with bundled PowerCinema in 
> Windows xp so this isn't hardware problem. Correct recognitions come 
> usually in small "bursts" which occur about two to three times in a 
> minute. At the end of this message is error log which contains two 
> "bursts" (first at 16:23:16 and second at 16:23:38). What could cause 
> this strange behaviour? Any thoughts are welcome.
> 
> Thanks in advance!
> Petteri

on my current card the IR receiver is broken, so I can't be of much help
concerning testing, but I assume it still works for others without
problems.

If it is not caused by low batteries, and the code is also well
protected against errors caused by using other remotes, it could be
something similar like Vincent already reported.
http://marc.info/?l=linux-video&m=116933904819990&w=2

At least those bursts from time to time look very suspicious.

Cheers,
Hermann


> uname -r:
> 2.6.24-gentoo-r3
> 
> dmesg after "modprobe saa7134":
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:00:0b.0, rev: 209, irq: 9, latency: 32, mmio: 
> 0xdb800000
> saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid 
> [card=112,autodetected]
> saa7133[0]: board init: gpio is 40000
> input: saa7134 IR (ASUSTeK P7131 Hybri as 
> /devices/pci0000:00/0000:00:0b.0/input/input7
> tuner 0-004b: chip found @ 0x96 (saa7133[0])
> tda8290 0-004b: setting tuner address to 61
> tuner 0-004b: type set to tda8290+75a
> tda8290 0-004b: setting tuner address to 61
> tuner 0-004b: type set to tda8290+75a
> saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 20 -- ok
> 
> errors with debug=1:
> 
> Mar 21 16:22:51 gentoo ir-common: ir_rc5_decode(4314c45) bad code
> Mar 21 16:22:51 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:51 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:22:51 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:22:51 gentoo ir-common: ir_rc5_decode(4514c51) bad code
> Mar 21 16:22:51 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:52 gentoo ir-common: ir_rc5_decode(250d451) bad code
> Mar 21 16:22:52 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:52 gentoo ir-common: ir_rc5_decode(4314c51) bad code
> Mar 21 16:22:52 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:52 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:22:52 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:52 gentoo ir-common: ir_rc5_decode(4315451) bad code
> Mar 21 16:22:52 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:52 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:22:52 gentoo ir-common: key released
> Mar 21 16:22:52 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:22:52 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:22:52 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:22:53 gentoo ir-common: ir_rc5_decode(4513451) bad code
> Mar 21 16:22:53 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:53 gentoo ir-common: key released
> Mar 21 16:22:53 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:22:53 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:22:53 gentoo ir-common: key released
> Mar 21 16:22:53 gentoo ir-common: ir_rc5_decode(4514c49) bad code
> Mar 21 16:22:53 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:53 gentoo ir-common: ir_rc5_decode(4513451) bad code
> Mar 21 16:22:53 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:53 gentoo ir-common: ir_rc5_decode(4315445) bad code
> Mar 21 16:22:53 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:54 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:22:54 gentoo ir-common: key released
> Mar 21 16:22:54 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:22:54 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:22:54 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:22:54 gentoo ir-common: key released
> Mar 21 16:22:54 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:22:54 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:22:54 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:22:54 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:22:54 gentoo ir-common: key released
> Mar 21 16:22:54 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:22:54 gentoo ir-common: ir_rc5_decode(448b449) bad code
> Mar 21 16:22:54 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:54 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:55 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:55 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:22:55 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:55 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:55 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:22:55 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:55 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:55 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:22:55 gentoo ir-common: ir_rc5_decode(4312c45) bad code
> Mar 21 16:22:55 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:56 gentoo ir-common: code=298d, rc5=4529491, start=2, 
> toggle=1, address=6, instr=d
> Mar 21 16:22:56 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:22:56 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:56 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:56 gentoo ir-common: code=21ad, rc5=4519429, start=2, 
> toggle=0, address=6, instr=2d
> Mar 21 16:22:56 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:56 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:57 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:22:57 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:57 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:57 gentoo ir-common: code=2888, rc5=8929891, start=2, 
> toggle=1, address=2, instr=8
> Mar 21 16:22:57 gentoo ir-common: code=25ad, rc5=4519461, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:22:57 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:22:57 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:57 gentoo ir-common: code=298d, rc5=4529491, start=2, 
> toggle=1, address=6, instr=d
> Mar 21 16:22:57 gentoo ir-common: ir_rc5_decode(4313449) bad code
> Mar 21 16:22:57 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:57 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:58 gentoo ir-common: code=29cc, rc5=8525491, start=2, 
> toggle=1, address=7, instr=c
> Mar 21 16:22:58 gentoo ir-common: ir_rc5_decode(4913451) bad code
> Mar 21 16:22:58 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:58 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:58 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:22:58 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:58 gentoo ir-common: code=298d, rc5=4529491, start=2, 
> toggle=1, address=6, instr=d
> Mar 21 16:22:58 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:22:58 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:22:59 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:22:59 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:22:59 gentoo ir-common: code=2d29, rc5=4912451, start=2, 
> toggle=1, address=14, instr=29
> Mar 21 16:22:59 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:22:59 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:00 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:00 gentoo ir-common: code=2188, rc5=8929489, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:00 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:23:00 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:00 gentoo ir-common: ir_rc5_decode(4513429) bad code
> Mar 21 16:23:00 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:00 gentoo ir-common: code=2d29, rc5=491a451, start=2, 
> toggle=1, address=14, instr=29
> Mar 21 16:23:01 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:01 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:01 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:01 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:01 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:01 gentoo ir-common: code=288c, rc5=8529891, start=2, 
> toggle=1, address=2, instr=c
> Mar 21 16:23:02 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:02 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:02 gentoo ir-common: code=25a9, rc5=4919461, start=2, 
> toggle=0, address=16, instr=29
> Mar 21 16:23:02 gentoo ir-common: code=2188, rc5=8929489, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:02 gentoo ir-common: code=2529, rc5=491a461, start=2, 
> toggle=0, address=14, instr=29
> Mar 21 16:23:02 gentoo ir-common: code=218d, rc5=4529489, start=2, 
> toggle=0, address=6, instr=d
> Mar 21 16:23:03 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:03 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:03 gentoo ir-common: ir_rc5_decode(250b429) bad code
> Mar 21 16:23:03 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:03 gentoo ir-common: code=29cc, rc5=8525491, start=2, 
> toggle=1, address=7, instr=c
> Mar 21 16:23:03 gentoo ir-common: ir_rc5_decode(430b425) bad code
> Mar 21 16:23:03 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:04 gentoo ir-common: ir_rc5_decode(430b429) bad code
> Mar 21 16:23:04 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:04 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:04 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:04 gentoo ir-common: code=2188, rc5=89294a1, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:04 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:04 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:04 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:05 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:05 gentoo ir-common: code=2529, rc5=491a461, start=2, 
> toggle=0, address=14, instr=29
> Mar 21 16:23:05 gentoo ir-common: code=20cc, rc5=8525889, start=2, 
> toggle=0, address=3, instr=c
> Mar 21 16:23:05 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:05 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:05 gentoo ir-common: code=2d29, rc5=491a451, start=2, 
> toggle=1, address=14, instr=29
> Mar 21 16:23:06 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:06 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:06 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:06 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:06 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:06 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:06 gentoo ir-common: code=2084, rc5=8629889, start=2, 
> toggle=0, address=2, instr=4
> Mar 21 16:23:07 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:07 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:07 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:07 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:07 gentoo ir-common: code=2188, rc5=89294a1, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:07 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:07 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:07 gentoo ir-common: ir_rc5_decode(250b431) bad code
> Mar 21 16:23:07 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:08 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:08 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:08 gentoo ir-common: code=2188, rc5=89294a1, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:08 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:08 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:08 gentoo ir-common: code=2cec, rc5=2515251, start=2, 
> toggle=1, address=13, instr=2c
> Mar 21 16:23:09 gentoo ir-common: ir_rc5_decode(4312c45) bad code
> Mar 21 16:23:09 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:09 gentoo ir-common: ir_rc5_decode(4313451) bad code
> Mar 21 16:23:09 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:09 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:09 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:09 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:09 gentoo ir-common: code=288c, rc5=8529891, start=2, 
> toggle=1, address=2, instr=c
> Mar 21 16:23:09 gentoo ir-common: code=2108, rc5=892a4a1, start=2, 
> toggle=0, address=4, instr=8
> Mar 21 16:23:10 gentoo ir-common: code=2988, rc5=8929491, start=2, 
> toggle=1, address=6, instr=8
> Mar 21 16:23:10 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:10 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:10 gentoo ir-common: code=2188, rc5=8929489, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:10 gentoo ir-common: ir_rc5_decode(4313449) bad code
> Mar 21 16:23:10 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:10 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:23:10 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:10 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:10 gentoo ir-common: code=24ed, rc5=4515249, start=2, 
> toggle=0, address=13, instr=2d
> Mar 21 16:23:11 gentoo ir-common: ir_rc5_decode(4315445) bad code
> Mar 21 16:23:11 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:11 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:11 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:11 gentoo ir-common: ir_rc5_decode(4313449) bad code
> Mar 21 16:23:11 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:11 gentoo ir-common: key released
> Mar 21 16:23:11 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:23:11 gentoo ir-common: ir_rc5_decode(450b431) bad code
> Mar 21 16:23:11 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:11 gentoo ir-common: code=218c, rc5=85294a1, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:12 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:12 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:12 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:12 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:12 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:12 gentoo ir-common: code=2108, rc5=892a4a1, start=2, 
> toggle=0, address=4, instr=8
> Mar 21 16:23:12 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:12 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:12 gentoo ir-common: code=210c, rc5=852a4a1, start=2, 
> toggle=0, address=4, instr=c
> Mar 21 16:23:12 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:13 gentoo ir-common: code=2dec, rc5=2515451, start=2, 
> toggle=1, address=17, instr=2c
> Mar 21 16:23:13 gentoo ir-common: instruction 2c, toggle 1
> Mar 21 16:23:13 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:13 gentoo ir-common: ir_rc5_decode(4314c51) bad code
> Mar 21 16:23:13 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:13 gentoo ir-common: key released
> Mar 21 16:23:13 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:13 gentoo ir-common: code=2dec, rc5=2515451, start=2, 
> toggle=1, address=17, instr=2c
> Mar 21 16:23:13 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:13 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:13 gentoo ir-common: key released
> Mar 21 16:23:13 gentoo ir-common: code=2100, rc5=8a2a4a1, start=2, 
> toggle=0, address=4, instr=0
> Mar 21 16:23:13 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:13 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:13 gentoo ir-common: code=2088, rc5=89298a1, start=2, 
> toggle=0, address=2, instr=8
> Mar 21 16:23:13 gentoo ir-common: ir_rc5_decode(250d451) bad code
> Mar 21 16:23:13 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:14 gentoo ir-common: ir_rc5_decode(4315449) bad code
> Mar 21 16:23:14 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:14 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:14 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:14 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:14 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:14 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:14 gentoo ir-common: key released
> Mar 21 16:23:14 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:14 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:23:14 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:14 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:14 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:14 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:14 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:14 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:14 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:14 gentoo ir-common: key released
> Mar 21 16:23:14 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:14 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:15 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:15 gentoo ir-common: key released
> Mar 21 16:23:15 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:15 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:15 gentoo ir-common: key released
> Mar 21 16:23:15 gentoo ir-common: ir_rc5_decode(450d429) bad code
> Mar 21 16:23:15 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:15 gentoo ir-common: ir_rc5_decode(4314c45) bad code
> Mar 21 16:23:15 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:15 gentoo ir-common: ir_rc5_decode(4314c45) bad code
> Mar 21 16:23:15 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:15 gentoo ir-common: code=25ec, rc5=2515449, start=2, 
> toggle=0, address=17, instr=2c
> Mar 21 16:23:15 gentoo ir-common: instruction 2c, toggle 0
> Mar 21 16:23:15 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:15 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:15 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:15 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:15 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:15 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:16 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:16 gentoo ir-common: code=2808, rc5=892a891, start=2, 
> toggle=1, address=0, instr=8
> Mar 21 16:23:16 gentoo ir-common: key released
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:16 gentoo ir-common: code=25ec, rc5=2515449, start=2, 
> toggle=0, address=17, instr=2c
> Mar 21 16:23:16 gentoo ir-common: instruction 2c, toggle 0
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:16 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:16 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:16 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:16 gentoo ir-common: key released
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:16 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:23:16 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:16 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:16 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:16 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:17 gentoo ir-common: code=2dec, rc5=2515451, start=2, 
> toggle=1, address=17, instr=2c
> Mar 21 16:23:17 gentoo ir-common: instruction 2c, toggle 1
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:17 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:17 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:17 gentoo ir-common: key released
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:17 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:17 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:17 gentoo ir-common: key released
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:17 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:17 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:17 gentoo ir-common: key released
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:17 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:17 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:17 gentoo ir-common: key released
> Mar 21 16:23:17 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:18 gentoo ir-common: code=288c, rc5=8529891, start=2, 
> toggle=1, address=2, instr=c
> Mar 21 16:23:18 gentoo ir-common: code=2dad, rc5=4519451, start=2, 
> toggle=1, address=16, instr=2d
> Mar 21 16:23:18 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:18 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:18 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:18 gentoo ir-common: ir_rc5_decode(4513451) bad code
> Mar 21 16:23:18 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:18 gentoo ir-common: ir_rc5_decode(4312c45) bad code
> Mar 21 16:23:18 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:18 gentoo ir-common: code=218d, rc5=4529489, start=2, 
> toggle=0, address=6, instr=d
> Mar 21 16:23:18 gentoo ir-common: ir_rc5_decode(4513445) bad code
> Mar 21 16:23:18 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:19 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:19 gentoo ir-common: code=25a9, rc5=4919449, start=2, 
> toggle=0, address=16, instr=29
> Mar 21 16:23:19 gentoo ir-common: code=21cc, rc5=8525489, start=2, 
> toggle=0, address=7, instr=c
> Mar 21 16:23:19 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:19 gentoo ir-common: code=29a9, rc5=4919491, start=2, 
> toggle=1, address=6, instr=29
> Mar 21 16:23:19 gentoo ir-common: code=2188, rc5=8929489, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:19 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:20 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:20 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:20 gentoo ir-common: ir_rc5_decode(4313445) bad code
> Mar 21 16:23:20 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:20 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:20 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:20 gentoo ir-common: code=21cc, rc5=8525489, start=2, 
> toggle=0, address=7, instr=c
> Mar 21 16:23:20 gentoo ir-common: ir_rc5_decode(4913429) bad code
> Mar 21 16:23:20 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:21 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:21 gentoo ir-common: code=2dad, rc5=4519451, start=2, 
> toggle=1, address=16, instr=2d
> Mar 21 16:23:21 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:21 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:21 gentoo ir-common: ir_rc5_decode(4313449) bad code
> Mar 21 16:23:21 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:21 gentoo ir-common: code=218c, rc5=85294a1, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:21 gentoo ir-common: ir_rc5_decode(4913451) bad code
> Mar 21 16:23:21 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:22 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:22 gentoo ir-common: code=29ad, rc5=4519491, start=2, 
> toggle=1, address=6, instr=2d
> Mar 21 16:23:22 gentoo ir-common: code=21cc, rc5=8525489, start=2, 
> toggle=0, address=7, instr=c
> Mar 21 16:23:22 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:23:22 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:22 gentoo ir-common: code=25cc, rc5=8525449, start=2, 
> toggle=0, address=17, instr=c
> Mar 21 16:23:22 gentoo ir-common: instruction c, toggle 0
> Mar 21 16:23:22 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x0c raw=0x0c down=1
> Mar 21 16:23:22 gentoo ir-common: code=25a9, rc5=4919449, start=2, 
> toggle=0, address=16, instr=29
> Mar 21 16:23:22 gentoo ir-common: key released
> Mar 21 16:23:22 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x0c raw=0x0c down=0
> Mar 21 16:23:22 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:22 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:22 gentoo ir-common: code=2188, rc5=8929489, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:22 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:23 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:23:23 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:23 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:23 gentoo ir-common: code=25a9, rc5=4919449, start=2, 
> toggle=0, address=16, instr=29
> Mar 21 16:23:23 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:23 gentoo ir-common: ir_rc5_decode(4313429) bad code
> Mar 21 16:23:23 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:23 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:23 gentoo ir-common: ir_rc5_decode(4913451) bad code
> Mar 21 16:23:23 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:23 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:24 gentoo ir-common: code=21ad, rc5=45194a1, start=2, 
> toggle=0, address=6, instr=2d
> Mar 21 16:23:24 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:24 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:24 gentoo ir-common: code=2da9, rc5=4919451, start=2, 
> toggle=1, address=16, instr=29
> Mar 21 16:23:24 gentoo ir-common: code=298d, rc5=4529491, start=2, 
> toggle=1, address=6, instr=d
> Mar 21 16:23:24 gentoo ir-common: code=218d, rc5=4529489, start=2, 
> toggle=0, address=6, instr=d
> Mar 21 16:23:25 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:25 gentoo ir-common: ir_rc5_decode(430b425) bad code
> Mar 21 16:23:25 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:25 gentoo ir-common: code=288c, rc5=8529891, start=2, 
> toggle=1, address=2, instr=c
> Mar 21 16:23:25 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:25 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:25 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:25 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:25 gentoo ir-common: code=20c8, rc5=8925889, start=2, 
> toggle=0, address=3, instr=8
> Mar 21 16:23:26 gentoo ir-common: code=2529, rc5=491a461, start=2, 
> toggle=0, address=14, instr=29
> Mar 21 16:23:26 gentoo ir-common: code=2d29, rc5=491a451, start=2, 
> toggle=1, address=14, instr=29
> Mar 21 16:23:26 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:26 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:26 gentoo ir-common: code=2529, rc5=491a449, start=2, 
> toggle=0, address=14, instr=29
> Mar 21 16:23:26 gentoo ir-common: code=29cc, rc5=8525491, start=2, 
> toggle=1, address=7, instr=c
> Mar 21 16:23:27 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:27 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:27 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:27 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:27 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:27 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:28 gentoo ir-common: code=210c, rc5=852a489, start=2, 
> toggle=0, address=4, instr=c
> Mar 21 16:23:28 gentoo ir-common: code=210c, rc5=852a4a1, start=2, 
> toggle=0, address=4, instr=c
> Mar 21 16:23:28 gentoo ir-common: ir_rc5_decode(4313429) bad code
> Mar 21 16:23:28 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:28 gentoo ir-common: code=2188, rc5=89294a1, start=2, 
> toggle=0, address=6, instr=8
> Mar 21 16:23:28 gentoo ir-common: code=208c, rc5=8529889, start=2, 
> toggle=0, address=2, instr=c
> Mar 21 16:23:29 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:29 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:29 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:29 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:29 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:29 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:29 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:29 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:29 gentoo ir-common: ir_rc5_decode(250b429) bad code
> Mar 21 16:23:29 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:29 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:29 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(4312c45) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:30 gentoo ir-common: code=2909, rc5=492a491, start=2, 
> toggle=1, address=4, instr=9
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(4513429) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:30 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:30 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(250d249) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:30 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:30 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:31 gentoo ir-common: code=2988, rc5=8929491, start=2, 
> toggle=1, address=6, instr=8
> Mar 21 16:23:31 gentoo ir-common: code=2884, rc5=8629891, start=2, 
> toggle=1, address=2, instr=4
> Mar 21 16:23:31 gentoo ir-common: ir_rc5_decode(250b429) bad code
> Mar 21 16:23:31 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:31 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:31 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:31 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:31 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:31 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:32 gentoo ir-common: code=2cec, rc5=2515251, start=2, 
> toggle=1, address=13, instr=2c
> Mar 21 16:23:32 gentoo ir-common: ir_rc5_decode(430b429) bad code
> Mar 21 16:23:32 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:32 gentoo ir-common: code=2dc4, rc5=84a5451, start=2, 
> toggle=1, address=17, instr=4
> Mar 21 16:23:32 gentoo ir-common: instruction 4, toggle 1
> Mar 21 16:23:32 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x04 raw=0x04 down=1
> Mar 21 16:23:32 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:32 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:32 gentoo ir-common: key released
> Mar 21 16:23:32 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x04 raw=0x04 down=0
> Mar 21 16:23:32 gentoo ir-common: ir_rc5_decode(250d431) bad code
> Mar 21 16:23:32 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:33 gentoo ir-common: code=2884, rc5=8629891, start=2, 
> toggle=1, address=2, instr=4
> Mar 21 16:23:33 gentoo ir-common: ir_rc5_decode(450b449) bad code
> Mar 21 16:23:33 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:33 gentoo ir-common: code=2108, rc5=892a4a1, start=2, 
> toggle=0, address=4, instr=8
> Mar 21 16:23:33 gentoo ir-common: code=25ec, rc5=2515449, start=2, 
> toggle=0, address=17, instr=2c
> Mar 21 16:23:33 gentoo ir-common: instruction 2c, toggle 0
> Mar 21 16:23:33 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:33 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:33 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:33 gentoo ir-common: key released
> Mar 21 16:23:33 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:33 gentoo ir-common: code=24ed, rc5=4515249, start=2, 
> toggle=0, address=13, instr=2d
> Mar 21 16:23:33 gentoo ir-common: ir_rc5_decode(450b429) bad code
> Mar 21 16:23:33 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:34 gentoo ir-common: ir_rc5_decode(250d451) bad code
> Mar 21 16:23:34 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:34 gentoo ir-common: ir_rc5_decode(4314c45) bad code
> Mar 21 16:23:34 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:34 gentoo ir-common: code=25ec, rc5=2515449, start=2, 
> toggle=0, address=17, instr=2c
> Mar 21 16:23:34 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:34 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:34 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:34 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:34 gentoo ir-common: key released
> Mar 21 16:23:34 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:34 gentoo ir-common: code=2908, rc5=892a491, start=2, 
> toggle=1, address=4, instr=8
> Mar 21 16:23:34 gentoo ir-common: ir_rc5_decode(4513429) bad code
> Mar 21 16:23:34 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:34 gentoo ir-common: code=2900, rc5=8a2a491, start=2, 
> toggle=1, address=4, instr=0
> Mar 21 16:23:35 gentoo ir-common: ir_rc5_decode(250d429) bad code
> Mar 21 16:23:35 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:35 gentoo ir-common: code=2084, rc5=8629889, start=2, 
> toggle=0, address=2, instr=4
> Mar 21 16:23:35 gentoo ir-common: ir_rc5_decode(4513429) bad code
> Mar 21 16:23:35 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:35 gentoo ir-common: code=2ced, rc5=4515251, start=2, 
> toggle=1, address=13, instr=2d
> Mar 21 16:23:35 gentoo ir-common: ir_rc5_decode(450b451) bad code
> Mar 21 16:23:35 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:35 gentoo ir-common: code=208c, rc5=8529889, start=2, 
> toggle=0, address=2, instr=c
> Mar 21 16:23:35 gentoo ir-common: ir_rc5_decode(450d429) bad code
> Mar 21 16:23:35 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:36 gentoo ir-common: ir_rc5_decode(4314c45) bad code
> Mar 21 16:23:36 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:36 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:36 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:36 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:36 gentoo ir-common: key released
> Mar 21 16:23:36 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:36 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:36 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:36 gentoo ir-common: key released
> Mar 21 16:23:36 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:36 gentoo ir-common: ir_rc5_decode(4313445) bad code
> Mar 21 16:23:36 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:36 gentoo ir-common: code=2dec, rc5=2515451, start=2, 
> toggle=1, address=17, instr=2c
> Mar 21 16:23:36 gentoo ir-common: instruction 2c, toggle 1
> Mar 21 16:23:36 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:37 gentoo ir-common: ir_rc5_decode(4514c51) bad code
> Mar 21 16:23:37 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:37 gentoo ir-common: key released
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:37 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:37 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:37 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:37 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:37 gentoo ir-common: key released
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:37 gentoo ir-common: code=2ce0, rc5=8895251, start=2, 
> toggle=1, address=13, instr=20
> Mar 21 16:23:37 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:37 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:37 gentoo ir-common: code=2088, rc5=89298a1, start=2, 
> toggle=0, address=2, instr=8
> Mar 21 16:23:37 gentoo ir-common: code=2dec, rc5=2515451, start=2, 
> toggle=1, address=17, instr=2c
> Mar 21 16:23:37 gentoo ir-common: instruction 2c, toggle 1
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:37 gentoo ir-common: ir_rc5_decode(4315449) bad code
> Mar 21 16:23:37 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:37 gentoo ir-common: key released
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:37 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:37 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:37 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:38 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:38 gentoo ir-common: code=2108, rc5=892a4a1, start=2, 
> toggle=0, address=4, instr=8
> Mar 21 16:23:38 gentoo ir-common: key released
> Mar 21 16:23:38 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:38 gentoo ir-common: ir_rc5_decode(450d431) bad code
> Mar 21 16:23:38 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:38 gentoo ir-common: ir_rc5_decode(4514c51) bad code
> Mar 21 16:23:38 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:38 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:38 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:38 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:38 gentoo ir-common: key released
> Mar 21 16:23:38 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:38 gentoo ir-common: key released
> Mar 21 16:23:38 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:38 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:38 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:38 gentoo ir-common: key released
> Mar 21 16:23:38 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:39 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:39 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:39 gentoo ir-common: key released
> Mar 21 16:23:39 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:39 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:39 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:39 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: code=2808, rc5=892a891, start=2, 
> toggle=1, address=0, instr=8
> Mar 21 16:23:39 gentoo ir-common: key released
> Mar 21 16:23:39 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:39 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:39 gentoo ir-common: ir_rc5_decode(4315445) bad code
> Mar 21 16:23:39 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:40 gentoo ir-common: key released
> Mar 21 16:23:40 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:40 gentoo ir-common: instruction 2d, toggle 1
> Mar 21 16:23:40 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:40 gentoo ir-common: code=2ded, rc5=4515451, start=2, 
> toggle=1, address=17, instr=2d
> Mar 21 16:23:40 gentoo ir-common: key released
> Mar 21 16:23:40 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:40 gentoo ir-common: ir_rc5_decode(4514c51) bad code
> Mar 21 16:23:40 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:40 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:40 gentoo ir-common: instruction 2d, toggle 0
> Mar 21 16:23:40 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=1
> Mar 21 16:23:40 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:40 gentoo ir-common: code=25ed, rc5=4515449, start=2, 
> toggle=0, address=17, instr=2d
> Mar 21 16:23:40 gentoo ir-common: code=25ec, rc5=2515449, start=2, 
> toggle=0, address=17, instr=2c
> Mar 21 16:23:40 gentoo ir-common: instruction 2c, toggle 0
> Mar 21 16:23:40 gentoo saa7134 IR (ASUSTeK P7131 Hybri: key event code=3 
> down=0
> Mar 21 16:23:40 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=1
> Mar 21 16:23:41 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:41 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:41 gentoo ir-common: key released
> Mar 21 16:23:41 gentoo saa7134 IR (ASUSTeK P7131 Hybri: unknown key: 
> key=0x2c raw=0x2c down=0
> Mar 21 16:23:41 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:41 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:41 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:41 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:41 gentoo ir-common: code=218d, rc5=4529489, start=2, 
> toggle=0, address=6, instr=d
> Mar 21 16:23:41 gentoo ir-common: ir_rc5_decode(4312c45) bad code
> Mar 21 16:23:41 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:42 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:42 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:42 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:42 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:42 gentoo ir-common: ir_rc5_decode(4312c49) bad code
> Mar 21 16:23:42 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:42 gentoo ir-common: code=2989, rc5=4929491, start=2, 
> toggle=1, address=6, instr=9
> Mar 21 16:23:42 gentoo ir-common: ir_rc5_decode(4513449) bad code
> Mar 21 16:23:42 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:42 gentoo ir-common: code=29cc, rc5=8525491, start=2, 
> toggle=1, address=7, instr=c
> Mar 21 16:23:42 gentoo ir-common: code=2dad, rc5=4519451, start=2, 
> toggle=1, address=16, instr=2d
> Mar 21 16:23:42 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:43 gentoo ir-common: code=29ad, rc5=4519491, start=2, 
> toggle=1, address=6, instr=2d
> Mar 21 16:23:43 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:43 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:43 gentoo ir-common: code=2988, rc5=8929491, start=2, 
> toggle=1, address=6, instr=8
> Mar 21 16:23:43 gentoo ir-common: ir_rc5_decode(4913429) bad code
> Mar 21 16:23:43 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:43 gentoo ir-common: code=298c, rc5=8529491, start=2, 
> toggle=1, address=6, instr=c
> Mar 21 16:23:43 gentoo ir-common: code=2dad, rc5=4519451, start=2, 
> toggle=1, address=16, instr=2d
> Mar 21 16:23:43 gentoo ir-common: code=2888, rc5=8929891, start=2, 
> toggle=1, address=2, instr=8
> Mar 21 16:23:43 gentoo ir-common: code=29ad, rc5=4519491, start=2, 
> toggle=1, address=6, instr=2d
> Mar 21 16:23:43 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:43 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:44 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:44 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:44 gentoo ir-common: code=25ad, rc5=4519449, start=2, 
> toggle=0, address=16, instr=2d
> Mar 21 16:23:44 gentoo ir-common: ir_rc5_decode(4312c25) bad code
> Mar 21 16:23:44 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:44 gentoo ir-common: code=218c, rc5=8529489, start=2, 
> toggle=0, address=6, instr=c
> Mar 21 16:23:44 gentoo ir-common: ir_rc5_decode(4913449) bad code
> Mar 21 16:23:44 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:44 gentoo ir-common: code=21cc, rc5=8525489, start=2, 
> toggle=0, address=7, instr=c
> Mar 21 16:23:45 gentoo ir-common: ir_rc5_decode(4312c29) bad code
> Mar 21 16:23:45 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:45 gentoo ir-common: code=298d, rc5=4529491, start=2, 
> toggle=1, address=6, instr=d
> Mar 21 16:23:45 gentoo ir-common: ir_rc5_decode(4313429) bad code
> Mar 21 16:23:45 gentoo ir-common: rc5 start bits invalid: 0
> Mar 21 16:23:45 gentoo ir-common: code=2d8c, rc5=8529451, start=2, 
> toggle=1, address=16, instr=c
> Mar 21 16:23:45 gentoo ir-common: ir_rc5_decode(4913451) bad code
> Mar 21 16:23:45 gentoo ir-common: rc5 start bits invalid: 0
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
