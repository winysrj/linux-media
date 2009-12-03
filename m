Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61154 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZLCIQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 03:16:13 -0500
Received: by bwz27 with SMTP id 27so870590bwz.21
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 00:16:18 -0800 (PST)
Date: Thu, 3 Dec 2009 17:19:54 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Subject: saa7134 and =?UTF-8?B?wrVQRDYxMTUx?= MPEG2 encoder
Message-ID: <20091203171954.2465b145@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

Our new TV card has MPEG-2 encoder NEC µPD61151. This encoder hasn't I2C bus, only SPI.
I wrote SPI bitbang master for saa7134.

[   74.482290] Linux video capture interface: v2.00
[   74.534047] saa7130/34: v4l2 driver version 0.2.15 loaded
[   74.534081] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   74.534086] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[   74.534092] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[   74.534101] saa7133[0]: board init: gpio is 200000
[   74.534108] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   74.684510] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[   74.684531] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684548] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684565] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684582] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684599] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684616] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684633] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684650] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684667] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684684] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684701] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684709] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684717] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684725] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[   74.684733] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[   74.684743] i2c-adapter i2c-7: Invalid 7-bit address 0x7a
[   74.712024] tuner 7-0061: chip found @ 0xc2 (saa7133[0])
[   74.819118] xc5000 7-0061: creating new instance
[   74.828015] xc5000: Successfully identified at address 0x61
[   74.828019] xc5000: Firmware has not been loaded previously
[  103.120811] input: i2c IR (BeholdTV) as /class/input/input5
[  103.120847] ir-kbd-i2c: i2c IR (BeholdTV) detected at i2c-7/7-002d/ir0 [saa7133[0]]
[  103.152055] saa7133[0]: found muPD61151 MPEG encoder
[  103.152216] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[  103.152322] saa7133[0]: registered device video0 [v4l2]
[  103.152340] saa7133[0]: registered device vbi0
[  103.152358] saa7133[0]: registered device radio0
[  103.168060] saa7133[0]: registered device video1 [mpeg]
[  103.196503] saa7134 ALSA driver for DMA sound loaded
[  103.196514] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  103.196531] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1
[  103.198892] xc5000: I2C write failed (len=4)
[  103.300018] xc5000: I2C write failed (len=4)
[  103.304799] xc5000: I2C read failed
[  103.304808] xc5000: I2C read failed
[  103.304810] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  103.304813] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[  103.347409] xc5000: firmware read 12401 bytes.
[  103.347413] xc5000: firmware uploading...
[  106.676008] xc5000: firmware upload complete...

Next point I think is write v4l2 workaround for SPI like I2C bus.

Functions:
v4l2_i2c_new_subdev -> v4l2_spi_new_subdev
v4l2_i2c_new_subdev_cfg -> v4l2_spi_new_subdev_cfg
v4l2_i2c_new_subdev_board -> v4l2_spi_new_subdev_board
v4l2_i2c_subdev_init -> v4l2_spi_subdev_init
i2c_set_clientdata -> spi_set_clientdata

Who can do it?? Or help me with it??

With my best regards, Dmitry.
