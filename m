Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53041 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaK1JTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 04:19:07 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v8 00/14] LED / flash API integration
Date: Fri, 28 Nov 2014 10:17:52 +0100
Message-id: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is a follow-up of the LED / flash API integration
series [1].

========================
Changes since version 7:
========================

- removed explicit support for indicator leds from
  LED Flash class - indicator leds will be registered
  as a separate LED Flash class devices
- added flash_sync_strobe sysfs attribute and related
  V4L2_CID_FLASH_SYNC_STROBE control
- changed the way of matching V4L2 Flash sub-devices
  in a media device, which entailed modification in
  v4l2-async driver
- modified max77693 DT bindings documentation
- applied various fixes an cleanups

========================
Changes since version 6:
========================

- removed addition of public LED subsystem API for setting
  torch brightness in favour of internal API for
  synchronous and asynchronous led brightness level setting
- fixed possible race condition upon creating LED Flash class
  related sysfs attributes

========================
Changes since version 5:
========================

- removed flash manager framework - its implementation needs
  further thorough discussion.
- removed external strobe facilities from the LED Flash Class
  and provided external_strobe_set op in v4l2-flash. LED subsystem
  should be strobe provider agnostic.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (14):
  leds: Add LED Flash class extension to the LED subsystem
  Documentation: leds: Add description of LED Flash class extension
  Documentation: leds: Add description of v4l2-flash sub-device
  v4l2-async: change custom.match callback argument type
  v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE control
  media: Add registration helpers for V4L2 flash sub-devices
  exynos4-is: Add support for v4l2-flash subdevs
  DT: Add documentation for exynos4-is 'flashes' property
  mfd: max77693: adjust max77693_led_platform_data
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693
  leds: Add driver for AAT1290 current regulator
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290

 Documentation/DocBook/media/v4l/controls.xml       |    9 +
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   74 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   61 ++
 drivers/leds/Kconfig                               |   27 +
 drivers/leds/Makefile                              |    3 +
 drivers/leds/led-class-flash.c                     |  446 ++++++++
 drivers/leds/led-class.c                           |    4 +
 drivers/leds/leds-aat1290.c                        |  472 ++++++++
 drivers/leds/leds-max77693.c                       | 1152 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.c      |   65 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-async.c               |   16 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  516 +++++++++
 include/linux/led-class-flash.h                    |  198 ++++
 include/linux/leds.h                               |    3 +
 include/linux/mfd/max77693.h                       |    3 +-
 include/media/v4l2-async.h                         |    2 +-
 include/media/v4l2-flash.h                         |  138 +++
 include/uapi/linux/v4l2-controls.h                 |    1 +
 25 files changed, 3230 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/leds/leds-class-flash.txt
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/linux/led-class-flash.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

