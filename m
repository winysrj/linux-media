Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaKBMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 00/14] Reduce cx231xx verbosity and do some cleanups
Date: Sun,  2 Nov 2014 10:32:23 -0200
Message-Id: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx231xx driver is too verbose. Several debug messages
are sent to dmesg. Do some cleanup and fix i2c_scan.

After this patch, it will now produce:

[  608.359255] usb 1-2: New device Conexant Corporation Polaris AV Capturb @ 480 Mbps (1554:5010) with 7 interfaces
[  608.360009] usb 1-2: Identified as Pixelview PlayTV USB Hybrid (card=10)
[  608.363129] i2c i2c-8: Added multiplexed i2c bus 10
[  608.363201] i2c i2c-8: Added multiplexed i2c bus 11
[  610.968904] cx25840 7-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[  611.041317] Chip ID is not zero. It is not a TEA5767
[  611.041351] tuner 9-0060: Tuner -1 found with type(s) Radio TV.
[  611.041429] tda18271 9-0060: creating new instance
[  611.044096] TDA18271HD/C2 detected @ 9-0060
[  611.239460] tda18271: performing RF tracking filter calibration
[  612.800569] tda18271: RF tracking filter calibration complete
[  612.835365] usb 1-2: v4l2 driver version 0.0.3
[  613.055006] usb 1-2: Registered video device video0 [v4l2]
[  613.055461] usb 1-2: Registered VBI device vbi0
[  613.110279] Registered IR keymap rc-pixelview-002t
[  613.110574] input: i2c IR (Pixelview PlayTV USB Hy as /devices/virtual/rc/rc0/input12
[  613.111398] rc0: i2c IR (Pixelview PlayTV USB Hy as /devices/virtual/rc/rc0
[  613.111409] ir-kbd-i2c: i2c IR (Pixelview PlayTV USB Hy detected at i2c-9/9-0030/ir0 [cx231xx #0-2]
[  613.111444] usb 1-2: video EndPoint Addr 0x84, Alternate settings: 5
[  613.111454] usb 1-2: VBI EndPoint Addr 0x85, Alternate settings: 2
[  613.111465] usb 1-2: sliced CC EndPoint Addr 0x86, Alternate settings: 2
[  613.111474] usb 1-2: TS EndPoint Addr 0x81, Alternate settings: 6
[  613.111654] usbcore: registered new interface driver cx231xx
[  613.136510] usb 1-2: audio EndPoint Addr 0x83, Alternate settings: 3
[  613.136521] usb 1-2: Cx231xx Audio Extension initialized
[  613.199085] usb 1-2: dvb_init: looking for demod on i2c bus: 9
[  613.232349] i2c i2c-11: Detected a Fujitsu mb86a20s frontend
[  613.232385] tda18271 9-0060: attaching existing instance
[  613.232392] DVB: registering new adapter (cx231xx #0)
[  613.232402] usb 1-2: DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
[  613.234528] usb 1-2: Successfully loaded cx231xx-dvb
[  613.234618] usb 1-2: Cx231xx dvb Extension initialized

Still verbose, but at least it doesn't produce extra logs during normal
work.

I2C scan is now fixed and not too verbose:

[  608.371656] usb 1-2: i2c scan: found device @ port 0 addr 0x40  [???]
[  608.374750] usb 1-2: i2c scan: found device @ port 0 addr 0x60  [colibri]
[  608.378433] usb 1-2: i2c scan: found device @ port 0 addr 0x88  [hammerhead]
[  608.380226] usb 1-2: i2c scan: found device @ port 0 addr 0x98  [???]
[  608.405747] usb 1-2: i2c scan: found device @ port 3 addr 0xa0  [eeprom]
[  608.422310] usb 1-2: i2c scan: found device @ port 2 addr 0x60  [colibri]
[  608.430229] usb 1-2: i2c scan: found device @ port 2 addr 0xc0  [tuner]
[  608.438793] usb 1-2: i2c scan: found device @ port 4 addr 0x20  [demod]
[  608.560247] cx25840 7-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)

Tested with a Pixelview PlayTV USB Hybrid SBTVD.

-

v2:
 - The i2c scan fix patch got replaced by the one sent by Matthias;
 - Converted to dev_foo() instead of pr_foo();
 - Some minor CodingStyle cleanups;
 - Be a little less verbose on i2c_scan;
 - Bumped version string.

Matthias Schwarzott (1):
  [media] cx231xx: use 1 byte read for i2c scan

Mauro Carvalho Chehab (13):
  [media] cx231xx: get rid of driver-defined printk macros
  [media] cx231xx: Fix identation
  [media] cx231xx: Cleanup printk at the driver
  [media] cx25840: Don't report an error if max size is adjusted
  [media] cx25840: convert max_buf_size var to lowercase
  [media] cx231xx: disable I2C errors during i2c_scan
  [media] cx231xx: convert from pr_foo to dev_foo
  [media] cx231xx: get rid of audio debug parameter
  [media] cx231xx: use dev_foo instead of printk
  [media] cx231xx: add addr for demod and make i2c_devs const
  [media] cx231xx: use dev_info() for extension load/unload
  [media] cx231xx: too much changes. Bump version number
  [media] cx231xx: simplify I2C scan debug messages

 drivers/media/i2c/cx25840/cx25840-firmware.c |  11 +-
 drivers/media/usb/cx231xx/cx231xx-417.c      |  53 +++--
 drivers/media/usb/cx231xx/cx231xx-audio.c    |  93 +++++----
 drivers/media/usb/cx231xx/cx231xx-avcore.c   | 292 +++++++++++++++------------
 drivers/media/usb/cx231xx/cx231xx-cards.c    | 158 ++++++++-------
 drivers/media/usb/cx231xx/cx231xx-core.c     | 150 +++++++-------
 drivers/media/usb/cx231xx/cx231xx-dvb.c      | 114 ++++++-----
 drivers/media/usb/cx231xx/cx231xx-i2c.c      |  37 ++--
 drivers/media/usb/cx231xx/cx231xx-input.c    |   1 -
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c  |  47 +++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c      |  48 +++--
 drivers/media/usb/cx231xx/cx231xx-video.c    |  85 ++++----
 drivers/media/usb/cx231xx/cx231xx.h          |  21 +-
 13 files changed, 583 insertions(+), 527 deletions(-)

-- 
1.9.3

