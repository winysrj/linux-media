Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43641 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZIJVwE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 17:52:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MlrYk-000449-7e
	for linux-media@vger.kernel.org; Thu, 10 Sep 2009 23:52:06 +0200
Received: from host-78-14-92-108.cust-adsl.tiscali.it ([78.14.92.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 23:52:06 +0200
Received: from avljawrowski by host-78-14-92-108.cust-adsl.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 23:52:06 +0200
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Thu, 10 Sep 2009 21:51:43 +0000 (UTC)
Message-ID: <loom.20090910T234610-403@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>  <1248033581.3667.40.camel@pc07.localdom.local>  <loom.20090720T224156-477@post.gmane.org>  <1248146456.3239.6.camel@pc07.localdom.local>  <loom.20090722T123703-889@post.gmane.org> <1248338430.3206.34.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton <hermann-pitton <at> arcor.de> writes:

> If it seems to deliver stable results now, you can even try to re-flash
> it with rewrite_eeprom.pl in v4l2-apps/util. Read the instructions on
> top of it. 

With 2.6.30 it's stable. I've reflashed the eeprom and now the card is
autodetected:

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7133[0]: found at 0000:01:02.0, rev: 209, irq: 22, latency: 32, mmio: 
0xcfddf800
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i 
[card=101,autodetected]
saa7133[0]: board init: gpio is 600e000
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
i2c-adapter i2c-0: Invalid 7-bit address 0x7a
tuner 0-004b: chip found @ 0x96 (saa7133[0])
tda829x 0-004b: setting tuner address to 61
tda829x 0-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

However it works still only with Kaffeine and w_scan.
dvbscan (last mercurial) give:

Unable to query frontend status

And with 2.6.31 (same configuration) appears this new error:

i2c-adapter i2c-0: Invalid 7-bit address 0x7a

It can be a problem?

> Cheers,
> Hermann

Thank you!

