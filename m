Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36980 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0FZMJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 08:09:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OSUC1-0004Kt-Ke
	for linux-media@vger.kernel.org; Sat, 26 Jun 2010 14:09:05 +0200
Received: from dynamic-adsl-78-14-99-30.clienti.tiscali.it ([78.14.99.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 14:09:05 +0200
Received: from avljawrowski by dynamic-adsl-78-14-99-30.clienti.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Jun 2010 14:09:05 +0200
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Sat, 26 Jun 2010 12:08:52 +0000 (UTC)
Message-ID: <loom.20100626T135340-672@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>  <1248033581.3667.40.camel@pc07.localdom.local>  <loom.20090720T224156-477@post.gmane.org>  <1248146456.3239.6.camel@pc07.localdom.local>  <loom.20090722T123703-889@post.gmane.org>  <1248338430.3206.34.camel@pc07.localdom.local>  <loom.20090910T234610-403@post.gmane.org>  <1252630820.3321.14.camel@pc07.localdom.local>  <loom.20090912T211959-273@post.gmane.org>  <1252815178.3259.39.camel@pc07.localdom.local>  <loom.20090913T115105-855@post.gmane.org>  <1252881736.4318.48.camel@pc07.localdom.local>  <loom.20090914T150511-456@post.gmane.org>  <1252968793.3250.23.camel@pc07.localdom.local>  <loom.20090915T215753-102@post.gmane.org>  <1253138846.3901.19.camel@pc07.localdom.local>  <loom.20100220T123935-59@post.gmane.org> <1267420877.3185.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
there are some news with 2.6.34 (or previous).
The IR is detected and the device seems to be created, but it doesn't work.

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:01:02.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
saa7133[0]: found at 0000:01:02.0, rev: 209, irq: 22, latency: 32, mmio: 
xcfddf800
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i
[card=101,autodetected]
saa7133[0]: board init: gpio is 600c000
IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2e 15 13 ff ff
saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e7 ff 21 00 c2
saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff 15 0e 6c a3 eb 03 c5 e8 9d
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
input: i2c IR (Pinnacle PCTV) as /class/input/input5
Creating IR device irrcv0
ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-0/0-0047/ir0 [saa7133[0]]
tuner 0-004b: chip found @ 0x96 (saa7133[0])
tda829x 0-004b: setting tuner address to 61
tda829x 0-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...

And loading it with i2c_debug=1 ir_debug=1 I get a lot of these:

[ 3757.243258] input: i2c IR (Pinnacle PCTV) as /class/input/input6
[ 3757.243314] Creating IR device irrcv0
[ 3757.243318] ir-kbd-i2c: i2c IR (Pinnacle PCTV)
detected at i2c-0/0-0047/ir0 [saa7133[0]]
[ 3757.243330] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3757.243470] i2c IR (Pinnacle PCTV)/ir: read error
[ 3757.243512] saa7133[0]: i2c xfer: < 10 3c 33 60 >
[ 3757.251420] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
[ 3757.251599] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
[ 3757.251777] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
[ 3757.251955] saa7133[0]: i2c xfer: < 96 >
[ 3757.256422] saa7133[0]: i2c xfer: < 96 00 >
[ 3757.262970] saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
[ 3757.269646] saa7133[0]: i2c xfer: < 96 1f >
[ 3757.276302] saa7133[0]: i2c xfer: < 97 =89 >
[ 3757.283045] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[ 3757.283135] saa7133[0]: i2c xfer: < 96 1f >
[ 3757.289700] saa7133[0]: i2c xfer: < 97 =89 >
[ 3757.296308] saa7133[0]: i2c xfer: < 96 2f >
[ 3757.302981] saa7133[0]: i2c xfer: < 97 =00 >
[ 3757.309643] saa7133[0]: i2c xfer: < 96 21 c0 >
[ 3757.339639] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[ 3757.339818] saa7133[0]: i2c xfer: < c3 =0a >
[ 3757.346302] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3793.576474] i2c IR (Pinnacle PCTV)/ir: read error
[ 3793.678145] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3793.678290] i2c IR (Pinnacle PCTV)/ir: read error
[ 3793.776341] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3793.776481] i2c IR (Pinnacle PCTV)/ir: read error
[ 3793.876338] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3793.876480] i2c IR (Pinnacle PCTV)/ir: read error
[ 3793.976343] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3793.976484] i2c IR (Pinnacle PCTV)/ir: read error
[ 3794.076337] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[ 3794.076478] i2c IR (Pinnacle PCTV)/ir: read error

It is an improvement or not?
Thanks,
Avl

