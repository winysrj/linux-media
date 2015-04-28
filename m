Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50868 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbD1HUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 03:20:49 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v6 00/10] LED / flash API integration
Date: Tue, 28 Apr 2015 09:18:40 +0200
Message-id: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a sixth non-RFC version of LED / flash API integration
series [1]. It is based on linux_next-20150427.

================
Changes since v5
================
- renamed v4l2-flash module to v4l2-flash-led-class and applied
  other related modifications spotted by Sakari
- fixed not released of_node reference in max77693-led driver

================
Changes since v4
================
- adapted leds-max77693 and leds-aat1290 drivers to the recent
  modifications in leds/common.txt bindings documentation and
  changed the behaviour when properties are missing
- modified DT bindings documenation for the aforementioned
  drivers
- removed unjustified use of goto in the leds-aat1290 driver
- fixed lack of of_node_put in leds-aat1290 driver, after parsing
  DT child node 
- removed patch adding 'skyworks' vendor prefix, as the entry
  has been recently added

================
Changes since v2
================
- improved leds/common DT bindings documentation
- improved max77693-led DT documentation
- fixed validation of DT confguration for leds-max77693 by
  minimal values in joint iouts case
- removed trigger-type property from leds-max77693 bindings
  and adjusted the driver accordingly
- improved LED Flash class documentation related to v4l2-flash sub-device
  initialization
- excluded from leds-aat1290 DT bindings documentation the part
  related to handling external strobe sources

================
Changes since v1
================

- excluded exynos4-is media device related patches, as there is
  consenus required related to flash devices handling in media device
  DT bindings
- modifications around LED Flash class settings and v4l2 flash config
  initialization in LED Flash class drivers and v4l2-flash wrapper
- switched to using DT node name as a device name for leds-max77693
  and leds-aat1290 drivers, in case DT 'label' property is absent
- dropped OF dependecy for v4l2-flash wrapper
- moved LED_FAULTS definitions from led-class-flash.h to uapi/linux/leds.h
- allowed for multiple clients of v4l2-flash sub-device

======================
Changes since RFC v13:
======================

- reduced number of patches - some of them have been merged
- slightly modified max77693-led device naming
- fixed issues in v4l2-flash helpers detected with yavta
- cleaned up AAT1290 device tree documentation
- added GPIOLIB dependecy to AAT1290 related entry in Kconfig

Thanks,
Jacek Anaszewski

[1] http://www.spinics.net/lists/kernel/msg1944538.html

Jacek Anaszewski (10):
  leds: unify the location of led-trigger API
  DT: Add documentation for the mfd Maxim max77693
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the Skyworks AAT1290
  leds: Add driver for AAT1290 flash LED controller
  media: Add registration helpers for V4L2 flash sub-devices
  Documentation: leds: Add description of v4l2-flash sub-device
  leds: max77693: add support for V4L2 Flash sub-device
  DT: aat1290: Document handling external strobe sources
  leds: aat1290: add support for V4L2 Flash sub-device

 .../devicetree/bindings/leds/leds-aat1290.txt      |   73 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |   67 ++
 Documentation/leds/leds-class-flash.txt            |   47 +
 drivers/leds/Kconfig                               |   19 +
 drivers/leds/Makefile                              |    2 +
 drivers/leds/leds-aat1290.c                        |  577 ++++++++++
 drivers/leds/leds-max77693.c                       | 1104 ++++++++++++++++++++
 drivers/leds/leds.h                                |   24 -
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |  626 +++++++++++
 include/linux/leds.h                               |   25 +
 include/media/v4l2-flash-led-class.h               |  145 +++
 13 files changed, 2698 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash-led-class.c
 create mode 100644 include/media/v4l2-flash-led-class.h

-- 
1.7.9.5

