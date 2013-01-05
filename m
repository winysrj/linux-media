Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40540 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3AEN7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 08:59:53 -0500
Received: by mail-ee0-f44.google.com with SMTP id b47so8406049eek.17
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 05:59:52 -0800 (PST)
Message-ID: <50E831F2.70400@googlemail.com>
Date: Sat, 05 Jan 2013 15:00:18 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: BUG: bttv does not load module ir-kbd-i2c for Hauppauge model 37284,
 rev B421
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we are at it ;) :

[   15.280772] bttv: Bt8xx card found (0)
[   15.281349] bttv: 0: Bt878 (rev 17) at 0000:01:08.0, irq: 18,
latency: 32, mmio: 0xfdfff000
[   15.281386] bttv: 0: detected: Hauppauge WinTV [card=10], PCI
subsystem ID is 0070:13eb
[   15.281391] bttv: 0: using: Hauppauge (bt878) [card=10,insmod option]
[   15.283964] bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   15.316043] tveeprom 4-0050: Hauppauge model 37284, rev B421, serial#
5111944
[   15.316049] tveeprom 4-0050: tuner model is Philips FM1216 (idx 21,
type 5)
[   15.316054] tveeprom 4-0050: TV standards PAL(B/G) (eeprom 0x04)
[   15.316059] tveeprom 4-0050: audio processor is MSP3410D (idx 5)
[   15.316063] tveeprom 4-0050: has radio
[   15.316066] bttv: 0: Hauppauge eeprom indicates model#37284
[   15.316071] bttv: 0: tuner type=5
[   16.178816] bttv: 0: registered device video0
[   16.179071] bttv: 0: registered device vbi0
[   16.180587] bttv: 0: registered device radio0

When I load module ir-kbd-i2c manually:

Registered IR keymap rc-hauppauge
input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input6
rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-4/4-0018/ir0 [bt878 #0 [sw]]

Remote control works fine then.

Regards,
rank


